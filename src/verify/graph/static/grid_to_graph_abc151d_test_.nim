# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_d
import sequtils
import cplib/graph/graph
import cplib/graph/grid_to_graph
import cplib/graph/maxk_dijkstra
import cplib/utils/constants
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var h, w = ii()
var g = newSeqWith(h, stdin.readLine).grid_to_graph('.', true)
g.build
var ans = 0
for sx in 0..<h:
    for sy in 0..<w:
        var d = g.maxk_dijkstra(sx*w+sy, 1).mapIt(if it == INF64: -1 else: it)
        ans = max(ans, d.max)
echo ans
