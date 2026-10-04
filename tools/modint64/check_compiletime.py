#!/usr/bin/env python3
"""Nim VMの演算とprivate素数判定を独立したPython期待値で検証する。"""
import argparse
import json
from pathlib import Path
import random

from validate import ROOT, PRIMES, MAX, run


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--nim-root", type=Path, default=Path("/workspace/cplib-env"))
    parser.add_argument("--output", type=Path, default=Path("/workspace/modint64-results"))
    args = parser.parse_args()
    output = args.output.resolve()
    output.mkdir(parents=True, exist_ok=True)
    rng = random.Random(640001)
    lines = ["include cplib/modint/modint64"]
    constant_cases = 0
    for index, p in enumerate(PRIMES):
        name = f"M{index}"
        lines.append(f"type {name} = StaticModint64[{p}u64]")
        for case in range(6):
            x, y = rng.getrandbits(64), rng.getrandbits(64)
            e = [0, 1, 2, 65535, MAX, rng.getrandbits(64)][case]
            signed = -(1 << 63) if case == 0 else rng.randrange(-(1 << 63), 1 << 63)
            a, b = x % p, y % p
            prefix = f"{name}_{case}"
            lines += [f"const {prefix}a = {name}.init({x}u64)",
                      f"const {prefix}b = {name}.init({y}u64)", "static:"]
            checks = [(f"{prefix}a + {prefix}b", (a + b) % p),
                      (f"{prefix}a - {prefix}b", (a - b) % p),
                      (f"{prefix}a * {prefix}b", a * b % p),
                      (f"{prefix}a.pow({e}u64)", pow(a, e, p)),
                      (f"{name}.init({signed}i64)", signed % p),
                      (f"{name}.init(\"{-rng.getrandbits(1024)}\")", None)]
            checks[-1] = (checks[-1][0], int(checks[-1][0].split('"')[1]) % p)
            if a:
                checks.append((f"{prefix}a.inv", pow(a, -1, p)))
            if b:
                checks.append((f"{prefix}a / {prefix}b", a * pow(b, -1, p) % p))
            for expression, wanted in checks:
                lines.append(f"    doAssert ({expression}).val == {wanted}u64")
            constant_cases += len(checks)
    # trial divisionはライブラリのMiller-Rabinと独立している。
    primality = [(n, n >= 2 and all(n % d for d in range(2, int(n ** 0.5) + 1)))
                 for n in range(2001)]
    primality += [(p, True) for p in PRIMES]
    primality += [(rng.randrange(1 << 30, 1 << 31) * rng.randrange(1 << 30, 1 << 31), False)
                  for _ in range(100)]
    primality += [(0, False), (1, False), (MAX, False), (3825123056546413051, False)]
    tuples = ",\n    ".join(f"({n}u64, {str(prime).lower()})" for n, prime in primality)
    lines += [f"const primalityCases = [\n    {tuples}\n]", "static:",
              "    for (n, expected) in primalityCases:",
              "        doAssert primeModint64(n) == expected",
              "for (n, expected) in primalityCases:",
              "    doAssert primeModint64(n) == expected", 'echo "compiletime passed"']
    source = output / "compiletime_oracle.nim"
    source.write_text("\n".join(lines) + "\n")
    results = []
    for version in ["1.6.20", "2.2.4"]:
        for backend in ["c", "cpp"]:
            print(f"compiletime {version}-{backend}", flush=True)
            nim = args.nim_root / f"nim-{version}/bin/nim"
            run([nim, backend, "-r", "--hints:off", "-d:release",
                 f"--path:{ROOT / 'src'}", f"--nimcache:{output / (version + backend + '-compiletime-cache')}",
                 f"--out:{output / (version + backend + '-compiletime')}", source],
                output / f"{version}-{backend}-compiletime.log")
            for p in [0, 1, 4, 3825123056546413051, MAX]:
                invalid = output / "invalid_direct.nim"
                invalid.write_text("import cplib/modint/modint64\n"
                                   f"discard StaticModint64[{p}u64].init(1)\n")
                run([nim, backend, "--hints:off", "-d:danger", f"--path:{ROOT / 'src'}", invalid],
                    output / f"{version}-{backend}-invalid-direct-{p}.log", expect_failure=True)
            results.append({"nim": version, "backend": backend, "result": "pass"})
    report = {"constant_oracle_checks": constant_cases,
              "primality_checks_each_vm_and_native": len(primality), "seed": 640001,
              "direct_invalid_moduli": [0, 1, 4, 3825123056546413051, MAX],
              "matrix": results, "status": "all passed"}
    (output / "compiletime-results.json").write_text(json.dumps(report, indent=2) + "\n")
    print("compiletime all passed", flush=True)


if __name__ == "__main__":
    main()
