# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/graph/graph
import cplib/tree/heavylightdecomposition

var g = initUnWeightedUnDirectedStaticGraph(6)
g.add_edge(0, 1)
g.add_edge(0, 2)
g.add_edge(1, 3)
g.add_edge(1, 4)
g.add_edge(2, 5)
g.build()

let hld = g.initHld(0)
assert hld.numVertices == 6
assert hld.parentOf(0) == -1
assert hld.parentOf(3) == 1
assert hld.depth(5) == 2
for v in 0..<6:
  assert hld.toVtx(hld.toSeq(v)) == v

assert hld.lca(3, 4) == 1
assert hld.lca(3, 5) == 0
assert hld.dist(3, 5) == 4
assert hld.median(3, 4, 5) == 1
assert hld.la(3, 5, 0) == 3
assert hld.la(3, 5, 1) == 1
assert hld.la(3, 5, 2) == 0
assert hld.la(3, 5, 4) == 5
assert hld.la(3, 5, 5) == -1

var subtree: seq[int]
for v in hld.subtreeV(1):
  subtree.add(v)
subtree.sort()
assert subtree == @[1, 3, 4]

var children: seq[int]
for v in hld.children(1):
  children.add(v)
children.sort()
assert children == @[3, 4]

let aux = hld.initAuxiliaryTree(@[3, 4, 5])
var auxVertices = aux.v
auxVertices.sort()
assert auxVertices == @[0, 1, 3, 4, 5]

let waux = hld.initAuxiliaryWeightedTree(@[3, 5])
assert waux.v == @[0, 3, 5]
var weightedEdges = waux.graph.edges[0].mapIt((it[0].int, it[1]))
weightedEdges.sort()
assert weightedEdges == @[(1, 2), (2, 2)]
