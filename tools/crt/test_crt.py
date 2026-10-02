"""Python 多倍長整数で CRT と ABC193E の利用例を検証する。"""
import itertools
import math
import pathlib
import random
import subprocess
import sys
import tempfile

ROOT = pathlib.Path(__file__).resolve().parents[2]
LIMIT = (1 << 63) - 1
LOW = -(1 << 63)


def oracle(residues, moduli):
    # 各 prefix の整合性を pairwise condition で独立に判定する。
    for end in range(1, len(moduli) + 1):
        for i in range(end - 1):
            if (residues[i] - residues[end - 1]) % math.gcd(moduli[i], moduli[end - 1]):
                return "0 0"
        if math.lcm(*moduli[:end]) > LIMIT:
            return "overflow"
    if not moduli:
        return "0 1"
    # 剰余を一つずつ併合する Python の多倍長算術。逆元は組込み pow に任せる。
    value, period = 0, 1
    for residue, modulus in zip(residues, moduli):
        g = math.gcd(period, modulus)
        factor = modulus // g
        k = ((residue - value) // g * pow(period // g, -1, factor)) % factor if factor != 1 else 0
        value += period * k
        period *= factor
    assert 0 <= value < period
    assert all((value - r) % m == 0 for r, m in zip(residues, moduli))
    return f"{value} {period}"


def main():
    nim = sys.argv[1] if len(sys.argv) > 1 else "nim"
    rng = random.Random(247)
    cases = [([], [])]
    boundaries = [LOW, LOW + 1, -1, 0, 1, LIMIT - 1, LIMIT]
    moduli = [1, 2, 3, 4, 7, 97, (1 << 31) - 1, 1 << 32, LIMIT // 3, LIMIT // 2, LIMIT - 1, LIMIT]
    for a, b, r, s in itertools.product(moduli, moduli, boundaries, boundaries):
        cases.append(([r, s], [a, b]))
    for _ in range(3000):
        ms = [rng.choice(moduli) if rng.randrange(2) else rng.randrange(1, LIMIT + 1) for _ in range(rng.randrange(1, 7))]
        rs = [rng.randrange(LOW, LIMIT + 1) for _ in ms]
        cases.append((rs, ms))
        # 整合する系と、大きな共有因子を持つ系を増やす。
        value = rng.randrange(LOW, LIMIT + 1)
        cases.append(([value] * len(ms), ms))
        divisor = rng.randrange(1, LIMIT // 120 + 1)
        ms = [divisor * rng.randrange(1, 11) for _ in range(3)]
        cases.append(([value] * 3, ms))
    for _ in range(500):
        ms = [rng.randrange(1, 40) for _ in range(4)]
        rs = [rng.randrange(-100, 101) for _ in ms]
        cases.append((rs, ms))
        cases.append((list(reversed(rs)), list(reversed(ms))))
        cases.append(([r + m for r, m in zip(rs, ms)] + [rs[0]], ms + [ms[0]]))

    # ABC193E: CRT の利用結果を周期内の時刻全探索と照合する。
    oversleeping = []
    for x, y, p, q in itertools.product(range(1, 5), repeat=4):
        start = len(cases)
        cases.extend(([a, b], [2 * (x + y), p + q]) for a in range(x, x + y) for b in range(p, p + q))
        expected = next((t for t in range(math.lcm(2 * (x + y), p + q)) if x <= t % (2 * (x + y)) < x + y and p <= t % (p + q) < p + q), None)
        oversleeping.append((start, len(cases), expected))
    for x, y, p, q, expected in [(5, 2, 7, 6, 20), (1, 1, 3, 1, None), (999999999, 1, 1000000000, 1, 1000000000999999999)]:
        start = len(cases)
        cases.extend(([a, b], [2 * (x + y), p + q]) for a in range(x, x + y) for b in range(p, p + q))
        oversleeping.append((start, len(cases), expected))
    data = str(len(cases)) + "\n" + "".join(f"{len(rs)}\n{' '.join(map(str, rs))}\n{' '.join(map(str, ms))}\n" for rs, ms in cases)
    expected = [oracle(rs, ms) for rs, ms in cases]
    with tempfile.TemporaryDirectory(prefix="cplib-crt-") as directory:
        for release in (False, True):
            binary = pathlib.Path(directory) / ("release" if release else "debug")
            command = [nim, "cpp", "--hints:off", f"--path:{ROOT / 'src'}", f"--nimcache:{directory}/cache-{binary.name}", f"-o:{binary}"]
            if release:
                command += ["-d:release", "--assertions:off"]
            command += sys.argv[2:] + [str(ROOT / "tools/crt/crt_oracle_driver.nim")]
            subprocess.run(command, check=True)
            output = subprocess.run([str(binary)], input=data, text=True, capture_output=True, check=True).stdout.splitlines()
            assert len(output) == len(cases), (len(output), len(cases))
            for case, actual, wanted in zip(cases, output, expected):
                assert actual == wanted, (case, actual, wanted)
            for start, end, wanted in oversleeping:
                values = [int(line.split()[0]) for line in output[start:end] if line != "0 0"]
                assert (min(values) if values else None) == wanted
            print(f"{binary.name}: {len(cases)} CRT cases, {len(oversleeping)} ABC193E cases passed", flush=True)


if __name__ == "__main__":
    main()
