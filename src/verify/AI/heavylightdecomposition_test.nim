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
assert hld.initAuxiliaryTree(newSeq[int]()).v == @[]
assert hld.initAuxiliaryWeightedTree(newSeq[int]()).v == @[]
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

proc checkPaths(adj: seq[seq[int]], root: int) =
  let hld = adj.initHld(root)
  for u in 0..<adj.len:
    var prev = newSeqWith(adj.len, -1)
    var queue = @[u]
    prev[u] = u
    var head = 0
    while head < queue.len:
      let p = queue[head]
      inc head
      for v in adj[p]:
        if prev[v] == -1:
          prev[v] = p
          queue.add(v)
    for v in 0..<adj.len:
      var expected = @[v]
      while expected[^1] != u:
        expected.add(prev[expected[^1]])
      expected.reverse()
      var actual: seq[int]
      for (l, r, upward) in hld.pathWithDirection(u, v):
        assert 0 <= l and l < r and r <= adj.len
        if upward:
          for i in l..<r:
            let idx = adj.len - 1 - i
            actual.add(hld.toVtx(idx))
            if i + 1 < r:
              assert hld.parentOf(hld.toVtx(idx)) == hld.toVtx(idx - 1)
        else:
          for i in l..<r:
            actual.add(hld.toVtx(i))
            if i + 1 < r:
              assert hld.parentOf(hld.toVtx(i + 1)) == hld.toVtx(i)
      assert actual == expected
      var unordered: seq[int]
      for (l, r) in hld.path(u, v):
        assert 0 <= l and l < r and r <= adj.len
        for i in l..<r:
          unordered.add(hld.toVtx(i))
      assert unordered.sorted() == expected.sorted()

import random
var rng = initRand(20260910)
for n in [1, 2, 7, 30]:
  for shape in 0..<4:
    var adj = newSeq[seq[int]](n)
    for v in 1..<n:
      let p = case shape
        of 0: v - 1
        of 1: 0
        of 2: (v - 1) div 2
        else: rng.rand(v - 1)
      adj[p].add(v)
      adj[v].add(p)
    for root in 0..<n:
      checkPaths(adj, root)
