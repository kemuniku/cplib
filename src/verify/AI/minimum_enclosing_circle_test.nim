# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, options, random, algorithm
import cplib/geometry/base
import cplib/geometry/circle
import cplib/geometry/minimum_enclosing_circle

type Candidate = tuple[x, y, radius: float]
proc oracle(points: seq[Point[float]]): float =
    var candidates: seq[Candidate]
    for p in points: candidates.add((p.x, p.y, 0.0))
    for i in 0..<points.len:
        for j in 0..<i:
            let a = points[i]
            let b = points[j]
            candidates.add(((a.x + b.x) / 2, (a.y + b.y) / 2, hypot(a.x - b.x, a.y - b.y) / 2))
            for k in 0..<j:
                let c = points[k]
                let det = 2 * (a.x * (b.y - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))
                if det == 0: continue
                let aa = a.x * a.x + a.y * a.y
                let bb = b.x * b.x + b.y * b.y
                let cc = c.x * c.x + c.y * c.y
                let x = (aa * (b.y - c.y) + bb * (c.y - a.y) + cc * (a.y - b.y)) / det
                let y = (aa * (c.x - b.x) + bb * (a.x - c.x) + cc * (b.x - a.x)) / det
                candidates.add((x, y, hypot(x - a.x, y - a.y)))
    result = system.Inf
    for candidate in candidates:
        var feasible = true
        for p in points:
            if hypot(p.x - candidate.x, p.y - candidate.y) > candidate.radius + 1e-9:
                feasible = false
        if feasible: result = min(result, candidate.radius)

proc check(points: seq[Point[float]], expected: float, seed: int64 = 0, error = 1e-8) =
    var saved: seq[(float, float)]
    for p in points: saved.add((p.x, p.y))
    let res = minimum_enclosing_circle(points, seed)
    for i, p in points: doAssert p.x == saved[i][0] and p.y == saved[i][1]
    doAssert res.isSome
    let circle = res.get
    doAssert abs(circle.radius - expected) <= error
    for p in points:
        doAssert circle.contains(p, 0)
        doAssert hypot(p.x - circle.center.x, p.y - circle.center.y) <= circle.radius + error
    let repeated = minimum_enclosing_circle(points, seed).get
    doAssert repeated.center.x == circle.center.x and repeated.center.y == circle.center.y
    doAssert repeated.radius == circle.radius

let empty: seq[Point[float]] = @[]
doAssert minimum_enclosing_circle(empty).isNone
check(@[initPoint(3.0, 4.0)], 0)
check(@[initPoint(3.0, 4.0), initPoint(3.0, 4.0)], 0)
check(@[initPoint(-5.0, 0.0), initPoint(2.0, 0.0), initPoint(5.0, 0.0)], 5)
check(@[initPoint(0.0, 0.0), initPoint(4.0, 0.0), initPoint(1.0, 1.0)], 2)
check(@[initPoint(0.0, 0.0), initPoint(2.0, 0.0), initPoint(1.0, sqrt(3.0))], 2 / sqrt(3.0))
for seed in 0'i64..50'i64:
    check(@[initPoint(0.0, 0.0), initPoint(1.0, 1e-13), initPoint(2.0, 0.0), initPoint(3.0, -1e-13)], 1.5, seed)
for invalid in [-1.0, 1.0, system.Inf, NaN]:
    var rejected = false
    try: discard minimum_enclosing_circle(empty, tolerance = invalid)
    except ValueError: rejected = true
    doAssert rejected
for invalid in [system.Inf, NaN]:
    var rejected = false
    try: discard minimum_enclosing_circle(@[initPoint(invalid, 0.0)])
    except ValueError: rejected = true
    doAssert rejected
let ints = @[initPoint(0'i64, 0'i64), initPoint(4000000000'i64, 0'i64)]
doAssert minimum_enclosing_circle(ints).get.radius == 2000000000.0
let singleHuge = minimum_enclosing_circle(@[initPoint(1.7e308, 1.7e308)]).get
doAssert singleHuge.radius == 0
for scale in [1e-150, 1.0, 1e150]:
    check(@[initPoint(-scale, 0.0), initPoint(scale, 0.0), initPoint(0.0, scale)], scale, error = scale * 1e-8)
    check(@[initPoint(0.0, 0.0), initPoint(scale, 0.0)], scale / 2, error = scale * 1e-8)
check(@[initPoint(1e12 - 3, -1e12), initPoint(1e12 + 3, -1e12), initPoint(1e12, -1e12 + 4)], 3.125, error = 0.001)

let sampleOne = @[initPoint(0.0, 0.0), initPoint(1.0, 0.0)]
check(sampleOne, 0.5)
let sampleTwo = @[initPoint(0.0, 0.0), initPoint(0.0, 1.0), initPoint(1.0, 0.0)]
check(sampleTwo, 0.707106781186497524)
let sampleThree = @[
    initPoint(10.0, 9.0), initPoint(5.0, 9.0), initPoint(2.0, 0.0),
    initPoint(0.0, 0.0), initPoint(2.0, 7.0), initPoint(3.0, 3.0),
    initPoint(2.0, 5.0), initPoint(10.0, 0.0), initPoint(3.0, 7.0), initPoint(1.0, 9.0)]
check(sampleThree, 6.726812023536805158)

var rng = initRand(409301)
for trial in 0..<2200:
    var points: seq[Point[float]]
    for _ in 0..<rng.rand(1..8):
        points.add(initPoint(float(rng.rand(-10..10)), float(rng.rand(-10..10))))
    let expected = oracle(points)
    for seed in [0'i64, 1'i64, 612903'i64]: check(points, expected, seed)
    if trial < 30:
        for scale in [1e-150, 1e150]:
            var scaled: seq[Point[float]]
            for p in points: scaled.add(initPoint(p.x * scale, p.y * scale))
            check(scaled, expected * scale, error = max(expected, 1.0) * scale * 1e-8)
        var translated: seq[Point[float]]
        for p in points: translated.add(initPoint(p.x + 1e12, p.y - 1e12))
        check(translated, expected, error = 0.001)
    points.reverse
    check(points, expected, 42)
var stress: seq[Point[float]]
for i in 0..<10000:
    let angle = 2 * PI * float(i) / 10000
    stress.add(initPoint(cos(angle), sin(angle)))
check(stress, 1)

echo "Hello World"
