# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/geometry/convex_polygon
import cplib/math/fractions
import algorithm, random, sequtils

type F = Fraction[int]
type FP = Point[F]
proc point(x,y: int): FP = initPoint(initFraction(x),initFraction(y))
proc turn(a,b,c: FP): F = cross(b-a,c-a)
proc eq(a,b: FP): bool = a.x == b.x and a.y == b.y
proc equalSeq(a,b: seq[FP]): bool =
    if a.len != b.len: return false
    for i in 0..<a.len:
        if not eq(a[i],b[i]): return false
    true
proc hull(points: seq[FP]): seq[FP] =
    var points = points
    points.sort(proc(a,b: FP): int =
        if a.x < b.x or (a.x == b.x and a.y < b.y): -1
        elif eq(a,b): 0
        else: 1)
    var unique: seq[FP]
    for p in points:
        if unique.len == 0 or not eq(unique[^1],p): unique.add(p)
    if unique.len < 2: return unique
    var lower,upper: seq[FP]
    for p in unique:
        while lower.len >= 2 and turn(lower[^2],lower[^1],p) <= 0: discard lower.pop()
        lower.add(p)
    for i in countdown(unique.high,0):
        let p = unique[i]
        while upper.len >= 2 and turn(upper[^2],upper[^1],p) <= 0: discard upper.pop()
        upper.add(p)
    lower.setLen(lower.len-1)
    upper.setLen(upper.len-1)
    lower & upper
proc areaTwice(v: seq[FP]): F =
    result = initFraction(0)
    for i in 0..<v.len:
        result += cross(v[i],v[(i+1) mod v.len])
        result.reduce()
proc oracle(v: seq[FP], line: Line[F]): seq[FP] =
    var candidates: seq[FP]
    let a = line.t.y-line.s.y
    let b = line.s.x-line.t.x
    let c = a*line.s.x+b*line.s.y
    for i,p in v:
        let q = v[(i+1) mod v.len]
        let sp = turn(line.s,line.t,p)
        let sq = turn(line.s,line.t,q)
        if sp >= 0: candidates.add(p)
        if (sp < 0 and sq > 0) or (sp > 0 and sq < 0):
            let d = q.y-p.y
            let e = p.x-q.x
            let f = d*p.x+e*p.y
            let determinant = a*e-b*d
            var x = (c*e-b*f)/determinant
            var y = (a*f-c*d)/determinant
            x.reduce(); y.reduce()
            candidates.add(initPoint(x,y))
    hull(candidates)
proc floating(v: seq[FP]): seq[Point[float]] =
    for p in v: result.add(initPoint(p.x.toFloat,p.y.toFloat))
proc floatInside(v: seq[Point[float]], p: Point[float]): bool =
    if v.len == 0: return false
    if v.len == 1: return norm(v[0]-p) < 1e-16
    if v.len == 2:
        return abs(cross(v[1]-v[0],p-v[0])) < 1e-8 and dot(p-v[0],p-v[1]) <= 1e-8
    for i in 0..<v.len:
        if cross(v[(i+1) mod v.len]-v[i],p-v[i]) < -1e-8: return false
    true
