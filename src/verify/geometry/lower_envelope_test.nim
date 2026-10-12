# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, options, random, sequtils
import cplib/geometry/base
import cplib/geometry/lower_envelope
import cplib/math/fractions

type
    Q = Fraction[int64]
    Input = tuple[sx, sy, tx, ty: int64, ray: bool]

proc q(x: int64): Q = initFraction(x)
proc asFloat(x: Q): float = float(x.num) / float(x.den)
proc segment(sx, sy, tx, ty: int64): Input = (sx, sy, tx, ty, false)
proc ray(sx, sy, tx, ty: int64): Input = (sx, sy, tx, ty, true)

proc covers(c: Input, x: Q): bool =
    if c.sx == c.tx: return x == q(c.sx)
    if c.ray:
        if c.sx < c.tx: return x >= q(c.sx)
        return x <= q(c.sx)
    q(min(c.sx, c.tx)) <= x and x <= q(max(c.sx, c.tx))

proc yAt(c: Input, x: Q, upper: bool): Q =
    if c.sx == c.tx:
        if c.ray: return q(c.sy)
        return q(if upper: max(c.sy, c.ty) else: min(c.sy, c.ty))
    q(c.sy) + (x - q(c.sx)) * q(c.ty - c.sy) / q(c.tx - c.sx)

proc brute(cs: seq[Input], x: Q, upper: bool): int =
    result = -1
    for i, c in cs:
        if not covers(c, x): continue
        if result < 0:
            result = i
        else:
            let a = yAt(c, x, upper)
            let b = yAt(cs[result], x, upper)
            if (upper and a > b) or (not upper and a < b): result = i

proc criticalXs(cs: seq[Input]): seq[Q] =
    for c in cs:
        result.add(q(c.sx))
        if not c.ray: result.add(q(c.tx))
    for i in 0..<cs.len:
        let a = cs[i]
        if a.sx == a.tx: continue
        for j in 0..<i:
            let b = cs[j]
            if b.sx == b.tx: continue
            let ax = a.tx - a.sx
            let ay = a.ty - a.sy
            let bx = b.tx - b.sx
            let by = b.ty - b.sy
            let den = ax * by - ay * bx
            if den == 0: continue
            let num = (b.sx - a.sx) * by - (b.sy - a.sy) * bx
            let x = q(a.sx) + initFraction(ax * num, den)
            if covers(a, x) and covers(b, x): result.add(x)
    result.sort()
    result = result.deduplicate(isSorted = true)

proc check(cs: seq[Input], upper: bool) =
    var curves: seq[EnvelopeCurve[Q]]
    var floats: seq[EnvelopeCurve[float]]
    for c in cs:
        let s = initPoint(q(c.sx), q(c.sy))
        let t = initPoint(q(c.tx), q(c.ty))
        let sf = initPoint(float(c.sx), float(c.sy))
        let tf = initPoint(float(c.tx), float(c.ty))
        if c.ray:
            curves.add(initEnvelopeRay(s, t))
            floats.add(initEnvelopeRay(sf, tf))
        else:
            curves.add(initEnvelopeSegment(s, t))
            floats.add(initEnvelopeSegment(sf, tf))
    let original = curves
    let e = if upper: upper_envelope(curves) else: lower_envelope(curves)
    let ef = if upper: upper_envelope(floats) else: lower_envelope(floats)
    doAssert curves == original
    let xs = criticalXs(cs)
    var expected: EnvelopeDiagram[Q]
    expected.interval_sources = @[brute(cs, if xs.len == 0: q(0) else: xs[0] - 1, upper)]
    var samples = xs
    samples.add(if xs.len == 0: q(0) else: xs[0] - 1)
    for i, x in xs:
        let sample = if i + 1 < xs.len: (x + xs[i + 1]) / 2 else: x + 1
        samples.add(sample)
        let point = brute(cs, x, upper)
        let right = brute(cs, sample, upper)
        if expected.interval_sources[^1] != point or point != right:
            expected.xs.add(x)
            expected.point_sources.add(point)
            expected.interval_sources.add(right)
    doAssert e.diagram == expected, $cs & " upper=" & $upper & "\n" & $e.diagram & "\n" & $expected
    doAssert ef.diagram.interval_sources.len == ef.diagram.xs.len + 1
    doAssert ef.diagram.point_sources.len == ef.diagram.xs.len
    for i in 1..<ef.diagram.xs.len:
        doAssert ef.diagram.xs[i - 1] < ef.diagram.xs[i]
    for x in samples:
        let id = brute(cs, x, upper)
        doAssert e.source_at(x) == id
        let y = e.value_at(x)
        let yf = ef.value_at(x.asFloat)
        doAssert y.isSome == (id >= 0)
        doAssert yf.isSome == y.isSome
        if id >= 0:
            let expectedY = yAt(cs[id], x, upper)
            doAssert y.get == expectedY
            doAssert abs(yf.get - expectedY.asFloat) <= 1e-8 * max(1.0, abs(expectedY.asFloat)),
                $cs & " x=" & $x & " upper=" & $upper

