# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/geometry/convex_polygon
import cplib/math/fractions
import algorithm, options, random, sequtils

type IP = Point[int]
proc turn[T](a, b, c: Point[T]): T = cross(b-a, c-a)
proc equalSeq[T](a, b: seq[Point[T]]): bool =
    if a.len != b.len: return false
    for i in 0..<a.len:
        if a[i].x != b[i].x or a[i].y != b[i].y: return false
    true
proc less[T](a, b: Point[T]): bool = a.x < b.x or (a.x == b.x and a.y < b.y)
proc equal[T](a, b: Point[T]): bool = a.x == b.x and a.y == b.y
proc hull[T](points: seq[Point[T]]): seq[Point[T]] =
    var sorted = points
    sorted.sort(proc(a, b: Point[T]): int = (if less(a,b): -1 elif less(b,a): 1 else: 0))
    var unique: seq[Point[T]]
    for p in sorted:
        if unique.len == 0 or not equal(unique[^1],p): unique.add(p)
    if unique.len < 2: return unique
    let zero = unique[0].x - unique[0].x
    var lower, upper: seq[Point[T]]
    for p in unique:
        while lower.len >= 2 and turn(lower[^2], lower[^1], p) <= zero: discard lower.pop()
        lower.add(p)
    for i in countdown(unique.high, 0):
        let p = unique[i]
        while upper.len >= 2 and turn(upper[^2], upper[^1], p) <= zero: discard upper.pop()
        upper.add(p)
    lower.setLen(lower.len-1)
    upper.setLen(upper.len-1)
    lower & upper
proc linear[T](vertices: seq[Point[T]], p: Point[T]): int =
    if vertices.len == 0: return -1
    if vertices.len == 1: return (if equal(vertices[0],p): 0 else: -1)
    let zero = p.x - p.x
    if vertices.len == 2:
        return (if turn(vertices[0],vertices[1],p) == zero and dot(p-vertices[0],p-vertices[1]) <= zero: 0 else: -1)
    var boundary = false
    for i in 0..<vertices.len:
        let c = turn(vertices[i],vertices[(i+1) mod vertices.len],p)
        if c < zero: return -1
        if c == zero: boundary = true
    if boundary: 0 else: 1
proc check[T](vertices, queries: seq[Point[T]]) =
    let before = vertices
    let cp = initConvexPolygon(initPolygon(vertices))
    doAssert equalSeq(vertices, before)
    let normalized = cp.toSeq
    doAssert equalSeq(normalized, hull(vertices))
    var copied = cp.toPolygon
    if copied.len > 0: copied.v[0] = initPoint(copied.v[0].x + copied.v[0].x, copied.v[0].y + copied.v[0].y)
    doAssert equalSeq(cp.toSeq, normalized)
    for p in queries:
        let loc = linear(normalized, p)
        doAssert cp.contains(p) == (loc >= 0)
        doAssert cp.contains(p, true) == (loc > 0)
        doAssert cp.on_edge(p) == (loc == 0)
    let answer = cp.diameter
    doAssert answer.isSome == (vertices.len > 0)
    doAssert initPolygon(vertices).diameter.isSome == answer.isSome
    if answer.isSome:
        let d = answer.get
        var naive = norm(vertices[0]-vertices[0])
        for a in vertices:
            for b in vertices:
                naive = max(naive, norm(a-b))
        doAssert d.distance_sq == naive
        doAssert norm(d.endpoints[0]-d.endpoints[1]) == naive
        doAssert d.endpoints[0] in vertices and d.endpoints[1] in vertices
proc variants[T](vertices, queries: seq[Point[T]]) =
    if vertices.len == 0: check(vertices, queries)
    for reverse in [false, true]:
        for offset in 0..<max(1,vertices.len):
            var v = vertices
            if reverse: v.reverse()
            if v.len > 0: v = v[offset..^1] & v[0..<offset]
            check(v, queries)
            var duplicates: seq[Point[T]]
            for p in v: duplicates.add(p); duplicates.add(p)
            if v.len > 0: duplicates.add(v[0])
            check(duplicates, queries)
proc rational(v: seq[IP]): seq[Point[Fraction[int]]] =
    for p in v: result.add(initPoint(initFraction(p.x),initFraction(p.y)))
