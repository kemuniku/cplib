# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

import random
import cplib/collections/bitset_avx512
include cplib/collections/private/bitset_avx512_impl

proc addCarries(generated, propagated, carry: cuint): cuint {.importc: "cplib_bs512_add_carries", nodecl.}

for generated in 0..255:
    for propagated in 0..255:
        if (generated and propagated) != 0:
            continue
        for incoming in 0..1:
            var carry = incoming
            var expected = incoming
            for lane in 0..<8:
                carry = ((generated shr lane) and 1) or (((propagated shr lane) and 1) and carry)
                expected = expected or (carry shl (lane + 1))
            doAssert addCarries(generated.cuint, propagated.cuint, incoming.cuint) == expected.cuint

proc check(a, b: seq[bool]) =
    var expected = newSeq[bool](a.len)
    var carry = 0
    for i in 0..<a.len:
        let sum = ord(a[i]) + ord(b[i]) + carry
        expected[i] = (sum and 1) != 0
        carry = sum shr 1
    var x = initBitSet(a)
    var y = initBitSet(b)
    var dst = initBitSet(a.len)
    dst.fill()
    dst.addInto(x, y)
    doAssert $dst == $initBitSet(expected)
    doAssert $x == $initBitSet(a)
    doAssert $y == $initBitSet(b)
    x.addInto(x, y)
    doAssert $x == $dst
    x = initBitSet(a)
    y.addInto(x, y)
    doAssert $y == $dst
    dst.addInto(x, x)
    x.addInto(x, x)
    doAssert $x == $dst

var rng = initRand(71283)
for n in [0, 1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023, 1024, 1025, 4097]:
    var a = newSeq[bool](n)
    var b = newSeq[bool](n)
    check(a, b)
    for i in 0..<n:
        a[i] = true
    if n > 0:
        b[0] = true
    check(a, b)
    check(a, a)
    for trial in 0..<50:
        for i in 0..<n:
            a[i] = rng.rand(1) == 1
            b[i] = rng.rand(1) == 1
        check(a, b)

when compileOption("boundChecks"):
    var dst = initBitSet(1)
    var raised = false
    try:
        dst.addInto(initBitSet(1), initBitSet(2))
    except ValueError:
        raised = true
    doAssert raised
    raised = false
    try:
        dst.addInto(initBitSet(2), initBitSet(2))
    except ValueError:
        raised = true
    doAssert raised

echo "Hello World"
