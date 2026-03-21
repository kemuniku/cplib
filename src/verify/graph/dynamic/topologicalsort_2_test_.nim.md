---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':warning:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':warning:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc245/tasks/abc245_f
    links:
    - https://atcoder.jp/contests/abc245/tasks/abc245_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc245/tasks/abc245_f\n\
    import cplib/graph/graph\nimport cplib/graph/topologicalsort\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\nvar N, M = ii()\nvar G = initUnWeightedDirectedGraph(N)\n\
    for i in 0..<M:\n    var U, V = ii()-1\n    G.add_edge(V, U)\necho N-len(G.topologicalsort())\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/graph/dynamic/topologicalsort_2_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/dynamic/topologicalsort_2_test_.nim
layout: document
redirect_from:
- /library/verify/graph/dynamic/topologicalsort_2_test_.nim
- /library/verify/graph/dynamic/topologicalsort_2_test_.nim.html
title: verify/graph/dynamic/topologicalsort_2_test_.nim
---
