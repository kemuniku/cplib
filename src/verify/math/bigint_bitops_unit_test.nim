# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/math/bigint

proc checkBitwise(a, b: int) =
    let x = initBigInt(a)
    let y = initBigInt(b)
    doAssert (x and y) == initBigInt(a and b)
    doAssert (x or y) == initBigInt(a or b)
    doAssert (x xor y) == initBigInt(a xor b)
    doAssert (not x) == initBigInt(not a)
    doAssert (x and b) == (a and y)
    doAssert (x or b) == (a or y)
    doAssert (x xor b) == (a xor y)

for a in -40..40:
    for b in -40..40:
        checkBitwise(a, b)
for a in [low(int), low(int) + 1, -1, 0, 1, high(int)]:
    for b in [low(int), low(int) + 1, -1, 0, 1, high(int)]:
        checkBitwise(a, b)
var rng = initRand(20260913)
for _ in 0..<1000:
    checkBitwise(rng.rand(low(int)..high(int)), rng.rand(low(int)..high(int)))

for width in [0, 1, 29, 30, 31, 32, 33, 63, 64, 65, 127, 128, 129, 1024]:
    let power = initBigInt(2).pow(width)
    doAssert (initBigInt(1) shl width) == power
    for x in [power - 1, power, power + 1, -power - 1, -power, -power + 1]:
        let original = $x
        doAssert (not x) == -x - 1
        doAssert (not (not x)) == x
        doAssert (x and (not x)) == 0
        doAssert (x or (not x)) == -1
        doAssert (x xor (not x)) == -1
        doAssert (x and -1) == x
        doAssert (x or 0) == x
        doAssert (x xor x) == 0
        doAssert (x shr high(int)) == (if x < 0: -1 else: 0)
        for shift in [0, 1, 31, 32, 33, 63, 64, 65, 129, 1025]:
            let factor = initBigInt(2).pow(shift)
            doAssert (x shl shift) == x * factor
            doAssert (x shr shift) == x // factor
            doAssert ((x shl shift) shr shift) == x
            var assigned = x
            `shl=`(assigned, shift)
            doAssert assigned == x * factor
            `shr=`(assigned, shift)
            doAssert assigned == x
        let y = initBigInt("1234567890123456789012345678901234567890")
        doAssert (not (x and y)) == ((not x) or (not y))
        doAssert (not (x or y)) == ((not x) and (not y))
        var assigned = x
        `and=`(assigned, y)
        doAssert assigned == (x and y)
        assigned = x
        `or=`(assigned, y)
        doAssert assigned == (x or y)
        assigned = x
        `xor=`(assigned, y)
        doAssert assigned == (x xor y)
        assigned = x
        `and=`(assigned, assigned)
        doAssert assigned == x
        `or=`(assigned, assigned)
        doAssert assigned == x
        `xor=`(assigned, assigned)
        doAssert assigned == 0
        doAssert (x xor x).sgn == 0
        doAssert $x == original

for x in [initBigInt(0), initBigInt(1), initBigInt(-1)]:
    for shift in [-1, low(int)]:
        doAssertRaises(ValueError):
            discard x shl shift
        doAssertRaises(ValueError):
            discard x shr shift
        var assigned = x
        doAssertRaises(ValueError):
            `shl=`(assigned, shift)
        doAssert assigned == x
        doAssertRaises(ValueError):
            `shr=`(assigned, shift)
        doAssert assigned == x
doAssert (initBigInt(0) shl high(int)) == 0

static:
    let x = initBigInt("18446744073709551615")
    doAssert (x shl 64) == initBigInt("340282366920938463444927863358058659840")
    doAssert (-x shr 64) == -1
    doAssert (x and (initBigInt(1) shl 64)) == 0
    doAssert (x or (initBigInt(1) shl 64)) == initBigInt("36893488147419103231")
    doAssert (x xor -1) == -x - 1
    doAssert (not x) == -x - 1

echo "Hello World"
