# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_point_get
import sequtils
import cplib/collections/dualsegtree_static_op
import cplib/modint/modint

type mint = modint998244353_barrett
proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} =
    scanf("%lld\n", addr result)

proc initrangeaffinepointget[T](v: seq[T]): auto =
    type S = T
    type F = (T, T)
    proc mapping(f: F, x: S): S =
        f[0] * x + f[1]
    proc composition(f, g: F): F =
        (f[0] * g[0], f[0] * g[1] + f[1])
    initDualSegmentTree(v, mapping, composition, (T(1), T(0)))

let N, Q = ii()
let A = newSeqWith(N, mint(ii()))
var st = initrangeaffinepointget(A)
for _ in 0..<Q:
    let t = ii()
    if t == 0:
        let l, r, b, c = ii()
        st.apply(l, r, (mint(b), mint(c)))
    else:
        let i = ii()
        echo st[i]
