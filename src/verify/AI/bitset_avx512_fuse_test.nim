# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, macros, sequtils
import cplib/collections/bitset_avx512

randomize(156)

proc check(a: BitSetAvx512, b: seq[bool]) =
    doAssert a.len == b.len
    for i, bit in b: doAssert a[i] == bit
    var count = 0
    for bit in b:
        if bit: inc count
    doAssert a.popcount == count

macro checkLogic(): untyped =
    result = newStmtList()
    for outer in ["and", "or", "xor"]:
        for inner in ["and", "or", "xor"]:
            for dst in ["x", "y", "z"]:
                result.add parseStmt("""
block:
    var x = initBitSet(a)
    var y = initBitSet(b)
    var z = initBitSet(c)
    fuse:
        """ & dst & " = x " & outer & " (y " & inner & " z)\n" & """
    var expected = newSeq[bool](a.len)
    for i in 0..<a.len:
        expected[i] = a[i] """ & outer & " (b[i] " & inner & " c[i])\n" &
                    "    check(" & dst & ", expected)\n")

for n in [0, 1, 63, 64, 65, 127, 255, 256, 257, 511, 512, 513, 1025]:
    for trial in 0..<5:
        var a, b, c, d: seq[bool]
        for i in 0..<n:
            a.add(rand(1) == 1)
            b.add(rand(1) == 1)
            c.add(rand(1) == 1)
            d.add(rand(1) == 1)
        checkLogic()
        var x = initBitSet(a)
        var y = initBitSet(b)
        var z = initBitSet(c)
        var w = initBitSet(d)
        var expected = newSeq[bool](n)
        fuse:
            x = not ((x xor y) and (z or not w))
        for i in 0..<n: expected[i] = not ((a[i] xor b[i]) and (c[i] or not d[i]))
        check(x, expected)
        fuse:
            x = not x
            x = x xor x
            x = not x
        check(x, newSeqWith(n, true))
        for k in [0, 1, 2, 63, 64, 65, 127, 255, 256, 511, 512, n, n+1, n+100]:
            x = initBitSet(a)
            fuse:
                x = x | (x << k)
            for i in 0..<n: expected[i] = a[i] or (i >= k and a[i-k])
            check(x, expected)
            x = initBitSet(a)
            fuse:
                x = (x shr k) or x
            for i in 0..<n: expected[i] = a[i] or (i+k < n and a[i+k])
            check(x, expected)
            x = initBitSet(a)
            fuse:
                x = (x shl k) or (x shr k)
            for i in 0..<n: expected[i] = (i >= k and a[i-k]) or (i+k < n and a[i+k])
            check(x, expected)
        x = initBitSet(n+1)
        fuse:
            x = y xor not z
        for i in 0..<n: expected[i] = b[i] xor not c[i]
        check(x, expected)

block:
    var x = initBitSet(65)
    var y = initBitSet(64)
    var rejected = false
    try:
        fuse: x = x or y
    except ValueError: rejected = true
    doAssert rejected
    rejected = false
    try:
        fuse: x = x or (x shl -1)
    except ValueError: rejected = true
    doAssert rejected

block:
    var xs = @[initBitSet(65)]
    var y = initBitSet(65)
    y[64] = true
    var calls = 0
    proc source(): BitSetAvx512 =
        inc calls
        y
    fuse:
        xs[0] = xs[0] or source()
    doAssert calls == 1 and xs[0][64]

echo "Hello World"

proc inGeneric[T](unused: T) =
    var x = initBitSet(513)
    fuse:
        x = not x
    doAssert x.popcount == 513
inGeneric(1)
inGeneric(1.0)

block:
    var x = initBitSet(513)
    x[8] = true
    let k = 65
    fuse:
        x = (x shl (k and 63)) or (x shr (k and 63))
    doAssert x.popcount == 2 and x[7] and x[9]

for n in [0, 1, 63, 64, 65, 511, 512, 513, 1025]:
    var a, b, c: seq[bool]
    for i in 0..<n:
        a.add(rand(1) == 1)
        b.add(rand(1) == 1)
        c.add(rand(1) == 1)
    var x = initBitSet(a)
    let y = initBitSet(b)
    let z = initBitSet(c)
    var expected = newSeq[bool](n)
    fuse:
        x |= y and z
    for i in 0..<n: expected[i] = a[i] or (b[i] and c[i])
    check(x, expected)
    fuse:
        x &= y or not z
    for i in 0..<n: expected[i] = expected[i] and (b[i] or not c[i])
    check(x, expected)
    fuse:
        x ^= y xor z
    for i in 0..<n: expected[i] = expected[i] xor (b[i] xor c[i])
    check(x, expected)
    for k in [0, 1, 63, 64, 65, 511, 512, n, n+1]:
        x = initBitSet(a)
        fuse:
            x |= x << k
        for i in 0..<n: expected[i] = a[i] or (i >= k and a[i-k])
        check(x, expected)
        x = initBitSet(a)
        fuse:
            x |= x shr k
        for i in 0..<n: expected[i] = a[i] or (i+k < n and a[i+k])
        check(x, expected)
        x = initBitSet(a)
        fuse:
            x ^= (y shl k) or (z shr k)
        for i in 0..<n: expected[i] = a[i] xor ((i >= k and b[i-k]) or (i+k < n and c[i+k]))
        check(x, expected)

block:
    var xs = @[initBitSet(65)]
    var y = initBitSet(65)
    y[64] = true
    var calls = 0
    proc index(): int =
        inc calls
        0
    fuse:
        xs[index()] |= y and y
    doAssert calls == 1 and xs[0][64]
