# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils, sets, tables
import cplib/geometry/base
import cplib/geometry/delaunay_triangulation
import cplib/geometry/euclidean_mst
import cplib/collections/unionfind

static:
    doAssert not compiles(delaunay_triangulation([(0.0, 0.0)]))
    doAssert not compiles(delaunay_triangulation([(0'u64, 0'u64)]))

type P = (int64, int64)

proc turn(a, b, c: P): int64 =
    (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])

proc distance(a, b: P): int64 =
    (a[0] - b[0]) * (a[0] - b[0]) + (a[1] - b[1]) * (a[1] - b[1])

proc key(a, b: int): (int, int) = (min(a, b), max(a, b))

proc onSegment(a, b, p: P): bool =
    turn(a, b, p) == 0 and min(a[0], b[0]) <= p[0] and p[0] <= max(a[0], b[0]) and
        min(a[1], b[1]) <= p[1] and p[1] <= max(a[1], b[1])

proc intersects(a, b, c, d: P): bool =
    let x = turn(a, b, c)
    let y = turn(a, b, d)
    let z = turn(c, d, a)
    let w = turn(c, d, b)
    (x < 0 and y > 0 or x > 0 and y < 0) and (z < 0 and w > 0 or z > 0 and w < 0) or
        onSegment(a, b, c) or onSegment(a, b, d) or onSegment(c, d, a) or onSegment(c, d, b)

proc kruskal(points: seq[P]): seq[int64] =
    var edges: seq[(int64, int, int)]
    for i in 0..<points.len:
        for j in 0..<i:
            edges.add((distance(points[i], points[j]), i, j))
    edges.sort()
    let uf = initUnionFind(points.len)
    for (w, a, b) in edges:
        if not uf.issame(a, b):
            uf.unite(a, b)
            result.add(w)

proc check(points: seq[P]) =
    let original = points
    let mesh = delaunay_triangulation(points)
    doAssert points == original
    let objectMesh = delaunay_triangulation(points.mapIt(initPoint(it)))
    doAssert objectMesh.representative == mesh.representative
    doAssert objectMesh.edges == mesh.edges and objectMesh.triangles == mesh.triangles
    doAssert mesh.representative.len == points.len
    var vertices: seq[int]
    for i, p in points:
        var expected = i
        for j in 0..<i:
            if points[j] == p:
                expected = j
                break
        doAssert mesh.representative[i] == expected
        if expected == i:
            vertices.add(i)
    var edgeSet = initHashSet[(int, int)]()
    let uf = initUnionFind(points.len)
    for (a, b) in mesh.edges:
        doAssert 0 <= a and a < points.len and 0 <= b and b < points.len and a != b
        doAssert mesh.representative[a] == a and mesh.representative[b] == b
        doAssert key(a, b) notin edgeSet
        edgeSet.incl(key(a, b))
        uf.unite(a, b)
        for c in vertices:
            if c != a and c != b:
                doAssert not onSegment(points[a], points[b], points[c])
    for i in 0..<mesh.edges.len:
        let (a, b) = mesh.edges[i]
        for j in 0..<i:
            let (c, d) = mesh.edges[j]
            if a != c and a != d and b != c and b != d:
                doAssert not intersects(points[a], points[b], points[c], points[d]), $points
    for v in vertices:
        doAssert uf.issame(v, vertices[0])
    var collinear = true
    for v in vertices:
        if vertices.len >= 2 and turn(points[vertices[0]], points[vertices[1]], points[v]) != 0:
            collinear = false
    if collinear:
        doAssert mesh.triangles.len == 0
        doAssert mesh.edges.len == max(0, vertices.len - 1)
        vertices.sort(proc(a, b: int): int = cmp(points[a], points[b]))
        for i in 1..<vertices.len:
            doAssert key(vertices[i - 1], vertices[i]) in edgeSet
    else:
        var faceSet = initHashSet[(int, int, int)]()
        var incidence = initCountTable[(int, int)]()
        for (a, b, c) in mesh.triangles:
            doAssert a < b and a < c and a != b and b != c
            doAssert (a, b, c) notin faceSet
            faceSet.incl((a, b, c))
            doAssert turn(points[a], points[b], points[c]) > 0
            for (u, v) in [(a, b), (b, c), (c, a)]:
                doAssert key(u, v) in edgeSet
                incidence.inc(key(u, v))
            let x = points[b][0] - points[a][0]
            let y = points[b][1] - points[a][1]
            let z = points[c][0] - points[a][0]
            let w = points[c][1] - points[a][1]
            let denominator = 2 * (x * w - y * z)
            let centerX = (x * x + y * y) * w - (z * z + w * w) * y
            let centerY = x * (z * z + w * w) - z * (x * x + y * y)
            for v in vertices:
                let dx = points[v][0] - points[a][0]
                let dy = points[v][1] - points[a][1]
                doAssert denominator * (dx * dx + dy * dy) >= 2 * (centerX * dx + centerY * dy), $points
        var boundary = 0
        for edge in edgeSet:
            doAssert incidence[edge] in 1..2
            if incidence[edge] == 1:
                inc boundary
                let (a, b) = edge
                var positive, negative: bool
                for v in vertices:
                    let t = turn(points[a], points[b], points[v])
                    positive = positive or t > 0
                    negative = negative or t < 0
                doAssert not (positive and negative)
        doAssert vertices.len - mesh.edges.len + mesh.triangles.len == 1
        doAssert mesh.edges.len == 3 * vertices.len - 3 - boundary
        doAssert mesh.triangles.len == 2 * vertices.len - 2 - boundary
    var weights: seq[int64]
    for (a, b) in euclidean_mst(points):
        weights.add(distance(points[a], points[b]))
    weights.sort()
    doAssert weights == kruskal(points)

