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
    path: cplib/graph/grid_to_graph.nim
    title: cplib/graph/grid_to_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/grid_to_graph.nim
    title: cplib/graph/grid_to_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
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
    PROBLEM: https://atcoder.jp/contests/abc151/tasks/abc151_d
    links:
    - https://atcoder.jp/contests/abc151/tasks/abc151_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_d\n\
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/grid_to_graph\n\
    import cplib/graph/maxk_dijkstra\nimport cplib/utils/constants\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar h, w = ii()\nvar g = newSeqWith(h, stdin.readLine).grid_to_graph('.',\
    \ true)\ng.build\nvar ans = 0\nfor sx in 0..<h:\n    for sy in 0..<w:\n      \
    \  var d = g.maxk_dijkstra(sx*w+sy, 1).mapIt(if it == INF64: -1 else: it)\n  \
    \      ans = max(ans, d.max)\necho ans\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/grid_to_graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/grid_to_graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/graph/static/grid_to_graph_abc151d_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/static/grid_to_graph_abc151d_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/grid_to_graph_abc151d_test.nim
- /verify/verify/graph/static/grid_to_graph_abc151d_test.nim.html
title: verify/graph/static/grid_to_graph_abc151d_test.nim
---
