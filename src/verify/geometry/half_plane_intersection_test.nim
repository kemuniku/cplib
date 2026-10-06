# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/half_plane_intersection
import cplib/math/fractions
import algorithm, random, math

type
    IPoint = tuple[x, y: int64]
    ILine = tuple[s, t: IPoint]
    Rational = Fraction[int64]
    RPoint = tuple[x, y: Rational]

proc toLine(l: ILine): Line[float] =
    Line[float](s: Point[float](x: float(l.s.x), y: float(l.s.y)),
        t: Point[float](x: float(l.t.x), y: float(l.t.y)))

proc cross(a, b: IPoint): int64 = a.x*b.y - a.y*b.x
proc direction(l: ILine): IPoint = (l.t.x-l.s.x, l.t.y-l.s.y)
proc feasible(lines: seq[ILine], p: RPoint): bool =
    for l in lines:
        let d = direction(l)
        if d.x*(p.y-l.s.y) - d.y*(p.x-l.s.x) < 0: return false
    true
proc same(a, b: RPoint): bool = a.x == b.x and a.y == b.y
proc oracle(lines: seq[ILine]): tuple[kind: HalfPlaneIntersectionKind, dimension: int, vertices: seq[RPoint]] =
    var candidates: seq[RPoint] = @[(initFraction(0'i64), initFraction(0'i64))]
    var rays: seq[IPoint]
    var directions: seq[IPoint] = @[(1'i64,0'i64),(-1'i64,0'i64),(0'i64,1'i64),(0'i64,-1'i64)]
    for i, l in lines:
        let d = direction(l)
        directions.add(d)
        directions.add((-d.x,-d.y))
        let c = cross(d, l.s)
        let norm = d.x*d.x+d.y*d.y
        candidates.add((initFraction(-d.y*c, norm), initFraction(d.x*c, norm)))
        for j in 0..<i:
            let e = direction(lines[j])
            let determinant = cross(d,e)
            if determinant == 0: continue
            let f = cross(e, lines[j].s)
            let p: RPoint = (initFraction(c*e.x-d.x*f, determinant),
                initFraction(e.y*c-d.y*f, determinant))
            candidates.add(p)
            if feasible(lines, p):
                var duplicate = false
                for q in result.vertices:
                    if same(p,q): duplicate = true
                if not duplicate: result.vertices.add(p)
    var points: seq[RPoint]
    for p in candidates:
        if feasible(lines,p): points.add(p)
    if points.len == 0:
        result.kind = hpiEmpty
        result.dimension = -1
        return
    for d in directions:
        var valid = true
        for l in lines:
            if cross(direction(l),d) < 0: valid = false
        if valid: rays.add(d)
    result.kind = if rays.len == 0: hpiBounded else: hpiUnbounded
    var spans: seq[RPoint]
    for p in points: spans.add((p.x-points[0].x, p.y-points[0].y))
    for d in rays: spans.add((initFraction(d.x), initFraction(d.y)))
    for a in spans:
        if a.x == 0 and a.y == 0: continue
        result.dimension = max(result.dimension, 1)
        for b in spans:
            if a.x*b.y-a.y*b.x != 0: result.dimension = 2

