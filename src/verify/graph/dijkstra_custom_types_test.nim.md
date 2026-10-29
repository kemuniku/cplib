---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
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
    import random, sequtils\nimport cplib/graph/graph\nimport cplib/graph/dijkstra\n\
    import cplib/utils/constants\n\ntype\n    Distance = object\n        value: int\n\
    \    Timetable = object\n        travel, interval: int\n\nproc `<`(a, b: Distance):\
    \ bool = a.value < b.value\nproc arrive(d: Distance, edge: Timetable): Distance\
    \ =\n    Distance(value: ((d.value + edge.interval - 1) div edge.interval) * edge.interval\
    \ + edge.travel)\n\nlet zero = Distance(value: 0)\nlet infinity = Distance(value:\
    \ 1_000_000)\n\ntemplate checkTimetable(g: untyped) =\n    doAssert dijkstra[Distance,\
    \ Timetable](g, 0, arrive, zero, infinity) ==\n        @[zero, Distance(value:\
    \ 2), Distance(value: 6), Distance(value: 9), infinity]\n    let restored = g.restore_dijkstra(0,\
    \ arrive, zero, infinity)\n    doAssert restored.prev == @[-1, 0, 1, 2, -1]\n\
    \    doAssert restored.costs == g.dijkstra(0, arrive, zero, infinity)\n    let\
    \ path = g.shortest_path_dijkstra(0, 3, arrive, zero, infinity)\n    doAssert\
    \ path.path == @[0, 1, 2, 3]\n    doAssert path.cost == Distance(value: 9)\n \
    \   let missing = g.shortest_path_dijkstra(0, 4, arrive, zero, infinity)\n   \
    \ doAssert missing.path == @[4]\n    doAssert missing.cost == infinity\n    doAssert\
    \ g.shortest_path_dijkstra(0, 0, arrive, zero, infinity) == (@[0], zero)\n   \
    \ let multi = g.restore_dijkstra(@[0, 2, 0], arrive, zero, infinity)\n    doAssert\
    \ multi.costs == @[zero, zero, zero, Distance(value: 1), infinity]\n    doAssert\
    \ multi.prev == @[-1, 2, -1, 2, -1]\n    let empty = g.restore_dijkstra(newSeq[int](),\
    \ arrive, zero, infinity)\n    doAssert empty.costs == newSeqWith(5, infinity)\n\
    \    doAssert empty.prev == newSeqWith(5, -1)\n\nvar dynamicGraph = initWeightedDirectedGraph(5,\
    \ Timetable)\nvar staticGraph = initWeightedDirectedStaticGraph(5, Timetable)\n\
    for (u, v, travel, interval) in [(0, 1, 2, 1), (0, 2, 20, 1), (1, 2, 1, 5),\n\
    \        (2, 3, 1, 4), (0, 0, 0, 1), (0, 1, 3, 1), (2, 1, 0, 1)]:\n    let edge\
    \ = Timetable(travel: travel, interval: interval)\n    dynamicGraph.add_edge(u,\
    \ v, edge)\n    staticGraph.add_edge(u, v, edge)\nstaticGraph.build()\ncheckTimetable(dynamicGraph)\n\
    checkTimetable(staticGraph)\n\nblock:\n    let wait = 2\n    let add = proc(d:\
    \ int64, edge: int): int64 = d + int64(edge + wait)\n    var g = initWeightedUnDirectedGraph(3)\n\
    \    var sg = initWeightedUnDirectedStaticGraph(3)\n    g.add_edge(0, 1, 3)\n\
    \    g.add_edge(1, 2, 4)\n    sg.add_edge(0, 1, 3)\n    sg.add_edge(1, 2, 4)\n\
    \    sg.build()\n    doAssert g.dijkstra(2, add, 10'i64, 1000'i64) == @[21'i64,\
    \ 16, 10]\n    doAssert sg.dijkstra(2, add, 10'i64, 1000'i64) == @[21'i64, 16,\
    \ 10]\n\nblock:\n    let add = proc(d: Distance, edge: int): Distance = Distance(value:\
    \ d.value + edge)\n    var g = initUnWeightedDirectedGraph(3)\n    var sg = initUnWeightedDirectedStaticGraph(3)\n\
    \    g.add_edge(0, 1)\n    sg.add_edge(0, 1)\n    sg.build()\n    doAssert g.dijkstra(0,\
    \ add, zero, infinity) == @[zero, Distance(value: 1), infinity]\n    doAssert\
    \ sg.dijkstra(0, add, zero, infinity) == @[zero, Distance(value: 1), infinity]\n\
    \    let emptyGraph = initWeightedDirectedGraph(0, Timetable)\n    doAssert emptyGraph.dijkstra(newSeq[int](),\
    \ arrive, zero, infinity).len == 0\n\nvar rng = initRand(20261026)\nfor trial\
    \ in 0..<100:\n    let n = rng.rand(1..8)\n    var g = initWeightedDirectedGraph(n,\
    \ Timetable)\n    var sg = initWeightedDirectedStaticGraph(n, Timetable)\n   \
    \ for u in 0..<n:\n        for v in 0..<n:\n            if rng.rand(0..3) == 0:\n\
    \                let edge = Timetable(travel: rng.rand(0..9), interval: rng.rand(1..5))\n\
    \                g.add_edge(u, v, edge)\n                sg.add_edge(u, v, edge)\n\
    \    sg.build()\n    var starts = newSeq[int](rng.rand(0..n + 2))\n    var expected\
    \ = newSeqWith(n, infinity)\n    for s in starts.mitems:\n        s = rng.rand(0..<n)\n\
    \        expected[s] = zero\n    for iteration in 0..<n:\n        for edge in\
    \ g.edge_info:\n            if expected[edge.src] != infinity:\n             \
    \   let next = arrive(expected[edge.src], edge.cost)\n                if next\
    \ < expected[edge.dst]:\n                    expected[edge.dst] = next\n    doAssert\
    \ g.dijkstra(starts, arrive, zero, infinity) == expected\n    doAssert sg.dijkstra(starts,\
    \ arrive, zero, infinity) == expected\n\nblock:\n    var g = initWeightedDirectedGraph(3)\n\
    \    g.add_edge(0, 1, 5)\n    g.add_edge(1, 2, 7)\n    g.add_edge(0, 2, 10)\n\
    \    let minimax = proc(d, edge: int): int = max(d, edge)\n    doAssert g.dijkstra(0,\
    \ minimax, 0, 1000) == @[0, 5, 7]\n    doAssert g.dijkstra(0) == @[0, 5, 10]\n\
    \ntemplate checkLegacy(T: typedesc, zero, infinity: untyped) =\n    block:\n \
    \       var g = initWeightedDirectedGraph(3, T)\n        var sg = initWeightedDirectedStaticGraph(3,\
    \ T)\n        g.add_edge(0, 1, T(2))\n        sg.add_edge(0, 1, T(2))\n      \
    \  sg.build()\n        doAssert g.dijkstra(0) == @[T(0), T(2), infinity]\n   \
    \     doAssert sg.dijkstra(0) == @[T(0), T(2), infinity]\n        doAssert dijkstra[T](g,\
    \ 0, zero, infinity) == @[T(0), T(2), infinity]\n        doAssert g.restore_dijkstra(@[0,\
    \ 2]).costs == @[T(0), T(2), T(0)]\n        doAssert sg.shortest_path_dijkstra(0,\
    \ 1) == (@[0, 1], T(2))\n\ncheckLegacy(int, 0, INF64)\ncheckLegacy(int32, 0'i32,\
    \ INF32)\ncheckLegacy(float, 0.0, 1e100)\ncheckLegacy(float32, 0.0'f32, 1e30'f32)\n\
    \nblock:\n    var g = initUnWeightedUnDirectedGraph(3)\n    var sg = initUnWeightedUnDirectedStaticGraph(3)\n\
    \    g.add_edge(0, 1)\n    sg.add_edge(0, 1)\n    sg.build()\n    doAssert g.dijkstra(0,\
    \ 0, 1000) == @[0, 1, 1000]\n    doAssert sg.dijkstra(0, 0, 1000) == @[0, 1, 1000]\n\
    \    doAssert g.restore_dijkstra(0).prev == @[-1, 0, -1]\n    doAssert sg.shortest_path_dijkstra(0,\
    \ 1) == (@[0, 1], 1)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/graph/dijkstra_custom_types_test.nim
  requiredBy: []
  timestamp: '2026-10-29 04:15:51+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dijkstra_custom_types_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dijkstra_custom_types_test.nim
- /verify/verify/graph/dijkstra_custom_types_test.nim.html
title: verify/graph/dijkstra_custom_types_test.nim
---
