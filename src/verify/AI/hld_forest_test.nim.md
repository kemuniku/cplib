---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import random, sequtils\nimport cplib/graph/graph\nimport cplib/tree/heavylightdecomposition\n\
    \nproc checkForest(n: int, edges: seq[(int, int)]) =\n  var g = initUnWeightedUnDirectedStaticGraph(n)\n\
    \  var weighted = initWeightedUnDirectedGraph(n)\n  var directed = initWeightedDirectedStaticGraph(n)\n\
    \  var adj = newSeq[seq[int]](n)\n  for (u, v) in edges:\n    g.add_edge(u, v)\n\
    \    weighted.add_edge(u, v, 7)\n    directed.add_edge(v, u, 3)\n    directed.add_edge(u,\
    \ v, 5)\n    adj[v].add(u)\n  g.build()\n  directed.build()\n\n  var tree = initUnWeightedUnDirectedGraph(n\
    \ + 1)\n  for (u, v) in edges:\n    tree.add_edge(u, v)\n  var seen = newSeq[bool](n)\n\
    \  for root in 0..<n:\n    if seen[root]:\n      continue\n    tree.add_edge(n,\
    \ root)\n    seen[root] = true\n    var queue = @[root]\n    var head = 0\n  \
    \  while head < queue.len:\n      let v = queue[head]\n      inc head\n      for\
    \ (u, _) in g.to_and_cost(v):\n        if not seen[u]:\n          seen[u] = true\n\
    \          queue.add(u)\n  let expected = tree.initHld(n)\n  for actual in [g.initHldFromForest(),\
    \ weighted.initHldFromForest(),\n                 directed.initHldFromForest(),\
    \ adj.initHldFromForest()]:\n    assert actual.numVertices == n + 1\n    assert\
    \ actual.parentOf(n) == -1\n    assert actual.depth(n) == 0\n    assert actual.subtree(n)\
    \ == (0, n + 1)\n    for v in 0..n:\n      assert actual.parentOf(v) == expected.parentOf(v)\n\
    \      assert actual.depth(v) == expected.depth(v)\n      assert actual.toVtx(actual.toSeq(v))\
    \ == v\n      for u in 0..n:\n        assert actual.lca(u, v) == expected.lca(u,\
    \ v)\n        assert actual.dist(u, v) == expected.dist(u, v)\n\ncheckForest(0,\
    \ @[])\ncheckForest(1, @[])\ncheckForest(8, @[])\ncheckForest(7, @[(4, 1), (1,\
    \ 6), (0, 3), (3, 5)])\nvar rng = initRand(20260913)\nfor n in 2..30:\n  for trial\
    \ in 0..<10:\n    var labels = toSeq(0..<n)\n    rng.shuffle(labels)\n    var\
    \ edges: seq[(int, int)]\n    for v in 1..<n:\n      if rng.rand(2) != 0:\n  \
    \      edges.add((labels[v], labels[rng.rand(v - 1)]))\n    checkForest(n, edges)\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/hld_forest_test.nim
  requiredBy: []
  timestamp: '2026-09-14 07:58:37+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/hld_forest_test.nim
layout: document
redirect_from:
- /verify/verify/AI/hld_forest_test.nim
- /verify/verify/AI/hld_forest_test.nim.html
title: verify/AI/hld_forest_test.nim
---
