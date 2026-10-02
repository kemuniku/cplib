# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random, sequtils
import cplib/math/linear_programming

proc checkOptimal(a: seq[seq[float64]], b, c: seq[float64], expected: float64,
        eps: float64 = 1e-9) =
    let answer = linear_programming(a, b, c, eps)
    doAssert answer.status == lpOptimal
    doAssert answer.x.len == c.len
    doAssert abs(answer.value - expected) <= 1e-7 * (1.0 + abs(expected))
    var value = 0.0
    for j in 0..<c.len:
        doAssert answer.x[j] >= -1e-7
        value += c[j] * answer.x[j]
    doAssert abs(value - answer.value) <= 1e-7 * (1.0 + abs(value))
    for i in 0..<b.len:
        var left = 0.0
        for j in 0..<c.len:
            left += a[i][j] * answer.x[j]
        doAssert left <= b[i] + 1e-7 * (1.0 + abs(b[i]))

proc checkStatus(a: seq[seq[float64]], b, c: seq[float64],
        status: LinearProgrammingStatus) =
    let answer = linear_programming(a, b, c)
    doAssert answer.status == status
    doAssert answer.x.len == 0
    doAssert answer.value == (if status == lpInfeasible: -Inf else: Inf)

block:
    let a = @[@[1.0, 1.0], @[1.0, 0.0], @[0.0, 1.0]]
    let b = @[4.0, 2.0, 3.0]
    let c = @[3.0, 2.0]
    checkOptimal(a, b, c, 10.0)
    doAssert linear_programming(a, b, c).x == @[2.0, 2.0]
    doAssert a == @[@[1.0, 1.0], @[1.0, 0.0], @[0.0, 1.0]]
    doAssert b == @[4.0, 2.0, 3.0] and c == @[3.0, 2.0]
    checkOptimal(@[@[2.0, 1.0], @[1.0, 2.0]], @[4.0, 4.0], @[1.0, 1.0], 8.0 / 3.0)
    checkOptimal(@[@[-1.0, -2.0]], @[-4.0], @[-1.0, -1.0], -2.0)
    checkOptimal(@[@[-1.0], @[1.0]], @[-2.0, 3.0], @[1.0], 3.0)
    checkOptimal(@[@[-1.0], @[1.0]], @[-2.0, 3.0], @[-1.0], -2.0)
    checkOptimal(@[@[1.0, 1.0]], @[2.0], @[-1.0, -2.0], 0.0)
    checkOptimal(@[@[-1.0], @[1.0], @[-2.0], @[0.0]], @[-2.0, 2.0, -4.0, 0.0], @[1.0], 2.0)
    checkOptimal(@[@[1.0, -1.0], @[-1.0, 1.0]], @[0.0, 0.0], @[1.0, -1.0], 0.0)
    checkOptimal(@[@[-1.0, -1.0], @[1.0, 1.0]], @[-1.0, 1.0], @[0.0, 0.0], 0.0)
    checkOptimal(@[@[1.0, 1.0], @[2.0, 2.0], @[0.0, 0.0]], @[2.0, 4.0, 0.0], @[1.0, 1.0], 2.0)
    checkOptimal(@[@[1.0, 1.0]], @[0.0], @[1.0, 2.0], 0.0)

block:
    checkStatus(@[@[1.0], @[-1.0]], @[1.0, -2.0], @[1.0], lpInfeasible)
    checkStatus(@[@[0.0]], @[-1.0], @[0.0], lpInfeasible)
    checkStatus(@[@[1.0]], @[-1.0], @[-1.0], lpInfeasible)
    checkStatus(@[@[1.0, 0.0], @[-1.0, 0.0]], @[1.0, -2.0], @[0.0, 1.0], lpInfeasible)
    checkStatus(@[@[-1.0]], @[-1.0], @[1.0], lpUnbounded)
    checkStatus(@[@[1.0, -1.0]], @[1.0], @[1.0, 1.0], lpUnbounded)
    checkStatus(@[@[0.0, 0.0]], @[0.0], @[1.0, 0.0], lpUnbounded)
    checkStatus(@[@[-1.0, -1.0], @[1.0, -1.0]], @[-1.0, 0.0], @[1.0, 1.0], lpUnbounded)

block:
    checkOptimal(@[], @[], @[], 0.0)
    checkOptimal(@[], @[], @[-1.0, 0.0], 0.0)
    checkOptimal(newSeqWith(2, newSeq[float64]()), @[0.0, 3.0], @[], 0.0)
    checkStatus(@[newSeq[float64]()], @[-1.0], @[], lpInfeasible)
    checkStatus(@[], @[], @[1.0], lpUnbounded)
    checkStatus(@[], @[], @[-1.0, 1.0], lpUnbounded)
    let a = [@[1.0]]
    let answer = linear_programming(a, [2.0], [3.0])
    doAssert answer.status == lpOptimal and answer.value == 6.0

