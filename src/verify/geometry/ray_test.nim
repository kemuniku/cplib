# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, random
import cplib/geometry/base
import cplib/geometry/ray
import cplib/geometry/intersect
import cplib/geometry/distance

type
    V = tuple[x, y: int]
    Shape = object
        a, d: V
        mode: int # 0: 半直線、1: 線分、2: 直線
    Expected = object
        kind: RayIntersectionKind
        a, b: Point[float64]

proc sub(a, b: V): V = (a.x - b.x, a.y - b.y)
proc cp(a, b: V): int = a.x * b.y - a.y * b.x
proc dp(a, b: V): int = a.x * b.x + a.y * b.y
proc fp(a: V): Point[float64] = initPoint(float64(a.x), float64(a.y))
proc finish(a: Shape): V = (a.a.x + a.d.x, a.a.y + a.d.y)
proc on(a: Shape, p: V): bool =
    let delta = sub(p, a.a)
    if a.d == (0, 0): return p == a.a
    if cp(delta, a.d) != 0: return false
    let t = dp(delta, a.d)
    a.mode == 2 or (t >= 0 and (a.mode == 0 or t <= dp(a.d, a.d)))

proc oracle(a, b: Shape): Expected =
    let delta = sub(b.a, a.a)
    let den = cp(a.d, b.d)
    if den != 0:
        var t = cp(delta, b.d)
        var u = cp(delta, a.d)
        var positiveDen = den
        if positiveDen < 0:
            positiveDen = -positiveDen
            t = -t
            u = -u
        if t < 0 or (b.mode != 2 and u < 0) or (b.mode == 1 and u > positiveDen):
            return Expected(kind: rikEmpty)
        return Expected(kind: rikPoint, a: initPoint(float64(a.a.x * positiveDen + a.d.x * t) / float64(positiveDen), float64(a.a.y * positiveDen + a.d.y * t) / float64(positiveDen)))
    if b.d == (0, 0):
        if on(a, b.a): return Expected(kind: rikPoint, a: fp(b.a))
        return Expected(kind: rikEmpty)
    if cp(delta, a.d) != 0: return Expected(kind: rikEmpty)
    if b.mode == 2: return Expected(kind: rikRay, a: fp(a.a), b: fp(a.d))
    if b.mode == 0 and dp(a.d, b.d) > 0:
        return Expected(kind: rikRay, a: fp(if dp(delta, a.d) >= 0: b.a else: a.a), b: fp(a.d))
    var candidates: seq[V]
    if on(b, a.a): candidates.add(a.a)
    if on(a, b.a) and b.a notin candidates: candidates.add(b.a)
    if b.mode == 1 and on(a, finish(b)) and finish(b) notin candidates: candidates.add(finish(b))
    if candidates.len == 0: return Expected(kind: rikEmpty)
    if candidates.len == 1: return Expected(kind: rikPoint, a: fp(candidates[0]))
    var lo = candidates[0]
    var hi = candidates[0]
    for p in candidates:
        if dp(sub(p, lo), a.d) < 0: lo = p
        if dp(sub(p, hi), a.d) > 0: hi = p
    Expected(kind: rikSegment, a: fp(lo), b: fp(hi))

proc pointNorm(p: V, s: Shape): float64 =
    let delta = sub(p, s.a)
    let length = dp(s.d, s.d)
    if length == 0: return float64(dp(delta, delta))
    let projection = dp(delta, s.d)
    if s.mode != 2 and projection < 0: return float64(dp(delta, delta))
    if s.mode == 1 and projection > length:
        let diff = sub(p, finish(s))
        return float64(dp(diff, diff))
    let determinant = cp(delta, s.d)
    float64(determinant * determinant) / float64(length)

proc pairNorm(a, b: Shape): float64 =
    if oracle(a, b).kind != rikEmpty: return 0
    result = pointNorm(a.a, b)
    if b.mode != 2: result = min(result, pointNorm(b.a, a))
    if b.mode == 1: result = min(result, pointNorm(finish(b), a))

proc close(a, b: float64): bool = abs(a - b) <= 1e-8 * max(1.0, max(abs(a), abs(b)))
proc close(a, b: Point[float64]): bool = close(a.x, b.x) and close(a.y, b.y)

proc checkResult(r: RayIntersection, e: Expected) =
    doAssert r.kind == e.kind, $r.kind & " != " & $e.kind
    case r.kind
    of rikEmpty: discard
    of rikPoint: doAssert close(r.point, e.a)
    of rikSegment:
        doAssert (close(r.segment.s, e.a) and close(r.segment.t, e.b)) or
            (close(r.segment.t, e.a) and close(r.segment.s, e.b))
    of rikRay:
        doAssert close(r.ray.origin, e.a)
        doAssert abs(cross(r.ray.direction, e.b)) < 1e-8
        doAssert dot(r.ray.direction, e.b) > 0

