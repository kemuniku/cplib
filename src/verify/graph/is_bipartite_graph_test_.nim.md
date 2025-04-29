---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/graph/bipartite_graph.nim
    title: cplib/graph/bipartite_graph.nim
  - icon: ':warning:'
    path: cplib/graph/bipartite_graph.nim
    title: cplib/graph/bipartite_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc327/tasks/abc327_d
    links:
    - https://atcoder.jp/contests/abc327/tasks/abc327_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc327/tasks/abc327_d\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport cplib/graph/bipartite_graph\n\
    import sequtils\nimport cplib/graph/graph\n\nvar N,M = ii()\nvar A = newseqwith(M,ii())\n\
    var B = newseqwith(M,ii())\nvar G = initUnWeightedUnDirectedGraph(N)\nfor i in\
    \ 0..<(M):\n    G.add_edge(A[i]-1,B[i]-1)\nif G.is_bipartite_graph():\n    echo\
    \ \"Yes\"\nelse:\n    echo \"No\""
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/bipartite_graph.nim
  - cplib/graph/bipartite_graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/graph/is_bipartite_graph_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/is_bipartite_graph_test_.nim
layout: document
redirect_from:
- /library/verify/graph/is_bipartite_graph_test_.nim
- /library/verify/graph/is_bipartite_graph_test_.nim.html
title: verify/graph/is_bipartite_graph_test_.nim
---
