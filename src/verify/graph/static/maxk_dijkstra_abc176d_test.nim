# verification-helper: PROBLEM https://atcoder.jp/contests/abc176/tasks/abc176_d
import sequtils
import cplib/graph/graph
import cplib/graph/maxk_dijkstra
import cplib/utils/constants
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var h, w = ii()
var sx, sy, tx, ty = ii() - 1
var g = initWeightedDirectedStaticGraph(h*w, int32)
var s = newSeqWith(h, stdin.readLine).mapIt(it.mapit(it == '.'))
var dxy = [(-1, 0), (1, 0), (0, -1), (0, 1)]
for i in 0..<h:
    for j in 0..<w:
        for (dx, dy) in dxy:
            if i+dx notin 0..<h or j+dy notin 0..<w or not s[i+dx][j+dy]: continue
            g.add_edge(i*w+j, (i+dx)*w+j+dy, 0i32)
        for dx in -2..2:
            for dy in -2..2:
                if abs(dx) + abs(dy) <= 1: continue
                if i+dx notin 0..<h or j+dy notin 0..<w or not s[i+dx][j+dy]: continue
                g.add_edge(i*w+j, (i+dx)*w+j+dy, 1i32)
g.build
var d = g.maxk_dijkstra(sx*w+sy, 1i32)
var ans = d[tx*w+ty]
if ans == INF32: ans = -1
echo ans
