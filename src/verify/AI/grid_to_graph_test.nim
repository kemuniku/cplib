# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/graph/graph
import cplib/graph/grid_to_graph

let grid = @["..", "#."]
let g = grid.grid_to_graph('.')
assert g.len == 4
assert toSeq(g[0]).sorted == @[1]
assert toSeq(g[1]).sorted == @[0, 3]
assert toSeq(g[3]).sorted == @[1]

var sg = grid.grid_to_graph('.', true)
sg.build()
assert sg.len == 4
assert toSeq(sg[1]).sorted == @[0, 3]

let nums = @[@[1, 1], @[0, 1]]
assert nums.grid_to_graph(1).len == 4
