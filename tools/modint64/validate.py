#!/usr/bin/env python3
"""modint64のローカル検証。judgeへの送信やネットワークアクセスは行わない。"""
import argparse
import itertools
import json
from pathlib import Path
import platform
import random
import statistics
import subprocess

ROOT = Path(__file__).resolve().parents[2]
PRIMES = [2, 3, 17, 998244353, 1000000007, 2305843009213693951,
          9223372036854775783, 9223372036854775837,
          18446744073709551533, 18446744073709551557]
MAX = (1 << 64) - 1


def run(command, log, cwd=ROOT, input_text=None, expect_failure=False):
    result = subprocess.run([str(x) for x in command], cwd=cwd, text=True,
                            input=input_text, stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE)
    log.write_text("COMMAND " + repr([str(x) for x in command]) + "\n" +
                   result.stdout + result.stderr, encoding="utf-8")
    if expect_failure:
        if result.returncode == 0 or "modint64の法" not in result.stderr:
            raise AssertionError(f"expected modulus rejection: {log}")
    elif result.returncode:
        raise AssertionError(f"failed: {log}\n{result.stderr[-3000:]}")
    return result.stdout


def corpus():
    rng = random.Random(0x64C0FFEE)
    rows, expected = [], []
    for p in PRIMES:
        edges = sorted({0, 1, 2, p // 2, p - 2, p - 1, p, p + 1,
                        (1 << 63) - 1, 1 << 63, MAX - 1, MAX})
        pairs = list(itertools.product(edges, repeat=2))
        pairs += [(rng.getrandbits(64), rng.getrandbits(64)) for _ in range(1500)]
        for index, (x, y) in enumerate(pairs):
            exponent = [0, 1, 2, 63, 64, MAX, rng.getrandbits(64)][index % 7]
            signed = [-(1 << 63), (1 << 63) - 1, -1, 0, 1,
                      rng.randrange(-(1 << 63), 1 << 63)][index % 6]
            decimal = str(rng.getrandbits([1, 64, 128, 1024][index % 4]))
            decimal = [decimal, "+000" + decimal, "-000" + decimal][index % 3]
            a, b = x % p, y % p
            inverse = "zero" if a == 0 else str(pow(a, -1, p))
            quotient = "zero" if b == 0 else str(a * pow(b, -1, p) % p)
            values = [a, b, (a + b) % p, (a - b) % p, a * b % p,
                      pow(a, exponent, p), inverse, quotient, signed % p,
                      int(decimal) % p, -a % p, (a + b) % p, (a - b) % p,
                      a * b % p, (a + signed) % p, (signed - a) % p,
                      signed * a % p]
            rows.append(f"{p} {x} {y} {exponent} {signed} {decimal}")
            expected.append(" ".join(map(str, values)))
    return "\n".join(rows) + "\n", expected


