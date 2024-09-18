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
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_dynamic_test.nim
    title: verify/tree/diameter_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_dynamic_test.nim
    title: verify/tree/diameter_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_dynamic_test.nim
    title: verify/tree/diameter_path_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_dynamic_test.nim
    title: verify/tree/diameter_path_dynamic_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_static_test.nim
    title: verify/tree/diameter_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_path_static_test.nim
    title: verify/tree/diameter_path_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_static_test.nim
    title: verify/tree/diameter_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_static_test.nim
    title: verify/tree/diameter_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_yosupo_test.nim
    title: verify/tree/diameter_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/diameter_yosupo_test.nim
    title: verify/tree/diameter_yosupo_test.nim
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
  code: "when not declared CPLIB_TREE_TREE:\n    const CPLIB_TREE_TREE* = 1\n    include\
    \ cplib/graph/graph\n\n    type WeightedTree*[T] = ref object of DynamicGraph[T]\n\
    \    type UnWeightedTree* = ref object of DynamicGraph[int]\n    type WeightedStaticTree*[T]\
    \ = ref object of StaticGraph[T]\n    type UnWeightedStaticTree* = ref object\
    \ of StaticGraph[int]\n\n    type TreeTypes* = WeightedTree or UnWeightedTree\
    \ or WeightedStaticTree or UnWeightedStaticTree\n    type WeightedTreeTypes*[T]\
    \ = WeightedTree[T] or WeightedStaticTree[T]\n    type UnWeightedTreeTypes* =\
    \ UnWeightedTree or UnWeightedStaticTree\n    type DynamicTree* = WeightedTree\
    \ or UnWeightedTree\n    type StaticTree* = WeightedStaticTree or UnWeightedStaticTree\n\
    \n    proc len*(g: TreeTypes): int = g.len\n\n    proc initWeightedTree*(N: int,\
    \ edgetype: typedesc = int): WeightedTree[edgetype] =\n        result = WeightedTree[edgetype](edges:\
    \ newSeq[seq[(int32, edgetype)]](N))\n    proc add_edge*[T](g: var WeightedTree[T],\
    \ u, v: int, cost: T) =\n        g.add_edge_dynamic_impl(u, v, cost, false)\n\n\
    \    proc initUnWeightedTree*(N: int): UnWeightedTree =\n        result = UnWeightedTree(edges:\
    \ newSeq[seq[(int32, int)]](N))\n    proc add_edge*(g: var UnWeightedTree, u,\
    \ v: int) =\n        g.add_edge_dynamic_impl(u, v, 1, false)\n    proc initUnWeightedTree*(parents:\
    \ seq[int]): UnWeightedTree =\n        result = initUnWeightedTree(parents.len\
    \ + 1)\n        for i in 0..<parents.len:\n            result.add_edge(i+1, parents[i])\n\
    \n    proc initWeightedStaticTree*(N: int, edgetype: typedesc = int): WeightedStaticTree[edgetype]\
    \ =\n        var capacity = (N - 1) * 2\n        result = WeightedStaticTree[edgetype](\n\
    \            src: newSeqOfCap[int32](capacity*2),\n            dst: newSeqOfCap[int32](capacity*2),\n\
    \            cost: newSeqOfCap[int](capacity*2),\n            elist: newSeq[(int32,\
    \ int)](0),\n            start: newSeq[int32](0),\n            len: N\n      \
    \  )\n    proc add_edge*[T](g: var WeightedStaticTree[T], u, v: int, cost: T)\
    \ =\n        g.add_edge_static_impl(u, v, cost, false)\n\n    proc initUnWeightedStaticTree*(N:\
    \ int): UnWeightedStaticTree =\n        var capacity = (N - 1) * 2\n        result\
    \ = UnWeightedStaticTree(\n            src: newSeqOfCap[int32](capacity*2),\n\
    \            dst: newSeqOfCap[int32](capacity*2),\n            cost: newSeqOfCap[int](capacity*2),\n\
    \            elist: newSeq[(int32, int)](0),\n            start: newSeq[int32](0),\n\
    \            len: N\n        )\n    proc add_edge*(g: var UnWeightedStaticTree,\
    \ u, v: int) =\n        g.add_edge_static_impl(u, v, 1, false)\n    proc initUnWeightedStaticTree*(parents:\
    \ seq[int]): UnWeightedStaticTree =\n        result = initUnWeightedStaticTree(parents.len\
    \ + 1)\n        for i in 0..<parents.len:\n            result.add_edge(i+1, parents[i])\n\
    \    proc build*(g: StaticTree) = g.build_impl()\n\n    iterator `[]`*[T](g: WeightedTree[T],\
    \ x: int): (int, T) =\n        for e in g.edges[x]: yield e\n    iterator `[]`*(g:\
    \ UnWeightedTree, x: int): int =\n        for e in g.edges[x]: yield e[0]\n  \
    \  iterator `[]`*[T](g: WeightedStaticTree[T], x: int): (int, T) =\n        g.static_graph_initialized_check()\n\
    \        for i in g.start[x]..<g.start[x+1]: yield g.elist[i]\n    iterator `[]`*(g:\
    \ UnWeightedStaticTree, x: int): int =\n        g.static_graph_initialized_check()\n\
    \        for i in g.start[x]..<g.start[x+1]: yield g.elist[i][0]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/tree.nim
  requiredBy:
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/tree/diameter.nim
  - cplib/tree/diameter.nim
  timestamp: '2024-04-23 22:14:31+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/prufer_abc328e_test.nim
  - verify/tree/prufer_abc328e_test.nim
  - verify/tree/diameter_path_dynamic_test.nim
  - verify/tree/diameter_path_dynamic_test.nim
  - verify/tree/tree_atcoder_test.nim
  - verify/tree/tree_atcoder_test.nim
  - verify/tree/diameter_path_static_test.nim
  - verify/tree/diameter_path_static_test.nim
  - verify/tree/tree_init_by_parent_atcoder_test.nim
  - verify/tree/tree_init_by_parent_atcoder_test.nim
  - verify/tree/diameter_dynamic_test.nim
  - verify/tree/diameter_dynamic_test.nim
  - verify/tree/diameter_static_test.nim
  - verify/tree/diameter_static_test.nim
  - verify/tree/diameter_yosupo_test.nim
  - verify/tree/diameter_yosupo_test.nim
documentation_of: cplib/tree/tree.nim
layout: document
redirect_from:
- /library/cplib/tree/tree.nim
- /library/cplib/tree/tree.nim.html
title: cplib/tree/tree.nim
---
