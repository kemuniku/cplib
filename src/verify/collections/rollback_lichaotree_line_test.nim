# verification-helper: PROBLEM https://judge.yosupo.jp/problem/line_add_get_min
import cplib/collections/rollback_lichaotree

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)

let n = ii()
let q = ii()
var initial: seq[(int, int)]
for i in 0..<n: initial.add((ii(), ii()))
var queries: seq[(int, int, int)]
var xs: seq[int]
for i in 0..<q:
    let t = ii()
    if t == 0: queries.add((t, ii(), ii()))
    else:
        let x = ii()
        xs.add(x)
        queries.add((t, x, 0))
let tree = initRollbackLiChaoTree(xs)
for (a, b) in initial: tree.add_line(a, b)
for (t, a, b) in queries:
    if t == 0: tree.add_line(a, b)
    else: echo tree.get_min(a)
