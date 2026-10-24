import argparse
import pathlib
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument("compilers", nargs="+")
args = parser.parse_args()
repo = pathlib.Path(__file__).resolve().parents[2]
output = pathlib.Path(__file__).resolve().parent / "validation.txt"
with output.open("w") as log, tempfile.TemporaryDirectory(prefix="trie-string-check-") as tmp:
    for compiler in args.compilers:
        version = subprocess.check_output([compiler, "--version"], text=True).splitlines()[0]
        for backend in ("c", "cpp"):
            for mode in ("debug", "release"):
                label = f"{version} {backend} {mode}"
                flags = ["-d:release"] if mode == "release" else []
                for test in ("trie_string_test", "trie_string_import_test"):
                    command = [compiler, backend, "-r", "--path:src", "--hints:off",
                               f"--nimcache:{tmp}/cache", f"--out:{tmp}/test", *flags,
                               f"tools/trie_string/tests/{test}.nim"]
                    result = subprocess.run(command, cwd=repo, text=True,
                                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
                    log.write(label + " " + test + "\n" + result.stdout + "\n")
                    log.flush()
                    print(label, test, "PASS" if result.returncode == 0 else "FAIL", flush=True)
                    if result.returncode:
                        raise SystemExit(result.returncode)
