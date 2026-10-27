# verification-helper: PROBLEM https://judge.yosupo.jp/problem/segment_add_get_min
import options
import cplib/collections/dynamic_lichaotree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

let n = ii()
let q = ii()
let tree = initDynamicLiChaoTree(-1_000_000_000, 1_000_000_001)
for i in 0..<n:
    let l = ii()
    let r = ii()
    let a = ii()
    let b = ii()
    tree.add_segment(a, b, l, r)
for i in 0..<q:
    let t = ii()
    if t == 0:
        let l = ii()
        let r = ii()
        let a = ii()
        let b = ii()
        tree.add_segment(a, b, l, r)
    else:
        let answer = tree.get_min(ii())
        if answer.isSome: echo answer.get
        else: echo "INFINITY"