proc checkBoth(cs: seq[Input]) =
    check(cs, false)
    check(cs, true)

checkBoth(@[])
checkBoth(@[segment(0, 1, 2, 3)])
checkBoth(@[segment(2, 3, 0, 1)])
checkBoth(@[segment(0, 0, 0, 0)])
checkBoth(@[segment(-3, 0, -2, 0), segment(2, 0, 3, 0)])
checkBoth(@[segment(-1, 0, 0, 0), segment(0, 1, 1, 1)])
checkBoth(@[segment(-1, 1, 1, 1), segment(0, 0, 0, 2)])
checkBoth(@[segment(-1, -1, 1, 1), segment(-1, 1, 1, -1), segment(-1, 0, 1, 0)])
checkBoth(@[segment(-1, 0, 1, 0), segment(-1, -1, 1, 1), segment(-1, 1, 1, -1)])
checkBoth(@[segment(-1, -1, 0, 0), segment(0, 0, 1, -1)])
checkBoth(@[segment(-2, -2, 0, 0), segment(-1, 1, 0, 0)])
checkBoth(@[segment(0, 2, 1, 1), segment(0, 0, 1, 0)])
checkBoth(@[segment(-2, 0, 2, 0), segment(-1, 0, 1, 0), segment(0, 0, 0, 0)])
checkBoth(@[ray(0, 0, 1, 1), ray(0, 0, -1, 1)])
checkBoth(@[ray(-1, 0, 1, 0), ray(1, 0, -1, 0)])
checkBoth(@[ray(1, 2, 2, 3), ray(-1, 2, -2, 3)])
checkBoth(@[ray(1, 2, 2, 1), ray(-1, 2, -2, 1)])
checkBoth(@[segment(0, 3, 0, -3), segment(0, -2, 0, 2), segment(0, 1, 0, 1)])
check(@[ray(0, -2, 0, 2), segment(-1, 0, 1, 0)], false)
check(@[ray(0, 2, 0, -2), segment(-1, 0, 1, 0)], true)

