# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/bitset_avx512

proc add(a, b: seq[bool]): seq[bool] =
    result = newSeq[bool](a.len)
    var carry = 0
    for i in 0..<a.len:
        let total = ord(a[i]) + ord(b[i]) + carry
        result[i] = (total and 1) != 0
        carry = total shr 1

proc check(x: BitSetAvx512, a: seq[bool]) =
    doAssert x.len == a.len
    var count = 0
    for i, v in a:
        doAssert x[i] == v
        count += ord(v)
    doAssert x.popcount == count

var rng = initRand(582173)
for n in [1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513,
          575, 576, 577, 1023, 1024, 1025, 4097]:
    for trial in 0..<12:
        var a, b, c = newSeq[bool](n)
        for i in 0..<n:
            a[i] = trial == 0 or rng.rand(1) == 1
            b[i] = if trial == 0: i == 0 else: rng.rand(1) == 1
            c[i] = rng.rand(1) == 1
        var x = initBitSet(a)
        var y = initBitSet(b)
        let z = initBitSet(c)
        var highBefore, highAfter: bool
        fuse:
            let total = (x + y) + z
            let h = not (total or x) or y
            highBefore = lastBit(h)
            var shifted = h shl 1
            shifted[0] = true
            x = shifted xor (z shl 63)
            y = x + total
            highAfter = lastBit(y)
        let total = add(add(a,b),c)
        var h, expectedX = newSeq[bool](n)
        for i in 0..<n: h[i] = not (total[i] or a[i]) or b[i]
        for i in 0..<n:
            expectedX[i] = (i == 0 or h[i-1]) xor (i >= 63 and c[i-63])
        let expectedY = add(expectedX,total)
        check(x,expectedX)
        check(y,expectedY)
        doAssert highBefore == h[^1] and highAfter == expectedY[^1]

        x = initBitSet(a)
        y = initBitSet(b)
        var expected = newSeq[bool](n)
        fuse:
            let t = (x and y) shl 2
            x = (t or z) shl 63
            y = x xor (t shl 0)
        var t = newSeq[bool](n)
        for i in 0..<n: t[i] = i >= 2 and a[i-2] and b[i-2]
        for i in 0..<n: expected[i] = i >= 63 and (t[i-63] or c[i-63])
        check(x,expected)
        for i in 0..<n: expected[i] = expected[i] xor t[i]
        check(y,expected)

        x = initBitSet(a)
        y = initBitSet(b)
        fuse:
            x = not x
            x[0] = false
            y = x + y
        for i in 0..<n: expected[i] = i > 0 and not a[i]
        check(x,expected)
        check(y,add(expected,b))

        x = initBitSet(a)
        y = initBitSet(b)
        template alias: untyped = x
        fuse:
            x = x xor y
            y = alias + y
        for i in 0..<n: expected[i] = a[i] xor b[i]
        check(x,expected)
        check(y,add(expected,b))

        x = initBitSet(a)
        y = initBitSet(b)
        let shift = 65
        let expectedFallback = ((x + y) >> shift) ^ z
        fuse:
            let t = x + y
            var shifted = t shr shift
            x = shifted xor z
            highAfter = lastBit(x)
        doAssert $x == $expectedFallback
        doAssert highAfter == expectedFallback.lastBit()

block:
    var x = initBitSet(0)
    var y = initBitSet(0)
    var bit = true
    fuse:
        let t = not x
        x = t + y
        y = x shl 1
        bit = lastBit(t)
    doAssert x.len == 0 and y.len == 0 and not bit
    var caught = false
    try:
        fuse:
            let t = x shl 1
            var u = t
            u[0] = true
            x = u
    except IndexDefect: caught = true
    doAssert caught

block:
    var x = initBitSet(2)
    var y = initBitSet(513)
    y[512] = true
    fuse:
        x = y xor y
        y = x or y
    doAssert x.len == 513 and x.popcount == 0 and y[512]
    var flag: bool
    fuse:
        let t = not x
        flag = lastBit(t)
    doAssert flag

proc generic[T](unused: T) =
    var x = initBitSet(513)
    var flag: bool
    fuse:
        let t = not x
        x = t shl 1
        flag = lastBit(x)
    doAssert x.popcount == 512 and flag
generic(0)
generic(0.0)

echo "Hello World"
