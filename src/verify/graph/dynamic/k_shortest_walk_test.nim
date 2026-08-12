# verification-helper: PROBLEM https://judge.yosupo.jp/problem/k_shortest_walk

import cplib/graph/[graph, k_shortest_walk]
import std/[sequtils, strutils]

let header = stdin.readLine.split.map(parseInt)
let (n, m, s, t, k) = (header[0], header[1], header[2], header[3], header[4])
var g = initWeightedDirectedGraph(n)
for _ in 0..<m:
    let edge = stdin.readLine.split.map(parseInt)
    let (a, b, c) = (edge[0], edge[1], edge[2])
    g.add_edge(a, b, c)

var ans = g.k_shortest_walk(s, t, k)
let found = ans.len
ans.setLen(k)
for i in found..<k:
    ans[i] = -1
echo ans.join("\n")
