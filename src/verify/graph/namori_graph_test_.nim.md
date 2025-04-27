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
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc266/tasks/abc266_f
    links:
    - https://atcoder.jp/contests/abc266/tasks/abc266_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc266/tasks/abc266_f\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nimport cplib/utils/constants\n\
    import cplib/graph/graph\nimport cplib/graph/namori_graph\nvar N = ii()\nvar G\
    \ = initUnWeightedUnDirectedGraph(N)\nfor i in 0..<N:\n    var u,v = ii()-1\n\
    \    G.add_edge(u,v)\nvar namori = G.initNamoriGraph()\nvar Q = ii()\nfor i in\
    \ 0..<Q:\n    var x,y = ii()-1\n    var (_,a) = namori.dist(x,y)\n    if a ==\
    \ INF64:\n        echo \"Yes\"\n    else:\n        echo \"No\"\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/namori_graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/namori_graph.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: verify/graph/namori_graph_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:49:49+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/namori_graph_test_.nim
layout: document
redirect_from:
- /library/verify/graph/namori_graph_test_.nim
- /library/verify/graph/namori_graph_test_.nim.html
title: verify/graph/namori_graph_test_.nim
---
