---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/radix_heap.nim
    title: cplib/collections/radix_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/radix_heap.nim
    title: cplib/collections/radix_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra_radix.nim
    title: cplib/graph/dijkstra_radix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra_radix.nim
    title: cplib/graph/dijkstra_radix.nim
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
    import random\nimport cplib/graph/graph\nimport cplib/graph/dijkstra\nimport cplib/graph/dijkstra_radix\n\
    import cplib/utils/constants\n\nproc checkGraph(G: auto, starts: seq[int], zero,\
    \ inf: int) =\n    let expected = G.dijkstra(starts, zero, inf)\n    doAssert\
    \ G.dijkstra_radix(starts, zero, inf) == expected\n    let restored = G.restore_dijkstra_radix(starts,\
    \ zero, inf)\n    doAssert restored.costs == expected\n    for v in 0..<G.len:\n\
    \        if expected[v] == inf: continue\n        var current = v\n        var\
    \ steps = 0\n        while restored.prev[current] != -1:\n            let parent\
    \ = restored.prev[current]\n            var found = false\n            for (dest,\
    \ cost) in G.to_and_cost(parent):\n                if dest == current and restored.costs[parent]\
    \ + cost == restored.costs[current]:\n                    found = true\n     \
    \       doAssert found\n            current = parent\n            inc steps\n\
    \            doAssert steps < G.len\n        doAssert current in starts\n    \
    \    doAssert restored.costs[current] == zero\n    if starts.len == 0: return\n\
    \    let single = G.dijkstra(starts[0], zero, inf)\n    doAssert G.dijkstra_radix(starts[0],\
    \ zero, inf) == single\n    for goal in 0..<G.len:\n        let answer = G.shortest_path_dijkstra_radix(starts[0],\
    \ goal, zero, inf)\n        doAssert answer.cost == single[goal]\n        if single[goal]\
    \ == inf:\n            doAssert answer.path == @[goal]\n        else:\n      \
    \      doAssert answer.path[0] == starts[0]\n            doAssert answer.path[^1]\
    \ == goal\n            doAssert answer.path.len <= G.len\n            var pathCost\
    \ = zero\n            for k in 1..<answer.path.len:\n                var best\
    \ = inf\n                for (dest, cost) in G.to_and_cost(answer.path[k - 1]):\n\
    \                    if dest == answer.path[k]: best = min(best, cost)\n     \
    \           doAssert best != inf\n                pathCost += best\n         \
    \   doAssert pathCost == answer.cost\n\nvar rng = initRand(987654)\nfor trial\
    \ in 0..<100:\n    let n = rng.rand(1..25)\n    var dynamic = initWeightedDirectedGraph(n)\n\
    \    var fixed = initWeightedDirectedStaticGraph(n)\n    var undirected = initWeightedUnDirectedGraph(n)\n\
    \    var fixedUndirected = initWeightedUnDirectedStaticGraph(n)\n    for edge\
    \ in 0..<rng.rand(0..n * 5):\n        let u = rng.rand(n - 1)\n        let v =\
    \ rng.rand(n - 1)\n        let cost = rng.rand(0..100)\n        dynamic.add_edge(u,\
    \ v, cost)\n        fixed.add_edge(u, v, cost)\n        undirected.add_edge(u,\
    \ v, cost)\n        fixedUndirected.add_edge(u, v, cost)\n    fixed.build()\n\
    \    fixedUndirected.build()\n    var starts: seq[int]\n    for s in 0..<rng.rand(0..5):\
    \ starts.add(rng.rand(n - 1))\n    let zero = rng.rand(-200..0)\n    checkGraph(dynamic,\
    \ starts, zero, INF64)\n    checkGraph(fixed, starts, zero, INF64)\n    checkGraph(undirected,\
    \ starts, zero, INF64)\n    checkGraph(fixedUndirected, starts, zero, INF64)\n\
    \nproc checkInteger[T: SomeInteger]() =\n    var g = initWeightedDirectedGraph(5,\
    \ T)\n    var sg = initWeightedDirectedStaticGraph(5, T)\n    for edge in @[(0,\
    \ 1, T(4)), (0, 2, T(1)), (2, 1, T(0)), (1, 3, T(2))]:\n        g.add_edge(edge[0],\
    \ edge[1], edge[2])\n        sg.add_edge(edge[0], edge[1], edge[2])\n    sg.build()\n\
    \    let expected = @[T(0), T(1), T(1), T(3), high(T)]\n    doAssert g.dijkstra_radix(0,\
    \ T(0), high(T)) == expected\n    doAssert sg.dijkstra_radix(0, T(0), high(T))\
    \ == expected\n    doAssert g.dijkstra_radix(0)[3] == T(3)\n    doAssert sg.restore_dijkstra_radix(0).costs[3]\
    \ == T(3)\n    doAssert g.shortest_path_dijkstra_radix(0, 3).path == @[0, 2, 1,\
    \ 3]\n    g.add_edge(0, 1, high(T) - T(1))\n    g.add_edge(1, 4, high(T))\n  \
    \  doAssert g.dijkstra_radix(0, T(0), high(T)) == expected\n    when T is SomeSignedInt:\n\
    \        let shifted = g.dijkstra_radix(0, T(-5), high(T))\n        doAssert shifted[3]\
    \ == T(-2)\n        doAssert shifted[4] == high(T) - T(4)\n        var crossing\
    \ = initWeightedDirectedGraph(3, T)\n        crossing.add_edge(0, 1, high(T))\n\
    \        crossing.add_edge(1, 2, T(2))\n        doAssert crossing.dijkstra_radix(0,\
    \ low(T), high(T)) == @[low(T), T(-1), T(1)]\n\ncheckInteger[int]()\ncheckInteger[int8]()\n\
    checkInteger[int16]()\ncheckInteger[int32]()\ncheckInteger[int64]()\ncheckInteger[uint]()\n\
    checkInteger[uint8]()\ncheckInteger[uint16]()\ncheckInteger[uint32]()\ncheckInteger[uint64]()\n\
    \nvar ug = initUnWeightedDirectedGraph(4)\nvar usg = initUnWeightedDirectedStaticGraph(4)\n\
    var uug = initUnWeightedUnDirectedGraph(4)\nvar uusg = initUnWeightedUnDirectedStaticGraph(4)\n\
    for edge in @[(0, 1), (1, 2)]:\n    ug.add_edge(edge[0], edge[1])\n    usg.add_edge(edge[0],\
    \ edge[1])\n    uug.add_edge(edge[0], edge[1])\n    uusg.add_edge(edge[0], edge[1])\n\
    usg.build()\nuusg.build()\ncheckGraph(ug, @[0, 0], -3, INF64)\ncheckGraph(usg,\
    \ @[0, 0], -3, INF64)\ncheckGraph(uug, @[0, 0], -3, INF64)\ncheckGraph(uusg, @[0,\
    \ 0], -3, INF64)\ndoAssert ug.dijkstra_radix(0) == @[0, 1, 2, INF64]\ndoAssert\
    \ usg.restore_dijkstra_radix(0).costs == @[0, 1, 2, INF64]\ndoAssert usg.shortest_path_dijkstra_radix(0,\
    \ 0) == (@[0], 0)\n\nvar empty = initWeightedDirectedGraph(0)\ndoAssert empty.dijkstra_radix(newSeq[int]()).len\
    \ == 0\nvar capped = initWeightedDirectedGraph(3)\ncapped.add_edge(0, 1, 5)\n\
    capped.add_edge(1, 2, 5)\ncheckGraph(capped, @[0], 0, 5)\ndoAssert capped.dijkstra_radix(0,\
    \ 5, 5) == @[5, 5, 5]\n\nwhen compileOption(\"assertions\"):\n    var rejected\
    \ = false\n    capped.add_edge(0, 2, -1)\n    try:\n        discard capped.dijkstra_radix(0)\n\
    \    except AssertionDefect:\n        rejected = true\n    doAssert rejected\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra_radix.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra_radix.nim
  - cplib/collections/radix_heap.nim
  - cplib/collections/radix_heap.nim
  isVerificationFile: true
  path: verify/AI/dijkstra_radix_test.nim
  requiredBy: []
  timestamp: '2026-09-23 19:26:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dijkstra_radix_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dijkstra_radix_test.nim
- /verify/verify/AI/dijkstra_radix_test.nim.html
title: verify/AI/dijkstra_radix_test.nim
---
