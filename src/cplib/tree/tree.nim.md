---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/tree/prufer_abc328e_test.nim
    title: verify/tree/prufer_abc328e_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/prufer_abc328e_test.nim
    title: verify/tree/prufer_abc328e_test.nim
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
  code: "when not declared CPLIB_TREE_TREE:\n    const CPLIB_TREE_TREE* = 1\n    import\
    \ cplib/graph/graph\n\n    type WeightedTree*[T] = ref object of Graph[T]\n  \
    \  type UnWeightedTree* = ref object of Graph[int]\n\n    type TreeTypes* = WeightedTree\
    \ or UnWeightedTree\n\n    proc add_edge_impl[T](g: TreeTypes, u, v: int, cost:\
    \ T) =\n        g.edges[u].add((v, cost))\n        g.edges[v].add((u, cost))\n\
    \n    #WeightedDirectedGraph\n    proc initWeightedTree*(N: int, edgetype: typedesc\
    \ = int): WeightedTree[edgetype] =\n        result = WeightedTree[edgetype](edges:\
    \ newSeq[seq[(int, edgetype)]](N))\n    proc add_edge*[T](g: var WeightedTree[T],\
    \ u, v: int, cost: T) =\n        g.add_edge_impl(u, v, cost)\n\n    #UnWeightedUnDirectedGraph\n\
    \    proc initUnWeightedTree*(N: int): UnWeightedTree =\n        result = UnWeightedTree(edges:\
    \ newSeq[seq[(int, int)]](N))\n    proc add_edge*(g: var UnWeightedTree, u, v:\
    \ int) =\n        g.add_edge_impl(u, v, 1)\n    proc initUnWeightedTree*(parents:\
    \ seq[int]): UnWeightedTree =\n        result = initUnWeightedTree(parents.len\
    \ + 1)\n        for i in 0..<parents.len:\n            result.add_edge(i+1, parents[i])\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/tree.nim
  requiredBy:
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  timestamp: '2024-01-07 09:42:27+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/prufer_abc328e_test.nim
  - verify/tree/prufer_abc328e_test.nim
  - verify/tree/tree_atcoder_test.nim
  - verify/tree/tree_atcoder_test.nim
  - verify/tree/tree_init_by_parent_atcoder_test.nim
  - verify/tree/tree_init_by_parent_atcoder_test.nim
documentation_of: cplib/tree/tree.nim
layout: document
redirect_from:
- /library/cplib/tree/tree.nim
- /library/cplib/tree/tree.nim.html
title: cplib/tree/tree.nim
---
