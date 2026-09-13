---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':question:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/range_edge_graph.nim
    title: cplib/graph/range_edge_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/range_edge_graph.nim
    title: cplib/graph/range_edge_graph.nim
  - icon: ':question:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':question:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
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
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/range_edge_graph\n\
    import cplib/graph/dijkstra\n\ntemplate checkMixed(init: untyped, weighted: static\
    \ bool) =\n    block:\n        var g = init\n        var expected = newSeq[seq[(int,\
    \ int, int)]](7)\n        for id in 0..<80:\n            let u = (id * 13 + 2)\
    \ mod 7\n            let v = (id * 17) mod 7\n            let directed = id <\
    \ 15 or id mod 3 == 0\n            when weighted:\n                doAssert g.add_edge_static_impl(u,\
    \ v, id + 1, directed) == id\n            else:\n                doAssert g.add_edge_static_impl(u,\
    \ v, directed) == id\n            let cost = when weighted: id + 1 else: 1\n \
    \           expected[u].add((v, cost, id))\n            if not directed: expected[v].add((u,\
    \ cost, id))\n            if id mod 9 == 0 or id == 79:\n                g.build()\n\
    \                for x in 0..<7:\n                    doAssert toSeq(g.to_and_cost_and_id(x))\
    \ == expected[x]\n                g.build()\n                for x in 0..<7:\n\
    \                    doAssert toSeq(g.to_and_cost_and_id(x)) == expected[x]\n\n\
    checkMixed(initWeightedDirectedStaticGraph(7), true)\ncheckMixed(initUnWeightedUnDirectedStaticGraph(7),\
    \ false)\n\nblock:\n    var g = initUnWeightedDirectedStaticGraph(2)\n    g.add_edge_static_impl(0,\
    \ 1, false)\n    g.build()\n    g.add_edge_static_impl(0, 0, true)\n    g.add_edge_static_impl(1,\
    \ 1, false)\n    g.build()\n    doAssert toSeq(g.to_and_id(0)) == @[(1, 0), (0,\
    \ 1)]\n    doAssert toSeq(g.to_and_id(1)) == @[(0, 0), (1, 2), (1, 2)]\n\ntemplate\
    \ checkReserve(init: untyped, weighted, undirected: static bool) =\n    block:\n\
    \        var g = init\n        g.reserve(20, [8, 8, 8])\n        when weighted:\n\
    \            g.add_edge(0, 0, 7)\n            g.add_edge(0, 1, 9)\n        else:\n\
    \            g.add_edge(0, 0)\n            g.add_edge(0, 1)\n        let before\
    \ = toSeq(g.to_and_cost_and_id(0))\n        g.reserve(30, [12, 12, 12])\n    \
    \    g.reserve(0, [0, 0, 0])\n        doAssert toSeq(g.to_and_cost_and_id(0))\
    \ == before\n        when weighted: doAssert g.add_edge(1, 2, 11) == 2\n     \
    \   else: doAssert g.add_edge(1, 2) == 2\n        doAssert toSeq(g.to_and_id(1))\
    \ == (when undirected: @[(0, 1), (2, 2)] else: @[(2, 2)])\n        doAssert g.get_edge(0).src\
    \ == 0\n        doAssert g.get_edge(2).dst == 2\n        doAssert g.edge_count\
    \ == 3\n        g.reserve(40)\n        doAssert toSeq(g.to_and_cost_and_id(0))\
    \ == before\n\ncheckReserve(initWeightedDirectedGraph(3, capacity = 4), true,\
    \ false)\ncheckReserve(initWeightedUnDirectedGraph(3, capacity = 4), true, true)\n\
    checkReserve(initUnWeightedDirectedGraph(3, capacity = 4), false, false)\ncheckReserve(initUnWeightedUnDirectedGraph(3,\
    \ capacity = 4), false, true)\n\nblock:\n    var dynamic = initWeightedUnDirectedGraph(2,\
    \ seq[int], capacity = 3)\n    dynamic.add_edge(0, 1, @[3, 5])\n    dynamic.reserve(10,\
    \ [10, 10])\n    dynamic.add_edge(0, 0, @[7])\n    doAssert toSeq(dynamic.to_and_cost_and_id(0))\
    \ == @[(1, @[3, 5], 0), (0, @[7], 1), (0, @[7], 1)]\n    var fixed = initWeightedDirectedStaticGraph(2,\
    \ seq[int])\n    fixed.add_edge_static_impl(0, 1, @[3, 5], false)\n    fixed.add_edge_static_impl(1,\
    \ 1, @[7], true)\n    fixed.build()\n    fixed.build()\n    doAssert toSeq(fixed.to_and_cost_and_id(1))\
    \ == @[(0, @[3, 5], 0), (1, @[7], 1)]\n\nblock:\n    var g = initWeightedRangeGraph(4)\n\
    \    g.add_range_to_range_edge(0, 2, 2, 4, 7)\n    g.add_point_to_point_edge(0,\
    \ 1, 3)\n    doAssert g.graph.dijkstra(0)[0..<4] == @[0, 3, 7, 7]\n    for u in\
    \ 0..<g.len:\n        for (v, cost, id) in g.graph.to_and_cost_and_id(u):\n  \
    \          doAssert g.graph.get_edge(id) == EdgeInfo[int](src: u, dst: v, cost:\
    \ cost)\n\necho \"Hello World\""
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/range_edge_graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/range_edge_graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  isVerificationFile: true
  path: verify/AI/graph_storage_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/graph_storage_test.nim
layout: document
redirect_from:
- /verify/verify/AI/graph_storage_test.nim
- /verify/verify/AI/graph_storage_test.nim.html
title: verify/AI/graph_storage_test.nim
---
