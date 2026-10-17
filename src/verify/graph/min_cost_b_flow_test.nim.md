---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/min_cost_b_flow.nim
    title: cplib/graph/min_cost_b_flow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/min_cost_b_flow.nim
    title: cplib/graph/min_cost_b_flow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/min_cost_b_flow
    links:
    - https://judge.yosupo.jp/problem/min_cost_b_flow
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/min_cost_b_flow\n\
    import cplib/graph/min_cost_b_flow\nimport cplib/math/int128\nimport strutils,\
    \ sequtils\n\nlet nm = stdin.readLine.split.map(parseInt)\nvar g = initMinCostBFlow(nm[0])\n\
    for v in 0..<nm[0]:\n    g.add_supply(v, parseBiggestInt(stdin.readLine))\nfor\
    \ i in 0..<nm[1]:\n    let e = stdin.readLine.split.map(parseBiggestInt)\n   \
    \ g.add_edge(int(e[0]), int(e[1]), e[2], e[3], e[4])\nlet answer = g.solve()\n\
    if not answer.feasible:\n    echo \"infeasible\"\nelse:\n    echo answer.cost\n\
    \    for p in g.get_potential():\n        echo p\n    for e in g.get_edges():\n\
    \        echo e.flow\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/graph/min_cost_b_flow.nim
  - cplib/graph/min_cost_b_flow.nim
  isVerificationFile: true
  path: verify/graph/min_cost_b_flow_test.nim
  requiredBy: []
  timestamp: '2026-10-03 01:29:57+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/min_cost_b_flow_test.nim
layout: document
redirect_from:
- /verify/verify/graph/min_cost_b_flow_test.nim
- /verify/verify/graph/min_cost_b_flow_test.nim.html
title: verify/graph/min_cost_b_flow_test.nim
---
