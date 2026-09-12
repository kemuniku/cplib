---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/count_topologicalsort.nim
    title: cplib/graph/count_topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/count_topologicalsort.nim
    title: cplib/graph/count_topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
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
    import algorithm, sequtils\nimport cplib/graph/graph\nimport cplib/graph/count_topologicalsort\n\
    \nproc bruteCount(g: UnWeightedDirectedGraph): int64 =\n    var order = toSeq(0..<g.len)\n\
    \    while true:\n        var pos = newSeq[int](g.len)\n        for i, v in order:\n\
    \            pos[v] = i\n        var valid = true\n        for u in 0..<g.len:\n\
    \            for v in g[u]:\n                if pos[u] >= pos[v]:\n          \
    \          valid = false\n        if valid:\n            inc result\n        if\
    \ not order.nextPermutation():\n            break\n\nproc checkTypes(n: int, edges:\
    \ openArray[(int, int)], expected: int64) =\n    var g = initUnWeightedDirectedGraph(n)\n\
    \    var sg = initUnWeightedDirectedStaticGraph(n)\n    var wg = initWeightedDirectedGraph(n,\
    \ float)\n    var swg = initWeightedDirectedStaticGraph(n, int64)\n    for (u,\
    \ v) in edges:\n        g.add_edge(u, v)\n        sg.add_edge(u, v)\n        wg.add_edge(u,\
    \ v, -0.5)\n        swg.add_edge(u, v, -10'i64)\n    sg.build()\n    swg.build()\n\
    \    doAssert g.count_topologicalsort() == expected\n    doAssert sg.count_topologicalsort()\
    \ == expected\n    doAssert wg.count_topologicalsort() == expected\n    doAssert\
    \ swg.count_topologicalsort() == expected\n\ncheckTypes(0, [], 1)\ncheckTypes(1,\
    \ [], 1)\ncheckTypes(5, [], 120)\ncheckTypes(4, [(0, 1), (1, 2), (2, 3)], 1)\n\
    checkTypes(4, [(0, 1), (0, 2), (1, 3), (2, 3)], 2)\ncheckTypes(4, [(0, 1), (2,\
    \ 3)], 6)\ncheckTypes(3, [(0, 1), (0, 1)], 3)\ncheckTypes(1, [(0, 0)], 0)\ncheckTypes(4,\
    \ [(0, 1), (1, 0)], 0)\ncheckTypes(3, [(0, 1), (1, 2), (2, 0)], 0)\n\nfor n in\
    \ 0..4:\n    var possible: seq[(int, int)]\n    for u in 0..<n:\n        for v\
    \ in 0..<n:\n            if u != v:\n                possible.add((u, v))\n  \
    \  for mask in 0..<(1 shl possible.len):\n        var g = initUnWeightedDirectedGraph(n)\n\
    \        for i, edge in possible:\n            if (mask and (1 shl i)) != 0:\n\
    \                g.add_edge(edge[0], edge[1])\n        doAssert g.count_topologicalsort()\
    \ == bruteCount(g)\n\ndoAssert initUnWeightedDirectedGraph(20).count_topologicalsort()\
    \ == 2432902008176640000'i64\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/topologicalsort.nim
  - cplib/graph/count_topologicalsort.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/count_topologicalsort.nim
  isVerificationFile: true
  path: verify/AI/count_topologicalsort_test.nim
  requiredBy: []
  timestamp: '2026-09-12 20:29:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/count_topologicalsort_test.nim
layout: document
redirect_from:
- /verify/verify/AI/count_topologicalsort_test.nim
- /verify/verify/AI/count_topologicalsort_test.nim.html
title: verify/AI/count_topologicalsort_test.nim
---
