---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/cycle_detection.nim
    title: cplib/graph/cycle_detection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/cycle_detection.nim
    title: cplib/graph/cycle_detection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/cycle_detection
    links:
    - https://judge.yosupo.jp/problem/cycle_detection
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/cycle_detection\n\
    import cplib/graph/graph\nimport cplib/graph/cycle_detection\ninclude cplib/tmpl/fastio\n\
    \nlet n = ii()\nlet m = ii()\nvar g = initUnWeightedDirectedGraph(n)\nfor i in\
    \ 0..<m:\n    let u = ii()\n    let v = ii()\n    g.add_edge(u, v)\nlet cycle\
    \ = g.cycle_detection()\nif cycle.len == 0:\n    echo -1\nelse:\n    echo cycle.len\n\
    \    for id in cycle: echo id\n"
  dependsOn:
  - cplib/graph/cycle_detection.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/cycle_detection.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/graph/cycle_detection_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/cycle_detection_test.nim
layout: document
redirect_from:
- /verify/verify/graph/cycle_detection_test.nim
- /verify/verify/graph/cycle_detection_test.nim.html
title: verify/graph/cycle_detection_test.nim
---
