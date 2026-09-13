# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/tree/heavylightdecomposition

proc checkForest(n: int, edges: seq[(int, int)]) =
  var g = initUnWeightedUnDirectedStaticGraph(n)
  var weighted = initWeightedUnDirectedGraph(n)
  var directed = initWeightedDirectedStaticGraph(n)
  var adj = newSeq[seq[int]](n)
  for (u, v) in edges:
    g.add_edge(u, v)
    weighted.add_edge(u, v, 7)
    directed.add_edge(v, u, 3)
    directed.add_edge(u, v, 5)
    adj[v].add(u)
  g.build()
  directed.build()

  var tree = initUnWeightedUnDirectedGraph(n + 1)
  for (u, v) in edges:
    tree.add_edge(u, v)
  var seen = newSeq[bool](n)
  for root in 0..<n:
    if seen[root]:
      continue
    tree.add_edge(n, root)
    seen[root] = true
    var queue = @[root]
    var head = 0
    while head < queue.len:
      let v = queue[head]
      inc head
      for (u, _) in g.to_and_cost(v):
        if not seen[u]:
          seen[u] = true
          queue.add(u)
  let expected = tree.initHld(n)
  for actual in [g.initHldFromForest(), weighted.initHldFromForest(),
                 directed.initHldFromForest(), adj.initHldFromForest()]:
    assert actual.numVertices == n + 1
    assert actual.parentOf(n) == -1
    assert actual.depth(n) == 0
    assert actual.subtree(n) == (0, n + 1)
    for v in 0..n:
      assert actual.parentOf(v) == expected.parentOf(v)
      assert actual.depth(v) == expected.depth(v)
      assert actual.toVtx(actual.toSeq(v)) == v
      for u in 0..n:
        assert actual.lca(u, v) == expected.lca(u, v)
        assert actual.dist(u, v) == expected.dist(u, v)

checkForest(0, @[])
checkForest(1, @[])
checkForest(8, @[])
checkForest(7, @[(4, 1), (1, 6), (0, 3), (3, 5)])
var rng = initRand(20260913)
for n in 2..30:
  for trial in 0..<10:
    var labels = toSeq(0..<n)
    rng.shuffle(labels)
    var edges: seq[(int, int)]
    for v in 1..<n:
      if rng.rand(2) != 0:
        edges.add((labels[v], labels[rng.rand(v - 1)]))
    checkForest(n, edges)
echo "Hello World"
