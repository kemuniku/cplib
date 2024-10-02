# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_diameter
import strutils
import cplib/graph/graph
import cplib/tree/diameter
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
var g = initWeightedUnDirectedStaticGraph(n)
for i in 0..<n-1:
    var a, b, c = ii()
    g.add_edge(a, b, c)
g.build
var (d, path) = g.diameter_path
echo d, " ", path.len
echo path.join(" ")
