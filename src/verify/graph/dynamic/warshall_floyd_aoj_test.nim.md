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
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd.nim
    title: cplib/graph/warshall_floyd.nim
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/1/GRL_1_C
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/1/GRL_1_C
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/5/GRL/1/GRL_1_C\n\
    import sequtils, strutils\nimport cplib/graph/graph\nimport cplib/graph/warshall_floyd\n\
    import cplib/utils/constants\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar\
    \ n, m = ii()\nvar g = initWeightedDirectedGraph(n, int)\nfor i in 0..<m:\n  \
    \  var u, v, c = ii()\n    g.add_edge(u, v, c)\nvar (negative_cycle, d) = g.warshall_floyd\n\
    if negative_cycle:\n    echo \"NEGATIVE CYCLE\"\n    quit()\nfor i in 0..<n:\n\
    \    var d = d[i].mapIt(if it == INF64: \"INF\" else: ($it)).join(\" \")\n   \
    \ echo d\n"
  dependsOn:
  - cplib/graph/warshall_floyd.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd.nim
  isVerificationFile: true
  path: verify/graph/dynamic/warshall_floyd_aoj_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dynamic/warshall_floyd_aoj_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dynamic/warshall_floyd_aoj_test.nim
- /verify/verify/graph/dynamic/warshall_floyd_aoj_test.nim.html
title: verify/graph/dynamic/warshall_floyd_aoj_test.nim
---
