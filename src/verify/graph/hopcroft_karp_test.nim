# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching
import cplib/graph/hopcroft_karp
include cplib/tmpl/fastio

let left = ii()
let right = ii()
let m = ii()
var g = initHopcroftKarp(left, right)
for i in 0..<m:
    let a = ii()
    let b = ii()
    g.add_edge(a, b)
echo g.matching()
for (a, b) in g.get_matching():
    echo a, " ", b
