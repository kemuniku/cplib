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
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/GRL_3_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/GRL_3_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/GRL_3_B\n\
    import algorithm\nimport cplib/graph/graph\nimport cplib/graph/lowlink\ninclude\
    \ cplib/tmpl/fastio\n\nlet n = ii()\nlet m = ii()\nvar g = initUnWeightedUnDirectedGraph(n)\n\
    for i in 0..<m:\n    let u = ii()\n    let v = ii()\n    g.add_edge(u, v)\nlet\
    \ ll = initLowLink(g)\nvar bridges: seq[(int, int)]\nfor (u, v) in ll.bridges:\
    \ bridges.add((min(u, v), max(u, v)))\nbridges.sort()\nfor (u, v) in bridges:\
    \ echo u, \" \", v\n"
  dependsOn:
  - cplib/graph/lowlink.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/lowlink_bridges_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/lowlink_bridges_test.nim
layout: document
redirect_from:
- /verify/verify/graph/lowlink_bridges_test.nim
- /verify/verify/graph/lowlink_bridges_test.nim.html
title: verify/graph/lowlink_bridges_test.nim
---
