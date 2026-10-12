import os, random, strformat, strutils, times
import cplib/geometry/base
import cplib/geometry/lower_envelope

proc makeInput(kind: string, n: int): seq[EnvelopeCurve[float]] =
    ## 固定seedのランダム入力と出力サイズの異なる構造入力を作る。O(N)。
    var rng = initRand(20261012)
    result = newSeqOfCap[EnvelopeCurve[float]](n)
    for i in 0..<n:
        let x = float(i)
        var a, b: Point[float]
        var ray = false
        case kind
        of "random_segments", "random_rays":
            a = initPoint(rng.rand(2e6) - 1e6, rng.rand(2e6) - 1e6)
            b = initPoint(rng.rand(2e6) - 1e6, rng.rand(2e6) - 1e6)
            ray = kind == "random_rays"
        of "disjoint":
            a = initPoint(3 * x, x)
            b = initPoint(3 * x + 1, x + 1)
        of "nested":
            a = initPoint(-x - 1, x)
            b = initPoint(x + 1, x)
        of "islands":
            if i == 0:
                a = initPoint(-1.0, 0.0)
                b = initPoint(3.0 * float(n), 0.0)
            else:
                a = initPoint(3 * x, -1.0)
                b = initPoint(3 * x + 1, -1.0)
        of "points":
            a = initPoint(x, -1.0)
            b = initPoint(x, 1.0)
        of "parallel":
            a = initPoint(0.0, x)
            b = initPoint(1.0, x + 1)
            ray = true
        of "crossings":
            a = initPoint(-float(n), -x * float(n) + x * x)
            b = initPoint(float(n), x * float(n) + x * x)
        else:
            raise newException(ValueError, "未知の入力種類です")
        result.add(if ray: initEnvelopeRay(a, b) else: initEnvelopeSegment(a, b))
    if kind notin ["random_segments", "random_rays"]: rng.shuffle(result)

let kind = if paramCount() >= 1: paramStr(1) else: "random_segments"
let n = if paramCount() >= 2: parseInt(paramStr(2)) else: 200000
let curves = makeInput(kind, n)
for upper in [false, true]:
    let started = cpuTime()
    let envelope = if upper: upper_envelope(curves) else: lower_envelope(curves)
    let elapsed = cpuTime() - started
    echo &"{kind},N={n},upper={upper},seconds={elapsed:.6f},vertices={envelope.diagram.xs.len}"
