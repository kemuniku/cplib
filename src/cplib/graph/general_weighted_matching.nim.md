---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/internal/weighted_matching_engine.nim
    title: cplib/graph/internal/weighted_matching_engine.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/internal/weighted_matching_engine.nim
    title: cplib/graph/internal/weighted_matching_engine.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_sparse_test.nim
    title: verify/AI/general_weighted_matching_sparse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_sparse_test.nim
    title: verify/AI/general_weighted_matching_sparse_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_test.nim
    title: verify/AI/general_weighted_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/general_weighted_matching_test.nim
    title: verify/AI/general_weighted_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_weighted_matching_test.nim
    title: verify/graph/general_weighted_matching_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/general_weighted_matching_test.nim
    title: verify/graph/general_weighted_matching_test.nim
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
  code: "## \u4E00\u822C\u7121\u5411\u30B0\u30E9\u30D5\u306E\u6700\u5927\u91CD\u307F\
    \u30DE\u30C3\u30C1\u30F3\u30B0\u3002\u8A2D\u8A08\u306E\u8AAC\u660E\u306Fgeneral_weighted_matching.md\u3092\
    \u53C2\u7167\u3002\nwhen not declared CPLIB_GRAPH_GENERAL_WEIGHTED_MATCHING:\n\
    \    const CPLIB_GRAPH_GENERAL_WEIGHTED_MATCHING* = 1\n    import cplib/graph/graph\n\
    \    import cplib/graph/internal/weighted_matching_engine\n\n    proc maximum_weight_matching*[T:\
    \ SomeSignedInt](g: WeightedUnDirectedGraph[T] or WeightedUnDirectedStaticGraph[T]):\
    \ tuple[weight: int64, matching: seq[tuple[u, v: int]]] =\n        ## \u6700\u5927\
    \u91CD\u307F\u3068\u3001\u305D\u308C\u3092\u9054\u6210\u3059\u308B\u9802\u70B9\
    \u30DA\u30A2\u5217\uFF08u < v\uFF09\u3092\u8FD4\u3059\u3002\u6642\u9593O(V+E+K^3)\u3001\
    \u8FFD\u52A0\u9818\u57DFO(V+K^2)\u3002\n        ## K\u306F\u6B63\u306E\u975E\u30EB\
    \u30FC\u30D7\u8FBA\u306B\u63A5\u3059\u308B\u9802\u70B9\u6570\u3001M\u306F\u591A\
    \u91CD\u8FBA\u3092\u307E\u3068\u3081\u305F\u5F8C\u306E\u6B63\u306E\u975E\u30EB\
    \u30FC\u30D7\u8FBA\u6570\u3002\n        ## \u8FBA\u6570\u306E\u6700\u5927\u5316\
    \u306F\u4FDD\u8A3C\u3057\u306A\u3044\u3002\u81EA\u5DF1\u30EB\u30FC\u30D7\u3068\
    \u91CD\u307F0\u4EE5\u4E0B\u306E\u8FBA\u306F\u7121\u8996\u3057\u3001\u591A\u91CD\
    \u8FBA\u306F\u6700\u5927\u91CD\u307F\u3092\u4F7F\u3046\u3002\n        ## \u91CD\
    \u307F\u306F\u7B26\u53F7\u4ED8\u304D\u6574\u6570\u578B\u3067\u3001\u7DCF\u548C\
    \u306Fint64\u3002K>0\u306E\u3068\u304D\u6700\u5927\u6B63\u91CD\u307FW\u306Fhigh(int64)\
    \ div (4*K)\u4EE5\u4E0B\u3068\u3059\u308B\u3002\n        ## \u5165\u529B\u306F\
    \u5909\u66F4\u3057\u306A\u3044\u3002\u9759\u7684\u30B0\u30E9\u30D5\u306Fbuild()\u304C\
    \u5FC5\u8981\u3002\n        g.independentWeightedMatching(false)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/internal/weighted_matching_engine.nim
  - cplib/graph/graph.nim
  - cplib/graph/internal/weighted_matching_engine.nim
  isVerificationFile: false
  path: cplib/graph/general_weighted_matching.nim
  requiredBy: []
  timestamp: '2026-09-29 03:00:17+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/general_weighted_matching_test.nim
  - verify/graph/general_weighted_matching_test.nim
  - verify/AI/general_weighted_matching_sparse_test.nim
  - verify/AI/general_weighted_matching_sparse_test.nim
  - verify/AI/general_weighted_matching_test.nim
  - verify/AI/general_weighted_matching_test.nim
documentation_of: cplib/graph/general_weighted_matching.nim
layout: document
redirect_from:
- /library/cplib/graph/general_weighted_matching.nim
- /library/cplib/graph/general_weighted_matching.nim.html
title: cplib/graph/general_weighted_matching.nim
---
