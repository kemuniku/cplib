# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/collections/dynamic_quaternary_vector
import cplib/collections/dynamic_bplus_kernels
import random

proc run[T](kind: typedesc[T], n: int, kernel: BPlusKernel) =
    var rng = initRand(343901+n)
    var a = newSeq[int](n)
    for x in a.mitems: x = rng.rand(3)
    let t = initQuadVector(kind, a, kernel)
    proc check() =
        t.validate()
        doAssert t.len == a.len
        var counts: array[4, int]
        var uniform = -1
        for i, x in a:
            doAssert t[i] == x
            if i mod 31 == 0:
                doAssert t.rankAccess(i) == (counts[x], x)
                doAssert t.ranks(i) == counts
            inc counts[x]
        for d in 0..3:
            doAssert t.total(d) == counts[d]
            doAssert t.rank(a.len, d) == counts[d]
            if a.len > 0 and counts[d] == a.len: uniform = d
        doAssert t.uniformDigit() == uniform
        for trial in 0..<8:
            let l = rng.rand(a.len)
            let r = l+rng.rand(a.len-l)
            doAssert t.ranksPair(l, r) == (t.ranks(l), t.ranks(r))
            for d in 0..3:
                doAssert t.rankPair(l, r, d) == (t.rank(l, d), t.rank(r, d))
    check()
    for step in 0..<(if defined(dynamicWmFullTest): 1000 else: 200):
        let digit = rng.rand(3)
        if a.len == 0 or step mod 11 == 0:
            let p = rng.rand(a.len)
            var rank = 0
            for i in 0..<p: rank+=int(a[i] == digit)
            doAssert t.insert(p, digit) == rank
            a.insert(digit, p)
        elif step mod 11 == 1:
            let p = rng.rand(a.high)
            let old = a[p]
            var rank = 0
            for i in 0..<p: rank+=int(a[i] == old)
            doAssert t.erase(p) == (rank, old)
            a.delete(p)
        else:
            let points = [0, a.high, a.len div 2, min(31, a.high), min(32, a.high),
                min(63, a.high), min(64, a.high), min(127, a.high), min(128, a.high),
                min(511, a.high), min(512, a.high), rng.rand(a.high)]
            let source = points[step mod points.len]
            let destination = if step mod 7 == 0: source else: points[(step div points.len) mod points.len]
            let old = a[source]
            let value = if step mod 3 == 0: old else: digit
            var oldRank, newRank: int
            for i in 0..<source: oldRank+=int(a[i] == old)
            a.delete(source)
            for i in 0..<destination: newRank+=int(a[i] == value)
            a.insert(value, destination)
            doAssert t.moveRank(source, destination, value) == (old, oldRank, newRank)
        if step mod 29 == 0: check()
    check()
    for i in 0..<a.len:
        discard t.replaceRank(i, 2)
        a[i] = 2
    check()
    if a.len > 0:
        doAssert t.moveRank(0, a.high, 2) == (2, 0, a.high)
        let p = a.len div 2
        discard t.replaceRank(p, 1)
        a[p] = 1
        check()
        doAssert t.moveRank(p, 0, 2) == (1, 0, 0)
        a[p] = 2
        check()
    while a.len > 0:
        discard t.erase(a.high)
        a.setLen(a.len-1)
    check()

for kernel in [bpkScalar, bpkAvx2, bpkAvx512]:
    if not kernelAvailable(kernel): continue
    for n in [0, 1, 31, 32, 33, 64, 65, 129, 5000]:
        run(QuadVector[4, 1, 0, 0], n, kernel)
        run(QuadVector[4, 1, 1, 63], n, kernel)
        run(QuadVector[4, 2, 2, 64], n, kernel)
    run(QuadVector[4, 6, 4, 127], 5000, kernel)
    run(QuadVector[24, 3, 2, 63], 5000, kernel)
    run(QuadVector[16, 64, 0, 0], 4097, kernel)
    for n in [1024, 1025, 2048, 2049, 4096, 4097, 8192, 8193, 16384, 17001]:
        run(FastQuadVector, n, kernel)
    run(QuadVector[32, 64, 2, 127], 17001, kernel)
echo "Hello World"
