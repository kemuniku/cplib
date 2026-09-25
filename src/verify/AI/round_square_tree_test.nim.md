---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/round_square_tree.nim
    title: cplib/graph/round_square_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/round_square_tree.nim
    title: cplib/graph/round_square_tree.nim
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
    import algorithm, random, sequtils\nimport cplib/graph/graph\nimport cplib/graph/biconnected_components\n\
    import cplib/graph/round_square_tree\n\ntype Edge = (int, int)\n\nproc labels(g:\
    \ UnWeightedUnDirectedGraph, removed = -1): seq[int] =\n    result = newSeqWith(g.len,\
    \ -1)\n    for s in 0..<g.len:\n        if s == removed or result[s] != -1: continue\n\
    \        result[s] = s\n        var stack = @[s]\n        while stack.len > 0:\n\
    \            let v = stack.pop()\n            for to in g[v]:\n              \
    \  if to != removed and result[to] == -1:\n                    result[to] = s\n\
    \                    stack.add(to)\n\nproc check(n: int, edges: seq[Edge]) =\n\
    \    var g = initUnWeightedUnDirectedGraph(n)\n    var sg = initUnWeightedUnDirectedStaticGraph(n)\n\
    \    var wg = initWeightedUnDirectedGraph(n, float)\n    var swg = initWeightedUnDirectedStaticGraph(n,\
    \ float)\n    for (u, v) in edges:\n        g.add_edge(u, v)\n        sg.add_edge(u,\
    \ v)\n        wg.add_edge(u, v, 2.5)\n        swg.add_edge(u, v, -1.5)\n    sg.build()\n\
    \    swg.build()\n    let bc = initBiconnectedComponents(g)\n    let tree = initRoundSquareTree(bc)\n\
    \    doAssert tree.len == n + bc.groups.len\n    for other in [initRoundSquareTree(g),\
    \ initRoundSquareTree(sg),\n                  initRoundSquareTree(wg), initRoundSquareTree(swg)]:\n\
    \        doAssert other.len == tree.len\n        doAssert other.edges == tree.edges\n\
    \        doAssert other.edge_info == tree.edge_info\n    for i, group in bc.groups:\n\
    \        doAssert toSeq(tree[n+i]).sorted() == group.sorted()\n    var edgeCount\
    \ = 0\n    for v in 0..<n:\n        var expected: seq[int]\n        for i in bc.belong[v]:\
    \ expected.add(n+i)\n        doAssert toSeq(tree[v]).sorted() == expected.sorted()\n\
    \        edgeCount += expected.len\n    let original = labels(g)\n    let mapped\
    \ = labels(tree)\n    var components = 0\n    for v, c in mapped:\n        if\
    \ v == c: inc components\n    doAssert edgeCount == tree.len - components\n  \
    \  for u in 0..<n:\n        for v in 0..<n:\n            doAssert (original[u]\
    \ == original[v]) == (mapped[u] == mapped[v])\n    for removed in 0..<n:\n   \
    \     let originalAfter = labels(g, removed)\n        let mappedAfter = labels(tree,\
    \ removed)\n        for u in 0..<n:\n            if u == removed: continue\n \
    \           for v in 0..<n:\n                if v == removed: continue\n     \
    \           doAssert (originalAfter[u] == originalAfter[v]) ==\n             \
    \       (mappedAfter[u] == mappedAfter[v])\n\ncheck(0, @[])\ncheck(1, @[])\ncheck(1,\
    \ @[(0, 0), (0, 0)])\ncheck(6, @[(0, 1), (1, 2), (2, 0), (2, 3), (3, 4), (4, 2)])\n\
    for n in 1..5:\n    var possible: seq[Edge]\n    for u in 0..<n:\n        for\
    \ v in u+1..<n: possible.add((u, v))\n    for mask in 0..<(1 shl possible.len):\n\
    \        var edges: seq[Edge]\n        for i, e in possible:\n            if (mask\
    \ and (1 shl i)) != 0: edges.add(e)\n        check(n, edges)\nvar rng = initRand(20260913)\n\
    for trial in 0..<300:\n    let n = rng.rand(1..8)\n    var edges: seq[Edge]\n\
    \    for i in 0..<rng.rand(0..24):\n        edges.add((rng.rand(n-1), rng.rand(n-1)))\n\
    \    check(n, edges)\n\nblock:\n    const n = 200000\n    var g = initUnWeightedUnDirectedGraph(n)\n\
    \    for v in 1..<n: g.add_edge(v-1, v)\n    let tree = initRoundSquareTree(g)\n\
    \    doAssert tree.len == 2*n-1\n    doAssert tree.edge_info.len == 2*(n-1)\n\
    \    for v in 0..<n:\n        doAssert tree.edges[v].len == (if v == 0 or v ==\
    \ n-1: 1 else: 2)\n    for v in n..<tree.len:\n        doAssert tree.edges[v].len\
    \ == 2\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/lowlink.nim
  - cplib/graph/graph.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/graph.nim
  - cplib/graph/round_square_tree.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/round_square_tree.nim
  isVerificationFile: true
  path: verify/AI/round_square_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/round_square_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/round_square_tree_test.nim
- /verify/verify/AI/round_square_tree_test.nim.html
title: verify/AI/round_square_tree_test.nim
---
