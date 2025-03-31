---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':warning:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
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
    PROBLEM: https://atcoder.jp/contests/abc296/tasks/abc296_e
    links:
    - https://atcoder.jp/contests/abc296/tasks/abc296_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc296/tasks/abc296_e\n\
    import cplib/graph/graph\nimport cplib/graph/SCC\nimport sequtils, math\nproc\
    \ scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nvar N = ii()\nvar A = newseqwith(N,\
    \ ii())\nvar G = initUnWeightedDirectedGraph(N)\nvar ans = 0\nfor i in 0..<N:\n\
    \    G.add_edge(i, A[i]-1)\n    if i == A[i]-1:\n        ans += 1\nvar group =\
    \ G.SCC()\necho group.mapit(len(it)).filterIt(it >= 2).sum()+ans\n"
  dependsOn:
  - cplib/graph/SCC.nim
  - cplib/graph/graph.nim
  - cplib/graph/SCC.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/graph/dynamic/SCC_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/dynamic/SCC_test_.nim
layout: document
redirect_from:
- /library/verify/graph/dynamic/SCC_test_.nim
- /library/verify/graph/dynamic/SCC_test_.nim.html
title: verify/graph/dynamic/SCC_test_.nim
---
