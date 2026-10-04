#!/usr/bin/env python3
"""long doubleのローカル検証。judgeへ通信・提出しない。"""
import argparse
import os
from pathlib import Path
import subprocess

ROOT = Path(__file__).resolve().parents[3]
LOCAL = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--nim', required=True)
    parser.add_argument('--build-dir', required=True)
    parser.add_argument('--skip-expander-tests', action='store_true')
    args = parser.parse_args()
    nim = str(Path(args.nim).resolve())
    build = Path(args.build_dir).resolve()
    build.mkdir(parents=True, exist_ok=True)
    log = (build / 'validation.log').open('w', encoding='utf-8')
    passed = []

    def run(command, *, cwd=ROOT, data=None, label=None):
        log.write('$ ' + ' '.join(map(str, command)) + '\n')
        log.flush()
        result = subprocess.run(list(map(str, command)), cwd=cwd, text=True,
                                input=data, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT)
        log.write(result.stdout)
        log.flush()
        if result.returncode:
            print(result.stdout, flush=True)
            raise RuntimeError(f'failed ({result.returncode}): {command}')
        if label:
            passed.append(label)
            print('PASS ' + label, flush=True)
        return result.stdout

    print(run([nim, '--version']).strip(), flush=True)
    for command in (['uname', '-sm'], ['gcc', '--version'], ['g++', '--version'],
                    ['ldd', '--version']):
        run(command)
    native_outputs = []
    for backend, compiler, standard in [('c', 'gcc', 'c11'), ('cpp', 'g++', 'c++14')]:
        reference = build / f'reference-{backend}.o'
        flags = ['-x', 'c' if backend == 'c' else 'c++', f'-std={standard}',
                 '-O2', '-frounding-math', '-Wall', '-Wextra', '-Werror']
        run([compiler, *flags, '-c', LOCAL / 'longdouble_reference.c', '-o', reference])
        oracle = build / f'native-{backend}'
        run([compiler, *flags, '-DCPLIB_LONGDOUBLE_REFERENCE_MAIN',
             LOCAL / 'longdouble_reference.c', '-lm', '-o', oracle])
        native_outputs.append(run([oracle], label=f'{backend}: independent native oracle'))
        for mode in ('debug', 'release'):
            def compile_run(source, name, *, data=None, reference_object=False):
                output = build / f'{backend}-{mode}-{name}'
                command = [nim, backend, '--hints:off', f'--path:{ROOT / "src"}',
                           f'--nimcache:{output}-cache', f'--out:{output}',
                           '--passC:-frounding-math']
                if mode == 'release':
                    command.append('-d:release')
                if reference_object:
                    command += [f'--passC:-I{LOCAL}', f'--passL:{reference}']
                run([*command, source])
                return run([output], data=data, label=f'{backend}/{mode}: {name}')
            compile_run(LOCAL / 'longdouble_contract.nim', 'contract', reference_object=True)
            verify = compile_run(ROOT / 'src/verify/AI/longdouble_test.nim', 'verify')
            assert verify == 'Hello World\n'
            io = compile_run(LOCAL / 'longdouble_io.nim', 'io',
                             data=' \t1.0000000000000000001\n18446744073709551615')
            assert io.splitlines()[0] == native_outputs[-1].splitlines()[1].split(' => ')[1]
            assert io.splitlines()[1] == '18446744073709551615'
            if backend == 'cpp':
                for name in ('float128', 'int128', 'lazy_leftist_heap_int128',
                             'fractions', 'fractions_pow_overflow', 'fractions_infinity_order'):
                    compile_run(ROOT / f'src/verify/AI/{name}_test.nim', name)
            else:
                # 既存float128/int128はimportcpp専用である。
                for name in ('float128', 'int128'):
                    output = build / f'unsupported-{name}-{mode}'
                    command = [nim, backend, '--hints:off', f'--path:{ROOT / "src"}',
                               f'--nimcache:{output}-cache', f'--out:{output}',
                               ROOT / f'src/verify/AI/{name}_test.nim']
                    result = subprocess.run(list(map(str, command)), cwd=ROOT, text=True,
                                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                    log.write(f'expected unsupported: {name}/c\n' + result.stdout)
                    assert result.returncode != 0, 'unexpected change to existing C support'
        # 入力モジュールの生成コードにlong doubleが実在し、型の偽装を使っていないことも保存する。
        generated = '\n'.join(source.read_text() for source in
                              (build / f'{backend}-debug-contract-cache').iterdir()
                              if source.suffix in ('.c', '.cpp'))
        assert all(fragment in generated for fragment in
                   ('long double', 'strtold(', 'sqrtl(', 'sizeof(long double)'))
    assert native_outputs[0] == native_outputs[1]
    passed.append('C/C++ native oracle outputs match')
    expander = build / 'expander'
    run([nim, 'cpp', '--hints:off', '-d:release',
         f'--nimcache:{build / "expander-cache"}', f'--out:{expander}',
         ROOT / 'tools/expander/expander.nim'])
    for index, options in enumerate(([], ['--single-line'], ['--compress'],
                                      ['--compress', '--original-source'])):
        expanded = build / f'expanded_{index}.nim'
        run([expander, '--quiet', *options, f'--lib:{ROOT}',
             f'--output-file:{expanded}', 'src/verify/AI/longdouble_test.nim'])
        for backend in ('c', 'cpp'):
            output = build / f'expanded-{index}-{backend}'
            run([nim, backend, '--hints:off', '-d:release',
                 f'--nimcache:{output}-cache', f'--out:{output}', expanded])
            assert run([output], label=f'{backend}: expander {options}') == 'Hello World\n'
    for index, options in enumerate(([], ['--single-line'])):
        directory = build / f'python-expand-{index}'
        directory.mkdir(exist_ok=True)
        run(['python3', ROOT / 'expander.py', *options, '--lib', ROOT,
             '--', ROOT / 'src/verify/AI/longdouble_test.nim'], cwd=directory)
        for backend in ('c', 'cpp'):
            output = directory / f'run-{backend}'
            run([nim, backend, '--hints:off', '-d:release',
                 f'--nimcache:{output}-cache', f'--out:{output}', directory / 'combined.nim'])
            assert run([output], label=f'{backend}: python expander {options}') == 'Hello World\n'
    if not args.skip_expander_tests:
        env = dict(os.environ, NIM=nim)
        result = subprocess.run(['python3', ROOT / 'tools/expander/test_expander.py'],
                                cwd=ROOT, env=env, text=True, stdout=subprocess.PIPE,
                                stderr=subprocess.STDOUT)
        log.write(result.stdout)
        log.flush()
        assert result.returncode == 0, result.stdout
        passed.append('existing expander tests (4 cases, all modes)')
        print('PASS ' + passed[-1], flush=True)
    (build / 'summary.txt').write_text('\n'.join(passed) + '\n', encoding='utf-8')
    print(f'{len(passed)} checks passed; log: {build / "validation.log"}', flush=True)


if __name__ == '__main__':
    main()