def verify_output(output, expected):
    lines = output.splitlines()
    if len(lines) != len(expected):
        raise AssertionError(f"line count {len(lines)} != {len(expected)}")
    for index, (actual, wanted) in enumerate(zip(lines, expected)):
        if actual != wanted:
            raise AssertionError(f"oracle row {index}: {actual} != {wanted}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nim-root", type=Path, default=Path("/workspace/cplib-env"))
    parser.add_argument("--output", type=Path, default=Path("/workspace/modint64-results"))
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    data, expected = corpus()
    (output / "oracle-input.txt").write_text(data)
    (output / "oracle-expected.txt").write_text("\n".join(expected) + "\n")
    report = {"platform": platform.platform(), "machine": platform.machine(),
              "seed": "0x64c0ffee", "primes": PRIMES, "oracle_rows": len(expected),
              "oracle_fields": 17, "matrix": [], "expander": [], "benchmarks": []}
    report["gcc"] = subprocess.check_output(["gcc", "--version"], text=True).splitlines()[0]
    report["g++"] = subprocess.check_output(["g++", "--version"], text=True).splitlines()[0]
    core = ROOT / "src/verify/modint/modint64_test.nim"
    driver = ROOT / "tools/modint64/oracle_driver.nim"
    for version in ["1.6.20", "2.2.4"]:
        nim = args.nim_root / f"nim-{version}/bin/nim"
        report[f"nim_{version}"] = subprocess.check_output([nim, "--version"], text=True)
        for backend in ["c", "cpp"]:
            for mode, flags in [("debug", []), ("release", ["-d:release"]),
                                ("danger", ["-d:danger"])]:
                name = f"{version}-{backend}-{mode}"
                print(f"verify {name}", flush=True)
                common = [nim, backend, "--hints:off", "--warnings:off",
                          f"--path:{ROOT / 'src'}", *flags]
                for source, label in [(core, "core"), (driver, "oracle")]:
                    binary = output / f"{name}-{label}"
                    run([*common, f"--nimcache:{output / (name + '-' + label + '-cache')}",
                         f"--out:{binary}", source], output / f"{name}-{label}-build.log")
                    result = run([binary], output / f"{name}-{label}-run.log",
                                 input_text=data if label == "oracle" else None)
                    if label == "oracle": verify_output(result, expected)
                    else: assert result.strip() == "Hello World"
                report["matrix"].append({"nim": version, "backend": backend,
                                         "mode": mode, "core": "pass", "oracle": "pass"})
            # 不正な法はdangerでもコンパイル時に拒否する。
            for p in [0, 1, 4, 9, 341, 561, 3215031751, 3825123056546413051, MAX]:
                invalid = output / "invalid_modulus.nim"
                invalid.write_text(f"import cplib/modint/modint64\n"
                                   f"declarStaticModint64(Bad, {p}u64)\n")
                run([nim, backend, "--hints:off", "-d:danger", f"--path:{ROOT / 'src'}",
                     f"--nimcache:{output / 'invalid-cache'}", invalid],
                    output / f"{version}-{backend}-invalid-{p}.log", expect_failure=True)
            # 複数translation unitからemitされた乗算を呼ぶ。
            helper = output / "abi_helper.nim"
            helper.write_text("import cplib/modint/modint64\n"
                              "type AbiMint* = StaticModint64[18446744073709551557u64]\n"
                              "proc multiply*(a, b: AbiMint): AbiMint = a * b\n")
            abi = output / "abi_main.nim"
            abi.write_text("import abi_helper, cplib/modint/modint64\n"
                           "doAssert sizeof(AbiMint) == 8\n"
                           "doAssert alignof(AbiMint) == alignof(uint64)\n"
                           "doAssert multiply(AbiMint.init(-1), AbiMint.init(-1)).val == 1\n"
                           "doAssert (AbiMint.init(-2) * AbiMint.init(-2)).val == 4\n")
            run([nim, backend, "-r", "--hints:off", f"--path:{ROOT / 'src'}",
                 f"--nimcache:{output / (version + backend + '-abi-cache')}",
                 f"--out:{output / (version + backend + '-abi')}", abi],
                output / f"{version}-{backend}-abi.log")
            # UBSanはunsigned wrapを許容し、signed overflow等を検出する。
            sanitizer = ["-d:release", "--passC:-fsanitize=undefined",
                         "--passC:-fno-sanitize-recover=all", "--passL:-fsanitize=undefined"]
            sanitized = output / f"{version}-{backend}-ubsan"
            run([nim, backend, "--hints:off", f"--path:{ROOT / 'src'}", *sanitizer,
                 f"--nimcache:{sanitized}-cache", f"--out:{sanitized}", driver],
                output / f"{version}-{backend}-ubsan-build.log")
            verify_output(run([sanitized], output / f"{version}-{backend}-ubsan-run.log",
                              input_text=data), expected)
        compare = ROOT / "tools/modint64/compare_existing.nim"
        run([nim, "cpp", "-r", "--hints:off", "-d:release", f"--path:{ROOT / 'src'}",
             f"--nimcache:{output / (version + '-compare-cache')}",
             f"--out:{output / (version + '-compare')}", compare],
            output / f"{version}-compare.log")
        for test in ["src/verify/modint/modint_arithmetic_test.nim",
                     "src/verify/AI/modint_test.nim"]:
            name = Path(test).stem
            run([nim, "cpp", "-r", "--hints:off", "-d:release", f"--path:{ROOT / 'src'}",
                 f"--nimcache:{output / (version + '-' + name + '-cache')}",
                 f"--out:{output / (version + '-' + name)}", ROOT / test],
                output / f"{version}-{name}.log")
        print(f"expand {version}", flush=True)
        expander = output / f"expander-{version}"
        run([nim, "cpp", "--hints:off", "-d:release",
             f"--nimcache:{expander}-cache", f"--out:{expander}",
             ROOT / "tools/expander/expander.nim"], output / f"{version}-expander-build.log")
        for label, options in [("normal", []), ("single", ["--single-line"]),
                               ("compress", ["--compress"]),
                               ("original", ["--compress", "--original-source"])]:
            expanded = output / f"expanded_{version.replace('.', '_')}_{label}.nim"
            run([expander, "--quiet", f"--lib:{ROOT}", *options,
                 f"--output-file:{expanded}", core.relative_to(ROOT)], output / f"{version}-{label}-expand.log")
            for backend in ["c", "cpp"]:
                run([nim, backend, "-r", "--hints:off", "-d:release",
                     f"--nimcache:{expanded}-{backend}-cache",
                     f"--out:{expanded}-{backend}", expanded],
                    output / f"{version}-{label}-{backend}-expanded-run.log", cwd=output)
                report["expander"].append({"nim": version, "backend": backend,
                                           "mode": label, "result": "pass"})
        # Python expanderでも通常・single-line形式を実行する。
        for label, options in [("normal", []), ("single", ["--single-line"])]:
            expanded = output / f"python_expanded_{version.replace('.', '_')}_{label}.nim"
            expanded.write_text(run(["python3", ROOT / "expander.py", "--console", *options,
                                     core, "--lib", ROOT],
                                    output / f"{version}-{label}-python-expand.log"))
            for backend in ["c", "cpp"]:
                run([nim, backend, "-r", "--hints:off", "-d:release",
                     f"--nimcache:{expanded}-{backend}-cache", f"--out:{expanded}-{backend}",
                     expanded], output / f"{version}-{label}-{backend}-python-run.log")
        print(f"benchmark {version}", flush=True)
        benchmark = output / f"benchmark-{version}"
        run([nim, "cpp", "--hints:off", "-d:danger", "--opt:speed",
             f"--path:{ROOT / 'src'}", f"--nimcache:{benchmark}-cache",
             f"--out:{benchmark}", ROOT / "tools/modint64/benchmark.nim"],
            output / f"{version}-benchmark-build.log")
        samples = {}
        for repeat in range(7):
            text = run([benchmark, "3000000"], output / f"{version}-benchmark-{repeat}.log")
            for line in text.splitlines():
                name, operation, duration, checksum = line.split()
                samples.setdefault((name, operation), []).append(float(duration))
        for (name, operation), durations in samples.items():
            count = 3000 if operation == "inv" else 3000000
            report["benchmarks"].append({"nim": version, "name": name,
                                         "operation": operation, "count": count,
                                         "median_seconds": statistics.median(durations),
                                         "samples_seconds": durations})
    report["status"] = "all passed"
    (output / "results.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"all passed: {output / 'results.json'}", flush=True)


if __name__ == "__main__":
    main()
