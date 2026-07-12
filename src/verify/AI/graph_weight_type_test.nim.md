---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
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
    path: cplib/graph/kruskal.nim
    title: cplib/graph/kruskal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/kruskal.nim
    title: cplib/graph/kruskal.nim
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
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/tsp.nim
    title: cplib/graph/tsp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
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
    echo \"Hello World\"\n\nimport std/math\nimport cplib/graph/bellmanford\nimport\
    \ cplib/graph/dijkstra\nimport cplib/graph/graph\nimport cplib/graph/kruskal\n\
    import cplib/graph/maxk_dijkstra\nimport cplib/graph/reverse_edge\nimport cplib/graph/steiner_tree\n\
    import cplib/graph/topologicalsort\nimport cplib/graph/tsp\nimport cplib/graph/warshall_floyd\n\
    import cplib/tree/diameter\nimport cplib/tree/heavylightdecomposition\n\ntemplate\
    \ assertClose(a, b: float) =\n  assert abs(a - b) < 1e-9\n\nvar g = initWeightedDirectedGraph(4,\
    \ float)\ng.add_edge(0, 1, 1.5)\ng.add_edge(1, 2, 2.25)\ng.add_edge(0, 2, 10.0)\n\
    g.add_edge(2, 3, 0.5)\nassertClose(g.dijkstra(0)[3], 4.25)\nassertClose(g.bellmanford(0)[3],\
    \ 4.25)\nassertClose(g.shortest_path_dijkstra(0, 3).cost, 4.25)\nassertClose(g.shortest_path_bellmanford(0,\
    \ 3).cost, 4.25)\nassertClose(g.warshall_floyd().d[0][3], 4.25)\n\nlet rg = g.reverse_edge()\n\
    assertClose(rg.to_adjacency_matrix(1e100)[1][0], 1.5)\n\nlet contracted = g.toContractionGraph(@[0,\
    \ 2, 3])\nassertClose(contracted.to_adjacency_matrix(1e100)[0][1], 3.75)\n\nvar\
    \ dag = initWeightedDirectedGraph(3, float)\ndag.add_edge(0, 1, 1.0)\ndag.add_edge(1,\
    \ 2, 2.0)\nlet ord = dag.topologicalsort()\nassert ord.len == 3\nassert ord.find(0)\
    \ < ord.find(1)\nassert ord.find(1) < ord.find(2)\n\nvar ug = initWeightedUnDirectedGraph(4,\
    \ float)\nug.add_edge(0, 1, 1.5)\nug.add_edge(1, 2, 2.0)\nug.add_edge(1, 3, 0.75)\n\
    ug.add_edge(0, 3, 10.0)\nassertClose(ug.get_MST_cost(), 4.25)\nlet mst = ug.to_MST_Graph()\n\
    assertClose(mst.get_MST_cost(), 4.25)\nassertClose(ug.steiner_tree_mincost(@[0,\
    \ 2, 3]), 4.25)\nassertClose(ug.steiner_tree_mincost(@[0, 2, 3], 0.0, 1e100),\
    \ 4.25)\n\nvar tree = initWeightedUnDirectedGraph(4, float)\ntree.add_edge(0,\
    \ 1, 1.0)\ntree.add_edge(1, 2, 4.0)\ntree.add_edge(1, 3, 6.0)\nassertClose(tree.diameter(),\
    \ 10.0)\n\nlet hld = tree.initHld(0)\nassert hld.dist(2, 3) == 2\nlet aux = hld.initAuxiliaryWeightedTree(@[2,\
    \ 3], float)\nvar auxCost = 0.0\nfor (_, c) in aux[1]:\n  auxCost += c\nassertClose(auxCost,\
    \ 2.0)\n\nvar sg = initWeightedUnDirectedStaticGraph(3, int32)\nsg.add_edge(0,\
    \ 1, 2.int32)\nsg.add_edge(1, 2, 3.int32)\nsg.add_edge(0, 2, 10.int32)\nsg.build()\n\
    assert sg.get_MST_cost() == 5.int32\nassert sg.to_MST_Graph().get_MST_cost() ==\
    \ 5.int32\nassert sg.steiner_tree_mincost(@[0, 2], 0.int32, 100.int32) == 5.int32\n\
    \nvar kg = initWeightedDirectedGraph(3, int32)\nkg.add_edge(0, 1, 1.int32)\nkg.add_edge(1,\
    \ 2, 2.int32)\nkg.add_edge(0, 2, 4.int32)\nassert kg.maxk_dijkstra(0, 4.int32)[2]\
    \ == 3.int32\nassert kg.shortest_path_maxk_dijkstra(0, 2, 4.int32).cost == 3.int32\n\
    \nlet dist = @[\n  @[0.0, 1.5, 3.0],\n  @[1.5, 0.0, 2.0],\n  @[3.0, 2.0, 0.0]\n\
    ]\nassertClose(tspPathCostFrom(dist, 0), 3.5)\nassertClose(tspPathCostFromTo(dist,\
    \ 0, 2), 3.5)\nassertClose(tspPathAnyStart(dist), 3.5)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/tsp.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/kruskal.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/dijkstra.nim
  - cplib/tree/diameter.nim
  - cplib/graph/bellmanford.nim
  - cplib/utils/bititers.nim
  - cplib/graph/kruskal.nim
  - cplib/utils/bititers.nim
  - cplib/collections/unionfind.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/warshall_floyd.nim
  - cplib/utils/constants.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/tsp.nim
  - cplib/graph/steiner_tree.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/constants.nim
  - cplib/graph/steiner_tree.nim
  - cplib/tree/diameter.nim
  - cplib/graph/reverse_edge.nim
  - cplib/graph/reverse_edge.nim
  - cplib/collections/unionfind.nim
  - cplib/graph/bellmanford.nim
  isVerificationFile: true
  path: verify/AI/graph_weight_type_test.nim
  requiredBy: []
  timestamp: '2026-07-09 07:24:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/graph_weight_type_test.nim
layout: document
redirect_from:
- /verify/verify/AI/graph_weight_type_test.nim
- /verify/verify/AI/graph_weight_type_test.nim.html
title: verify/AI/graph_weight_type_test.nim
---
