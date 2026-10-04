# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, random
import cplib/math/crt

proc normalized(a, m: int): int =
    result = a mod m
    if result < 0: result += m

proc checkSmall(r, m: seq[int]) =
    var period = 1
    for modulus in m: period = lcm(period, modulus)
    var expected = (0, 0)
    var solutions = 0
    for x in 0..<period:
        var valid = true
        for i in 0..<r.len:
            if x mod m[i] != normalized(r[i], m[i]): valid = false
        if valid:
            expected = (x, period)
            inc solutions
    doAssert solutions <= 1
    doAssert crt(r, m) == expected
    var rr, mm: seq[int]
    for i in countdown(r.len - 1, 0):
        rr.add(r[i] + 3 * m[i])
        mm.add(m[i])
    doAssert crt(rr, mm) == expected
    if m.len > 0:
        rr.add(r[0])
        mm.add(m[0])
        doAssert crt(rr, mm) == expected

doAssert crt([], []) == (0, 1)
doAssert crt([2, 3, 2], [3, 5, 7]) == (23, 105)
doAssert crt([4, 4], [6, 8]) == (4, 24)
doAssert crt([0, 1], [2, 4]) == (0, 0)
doAssert crt([-1, -1], [3, 5]) == (14, 15)
doAssert crt([100, -999], [1, 1]) == (0, 1)
doAssert crt([3, 3, 3], [4, 8, 8]) == (3, 8)

for m0 in 1..12:
    for m1 in 1..12:
        for r0 in 0..<m0:
            for r1 in 0..<m1:
                checkSmall(@[r0, r1], @[m0, m1])
var rng = initRand(193)
for iteration in 0..<1000:
    var r, m: seq[int]
    for i in 0..<rng.rand(0..5):
        m.add(rng.rand(1..10))
        r.add(rng.rand(-100..100))
    checkSmall(r, m)

proc expectInvalid(r, m: seq[int]) =
    var caught = false
    try: discard crt(r, m)
    except ValueError: caught = true
    doAssert caught

expectInvalid(@[0], @[])
expectInvalid(@[], @[1])
expectInvalid(@[0], @[0])
expectInvalid(@[0], @[-1])
expectInvalid(@[0], @[low(int)])
expectInvalid(@[0, 1, 0], @[2, 2, 0])

doAssert crt([low(int)], [high(int)]) == (high(int) - 1, high(int))
doAssert crt([low(int), high(int)], [1, high(int)]) == (0, high(int))
doAssert crt([high(int) - 1, -1], [high(int), high(int)]) == (high(int) - 1, high(int))
doAssert crt([0, 1], [high(int) - 1, 2]) == (0, 0)
let shared = high(int) div 3
let period = shared * 3
doAssert crt([period - 1, -1], [period, shared]) == (period - 1, period)
doAssert crt([low(int), low(int)], [high(int) - 1, 2]) == (high(int) - 3, high(int) - 1)
doAssert crt([0, 0], [high(int) div 2, 2]) == (0, high(int) - 1)
doAssert crt([high(int) - 1, 0], [high(int), 1]) == (high(int) - 1, high(int))
doAssert crt([int(uint(high(int)))], [high(int)]) == (0, high(int))

proc expectOverflow(r, m: seq[int]) =
    var caught = false
    try: discard crt(r, m)
    except OverflowDefect: caught = true
    doAssert caught

expectOverflow(@[0, 0], @[high(int), 2])
expectOverflow(@[0, 0], @[high(int), high(int) - 1])
expectOverflow(@[0, 0, 1], @[high(int), 2, 2])

echo "Hello World"
