---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/k_shortest_walk.nim
    title: cplib/graph/k_shortest_walk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/k_shortest_walk.nim
    title: cplib/graph/k_shortest_walk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/reverse_edge.nim
    title: cplib/graph/reverse_edge.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/reverse_edge.nim
    title: cplib/graph/reverse_edge.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/steiner_tree.nim
    title: cplib/graph/steiner_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/steiner_tree.nim
    title: cplib/graph/steiner_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
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
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/reverse_edge\nimport\
    \ cplib/graph/dijkstra\nimport cplib/graph/bellmanford\nimport cplib/graph/maxk_dijkstra\n\
    import cplib/graph/warshall_floyd\nimport cplib/graph/steiner_tree\nimport cplib/graph/k_shortest_walk\n\
    import cplib/utils/constants\n\ntemplate checkGraph(init: untyped, weighted, undirected,\
    \ isStatic: static bool) =\n    block:\n        var g = init\n        template\
    \ add(u, v, c: int): int =\n            when weighted: g.add_edge(u, v, c)\n \
    \           else: g.add_edge(u, v)\n        assert add(2, 0, 5) == 0\n       \
    \ assert add(0, 1, 7) == 1\n        assert add(0, 1, 9) == 2\n        assert add(0,\
    \ 0, 11) == 3\n        assert g.edge_count == 4\n        assert g.get_edge(0).src\
    \ == 2\n        assert g.get_edge(0).dst == 0\n        when weighted:\n      \
    \      assert g.get_edge(0).cost == 5\n        else:\n            static: doAssert\
    \ not compiles(g.edge_info[0].cost)\n            static: doAssert sizeof(EdgeInfo[void])\
    \ == 2 * sizeof(int)\n        when isStatic: g.build()\n        let expected =\
    \ when undirected: @[(2, 0), (1, 1), (1, 2), (0, 3), (0, 3)]\n               \
    \        else: @[(1, 1), (1, 2), (0, 3)]\n        assert toSeq(g.to_and_id(0))\
    \ == expected\n        for (dst, cost, id) in g.to_and_cost_and_id(0):\n     \
    \       assert (dst, id) in expected\n            when weighted: assert cost ==\
    \ g.get_edge(id).cost\n            else: assert cost == 1\n        when isStatic:\n\
    \            g.build()\n            assert toSeq(g.to_and_id(0)) == expected\n\
    \        assert add(1, 2, 13) == 4\n        when isStatic:\n            var rejected\
    \ = false\n            try: discard toSeq(g.to_and_id(0))\n            except\
    \ AssertionDefect: rejected = true\n            assert rejected\n            g.build()\n\
    \        assert toSeq(g.to_and_id(0)) == expected\n        for u in 0..<g.len:\n\
    \            for (dst, cost, id) in g.to_and_cost_and_id(u):\n               \
    \ assert (dst, id) in toSeq(g.to_and_id(u))\n                when weighted:\n\
    \                    assert cost == g.get_edge(id).cost\n                    assert\
    \ (dst, cost) in toSeq(g[u])\n                else:\n                    assert\
    \ cost == 1\n        when not undirected:\n            let reversed = g.reverse_edge()\n\
    \            for id in 0..<g.edge_count:\n                assert reversed.get_edge(id).src\
    \ == g.get_edge(id).dst\n                assert reversed.get_edge(id).dst == g.get_edge(id).src\n\
    \            assert toSeq(reversed.to_and_id(0)) == @[(2, 0), (0, 3)]\n\ncheckGraph(initWeightedDirectedGraph(3),\
    \ true, false, false)\ncheckGraph(initWeightedUnDirectedGraph(3), true, true,\
    \ false)\ncheckGraph(initUnWeightedDirectedGraph(3), false, false, false)\ncheckGraph(initUnWeightedUnDirectedGraph(3),\
    \ false, true, false)\ncheckGraph(initWeightedDirectedStaticGraph(3, capacity\
    \ = 1), true, false, true)\ncheckGraph(initWeightedUnDirectedStaticGraph(3), true,\
    \ true, true)\ncheckGraph(initUnWeightedDirectedStaticGraph(3), false, false,\
    \ true)\ncheckGraph(initUnWeightedUnDirectedStaticGraph(3), false, true, true)\n\
    \ntemplate checkAlgorithms(init: untyped, isStatic: static bool) =\n    block:\n\
    \        var g = init\n        g.add_edge(0, 1)\n        g.add_edge(1, 2)\n  \
    \      when isStatic: g.build()\n        assert g.dijkstra(0) == @[0, 1, 2]\n\
    \        assert g.bellmanford(0) == @[0, 1, 2]\n        assert g.maxk_dijkstra(0,\
    \ 2) == @[0, 1, 2]\n        assert g.shortest_path_dijkstra(0, 2).cost == 2\n\
    \        assert g.shortest_path_bellmanford(0, 2).cost == 2\n        assert g.shortest_path_maxk_dijkstra(0,\
    \ 2, 2).cost == 2\n        assert g.warshall_floyd()[0][2] == 2\n        assert\
    \ g.k_shortest_walk(0, 2, 2) == @[2, INF64]\n\ncheckAlgorithms(initUnWeightedDirectedGraph(3),\
    \ false)\ncheckAlgorithms(initUnWeightedDirectedStaticGraph(3), true)\n\nvar empty\
    \ = initUnWeightedUnDirectedStaticGraph(0)\nempty.build()\nempty.build()\nassert\
    \ empty.edge_count == 0\nassert empty.len == 0\nvar isolated = initUnWeightedDirectedStaticGraph(2)\n\
    isolated.build()\nassert toSeq(isolated[0]).len == 0\n\nvar tableGraph = initWeightedUnDirectedTableGraph(@[\"\
    a\", \"b\"], float)\nassert tableGraph.add_edge(\"a\", \"b\", 1.5) == 0\nassert\
    \ toSeq(tableGraph.to_and_id(\"b\")) == @[(\"a\", 0)]\nassert toSeq(tableGraph.to_and_cost_and_id(\"\
    a\")) == @[(\"b\", 1.5, 0)]\nvar unweightedTableGraph = initUnWeightedDirectedTableGraph(@[\"\
    a\", \"b\"])\nassert unweightedTableGraph.add_edge(\"a\", \"b\") == 0\nassert\
    \ toSeq(unweightedTableGraph.to_and_id(\"a\")) == @[(\"b\", 0)]\necho \"Hello\
    \ World\"\n\nvar tree = initUnWeightedUnDirectedGraph(3)\ntree.add_edge(0, 1)\n\
    tree.add_edge(1, 2)\nassert tree.steiner_tree_mincost(@[0, 2]) == 2\n"
  dependsOn:
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/reverse_edge.nim
  - cplib/utils/bititers.nim
  - cplib/graph/graph.nim
  - cplib/graph/bellmanford.nim
  - cplib/graph/bellmanford.nim
  - cplib/graph/reverse_edge.nim
  - cplib/graph/k_shortest_walk.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/graph/steiner_tree.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/graph/k_shortest_walk.nim
  - cplib/graph/graph.nim
  - cplib/utils/bititers.nim
  - cplib/graph/steiner_tree.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/AI/graph_edge_id_test.nim
  requiredBy: []
  timestamp: '2026-09-14 16:47:56+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/graph_edge_id_test.nim
layout: document
redirect_from:
- /verify/verify/AI/graph_edge_id_test.nim
- /verify/verify/AI/graph_edge_id_test.nim.html
title: verify/AI/graph_edge_id_test.nim
---