block:
    var islands = @[segment(-20, 0, 20, 0)]
    for i in countup(-19'i64, 17'i64, 4'i64): islands.add(segment(i, -1, i + 1, -1))
    checkBoth(islands)
    var spikes = @[segment(-20, 0, 20, 0)]
    for i in -19'i64..19'i64: spikes.add(segment(i, -1, i, 1))
    checkBoth(spikes)

var rng = initRand(20261012)
for trial in 0..<1800:
    var cs: seq[Input]
    for i in 0..<rng.rand(0..10):
        var c = segment(int64(rng.rand(-4..4)), int64(rng.rand(-4..4)),
            int64(rng.rand(-4..4)), int64(rng.rand(-4..4)))
        c.ray = i mod 3 == 0 and c.sx != c.tx
        cs.add(c)
    checkBoth(cs)

for upper in [false, true]:
    for trial in 0..<150:
        var cs: seq[Input]
        for i in 0..<rng.rand(1..10):
            let x = int64(rng.rand(-3..3))
            let y = int64(rng.rand(-3..3))
            cs.add(ray(x, y, x, y + (if upper: -1 else: 1)))
        cs.add(segment(-3, -3, 3, 3))
        check(cs, upper)

template rejects(body: untyped) =
    block:
        var caught = false
        try:
            discard body
        except ValueError:
            caught = true
        doAssert caught

block:
    let p = initPoint(0.0, 0.0)
    rejects(initEnvelopeRay(p, p))
    rejects(lower_envelope([initEnvelopeRay(p, initPoint(0.0, -1.0))]))
    rejects(upper_envelope([initEnvelopeRay(p, initPoint(0.0, 1.0))]))
    for invalid in [NaN, Inf, -Inf]:
        rejects(lower_envelope([initEnvelopeSegment(p, initPoint(invalid, 0.0))]))
        rejects(upper_envelope([initEnvelopeRay(p, initPoint(1.0, invalid))]))
    rejects(lower_envelope([initEnvelopeSegment(initPoint(q(0), q(0)),
        initPoint(initFraction(1'i64, 0'i64), q(0)))]))
    let e = lower_envelope([initEnvelopeSegment(p, initPoint(1.0, 1.0))])
    rejects(e.source_at(Inf))
    rejects(e.value_at(NaN))
    rejects(lower_envelope([initEnvelopeSegment(p, initPoint(1e-308, 1e308))]))

block:
    let segments = [initSegment(initPoint(-1.0, 1.0), initPoint(1.0, 1.0)),
        initSegment(initPoint(0.0, 0.0), initPoint(0.0, 2.0))]
    let lo = lower_envelope(segments)
    let hi = upper_envelope(segments)
    doAssert lo.diagram.xs == @[-1.0, 0.0, 1.0]
    doAssert lo.diagram.interval_sources == @[-1, 0, 0, -1]
    doAssert lo.diagram.point_sources == @[0, 1, 0]
    doAssert lo.value_at(0.0).get == 0.0
    doAssert hi.value_at(0.0).get == 2.0
    doAssert lo.source_value(0, 0.0) == 1.0
    doAssert lo.source_value(1, 0.0) == 0.0
    doAssert hi.source_value(1, 0.0) == 2.0
    doAssert lo.value_at(2.0).isNone
    rejects(lo.source_value(-1, 0.0))
    rejects(lo.source_value(2, 0.0))
    rejects(lo.source_value(0, Inf))

block:
    let curves = [initEnvelopeSegment(initPoint(-1.0, 0.0), initPoint(0.0, 0.0)),
        initEnvelopeSegment(initPoint(0.0, 1.0), initPoint(1.0, 1.0))]
    doAssert lower_envelope(curves).diagram.point_sources == @[0, 0, 1]
    doAssert upper_envelope(curves).diagram.point_sources == @[0, 1, 1]

block:
    let tiny = 1e-12
    let curves = [initEnvelopeSegment(initPoint(0.0, 0.0), initPoint(tiny, tiny)),
        initEnvelopeSegment(initPoint(0.0, tiny), initPoint(tiny, 0.0))]
    for e in [lower_envelope(curves), upper_envelope(curves)]:
        doAssert e.diagram.xs == @[0.0, tiny / 2, tiny]
        doAssert e.source_at(tiny / 2) == 0
    let close = [initEnvelopeRay(initPoint(0.0, 0.0), initPoint(1.0, 1.0)),
        initEnvelopeRay(initPoint(0.0, tiny), initPoint(1.0, 1.0 - tiny))]
    for e in [lower_envelope(close), upper_envelope(close)]:
        doAssert e.diagram.xs.len == 2
        doAssert abs(e.diagram.xs[1] - 0.5) < 1e-4
    let distant = [initEnvelopeRay(initPoint(0.0, 0.0), initPoint(1.0, 0.0)),
        initEnvelopeRay(initPoint(0.0, 1.0), initPoint(1e12, 0.0))]
    let lo = lower_envelope(distant)
    let hi = upper_envelope(distant)
    doAssert lo.diagram.xs == @[0.0, 1e12]
    doAssert hi.diagram.xs == @[0.0, 1e12]
    doAssert lo.source_at(1e12) == 0 and hi.source_at(1e12) == 0
    doAssert lo.source_at(5e11) == 0 and lo.source_at(2e12) == 1
    doAssert hi.source_at(5e11) == 1 and hi.source_at(2e12) == 0

block:
    let s = initEnvelopeSegment(initPoint(0'f32, 1'f32), initPoint(2'f32, 3'f32))
    doAssert lower_envelope([s]).value_at(1'f32).get == 2'f32
    doAssert upper_envelope([s]).value_at(1'f32).get == 2'f32

block:
    let left = lower_envelope([
        initEnvelopeRay(initPoint(q(0), q(0)), initPoint(q(-1), q(1))),
        initEnvelopeRay(initPoint(q(0), q(0)), initPoint(q(1), q(1)))])
    let right = upper_envelope([
        initEnvelopeSegment(initPoint(q(-2), q(1)), initPoint(q(2), q(1))),
        initEnvelopeSegment(initPoint(q(0), q(3)), initPoint(q(0), q(3)))])
    for upper in [false, true]:
        let combined = if upper: upper_envelope(left, right) else: lower_envelope(left, right)
        var xs: seq[Q]
        xs.add(combined.diagram.xs)
        for i in -8..8: xs.add(initFraction(int64(i), 2'i64))
        for x in xs:
            let lv = left.value_at(x)
            let rv = right.value_at(x)
            let li = left.source_at(x)
            let ri = right.source_at(x)
            var expected = li
            if li < 0 or (ri >= 0 and
                    (if upper: rv.get > lv.get else: rv.get < lv.get)):
                expected = if ri < 0: -1 else: ri + 2
            doAssert combined.source_at(x) == expected
            let actual = combined.value_at(x)
            if expected < 0:
                doAssert actual.isNone
            elif expected < 2:
                doAssert actual.get == lv.get
            else:
                doAssert actual.get == rv.get
        let nested = upper_envelope(combined, left)
        for x in xs:
            let expected = if upper: combined.value_at(x) else: left.value_at(x)
            doAssert nested.value_at(x) == expected

static:
    doAssert not compiles(initEnvelopeSegment(initPoint(0, 0), initPoint(1, 1)))

block:
    const n = 200000
    var curves = newSeqOfCap[EnvelopeCurve[float]](n)
    curves.add(initEnvelopeSegment(initPoint(-1.0, 0.0), initPoint(float(3 * n), 0.0)))
    for i in 1..<n:
        curves.add(initEnvelopeSegment(initPoint(float(3 * i), -1.0),
            initPoint(float(3 * i + 1), -1.0)))
    let lo = lower_envelope(curves)
    let hi = upper_envelope(curves)
    doAssert lo.diagram.xs.len == 2 * n
    doAssert hi.diagram.xs.len == 2
    for i in 1..<n:
        doAssert lo.source_at(float(3 * i)) == i
        doAssert lo.source_at(float(3 * i + 1)) == i
        doAssert lo.source_at(float(3 * i + 2)) == 0

echo "Hello World"
