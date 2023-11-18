---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':warning:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':warning:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/restore_dijkstra_test.nim
    title: verify/graph/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/restore_dijkstra_test.nim
    title: verify/graph/restore_dijkstra_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/shortest_path_test.nim
    title: verify/graph/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/shortest_path_test.nim
    title: verify/graph/shortest_path_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/unweighted_directed_graph_aoj_test.nim
    title: verify/graph/unweighted_directed_graph_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/unweighted_directed_graph_aoj_test.nim
    title: verify/graph/unweighted_directed_graph_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/tree_atcoder_test.nim
    title: verify/tree/tree_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/tree_atcoder_test.nim
    title: verify/tree/tree_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/tree_init_by_parent_atcoder_test.nim
    title: verify/tree/tree_init_by_parent_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/tree_init_by_parent_atcoder_test.nim
    title: verify/tree/tree_init_by_parent_atcoder_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_GRAPH:\n    const CPLIB_GRAPH_GRAPH* = 1\n\n\
    \    type Graph*[T] = ref object of RootObj\n        edges*: seq[seq[(int, T)]]\n\
    \n    type WeightedDirectedGraph*[T] = ref object of Graph[T]\n    type WeightedUnDirectedGraph*[T]\
    \ = ref object of Graph[T]\n    type UnWeightedDirectedGraph* = ref object of\
    \ Graph[int]\n    type UnWeightedUnDirectedGraph* = ref object of Graph[int]\n\
    \n    type GraphTypes* = Graph or WeightedDirectedGraph or WeightedUnDirectedGraph\
    \ or UnWeightedDirectedGraph or UnWeightedUnDirectedGraph\n\n    proc add_edge_impl[T](g:\
    \ GraphTypes, u, v: int, cost: T, directed: bool) =\n        g.edges[u].add((v,\
    \ cost))\n        if not directed: g.edges[v].add((u, cost))\n\n    #WeightedDirectedGraph\n\
    \    proc initWeightedDirectedGraph*(N: int, edgetype: typedesc = int): WeightedDirectedGraph[edgetype]\
    \ =\n        result = WeightedDirectedGraph[edgetype](edges: newSeq[seq[(int,\
    \ edgetype)]](N))\n    proc add_edge*[T](g: var WeightedDirectedGraph[T], u, v:\
    \ int, cost: T) =\n        g.add_edge_impl(u, v, cost, true)\n\n    #WeightedUnDirectedGraph\n\
    \    proc initWeightedUnDirectedGraph*(N: int, edgetype: typedesc = int): WeightedUnDirectedGraph[edgetype]\
    \ =\n        result = WeightedUnDirectedGraph[edgetype](edges: newSeq[seq[(int,\
    \ edgetype)]](N))\n    proc add_edge*[T](g: var WeightedUnDirectedGraph[T], u,\
    \ v: int, cost: T) =\n        g.add_edge_impl(u, v, cost, false)\n\n    #UnWeightedDirectedGraph\n\
    \    proc initUnWeightedDirectedGraph*(N: int): UnWeightedDirectedGraph =\n  \
    \      result = UnWeightedDirectedGraph(edges: newSeq[seq[(int, int)]](N))\n \
    \   proc add_edge*(g: var UnWeightedDirectedGraph, u, v: int) =\n        g.add_edge_impl(u,\
    \ v, 1, true)\n\n    #UnWeightedUnDirectedGraph\n    proc initUnWeightedUnDirectedGraph*(N:\
    \ int): UnWeightedUnDirectedGraph =\n        result = UnWeightedUnDirectedGraph(edges:\
    \ newSeq[seq[(int, int)]](N))\n    proc add_edge*(g: var UnWeightedUnDirectedGraph,\
    \ u, v: int) =\n        g.add_edge_impl(u, v, 1, false)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/graph/graph.nim
  requiredBy:
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra.nim
  - cplib/tree/tree.nim
  - cplib/tree/tree.nim
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  timestamp: '2023-11-16 00:40:08+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/shortest_path_test.nim
  - verify/graph/shortest_path_test.nim
  - verify/graph/unweighted_directed_graph_aoj_test.nim
  - verify/graph/unweighted_directed_graph_aoj_test.nim
  - verify/graph/restore_dijkstra_test.nim
  - verify/graph/restore_dijkstra_test.nim
  - verify/tree/tree_atcoder_test.nim
  - verify/tree/tree_atcoder_test.nim
  - verify/tree/tree_init_by_parent_atcoder_test.nim
  - verify/tree/tree_init_by_parent_atcoder_test.nim
documentation_of: cplib/graph/graph.nim
layout: document
redirect_from:
- /library/cplib/graph/graph.nim
- /library/cplib/graph/graph.nim.html
title: cplib/graph/graph.nim
---
