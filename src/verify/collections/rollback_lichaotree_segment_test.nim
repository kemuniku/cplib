# verification-helper: PROBLEM https://judge.yosupo.jp/problem/segment_add_get_min
import cplib/collections/rollback_lichaotree
import cplib/utils/constants

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

let n = ii()
let q = ii()
var initial: seq[(int, int, int, int)]
for i in 0..<n: initial.add((ii(), ii(), ii(), ii()))
var queries: seq[(int, int, int, int, int)]
var xs: seq[int]
for i in 0..<q:
    let t = ii()
    if t == 0: queries.add((t, ii(), ii(), ii(), ii()))
    else:
        let x = ii()
        xs.add(x)
        queries.add((t, x, 0, 0, 0))
let tree = initRollbackLiChaoTree(xs)
for (l, r, a, b) in initial: tree.add_segment(a, b, l, r)
for (t, l, r, a, b) in queries:
    if t == 0: tree.add_segment(a, b, l, r)
    else:
        let value = tree.get_min(l)
        if value == INF64: echo "INFINITY"
        else: echo value
