# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_range_frequency
import cplib/collections/dynamic_mergesorttree
import sequtils

proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = discard scanf("%lld", addr result)

let n = ii()
let q = ii()
let a = newSeqWith(n, ii())
let tree = initDynamicMergeSortTree(a)
for _ in 0..<q:
    let kind = ii()
    if kind == 0:
        let k = ii()
        let v = ii()
        tree.update(k, v)
    else:
        let l = ii()
        let r = ii()
        let x = ii()
        echo tree.count(l, r, x)
