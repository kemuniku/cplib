"""Delaunay分割とMSTをPythonの任意精度整数・独立oracleで検証する。"""
import argparse
from fractions import Fraction
import itertools
import json
from pathlib import Path
import random
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]


def turn(a, b, c):
    return (b[0]-a[0])*(c[1]-a[1]) - (b[1]-a[1])*(c[0]-a[0])


def distance(a, b):
    return sum((x-y)**2 for x, y in zip(a, b))


def on_segment(a, b, c):
    return turn(a, b, c) == 0 and all(min(x, y) <= z <= max(x, y) for x, y, z in zip(a, b, c))


def check(points, mesh):
    rep = [points.index(p) for p in points]
    assert mesh['representative'] == rep
    vertices = sorted(set(rep))
    edges = {tuple(sorted(e)) for e in mesh['edges']}
    assert len(edges) == len(mesh['edges'])
    assert all(a in vertices and b in vertices and a != b for a, b in edges)
    for a, b in edges:
        assert all(not on_segment(points[a], points[b], points[c]) for c in vertices if c not in (a, b))
    for (a, b), (c, d) in itertools.combinations(edges, 2):
        if len({a, b, c, d}) < 4:
            continue
        p, q, r, s = (points[i] for i in (a, b, c, d))
        assert not (turn(p, q, r)*turn(p, q, s) < 0 and turn(r, s, p)*turn(r, s, q) < 0)
        assert not any((on_segment(p, q, r), on_segment(p, q, s), on_segment(r, s, p), on_segment(r, s, q)))
    triangles = {tuple(t) for t in mesh['triangles']}
    assert len(triangles) == len(mesh['triangles'])
    incidence = dict.fromkeys(edges, 0)
    for a, b, c in triangles:
        assert all(v in vertices for v in (a, b, c)) and a == min(a, b, c)
        assert turn(points[a], points[b], points[c]) > 0
        for u, v in ((a, b), (b, c), (c, a)):
            incidence[tuple(sorted((u, v)))] += 1
        # 3点の等距離方程式から有理数の外心を求める。実装のinCircle式には依存しない。
        p, q, r = (points[i] for i in (a, b, c))
        x, y = q[0]-p[0], q[1]-p[1]
        z, w = r[0]-p[0], r[1]-p[1]
        cx = Fraction((x*x+y*y)*w - (z*z+w*w)*y, 2*(x*w-y*z)) + p[0]
        cy = Fraction(x*(z*z+w*w) - z*(x*x+y*y), 2*(x*w-y*z)) + p[1]
        radius = (cx-p[0])**2 + (cy-p[1])**2
        assert all((cx-points[v][0])**2 + (cy-points[v][1])**2 >= radius for v in vertices)
    collinear = len(vertices) < 3 or all(turn(points[vertices[0]], points[vertices[1]], points[v]) == 0 for v in vertices)
    if collinear:
        ordered = sorted(vertices, key=lambda v: points[v])
        assert edges == {tuple(sorted(e)) for e in zip(ordered, ordered[1:])}
        assert not triangles
    else:
        assert all(count in (1, 2) for count in incidence.values())
        boundary = [e for e in edges if incidence[e] == 1]
        assert len(vertices) - len(edges) + len(triangles) == 1
        assert len(edges) == 3*len(vertices)-3-len(boundary)
        assert len(triangles) == 2*len(vertices)-2-len(boundary)
        for a, b in boundary:
            sides = [turn(points[a], points[b], points[v]) for v in vertices]
            assert not (min(sides) < 0 < max(sides))
    # 全点対Kruskal。重複座標も独立した頂点として検証する。
    parent = list(range(len(points)))

    def root(a):
        while parent[a] != a:
            parent[a] = parent[parent[a]]
            a = parent[a]
        return a

    expected = []
    for weight, a, b in sorted((distance(points[a], points[b]), a, b) for a in range(len(points)) for b in range(a)):
        a, b = root(a), root(b)
        if a != b:
            parent[a] = b
            expected.append(weight)
    parent[:] = range(len(points))
    actual = []
    assert len(mesh['mst']) == max(0, len(points)-1)
    for a, b in mesh['mst']:
        assert 0 <= a < b < len(points)
        assert root(a) != root(b)
        parent[root(a)] = root(b)
        actual.append(distance(points[a], points[b]))
    assert sorted(actual) == expected
    if vertices:
        parent[:] = range(len(points))
        for a, b in edges:
            parent[root(a)] = root(b)
        assert len({root(v) for v in vertices}) == 1


