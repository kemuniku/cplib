import argparse
from fractions import Fraction as F
from itertools import permutations
import random
import subprocess
import time
import sys

if hasattr(sys, "set_int_max_str_digits"):
    sys.set_int_max_str_digits(0)


def sign(x):
    return (x > 0) - (x < 0)


def determinant(a):
    if len(a) == 1:
        return a[0][0]
    return sum((-1) ** i * a[0][i] * determinant([r[:i] + r[i+1:] for r in a[1:]]) for i in range(len(a)))


def circle(points, method, radius):
    a, b, c = points
    if method == 1:
        return a, F(radius * radius)
    if method == 2:
        return a, sum((x-y)**2 for x, y in zip(a, b))
    if a == b == c:
        return a, F(0)
    matrix = [[x, y, F(1)] for x, y in points]
    det = determinant(matrix)
    if det == 0:
        return None
    rhs = [-x*x-y*y for x, y in points]
    coefficients = [determinant([row[:i] + [rhs[j]] + row[i+1:] for j, row in enumerate(matrix)]) / det for i in range(3)]
    center = tuple(-z/2 for z in coefficients[:2])
    return center, sum(x*x for x in center)-coefficients[2]


def power(c, p):
    center, r2 = c
    return sum((x-y)**2 for x, y in zip(center, p)) - r2


def location(c, p):
    return {1: 0, 0: 1, -1: 2}[sign(power(c, p))]


def line_coeff(c, a, b):
    v = [y-x for x, y in zip(a, b)]
    w = [x-y for x, y in zip(a, c[0])]
    A = sum(x*x for x in v)
    B = 2 * sum(x*y for x, y in zip(v, w))
    C = power(c, a)
    return A, B, C, B*B-4*A*C


def line_count(c, a, b):
    d = line_coeff(c, a, b)[3]
    return 0 if d < 0 else 1 if d == 0 else 2


def segment_count(c, a, b):
    if a == b:
        return int(power(c, a) == 0)
    A, B, C, D = line_coeff(c, a, b)
    if D < 0:
        return 0
    if D == 0:
        return int(0 <= -B/(2*A) <= 1)
    def variations(x):
        signs = [sign(z) for z in (A*x*x+B*x+C, 2*A*x+B, D/(4*A)) if z != 0]
        return sum(a != b for a, b in zip(signs, signs[1:]))
    return variations(0) - variations(1) + int(C == 0)


def circle_count(a, b):
    distance = sum((x-y)**2 for x, y in zip(a[0], b[0]))
    if distance == 0:
        return (1 if a[1] == 0 else -1) if a == b else 0
    delta = 4*a[1]*b[1]-(distance-a[1]-b[1])**2
    return 0 if delta < 0 else 1 if delta == 0 else 2


def tangent_count(c, p):
    v = power(c, p)
    if c[1] == 0:
        return -1 if v == 0 else 1
    return 0 if v < 0 else 1 if v == 0 else 2


def common_count(a, b):
    d = sum((x-y)**2 for x, y in zip(a[0], b[0]))
    if d == 0:
        return -1 if a == b else 0
    if a[1] == b[1] == 0:
        return 1
    if a[1] == 0:
        return tangent_count(b, a[0])
    if b[1] == 0:
        return tangent_count(a, b[0])
    delta = d-a[1]-b[1]
    determinant = delta**2-4*a[1]*b[1]
    if determinant < 0:
        return 2
    if determinant == 0:
        return 3 if delta > 0 else 1
    return 4 if delta > 0 else 0


