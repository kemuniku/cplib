# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_affine_range_sum
import cplib/collections/dynamic_lazysegtree

const modulus = 998244353
type
    S = tuple[sum, size: int]
    F = tuple[a, b: int]

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)
proc op(l, r: S): S = ((l.sum + r.sum) mod modulus, l.size + r.size)
proc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.size) mod modulus, x.size)
proc composition(f, g: F): F = (f.a * g.a mod modulus, (f.a * g.b + f.b) mod modulus)
proc initial(l, r: int): S = (0, r - l)

let n = ii()
let q = ii()
let st = initDynamicLazySegmentTree[S, F](n, op, (0, 0), mapping, composition, (1, 0), initial)
for i in 0..<n: st[i] = (ii(), 1)
for i in 0..<q:
    let t = ii()
    let l = ii()
    let r = ii()
    if t == 0:
        let a = ii()
        let b = ii()
        st.apply(l, r, (a, b))
    else:
        echo st.get(l, r).sum
