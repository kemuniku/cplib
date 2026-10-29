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
    \ntype Distance = object\n    value: int\n    path: string\n\nproc `<`(a, b: Distance):\
    \ bool {.error: \"Distance \u306E\u6BD4\u8F03\u306B\u306F cmp \u3092\u4F7F\u3046\
    \u3053\u3068\".}\nproc `==`(a, b: Distance): bool {.error: \"Distance \u306E\u540C\
    \u9806\u4F4D\u5224\u5B9A\u306B\u306F cmp \u3092\u4F7F\u3046\u3053\u3068\".}\n\n\
    let zero = Distance(value: 0, path: \"start\")\nlet infinity = Distance(value:\
    \ 1000, path: \"unreachable\")\nlet direction = 1\nlet compare = proc(a, b: Distance):\
    \ int = direction * system.cmp(a.value, b.value)\nvar staleExpansions = 0\nlet\
    \ add = proc(d: Distance, edge: int): Distance =\n    if d.value == 10: inc staleExpansions\n\
    \    Distance(value: d.value + edge, path: d.path & \" \" & $edge)\n\ntemplate\
    \ check(g: untyped) =\n    let costs = g.dijkstra(0, add, zero, infinity, cmp\
    \ = compare)\n    for i, value in [0, 2, 1, 3, 2, 1000]:\n        doAssert costs[i].value\
    \ == value\n    let restored = g.restore_dijkstra(0, add, zero, infinity, compare)\n\
    \    doAssert restored.prev == @[-1, 2, 0, 1, 0, -1]\n    let shortest = g.shortest_path_dijkstra(0,\
    \ 3, add, zero, infinity, compare)\n    doAssert shortest.path == @[0, 2, 1, 3]\n\
    \    doAssert shortest.cost.value == 3\n    doAssert shortest.cost.path == \"\
    start 1 1 1\"\n    let missing = g.shortest_path_dijkstra(0, 5, add, zero, infinity,\
    \ compare)\n    doAssert missing.cost.value == infinity.value\n    doAssert missing.path\
    \ == @[5]\n    let same = g.shortest_path_dijkstra(0, 0, add, zero, infinity,\
    \ compare)\n    doAssert same.cost.value == 0\n    doAssert same.path == @[0]\n\
    \    let multi = g.restore_dijkstra(@[0, 2, 0], add, zero, infinity, compare)\n\
    \    for i, value in [0, 1, 0, 2, 2, 1000]:\n        doAssert multi.costs[i].value\
    \ == value\n    doAssert multi.prev[0] == -1\n    doAssert multi.prev[2] == -1\n\
    \    let empty = g.restore_dijkstra(newSeq[int](), add, zero, infinity, compare)\n\
    \    doAssert empty.prev == newSeqWith(6, -1)\n    for d in empty.costs: doAssert\
    \ d.value == infinity.value\n    doAssert staleExpansions == 0\n\nvar g = initWeightedDirectedGraph(6)\n\
    var sg = initWeightedDirectedStaticGraph(6)\nfor (u, v, edge) in [(0, 1, 10),\
    \ (0, 2, 1), (2, 1, 1), (1, 3, 1),\n        (2, 3, 30), (0, 4, 2), (4, 3, 1),\
    \ (0, 0, 0), (1, 1, 0)]:\n    g.add_edge(u, v, edge)\n    sg.add_edge(u, v, edge)\n\
    sg.build()\ncheck(g)\ncheck(sg)\n\nblock:\n    var g = initUnWeightedUnDirectedGraph(3)\n\
    \    var sg = initUnWeightedUnDirectedStaticGraph(3)\n    g.add_edge(0, 1)\n \
    \   sg.add_edge(0, 1)\n    sg.build()\n    doAssert g.dijkstra(0, add, zero, infinity,\
    \ compare)[1].value == 1\n    doAssert sg.dijkstra(0, add, zero, infinity, compare)[2].value\
    \ == 1000\n\nvar rng = initRand(20261026)\nfor trial in 0..<100:\n    let n =\
    \ rng.rand(1..8)\n    var g = initWeightedDirectedGraph(n)\n    var sg = initWeightedDirectedStaticGraph(n)\n\
    \    for u in 0..<n:\n        for v in 0..<n:\n            if rng.rand(0..3) ==\
    \ 0:\n                let weight = rng.rand(0..9)\n                g.add_edge(u,\
    \ v, weight)\n                sg.add_edge(u, v, weight)\n    sg.build()\n    let\
    \ start = rng.rand(0..<n)\n    var expected = newSeqWith(n, -1)\n    expected[start]\
    \ = 1000\n    for iteration in 0..<n:\n        for e in g.edge_info:\n       \
    \     if expected[e.src] != -1:\n                expected[e.dst] = max(expected[e.dst],\
    \ min(expected[e.src], e.cost))\n    let reverse = trial mod 2 == 0\n    let compare\
    \ = proc(a, b: int): int =\n        if reverse: system.cmp(b, a)\n        else:\
    \ system.cmp(-a, -b)\n    let bottleneck = proc(d, edge: int): int = min(d, edge)\n\
    \    doAssert g.dijkstra(start, bottleneck, 1000, -1, compare) == expected\n \
    \   doAssert sg.dijkstra(start, bottleneck, 1000, -1, compare) == expected\n \
    \   let sum = proc(d, edge: int): int = d + edge\n    doAssert g.dijkstra(start,\
    \ sum, 0, 1000) == g.dijkstra(start, 0, 1000)\n\necho \"Hello World\"\n"
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
  path: verify/graph/dijkstra_custom_cmp_test.nim
  requiredBy: []
  timestamp: '2026-10-29 04:15:51+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dijkstra_custom_cmp_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dijkstra_custom_cmp_test.nim
- /verify/verify/graph/dijkstra_custom_cmp_test.nim.html
title: verify/graph/dijkstra_custom_cmp_test.nim
---
