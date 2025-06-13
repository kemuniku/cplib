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
  - icon: ':warning:'
    path: cplib/graph/dag_minimum_path_cover.nim
    title: cplib/graph/dag_minimum_path_cover.nim
  - icon: ':warning:'
    path: cplib/graph/dag_minimum_path_cover.nim
    title: cplib/graph/dag_minimum_path_cover.nim
  - icon: ':warning:'
    path: verify/graph/dag_minimum_path_cover_hakata_test_.nim
    title: verify/graph/dag_minimum_path_cover_hakata_test_.nim
  - icon: ':warning:'
    path: verify/graph/dag_minimum_path_cover_hakata_test_.nim
    title: verify/graph/dag_minimum_path_cover_hakata_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/topologicalsort_1_test_.nim
    title: verify/graph/dynamic/topologicalsort_1_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/topologicalsort_1_test_.nim
    title: verify/graph/dynamic/topologicalsort_1_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/topologicalsort_2_test_.nim
    title: verify/graph/dynamic/topologicalsort_2_test_.nim
  - icon: ':warning:'
    path: verify/graph/dynamic/topologicalsort_2_test_.nim
    title: verify/graph/dynamic/topologicalsort_2_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/topologicalsort_1_static_test_.nim
    title: verify/graph/static/topologicalsort_1_static_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/topologicalsort_1_static_test_.nim
    title: verify/graph/static/topologicalsort_1_static_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/topologicalsort_2_static_test_.nim
    title: verify/graph/static/topologicalsort_2_static_test_.nim
  - icon: ':warning:'
    path: verify/graph/static/topologicalsort_2_static_test_.nim
    title: verify/graph/static/topologicalsort_2_static_test_.nim
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
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
  requiredBy:
  - verify/graph/dag_minimum_path_cover_hakata_test_.nim
  - verify/graph/dag_minimum_path_cover_hakata_test_.nim
  - verify/graph/static/topologicalsort_2_static_test_.nim
  - verify/graph/static/topologicalsort_2_static_test_.nim
  - verify/graph/static/topologicalsort_1_static_test_.nim
  - verify/graph/static/topologicalsort_1_static_test_.nim
  - verify/graph/dynamic/topologicalsort_2_test_.nim
  - verify/graph/dynamic/topologicalsort_2_test_.nim
  - verify/graph/dynamic/topologicalsort_1_test_.nim
  - verify/graph/dynamic/topologicalsort_1_test_.nim
  - cplib/graph/dag_minimum_path_cover.nim
  - cplib/graph/dag_minimum_path_cover.nim
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/topologicalsort.nim
layout: document
redirect_from:
- /library/cplib/graph/topologicalsort.nim
- /library/cplib/graph/topologicalsort.nim.html
title: cplib/graph/topologicalsort.nim
---
