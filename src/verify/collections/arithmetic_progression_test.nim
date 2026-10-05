# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import options, algorithm
import cplib/collections/arithmetic_progression

{.push overflowChecks: on.}

proc foldSum(v: seq[int]): int =
    for x in v: result += x

proc check(p: ArithmeticProgression, expected: seq[int]) =
    doAssert p.len == expected.len
    var total = 0
    for i, x in expected:
        doAssert p[i] == x
        doAssert p[i - expected.len] == x
        doAssert p[^(expected.len - i)] == x
        total += x
    doAssert p.sum == total
    for x in -40..40:
        var lower, upper: int
        var ge, gt, le, lt = none(int)
        for y in expected:
            if (p.step >= 0 and y < x) or (p.step < 0 and y > x): inc lower
            if (p.step >= 0 and y <= x) or (p.step < 0 and y >= x): inc upper
            if y >= x and (ge.isNone or y < ge.get): ge = some(y)
            if y > x and (gt.isNone or y < gt.get): gt = some(y)
            if y <= x and (le.isNone or y > le.get): le = some(y)
            if y < x and (lt.isNone or y > lt.get): lt = some(y)
        doAssert p.lowerBound(x) == lower
        doAssert p.upperBound(x) == upper
        doAssert p.minGe(x) == ge
        doAssert p.minGt(x) == gt
        doAssert p.maxLe(x) == le
        doAssert p.maxLt(x) == lt
    for a in 0..expected.len:
        for b in a..expected.len:
            var part: seq[int]
            for i in a..<b: part.add(expected[i])
            let s = p[a..<b]
            doAssert s.len == part.len
            doAssert s.sum == part.foldSum
            for i, x in part: doAssert s[i] == x

for first in -5..5:
    for step in -4..4:
        for n in 0..8:
            var expected: seq[int]
            for i in 0..<n: expected.add(first + i * step)
            check(initArithmeticProgression(first, step, n), expected)

for start in -8..8:
    for stop in -8..8:
        for step in -5..5:
            if step == 0: continue
            var expected: seq[int]
            var x = start
            while (step > 0 and x < stop) or (step < 0 and x > stop):
                expected.add(x)
                x += step
            check(initArithmeticRange(start, stop, step), expected)

for n in 0..8:
    let p = initArithmeticProgression(7, -3, n)
    for a in -12..12:
        for b in -12..12:
            for stride in [-9, -3, -1, 1, 2, 9]:
                var indices: seq[int]
                for i in 0..<n: indices.add(i)
                if stride < 0: indices.reverse
                var expected: seq[int]
                for i in indices:
                    let normalizedA = if a < 0: a + n else: a
                    let normalizedB = if b < 0: b + n else: b
                    let edge = if stride > 0: max(0, min(n, normalizedA))
                               else: max(-1, min(n - 1, normalizedA))
                    let stopEdge = if stride > 0: max(0, min(n, normalizedB))
                                   else: max(-1, min(n - 1, normalizedB))
                    if (stride > 0 and i >= edge and i < stopEdge and (i - edge) mod stride == 0) or
                       (stride < 0 and i <= edge and i > stopEdge and (edge - i) mod (-stride) == 0):
                        expected.add(7 - 3 * i)
                let s = p.slice(a, b, stride)
                doAssert s.len == expected.len
                doAssert s.sum == expected.foldSum
                for i, x in expected: doAssert s[i] == x

template raises(kind: typedesc, body: untyped) =
    block:
        var caught = false
        try: body
        except kind: caught = true
        doAssert caught