proc checkPair(a, b: Shape) =
    let r = initRay(fp(a.a), fp(a.d))
    let e = oracle(a, b)
    let squared = pairNorm(a, b)
    case b.mode
    of 0:
        let q = initRay(fp(b.a), fp(b.d))
        checkResult(intersection(r, q), e)
        checkResult(intersection(q, r), e)
        doAssert intersect(r, q) == (e.kind != rikEmpty)
        doAssert intersect(q, r) == intersect(r, q)
        doAssert close(norm(r, q), squared)
        doAssert close(distance(r, q), sqrt(squared))
        doAssert close(distance(q, r), distance(r, q))
    of 1:
        let s = Segment[int](s: initPoint(b.a.x, b.a.y), t: initPoint(finish(b).x, finish(b).y))
        checkResult(intersection(r, s), e)
        checkResult(intersection(s, r), e)
        doAssert intersect(r, s) == (e.kind != rikEmpty)
        doAssert intersect(s, r) == intersect(r, s)
        doAssert close(norm(r, s), squared) and close(norm(s, r), squared)
        doAssert close(distance(r, s), sqrt(squared))
        doAssert close(distance(s, r), distance(r, s))
        let reversed = Segment[int](s: s.t, t: s.s)
        checkResult(intersection(r, reversed), e)
    else:
        let l = Line[int](s: initPoint(b.a.x, b.a.y), t: initPoint(finish(b).x, finish(b).y))
        checkResult(intersection(r, l), e)
        checkResult(intersection(l, r), e)
        doAssert intersect(r, l) == (e.kind != rikEmpty)
        doAssert intersect(l, r) == intersect(r, l)
        doAssert close(norm(r, l), squared) and close(norm(l, r), squared)
        doAssert close(distance(r, l), sqrt(squared))
        doAssert close(distance(l, r), distance(r, l))
        checkResult(intersection(r, Line[int](s: l.t, t: l.s)), e)

var points: seq[V]
var rays: seq[Shape]
var segments: seq[Shape]
for x in -1..1:
    for y in -1..1: points.add((x, y))
for p in points:
    for q in points:
        segments.add(Shape(a: p, d: sub(q, p), mode: 1))
    for d in points:
        if d != (0, 0): rays.add(Shape(a: p, d: d, mode: 0))

for a in rays:
    let r = initRay(fp(a.a), fp(a.d))
    for p in points:
        doAssert r.contains(initPoint(p.x, p.y)) == on(a, p)
        let squared = pointNorm(p, a)
        doAssert close(norm(fp(p), r), squared) and close(norm(r, fp(p)), squared)
        doAssert close(distance(fp(p), r), sqrt(squared))
        doAssert close(distance(r, fp(p)), sqrt(squared))
    for b in rays:
        checkPair(a, b)
        var line = b
        line.mode = 2
        checkPair(a, line)
    for b in segments: checkPair(a, b)

var rng = initRand(84)
for iteration in 0..<2000:
    proc vector(): V = (rng.rand(-50..50), rng.rand(-50..50))
    let a = Shape(a: vector(), d: vector(), mode: 0)
    var b = Shape(a: vector(), d: vector(), mode: iteration mod 3)
    if a.d == (0, 0) or (b.mode != 1 and b.d == (0, 0)): continue
    checkPair(a, b)
    let p = vector()
    doAssert close(norm(fp(p), initRay(fp(a.a), fp(a.d))), pointNorm(p, a))

template rejected(body: untyped) =
    block:
        var failed = false
        try: body
        except ValueError: failed = true
        doAssert failed

