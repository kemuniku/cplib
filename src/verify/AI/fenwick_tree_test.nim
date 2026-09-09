# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/fenwick
import cplib/collections/fenwick_avx2

var rng = initRand(712893)

for n in [0, 1, 2, 3, 15, 16, 17, 31, 32, 33, 255, 256, 257,
          1023, 1024, 1025, 4095, 4096, 4097, 65535, 65536, 65537]:
    var a = newSeq[int](n)
    for x in a.mitems: x = rng.rand(-1000..1000)
    var bit = initFenwickTree(a)
    var wide = initFenwickTreeAvx2(a)
    var zero = initFenwickTree[int](n)
    var wideZero = initFenwickTreeAvx2(n)
    doAssert bit.len == n and wide.len == n
    doAssert zero.get(0, n) == 0 and wideZero.get(0, n) == 0
    var prefix = 0
    for r in 0..n:
        doAssert bit.prefix(r) == prefix
        doAssert wide.prefix(r) == prefix
        doAssert bit.get(r, r) == 0
        doAssert wide.get(r, r) == 0
        if r < n: prefix += a[r]
    for step in 0..<1000:
        if n > 0 and step mod 3 != 0:
            let p = rng.rand(n - 1)
            let delta = rng.rand(-1000..1000)
            if step mod 3 == 1:
                a[p] += delta
                bit.add(p, delta)
                wide.add(p, delta)
            else:
                a[p] = delta
                bit[p] = delta
                wide[p] = delta
            doAssert bit[p] == a[p] and wide[p] == a[p]
        else:
            let l = rng.rand(n)
            let r = rng.rand(l..n)
            var expected = 0
            for i in l..<r: expected += a[i]
            doAssert bit.get(l, r) == expected
            doAssert wide.get(l, r) == expected
            doAssert bit[l..<r] == expected
            doAssert wide[l..<r] == expected
    if n > 0:
        let old = bit[0]
        var other = bit
        var otherWide = wide
        other.add(0, 1)
        otherWide.add(0, 1)
        doAssert bit[0] == old and wide[0] == old
        doAssert other[0] == old + 1 and otherWide[0] == old + 1

block:
    var a = @[uint64.high, 1'u64, 1'u64 shl 63, 7'u64]
    var bit = initFenwickTree(a)
    var signed = newSeq[int](a.len)
    for i, x in a: signed[i] = cast[int](x)
    var wide = initFenwickTreeAvx2(signed)
    for step in 0..<200:
        let p = rng.rand(3)
        let delta = cast[uint64](rng.rand(-100..100))
        a[p] += delta
        bit.add(p, delta)
        wide.add(p, cast[int](delta))
        for l in 0..a.len:
            var expected = 0'u64
            for r in l..a.len:
                doAssert bit.get(l, r) == expected
                doAssert cast[uint64](wide.get(l, r)) == expected
                if r < a.len: expected += a[r]
    wide[0] = cast[int](uint64.high)
    doAssert cast[uint64](wide.get(0, 1)) == uint64.high

block:
    var bit = initFenwickTreeAvx2(@[-128, 127, -1])
    doAssert bit.get(0, 3) == -2
    bit.add(2, -128)
    doAssert bit[2] == -129
    bit[0] = int.low
    doAssert bit[0] == int.low
    bit.add(0, int.low)
    doAssert bit[0] == 0

block:
    var bit = initFenwickTree(@[1.5, -2.0, 3.0])
    bit.add(1, 0.5)
    doAssert bit.get(0, 3) == 3.0
    var empty: FenwickTree[int]
    var emptyWide: FenwickTreeAvx2
    doAssert empty.get(0, 0) == 0 and empty.prefix(0) == 0
    doAssert emptyWide.get(0, 0) == 0 and emptyWide.prefix(0) == 0

for n in [(1 shl 20) - 1, 1 shl 20, (1 shl 20) + 1]:
    var wide = initFenwickTreeAvx2(n)
    let positions = [0, 15, 16, n div 2, n - 1]
    for p in positions: wide.add(p, 7)
    for r in [0, 1, 15, 16, 17, n div 2, n div 2 + 1, n - 1, n]:
        var expected = 0
        for p in positions:
            if p < r: expected += 7
        doAssert wide.prefix(r) == expected
        doAssert wide.get(r, n) == 35 - expected

when compileOption("assertions"):
    template expectAssertion(body: untyped) =
        block:
            var caught = false
            try:
                body
            except AssertionDefect:
                caught = true
            doAssert caught
    var bit = initFenwickTree[int](2)
    var wide = initFenwickTreeAvx2(2)
    expectAssertion: bit.add(-1, 1)
    expectAssertion: wide.add(-1, 1)
    expectAssertion: bit.add(2, 1)
    expectAssertion: wide.add(2, 1)
    expectAssertion: discard bit.prefix(3)
    expectAssertion: discard wide.prefix(3)
    expectAssertion: discard bit.get(1, 0)
    expectAssertion: discard wide.get(1, 0)

echo "Hello World"
