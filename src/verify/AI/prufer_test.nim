# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/graph/graph
import cplib/tree/prufer

let g = prufer_decode(@[1, 1])
assert g.len == 4
var edges: seq[(int, int)]
for i in 0..<g.len:
  for j in g[i]:
    if i < j:
      edges.add((i, j))
assert edges == @[(0, 1), (1, 2), (1, 3)]
