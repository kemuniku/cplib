---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':x:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':x:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':x:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':x:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_5_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_5_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_5_A\n\
    import cplib/tree/tree\nimport cplib/tree/diameter\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar n = ii()\nvar g = initWeightedStaticTree(n)\nfor i in 0..<n-1:\n\
    \    var a, b, c = ii()\n    g.add_edge(a, b, c)\ng.build\necho g.diameter\n"
  dependsOn:
  - cplib/tree/tree.nim
  - cplib/tree/tree.nim
  - cplib/tree/diameter.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/diameter.nim
  isVerificationFile: true
  path: verify/tree/diameter_static_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/tree/diameter_static_test.nim
layout: document
redirect_from:
- /verify/verify/tree/diameter_static_test.nim
- /verify/verify/tree/diameter_static_test.nim.html
title: verify/tree/diameter_static_test.nim
---
