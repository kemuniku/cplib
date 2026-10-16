---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/cycle_detection.nim
    title: cplib/graph/cycle_detection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/cycle_detection.nim
    title: cplib/graph/cycle_detection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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
    import random, sequtils\nimport cplib/graph/graph\nimport cplib/graph/cycle_detection\n\
    \nproc check(g: DirectedGraph or UnDirectedGraph, expected: bool) =\n    let cycle\
    \ = g.cycle_detection()\n    doAssert (cycle.len > 0) == expected\n    let vertices\
    \ = g.restore_cycle_vertices(cycle)\n    doAssert vertices.len == cycle.len\n\
    \    var seenVertices = newSeq[bool](g.len)\n    var seenEdges = newSeq[bool](g.edge_count)\n\
    \    for i, id in cycle:\n        let v = vertices[i]\n        let to = vertices[(i\
    \ + 1) mod vertices.len]\n        doAssert not seenVertices[v]\n        doAssert\
    \ not seenEdges[id]\n        seenVertices[v] = true\n        seenEdges[id] = true\n\
    \        let e = g.get_edge(id)\n        when g is DirectedGraph:\n          \
    \  doAssert e.src == v and e.dst == to\n        else:\n            doAssert (e.src\
    \ == v and e.dst == to) or (e.dst == v and e.src == to)\n\nproc hasCycle(n: int,\
    \ edges: seq[(int, int)], undirected: bool): bool =\n    var reach = newSeqWith(n,\
    \ newSeq[bool](n))\n    for (u, v) in edges:\n        if undirected:\n       \
    \     if u == v or reach[u][v]: return true\n            reach[v][u] = true\n\
    \        reach[u][v] = true\n        for k in 0..<n:\n            for i in 0..<n:\n\
    \                for j in 0..<n:\n                    reach[i][j] = reach[i][j]\
    \ or (reach[i][k] and reach[k][j])\n    if not undirected:\n        for v in 0..<n:\n\
    \            if reach[v][v]: return true\n\ntemplate checkTypes(n: int, edges:\
    \ seq[(int, int)]) =\n    block:\n        let directedCycle = hasCycle(n, edges,\
    \ false)\n        let undirectedCycle = hasCycle(n, edges, true)\n        template\
    \ run(init: untyped) =\n            block:\n                var g = init\n   \
    \             for (u, v) in edges:\n                    when g is WeightedGraph:\
    \ g.add_edge(u, v, -7)\n                    else: g.add_edge(u, v)\n         \
    \       when g is StaticGraphTypes: g.build()\n                when g is UnDirectedGraph:\
    \ check(g, undirectedCycle)\n                else: check(g, directedCycle)\n \
    \       run(initUnWeightedDirectedGraph(n))\n        run(initUnWeightedUnDirectedGraph(n))\n\
    \        run(initWeightedDirectedGraph(n))\n        run(initWeightedUnDirectedGraph(n))\n\
    \        run(initUnWeightedDirectedStaticGraph(n))\n        run(initUnWeightedUnDirectedStaticGraph(n))\n\
    \        run(initWeightedDirectedStaticGraph(n))\n        run(initWeightedUnDirectedStaticGraph(n))\n\
    \ncheckTypes(0, newSeq[(int, int)]())\ncheckTypes(4, newSeq[(int, int)]())\ncheckTypes(1,\
    \ @[(0, 0)])\ncheckTypes(2, @[(0, 1)])\ncheckTypes(2, @[(0, 1), (0, 1)])\ncheckTypes(2,\
    \ @[(0, 1), (1, 0)])\ncheckTypes(3, @[(1, 0), (1, 2), (0, 2)])\ncheckTypes(4,\
    \ @[(0, 1), (0, 2), (2, 1), (1, 3), (2, 3)])\ncheckTypes(6, @[(0, 1), (2, 3),\
    \ (3, 4), (4, 2)])\nvar rng = initRand(20260917)\nfor trial in 0..<400:\n    let\
    \ n = rng.rand(1..8)\n    var edges: seq[(int, int)]\n    for i in 0..<rng.rand(0..20):\n\
    \        edges.add((rng.rand(n - 1), rng.rand(n - 1)))\n    checkTypes(n, edges)\n\
    \ntemplate checkDeep(init: untyped) =\n    block:\n        var g = init\n    \
    \    for i in 1..<g.len: g.add_edge(i - 1, i)\n        when g is StaticGraphTypes:\
    \ g.build()\n        check(g, false)\n        g.add_edge(g.len - 1, 0)\n     \
    \   when g is StaticGraphTypes: g.build()\n        check(g, true)\n        doAssert\
    \ g.cycle_detection().len == g.len\ncheckDeep(initUnWeightedDirectedGraph(200000))\n\
    checkDeep(initUnWeightedUnDirectedGraph(200000))\ncheckDeep(initUnWeightedDirectedStaticGraph(200000))\n\
    checkDeep(initUnWeightedUnDirectedStaticGraph(200000))\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/cycle_detection.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/cycle_detection.nim
  isVerificationFile: true
  path: verify/AI/cycle_detection_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/cycle_detection_test.nim
layout: document
redirect_from:
- /verify/verify/AI/cycle_detection_test.nim
- /verify/verify/AI/cycle_detection_test.nim.html
title: verify/AI/cycle_detection_test.nim
---
