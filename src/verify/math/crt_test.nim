# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, random
import cplib/math/crt
import cplib/math/bigint

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
doAssert crt([high(int) - 1, -1], [high(int), high(int)]) == (high(int) - 1,
        high(int))
doAssert crt([0, 1], [high(int) - 1, 2]) == (0, 0)
let shared = high(int) div 3
let period = shared * 3
doAssert crt([period - 1, -1], [period, shared]) == (period - 1, period)
doAssert crt([low(int), low(int)], [high(int) - 1, 2]) == (high(int) - 3, high(
        int) - 1)
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

proc checkLarge(r, m: seq[int]) =
    let zero = initBigInt(0)
    let one = initBigInt(1)
    let limit = initBigInt(high(int))
    var period = one
    var inconsistent, overflow = false
    for endIndex in 0..<m.len:
        for i in 0..<endIndex:
            let difference = initBigInt(r[i]) - initBigInt(r[endIndex])
            if difference mod initBigInt(gcd(m[i], m[endIndex])) != zero:
                inconsistent = true
        if inconsistent: break
        let modulus = initBigInt(m[endIndex])
        period = period div gcd(period, modulus) * modulus
        if period > limit:
            overflow = true
            break
    if overflow:
        expectOverflow(r, m)
    elif inconsistent:
        doAssert crt(r, m) == (0, 0)
    else:
        var value = zero
        var product = one
        for i in 0..<m.len:
            let modulus = initBigInt(m[i])
            let divisor = gcd(product, modulus)
            let factor = modulus div divisor
            var a = product div divisor
            var b = factor
            var inverse = one
            var nextInverse = zero
            while b != zero:
                let quotient = a div b
                (a, b) = (b, a - quotient * b)
                (inverse, nextInverse) = (nextInverse, inverse - quotient * nextInverse)
            let delta = (initBigInt(r[i]) - value) div divisor
            var shift = delta * inverse mod factor
            if shift < zero: shift += factor
            value += product * shift
            product *= factor
        let actual = crt(r, m)
        doAssert initBigInt(actual.r) == value
        doAssert initBigInt(actual.m) == period
        doAssert actual.r >= 0 and actual.r < actual.m

when sizeof(int) == 8:
    let boundaries = [low(int), low(int) + 1, -1, 0, 1, high(int) - 1, high(int)]
    let moduliForLarge = [1, 2, 3, 4, 7, 97, int((1'i64 shl 31) - 1),
                  int(1'i64 shl 32), high(int) div 3, high(int) div 2,
                  high(int) - 1, high(int)]
    for a in moduliForLarge:
        for b in moduliForLarge:
            for r in boundaries:
                for s in boundaries:
                    checkLarge(@[r, s], @[a, b])
    var largeRng = initRand(247)
    for iteration in 0..<3000:
        var residues, moduli: seq[int]
        for i in 0..<largeRng.rand(1..6):
            let modulus = if largeRng.rand(1) == 0:
                largeRng.rand(1..high(int))
            else: moduliForLarge[largeRng.rand(moduliForLarge.high)]
            moduli.add(modulus)
            let magnitude = largeRng.rand(0..high(int))
            residues.add(if largeRng.rand(1) == 0: magnitude else: -magnitude - 1)
        checkLarge(residues, moduli)
        let value = largeRng.rand(0..high(int))
        for i in 0..<residues.len: residues[i] = value
        checkLarge(residues, moduli)
        let divisor = largeRng.rand(1..high(int) div 120)
        for i in 0..<moduli.len: moduli[i] = divisor * largeRng.rand(1..10)
        checkLarge(residues, moduli)

proc oversleeping(x, y, p, q: int): int =
    result = high(int)
    for a in x..<x+y:
        for b in p..<p+q:
            let answer = crt([a, b], [2*(x+y), p+q])
            if answer.m != 0: result = min(result, answer.r)

for x in 1..4:
    for y in 1..4:
        for p in 1..4:
            for q in 1..4:
                var expected = high(int)
                for t in 0..<lcm(2*(x+y), p+q):
                    if x <= t mod (2*(x+y)) and t mod (2*(x+y)) < x+y and
                            p <= t mod (p+q) and t mod (p+q) < p+q:
                        expected = t
                        break
                doAssert oversleeping(x, y, p, q) == expected

doAssert oversleeping(5, 2, 7, 6) == 20
doAssert oversleeping(1, 1, 3, 1) == high(int)
when sizeof(int) == 8:
    doAssert oversleeping(999999999, 1, 1000000000, 1) == 1000000000999999999'i64

echo "Hello World"