def cases():
    bound = 10**9
    yield []
    yield [(0, 0)]
    yield [(bound, bound), (-bound, -bound)]
    yield [(7, -11)]*20
    corners = [(-bound, -bound), (-bound, bound), (bound, -bound), (bound, bound)]
    for p in itertools.permutations(corners):
        yield list(p)
    yield corners + [(0, 0), (bound-1, bound-2), (-bound+1, -bound+2), (0, 0)]
    yield [(-bound, -bound), (bound, bound), (bound-1, bound-2), (bound-2, bound-3), (0, 0), (-1, -1)]
    rng = random.Random(20261002)
    circle = [(x, y) for x in range(-65, 66) for y in range(-65, 66) if x*x+y*y == 65**2]
    for scale in (1, 10**7):
        p = [(scale*x, scale*y) for x, y in circle]
        for _ in range(4):
            rng.shuffle(p)
            yield p.copy()
        yield p + [(0, 0), p[0]]
    for dx, dy in ((0, 1), (1, 0), (1, 1), (2, -3)):
        p = [(dx*i, dy*i) for i in range(-20, 21)]
        rng.shuffle(p)
        yield p + [p[0]]
    for trial in range(220):
        n = rng.randrange(0, 36)
        limit = (5, 1000, bound)[trial % 3]
        p = [(rng.randint(-limit, limit), rng.randint(-limit, limit)) for _ in range(n)]
        if trial % 7 == 0:
            p = [(rng.choice((-bound, -bound+1, 0, bound-1, bound)), rng.choice((-bound, -bound+1, 0, bound-1, bound))) for _ in range(n)]
        yield p


def run(command, **kwargs):
    result = subprocess.run(command, text=True, capture_output=True, **kwargs)
    if result.returncode:
        raise RuntimeError(result.stdout + result.stderr)
    return result.stdout


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--nim', default='nim')
    parser.add_argument('--baseline', type=Path, help='切り出し前のeuclidean_mst.nimを指定すると出力列も比較する')
    args = parser.parse_args()
    inputs = list(cases())
    data = ''.join(json.dumps(p)+'\n' for p in inputs)
    with tempfile.TemporaryDirectory() as directory:
        tmp = Path(directory)
        if args.baseline:
            source = args.baseline.read_text().replace('CPLIB_GEOMETRY_EUCLIDEAN_MST', 'CPLIB_GEOMETRY_BASELINE_MST').replace('euclidean_mst*', 'baseline_mst*').replace('euclidean_mst(converted)', 'baseline_mst(converted)')
            (tmp/'baseline.nim').write_text(source)
            driver = (ROOT/'tools/geometry/delaunay_oracle_driver.nim').read_text()
            driver = driver.replace('import cplib/geometry/euclidean_mst', 'import baseline').replace('euclidean_mst(points)', 'baseline_mst(points)')
            (tmp/'baseline_driver.nim').write_text(driver)
        for mode in ('debug', 'release'):
            flags = ['-d:release'] if mode == 'release' else []
            binary = tmp/mode
            run([args.nim, 'cpp', '--hints:off', '--path:'+str(ROOT/'src'), '--nimcache:'+str(tmp/('cache-'+mode)), '--out:'+str(binary), *flags, str(ROOT/'tools/geometry/delaunay_oracle_driver.nim')], cwd=ROOT)
            outputs = [json.loads(line) for line in run([str(binary)], input=data).splitlines()]
            assert len(outputs) == len(inputs)
            for invalid in ([[10**9+1, 0]], [[0, -10**9-1]]):
                rejected = subprocess.run([str(binary)], input=json.dumps(invalid)+'\n', text=True, capture_output=True)
                assert rejected.returncode != 0
            for i, (points, mesh) in enumerate(zip(inputs, outputs)):
                try:
                    check(points, mesh)
                except (AssertionError, KeyError):
                    raise AssertionError(f'{mode} case {i}: {points}; {mesh}') from None
            if args.baseline:
                old = tmp/('baseline-'+mode)
                run([args.nim, 'cpp', '--hints:off', '--path:'+str(ROOT/'src'), '--nimcache:'+str(tmp/('cache-baseline-'+mode)), '--out:'+str(old), *flags, str(tmp/'baseline_driver.nim')], cwd=ROOT)
                baseline = [json.loads(line) for line in run([str(old)], input=data).splitlines()]
                assert [m['mst'] for m in outputs] == [m['mst'] for m in baseline]
            print(f'{mode}: {len(inputs)} cases passed (exact circle, topology, Kruskal' + (', baseline MST order)' if args.baseline else ')'))


if __name__ == '__main__':
    main()
