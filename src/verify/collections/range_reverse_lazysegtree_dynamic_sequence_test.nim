# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dynamic_sequence_range_affine_range_sum
import cplib/collections/range_reverse_lazysegtree

const modulus = 998244353
type
    S = tuple[sum, size: int]
    F = tuple[a, b: int]

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)
proc op(l, r: S): S = ((l.sum + r.sum) mod modulus, l.size + r.size)
proc mapping(f: F, x: S): S = ((f.a * x.sum + f.b * x.size) mod modulus, x.size)
proc composition(f, g: F): F = (f.a * g.a mod modulus, (f.a * g.b + f.b) mod modulus)

let n = ii()
let q = ii()
var values = newSeq[S](n)
for i in 0..<n: values[i] = (ii(), 1)
let seg = initRangeReverseLazySegmentTree(values, op, (0, 0), mapping, composition, (1, 0))
for i in 0..<q:
    let t = ii()
    case t
    of 0:
        let index = ii()
        let value = ii()
        seg.insert(index, (value, 1))
    of 1:
        seg.erase(ii())
    of 2:
        let l = ii()
        let r = ii()
        seg.reverse(l, r)
    of 3:
        let l = ii()
        let r = ii()
        let a = ii()
        let b = ii()
        seg.apply(l, r, (a, b))
    else:
        let l = ii()
        let r = ii()
        echo seg.get(l, r).sum
