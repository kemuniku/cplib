#!/usr/bin/env python3
"""公開APIのoracle・境界検証を逐次実行する。ログと生成物はrepository外へ保存する。"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

REPO = Path(__file__).resolve().parents[3]
VERIFY = REPO / "src/verify/AI"
CORE = ["dynamic_quaternary_vector", "dynamic_quaternary_waveletmatrix",
        "dynamic_quaternary_boundary", "dynamic_quaternary_query", "dynamic_quaternary_kernel"]
BINARY = ["dynamic_bplus_bitvector", "dynamic_bplus_stress", "dynamic_bplus_boundary"]
PREFIX = ["-d:quadLeafPrefix", "-d:quadPrefixWords:16"]
PROFILES = {
    "default": [],
    "fast": [],
    "small": ["-d:quadOptimized"],
    "prefix": ["-d:quadOptimized"] + PREFIX,
    "large": ["-d:quadOptimized"] + PREFIX + ["-d:quadTestBranch:32", "-d:quadTestWords:256"],
    "wide512": ["-d:quadOptimized"] + PREFIX + ["-d:quadTestBranch:32", "-d:quadTestWords:512"],
}
MODES = ["c", "cpp", "portable", "asan", "expander"]
SANITIZER = ["-d:debug", "-d:noSignalHandler", "--passC:-fsanitize=address,undefined",
             "--passC:-fno-sanitize-recover=all", "--passC:-ftls-model=local-exec",
             "--passC:-fno-omit-frame-pointer", "--passL:-fsanitize=address,undefined"]


def choices(value, allowed):
    result = value.split(",")
    if not result or len(set(result)) != len(result) or any(x not in allowed for x in result):
        raise argparse.ArgumentTypeError("選択肢: " + ",".join(allowed))
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__, epilog=(
        "例: --nim /path/nim-1.6.20/bin/nim --nim /path/nim-2.2.4/bin/nim。"
        "短縮確認は --quick --skip-large --modes c --profiles small,large。"
        "既定は従来のdefault全量/portable/sanitizer/expanderとmanual大規模を実行する。"
        "最適化確認は --profiles small,large,wide512、define不要Fast APIは --profiles fast を明示する。"))
    parser.add_argument("output", type=Path)
    parser.add_argument("--nim", action="append", help="複数指定可。既定は環境変数NIMまたはPATHのnim")
    parser.add_argument("--profiles", type=lambda x: choices(x, PROFILES), default=["default"])
    parser.add_argument("--modes", type=lambda x: choices(x, MODES), default=MODES)
    parser.add_argument("--tests", help="通常modeのtest stemをcomma区切りで指定。expanderはboundary、fast profileではFast testを使用")
    parser.add_argument("--quick", action="store_true", help="dynamicWmFullTestを付けない")
    parser.add_argument("--skip-large", action="store_true", help="従来の140000要素manual試験を省く")
    args = parser.parse_args()
    out = args.output.resolve()
    if out == REPO or REPO in out.parents:
        parser.error("出力先はrepository外にしてください")
    if out.exists() and (not out.is_dir() or any(out.iterdir())):
        parser.error("既存結果を保護するため空の出力directoryを指定してください")
    explicit = args.tests.split(",") if args.tests else None
    if explicit and any(not (VERIFY / (name + "_test.nim")).is_file() or "/" in name for name in explicit):
        parser.error("--testsにはverify/AIの既存test stemを指定してください")
    compilers = []
    for name in args.nim or [os.environ.get("NIM", "nim")]:
        resolved = shutil.which(name)
        if resolved is None:
            parser.error("Nim compilerが見つかりません: " + name)
        compiler = str(Path(resolved).resolve())
        if compiler in compilers:
            parser.error("同一Nim compilerの重複指定です")
        compilers.append(compiler)
    out.mkdir(parents=True, exist_ok=True)
    source_files = list((REPO / "src/cplib/collections").glob("dynamic_*.nim"))
    source_files += list(VERIFY.glob("dynamic_*test.nim")) + list(VERIFY.glob("dynamic_*trace.nim"))
    source_files += list((REPO / "tools/expander").glob("*.nim"))
    source_files += [Path(__file__).resolve(), VERIFY / "run_dynamic_quaternary_validation.sh"]
    hashes = {str(p.relative_to(REPO)): hashlib.sha256(p.read_bytes()).hexdigest()
              for p in sorted(set(source_files))}
    (out / "source_sha256.json").write_text(json.dumps(hashes, indent=2) + "\n")
    report = {"arguments": vars(args).copy(), "repository": str(REPO), "compilers": [],
              "cases": [], "commands": [], "status": "running",
              "sanitizer_limit": "ASan/UBSanを実行。既定detect_leaks=0でLSanは検証しない。",
              "isa": "各testが可用ISAを判定。未対応ISAのlibrary fallbackも境界testで検証。"}
    report["arguments"]["output"] = str(out)

    def save():
        (out / "validation.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n")

    def run(command, log, env=None):
        record = {"argv": [str(x) for x in command], "cwd": str(REPO), "log": str(log)}
        if env:
            record["environment"] = {key: env[key] for key in ("ASAN_OPTIONS", "UBSAN_OPTIONS")}
        report["commands"].append(record)
        save()
        with log.open("w") as stream:
            result = subprocess.run(command, cwd=REPO, env=env, stdout=stream, stderr=subprocess.STDOUT)
        record["exit_code"] = result.returncode
        save()
        if result.returncode:
            raise RuntimeError("検証失敗: " + str(log))

    try:
        for index, nim in enumerate(compilers):
            folder = out / ("nim_" + str(index))
            folder.mkdir()
            run([nim, "--version"], folder / "version.log")
            report["compilers"].append({"path": nim, "version": (folder / "version.log").read_text(),
                                         "sha256": hashlib.sha256(Path(nim).read_bytes()).hexdigest()})
            expander = folder / "expander"
            if "expander" in args.modes:
                run([nim, "c", "-d:release", "--gc:orc", "--nimcache:" + str(folder / "cache_expander"),
                     "-o:" + str(expander), str(REPO / "tools/expander/expander.nim")], folder / "expander_compile.log")

            def check(label, source, backend, flags, expanded=None, sanitizer=False):
                binary = folder / label
                memory = ["--gc:orc"] if backend == "c" or expanded is not None else []
                run([nim, backend, "-d:release"] + memory + ["--path:" + str(REPO / "src"),
                     "--nimcache:" + str(folder / ("cache_" + label)), "-o:" + str(binary)] + flags +
                    [str(expanded or VERIFY / (source + "_test.nim"))], folder / (label + "_compile.log"))
                env = None
                if sanitizer:
                    env = dict(os.environ)
                    env.setdefault("ASAN_OPTIONS", "detect_leaks=0")
                    env.setdefault("UBSAN_OPTIONS", "halt_on_error=1:print_stacktrace=1")
                run([str(binary)], folder / (label + "_run.log"), env)
                report["cases"].append({"compiler": index, "label": label, "source": source,
                                        "flags": flags, "status": "passed"})
                save()
                print(label + " passed", flush=True)

            for profile in args.profiles:
                flags = PROFILES[profile]
                selected = explicit or (CORE + BINARY if profile == "default" else CORE)
                if not explicit and profile in ("large", "wide512"):
                    selected = ["dynamic_quaternary_waveletmatrix", "dynamic_quaternary_boundary", "dynamic_quaternary_wide"]
                if not explicit and profile == "fast":
                    selected = ["dynamic_quaternary_fast", "dynamic_quaternary_fast_abc343f"]
                for mode in args.modes:
                    if mode == "expander":
                        source = "dynamic_quaternary_fast" if profile == "fast" else "dynamic_quaternary_boundary"
                        for form in ("plain", "single_line", "compress"):
                            label = profile + "_expanded_" + form
                            expanded = folder / (label + ".nim")
                            extra = [] if form == "plain" else ["--" + form.replace("_", "-")]
                            run([str(expander), "--quiet"] + extra + ["--lib:" + str(REPO),
                                "--output-file:" + str(expanded), str((VERIFY / (source + "_test.nim")).relative_to(REPO))], folder / (label + "_expand.log"))
                            for backend in (["c", "cpp"] if profile == "fast" else ["cpp"]):
                                compiled_label = label + "_" + backend if profile == "fast" else label
                                check(compiled_label, source, backend, flags, expanded=expanded)
                        continue
                    extra = [] if args.quick or mode == "cpp" else ["-d:dynamicWmFullTest"]
                    if mode == "portable": extra += ["-d:dynamicWmPortable", "-d:cplibDynamicBitVectorPortable"]
                    if mode == "asan": extra += SANITIZER
                    for source in selected:
                        check(profile + "_" + mode + "_" + source, source,
                              "cpp" if mode == "cpp" else "c", flags + extra, sanitizer=mode == "asan")
            if not args.skip_large:
                # 旧entrypointのmanual全量・B24/B32 sanitizer検証を保持する。
                for label, source, flags in [
                    ("manual_large", "dynamic_quaternary_large", []),
                    ("manual_branch24", "dynamic_quaternary_waveletmatrix", ["-d:quadBranch24"]),
                    ("manual_branch32", "dynamic_quaternary_waveletmatrix", ["-d:quadBranch32"]),
                ]:
                    check(label, source, "c", ["-d:dynamicWmFullTest"] + flags + SANITIZER, sanitizer=True)
        changed = [name for name, digest in hashes.items()
                   if not (REPO / name).is_file() or hashlib.sha256((REPO / name).read_bytes()).hexdigest() != digest]
        if changed:
            raise RuntimeError("検証中に入力sourceが変化しました: " + ", ".join(changed))
        report["source_unchanged"] = True
        report["status"] = "passed"
    except Exception as error:
        report["status"] = "failed"
        report["error"] = str(error)
        raise
    finally:
        save()


if __name__ == "__main__":
    try:
        main()
    except RuntimeError as error:
        print(error, file=sys.stderr)
        sys.exit(1)