let low = low(int)
let high = high(int)
doAssert initArithmeticRange(5).sum == 10
doAssert initArithmeticRange(-5).len == 0
let p = initArithmeticRange(2, 10, 2)
doAssert p[1..^1].sum == 18
doAssert p[^4..^2].sum == 12
doAssert p[^0 ..< ^0].len == 0
doAssert p.slice(-1, -p.len - 1, -1).sum == p.sum
doAssert p.slice(low, high).len == p.len
doAssert initArithmeticRange(4).slice(high, low, low).len == 1
doAssert initArithmeticProgression(low, high, 3)[2] == high - 1
doAssert initArithmeticProgression(high, low, 2)[1] == -1
doAssert initArithmeticProgression(low, 0, 1).sum == low
doAssert initArithmeticProgression(high, 0, 1).sum == high
doAssert initArithmeticProgression(-high, 2, high).sum == -high
doAssert initArithmeticProgression(-high + 2, 2, high - 1).sum == 0
doAssert initArithmeticProgression(0, 0, high).sum == 0
doAssert initArithmeticProgression(0, 0, high).upperBound(0) == high
doAssert initArithmeticRange(low, high, high).len == 3
doAssert initArithmeticRange(high, low, low).len == 2
raises(ValueError): discard initArithmeticProgression(0, 1, -1)
raises(ValueError): discard initArithmeticProgression(high, 1, 2)
raises(ValueError): discard initArithmeticProgression(low, -1, 2)
raises(ValueError): discard initArithmeticRange(0, 1, 0)
raises(ValueError): discard initArithmeticRange(low, high)
raises(ValueError): discard p.slice(0, 1, 0)
raises(ValueError): discard p.slice(0, 0, high)
raises(ValueError): discard initArithmeticProgression(high, 0, 2).sum
raises(ValueError): discard initArithmeticProgression(low, 0, 3).sum
raises(ValueError): discard initArithmeticProgression(high div 2, 1, 3).sum
raises(IndexDefect): discard p[4]
raises(IndexDefect): discard p[-5]
raises(IndexDefect): discard p[low]
raises(IndexDefect): discard p[^0]
raises(IndexDefect): discard initArithmeticRange(0)[0]
raises(IndexDefect): discard p[0..4]
raises(IndexDefect): discard p[3..1]

