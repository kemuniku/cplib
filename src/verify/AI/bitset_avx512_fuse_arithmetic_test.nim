# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/bitset_avx512

proc add(a, b: seq[bool]): seq[bool] =
    result = newSeq[bool](a.len)
    var carry = 0
    for i in 0..<a.len:
        let v = ord(a[i]) + ord(b[i]) + carry
        result[i] = (v and 1) != 0
        carry = v shr 1

proc check(x: BitSetAvx512, a: seq[bool]) =
    doAssert x.len == a.len
    for i, v in a: doAssert x[i] == v
    var count = 0
    for v in a: count += ord(v)
    doAssert x.popcount == count

var rng = initRand(47923)
for n in [0, 1, 63, 64, 65, 255, 256, 257, 511, 512, 513, 1023, 1024, 1025, 4097]:
    for trial in 0..<8:
        var a, b, c = newSeq[bool](n)
        for i in 0..<n:
            a[i] = trial == 0 or rng.rand(1) == 1
            b[i] = if trial == 0: i == 0 else: rng.rand(1) == 1
            c[i] = rng.rand(1) == 1
        var x = initBitSet(a)
        let y = initBitSet(b)
        let z = initBitSet(c)
        var dst = initBitSet(n)
        fuse: dst = x + y
        check(dst, add(a,b))
        fuse: x += y
        check(x, add(a,b))
        x = initBitSet(a)
        fuse: x = ((x + y) + (z + x)) xor y
        var expected = add(add(a,b), add(c,a))
        for i in 0..<n: expected[i] = expected[i] xor b[i]
        check(x, expected)
        for k in [0, 1, 63, 64, 65, 255, 256, 511, 512, 513, n, n+1, high(int)]:
            x = initBitSet(a)
            var l, r = newSeq[bool](n)
            for i in 0..<n:
                l[i] = i >= k and a[i-k]
                r[i] = k < n-i and b[i+k]
            fuse: x = ((x shl k) + (y shr k)) xor z
            expected = add(l,r)
            for i in 0..<n: expected[i] = expected[i] xor c[i]
            check(x, expected)
            x = initBitSet(a)
            fuse: dst = (x shl k) + y
            check(dst, add(l,b))
            fuse: x <<= k
            check(x,l)
            x = initBitSet(b)
            fuse: x = x shr k
            check(x,r)
        x = initBitSet(n+1)
        fuse: x = y + z
        check(x, add(b,c))
        x = initBitSet(a)
        fuse: dst = (not (x + y)) shr 1
        expected = add(a,b)
        for i in 0..<n:
            expected[i] = i+1 < n and not expected[i+1]
        check(dst, expected)

block:
    var x = initBitSet(65)
    var y = initBitSet(64)
    var raised = false
    try:
        fuse: x = x + y
    except ValueError: raised = true
    doAssert raised
    y = initBitSet(65)
    raised = false
    try:
        fuse: x = (y shl -1) + y
    except ValueError: raised = true
    doAssert raised

echo "Hello World"

block:
    var x = initBitSet(0)
    var y = initBitSet(513)
    y[0] = true
    var calls = 0
    proc amount(): int =
        inc calls
        1
    fuse: x = (y shl amount()) + y
    doAssert calls == 1 and x.len == 513 and x.popcount == 2 and x[0] and x[1]

block:
    var xs = @[initBitSet(513)]
    xs[0][62] = true
    var calls = 0
    proc index(): int =
        inc calls
        0
    let amount = 65
    fuse: xs[index()] <<= (amount and 63)
    doAssert calls == 1 and xs[0][63] and xs[0].popcount == 1
    fuse: xs[index()] >>= (amount and 63)
    doAssert calls == 2 and xs[0][62] and xs[0].popcount == 1
