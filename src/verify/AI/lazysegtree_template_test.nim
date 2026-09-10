# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/collections/lazysegtree_template
import cplib/collections/lazysegtree_static_op
import cplib/modint/modint

var rng = initRand(20260910)
for n in [0, 1, 2, 5, 16, 23]:
    var added, assigned, affine: seq[int]
    for i in 0..<n:
        let value = rng.rand(-10..10)
        added.add(value)
    assigned = added
    affine = added
    var amin = initRangeAddRangeMinIndex(added)
    var amax = initRangeAddRangeMaxIndex(added)
    var asum = initRangeAddRangeSum(added)
    var cmin = initRangeAssignRangeMinIndex(assigned)
    var cmax = initRangeAssignRangeMaxIndex(assigned)
    var csum = initRangeAssignRangeSum(assigned)
    var fsum = initRangeAffineRangeSum(affine)
    assert amin.len == n
    for step in 0..<300:
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        let value = rng.rand(-10..10)
        let a = rng.rand(-1..1)
        amin.apply(l, r, value)
        amax.apply(l..<r, value)
        asum.apply(l, r, value)
        cmin.apply(l, r, value)
        cmax.apply(l, r, value)
        csum.apply(l..<r, value)
        fsum.apply(l, r, (a, value))
        for i in l..<r:
            added[i] += value
            assigned[i] = value
            affine[i] = a * affine[i] + value
        for q in 0..<5:
            let ql = rng.rand(n)
            let qr = rng.rand(ql..n)
            var sa, sc, sf = 0
            var iaMin, iaMax, icMin, icMax = -1
            for i in ql..<qr:
                sa += added[i]
                sc += assigned[i]
                sf += affine[i]
                if iaMin < 0 or added[i] < added[iaMin]: iaMin = i
                if iaMax < 0 or added[i] > added[iaMax]: iaMax = i
                if icMin < 0 or assigned[i] < assigned[icMin]: icMin = i
                if icMax < 0 or assigned[i] > assigned[icMax]: icMax = i
            assert asum.get(ql, qr) == (sa, qr - ql)
            assert csum[ql..<qr] == (sc, qr - ql)
            assert fsum.get(ql, qr) == (sf, qr - ql)
            assert amin.get(ql, qr).index == iaMin
            assert amax.get(ql, qr).index == iaMax
            assert cmin.get(ql, qr).index == icMin
            assert cmax.get(ql, qr).index == icMax
            if ql < qr:
                assert amin.get(ql, qr).value == added[iaMin]
                assert amax.get(ql, qr).value == added[iaMax]
                assert cmin.get(ql, qr).value == assigned[icMin]
                assert cmax.get(ql, qr).value == assigned[icMax]

block:
    var seg = initRangeAssignRangeMinIndex(@[9, 1, 8, 2, 7])
    seg.apply(0, 5, 0)
    assert seg.get(0, 5).index == 0
    assert seg.get(1, 4).index == 1
    seg[2] = (value: -1, index: 2, left: 2)
    assert seg.get(0, 5).index == 2
    seg.apply(0, 5, int.high)
    assert seg.get(0, 5).value == int.high
    assert seg.get(0, 5).index == 0
block:
    var seg = initRangeAddRangeMaxIndex(@[int.low, int.low])
    seg.apply(0, 2, 1)
    assert seg.get(0, 2).value == int.low + 1
    assert seg.get(0, 2).index == 0
block:
    var seg = initRangeAffineRangeSum(@[1.0, 2.0, 3.0])
    seg.apply(0, 3, (2.0, 1.0))
    assert seg.get(0, 3).sum == 15.0
block:
    type Mint = modint998244353_montgomery
    var seg = initRangeAffineRangeSum(@[Mint.init(1), Mint.init(2), Mint.init(3)])
    seg.apply(0, 3, (Mint.init(2), Mint.init(3)))
    seg.apply(0, 3, (Mint.init(4), Mint.init(5)))
    assert seg.get(1, 3).sum.val == 74
    var add = initRangeAddRangeSum(@[Mint.init(1), Mint.init(2)])
    add.apply(0, 2, Mint.init(3))
    assert add.get(0, 2).sum.val == 9
    var assign = initRangeAssignRangeSum(@[Mint.init(1), Mint.init(2)])
    assign.apply(0, 2, Mint.init(0))
    assert assign.get(0, 2).sum.val == 0
for n in [0, 1, 2, 5, 16, 23]:
    var added = newSeq[int](n)
    var assigned = newSeq[int](n)
    for i in 0..<n:
        added[i] = rng.rand(-10..10)
        assigned[i] = added[i]
    var amin = initRangeAddRangeMin(added)
    var amax = initRangeAddRangeMax(added)
    var cmin = initRangeAssignRangeMin(assigned)
    var cmax = initRangeAssignRangeMax(assigned)
    assert amin.len == n
    static:
        doAssert typeof(amin.arr[0]) is int
    for step in 0..<300:
        let l = rng.rand(n)
        let r = rng.rand(l..n)
        let value = rng.rand(-10..10)
        amin.apply(l, r, value)
        amax.apply(l..<r, value)
        cmin.apply(l, r, value)
        cmax.apply(l..<r, value)
        for i in l..<r:
            added[i] += value
            assigned[i] = value
        if n > 0 and step mod 3 == 0:
            let p = rng.rand(n - 1)
            amin[p] = value
            amax[p] = value
            cmin[p] = value
            cmax[p] = value
            added[p] = value
            assigned[p] = value
            assert amin[p] == value
        for q in 0..<5:
            let ql = rng.rand(n)
            let qr = rng.rand(ql..n)
            var ma, mc = int.high
            var xa, xc = int.low
            for i in ql..<qr:
                ma = min(ma, added[i])
                xa = max(xa, added[i])
                mc = min(mc, assigned[i])
                xc = max(xc, assigned[i])
            assert amin.get(ql, qr) == ma
            assert amax[ql..<qr] == xa
            assert cmin.get(ql, qr) == mc
            assert cmax[ql..<qr] == xc
block:
    var lo = initRangeAddRangeMin(@[int.high, int.high, int.high])
    lo.apply(0, 3, -1)
    assert lo.get(0, 3) == int.high - 1
    assert lo[2] == int.high - 1
    var hi = initRangeAddRangeMax(@[int.low, int.low, int.low])
    hi.apply(0, 3, 1)
    assert hi.get(0, 3) == int.low + 1
    assert hi[2] == int.low + 1
    var cmin = initRangeAssignRangeMin(@[1, 2, 3])
    var cmax = initRangeAssignRangeMax(@[1, 2, 3])
    for value in [int.high, int.low, 0]:
        cmin.apply(0, 3, value)
        cmax.apply(0, 3, value)
        assert cmin.get(1, 3) == value
        assert cmax.get(1, 3) == value
block:
    var seg = initRangeAddRangeMin(@[1.0, 2.0, 3.0])
    seg.apply(0, 3, 0.5)
    assert seg.get(0, 3) == 1.5
    assert seg.get(1, 1) == float.high
    var hi = initRangeAssignRangeMax(@[1.0, 2.0, 3.0])
    hi.apply(0, 3, -0.5)
    assert hi.get(1, 3) == -0.5
    assert hi.get(1, 1) == float.low
echo "Hello World"
