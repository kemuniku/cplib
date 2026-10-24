import argparse
import pathlib
import subprocess
import tempfile

parser = argparse.ArgumentParser()
parser.add_argument("compiler")
args = parser.parse_args()
repo = pathlib.Path(__file__).resolve().parents[2]
output = pathlib.Path(__file__).resolve().parent / "benchmark.txt"
with output.open("w") as log, tempfile.TemporaryDirectory(prefix="trie-string-bench-") as tmp:
    log.write(subprocess.check_output([args.compiler, "--version"], text=True))
    for variant in ("table", "array2", "array26", "array256"):
        flags = [] if variant == "table" else [f"-d:{variant}"]
        command = [args.compiler, "c", "-d:release", "--path:src", "--hints:off",
                   f"--nimcache:{tmp}/{variant}", f"--out:{tmp}/bench", *flags,
                   "src/verify/str/trie_string_benchmark.nim"]
        subprocess.run(command, cwd=repo, check=True)
        sizes = (12500, 25000, 50000) if variant == "array256" else (50000, 100000, 200000, 400000)
        for shape in ("chains", "binary"):
            for n in sizes:
                result = subprocess.run(["/usr/bin/time", "-f", "rss_kib=%M", f"{tmp}/bench", str(n), shape],
                                        cwd=repo, text=True, stdout=subprocess.PIPE,
                                        stderr=subprocess.STDOUT, check=True)
                record = f"variant={variant} n={n}\n{result.stdout}"
                print(record, end="", flush=True)
                log.write(record)
                log.flush()
