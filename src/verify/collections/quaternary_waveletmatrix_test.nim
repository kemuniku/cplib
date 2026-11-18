# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_kth_smallest
import cplib/collections/quaternary_waveletmatrix
import sequtils
proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)
let n = ii()
let q = ii()
let a = newSeqWith(n, ii())
let w = initQuadWaveletMatrix(a)
for _ in 0..<q:
    let l = ii()
    let r = ii()
    let k = ii()
    echo w.kth_smallest(l, r, k)
