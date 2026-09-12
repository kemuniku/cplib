---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/mincostflow.nim
    title: cplib/graph/mincostflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/mincostflow.nim
    title: cplib/graph/mincostflow.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_B\n\
    import cplib/graph/mincostflow\nimport strutils, sequtils\nlet nmf = stdin.readLine.split.map(parseInt)\n\
    var g = initMinCostFlow[int, int64](nmf[0])\nfor i in 0..<nmf[1]:\n    let e =\
    \ stdin.readLine.split.map(parseInt)\n    g.add_edge(e[0], e[1], e[2], int64(e[3]))\n\
    let answer = g.flow(0, nmf[0] - 1, nmf[2])\nif answer.flow == nmf[2]:\n    echo\
    \ answer.cost\nelse:\n    echo -1\n"
  dependsOn:
  - cplib/graph/mincostflow.nim
  - cplib/graph/mincostflow.nim
  isVerificationFile: true
  path: verify/graph/mincostflow_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:53:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/mincostflow_test.nim
layout: document
redirect_from:
- /verify/verify/graph/mincostflow_test.nim
- /verify/verify/graph/mincostflow_test.nim.html
title: verify/graph/mincostflow_test.nim
---
