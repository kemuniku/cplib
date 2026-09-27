# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import math, random, sets
import cplib/utils/golden_section_search

proc checkInteger(values: seq[int], left: int, maximize: bool) =
    var seen = initHashSet[int]()
    proc f(x: int): int =
        doAssert left <= x and x <= left + values.high
        doAssert x notin seen
        seen.incl(x)
        values[x - left]
    let answer = golden_section_search(left, left + values.high, f,
        maximize = maximize)
    var expected = values[0]
    for value in values:
        if (if maximize: expected < value else: value < expected):
            expected = value
    doAssert left <= answer.x and answer.x <= left + values.high
    doAssert answer.fx == values[answer.x - left]
    doAssert answer.fx == expected
    doAssert seen.len <= 2 + int(ceil(ln(float(values.len + 1)) / ln(1.618033988749895)))

block:
    var rng = initRand(20260926)
    for n in 1..24:
        for first in 0..<n:
            for last in first..<n:
                var values = newSeq[int](n)
                for i in countdown(first - 1, 0):
                    values[i] = values[i + 1] + rng.rand(1..20)
                for i in last + 1..<n:
                    values[i] = values[i - 1] + rng.rand(1..20)
                checkInteger(values, -n div 2, false)
                for value in values.mitems: value = -value
                checkInteger(values, -n div 2, true)
    for _ in 0..<1000:
        let n = rng.rand(1..1000)
        let first = rng.rand(0..<n)
        let last = rng.rand(first..<n)
        var values = newSeq[int](n)
        for i in countdown(first - 1, 0):
            values[i] = values[i + 1] + rng.rand(1..100)
        for i in last + 1..<n:
            values[i] = values[i - 1] + rng.rand(1..100)
        checkInteger(values, rng.rand(-10000..10000), false)
        for value in values.mitems: value = -value
        checkInteger(values, rng.rand(-10000..10000), true)

block:
    proc f(x: int): float = float((x - 7) * (x - 7)) + 0.5
    let answer = golden_section_search(-10, 20, f)
    doAssert answer == (x: 7, fx: 0.5)

type Score = object
    value: int
proc `<`(a, b: Score): bool = a.value < b.value

block:
    proc f(x: int): Score = Score(value: abs(x - 4))
    let answer = golden_section_search(-20, 20, f)
    doAssert answer.x == 4 and answer.fx.value == 0
    let maximum = golden_section_search(-20, 4, f, maximize = true)
    doAssert maximum.x == -20 and maximum.fx.value == 24

block:
    proc checkWide(left, right: int, maximize: bool) =
        var seen = initHashSet[int]()
        proc f(x: int): int =
            doAssert left <= x and x <= right
            doAssert x notin seen
            seen.incl(x)
            x
        let answer = golden_section_search(left, right, f, maximize = maximize)
        let expected = if maximize: right else: left
        doAssert answer == (x: expected, fx: expected)
        doAssert seen.len <= sizeof(int) * 12 + 2
    for (left, right) in [(low(int), high(int)), (low(int), 0), (0, high(int)),
            (low(int), low(int)), (high(int), high(int)),
            (low(int), low(int) + 1), (high(int) - 1, high(int)),
            (low(int), low(int) + 100), (high(int) - 100, high(int))]:
        checkWide(left, right, false)
        checkWide(left, right, true)

    for target in [low(int), low(int) + 1, low(int) div 2, -1, 0, 1,
            high(int) div 2, high(int) - 1, high(int)]:
        for maximize in [false, true]:
            var seen = initHashSet[int]()
            proc f(x: int): uint =
                doAssert x notin seen
                seen.incl(x)
                let distance = if x < target:
                    cast[uint](target) - cast[uint](x)
                else:
                    cast[uint](x) - cast[uint](target)
                if maximize: high(uint) - distance else: distance
            let answer = golden_section_search(low(int), high(int), f,
                maximize = maximize)
            doAssert answer.x == target
            doAssert answer.fx == (if maximize: high(uint) else: 0'u)
            doAssert seen.len <= sizeof(int) * 12 + 2

proc checkFloat[T: SomeFloat](tolerance: T) =
    for target in [T(-12), T(-10), T(-3.125), T(0), T(4.375), T(10), T(12)]:
        for maximize in [false, true]:
            var calls = 0
            proc f(x: T): T =
                doAssert T(-10) <= x and x <= T(10)
                inc calls
                if maximize: -abs(x - target) else: abs(x - target)
            let answer = golden_section_search(T(-10), T(10), f,
                maximize = maximize)
            let expected = min(T(10), max(T(-10), target))
            doAssert abs(answer.x - expected) <= tolerance
            let expectedValue = if maximize: -abs(answer.x - target) else: abs(answer.x - target)
            doAssert answer.fx == expectedValue
            doAssert calls <= 104

    block:
        var calls = 0
        proc f(x: T): T =
            inc calls
            x * x
        let answer = golden_section_search(T(3), T(3), f)
        doAssert answer == (x: T(3), fx: T(9))
        doAssert calls == 1

    block:
        var calls = 0
        proc f(x: T): T =
            inc calls
            abs(x - T(0.25))
        let answer = golden_section_search(T(0), T(1), f, iterations = 0)
        doAssert T(0) <= answer.x and answer.x <= T(1)
        doAssert answer.fx == abs(answer.x - T(0.25))
        doAssert calls == 4
        let refined = golden_section_search(T(0), T(1), f, iterations = 20)
        doAssert refined.fx <= answer.fx

    block:
        proc f(x: T): T = max(T(0), abs(x) - T(2))
        let answer = golden_section_search(T(-10), T(10), f)
        doAssert abs(answer.x) <= T(2)
        doAssert answer.fx == T(0)

    block:
        proc f(x: T): T = T(7)
        let answer = golden_section_search(T(-10), T(10), f, iterations = 1000)
        doAssert T(-10) <= answer.x and answer.x <= T(10)
        doAssert answer.fx == T(7)

checkFloat[float64](1e-10)
checkFloat[float32](1e-5'f32)

block:
    for maximize in [false, true]:
        proc f(x: float): float =
            let value = (x - 3.0) * (x - 3.0) + 2.0
            if maximize: -value else: value
        let answer = golden_section_search(-10.0, 10.0, f, maximize = maximize)
        doAssert abs(answer.x - 3.0) <= 1e-7
        doAssert abs(abs(answer.fx) - 2.0) <= 1e-12

block:
    let left = 1.0
    let right = 1.0000000000000002
    var calls = 0
    proc f(x: float): float =
        doAssert x == left or x == right
        inc calls
        x
    doAssert golden_section_search(left, right, f).x == left
    doAssert calls == 2
    calls = 0
    doAssert golden_section_search(left, right, f, maximize = true).x == right
    doAssert calls == 2

block:
    for (left, right) in [(-1.7e308, 1.7e308), (1.6e308, 1.7e308),
            (-1.7e308, -1.6e308)]:
        for maximize in [false, true]:
            proc f(x: float): float =
                doAssert left <= x and x <= right
                let value = abs(x / 1e308 - 0.25)
                if maximize: -value else: value
            let answer = golden_section_search(left, right, f, maximize = maximize)
            let expected = max(left, min(right, 0.25e308))
            doAssert abs(answer.x / 1e308 - expected / 1e308) < 1e-12
            doAssert answer.fx == f(answer.x)

echo "Hello World"
