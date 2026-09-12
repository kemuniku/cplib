# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching
import cplib/graph/maxflow
include cplib/tmpl/fastio

let left = ii()
let right = ii()
let m = ii()
let src = left + right
let dst = src + 1
var g = initMaxFlow[int](dst + 1)
for i in 0..<left:
    g.add_edge(src, i, 1)
for i in 0..<right:
    g.add_edge(left + i, dst, 1)
for i in 0..<m:
    let a = ii()
    let b = ii()
    g.add_edge(a, left + b, 1)
echo g.flow(src, dst)
for e in g.get_edges:
    if e.src < left and e.dst >= left and e.dst < src and e.flow == 1:
        echo e.src, " ", e.dst - left
