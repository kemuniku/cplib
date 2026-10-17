# verification-helper: PROBLEM https://atcoder.jp/contests/typical90/tasks/typical90_bg
import cplib/graph/graph
import cplib/graph/dag_reachable
proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)
let n = ii()
let m = ii()
let q = ii()
var g = initUnWeightedDirectedStaticGraph(n)
for i in 0..<m:
    let a = ii() - 1
    let b = ii() - 1
    g.add_edge(a, b)
g.build()
var queries = newSeq[(int, int)](q)
for i in 0..<q:
    let a = ii() - 1
    let b = ii() - 1
    queries[i] = (a, b)
for answer in g.dag_reachable(queries):
    echo (if answer: "Yes" else: "No")
