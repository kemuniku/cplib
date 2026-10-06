import argparse
from fractions import Fraction as F
from itertools import combinations
import random
import subprocess
import sys
import time
from exact_circle_oracle import circle, power


def oracle(points):
    if not points:
        return None
    candidates = [(p, F(0)) for p in points]
    for a, b in combinations(points, 2):
        center = tuple((x+y)/2 for x, y in zip(a, b))
        candidates.append((center, sum((x-y)**2 for x, y in zip(center, a))))
    for subset in combinations(points, 3):
        candidate = circle(subset, 0, 0)
        if candidate is not None:
            candidates.append(candidate)
    feasible = [c for c in candidates if all(power(c, p) <= 0 for p in points)]
    return min(feasible, key=lambda c: c[1])


def generate():
    rng = random.Random(28563355030)
    types = ('int', 'int128', 'bigint', 'fraction-int', 'fraction-int128', 'fraction-bigint')
    sets = []
    for kind in types:
        for i in range(80):
            n = rng.randrange(0, 9)
            def value():
                x = rng.randrange(-2, 3) if kind in ('int', 'fraction-int') else rng.randrange(-10, 11)
                return F(x, 2 if 'fraction' in kind else 1)
            points = [tuple(value() for _ in range(2)) for _ in range(n)]
            if i % 5 == 0:
                points = [(p[0], F(3)) for p in points]
            if i % 7 == 0 and points:
                points += [points[0]] * 3
            sets.append((kind, points))
        # 座標・分母の共通尺度を大きくして、支持集合と半径二乗を厳密照合する。
        if 'fraction' in kind:
            scale = F(1, {'fraction-int': 2, 'fraction-int128': 1000, 'fraction-bigint': 2**2048-1}[kind])
            origin = F(0)
        else:
            scale = F(1)
            origin = F({'int': 1000000, 'int128': 10**30, 'bigint': 2**2048}[kind])
        for grid in ([(0, 0), (1, 0)], [(0, 0), (4, 0), (2, 4)], [(0, 0), (4, 0), (1, 1)],
                     [(0, 0), (4, 0), (0, 4), (4, 4)], [(0, 0)]*20):
            sets.append((kind, [(origin+scale*x, origin+scale*y) for x, y in grid]))
        if kind == 'bigint':
            sets.append((kind, [(F(-2**2048), F(0)), (F(2**2048-1), F(0))]))
    # 小さな整数格子から全ての1/2/3/4点集合を調べる。
    grid = [(F(x), F(y)) for x in range(3) for y in range(3)]
    for n in range(1, 5):
        for points in combinations(grid, n): sets.append(('int', list(points)))
    for kind, points in sets:
        expected = oracle(points)
        for seed in (0, 1, -1, 63355030):
            for ordering in (points, list(reversed(points))):
                yield kind, seed, ordering, expected


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('binaries', nargs='+')
    args = parser.parse_args()
    cases = list(generate())
    lines, expected = [], []
    for kind, seed, points, result in cases:
        tokens = ['mec-'+kind, str(seed), str(len(points))]
        for point in points:
            for value in point: tokens += [str(value.numerator), str(value.denominator)]
        lines.append(' '.join(tokens))
        expected.append('EMPTY' if result is None else ' '.join(str(v.numerator)+'/'+str(v.denominator) for v in (*result[0], result[1])))
    for binary in args.binaries:
        start = time.monotonic()
        result = subprocess.run([binary], input='\n'.join(lines)+'\n', text=True, capture_output=True)
        assert result.returncode == 0, (binary, result.stderr[-2000:])
        actual = result.stdout.splitlines()
        assert len(actual) == len(expected), (len(actual), len(expected))
        for i, (a, e) in enumerate(zip(actual, expected)):
            assert a == e, (binary, i, lines[i], a, e)
        print(f'{binary}: {len(cases)} MEC all-1/2/3-support oracle cases passed in {time.monotonic()-start:.2f}s', flush=True)


if __name__ == '__main__':
    main()
