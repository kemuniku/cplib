---
data:
  _extendedDependsOn:
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport std/[hashes, tables]\nimport cplib/utils/implicit_dijkstra\n\
    import cplib/utils/constants\n\ntype Vertex = object\n    x, y: int\n\nproc `==`(a,\
    \ b: Vertex): bool = a.x == b.x and a.y == b.y\nproc hash(v: Vertex): Hash = hash((v.x,\
    \ v.y))\n\nproc makeAdjacent(width, height: int, blocked: Vertex): proc(v: Vertex):\
    \ seq[(Vertex, int)] {.closure.} =\n    result = proc(v: Vertex): seq[(Vertex,\
    \ int)] =\n        for (dx, dy, cost) in @[(1, 0, 2), (-1, 0, 2), (0, 1, 1), (0,\
    \ -1, 1)]:\n            let next = Vertex(x: v.x + dx, y: v.y + dy)\n        \
    \    if next.x in 0..<width and next.y in 0..<height and next != blocked:\n  \
    \              result.add((next, cost))\n\nlet start = Vertex(x: 0, y: 0)\nlet\
    \ goal = Vertex(x: 2, y: 0)\nlet adjacent = makeAdjacent(3, 2, Vertex(x: 1, y:\
    \ 0))\nlet distances = implicit_dijkstra(start, adjacent)\ndoAssert distances[goal]\
    \ == 6\ndoAssert not distances.hasKey(Vertex(x: 9, y: 9))\n\nlet targetX = 2\n\
    let untilX = implicit_dijkstra_until(\n    start,\n    adjacent,\n    proc(v:\
    \ Vertex): bool = v.x == targetX,\n)\ndoAssert untilX == 5\ndoAssert implicit_dijkstra_until(start,\
    \ adjacent, proc(v: Vertex): bool = v == start) == 0\ndoAssert implicit_dijkstra_until(start,\
    \ adjacent, proc(v: Vertex): bool = v.x == 9) == INF64\n\nlet restored = restore_implicit_dijkstra(start,\
    \ adjacent)\ndoAssert restored.costs[goal] == 6\ndoAssert restored.prev[goal]\
    \ == Vertex(x: 2, y: 1)\n\nlet shortest = shortest_path_implicit_dijkstra(start,\
    \ goal, adjacent)\ndoAssert shortest.cost == 6\ndoAssert shortest.path == @[\n\
    \    Vertex(x: 0, y: 0),\n    Vertex(x: 0, y: 1),\n    Vertex(x: 1, y: 1),\n \
    \   Vertex(x: 2, y: 1),\n    Vertex(x: 2, y: 0),\n]\n\nlet unreachable = shortest_path_implicit_dijkstra(\n\
    \    start,\n    Vertex(x: 9, y: 9),\n    adjacent,\n)\ndoAssert unreachable.cost\
    \ == INF64\ndoAssert unreachable.path.len == 0\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/utils/implicit_dijkstra.nim
  - cplib/utils/implicit_dijkstra.nim
  isVerificationFile: true
  path: verify/AI/implicit_dijkstra_test.nim
  requiredBy: []
  timestamp: '2026-07-20 01:43:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/implicit_dijkstra_test.nim
layout: document
redirect_from:
- /verify/verify/AI/implicit_dijkstra_test.nim
- /verify/verify/AI/implicit_dijkstra_test.nim.html
title: verify/AI/implicit_dijkstra_test.nim
---