proc asFloat(a: Rational): float = float(a.num) / float(a.den)
proc near(a, b: float): bool = abs(a-b) <= 1e-8 * max(1.0, max(abs(a),abs(b)))
proc check(lines: seq[ILine], checkFloat = true) =
    var input: seq[Line[float]]
    for l in lines: input.add(toLine(l))
    let expected = oracle(lines)
    var rationalInput: seq[Line[Rational]]
    for l in lines:
        rationalInput.add(Line[Rational](s: Point[Rational](x: initFraction(l.s.x), y: initFraction(l.s.y)),
            t: Point[Rational](x: initFraction(l.t.x), y: initFraction(l.t.y))))
    let exact = half_plane_intersection(rationalInput)
    doAssert exact.kind == expected.kind, $lines
    doAssert exact.dimension == expected.dimension, $lines
    doAssert exact.vertices.len == expected.vertices.len, $lines
    for p in exact.vertices:
        var found = false
        for q in expected.vertices:
            if p.x == q.x and p.y == q.y: found = true
        doAssert found, $lines
        doAssert exact.contains(p)
    for x in -3..3:
        for y in -3..3:
            doAssert exact.contains(Point[Rational](x: initFraction(int64(x)), y: initFraction(int64(y)))) ==
                feasible(lines,(initFraction(int64(x)),initFraction(int64(y))))
    var exactReversed = rationalInput
    exactReversed.reverse()
    let exactOther = half_plane_intersection(exactReversed)
    doAssert exact.kind == exactOther.kind and exact.dimension == exactOther.dimension
    doAssert exact.vertices.len == exactOther.vertices.len
    for i in 0..<exact.vertices.len:
        doAssert exact.vertices[i].x == exactOther.vertices[i].x
        doAssert exact.vertices[i].y == exactOther.vertices[i].y
    let duplicated = half_plane_intersection(rationalInput & rationalInput)
    doAssert exact.kind == duplicated.kind and exact.dimension == duplicated.dimension
    doAssert exact.vertices.len == duplicated.vertices.len
    for i in 0..<exact.vertices.len:
        doAssert exact.vertices[i].x == duplicated.vertices[i].x
        doAssert exact.vertices[i].y == duplicated.vertices[i].y
    if not checkFloat: return
    let actual = half_plane_intersection(input)
    doAssert actual.kind == expected.kind, $lines & " kind " & $actual.kind & " != " & $expected.kind
    doAssert actual.dimension == expected.dimension, $lines & " dimension " & $actual.dimension & " != " & $expected.dimension
    doAssert actual.constraints.len == input.len
    doAssert actual.vertices.len == expected.vertices.len, $lines & " vertices " & $actual.vertices & " expected " & $expected.vertices
    for p in expected.vertices:
        var found = false
        for q in actual.vertices:
            if near(asFloat(p.x),q.x) and near(asFloat(p.y),q.y): found = true
        doAssert found, $lines & " vertex " & $p
    if actual.kind == hpiBounded and actual.dimension == 2:
        var area = 0.0
        for i in 0..<actual.vertices.len:
            let a = actual.vertices[i]
            let b = actual.vertices[(i+1) mod actual.vertices.len]
            area += a.x*b.y-a.y*b.x
        doAssert area > 0
    var reversed = input
    reversed.reverse()
    let other = half_plane_intersection(reversed)
    doAssert actual.kind == other.kind and actual.dimension == other.dimension
    doAssert actual.vertices.len == other.vertices.len
    for i in 0..<actual.vertices.len:
        doAssert actual.vertices[i].x == other.vertices[i].x
        doAssert actual.vertices[i].y == other.vertices[i].y
    for x in -3..3:
        for y in -3..3:
            doAssert actual.contains(Point[float](x: float(x), y: float(y))) ==
                feasible(lines,(initFraction(int64(x)),initFraction(int64(y))))

proc constraint(a,b,c: int64): ILine =
    # a*x+b*y >= c。テストの係数は軸または b=+-1。
    if b == 0:
        let x = c div a
        if a > 0: ((x,1'i64),(x,0'i64))
        else: ((x,0'i64),(x,1'i64))
    else:
        let y = c div b
        let dy = -a div b
        if b > 0: ((0'i64,y),(1'i64,y+dy))
        else: ((1'i64,y+dy),(0'i64,y))

check(@[])
check(@[constraint(0,1,0)])
check(@[constraint(0,1,0),constraint(0,-1,-1)])
check(@[constraint(0,1,0),constraint(0,-1,0)])
check(@[constraint(0,1,1),constraint(0,-1,0)])
check(@[constraint(1,0,0),constraint(-1,0,0)])
check(@[constraint(1,0,0),constraint(-1,0,0),constraint(0,1,0)])
check(@[constraint(1,0,0),constraint(-1,0,0),constraint(0,1,0),constraint(0,-1,-2)])
check(@[constraint(1,0,0),constraint(-1,0,0),constraint(0,1,0),constraint(0,-1,0)])
check(@[constraint(0,1,0),constraint(0,-1,0),constraint(1,0,0)])
check(@[constraint(0,1,0),constraint(0,-1,0),constraint(1,0,0),constraint(-1,0,-2)])
check(@[constraint(-1,1,0),constraint(1,-1,0),constraint(1,0,-2),constraint(-1,0,-3)])
check(@[constraint(1,1,0),constraint(-1,1,0),constraint(0,-1,0)])
check(@[constraint(1,1,1),constraint(-1,1,1),constraint(0,-1,0)])
check(@[constraint(1,0,0),constraint(-1,0,-3),constraint(0,1,0),constraint(0,-1,-2)])
check(@[constraint(0,1,0),constraint(0,1,0),constraint(0,1,1),constraint(0,1,-1)])

