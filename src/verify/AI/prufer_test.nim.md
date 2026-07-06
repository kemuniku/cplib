---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport sequtils\nimport cplib/graph/graph\nimport cplib/tree/prufer\n\
    \nlet g = prufer_decode(@[1, 1])\nassert g.len == 4\nvar edges: seq[(int, int)]\n\
    for i in 0..<g.len:\n  for j in g[i]:\n    if i < j:\n      edges.add((i, j))\n\
    assert edges == @[(0, 1), (1, 2), (1, 3)]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/prufer_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/prufer_test.nim
layout: document
redirect_from:
- /verify/verify/AI/prufer_test.nim
- /verify/verify/AI/prufer_test.nim.html
title: verify/AI/prufer_test.nim
---