block:
    let r = initRay(initPoint(0, 0), initPoint(1, 0))
    doAssert r.origin == initPoint(0.0, 0.0)
    doAssert r.direction == initPoint(1.0, 0.0)
    doAssert r.contains(initPoint(0, 0))
    doAssert not r.contains(initPoint(-1, 0))
    doAssert r.contains(initPoint(-0.125, 0.0), 0.125)
    doAssert not r.contains(initPoint(-0.125, 0.0), 0.124)
    doAssert r.contains(initPoint(10.0, 0.125), 0.125)
    doAssert not r.contains(initPoint(10.0, 0.125), 0.124)
    doAssert not r.contains(initPoint(10.0, 1e-12))
    for eps in [0.0, 1e-10, 1.0]:
        GEOMETRY_EPS = eps
        doAssert r.contains(initPoint(0, 0))
        doAssert intersection(r, initRay(initPoint(0, 0), initPoint(-1, 0))).kind == rikPoint
        doAssert intersection(r, initRay(initPoint(2, 0), initPoint(-1, 0))).kind == rikSegment
        doAssert intersection(r, initRay(initPoint(2, 0), initPoint(1, 0))).kind == rikRay
        doAssert intersection(r, initRay(initPoint(-1, 0), initPoint(-1, 0))).kind == rikEmpty
    GEOMETRY_EPS = 1e-10
    rejected: discard initRay(initPoint(0, 0), initPoint(0, 0))
    rejected: discard initRay(initPoint(high(int64), 0'i64), initPoint(1, 0))
    rejected: discard initRay(initPoint(low(int64), 0'i64), initPoint(1, 0))
    rejected: discard initRay(initPoint(high(uint64), 0'u64), initPoint(1, 0))
    rejected: discard initRay(initPoint(0, 0), initPoint(9007199254740993'i64, 0'i64))
    rejected: discard initRay(initPoint(NaN, 0.0), initPoint(1, 0))
    rejected: discard initRay(initPoint(0, 0), initPoint(Inf, 0.0))
    rejected: discard r.contains(initPoint(0, 0), -1)
    rejected: discard r.contains(initPoint(0, 0), NaN)
    rejected: discard r.contains(initPoint(Inf, 0.0))
    rejected: discard distance(initPoint(0, 0), Ray())
    rejected: discard intersection(r, Line[int](s: initPoint(0, 0), t: initPoint(0, 0)))
    rejected: discard intersection(r, Line[float64](s: initPoint(Inf, 0.0), t: initPoint(0.0, 0.0)))
    rejected: discard norm(initPoint(0.0, 1e200), r)
    rejected: discard norm(initPoint(0.0, 1e-200), r)
    rejected: discard initRay(initPoint(0, 0), initPoint(1e300, 1e-300))
    let huge = initRay(initPoint(1e308, 0.0), initPoint(1, 0))
    rejected: discard distance(initPoint(-1e308, 0.0), huge)

for scale in [1e-200, 1e-12, 1.0, 1e12, 1e200]:
    let r = initRay(initPoint(0.0, 0.0), initPoint(scale, scale))
    doAssert r.direction.x == 1 and r.direction.y == 1
    doAssert r.contains(initPoint(scale, scale))
    let q = initRay(initPoint(2 * scale, 0.0), initPoint(-scale, scale))
    let hit = intersection(r, q)
    doAssert hit.kind == rikPoint
    doAssert close(hit.point.x / scale, 1) and close(hit.point.y / scale, 1)
    let behind = initRay(initPoint(-2 * scale, 0.0), initPoint(-scale, scale))
    doAssert not intersect(r, behind)
    doAssert close(distance(initPoint(-scale, -scale), r) / scale, sqrt(2.0))

block:
    let tiny = initRay(initPoint(0.0, 0.0), initPoint(1e-320, 0.0))
    doAssert tiny.direction.x == 1
    doAssert tiny.contains(initPoint(1e-320, 0.0))
    doAssert not tiny.contains(initPoint(-1e-320, 0.0))
    let r32 = initRay(initPoint(1'f32, 2'f32), initPoint(0'f32, 1'f32))
    doAssert r32.contains(initPoint(1'f32, 3'f32))
    let s32 = Segment[float32](s: initPoint(0'f32, 3'f32), t: initPoint(2'f32, 3'f32))
    doAssert intersection(r32, s32).point == initPoint(1.0, 3.0)
    doAssert distance(r32, s32) == 0
    let l32 = Line[float32](s: s32.s, t: s32.t)
    doAssert intersect(r32, l32) and norm(l32, r32) == 0
    let largeInteger = initRay(initPoint(9007199254740992'i64, 0'i64), initPoint(1'i64, 0'i64))
    doAssert largeInteger.contains(initPoint(9007199254740992'i64, 0'i64))
    doAssert initRay(initPoint(0'u32, 0'u32), initPoint(1'u32, 0'u32)).contains(initPoint(1'u32, 0'u32))
    doAssert initRay(initPoint(-9007199254740992'i64, 0'i64), initPoint(-1'i64, 0'i64)).contains(initPoint(-9007199254740992'i64, 0'i64))
    let near = initRay(initPoint(0.0, 1.0), initPoint(1.0, -1e-12))
    let hit = intersection(initRay(initPoint(0, 0), initPoint(1, 0)), near)
    doAssert hit.kind == rikPoint and close(hit.point.x, 1e12)

block:
    let a = initSegment(initPoint(0, 0), initPoint(2, 0))
    let b = initSegment(initPoint(1, -1), initPoint(1, 1))
    doAssert intersect(a, b)
    doAssert norm(initPoint(3.0, 4.0), initSegment(initPoint(0.0, 0.0), initPoint(2.0, 0.0))) == 17
    doAssert intersection(initRay(initPoint(0, 0), initPoint(1, 0)), b).kind == rikPoint

echo "Hello World"
