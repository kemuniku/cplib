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
    path: verify/graph/dynamic/topologicalsort_1_test.nim
    title: verify/graph/dynamic/topologicalsort_1_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/topologicalsort_1_test.nim
    title: verify/graph/dynamic/topologicalsort_1_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/topologicalsort_2_test.nim
    title: verify/graph/dynamic/topologicalsort_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/topologicalsort_2_test.nim
    title: verify/graph/dynamic/topologicalsort_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/topologicalsort_1_static_test.nim
    title: verify/graph/static/topologicalsort_1_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/topologicalsort_1_static_test.nim
    title: verify/graph/static/topologicalsort_1_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/topologicalsort_2_static_test.nim
    title: verify/graph/static/topologicalsort_2_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/topologicalsort_2_static_test.nim
    title: verify/graph/static/topologicalsort_2_static_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_TOPOLOGICALSORT:\n    const CPLIB_GRAPH_TOPOLOGICALSORT*\
    \ = 1\n    import cplib/graph/graph\n    proc topologicalsort*(G: DirectedGraph):\
    \ seq[int] =\n        var gin = newseq[int](len(G))\n        for i in 0..<len(G):\n\
    \            for (j, _) in G.to_and_cost(i):\n                gin[j] += 1\n  \
    \      var stack: seq[int]\n        for i in 0..<len(G):\n            if gin[i]\
    \ == 0:\n                stack.add(i)\n        while len(stack) != 0:\n      \
    \      var i = stack.pop()\n            result.add(i)\n            for j in G[i]:\n\
    \                gin[j] -= 1\n                if gin[j] == 0:\n              \
    \      stack.add(j)\n    proc isDAG*(G: DirectedGraph): bool = G.topologicalsort.len\
    \ == G.len\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/topologicalsort.nim
  requiredBy: []
  timestamp: '2024-03-22 18:42:41+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/dynamic/topologicalsort_2_test.nim
  - verify/graph/dynamic/topologicalsort_2_test.nim
  - verify/graph/dynamic/topologicalsort_1_test.nim
  - verify/graph/dynamic/topologicalsort_1_test.nim
  - verify/graph/static/topologicalsort_1_static_test.nim
  - verify/graph/static/topologicalsort_1_static_test.nim
  - verify/graph/static/topologicalsort_2_static_test.nim
  - verify/graph/static/topologicalsort_2_static_test.nim
documentation_of: cplib/graph/topologicalsort.nim
layout: document
redirect_from:
- /library/cplib/graph/topologicalsort.nim
- /library/cplib/graph/topologicalsort.nim.html
title: cplib/graph/topologicalsort.nim
---
