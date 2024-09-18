# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum
import sequtils
import cplib/collections/lazysegtree
import cplib/modint/modint

type mint = modint998244353_barrett
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, Q = ii()

type S = tuple[val: mint, siz: int]
type F = tuple[a: mint, b: mint]
var v = newSeqWith(N, (mint(ii()), 1))
proc op(L, R: S): S = (L.val+R.val, L.siz+R.siz)
proc e(): S = (mint(0), 0)
proc mapping(f: F, x: S): S = (f.a * x.val+f.b*x.siz, x.siz)
proc composition(f: F, g: F): F = (f.a*g.a, f.a*g.b+f.b)
proc id(): F = (mint(1), mint(0))
var seg = initLazySegmentTree(v, op, e(), mapping, composition, id())

for i in 0..<Q:
    var t = ii()
    if t == 0:
        var l, r, b, c = ii()
        seg.apply(l..<r, (mint(b), mint(c)))
    else:
        var l, r = ii()
        echo seg[l..<r][0]
