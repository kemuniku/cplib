# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_set_range_composite
import sequtils
import cplib/collections/lazysegtree
import cplib/modint/modint

type mint = modint998244353_barrett
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()

type S = (mint, mint, int)
type F = (bool, mint, mint)
var v = newSeqWith(N, (mint(ii()), mint(ii()), 1))
proc op(l, r: S): S = (r[0] * l[0], r[0] * l[1] + r[1], l[2] + r[2])
proc mapping(f: F, x: S): S = (if f[0]: (f[1].pow(x[2]), f[2] * (1 - f[1].pow(x[2])) / (1 - f[1]), x[2]) else: x)
proc composition(f: F, g: F): F = (if f[0]: f else: g)
var seg = initLazySegmentTree(v, op, (mint(1), mint(0), 0), mapping, composition, (false, mint(1), mint(0)))


for i in 0..<Q:
    var t = ii()
    if t == 0:
        var l, r, c, d = ii()
        seg.apply(l..<r, (true, mint(c), mint(d)))
    else:
        var l, r, x = ii()
        var (a, b, _) = seg[l..<r]
        echo a * x + b
