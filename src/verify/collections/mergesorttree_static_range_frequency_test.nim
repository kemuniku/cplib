# verification-helper: PROBLEM https://judge.yosupo.jp/problem/static_range_frequency
import cplib/collections/mergesorttree
import sequtils

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = discard scanf("%lld", addr result)

let n = ii()
let q = ii()
let a = newSeqWith(n, ii())
let tree = initMergeSortTree(a)
for _ in 0..<q:
    let l = ii()
    let r = ii()
    let x = ii()
    echo tree.count(l, r, x)