def generate():
    rng = random.Random(61006)
    cases = []
    types = ('int', 'uint', 'int128', 'bigint', 'fraction-int', 'fraction-int128', 'fraction-bigint')
    for kind in types:
        for i in range(300):
            if kind == 'uint':
                base = rng.choice((0, 2**64-31))
                def val(): return F(base + rng.randrange(0, 30))
            elif 'fraction' in kind:
                bits = {'fraction-int': 63, 'fraction-int128': 127, 'fraction-bigint': 160}[kind]
                def val():
                    if i % 4 == 0:
                        return F(rng.getrandbits(bits)*rng.choice((-1, 1)), rng.getrandbits(bits) or 1)
                    return F(rng.randrange(-20, 21), rng.randrange(1, 21))
            else:
                bits = {'int': 63, 'int128': 127, 'bigint': 600}[kind]
                base = rng.choice((0, -(2**bits), 2**bits-31))
                def val(): return F(base + rng.randrange(0, 30))
            points = [tuple(val() for _ in range(2)) for _ in range(9)]
            method = i % 3
            ra, rb = rng.randrange(0, 12), rng.randrange(0, 12)
            if i % 17 == 0:
                points[2] = points[1] = points[0]
            elif i % 19 == 0:
                points[1] = points[0]
            if i % 13 == 0:
                points[3] = points[0] if method == 0 else points[1]
            if i % 11 == 0:
                points[6:8] = points[:2]
            if points[4] == points[5]:
                points[5] = (points[5][0]+1, points[5][1])
            # uintの入力範囲を維持する。
            for ordering in (points[:3], points[:3][::-1]):
                ps = ordering + points[3:]
                cases.append((kind, method, ps, ra, rb))
    # 4x4 incircle determinantも使い、全順列・境界・64bit端を確認する。
    for kind in ('int', 'int128', 'bigint', 'fraction-int', 'fraction-int128', 'fraction-bigint'):
        for offset in (0, 2**63-5, -(2**63)):
            defining = [(F(offset), F(offset)), (F(offset+4), F(offset)), (F(offset), F(offset+4))]
            for ordering in permutations(defining):
                outside = (offset+4, offset-1) if offset > 0 else (offset+5, offset+5)
                for query in ((offset+4, offset+4), (offset+2, offset+2), outside):
                    ps = list(ordering)+[tuple(map(F, query))]+[defining[0], defining[1], defining[0], defining[1], defining[2]]
                    cases.append((kind, 0, ps, 0, 2))
    return cases


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('binaries', nargs='+')
    args = parser.parse_args()
    cases = generate()
    lines, expected = [], []
    for kind, method, ps, ra, rb in cases:
        tokens = [kind, str(method)]
        for p in ps:
            for v in p:
                tokens += [str(v.numerator), str(v.denominator)]
        tokens += [str(ra), str(rb)]
        lines.append(' '.join(tokens))
        c = circle(ps[:3], method, ra)
        if c is None:
            expected.append('INVALID')
            continue
        loc = location(c, ps[3])
        if method == 0 and len(set(ps[:3])) == 3:
            mat = [[x, y, x*x+y*y, F(1)] for x, y in ps[:4]]
            orientation = determinant([[x, y, F(1)] for x, y in ps[:3]])
            s = sign(determinant(mat)*orientation)
            assert loc == {-1: 0, 0: 1, 1: 2}[s]
        other = (ps[8], F(rb*rb))
        expected.append(' '.join([*(str(x.numerator)+'/'+str(x.denominator) for x in (*c[0], c[1])),
            str(loc), str(line_count(c, *ps[4:6])), str(segment_count(c, *ps[6:8])),
            str(circle_count(c, other)), str(tangent_count(c, ps[3])), str(common_count(c, other))]))
    for binary in args.binaries:
        start = time.monotonic()
        result = subprocess.run([binary], input='\n'.join(lines)+'\n', text=True, capture_output=True)
        if result.returncode != 0:
            raise AssertionError((binary, result.returncode, len(result.stdout.splitlines()), result.stderr[-2000:]))
        actual = result.stdout.splitlines()
        assert len(actual) == len(expected), (binary, len(actual), len(expected), result.stderr)
        for i, (a, e) in enumerate(zip(actual, expected)):
            assert a == e, (binary, i, lines[i], a, e)
        print(f'{binary}: {len(cases)} independent rational/determinant/Sturm cases passed in {time.monotonic()-start:.2f}s')


if __name__ == '__main__':
    main()