proc check(v: seq[FP], line: Line[F]) =
    let before = v
    let clipped = convex_cut(initPolygon(v),line)
    doAssert equalSeq(v,before)
    let expected = oracle(v,line)
    doAssert equalSeq(hull(clipped.v),expected)
    for p in clipped:
        doAssert turn(line.s,line.t,p) >= 0
        doAssert initConvexPolygon(v).contains(p)
    doAssert abs(areaTwice(clipped.v)) == abs(areaTwice(expected))
    let complement = convex_cut(initPolygon(v),initLine(line.t,line.s))
    doAssert abs(areaTwice(clipped.v))+abs(areaTwice(complement.v)) == abs(areaTwice(v))
    if v.len >= 3 and areaTwice(v) != 0 and areaTwice(clipped.v) != 0:
        doAssert (areaTwice(v) > 0) == (areaTwice(clipped.v) > 0)
    doAssert equalSeq(hull(convex_cut(clipped,line).v),expected)
    doAssert equalSeq(hull(convex_cut(initConvexPolygon(v),line).v),expected)
    let fv = floating(v)
    let fl = initLine(initPoint(line.s.x.toFloat,line.s.y.toFloat),initPoint(line.t.x.toFloat,line.t.y.toFloat))
    let actual = convex_cut(initPolygon(fv),fl)
    let fnormal = initConvexPolygon(actual).toSeq
    let enormal = floating(expected)
    for p in fnormal:
        doAssert floatInside(enormal,p)
        doAssert cross(fl.vector,p-fl.s) >= -1e-8
    for p in enormal: doAssert floatInside(fnormal,p)
    doAssert abs(abs(actual.area)*2.0-abs(areaTwice(expected)).toFloat) < 1e-8

var grid: seq[FP]
for x in 0..2:
    for y in 0..2: grid.add(point(x,y))
var lines: seq[Line[F]]
for x in -1..3:
    lines.add(initLine(point(x,-2),point(x,4)))
    lines.add(initLine(point(-2,x),point(4,x)))
for i in -2..4: lines.add(initLine(point(-2,-2+i),point(4,4+i)))
lines.add(initLine(point(-2,4),point(4,-2)))
for mask in 0..<(1 shl grid.len):
    var points: seq[FP]
    for i in 0..<grid.len:
        if (mask and (1 shl i)) != 0: points.add(grid[i])
    let v = hull(points)
    for line in lines:
        check(v,line)
        check(v.reversed,line)
        check(v,initLine(line.t,line.s))

var rng = initRand(573291)
for trial in 0..<200:
    var points: seq[FP]
    for i in 0..<rng.rand(1..12): points.add(point(rng.rand(-3..3),rng.rand(-3..3)))
    let v = hull(points)
    var a = point(rng.rand(-4..4),rng.rand(-4..4))
    var b = point(rng.rand(-4..4),rng.rand(-4..4))
    if eq(a,b): b = point(5,5)
    check(v,initLine(a,b))
    if v.len > 0: check(v[1..^1] & @[v[0]],initLine(a,b))

let square = @[point(0,0),point(1,0),point(2,0),point(2,2),point(0,2),point(0,0)]
for line in lines: check(square,line)
for v in [@[point(1,1),point(1,1),point(1,1)],@[point(2,0),point(0,0),point(1,0),point(2,0)]]:
    for line in lines: check(v,line)
block:
    let triangle = @[point(0,0),point(3,0),point(0,3)]
    let line = initLine(point(0,1),point(2,0))
    let expected = @[point(0,1),point(2,0),point(3,0),point(0,3)]
    doAssert equalSeq(hull(convex_cut(initPolygon(triangle),line).v),hull(expected))
block:
    let z = initFraction(0'i32)
    let one = initFraction(1'i32)
    let two = initFraction(2'i32)
    let poly = initPolygon(@[initPoint(z,z),initPoint(two,z),initPoint(z,two)])
    let clipped = convex_cut(poly,initLine(initPoint(one,z),initPoint(one,two)))
    doAssert clipped.len == 4
    for p in clipped: doAssert p.x <= one
block:
    let poly = initPolygon(@[initPoint(0'f32,0'f32),initPoint(2'f32,0'f32),initPoint(0'f32,2'f32)])
    doAssert convex_cut(poly,initLine(initPoint(1'f32,0'f32),initPoint(1'f32,2'f32))).len == 4
block:
    let z = initFraction(0'i64)
    let one = initFraction(1'i64)
    let poly = initPolygon(@[initPoint(z,z),initPoint(one,z)])
    doAssert convex_cut(poly,initLine(initPoint(z,z),initPoint(z,one))).len == 1

echo "Hello World"
