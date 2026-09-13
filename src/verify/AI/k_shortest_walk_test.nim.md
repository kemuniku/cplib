---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/k_shortest_walk.nim
    title: cplib/graph/k_shortest_walk.nim
  - icon: ':question:'
    path: cplib/graph/k_shortest_walk.nim
    title: cplib/graph/k_shortest_walk.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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
    import cplib/graph/graph\nimport cplib/graph/k_shortest_walk\nimport cplib/utils/constants\n\
    import heapqueue, random, sequtils\n\nproc naive(g: WeightedDirectedGraph[int],\
    \ s, t, k: int): seq[int] =\n    var queue = initHeapQueue[(int, int)]()\n   \
    \ var count = newSeq[int](g.len)\n    queue.push((0, s))\n    while queue.len\
    \ > 0 and result.len < k:\n        let (cost, u) = queue.pop()\n        if count[u]\
    \ == k: continue\n        inc count[u]\n        if u == t: result.add(cost)\n\
    \        for (v, w) in g.to_and_cost(u):\n            if count[v] < k: queue.push((cost\
    \ + w, v))\n    while result.len < k: result.add(INF64)\n\nblock:\n    var g =\
    \ initWeightedDirectedGraph(3)\n    doAssert g.k_shortest_walk(0, 0, 5) == @[0,\
    \ INF64, INF64, INF64, INF64]\n    doAssert g.k_shortest_walk(0, 2, 5) == newSeqWith(5,\
    \ INF64)\n    doAssert g.k_shortest_walk(0, 2, 1) == @[INF64]\n    doAssert g.k_shortest_walk(0,\
    \ 0, 1) == @[0]\n    doAssert g.k_shortest_walk(0, 2, 3, INF = 100) == @[100,\
    \ 100, 100]\n    doAssert g.k_shortest_walk(0, 0, 0) == newSeq[int]()\n    g.add_edge(0,\
    \ 1, 2)\n    g.add_edge(0, 1, 2)\n    g.add_edge(1, 2, 3)\n    doAssert g.k_shortest_walk(0,\
    \ 2, 5) == @[5, 5, INF64, INF64, INF64]\n    doAssert g.k_shortest_walk(0, 2,\
    \ 3, INF = 100) == @[5, 5, 100]\n    g.add_edge(2, 2, 0)\n    doAssert g.k_shortest_walk(0,\
    \ 2, 20) == newSeqWith(20, 5)\n\nblock:\n    var g = initWeightedDirectedGraph(3)\n\
    \    g.add_edge(0, 1, 0)\n    g.add_edge(1, 0, 0)\n    g.add_edge(0, 2, 1)\n \
    \   g.add_edge(1, 2, 1)\n    doAssert g.k_shortest_walk(0, 2, 20) == newSeqWith(20,\
    \ 1)\n    doAssert g.k_shortest_walk(0, 0, 20) == newSeqWith(20, 0)\n\nblock:\n\
    \    var g = initWeightedDirectedGraph(2)\n    g.add_edge(0, 1, 3)\n    g.add_edge(1,\
    \ 0, 4)\n    doAssert g.k_shortest_walk(0, 1, 4) == @[3, 10, 17, 24]\n\nvar rng\
    \ = initRand(712398)\nfor trial in 0..<1000:\n    let n = rng.rand(1..7)\n   \
    \ var g = initWeightedDirectedGraph(n)\n    var gs = initWeightedDirectedStaticGraph(n)\n\
    \    for _ in 0..<rng.rand(0..40):\n        let u = rng.rand(n - 1)\n        let\
    \ v = rng.rand(n - 1)\n        let w = rng.rand(0..9)\n        g.add_edge(u, v,\
    \ w)\n        gs.add_edge(u, v, w)\n    gs.build()\n    for s in 0..<n:\n    \
    \    for t in 0..<n:\n            let k = rng.rand(0..20)\n            let expected\
    \ = naive(g, s, t, k)\n            doAssert g.k_shortest_walk(s, t, k) == expected\n\
    \            doAssert gs.k_shortest_walk(s, t, k) == expected\n\nblock:\n    var\
    \ g = initWeightedDirectedGraph(2, int64)\n    g.add_edge(0, 1, 3_000_000_000'i64)\n\
    \    g.add_edge(1, 1, 1'i64)\n    doAssert g.k_shortest_walk(0, 1, 2) == @[3_000_000_000'i64,\
    \ 3_000_000_001'i64]\n    doAssert g.k_shortest_walk(1, 0, 2) == @[int64(INF64),\
    \ int64(INF64)]\n    var small = initWeightedDirectedStaticGraph(2, int32)\n \
    \   small.add_edge(0, 1, 5'i32)\n    small.build()\n    doAssert small.k_shortest_walk(0,\
    \ 1, 2) == @[5'i32, INF32]\n    doAssert small.k_shortest_walk(0, 1, 2, INF =\
    \ 100'i32) == @[5'i32, 100'i32]\n    var unweighted = initUnWeightedUnDirectedGraph(2)\n\
    \    unweighted.add_edge(0, 1)\n    doAssert unweighted.k_shortest_walk(0, 1,\
    \ 3) == @[1, 3, 5]\n\nblock:\n    let n = 20_000\n    var g = initWeightedDirectedGraph(n)\n\
    \    for u in 0..<n:\n        g.add_edge(u, u, 1)\n        if u + 1 < n: g.add_edge(u,\
    \ u + 1, 1)\n    let lengths = g.k_shortest_walk(0, n - 1, n + 2)\n    doAssert\
    \ lengths.len == n + 2\n    doAssert lengths[0] == n - 1\n    for i in 1..n: doAssert\
    \ lengths[i] == n\n    doAssert lengths[^1] == n + 1\n\nblock:\n    var g = initWeightedDirectedGraph(2)\n\
    \    for w in countdown(100_000, 1): g.add_edge(0, 1, w)\n    doAssert g.k_shortest_walk(0,\
    \ 1, 100_001) == toSeq(1..100_000) & @[INF64]\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/k_shortest_walk.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/k_shortest_walk.nim
  isVerificationFile: true
  path: verify/AI/k_shortest_walk_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/k_shortest_walk_test.nim
layout: document
redirect_from:
- /verify/verify/AI/k_shortest_walk_test.nim
- /verify/verify/AI/k_shortest_walk_test.nim.html
title: verify/AI/k_shortest_walk_test.nim
---
