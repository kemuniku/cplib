---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_dijkstra.nim
    title: cplib/utils/implicit_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/implicit_dijkstra.nim
    title: cplib/utils/implicit_dijkstra.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/shortest_path
    links:
    - https://judge.yosupo.jp/problem/shortest_path
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/shortest_path\n\
    include cplib/tmpl/sheep\nimport cplib/utils/implicit_dijkstra\n\nvar N, M, s,\
    \ t = ii()\nvar edges = newSeq[seq[(int, int)]](N)\nvar starts = @[s]\nvar goals\
    \ = @[t]\nfor i in 0..<M:\n    var a, b, c = ii()\n    edges[a].add((b, c))\n\
    \    if a == s and c == 0:\n        starts.add(b)\n    if b == t and c == 0:\n\
    \        goals.add(a)\n\nlet adjacent: ImplicitDijkstraAdjacent[int] = proc(v:\
    \ int): seq[(int, int)] = edges[v]\n# s \u304B\u3089\uFF0Ft \u3078\u306E\u91CD\
    \u307F 0 \u306E\u8FBA\u3067\u59CB\u7D42\u70B9\u3092\u62E1\u5F35\u3057\u3001\u8FD4\
    \u308B\u7D4C\u8DEF\u306B\u305D\u306E\u8FBA\u3092\u88DC\u3046\u3002\nvar (path,\
    \ cost) = shortest_path_implicit_dijkstra(starts, goals, adjacent)\nif path.len\
    \ == 0:\n    echo -1\nelse:\n    if path[0] != s:\n        path.insert(s, 0)\n\
    \    if path[^1] != t:\n        path.add(t)\n    echo cost, \" \", path.len -\
    \ 1\n    for i in 1..<path.len:\n        echo path[i - 1], \" \", path[i]\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/utils/implicit_dijkstra.nim
  - cplib/tmpl/fastio.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/implicit_dijkstra.nim
  - cplib/tmpl/sheep.nim
  isVerificationFile: true
  path: verify/utils/implicit_dijkstra_shortest_path_test.nim
  requiredBy: []
  timestamp: '2026-10-17 20:24:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/implicit_dijkstra_shortest_path_test.nim
layout: document
redirect_from:
- /verify/verify/utils/implicit_dijkstra_shortest_path_test.nim
- /verify/verify/utils/implicit_dijkstra_shortest_path_test.nim.html
title: verify/utils/implicit_dijkstra_shortest_path_test.nim
---
