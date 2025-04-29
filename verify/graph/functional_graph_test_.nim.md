---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':warning:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc357/tasks/abc357_e
    links:
    - https://atcoder.jp/contests/abc357/tasks/abc357_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc357/tasks/abc357_e\n\
    import cplib/graph/graph\nimport sequtils\nimport cplib/graph/functional_graph\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar N = ii()\nvar A = newseqwith(N,ii()).mapit(it-1)\n\
    var G = initUnWeightedDirectedGraph(N)\nfor i in 0..<N:\n    G.add_edge(i,A[i])\n\
    var f = G.initFunctionalGraph()\nvar ans = 0\nfor i in 0..<N:\n    ans += f.cycle_size(i)\
    \ + f.depth(i)\necho ans\n"
  dependsOn:
  - cplib/graph/functional_graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/graph/functional_graph_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/functional_graph_test_.nim
layout: document
redirect_from:
- /library/verify/graph/functional_graph_test_.nim
- /library/verify/graph/functional_graph_test_.nim.html
title: verify/graph/functional_graph_test_.nim
---