var rng = initRand(20261002)
for iteration in 0..<2000:
    var lines: seq[ILine]
    for i in 0..<rng.rand(0..10):
        let a = int64(rng.rand(-3..3))
        let b = int64(rng.rand(-1..1))
        if a == 0 and b == 0: continue
        let c = int64(rng.rand(-4..4)) * (if b == 0: abs(a) else: 1'i64)
        lines.add(constraint(a,b,c))
        if rng.rand(0..4) == 0: lines.add(lines[^1])
    check(lines)

for iteration in 0..<2000:
    var lines: seq[ILine]
    for i in 0..<rng.rand(0..10):
        let s: IPoint = (int64(rng.rand(-3..3)),int64(rng.rand(-3..3)))
        let t: IPoint = (int64(rng.rand(-3..3)),int64(rng.rand(-3..3)))
        if s != t: lines.add((s,t))
    check(lines, false)

proc clip(poly: seq[RPoint], line: ILine): seq[RPoint] =
    let d = direction(line)
    proc side(p: RPoint): Rational = d.x*(p.y-line.s.y)-d.y*(p.x-line.s.x)
    for i in 0..<poly.len:
        let p = poly[i]
        let q = poly[(i+1) mod poly.len]
        let a = side(p)
        let b = side(q)
        if a >= 0: result.add(p)
        if (a < 0 and b > 0) or (a > 0 and b < 0):
            let t = a/(a-b)
            result.add((p.x+(q.x-p.x)*t,p.y+(q.y-p.y)*t))
    var unique: seq[RPoint]
    for p in result:
        if unique.len == 0 or not same(unique[^1],p): unique.add(p)
    if unique.len > 1 and same(unique[0],unique[^1]): discard unique.pop()
    result = unique

for iteration in 0..<400:
    var lines = @[constraint(1,0,-8),constraint(-1,0,-8),
        constraint(0,1,-8),constraint(0,-1,-8)]
    var poly: seq[RPoint] = @[
        (initFraction(-8'i64),initFraction(-8'i64)),
        (initFraction(8'i64),initFraction(-8'i64)),
        (initFraction(8'i64),initFraction(8'i64)),
        (initFraction(-8'i64),initFraction(8'i64))]
    for i in 0..<rng.rand(0..8):
        let a = int64(rng.rand(-3..3))
        let b = int64(rng.rand(-1..1))
        if a == 0 and b == 0: continue
        let c = int64(rng.rand(-4..4)) * (if b == 0: abs(a) else: 1'i64)
        let l = constraint(a,b,c)
        lines.add(l)
        poly = clip(poly,l)
    let expected = oracle(lines)
    doAssert (poly.len == 0) == (expected.kind == hpiEmpty)
    for p in expected.vertices:
        var found = false
        for q in poly:
            if same(p,q): found = true
        doAssert found
    for p in poly: doAssert feasible(lines,p)
    check(lines)

# 非二進分数の境界でできる一点は Fraction API で厳密に分類する。
check(@[
    ((0'i64,0'i64),(-1'i64,2'i64)),
    ((-2'i64,-3'i64),(0'i64,2'i64)),
    ((-1'i64,-2'i64),(-3'i64,3'i64)),
    ((-3'i64,1'i64),(2'i64,1'i64)),
    ((-2'i64,-2'i64),(2'i64,-3'i64)),
    ((2'i64,0'i64),(-3'i64,3'i64)),
    ((2'i64,-2'i64),(3'i64,-3'i64)),
    ((-2'i64,0'i64),(-2'i64,3'i64))], false)

let square32 = half_plane_intersection(@[
    Line[float32](s: Point[float32](x: 0,y: 0),t: Point[float32](x: 1,y: 0)),
    Line[float32](s: Point[float32](x: 1,y: 0),t: Point[float32](x: 1,y: 1)),
    Line[float32](s: Point[float32](x: 1,y: 1),t: Point[float32](x: 0,y: 1)),
    Line[float32](s: Point[float32](x: 0,y: 1),t: Point[float32](x: 0,y: 0))])
doAssert square32.kind == hpiBounded and square32.dimension == 2
doAssert square32.vertices.len == 4

let oneThird = initFraction(1'i64,3'i64)
let twoThirds = initFraction(2'i64,3'i64)
let fractionalSquare = @[
    Point[Rational](x: oneThird,y: oneThird),
    Point[Rational](x: twoThirds,y: oneThird),
    Point[Rational](x: twoThirds,y: twoThirds),
    Point[Rational](x: oneThird,y: twoThirds)]
var fractionalLines: seq[Line[Rational]]
for i in 0..<4:
    fractionalLines.add(Line[Rational](s: fractionalSquare[i],t: fractionalSquare[(i+1) mod 4]))
let fractionalResult = half_plane_intersection(fractionalLines)
doAssert fractionalResult.kind == hpiBounded and fractionalResult.dimension == 2
doAssert fractionalResult.vertices.len == 4
for p in fractionalResult.vertices:
    doAssert (p.x == oneThird or p.x == twoThirds) and (p.y == oneThird or p.y == twoThirds)
    doAssert fractionalResult.contains(p)
for badFraction in [Fraction[int64](num: 1,den: 0),Fraction[int64](num: 1,den: -1)]:
    var raised = false
    try:
        discard half_plane_intersection(@[Line[Rational](
            s: Point[Rational](x: badFraction,y: oneThird),t: fractionalSquare[1])])
    except ValueError: raised = true
    doAssert raised

let tiny = 1e-12
let narrow = half_plane_intersection(@[
    Line[float](s: Point[float](x: 0, y: 0), t: Point[float](x: 1, y: 0)),
    Line[float](s: Point[float](x: 1, y: tiny), t: Point[float](x: 0, y: tiny))])
doAssert narrow.kind == hpiUnbounded and narrow.dimension == 2
let nearParallel = half_plane_intersection(@[
    Line[float](s: Point[float](x: 0, y: 0), t: Point[float](x: 1, y: 0)),
    Line[float](s: Point[float](x: 1, y: 1-tiny), t: Point[float](x: 0, y: 1))])
doAssert nearParallel.kind == hpiUnbounded and nearParallel.dimension == 2
doAssert nearParallel.vertices.len == 1 and nearParallel.vertices[0].x > 1e11

for bad in @[
    Line[float](s: Point[float](x: 0,y: 0), t: Point[float](x: 0,y: 0)),
    Line[float](s: Point[float](x: NaN,y: 0), t: Point[float](x: 1,y: 1)),
    Line[float](s: Point[float](x: 0,y: 0), t: Point[float](x: system.Inf,y: 1)),
    Line[float](s: Point[float](x: -1e308,y: 0), t: Point[float](x: 1e308,y: 1)),
    Line[float](s: Point[float](x: 0,y: 0), t: Point[float](x: 1e-308,y: 1e308))]:
    var raised = false
    try: discard half_plane_intersection(@[bad])
    except ValueError: raised = true
    doAssert raised

var large: seq[Line[float]]
for i in 0..<20000:
    large.add(toLine(constraint(0,1,int64(i))))
let largeResult = half_plane_intersection(large)
doAssert largeResult.kind == hpiUnbounded and largeResult.dimension == 2

var staircase: seq[Line[float]]
for i in 0..<20000:
    let k = float(i)
    staircase.add(Line[float](s: Point[float](x: 0,y: -k*k),
        t: Point[float](x: 1,y: k-k*k)))
let stairs = half_plane_intersection(staircase)
doAssert stairs.kind == hpiUnbounded and stairs.dimension == 2
doAssert stairs.vertices.len == 19999

echo "Hello World"
