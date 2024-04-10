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
    path: cplib/graph/grid_to_graph.nim
    title: cplib/graph/grid_to_graph.nim
  - icon: ':x:'
    path: cplib/graph/grid_to_graph.nim
    title: cplib/graph/grid_to_graph.nim
  - icon: ':question:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':question:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':question:'
    path: cplib/utils/infl.nim
    title: cplib/utils/infl.nim
  - icon: ':question:'
    path: cplib/utils/infl.nim
    title: cplib/utils/infl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc151/tasks/abc151_d
    links:
    - https://atcoder.jp/contests/abc151/tasks/abc151_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_d\n\
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/grid_to_graph\n\
    import cplib/graph/maxk_dijkstra\nimport cplib/utils/infl\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar h, w = ii()\nvar g = newSeqWith(h, stdin.readLine).grid_to_graph('.',\
    \ false)\nvar ans = 0\nfor sx in 0..<h:\n    for sy in 0..<w:\n        var d =\
    \ g.maxk_dijkstra(sx*w+sy, 1).mapIt(if it == INFL: -1 else: it)\n        ans =\
    \ max(ans, d.max)\necho ans\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/utils/infl.nim
  - cplib/graph/grid_to_graph.nim
  - cplib/graph/grid_to_graph.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/utils/infl.nim
  - cplib/graph/maxk_dijkstra.nim
  isVerificationFile: true
  path: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
  requiredBy: []
  timestamp: '2024-04-11 04:28:13+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dynamic/grid_to_graph_abc151d_test.nim
- /verify/verify/graph/dynamic/grid_to_graph_abc151d_test.nim.html
title: verify/graph/dynamic/grid_to_graph_abc151d_test.nim
---
