---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
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
    path: verify/AI/round_square_tree_test.nim
    title: verify/AI/round_square_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/round_square_tree_test.nim
    title: verify/AI/round_square_tree_test.nim
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
  code: "when not declared CPLIB_GRAPH_ROUND_SQUARE_TREE:\n    const CPLIB_GRAPH_ROUND_SQUARE_TREE*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/graph/biconnected_components\n\
    \n    proc initRoundSquareTree*(bc: BiconnectedComponents): UnWeightedUnDirectedGraph\
    \ =\n        ## RoundSquareTree\u3092\u69CB\u7BC9 O(V) \u68EE\u3092\u8FD4\u3059\
    \n        ## \u30B0\u30E9\u30D5\u4E0A\u306B\u3042\u3063\u305F\u9802\u70B9\u306E\
    \u756A\u53F7\u306F\u305D\u306E\u307E\u307E\u3001round\u30CE\u30FC\u30C9\u306F\
    n\u59CB\u307E\u308A\n        ## \u96A3\u63A5\u3059\u308B\u306E\u306F\u5FC5\u305A\
    \u56DB\u89D2\u3068\u4E38\u30CE\u30FC\u30C9\n        let n = bc.belong.len\n  \
    \      result = initUnWeightedUnDirectedGraph(n + bc.groups.len)\n        for\
    \ i, group in bc.groups:\n            for v in group:\n                result.add_edge(v,\
    \ n + i)\n\n    proc initRoundSquareTree*(g: UnDirectedGraph): UnWeightedUnDirectedGraph\
    \ =\n        ## \u7121\u5411\u30B0\u30E9\u30D5\u306E\u5186\u65B9\u6728\u3092O(V+E)\u6642\
    \u9593\u30FB\u9818\u57DF\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\u81EA\u5DF1\
    \u30EB\u30FC\u30D7\u3068\u91CD\u307F\u306F\u7121\u8996\u3057\u307E\u3059\u3002\
    \n        ## \u9759\u7684\u30B0\u30E9\u30D5\u306Fbuild\u6E08\u307F\u3068\u3057\
    \u307E\u3059\u3002\u6210\u5206\u5206\u89E3\u306F\u975E\u518D\u5E30\u3067\u3059\
    \u3002\n        result = initRoundSquareTree(initBiconnectedComponents(g))\n"
  dependsOn:
  - cplib/graph/biconnected_components.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/biconnected_components.nim
  isVerificationFile: false
  path: cplib/graph/round_square_tree.nim
  requiredBy: []
  timestamp: '2026-09-14 10:23:34+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/round_square_tree_test.nim
  - verify/AI/round_square_tree_test.nim
documentation_of: cplib/graph/round_square_tree.nim
layout: document
redirect_from:
- /library/cplib/graph/round_square_tree.nim
- /library/cplib/graph/round_square_tree.nim.html
title: cplib/graph/round_square_tree.nim
---