# Python多倍長整数で逐点列挙した240ケースの期待値。
when sizeof(int) == 8:
    const wideCases: array[240, tuple[a, b, n, x, lb, ub: int, ge, gt, le, lt: Option[int], ok: bool, total: int]] = [
        (low(int), low(int), 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), low(int), 1, 0, 0, 0, none(int), none(int), some(low(int)), some(low(int)), true, low(int)),
        (low(int), int(-9223372036854775807), 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), int(-9223372036854775807), 1, 0, 0, 0, none(int), none(int), some(low(int)), some(low(int)), true, low(int)),
        (low(int), -2, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), -2, 1, int(-9223372036854775807), 0, 0, none(int), none(int), some(low(int)), some(low(int)), true, low(int)),
        (low(int), -1, 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), -1, 1, low(int), 0, 1, some(low(int)), none(int), some(low(int)), none(int), true, low(int)),
        (low(int), 0, 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), 0, 1, low(int), 0, 1, some(low(int)), none(int), some(low(int)), none(int), true, low(int)),
        (low(int), 0, 2, 1, 2, 2, none(int), none(int), some(low(int)), some(low(int)), false, 0),
        (low(int), 0, 3, -1, 3, 3, none(int), none(int), some(low(int)), some(low(int)), false, 0),
        (low(int), 0, 5, 1, 5, 5, none(int), none(int), some(low(int)), some(low(int)), false, 0),
        (low(int), 1, 0, -1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), 1, 1, low(int), 0, 1, some(low(int)), none(int), some(low(int)), none(int), true, low(int)),
        (low(int), 1, 2, low(int), 0, 1, some(low(int)), some(int(int(-9223372036854775807))), some(low(int)), none(int), false, 0),
        (low(int), 1, 3, low(int), 0, 1, some(low(int)), some(int(int(-9223372036854775807))), some(low(int)), none(int), false, 0),
        (low(int), 1, 5, int(9223372036854775806), 5, 5, none(int), none(int), some(int(int(-9223372036854775804))), some(int(int(-9223372036854775804))), false, 0),
        (low(int), 2, 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), 2, 1, low(int), 0, 1, some(low(int)), none(int), some(low(int)), none(int), true, low(int)),
        (low(int), 2, 2, int(9223372036854775806), 2, 2, none(int), none(int), some(int(int(-9223372036854775806))), some(int(int(-9223372036854775806))), false, 0),
        (low(int), 2, 3, int(9223372036854775806), 3, 3, none(int), none(int), some(int(int(-9223372036854775804))), some(int(int(-9223372036854775804))), false, 0),
        (low(int), 2, 5, low(int), 0, 1, some(low(int)), some(int(int(-9223372036854775806))), some(low(int)), none(int), false, 0),
        (low(int), int(9223372036854775807), 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (low(int), int(9223372036854775807), 1, low(int), 0, 1, some(low(int)), none(int), some(low(int)), none(int), true, low(int)),
        (low(int), int(9223372036854775807), 2, low(int), 0, 1, some(low(int)), some(int(-1)), some(low(int)), none(int), false, 0),
        (low(int), int(9223372036854775807), 3, int(9223372036854775806), 2, 3, some(int(int(9223372036854775806))), none(int), some(int(int(9223372036854775806))), some(int(-1)), true, -3),
        (int(-9223372036854775807), low(int), 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), low(int), 1, low(int), 1, 1, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), true, int(-9223372036854775807)),
        (int(-9223372036854775807), int(-9223372036854775807), 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), int(-9223372036854775807), 1, int(9223372036854775806), 0, 0, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), -2, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), -2, 1, int(9223372036854775807), 0, 0, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), -1, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), -1, 1, int(9223372036854775806), 0, 0, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), -1, 2, int(-9223372036854775807), 0, 1, some(int(int(-9223372036854775807))), none(int), some(int(int(-9223372036854775807))), some(low(int)), false, 0),
        (int(-9223372036854775807), 0, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), 0, 1, int(9223372036854775806), 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), 0, 2, int(-9223372036854775807), 0, 2, some(int(int(-9223372036854775807))), none(int), some(int(int(-9223372036854775807))), none(int), false, 0),
        (int(-9223372036854775807), 0, 3, int(-9223372036854775807), 0, 3, some(int(int(-9223372036854775807))), none(int), some(int(int(-9223372036854775807))), none(int), false, 0),
        (int(-9223372036854775807), 0, 5, 1, 5, 5, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), false, 0),
        (int(-9223372036854775807), 1, 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), 1, 1, -1, 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), 1, 2, 0, 2, 2, none(int), none(int), some(int(int(-9223372036854775806))), some(int(int(-9223372036854775806))), false, 0),
        (int(-9223372036854775807), 1, 3, int(9223372036854775806), 3, 3, none(int), none(int), some(int(int(-9223372036854775805))), some(int(int(-9223372036854775805))), false, 0),
        (int(-9223372036854775807), 1, 5, 0, 5, 5, none(int), none(int), some(int(int(-9223372036854775803))), some(int(int(-9223372036854775803))), false, 0),
        (int(-9223372036854775807), 2, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), 2, 1, 0, 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), 2, 2, low(int), 0, 0, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), false, 0),
        (int(-9223372036854775807), 2, 3, int(-9223372036854775807), 0, 1, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775805))), some(int(int(-9223372036854775807))), none(int), false, 0),
        (int(-9223372036854775807), 2, 5, -1, 5, 5, none(int), none(int), some(int(int(-9223372036854775799))), some(int(int(-9223372036854775799))), false, 0),
        (int(-9223372036854775807), int(9223372036854775807), 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), int(9223372036854775807), 1, -1, 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), int(9223372036854775807), 2, 1, 2, 2, none(int), none(int), some(int(0)), some(int(0)), true, int(-9223372036854775807)),
        (int(-9223372036854775807), int(9223372036854775807), 3, int(-9223372036854775807), 0, 1, some(int(int(-9223372036854775807))), some(int(0)), some(int(int(-9223372036854775807))), none(int), true, 0),
        (int(-9223372036854775807), low(int), 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), low(int), 1, low(int), 1, 1, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), true, int(-9223372036854775807)),
        (int(-9223372036854775807), int(-9223372036854775807), 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), int(-9223372036854775807), 1, low(int), 1, 1, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), true, int(-9223372036854775807)),
        (int(-9223372036854775807), -2, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), -2, 1, low(int), 1, 1, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), true, int(-9223372036854775807)),
        (int(-9223372036854775807), -1, 0, -1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), -1, 1, 1, 0, 0, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), -1, 2, 0, 0, 0, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), false, 0),
        (int(-9223372036854775807), 0, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), 0, 1, int(-9223372036854775807), 0, 1, some(int(int(-9223372036854775807))), none(int), some(int(int(-9223372036854775807))), none(int), true, int(-9223372036854775807)),
        (int(-9223372036854775807), 0, 2, 1, 2, 2, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), false, 0),
        (int(-9223372036854775807), 0, 3, 0, 3, 3, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), false, 0),
        (int(-9223372036854775807), 0, 5, int(-9223372036854775807), 0, 5, some(int(int(-9223372036854775807))), none(int), some(int(int(-9223372036854775807))), none(int), false, 0),
        (int(-9223372036854775807), 1, 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), 1, 1, int(9223372036854775807), 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), 1, 2, int(9223372036854775806), 2, 2, none(int), none(int), some(int(int(-9223372036854775806))), some(int(int(-9223372036854775806))), false, 0),
        (int(-9223372036854775807), 1, 3, low(int), 0, 0, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), false, 0),
        (int(-9223372036854775807), 1, 5, 1, 5, 5, none(int), none(int), some(int(int(-9223372036854775803))), some(int(int(-9223372036854775803))), false, 0),
        (int(-9223372036854775807), 2, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), 2, 1, 0, 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), 2, 2, 1, 2, 2, none(int), none(int), some(int(int(-9223372036854775805))), some(int(int(-9223372036854775805))), false, 0),
        (int(-9223372036854775807), 2, 3, int(9223372036854775806), 3, 3, none(int), none(int), some(int(int(-9223372036854775803))), some(int(int(-9223372036854775803))), false, 0),
        (int(-9223372036854775807), 2, 5, int(9223372036854775807), 5, 5, none(int), none(int), some(int(int(-9223372036854775799))), some(int(int(-9223372036854775799))), false, 0),
        (int(-9223372036854775807), int(9223372036854775807), 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(-9223372036854775807), int(9223372036854775807), 1, -1, 1, 1, none(int), none(int), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (int(-9223372036854775807), int(9223372036854775807), 2, 1, 2, 2, none(int), none(int), some(int(0)), some(int(0)), true, int(-9223372036854775807)),
        (int(-9223372036854775807), int(9223372036854775807), 3, low(int), 0, 0, some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), none(int), none(int), true, 0),
        (-1, low(int), 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, low(int), 1, low(int), 1, 1, some(int(-1)), some(int(-1)), none(int), none(int), true, -1),
        (-1, int(-9223372036854775807), 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, int(-9223372036854775807), 1, 1, 0, 0, none(int), none(int), some(int(-1)), some(int(-1)), true, -1),
        (-1, int(-9223372036854775807), 2, low(int), 1, 2, some(low(int)), some(int(-1)), some(low(int)), none(int), false, 0),
        (-1, -2, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, -2, 1, -1, 0, 1, some(int(-1)), none(int), some(int(-1)), none(int), true, -1),
        (-1, -2, 2, -1, 0, 1, some(int(-1)), none(int), some(int(-1)), some(int(-3)), true, -4),
        (-1, -2, 3, int(9223372036854775807), 0, 0, none(int), none(int), some(int(-1)), some(int(-1)), true, -9),
        (-1, -2, 5, 1, 0, 0, none(int), none(int), some(int(-1)), some(int(-1)), true, -25),
        (-1, -1, 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, -1, 1, 0, 0, 0, none(int), none(int), some(int(-1)), some(int(-1)), true, -1),
        (-1, -1, 2, -1, 0, 1, some(int(-1)), none(int), some(int(-1)), some(int(-2)), true, -3),
        (-1, -1, 3, 1, 0, 0, none(int), none(int), some(int(-1)), some(int(-1)), true, -6),
        (-1, -1, 5, low(int), 5, 5, some(int(-5)), some(int(-5)), none(int), none(int), true, -15),
        (-1, 0, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, 0, 1, 1, 1, 1, none(int), none(int), some(int(-1)), some(int(-1)), true, -1),
        (-1, 0, 2, int(9223372036854775807), 2, 2, none(int), none(int), some(int(-1)), some(int(-1)), true, -2),
        (-1, 0, 3, -1, 0, 3, some(int(-1)), none(int), some(int(-1)), none(int), true, -3),
        (-1, 0, 5, int(9223372036854775806), 5, 5, none(int), none(int), some(int(-1)), some(int(-1)), true, -5),
        (-1, 1, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, 1, 1, -1, 0, 1, some(int(-1)), none(int), some(int(-1)), none(int), true, -1),
        (-1, 1, 2, -1, 0, 1, some(int(-1)), some(int(0)), some(int(-1)), none(int), true, -1),
        (-1, 1, 3, low(int), 0, 0, some(int(-1)), some(int(-1)), none(int), none(int), true, 0),
        (-1, 1, 5, -1, 0, 1, some(int(-1)), some(int(0)), some(int(-1)), none(int), true, 5),
        (-1, 2, 0, -1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, 2, 1, -1, 0, 1, some(int(-1)), none(int), some(int(-1)), none(int), true, -1),
        (-1, 2, 2, int(9223372036854775806), 2, 2, none(int), none(int), some(int(1)), some(int(1)), true, 0),
        (-1, 2, 3, 1, 1, 2, some(int(1)), some(int(3)), some(int(1)), some(int(-1)), true, 3),
        (-1, 2, 5, int(9223372036854775806), 5, 5, none(int), none(int), some(int(7)), some(int(7)), true, 15),
        (-1, int(9223372036854775807), 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (-1, int(9223372036854775807), 1, 1, 1, 1, none(int), none(int), some(int(-1)), some(int(-1)), true, -1),
        (-1, int(9223372036854775807), 2, int(9223372036854775806), 1, 2, some(int(int(9223372036854775806))), none(int), some(int(int(9223372036854775806))), some(int(-1)), true, int(9223372036854775805)),
        (0, low(int), 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, low(int), 1, low(int), 1, 1, some(int(0)), some(int(0)), none(int), none(int), true, 0),
        (0, low(int), 2, low(int), 1, 2, some(low(int)), some(int(0)), some(low(int)), none(int), true, low(int)),
        (0, int(-9223372036854775807), 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, int(-9223372036854775807), 1, int(-9223372036854775807), 1, 1, some(int(0)), some(int(0)), none(int), none(int), true, 0),
        (0, int(-9223372036854775807), 2, 0, 0, 1, some(int(0)), none(int), some(int(0)), some(int(int(-9223372036854775807))), true, int(-9223372036854775807)),
        (0, -2, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, -2, 1, 0, 0, 1, some(int(0)), none(int), some(int(0)), none(int), true, 0),
        (0, -2, 2, int(9223372036854775807), 0, 0, none(int), none(int), some(int(0)), some(int(0)), true, -2),
        (0, -2, 3, 0, 0, 1, some(int(0)), none(int), some(int(0)), some(int(-2)), true, -6),
        (0, -2, 5, int(-9223372036854775807), 5, 5, some(int(-8)), some(int(-8)), none(int), none(int), true, -20),
        (0, -1, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, -1, 1, 0, 0, 1, some(int(0)), none(int), some(int(0)), none(int), true, 0),
        (0, -1, 2, int(9223372036854775807), 0, 0, none(int), none(int), some(int(0)), some(int(0)), true, -1),
        (0, -1, 3, int(-9223372036854775807), 3, 3, some(int(-2)), some(int(-2)), none(int), none(int), true, -3),
        (0, -1, 5, 1, 0, 0, none(int), none(int), some(int(0)), some(int(0)), true, -10),
        (0, 0, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, 0, 1, low(int), 0, 0, some(int(0)), some(int(0)), none(int), none(int), true, 0),
        (0, 0, 2, -1, 0, 0, some(int(0)), some(int(0)), none(int), none(int), true, 0),
        (0, 0, 3, int(9223372036854775807), 3, 3, none(int), none(int), some(int(0)), some(int(0)), true, 0),
        (0, 0, 5, -1, 0, 0, some(int(0)), some(int(0)), none(int), none(int), true, 0),
        (0, 1, 0, -1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, 1, 1, int(9223372036854775806), 1, 1, none(int), none(int), some(int(0)), some(int(0)), true, 0),
        (0, 1, 2, int(9223372036854775807), 2, 2, none(int), none(int), some(int(1)), some(int(1)), true, 1),
        (0, 1, 3, -1, 0, 0, some(int(0)), some(int(0)), none(int), none(int), true, 3),
        (0, 1, 5, int(9223372036854775806), 5, 5, none(int), none(int), some(int(4)), some(int(4)), true, 10),
        (0, 2, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, 2, 1, 1, 1, 1, none(int), none(int), some(int(0)), some(int(0)), true, 0),
        (0, 2, 2, 1, 1, 1, some(int(2)), some(int(2)), some(int(0)), some(int(0)), true, 2),
        (0, 2, 3, int(9223372036854775806), 3, 3, none(int), none(int), some(int(4)), some(int(4)), true, 6),
        (0, 2, 5, 0, 0, 1, some(int(0)), some(int(2)), some(int(0)), none(int), true, 20),
        (0, int(9223372036854775807), 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (0, int(9223372036854775807), 1, -1, 0, 0, some(int(0)), some(int(0)), none(int), none(int), true, 0),
        (0, int(9223372036854775807), 2, int(9223372036854775806), 1, 1, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), some(int(0)), some(int(0)), true, int(9223372036854775807)),
        (1, low(int), 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, low(int), 1, low(int), 1, 1, some(int(1)), some(int(1)), none(int), none(int), true, 1),
        (1, low(int), 2, -1, 1, 1, some(int(1)), some(int(1)), some(int(int(-9223372036854775807))), some(int(int(-9223372036854775807))), true, int(-9223372036854775806)),
        (1, int(-9223372036854775807), 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, int(-9223372036854775807), 1, low(int), 1, 1, some(int(1)), some(int(1)), none(int), none(int), true, 1),
        (1, int(-9223372036854775807), 2, low(int), 2, 2, some(int(int(-9223372036854775806))), some(int(int(-9223372036854775806))), none(int), none(int), true, int(-9223372036854775805)),
        (1, -2, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, -2, 1, int(9223372036854775807), 0, 0, none(int), none(int), some(int(1)), some(int(1)), true, 1),
        (1, -2, 2, int(9223372036854775807), 0, 0, none(int), none(int), some(int(1)), some(int(1)), true, 0),
        (1, -2, 3, int(9223372036854775807), 0, 0, none(int), none(int), some(int(1)), some(int(1)), true, -3),
        (1, -2, 5, int(-9223372036854775807), 5, 5, some(int(-7)), some(int(-7)), none(int), none(int), true, -15),
        (1, -1, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, -1, 1, int(-9223372036854775807), 1, 1, some(int(1)), some(int(1)), none(int), none(int), true, 1),
        (1, -1, 2, int(9223372036854775806), 0, 0, none(int), none(int), some(int(1)), some(int(1)), true, 1),
        (1, -1, 3, int(-9223372036854775807), 3, 3, some(int(-1)), some(int(-1)), none(int), none(int), true, 0),
        (1, -1, 5, int(9223372036854775806), 0, 0, none(int), none(int), some(int(1)), some(int(1)), true, -5),
        (1, 0, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, 0, 1, int(-9223372036854775807), 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 1),
        (1, 0, 2, int(9223372036854775806), 2, 2, none(int), none(int), some(int(1)), some(int(1)), true, 2),
        (1, 0, 3, 1, 0, 3, some(int(1)), none(int), some(int(1)), none(int), true, 3),
        (1, 0, 5, 0, 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 5),
        (1, 1, 0, 0, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, 1, 1, int(9223372036854775807), 1, 1, none(int), none(int), some(int(1)), some(int(1)), true, 1),
        (1, 1, 2, -1, 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 3),
        (1, 1, 3, int(9223372036854775807), 3, 3, none(int), none(int), some(int(3)), some(int(3)), true, 6),
        (1, 1, 5, 1, 0, 1, some(int(1)), some(int(2)), some(int(1)), none(int), true, 15),
        (1, 2, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, 2, 1, -1, 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 1),
        (1, 2, 2, 1, 0, 1, some(int(1)), some(int(3)), some(int(1)), none(int), true, 4),
        (1, 2, 3, int(-9223372036854775807), 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 9),
        (1, 2, 5, low(int), 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 25),
        (1, int(9223372036854775807), 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (1, int(9223372036854775807), 1, -1, 0, 0, some(int(1)), some(int(1)), none(int), none(int), true, 1),
        (int(9223372036854775806), low(int), 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), low(int), 1, 0, 1, 1, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), none(int), none(int), true, int(9223372036854775806)),
        (int(9223372036854775806), low(int), 2, int(-9223372036854775807), 2, 2, some(int(-2)), some(int(-2)), none(int), none(int), true, int(9223372036854775804)),
        (int(9223372036854775806), int(-9223372036854775807), 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), int(-9223372036854775807), 1, int(9223372036854775807), 0, 0, none(int), none(int), some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), true, int(9223372036854775806)),
        (int(9223372036854775806), int(-9223372036854775807), 2, int(9223372036854775807), 0, 0, none(int), none(int), some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), true, int(9223372036854775805)),
        (int(9223372036854775806), int(-9223372036854775807), 3, 0, 1, 1, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), some(int(-1)), some(int(-1)), true, -3),
        (int(9223372036854775806), -2, 0, 1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), -2, 1, int(9223372036854775806), 0, 1, some(int(int(9223372036854775806))), none(int), some(int(int(9223372036854775806))), none(int), true, int(9223372036854775806)),
        (int(9223372036854775806), -2, 2, 0, 2, 2, some(int(int(9223372036854775804))), some(int(int(9223372036854775804))), none(int), none(int), false, 0),
        (int(9223372036854775806), -2, 3, low(int), 3, 3, some(int(int(9223372036854775802))), some(int(int(9223372036854775802))), none(int), none(int), false, 0),
        (int(9223372036854775806), -2, 5, -1, 5, 5, some(int(int(9223372036854775798))), some(int(int(9223372036854775798))), none(int), none(int), false, 0),
        (int(9223372036854775806), -1, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), -1, 1, -1, 1, 1, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), none(int), none(int), true, int(9223372036854775806)),
        (int(9223372036854775806), -1, 2, -1, 2, 2, some(int(int(9223372036854775805))), some(int(int(9223372036854775805))), none(int), none(int), false, 0),
        (int(9223372036854775806), -1, 3, int(9223372036854775806), 0, 1, some(int(int(9223372036854775806))), none(int), some(int(int(9223372036854775806))), some(int(int(9223372036854775805))), false, 0),
        (int(9223372036854775806), -1, 5, int(9223372036854775806), 0, 1, some(int(int(9223372036854775806))), none(int), some(int(int(9223372036854775806))), some(int(int(9223372036854775805))), false, 0),
        (int(9223372036854775806), 0, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), 0, 1, int(9223372036854775807), 1, 1, none(int), none(int), some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), true, int(9223372036854775806)),
        (int(9223372036854775806), 0, 2, int(-9223372036854775807), 0, 0, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), none(int), none(int), false, 0),
        (int(9223372036854775806), 0, 3, low(int), 0, 0, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), none(int), none(int), false, 0),
        (int(9223372036854775806), 0, 5, -1, 0, 0, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), none(int), none(int), false, 0),
        (int(9223372036854775806), 1, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), 1, 1, int(9223372036854775806), 0, 1, some(int(int(9223372036854775806))), none(int), some(int(int(9223372036854775806))), none(int), true, int(9223372036854775806)),
        (int(9223372036854775806), 1, 2, int(9223372036854775807), 1, 2, some(int(int(9223372036854775807))), none(int), some(int(int(9223372036854775807))), some(int(int(9223372036854775806))), false, 0),
        (int(9223372036854775806), 2, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), 2, 1, int(9223372036854775807), 1, 1, none(int), none(int), some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), true, int(9223372036854775806)),
        (int(9223372036854775806), int(9223372036854775807), 0, -1, 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775806), int(9223372036854775807), 1, int(-9223372036854775807), 0, 0, some(int(int(9223372036854775806))), some(int(int(9223372036854775806))), none(int), none(int), true, int(9223372036854775806)),
        (int(9223372036854775807), low(int), 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), low(int), 1, 0, 1, 1, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), low(int), 2, int(-9223372036854775807), 2, 2, some(int(-1)), some(int(-1)), none(int), none(int), true, int(9223372036854775806)),
        (int(9223372036854775807), int(-9223372036854775807), 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), int(-9223372036854775807), 1, -1, 1, 1, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), int(-9223372036854775807), 2, 1, 1, 1, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), some(int(0)), some(int(0)), true, int(9223372036854775807)),
        (int(9223372036854775807), int(-9223372036854775807), 3, int(-9223372036854775807), 2, 3, some(int(int(-9223372036854775807))), some(int(0)), some(int(int(-9223372036854775807))), none(int), true, 0),
        (int(9223372036854775807), -2, 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), -2, 1, int(9223372036854775806), 1, 1, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), -2, 2, low(int), 2, 2, some(int(int(9223372036854775805))), some(int(int(9223372036854775805))), none(int), none(int), false, 0),
        (int(9223372036854775807), -2, 3, low(int), 3, 3, some(int(int(9223372036854775803))), some(int(int(9223372036854775803))), none(int), none(int), false, 0),
        (int(9223372036854775807), -2, 5, -1, 5, 5, some(int(int(9223372036854775799))), some(int(int(9223372036854775799))), none(int), none(int), false, 0),
        (int(9223372036854775807), -1, 0, int(-9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), -1, 1, 0, 1, 1, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), -1, 2, int(9223372036854775807), 0, 1, some(int(int(9223372036854775807))), none(int), some(int(int(9223372036854775807))), some(int(int(9223372036854775806))), false, 0),
        (int(9223372036854775807), -1, 3, int(-9223372036854775807), 3, 3, some(int(int(9223372036854775805))), some(int(int(9223372036854775805))), none(int), none(int), false, 0),
        (int(9223372036854775807), -1, 5, -1, 5, 5, some(int(int(9223372036854775803))), some(int(int(9223372036854775803))), none(int), none(int), false, 0),
        (int(9223372036854775807), 0, 0, low(int), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), 0, 1, -1, 0, 0, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), 0, 2, 1, 0, 0, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), false, 0),
        (int(9223372036854775807), 0, 3, 1, 0, 0, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), false, 0),
        (int(9223372036854775807), 0, 5, int(9223372036854775806), 0, 0, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), false, 0),
        (int(9223372036854775807), 1, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), 1, 1, int(9223372036854775807), 0, 1, some(int(int(9223372036854775807))), none(int), some(int(int(9223372036854775807))), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), 2, 0, int(9223372036854775806), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), 2, 1, 0, 0, 0, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807)),
        (int(9223372036854775807), int(9223372036854775807), 0, int(9223372036854775807), 0, 0, none(int), none(int), none(int), none(int), true, 0),
        (int(9223372036854775807), int(9223372036854775807), 1, 1, 0, 0, some(int(int(9223372036854775807))), some(int(int(9223372036854775807))), none(int), none(int), true, int(9223372036854775807))
    ]
    for c in wideCases:
        let p = initArithmeticProgression(c[0], c[1], c[2])
        doAssert p.lowerBound(c[3]) == c[4]
        doAssert p.upperBound(c[3]) == c[5]
        doAssert p.minGe(c[3]) == c[6]
        doAssert p.minGt(c[3]) == c[7]
        doAssert p.maxLe(c[3]) == c[8]
        doAssert p.maxLt(c[3]) == c[9]
        if c[10]: doAssert p.sum == c[11]
        else:
            raises(ValueError): discard p.sum

static:
    let p = initArithmeticRange(9, -5, -3)
    doAssert p.len == 5
    doAssert p.sum == 15
    doAssert p.minGe(1) == some(3)
    doAssert p.lowerBound(3) == 2
    doAssert p.slice(-1, -6, -1).first == -3

{.pop.}
echo "Hello World"
