---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowerbound_maxflow.nim
    title: cplib/graph/lowerbound_maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowerbound_maxflow.nim
    title: cplib/graph/lowerbound_maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
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
    import cplib/graph/lowerbound_maxflow\nimport random\n\nproc checkFlow[Cap](g:\
    \ LowerBoundMaxFlow[Cap], n, src, dst: int, value: Cap) =\n    var balance = newSeq[Cap](n)\n\
    \    for i, e in g.get_edges():\n        doAssert e == g.get_edge(i)\n       \
    \ doAssert e.lower <= e.flow and e.flow <= e.upper\n        if e.src != e.dst:\n\
    \            balance[e.src] -= e.flow\n            balance[e.dst] += e.flow\n\
    \    for v in 0..<n:\n        doAssert balance[v] == (if v == src: -value elif\
    \ v == dst: value else: Cap(0))\n\nblock:\n    var g = initLowerBoundMaxFlow(3)\n\
    \    doAssert g.add_edge(0, 1, 2, 5) == 0\n    doAssert g.add_edge(1, 2, 3, 4)\
    \ == 1\n    doAssert g.add_edge(0, 2, 0, 2) == 2\n    doAssert g.flow(0, 2) ==\
    \ 6\n    g.checkFlow(3, 0, 2, 6)\n    doAssert g.flow(0, 2) == 6\n    g.add_edge(0,\
    \ 2, 1, 3)\n    doAssert g.flow(0, 2) == 9\n    g.checkFlow(3, 0, 2, 9)\n    doAssert\
    \ g.flow(2, 0) == -1\n    doAssert g.flow(0, 2) == 9\n    g.checkFlow(3, 0, 2,\
    \ 9)\n\nblock:\n    var g = initLowerBoundMaxFlow[int32](3)\n    g.add_edge(0,\
    \ 1, 2, 2)\n    doAssert g.flow(0, 2) == -1\n    g.add_edge(1, 2, 0, 3)\n    doAssert\
    \ g.flow(0, 2) == 2\n    g.checkFlow(3, 0, 2, 2'i32)\n\nblock:\n    var g = initLowerBoundMaxFlow[int64](2)\n\
    \    g.add_edge(0, 0, high(int64), high(int64))\n    g.add_edge(0, 1, high(int64)\
    \ - 1, high(int64))\n    doAssert g.flow(0, 1) == high(int64)\n    g.checkFlow(2,\
    \ 0, 1, high(int64))\n\nblock:\n    var g = initLowerBoundMaxFlow(4)\n    g.add_edge(2,\
    \ 3, 2, 3)\n    doAssert g.flow(0, 1) == -1\n    g.add_edge(3, 2, 1, 3)\n    doAssert\
    \ g.flow(0, 1) == 0\n    g.checkFlow(4, 0, 1, 0)\n\nblock:\n    var g = initLowerBoundMaxFlow(2)\n\
    \    g.add_edge(1, 0, 2, 2)\n    doAssert g.flow(0, 1) == -1\n    g.add_edge(0,\
    \ 1, 0, 2)\n    doAssert g.flow(0, 1) == 0\n    g.checkFlow(2, 0, 1, 0)\n\ntype\
    \ Edge = tuple[src, dst, lower, upper: int]\n\nproc bruteForce(n, src, dst: int,\
    \ edges: seq[Edge]): int =\n    var balance = newSeq[int](n)\n    var best = -1\n\
    \    proc dfs(i: int) =\n        if i == edges.len:\n            for v in 0..<n:\n\
    \                if v != src and v != dst and balance[v] != 0:\n             \
    \       return\n            if balance[src] + balance[dst] == 0:\n           \
    \     best = max(best, balance[dst])\n            return\n        let e = edges[i]\n\
    \        for amount in e.lower..e.upper:\n            balance[e.src] -= amount\n\
    \            balance[e.dst] += amount\n            dfs(i + 1)\n            balance[e.src]\
    \ += amount\n            balance[e.dst] -= amount\n    dfs(0)\n    best\n\nvar\
    \ rng = initRand(20260914)\nfor trial in 0..<3000:\n    let n = rng.rand(2..5)\n\
    \    let src = rng.rand(0..<n)\n    let dst = (src + rng.rand(1..<n)) mod n\n\
    \    var edges: seq[Edge]\n    var g = initLowerBoundMaxFlow(n)\n    for i in\
    \ 0..<rng.rand(0..7):\n        let u = rng.rand(0..<n)\n        let v = rng.rand(0..<n)\n\
    \        let upper = rng.rand(0..3)\n        let lower = rng.rand(0..upper)\n\
    \        edges.add((u, v, lower, upper))\n        doAssert g.add_edge(u, v, lower,\
    \ upper) == i\n    let expected = bruteForce(n, src, dst, edges)\n    doAssert\
    \ g.flow(src, dst) == expected\n    if expected >= 0:\n        g.checkFlow(n,\
    \ src, dst, expected)\n        for i, e in g.get_edges():\n            doAssert\
    \ (e.src, e.dst, e.lower, e.upper) == edges[i]\n    doAssert g.flow(src, dst)\
    \ == expected\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/graph/lowerbound_maxflow.nim
  - cplib/graph/maxflow.nim
  - cplib/graph/lowerbound_maxflow.nim
  isVerificationFile: true
  path: verify/AI/lowerbound_maxflow_test.nim
  requiredBy: []
  timestamp: '2026-09-16 22:30:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lowerbound_maxflow_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lowerbound_maxflow_test.nim
- /verify/verify/AI/lowerbound_maxflow_test.nim.html
title: verify/AI/lowerbound_maxflow_test.nim
---