block:
    checkOptimal(@[@[0.5, -5.5, -2.5, 9.0], @[0.5, -1.5, -0.5, 1.0],
        @[1.0, 0.0, 0.0, 0.0]], @[0.0, 0.0, 1.0], @[10.0, -57.0, -9.0, -24.0], 1.0)
    checkOptimal(@[@[1e-6, 1e-6], @[1e-6, 0.0], @[0.0, 1e-6]],
        @[4e-6, 2e-6, 3e-6], @[3.0, 2.0], 10.0, eps = 1e-12)
    checkOptimal(@[@[1e6, 1e6], @[1e6, 0.0], @[0.0, 1e6]],
        @[4e6, 2e6, 3e6], @[3.0, 2.0], 10.0)
    checkOptimal(@[@[1e-10]], @[1e-10], @[1.0], 1.0, eps = 1e-12)

proc determinant(a: seq[seq[int64]]): int64 =
    let n = a.len
    if n == 0: return 1
    for j in 0..<n:
        var minor = newSeqWith(n - 1, newSeq[int64](n - 1))
        for i in 1..<n:
            var k = 0
            for col in 0..<n:
                if col != j:
                    minor[i - 1][k] = a[i][col]
                    inc k
        let term = a[0][j] * determinant(minor)
        if j mod 2 == 0: result += term
        else: result -= term

type ExactOptimum = tuple[found: bool, numerator, denominator: int64]

proc enumerateVertices(a: seq[seq[int64]], b, c: seq[int64]): ExactOptimum =
    let n = c.len
    var constraints = a
    var bounds = b
    for j in 0..<n:
        var row = newSeq[int64](n)
        row[j] = -1
        constraints.add(row)
        bounds.add(0)
    var best: ExactOptimum
    var chosen: seq[int]

    proc visit(start: int) =
        if chosen.len < n:
            for i in start..<constraints.len:
                chosen.add(i)
                visit(i + 1)
                chosen.setLen(chosen.len - 1)
            return
        var matrix = newSeqWith(n, newSeq[int64](n))
        for i in 0..<n:
            for j in 0..<n:
                matrix[i][j] = constraints[chosen[i]][j]
        var denominator = determinant(matrix)
        if denominator == 0: return
        var numerators = newSeq[int64](n)
        for j in 0..<n:
            for i in 0..<n:
                matrix[i][j] = bounds[chosen[i]]
            numerators[j] = determinant(matrix)
            for i in 0..<n:
                matrix[i][j] = constraints[chosen[i]][j]
        if denominator < 0:
            denominator = -denominator
            for x in numerators.mitems: x = -x
        for i in 0..<constraints.len:
            var value = 0'i64
            for j in 0..<n:
                value += constraints[i][j] * numerators[j]
            if value > bounds[i] * denominator: return
        var value = 0'i64
        for j in 0..<n:
            value += c[j] * numerators[j]
        if not best.found or value * best.denominator > best.numerator * denominator:
            best = (true, value, denominator)

    visit(0)
    return best

proc checkExact(a: seq[seq[int64]], b, c: seq[int64]) =
    let af = a.mapIt(it.mapIt(float64(it)))
    let bf = b.mapIt(float64(it))
    let cf = c.mapIt(float64(it))
    let best = enumerateVertices(a, b, c)
    if not best.found:
        checkStatus(af, bf, cf, lpInfeasible)
        return
    var directions = a
    directions.add(newSeqWith(c.len, 1'i64))
    var bounds = newSeq[int64](b.len)
    bounds.add(1)
    let direction = enumerateVertices(directions, bounds, c)
    doAssert direction.found
    if direction.numerator > 0:
        checkStatus(af, bf, cf, lpUnbounded)
    else:
        checkOptimal(af, bf, cf, float64(best.numerator) / float64(best.denominator))

block:
    var rng = initRand(20260926)
    for test in 0..<2500:
        let n = rng.rand(0..3)
        let m = rng.rand(0..6)
        var a = newSeqWith(m, newSeq[int64](n))
        var b = newSeq[int64](m)
        var c = newSeq[int64](n)
        for i in 0..<m:
            for j in 0..<n: a[i][j] = int64(rng.rand(-4..4))
        for x in b.mitems: x = int64(rng.rand(-6..6))
        for x in c.mitems: x = int64(rng.rand(-4..4))
        if test mod 4 == 0:
            let feasible = newSeqWith(n, int64(rng.rand(0..3)))
            for i in 0..<m:
                b[i] = int64(rng.rand(0..2))
                for j in 0..<n: b[i] += a[i][j] * feasible[j]
        if test mod 4 == 1:
            for j in 0..<n:
                var row = newSeq[int64](n)
                row[j] = 1
                a.add(row)
                b.add(4)
        checkExact(a, b, c)

echo "Hello World"
