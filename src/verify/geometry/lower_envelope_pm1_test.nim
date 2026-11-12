# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, random
import cplib/geometry/base
import cplib/geometry/lower_envelope as general
import cplib/geometry/lower_envelope_pm1 as pm1
import cplib/math/fractions
import cplib/math/int128

type Frac = Fraction[Int128]

proc q(x: int): Frac = initFraction(Int128(x))

proc compare(curves: seq[tuple[x, y, slope, direction: int]]) =
    var fastCurves: seq[pm1.EnvelopeCurve[Frac]]
    var slowCurves: seq[general.EnvelopeCurve[Frac]]
    for c in curves:
        let s = initPoint(q(c.x), q(c.y))
        let t = initPoint(q(c.x + c.direction), q(c.y + c.slope * c.direction))
        fastCurves.add(pm1.initEnvelopeRay(s, t))
        slowCurves.add(general.initEnvelopeRay(s, t))

    for upper in [false, true]:
        let fast = if upper: pm1.upper_envelope(fastCurves) else: pm1.lower_envelope(fastCurves)
        let slow = if upper: general.upper_envelope(slowCurves) else: general.lower_envelope(slowCurves)
        doAssert fast.diagram.xs == slow.diagram.xs
        doAssert fast.diagram.point_sources == slow.diagram.point_sources
        doAssert fast.diagram.interval_sources == slow.diagram.interval_sources

        for numerator in -24..24:
            let x = initFraction(Int128(numerator), Int128(2))
            doAssert pm1.source_at(fast, x) == general.source_at(slow, x)
            doAssert pm1.value_at(fast, x) == general.value_at(slow, x)

        let middle = curves.len div 2
        let fastLeft = if upper: pm1.upper_envelope(fastCurves[0..<middle])
            else: pm1.lower_envelope(fastCurves[0..<middle])
        let fastRight = if upper: pm1.upper_envelope(fastCurves[middle..<curves.len])
            else: pm1.lower_envelope(fastCurves[middle..<curves.len])
        let combined = if upper: pm1.upper_envelope(fastLeft, fastRight)
            else: pm1.lower_envelope(fastLeft, fastRight)
        doAssert combined.diagram == fast.diagram

compare(@[])
compare(@[(x: 0, y: 0, slope: 1, direction: 1)])
compare(@[(x: 0, y: 0, slope: -1, direction: -1),
          (x: 0, y: 0, slope: 1, direction: 1)])

var rng = initRand(20261013)
for n in 2..8:
    for repetition in 0..<100:
        var curves: seq[tuple[x, y, slope, direction: int]]
        for i in 0..<n:
            curves.add((rng.rand(-5..5), rng.rand(-5..5),
                if rng.rand(1) == 0: -1 else: 1,
                if rng.rand(1) == 0: -1 else: 1))
        compare(curves)

block:
    let s = initPoint(q(0), q(0))
    let t = initPoint(q(1), q(0))
    try:
        discard pm1.lower_envelope([pm1.initEnvelopeRay(s, t)])
        doAssert false
    except ValueError:
        discard

echo "Hello World"
