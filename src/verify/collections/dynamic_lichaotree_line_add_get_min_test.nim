# verification-helper: PROBLEM https://judge.yosupo.jp/problem/line_add_get_min
import options
import cplib/collections/dynamic_lichaotree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

let n = ii()
let q = ii()
let tree = initDynamicLiChaoTree(-1_000_000_000, 1_000_000_001)
for i in 0..<n:
    let a = ii()
    let b = ii()
    tree.add_line(a, b)
for i in 0..<q:
    let t = ii()
    if t == 0:
        let a = ii()
        let b = ii()
        tree.add_line(a, b)
    else:
        echo tree.get_min(ii()).get
