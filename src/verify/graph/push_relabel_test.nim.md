---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/push_relabel.nim
    title: cplib/graph/push_relabel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/push_relabel.nim
    title: cplib/graph/push_relabel.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_6_A\n\
    import cplib/graph/push_relabel\nimport strutils, sequtils\n\nlet nm = stdin.readLine.split.map(parseInt)\n\
    var g = initPushRelabel[int](nm[0])\nfor i in 0..<nm[1]:\n    let e = stdin.readLine.split.map(parseInt)\n\
    \    g.add_edge(e[0], e[1], e[2])\necho g.flow(0, nm[0] - 1)\n"
  dependsOn:
  - cplib/graph/push_relabel.nim
  - cplib/graph/push_relabel.nim
  isVerificationFile: true
  path: verify/graph/push_relabel_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/push_relabel_test.nim
layout: document
redirect_from:
- /verify/verify/graph/push_relabel_test.nim
- /verify/verify/graph/push_relabel_test.nim.html
title: verify/graph/push_relabel_test.nim
---
