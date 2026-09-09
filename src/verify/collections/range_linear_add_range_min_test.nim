# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_linear_add_range_min
import sequtils
import cplib/collections/range_linear_add_range_min

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

let n = ii()
let q = ii()
let a = newSeqWith(n, ii())
let seg = initRangeLinearAddRangeMin(a)
for _ in 0..<q:
    let t = ii()
    let l = ii()
    let r = ii()
    if t == 0:
        let b = ii()
        let c = ii()
        seg.add(l..<r, b, c)
    else:
        echo seg[l..<r]
