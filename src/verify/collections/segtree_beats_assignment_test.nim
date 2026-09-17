# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random, sequtils
import cplib/collections/segtree_beats_template
import cplib/math/int128

proc checkAssignment[T](zero, inf: T) =
    var seg = initRangeChminChmaxRangeSumMaxMin(@[T(1), T(5), T(2), T(7)], inf, zero)
    seg.chmin(0..3, T(4))
    seg.add(0..3, T(3))
    seg[1] = T(-2)
    assert seg[1].sum == T(-2)
    assert seg[0..3].sum == T(14)
    assert seg[0..3].min == T(-2)
    assert seg[0..3].max == T(7)
    seg.chmax(0..3, T(0))
    seg[0] = T(10)
    assert seg[0..3].sum == T(22)

checkAssignment(0, 1_000_000_000)
checkAssignment(0i32, 1_000_000_000i32)
checkAssignment(0.0, 1e100)
checkAssignment(to_Int128(0), parseInt128("1000000000000000000000000000000"))

var rng = initRand(2500)
var a = newSeqWith(12, 0)
var seg = initRangeChminChmaxRangeSumMaxMin(a)
for trial in 0..<300:
    let l = rng.rand(0..<a.len)
    let r = rng.rand(l..<a.len)
    let x = rng.rand(-20..20)
    case rng.rand(0..3)
    of 0:
        seg[l] = x
        a[l] = x
    of 1:
        seg.add(l..r, x)
        for i in l..r: a[i] += x
    of 2:
        seg.chmin(l..r, x)
        for i in l..r: a[i] = min(a[i], x)
    else:
        seg.chmax(l..r, x)
        for i in l..r: a[i] = max(a[i], x)
    var total = 0
    for i, value in a:
        total += value
        assert seg[i].sum == value
    assert seg[0..<a.len].sum == total
    assert seg[0..<a.len].min == min(a)
    assert seg[0..<a.len].max == max(a)
