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
    PROBLEM: https://atcoder.jp/contests/abc176/tasks/abc176_d
    links:
    - https://atcoder.jp/contests/abc176/tasks/abc176_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc176/tasks/abc176_d\n\
    import sequtils\nimport cplib/graph/graph\nimport cplib/graph/maxk_dijkstra\n\
    import cplib/utils/constants\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar\
    \ h, w = ii()\nvar sx, sy, tx, ty = ii() - 1\nvar g = initWeightedDirectedGraph(h*w,\
    \ int32)\nvar s = newSeqWith(h, stdin.readLine).mapIt(it.mapit(it == '.'))\nvar\
    \ dxy = [(-1, 0), (1, 0), (0, -1), (0, 1)]\nfor i in 0..<h:\n    for j in 0..<w:\n\
    \        for (dx, dy) in dxy:\n            if i+dx notin 0..<h or j+dy notin 0..<w\
    \ or not s[i+dx][j+dy]: continue\n            g.add_edge(i*w+j, (i+dx)*w+j+dy,\
    \ 0i32)\n        for dx in -2..2:\n            for dy in -2..2:\n            \
    \    if abs(dx) + abs(dy) <= 1: continue\n                if i+dx notin 0..<h\
    \ or j+dy notin 0..<w or not s[i+dx][j+dy]: continue\n                g.add_edge(i*w+j,\
    \ (i+dx)*w+j+dy, 1i32)\nvar d = g.maxk_dijkstra(sx*w+sy, 1i32)\nvar ans = d[tx*w+ty]\n\
    if ans == INF32: ans = -1\necho ans\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  isVerificationFile: true
  path: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
- /verify/verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim.html
title: verify/graph/dynamic/maxk_dijkstra_abc176d_test.nim
---