check(@[])
check(@[(4'i64, -2'i64)])
check(@[(3'i64, 4'i64), (0'i64, 0'i64)])
check(newSeqWith(30, (7'i64, -3'i64)))
check(@[(1'i64, 1'i64), (0'i64, 0'i64), (0'i64, 1'i64)])
check(@[(0'i64, 0'i64), (1'i64, 0'i64), (0'i64, 1'i64)])
check(@[(0'i64, 0'i64), (1'i64, 0'i64), (0'i64, 1'i64), (0'i64, 0'i64)])
for mask in 0..<512:
    var points: seq[P]
    for i in 0..<9:
        if (mask and (1 shl i)) != 0:
            points.add((int64(i div 3 - 1), int64(i mod 3 - 1)))
    check(points)
var rng = initRand(20261002)
for direction in [(0'i64, 1'i64), (1'i64, 0'i64), (2'i64, 3'i64), (2'i64, -3'i64)]:
    var points: seq[P]
    for i in -15..15:
        points.add((direction[0] * int64(i) + 17, direction[1] * int64(i) - 31))
    points.add(points[0])
    rng.shuffle(points)
    check(points)
block:
    var circle: seq[P]
    for x in -65..65:
        for y in -65..65:
            if x * x + y * y == 65 * 65:
                circle.add((int64(x), int64(y)))
    for repeat in 0..<10:
        rng.shuffle(circle)
        check(circle)
    circle.add((0'i64, 0'i64))
    circle.add(circle[0])
    check(circle)
for trial in 0..<1000:
    var points: seq[P]
    for i in 0..<rng.rand(0..35):
        let bound = if trial mod 2 == 0: 5 else: 1000
        points.add((int64(rng.rand(-bound..bound)), int64(rng.rand(-bound..bound))))
    check(points)
block:
    var grid: seq[P]
    for x in 0..<10:
        for y in 0..<10:
            grid.add((int64(x), int64(y)))
    rng.shuffle(grid)
    check(grid)
for triangle in [delaunay_triangulation([(0, 0), (1, 0), (0, 1)]),
        delaunay_triangulation([(0'i8, 0'i8), (1'i8, 0'i8), (0'i8, 1'i8)]),
        delaunay_triangulation([(0'i16, 0'i16), (1'i16, 0'i16), (0'i16, 1'i16)]),
        delaunay_triangulation([initPoint(0'i32, 0'i32), initPoint(1'i32, 0'i32), initPoint(0'i32, 1'i32)])]:
    doAssert triangle.triangles == @[(0, 1, 2)]
echo "Hello World"
