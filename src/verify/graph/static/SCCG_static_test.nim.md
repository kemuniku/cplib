---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc296/tasks/abc296_e
    links:
    - https://atcoder.jp/contests/abc296/tasks/abc296_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc296/tasks/abc296_e\n\
    import cplib/graph/graph\nimport cplib/graph/SCC\nimport sequtils, math\nproc\
    \ scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nvar N = ii()\nvar A = newseqwith(N,\
    \ ii())\nvar G = initUnWeightedDirectedStaticGraph(N)\nvar ans = 0\nfor i in 0..<N:\n\
    \    G.add_edge(i, A[i]-1)\n    if i == A[i]-1:\n        ans += 1\nG.build()\n\
    var (_, _, group) = G.SCCG()\necho group.mapit(len(it)).filterIt(it >= 2).sum()+ans\n"
  dependsOn:
  - cplib/graph/SCC.nim
  - cplib/graph/SCC.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/static/SCCG_static_test.nim
  requiredBy: []
  timestamp: '2024-04-08 19:13:57+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/static/SCCG_static_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/SCCG_static_test.nim
- /verify/verify/graph/static/SCCG_static_test.nim.html
title: verify/graph/static/SCCG_static_test.nim
---
