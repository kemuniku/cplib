import argparse
from pathlib import Path
import random
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parents[2]


def run(command, **kwargs):
    result = subprocess.run(command, text=True, capture_output=True, **kwargs)
    if result.returncode:
        raise AssertionError(f"{command!r}\n{result.stdout}\n{result.stderr}")
    return result.stdout


def check(binary, seed, n):
    rng = random.Random(seed)
    initial = [rng.randrange(-4, 5) for _ in range(n)]
    current = initial.copy()
    operations, expected = [], []
    for step in range(2000):
        if n and rng.randrange(3) == 0:
            i = rng.choice([0, n - 1, rng.randrange(n)])
            value = current[i] if step % 7 == 0 else rng.randrange(-10**12, 10**12)
            operations.append(f"0 {i} {value}")
            current[i] = value
            continue
        kind = rng.choice([1, 1, 2])
        l = rng.randrange(n + 1)
        r = rng.randrange(l, n + 1)
        values = (current if kind == 1 else initial)[l:r]
        x = rng.choice([-2**63, 2**63 - 1, rng.randrange(-6, 7),
                        rng.choice(values) if values else 0])
        low, high = rng.randrange(-6, 7), rng.randrange(-6, 7)
        k = rng.randrange(len(values)) if values else 0
        operations.append(f"{kind} {l} {r} {x} {low} {high} {k}")
        prev = max((v for v in values if v < x), default="none")
        nxt = min((v for v in values if v >= x), default="none")
        ordered = sorted(values)
        answer = [sum(v < x for v in values), sum(v <= x for v in values),
                  values.count(x), sum(low <= v < high for v in values), prev, nxt,
                  ordered[k] if values else "none", ordered[-1-k] if values else "none"]
        expected.append(" ".join(map(str, answer)))
    data = f"{n} {len(operations)}\n{' '.join(map(str, initial))}\n" + "\n".join(operations) + "\n"
    actual = run([str(binary)], input=data).splitlines()
    if actual != expected:
        for i, (got, want) in enumerate(zip(actual, expected)):
            if got != want:
                raise AssertionError(f"seed={seed}, n={n}, answer={i}: {got!r} != {want!r}")
        raise AssertionError(f"seed={seed}, n={n}: output length {len(actual)} != {len(expected)}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nim", default="nim")
    parser.add_argument("--expand", action="store_true")
    args = parser.parse_args()
    with tempfile.TemporaryDirectory() as directory:
        build = Path(directory)
        driver = Path(__file__).with_name("driver.nim")
        sources = [("original", driver)]
        if args.expand:
            expander = build / "expander"
            run([args.nim, "cpp", "--hints:off", "-d:release",
                 f"--nimcache:{build}/expander_cache", f"--out:{expander}",
                 str(ROOT / "tools/expander/expander.nim")])
            for name, flags in [("plain", []), ("single", ["--single-line"]),
                                ("compressed", ["--compress"]),
                                ("with_source", ["--compress", "--original-source"])]:
                source = build / f"{name}.nim"
                run([str(expander), "--quiet", f"--lib:{ROOT}",
                     f"--output-file:{source}", *flags, str(driver.relative_to(ROOT))], cwd=ROOT)
                sources.append((name, source))
        for name, source in sources:
            binary = build / name
            command = [args.nim, "cpp", "--hints:off", "-d:release",
                       f"--nimcache:{build}/{name}_cache", f"--out:{binary}"]
            if name == "original": command.append(f"--path:{ROOT / 'src'}")
            run(command + [str(source)])
            for seed in range(24):
                check(binary, 20261004 + seed, [0, 1, 2, 7, 65, 257][seed % 6])
            print(f"{name}: 24 seeds x 2000 operations: OK", flush=True)
        if args.expand:
            source = build / "generic.nim"
            run([str(expander), "--quiet", f"--lib:{ROOT}", f"--output-file:{source}",
                 "src/verify/collections/mergesorttree_test.nim"], cwd=ROOT)
            output = run([args.nim, "cpp", "-r", "--hints:off", "-d:release",
                          f"--nimcache:{build}/generic_cache", f"--out:{build}/generic",
                          str(source)])
            assert output.strip() == "Hello World"
            print("expanded generic/edge/random regression: OK", flush=True)


if __name__ == "__main__":
    main()
