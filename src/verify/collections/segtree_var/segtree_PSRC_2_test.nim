# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_composite
import sequtils
import cplib/collections/segtree_var

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()
var A = newSeqWith(N, (ii(), ii()))
const MOD = 998244353
proc op(a, b: (int, int)): (int, int) = (b[0]*a[0] mod MOD, (b[0]*a[1] mod MOD)+b[1] mod MOD)
var st = initSegmentTree(A, op, (1, 0))
for i in 0..<Q:
    var T = ii()
    if T == 0:
        var p, c, d = ii()
        st.update(p, (c, d))
    else:
        var l, r, x = ii()
        if r == len(st) and l == 0:
            assert r == N
            var (a, b) = st.get_all
            echo (a*x mod MOD + b) mod MOD
        else:
            var (a, b) = st.get(l, r)
            echo (a*x mod MOD + b) mod MOD
