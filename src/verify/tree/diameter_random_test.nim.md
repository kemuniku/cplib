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
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
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
    import random, sequtils\nimport cplib/graph/graph\nimport cplib/tree/diameter\n\
    \nproc checkSmall(g: UnDirectedGraph) =\n    when g is WeightedGraph:\n      \
    \  type Cost = g.T\n    else:\n        type Cost = int\n    let n = g.len\n  \
    \  var dist = newSeqWith(n, newSeqWith(n, Cost(1000000)))\n    for x in 0..<n:\n\
    \        dist[x][x] = Cost(0)\n        for (y, cost) in g.to_and_cost(x):\n  \
    \          dist[x][y] = cost\n    for k in 0..<n:\n        for x in 0..<n:\n \
    \           for y in 0..<n:\n                dist[x][y] = min(dist[x][y], dist[x][k]\
    \ + dist[k][y])\n    var expected = Cost(0)\n    for row in dist:\n        for\
    \ d in row: expected = max(expected, d)\n    let (d, u, v) = g.diameter_and_edge()\n\
    \    doAssert d is Cost\n    doAssert d == expected\n    doAssert u in 0..<n and\
    \ v in 0..<n\n    doAssert dist[u][v] == expected\n    doAssert g.diameter() ==\
    \ expected\n    let (pathDist, path) = g.diameter_path()\n    doAssert pathDist\
    \ is Cost\n    doAssert pathDist == expected\n    doAssert path.len > 0\n    doAssert\
    \ path[0] == u and path[^1] == v\n    var seen = newSeq[bool](n)\n    var total\
    \ = Cost(0)\n    for i, x in path:\n        doAssert x in 0..<n\n        doAssert\
    \ not seen[x]\n        seen[x] = true\n        if i == 0: continue\n        var\
    \ found = false\n        for (y, cost) in g.to_and_cost(x):\n            if y\
    \ == path[i - 1]:\n                total += cost\n                found = true\n\
    \                break\n        doAssert found\n    doAssert total == expected\n\
    \nproc checkVariants(n: int, edges: seq[tuple[u, v, cost: int]]) =\n    var wd\
    \ = initWeightedUnDirectedGraph(n, int64)\n    var ws = initWeightedUnDirectedStaticGraph(n,\
    \ int32)\n    var fd = initWeightedUnDirectedGraph(n, float)\n    var fs = initWeightedUnDirectedStaticGraph(n,\
    \ float)\n    var ud = initUnWeightedUnDirectedGraph(n)\n    var us = initUnWeightedUnDirectedStaticGraph(n)\n\
    \    for (u, v, cost) in edges:\n        wd.add_edge(u, v, cost.int64)\n     \
    \   ws.add_edge(u, v, cost.int32)\n        fd.add_edge(u, v, cost.float / 4)\n\
    \        fs.add_edge(u, v, cost.float / 4)\n        ud.add_edge(u, v)\n      \
    \  us.add_edge(u, v)\n    ws.build()\n    fs.build()\n    us.build()\n    checkSmall(wd)\n\
    \    checkSmall(ws)\n    checkSmall(fd)\n    checkSmall(fs)\n    checkSmall(ud)\n\
    \    checkSmall(us)\n\ncheckVariants(1, @[])\ncheckVariants(2, @[(0, 1, 0)])\n\
    checkVariants(2, @[(1, 0, 7)])\ncheckVariants(6, @[(0, 1, 0), (1, 2, 3), (1, 3,\
    \ 3), (3, 4, 0), (3, 5, 0)])\ncheckVariants(7, @[(0, 1, 1), (1, 2, 1), (2, 3,\
    \ 1), (3, 4, 10), (3, 5, 10), (3, 6, 0)])\nfor shape in 0..2:\n    var edges:\
    \ seq[tuple[u, v, cost: int]]\n    for x in 1..<30:\n        let p = if shape\
    \ == 0: 0 elif shape == 1: x - 1 else: (x - 1) div 2\n        edges.add((p, x,\
    \ 0))\n    checkVariants(30, edges)\n    for e in edges.mitems: e.cost = 1\n \
    \   checkVariants(30, edges)\n\nvar rng = initRand(20260930)\nfor trial in 0..<120:\n\
    \    let n = rng.rand(1..30)\n    var labels = toSeq(0..<n)\n    rng.shuffle(labels)\n\
    \    var edges: seq[tuple[u, v, cost: int]]\n    for x in 1..<n:\n        var\
    \ u = labels[rng.rand(x - 1)]\n        var v = labels[x]\n        if rng.rand(1)\
    \ == 0: swap(u, v)\n        edges.add((u, v, rng.rand(20)))\n    rng.shuffle(edges)\n\
    \    checkVariants(n, edges)\n\nproc checkChain(g: UnDirectedGraph, expected:\
    \ auto) =\n    doAssert g.diameter() == expected\n    let (d, u, v) = g.diameter_and_edge()\n\
    \    doAssert d == expected\n    doAssert (u == 0 and v == g.len - 1) or (v ==\
    \ 0 and u == g.len - 1)\n    let (pathDist, path) = g.diameter_path()\n    doAssert\
    \ pathDist == expected\n    doAssert path.len == g.len\n    doAssert path[0] ==\
    \ u and path[^1] == v\n    for i, x in path:\n        doAssert x == (if u == 0:\
    \ i else: g.len - 1 - i)\n\nblock:\n    const n = 200000\n    const weight = 1000000000000'i64\n\
    \    var g = initWeightedUnDirectedStaticGraph(n, int64, n - 1)\n    for x in\
    \ 1..<n: g.add_edge(x - 1, x, weight)\n    g.build()\n    checkChain(g, (n - 1).int64\
    \ * weight)\n\nblock:\n    const n = 200000\n    var g = initUnWeightedUnDirectedGraph(n,\
    \ n - 1)\n    for x in 1..<n: g.add_edge(x - 1, x)\n    checkChain(g, n - 1)\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/diameter.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/diameter.nim
  isVerificationFile: true
  path: verify/tree/diameter_random_test.nim
  requiredBy: []
  timestamp: '2026-09-30 06:49:19+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/diameter_random_test.nim
layout: document
redirect_from:
- /verify/verify/tree/diameter_random_test.nim
- /verify/verify/tree/diameter_random_test.nim.html
title: verify/tree/diameter_random_test.nim
---
