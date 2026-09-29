# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/geometry/base
import cplib/geometry/manhattan_mst
import cplib/collections/unionfind

proc distance(a, b: (int64, int64)): int64 =
    abs(a[0] - b[0]) + abs(a[1] - b[1])

proc naiveWeights(points: seq[(int64, int64)]): seq[int64] =
    if points.len == 0:
        return @[]
    var best = newSeqWith(points.len, high(int64))
    var used = newSeq[bool](points.len)
    best[0] = 0
    for step in 0..<points.len:
        var v = -1
        for i in 0..<points.len:
            if not used[i] and (v < 0 or best[i] < best[v]):
                v = i
        used[v] = true
        if step > 0:
            result.add(best[v])
        for i in 0..<points.len:
            if not used[i]:
                best[i] = min(best[i], distance(points[v], points[i]))
    result.sort()

proc check(points: seq[(int64, int64)]) =
    let original = points
    let edges = manhattan_mst(points)
    doAssert points == original
    doAssert edges.len == max(0, points.len - 1)
    let uf = initUnionFind(points.len)
    var weights: seq[int64]
    for (u, v) in edges:
        doAssert 0 <= u and u < v and v < points.len
        doAssert not uf.issame(u, v)
        uf.unite(u, v)
        weights.add(distance(points[u], points[v]))
    doAssert uf.count == min(1, points.len)
    weights.sort()
    doAssert weights == naiveWeights(points), $points
    doAssert manhattan_mst(points.mapIt(initPoint(it))) == edges

check(@[])
check(@[(0'i64, 0'i64)])
check(@[(0'i64, 0'i64), (3'i64, 4'i64)])
check(newSeqWith(100, (7'i64, -11'i64)))
check(@[(0'i64, 0'i64), (1'i64, 1'i64), (0'i64, 0'i64),
    (0'i64, 1'i64), (1'i64, 0'i64), (1'i64, 1'i64)])

for mask in 0..<512:
    var points: seq[(int64, int64)]
    for i in 0..<9:
        if (mask and (1 shl i)) != 0:
            points.add((int64(i div 3 - 1), int64(i mod 3 - 1)))
    check(points)

var rng = initRand(20260930)
for direction in [(0'i64, 1'i64), (1'i64, 0'i64), (1'i64, 1'i64),
        (1'i64, -1'i64), (2'i64, 3'i64), (2'i64, -3'i64)]:
    var points: seq[(int64, int64)]
    for i in -60..60:
        points.add((direction[0] * int64(i) + 17, direction[1] * int64(i) - 31))
    rng.shuffle(points)
    check(points)

const bound = high(int64) div 4
check(@[(-bound, -bound), (bound, bound)])
check(@[(-bound, -bound), (-bound, bound), (bound, -bound), (bound, bound)])
check(@[(-bound, -bound), (bound, bound), (bound - 1, bound - 2),
    (bound - 2, bound - 3), (0'i64, 0'i64), (-1'i64, -1'i64)])
for trial in 0..<1500:
    var points: seq[(int64, int64)]
    let n = rng.rand(0..70)
    for i in 0..<n:
        if trial mod 3 == 0:
            points.add((int64(rng.rand(-5..5)), int64(rng.rand(-5..5))))
        elif trial mod 3 == 1:
            points.add((int64(rng.rand(-10000..10000)), int64(rng.rand(-10000..10000))))
        else:
            points.add((int64(rng.rand(-1_000_000_000..1_000_000_000)),
                int64(rng.rand(-1_000_000_000..1_000_000_000))))
    check(points)

block:
    var grid: seq[(int64, int64)]
    for x in 0..<25:
        for y in 0..<25:
            grid.add((int64(x), int64(y)))
    rng.shuffle(grid)
    check(grid)

doAssert manhattan_mst([(0, 0), (3, 4)]) == @[(0, 1)]
doAssert manhattan_mst([initPoint(low(int32), high(int32)),
    initPoint(high(int32), low(int32))]) == @[(0, 1)]
doAssert manhattan_mst([(low(int8), high(int8)), (high(int8), low(int8))]) == @[(0, 1)]

block:
    const n = 200000
    var points = newSeq[(int64, int64)](n)
    for i in 0..<n:
        points[i] = (int64(i), -int64(i))
    rng.shuffle(points)
    let edges = manhattan_mst(points)
    doAssert edges.len == n - 1
    let uf = initUnionFind(n)
    for (u, v) in edges:
        doAssert distance(points[u], points[v]) == 2
        doAssert not uf.issame(u, v)
        uf.unite(u, v)
    doAssert uf.count == 1

echo "Hello World"
