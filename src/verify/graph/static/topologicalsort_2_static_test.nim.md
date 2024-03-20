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
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc245/tasks/abc245_f
    links:
    - https://atcoder.jp/contests/abc245/tasks/abc245_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc245/tasks/abc245_f\n\
    import cplib/graph/graph\nimport cplib/graph/topologicalsort\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\nvar N, M = ii()\nvar G = initUnWeightedDirectedStaticGraph(N)\n\
    for i in 0..<M:\n    var U, V = ii()-1\n    G.add_edge(V, U)\nG.build()\necho\
    \ N-len(G.topologicalsort())\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  isVerificationFile: true
  path: verify/graph/static/topologicalsort_2_static_test.nim
  requiredBy: []
  timestamp: '2024-02-14 18:36:42+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/static/topologicalsort_2_static_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/topologicalsort_2_static_test.nim
- /verify/verify/graph/static/topologicalsort_2_static_test.nim.html
title: verify/graph/static/topologicalsort_2_static_test.nim
---
