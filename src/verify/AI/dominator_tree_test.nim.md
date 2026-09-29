---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dominator_tree.nim
    title: cplib/graph/dominator_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dominator_tree.nim
    title: cplib/graph/dominator_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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
    import cplib/graph/graph\nimport cplib/graph/dominator_tree\nimport random, sequtils\n\
    \nproc reachableWithout(adj: seq[seq[int]], root, removed: int): seq[bool] =\n\
    \    result = newSeq[bool](adj.len)\n    if root == removed: return\n    result[root]\
    \ = true\n    var stack = @[root]\n    while stack.len > 0:\n        let v = stack.pop()\n\
    \        for u in adj[v]:\n            if u != removed and not result[u]:\n  \
    \              result[u] = true\n                stack.add(u)\n\nproc brute(adj:\
    \ seq[seq[int]], root: int): seq[int] =\n    let n = adj.len\n    let reachable\
    \ = reachableWithout(adj, root, -1)\n    var dominates = newSeqWith(n, newSeq[bool](n))\n\
    \    for u in 0..<n:\n        let without = reachableWithout(adj, root, u)\n \
    \       for v in 0..<n:\n            dominates[u][v] = reachable[v] and not without[v]\n\
    \    result = newSeqWith(n, -1)\n    result[root] = root\n    for v in 0..<n:\n\
    \        if not reachable[v] or v == root: continue\n        for u in 0..<n:\n\
    \            if u == v or not dominates[u][v]: continue\n            var immediate\
    \ = true\n            for w in 0..<n:\n                if w != v and w != u and\
    \ dominates[w][v] and not dominates[w][u]:\n                    immediate = false\n\
    \            if immediate:\n                doAssert result[v] == -1\n       \
    \         result[v] = u\n        doAssert result[v] != -1\n\nproc check(adj: seq[seq[int]],\
    \ root: int, allTypes = false) =\n    let expected = brute(adj, root)\n    doAssert\
    \ adj.dominator_tree(root) == expected\n    if not allTypes: return\n    var dynamicGraph\
    \ = initUnWeightedDirectedGraph(adj.len)\n    var staticGraph = initUnWeightedDirectedStaticGraph(adj.len)\n\
    \    var weightedDynamic = initWeightedDirectedGraph(adj.len, int64)\n    var\
    \ weightedStatic = initWeightedDirectedStaticGraph(adj.len, float64)\n    for\
    \ v in 0..<adj.len:\n        for u in adj[v]:\n            dynamicGraph.add_edge(v,\
    \ u)\n            staticGraph.add_edge(v, u)\n            weightedDynamic.add_edge(v,\
    \ u, -123'i64)\n            weightedStatic.add_edge(v, u, 0.5)\n    staticGraph.build()\n\
    \    weightedStatic.build()\n    doAssert dynamicGraph.dominator_tree(root) ==\
    \ expected\n    doAssert staticGraph.dominator_tree(root) == expected\n    doAssert\
    \ weightedDynamic.dominator_tree(root) == expected\n    doAssert weightedStatic.dominator_tree(root)\
    \ == expected\n    doAssert dynamicGraph.dominator_tree(root) == expected\n\n\
    for adj in [\n        newSeq[seq[int]](1),\n        @[@[0, 0]],\n        newSeq[seq[int]](3),\n\
    \        @[@[1, 2], @[3], @[3], @[]],\n        @[@[0, 1, 1], @[2], @[1, 3], @[3],\
    \ @[1, 3, 5], @[4]],\n        @[@[1, 2], @[3, 4], @[4], @[5], @[3, 5], @[1, 6],\
    \ @[]]]:\n    for root in 0..<adj.len:\n        check(adj, root, true)\n\nfor\
    \ n in 1..4:\n    for mask in 0..<(1 shl (n * (n - 1))):\n        var adj = newSeq[seq[int]](n)\n\
    \        var bit = 0\n        for v in 0..<n:\n            for u in 0..<n:\n \
    \               if v == u: continue\n                if (mask and (1 shl bit))\
    \ != 0:\n                    adj[v].add(u)\n                inc bit\n        for\
    \ root in 0..<n:\n            check(adj, root)\n\nvar rng = initRand(927461)\n\
    for trial in 0..<500:\n    let n = rng.rand(1..12)\n    var adj = newSeq[seq[int]](n)\n\
    \    for i in 0..<rng.rand(0..n * n * 2):\n        adj[rng.rand(n - 1)].add(rng.rand(n\
    \ - 1))\n    for root in 0..<n:\n        check(adj, root, root == trial mod n)\n\
    \nblock:\n    const n = 200000\n    var g = initUnWeightedDirectedStaticGraph(n)\n\
    \    for v in 1..<n:\n        g.add_edge(v, v - 1)\n    g.add_edge(0, n - 2)\n\
    \    g.build()\n    let parent = g.dominator_tree(n - 1)\n    doAssert parent[n\
    \ - 1] == n - 1\n    for v in 0..<n - 1:\n        doAssert parent[v] == v + 1\n\
    \    let fromZero = g.dominator_tree(0)\n    doAssert fromZero[0] == 0\n    doAssert\
    \ fromZero[n - 1] == -1\n    doAssert fromZero[n - 2] == 0\n    for v in 1..<n\
    \ - 2:\n        doAssert fromZero[v] == v + 1\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/dominator_tree.nim
  - cplib/graph/dominator_tree.nim
  isVerificationFile: true
  path: verify/AI/dominator_tree_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:45:17+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dominator_tree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dominator_tree_test.nim
- /verify/verify/AI/dominator_tree_test.nim.html
title: verify/AI/dominator_tree_test.nim
---
