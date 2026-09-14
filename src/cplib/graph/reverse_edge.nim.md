---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_edge_id_test.nim
    title: verify/AI/graph_edge_id_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_edge_id_test.nim
    title: verify/AI/graph_edge_id_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/reverse_edge_test.nim
    title: verify/AI/reverse_edge_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/reverse_edge_test.nim
    title: verify/AI/reverse_edge_test.nim
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
  code: "when not declared CPLIB_GRAPH_REVERSE_EDGE:\n    const CPLIB_GRAPH_REVERSE_EDGE*\
    \ = 1\n    import cplib/graph/graph\n\n    proc reverse_edge*[T](g: WeightedDirectedGraph[T]):\
    \ WeightedDirectedGraph[T] =\n        ## \u8FBA\u756A\u53F7\u3092\u7DAD\u6301\u3057\
    \u3066\u5168\u8FBA\u306E\u5411\u304D\u3092\u53CD\u8EE2\u3059\u308B\u3002O(V +\
    \ E)\u3002\n        result = initWeightedDirectedGraph(g.len, T)\n        for\
    \ e in g.edge_info:\n            result.add_edge(e.dst, e.src, e.cost)\n\n   \
    \ proc reverse_edge*(g: UnWeightedDirectedGraph): UnWeightedDirectedGraph =\n\
    \        ## \u8FBA\u756A\u53F7\u3092\u7DAD\u6301\u3057\u3066\u5168\u8FBA\u306E\
    \u5411\u304D\u3092\u53CD\u8EE2\u3059\u308B\u3002O(V + E)\u3002\n        result\
    \ = initUnWeightedDirectedGraph(g.len)\n        for e in g.edge_info:\n      \
    \      result.add_edge(e.dst, e.src)\n\n    proc reverse_edge*[T](g: WeightedDirectedStaticGraph[T]):\
    \ WeightedDirectedStaticGraph[T] =\n        ## \u8FBA\u756A\u53F7\u3092\u7DAD\u6301\
    \u3057\u3066\u5168\u8FBA\u306E\u5411\u304D\u3092\u53CD\u8EE2\u3059\u308B\u3002\
    O(V + E)\u3002\n        result = initWeightedDirectedStaticGraph(g.len, T)\n \
    \       for e in g.edge_info:\n            result.add_edge(e.dst, e.src, e.cost)\n\
    \        result.build()\n\n    proc reverse_edge*(g: UnWeightedDirectedStaticGraph):\
    \ UnWeightedDirectedStaticGraph =\n        ## \u8FBA\u756A\u53F7\u3092\u7DAD\u6301\
    \u3057\u3066\u5168\u8FBA\u306E\u5411\u304D\u3092\u53CD\u8EE2\u3059\u308B\u3002\
    O(V + E)\u3002\n        result = initUnWeightedDirectedStaticGraph(g.len)\n  \
    \      for e in g.edge_info:\n            result.add_edge(e.dst, e.src)\n    \
    \    result.build()\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/reverse_edge.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/graph_edge_id_test.nim
  - verify/AI/graph_edge_id_test.nim
  - verify/AI/reverse_edge_test.nim
  - verify/AI/reverse_edge_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
documentation_of: cplib/graph/reverse_edge.nim
layout: document
redirect_from:
- /library/cplib/graph/reverse_edge.nim
- /library/cplib/graph/reverse_edge.nim.html
title: cplib/graph/reverse_edge.nim
---
