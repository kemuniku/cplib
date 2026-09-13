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
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/count_topologicalsort_test.nim
    title: verify/AI/count_topologicalsort_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/count_topologicalsort_test.nim
    title: verify/AI/count_topologicalsort_test.nim
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
  code: "when not declared CPLIB_GRAPH_COUNT_TOPOLOGICALSORT:\n    const CPLIB_GRAPH_COUNT_TOPOLOGICALSORT*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/graph/topologicalsort\n\n\
    \    proc count_topologicalsort*(G: DirectedGraph): int64 =\n        ## \u30C8\
    \u30DD\u30ED\u30B8\u30AB\u30EB\u9806\u5E8F\u306E\u500B\u6570\u3092\u8FD4\u3059\
    \u3002\u6642\u9593 O(V * 2^V + E)\u3001\u7A7A\u9593 O(2^V + V)\u3002\n       \
    \ ## \u7A7A\u30B0\u30E9\u30D5\u306F1\u3001\u9589\u8DEF\u3092\u542B\u3080\u5834\
    \u5408\u306F0\u3002\u591A\u91CD\u8FBA\u306F\u540C\u3058\u5236\u7D04\u3068\u3057\
    \u3066\u6271\u3044\u3001\u91CD\u307F\u306F\u7121\u8996\u3059\u308B\u3002\n   \
    \     ## \u9759\u7684\u30B0\u30E9\u30D5\u306F\u4E8B\u524D\u306Bbuild\u304C\u5FC5\
    \u8981\u3002\u9802\u70B9\u6570\u306F20\u7A0B\u5EA6\u307E\u3067\u3092\u60F3\u5B9A\
    \u3059\u308B\u3002\n        ## V < sizeof(int) * 8 - 1 \u304B\u3064\u7B54\u3048\
    \u304Cint64\u306B\u53CE\u307E\u308B\u3053\u3068\u304C\u5FC5\u8981\uFF08V <= 20\u306A\
    \u3089\u53CE\u307E\u308B\uFF09\u3002\n        let n = G.len\n        assert n\
    \ < sizeof(int) * 8 - 1\n        if not G.isDAG():\n            return 0\n   \
    \     var predecessors = newSeq[int](n)\n        for u in 0..<n:\n           \
    \ for (v, _) in G.to_and_cost(u):\n                predecessors[v] = predecessors[v]\
    \ or (1 shl u)\n        let size = 1 shl n\n        var dp = newSeq[int64](size)\n\
    \        dp[0] = 1\n        for mask in 0..<size:\n            if dp[mask] ==\
    \ 0:\n                continue\n            for v in 0..<n:\n                let\
    \ bit = 1 shl v\n                if (mask and bit) == 0 and (mask and predecessors[v])\
    \ == predecessors[v]:\n                    dp[mask or bit] += dp[mask]\n     \
    \   return dp[^1]\n"
  dependsOn:
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  isVerificationFile: false
  path: cplib/graph/count_topologicalsort.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/count_topologicalsort_test.nim
  - verify/AI/count_topologicalsort_test.nim
documentation_of: cplib/graph/count_topologicalsort.nim
layout: document
redirect_from:
- /library/cplib/graph/count_topologicalsort.nim
- /library/cplib/graph/count_topologicalsort.nim.html
title: cplib/graph/count_topologicalsort.nim
---
