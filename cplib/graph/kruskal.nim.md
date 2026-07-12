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
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/kruskal_test.nim
    title: verify/AI/kruskal_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/kruskal_test.nim
    title: verify/AI/kruskal_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_KRUSKAL:\n    const CPLIB_GRAPH_KRUSKAL* =\
    \ 1\n    import cplib/graph/graph\n    import algorithm\n    import cplib/collections/unionfind\n\
    \    import cplib/utils/constants\n\n    proc get_MST_cost_impl[T](G: WeightedUnDirectedGraph[T]\
    \ or WeightedUnDirectedStaticGraph[T], ZERO, INF: T): T =\n        ## \u6700\u5C0F\
    \u5168\u57DF\u6728\u306E\u30B3\u30B9\u30C8\u306E\u7DCF\u548C\u3092\u6C42\u3081\
    \u308B\u3002\n        var edges : seq[(T,int,int)]\n        var uf = initUnionFind(len(G))\n\
    \        for i in 0..<len(G):\n            for (j,c) in G[i]:\n              \
    \  if i < j:\n                    edges.add((c,i,j))\n        edges.sort()\n \
    \       result = ZERO\n        for (c,i,j) in edges:\n            if not uf.issame(i,j):\n\
    \                result += c\n                uf.unite(i,j)\n        if uf.count\
    \ != 1:\n            return INF\n\n    proc get_MST_cost*(G: WeightedUnDirectedGraph[int]\
    \ or WeightedUnDirectedStaticGraph[int], ZERO: int = 0, INF: int = INF64): int\
    \ =\n        get_MST_cost_impl(G, ZERO, INF)\n    proc get_MST_cost*(G: WeightedUnDirectedGraph[int32]\
    \ or WeightedUnDirectedStaticGraph[int32], ZERO: int32 = 0.int32, INF: int32 =\
    \ INF32): int32 =\n        get_MST_cost_impl(G, ZERO, INF)\n    proc get_MST_cost*(G:\
    \ WeightedUnDirectedGraph[float] or WeightedUnDirectedStaticGraph[float], ZERO:\
    \ float = 0.0, INF: float = 1e100): float =\n        get_MST_cost_impl(G, ZERO,\
    \ INF)\n    proc get_MST_cost*(G: WeightedUnDirectedGraph[float32] or WeightedUnDirectedStaticGraph[float32],\
    \ ZERO: float32 = 0.0'f32, INF: float32 = 1e30'f32): float32 =\n        get_MST_cost_impl(G,\
    \ ZERO, INF)\n    proc get_MST_cost*[T](G: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T],\
    \ ZERO, INF: T): T =\n        get_MST_cost_impl(G, ZERO, INF)\n\n    proc to_MST_Graph*[T](G:\
    \ WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T]): WeightedUnDirectedGraph[T]\
    \ =\n        ## \u6700\u5C0F\u5168\u57DF\u6728\u3092\u53D6\u3063\u305F\u3068\u304D\
    \u306E\u30B0\u30E9\u30D5\u3092\u8FD4\u3059\n        var edges : seq[(T,int,int)]\n\
    \        var uf = initUnionFind(len(G))\n        for i in 0..<len(G):\n      \
    \      for (j,c) in G[i]:\n                if i < j:\n                    edges.add((c,i,j))\n\
    \        edges.sort()\n        result = initWeightedUnDirectedGraph(len(G), T)\n\
    \        for (c,i,j) in edges:\n            if not uf.issame(i,j):\n         \
    \       result.add_edge(i,j,c)\n                uf.unite(i,j)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/collections/unionfind.nim
  - cplib/collections/unionfind.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/kruskal.nim
  requiredBy: []
  timestamp: '2026-07-09 07:24:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/kruskal_test.nim
  - verify/AI/kruskal_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
documentation_of: cplib/graph/kruskal.nim
layout: document
redirect_from:
- /library/cplib/graph/kruskal.nim
- /library/cplib/graph/kruskal.nim.html
title: cplib/graph/kruskal.nim
---
