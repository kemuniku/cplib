# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_count_distinct
import cplib/collections/static_range_distinct
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)
let N = ii()
let Q = ii()
let A = newSeqWith(N, ii())
let d = initStaticRangeDistinct(A)
for _ in 0..<Q:
    let l = ii()
    let r = ii()
    echo d.count(l, r)
