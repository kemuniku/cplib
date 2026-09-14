---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lowlink_test.nim
    title: verify/AI/lowlink_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/two_edge_connected_components_test.nim
    title: verify/graph/two_edge_connected_components_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/two_edge_connected_components_test.nim
    title: verify/graph/two_edge_connected_components_test.nim
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
  code: "when not declared CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS:\n    const CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/graph/lowlink\n\n    type\
    \ TwoEdgeConnectedComponents* = object\n        groups*: seq[seq[int]]\n     \
    \   component*: seq[int]\n        forest*: UnWeightedUnDirectedGraph\n\n    proc\
    \ initTwoEdgeConnectedComponents*(ll: LowLink): TwoEdgeConnectedComponents =\n\
    \        ## \u8A08\u7B97\u6E08\u307Flowlink\u304B\u3089\u4E8C\u91CD\u8FBA\u9023\
    \u7D50\u6210\u5206\u3068\u6A4B\u3067\u7D50\u3070\u308C\u305F\u7E2E\u7D04\u68EE\
    \u3092O(V)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        result.component\
    \ = newSeq[int](ll.ord.len)\n        for v in ll.preorder:\n            let p\
    \ = ll.parent[v]\n            if p == -1 or ll.low[v] > ll.ord[p]:\n         \
    \       result.component[v] = result.groups.len\n                result.groups.add(@[v])\n\
    \            else:\n                result.component[v] = result.component[p]\n\
    \                result.groups[result.component[v]].add(v)\n        result.forest\
    \ = initUnWeightedUnDirectedGraph(result.groups.len)\n        for (u, v) in ll.bridges:\n\
    \            result.forest.add_edge(result.component[u], result.component[v])\n\
    \n    proc initTwoEdgeConnectedComponents*(g: UnDirectedGraph): TwoEdgeConnectedComponents\
    \ =\n        ## \u7121\u5411\u30B0\u30E9\u30D5\u3092O(V+E)\u6642\u9593\u30FB\u9818\
    \u57DF\u3067\u4E8C\u91CD\u8FBA\u9023\u7D50\u6210\u5206\u306B\u5206\u89E3\u3057\
    \u307E\u3059\u3002\n        result = initTwoEdgeConnectedComponents(initLowLink(g))\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/graph.nim
  - cplib/graph/lowlink.nim
  isVerificationFile: false
  path: cplib/graph/two_edge_connected_components.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/two_edge_connected_components_test.nim
  - verify/graph/two_edge_connected_components_test.nim
  - verify/AI/lowlink_test.nim
  - verify/AI/lowlink_test.nim
documentation_of: cplib/graph/two_edge_connected_components.nim
layout: document
redirect_from:
- /library/cplib/graph/two_edge_connected_components.nim
- /library/cplib/graph/two_edge_connected_components.nim.html
title: cplib/graph/two_edge_connected_components.nim
---