proc floating(v: seq[IP]): seq[Point[float]] =
    for p in v: result.add(initPoint(float(p.x),float(p.y)))

var grid, queries: seq[IP]
for x in 0..2:
    for y in 0..2: grid.add(initPoint(x*2,y*2))
for x in -1..5:
    for y in -1..5: queries.add(initPoint(x,y))
for mask in 0..<(1 shl grid.len):
    var points: seq[IP]
    for i in 0..<grid.len:
        if (mask and (1 shl i)) != 0: points.add(grid[i])
    let h = hull(points)
    variants(h, queries)
    check(floating(h),floating(queries))
    check(rational(h),rational(queries))
    var weak: seq[IP]
    for i, p in h:
        weak.add(p)
        if h.len >= 2:
            let q = h[(i+1) mod h.len]
            weak.add(initPoint((p.x+q.x) div 2,(p.y+q.y) div 2))
    if h.len >= 3: variants(weak,queries)

var rng = initRand(903247)
for trial in 0..<300:
    var points: seq[IP]
    for i in 0..<rng.rand(1..30): points.add(initPoint(rng.rand(-20..20),rng.rand(-20..20)))
    let h = hull(points)
    var q = h
    for i in 0..<50: q.add(initPoint(rng.rand(-25..25),rng.rand(-25..25)))
    check(h,q)
    check(h.reversed,q)
    check(floating(h),floating(q))
    check(rational(h),rational(q))

variants(@[initPoint(3,0),initPoint(-1,0),initPoint(1,0),initPoint(3,0)],queries)
variants(@[initPoint(1,1),initPoint(1,1),initPoint(1,1)],queries)
for scale in [1'i32, 2'i32]:
    let f = initFraction(scale)
    let z = initFraction(0'i32)
    check(@[initPoint(z,z),initPoint(f,z),initPoint(z,f)],@[initPoint(z,z),initPoint(f,f)])
check(@[initPoint(0'f32,0'f32),initPoint(2'f32,0'f32),initPoint(0'f32,2'f32)],
    @[initPoint(0'f32,0'f32),initPoint(0.5'f32,0.5'f32)])
check(@[initPoint(0'i64,0'i64),initPoint(2'i64,0'i64),initPoint(0'i64,2'i64)],
    @[initPoint(0'i64,0'i64),initPoint(1'i64,1'i64)])
check(@[initPoint(initFraction(0'i64),initFraction(0'i64))],
    @[initPoint(initFraction(0'i64),initFraction(1'i64))])

block:
    var v: seq[IP]
    for i in 0..<20000: v.add(initPoint(i,0))
    let cp = initConvexPolygon(v)
    doAssert cp.len == 2
    for i in 0..<20000: doAssert cp.contains(initPoint(i,0))
    v[0] = initPoint(-100,-100)
    doAssert cp.toSeq[0] == initPoint(0,0)
block:
    var parabola: seq[IP]
    for i in -400..400: parabola.add(initPoint(i,i*i))
    let cp = initConvexPolygon(parabola)
    doAssert cp.len == parabola.len
    for i in -400..400:
        doAssert cp.on_edge(initPoint(i,i*i))
        doAssert not cp.contains(initPoint(i,i*i),true)
    for i in 0..<10000: doAssert cp.contains(initPoint(0,100))

block:
    let z = initFraction(0)
    let one = initFraction(1)
    let third = initFraction(1,3)
    let half = initFraction(1,2)
    variants(@[initPoint(z,z),initPoint(one,z),initPoint(one,one),initPoint(z,one)],
        @[initPoint(third,third),initPoint(half,z),initPoint(one,third),initPoint(one+third,half)])
block:
    let cp = initConvexPolygon(@[initPoint(0.0,0.0),initPoint(1.0,0.0),initPoint(1.0,1.0),initPoint(0.0,1.0)])
    let near = initPoint(0.5,-GEOMETRY_EPS/4.0)
    doAssert cp.on_edge(near)
    doAssert cp.contains(near)
    doAssert not cp.contains(near,true)
    doAssert not cp.contains(initPoint(0.5,-GEOMETRY_EPS*4.0))

static:
    doAssert not compiles(convex_cut(initPolygon(@[initPoint(0,0)]),initLine(initPoint(0,0),initPoint(1,0))))
echo "Hello World"
