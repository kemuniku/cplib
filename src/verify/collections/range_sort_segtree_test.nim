# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_sort_range_composite
import algorithm
import cplib/collections/range_sort_segtree

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = discard scanf("%lld", addr result)

const MOD = 998244353
type Affine = tuple[a, b: int]

proc compose(f, g: Affine): Affine =
    (g.a * f.a mod MOD, (g.a * f.b + g.b) mod MOD)

let n = ii()
let q = ii()
var keys = newSeq[int](n)
var values = newSeq[Affine](n)
for i in 0..<n:
    keys[i] = ii()
    values[i] = (ii(), ii())
let seg = initRangeSortSegmentTree(keys, values, 1_000_000_001, compose, (1, 0))
for _ in 0..<q:
    case ii()
    of 0:
        let i = ii()
        let p = ii()
        let a = ii()
        let b = ii()
        seg.update(i, p, (a, b))
    of 1:
        let l = ii()
        let r = ii()
        let x = ii()
        let f = seg.get(l, r)
        echo (f.a * x + f.b) mod MOD
    of 2:
        let l = ii()
        let r = ii()
        seg.sort(l, r)
    of 3:
        let l = ii()
        let r = ii()
        seg.sort(l, r, Descending)
    else:
        discard
