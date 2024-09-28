---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/bellmanford.nim
    title: cplib/graph/bellmanford.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_1_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_1_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/all/GRL_1_B\n\
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/bellmanford\nimport\
    \ cplib/utils/constants\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar\
    \ v, e, r = ii()\nvar g = initWeightedDirectedStaticGraph(v, int)\nfor i in 0..<e:\n\
    \    var s, t, d = ii()\n    g.add_edge(s, t, d)\ng.build\nvar cost = bellmanford(g,\
    \ r)\nif cost.min == -INF64:\n    echo \"NEGATIVE CYCLE\"\nelse:\n    for i in\
    \ 0..<v:\n        if cost[i] == INF64: echo \"INF\"\n        else: echo cost[i]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/bellmanford.nim
  - cplib/graph/bellmanford.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/graph/static/bellmanford_grl1b_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/static/bellmanford_grl1b_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/bellmanford_grl1b_test.nim
- /verify/verify/graph/static/bellmanford_grl1b_test.nim.html
title: verify/graph/static/bellmanford_grl1b_test.nim
---
