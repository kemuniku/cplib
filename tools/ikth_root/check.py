#!/usr/bin/env python3
"""コンパイル済みkth_root_integer_testをPython多倍長整数と比較する。"""
import random
import subprocess
import sys


def root(n, k):
    if k == 1 or n <= 1:
        return n
    if k >= n.bit_length():
        return 1
    lo, hi = 0, 1 << ((n.bit_length() + k - 1) // k)
    while hi - lo > 1:
        mid = (lo + hi) // 2
        if pow(mid, k) <= n:
            lo = mid
        else:
            hi = mid
    return lo


def main():
    rng = random.Random(20261022)
    limit = (1 << 64) - 1
    cases = [(rng.getrandbits(64), rng.randint(1, 100)) for _ in range(100000)]
    for k in range(1, 101):
        cases.extend((n, k) for n in [0, 1, 2, limit, limit - 1, (1 << 63) - 1])
        for bit in range(64):
            cases.extend((n, k) for n in [(1 << bit) - 1, 1 << bit, (1 << bit) + 1])
    for k in range(2, 64):
        max_root = root(limit, k)
        for x in [2, 3, max_root, max_root - 1] + [rng.randint(1, max_root) for _ in range(100)]:
            p = pow(x, k)
            cases.extend((n, k) for n in [p - 1, p, p + 1] if 0 <= n <= limit)
    cases.extend((n, (1 << 63) - 1) for n in [0, 1, 2, limit])
    data = str(len(cases)) + '\n' + ''.join(f'{n} {k}\n' for n, k in cases)
    expected = [root(n, k) for n, k in cases]
    for binary in sys.argv[1:]:
        result = subprocess.run([binary], input=data, text=True, capture_output=True, check=True)
        actual = list(map(int, result.stdout.split()))
        assert len(actual) == len(expected), (binary, len(actual), len(expected))
        for (n, k), got, want in zip(cases, actual, expected):
            assert got == want, (binary, n, k, got, want)
        print(f'{binary}: {len(cases)} cases passed')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit('usage: check.py COMPILED_JUDGE_HARNESS ...')
    main()
