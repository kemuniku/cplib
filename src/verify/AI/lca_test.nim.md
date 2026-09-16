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
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lca.nim
    title: cplib/tree/lca.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lca.nim
    title: cplib/tree/lca.nim
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
    import random, sequtils\nimport cplib/graph/graph\nimport cplib/tree/lca\nimport\
    \ cplib/tree/heavylightdecomposition\n\nvar rng = initRand(20260914)\n\nproc naive(parent,\
    \ depth: seq[int], u, v: int): int =\n    var (a, b) = (u, v)\n    while depth[a]\
    \ > depth[b]: a = parent[a]\n    while depth[b] > depth[a]: b = parent[b]\n  \
    \  while a != b:\n        a = parent[a]\n        b = parent[b]\n    a\n\nproc\
    \ check(n: int, edges: seq[(int, int)], root: int, forest: bool) =\n    var g\
    \ = initUnWeightedUnDirectedStaticGraph(n)\n    var gd = initUnWeightedUnDirectedGraph(n)\n\
    \    var wg = initWeightedUnDirectedGraph(n)\n    var ws = initWeightedUnDirectedStaticGraph(n)\n\
    \    var dg = initUnWeightedDirectedGraph(n)\n    var ds = initUnWeightedDirectedStaticGraph(n)\n\
    \    var wd = initWeightedDirectedGraph(n)\n    var wds = initWeightedDirectedStaticGraph(n)\n\
    \    var adj = newSeq[seq[int]](n)\n    for (u, v) in edges:\n        g.add_edge(u,\
    \ v)\n        gd.add_edge(u, v)\n        wg.add_edge(u, v, 7)\n        ws.add_edge(u,\
    \ v, -3)\n        dg.add_edge(v, u)\n        ds.add_edge(u, v)\n        wd.add_edge(v,\
    \ u, 4)\n        wds.add_edge(u, v, 2)\n        wds.add_edge(v, u, 8)\n      \
    \  adj[v].add(u)\n    g.build()\n    ws.build()\n    ds.build()\n    wds.build()\n\
    \    var actual: seq[LowestCommonAncestor]\n    var expected: HeavyLightDecomposition\n\
    \    if forest:\n        expected = g.initHldFromForest()\n        actual = @[g.initLCAFromForest(),\
    \ gd.initLCAFromForest(),\n            wg.initLCAFromForest(), ws.initLCAFromForest(),\
    \ dg.initLCAFromForest(),\n            ds.initLCAFromForest(), wd.initLCAFromForest(),\
    \ wds.initLCAFromForest(),\n            adj.initLCAFromForest()]\n    else:\n\
    \        expected = g.initHld(root)\n        actual = @[g.initLCA(root), gd.initLCA(root),\
    \ wg.initLCA(root),\n            ws.initLCA(root), dg.initLCA(root), ds.initLCA(root),\
    \ wd.initLCA(root),\n            wds.initLCA(root), adj.initLCA(root)]\n    let\
    \ count = expected.numVertices\n    var parent = newSeq[int](count)\n    var depths\
    \ = newSeq[int](count)\n    for v in 0..<count:\n        parent[v] = expected.parentOf(v)\n\
    \        depths[v] = expected.depth(v)\n    let realRoot = if forest: n else:\
    \ root\n    parent[realRoot] = count + 100\n    actual.add(initLCAFromParent(parent,\
    \ realRoot))\n    let disabled = initLCAFromParent(parent, realRoot, no_la = true)\n\
    \    parent[realRoot] = -1\n    for tree in actual:\n        doAssert tree.numVertices\
    \ == count\n        for v in 0..<count:\n            doAssert tree.parentOf(v)\
    \ == parent[v]\n            doAssert tree.depth(v) == depths[v]\n            doAssert\
    \ tree.la(v, -1) == -1\n            doAssert tree.la(v, depths[v] + 1) == -1\n\
    \            var a = v\n            for k in 0..depths[v]:\n                doAssert\
    \ tree.la(v, k) == a\n                a = parent[a]\n        for trial in 0..<(if\
    \ count <= 40: count * count else: 2000):\n            let u = if count <= 40:\
    \ trial div count else: rng.rand(count - 1)\n            let v = if count <= 40:\
    \ trial mod count else: rng.rand(count - 1)\n            let ancestor = naive(parent,\
    \ depths, u, v)\n            doAssert tree.lca(u, v) == ancestor\n           \
    \ doAssert disabled.lca(u, v) == ancestor\n            doAssert tree.dist(u, v)\
    \ == depths[u] + depths[v] - 2 * depths[ancestor]\n            let x = rng.rand(count\
    \ - 1)\n            doAssert tree.median(x, u, v) == expected.median(x, u, v)\n\
    \            let d = rng.rand(tree.dist(u, v) + 1)\n            doAssert tree.la(u,\
    \ v, d) == expected.la(u, v, d)\n            doAssert tree.la(u, v, -1) == -1\n\
    \    var rejected = false\n    try:\n        discard disabled.la(realRoot, 0)\n\
    \    except AssertionDefect:\n        rejected = true\n    doAssert rejected\n\
    \ncheck(0, @[], 0, true)\ncheck(1, @[], 0, false)\ncheck(15, @[], 0, true)\nfor\
    \ n in 2..40:\n    for trial in 0..<4:\n        var labels = toSeq(0..<n)\n  \
    \      rng.shuffle(labels)\n        var edges: seq[(int, int)]\n        var forestEdges:\
    \ seq[(int, int)]\n        for v in 1..<n:\n            let edge = (labels[v],\
    \ labels[rng.rand(v - 1)])\n            edges.add(edge)\n            if rng.rand(2)\
    \ != 0: forestEdges.add(edge)\n        check(n, edges, rng.rand(n - 1), false)\n\
    \        check(n, forestEdges, 0, true)\nfor n in [63, 64, 65, 127, 128, 129,\
    \ 511, 512, 513, 2048]:\n    var edges: seq[(int, int)]\n    for v in 1..<n: edges.add((v,\
    \ rng.rand(v - 1)))\n    check(n, edges, rng.rand(n - 1), false)\n\nfor n in [255,\
    \ 256, 257, 65535, 65536, 65537]:\n    var parent = newSeq[int](n)\n    var depths\
    \ = newSeq[int](n)\n    parent[0] = -1\n    for v in 1..<n:\n        parent[v]\
    \ = rng.rand(v - 1)\n        depths[v] = depths[parent[v]] + 1\n    let tree =\
    \ initLCAFromParent(parent, 0)\n    for v in 0..<n:\n        doAssert tree.lca(v,\
    \ v) == v\n        if v > 0: doAssert tree.lca(v, parent[v]) == parent[v]\n  \
    \  for trial in 0..<10000:\n        let u = rng.rand(n - 1)\n        let v = rng.rand(n\
    \ - 1)\n        doAssert tree.lca(u, v) == naive(parent, depths, u, v)\n\nfor\
    \ badParent in [@[-1, 2, 1], @[-1, -1], @[-1, 2],\n        @[-1, high(int)], @[-1,\
    \ low(int)]]:\n    var rejected = false\n    try:\n        discard initLCAFromParent(badParent,\
    \ 0)\n    except AssertionDefect:\n        rejected = true\n    doAssert rejected\n\
    \nfor n in [63, 64, 65, 127, 128, 129, 257]:\n    for shape in 0..<3:\n      \
    \  var labels = toSeq(0..<n)\n        rng.shuffle(labels)\n        var parent\
    \ = newSeq[int](n)\n        var depths = newSeq[int](n)\n        parent[labels[0]]\
    \ = -1\n        for i in 1..<n:\n            let p = (if shape == 0: i - 1\n \
    \               elif shape == 1: (i - 1) div 2\n                elif i < n div\
    \ 2: i - 1 else: i mod (n div 2))\n            parent[labels[i]] = labels[p]\n\
    \            depths[labels[i]] = depths[labels[p]] + 1\n        let tree = initLCAFromParent(parent,\
    \ labels[0])\n        for u in 0..<n:\n            doAssert tree.depth(u) == depths[u]\n\
    \            var a = u\n            for k in 0..depths[u]:\n                doAssert\
    \ tree.la(u, k) == a\n                a = parent[a]\n            for v in 0..<n:\n\
    \                doAssert tree.lca(u, v) == naive(parent, depths, u, v)\n\nblock:\n\
    \    let n = 601\n    var labels = toSeq(0..<n)\n    rng.shuffle(labels)\n   \
    \ var edges: seq[(int, int)]\n    for v in 1..<n:\n        let p = (if v in [1,\
    \ 161, 321]: 0\n            elif v <= 480: v - 1\n            else: 40 + (v -\
    \ 481) div 4)\n        edges.add((labels[v], labels[p]))\n    check(n, edges,\
    \ labels[0], false)\n\nfor leaves in [32767, 32768, 32769, 65535, 65536, 65537]:\n\
    \    var parent = newSeq[int](leaves + 2)\n    parent[0] = -1\n    parent[^1]\
    \ = 1\n    let tree = initLCAFromParent(parent, 0)\n    for v in 0..<parent.len:\n\
    \        doAssert tree.lca(v, v) == v\n        doAssert tree.lca(v, parent.high)\
    \ == (if v == parent.high: v\n            elif v == 1: 1 else: 0)\n\nlet n = 200000\n\
    var parent = newSeq[int](n)\nfor v in 0..<n: parent[v] = v - 1\nlet path = initLCAFromParent(parent,\
    \ 0)\nfor start in [0, 16, 32, n - 64]:\n    for u in start..<start + 32:\n  \
    \      for v in start..<start + 64:\n            doAssert path.lca(u, v) == min(u,\
    \ v)\nfor trial in 0..<10000:\n    let u = rng.rand(n - 1)\n    let v = rng.rand(n\
    \ - 1)\n    doAssert path.lca(u, v) == min(u, v)\n    doAssert path.dist(u, v)\
    \ == abs(u - v)\n    let k = rng.rand(u)\n    doAssert path.la(u, k) == u - k\n\
    for v in 0..<n: parent[v] = n - 1\nlet star = initLCAFromParent(parent, n - 1)\n\
    for trial in 0..<10000:\n    let u = rng.rand(n - 1)\n    let v = rng.rand(n -\
    \ 1)\n    doAssert star.lca(u, v) == (if u == v: u else: n - 1)\n    doAssert\
    \ star.la(u, 0) == u\n    doAssert star.la(u, 1) == (if u == n - 1: -1 else: n\
    \ - 1)\nparent[0] = -1\nvar depths = newSeq[int](n)\nfor v in 1..<n:\n    parent[v]\
    \ = rng.rand(v - 1)\n    depths[v] = depths[parent[v]] + 1\nlet randomTree = initLCAFromParent(parent,\
    \ 0)\nfor trial in 0..<10000:\n    let u = rng.rand(n - 1)\n    let v = rng.rand(n\
    \ - 1)\n    doAssert randomTree.lca(u, v) == naive(parent, depths, u, v)\n   \
    \ let k = rng.rand(depths[u])\n    var a = u\n    for i in 0..<k: a = parent[a]\n\
    \    doAssert randomTree.la(u, k) == a\n\nblock:\n    var adj = @[@[1], @[0, 2],\
    \ @[1]]\n    var g = initUnWeightedUnDirectedGraph(3)\n    var dg = initUnWeightedDirectedGraph(3)\n\
    \    for i in 0..<2:\n        g.add_edge(i, i + 1)\n        dg.add_edge(i, i +\
    \ 1)\n    for tree in [adj.initLCA(0, no_la = true), g.initLCA(0, no_la = true),\n\
    \            dg.initLCA(0, no_la = true), adj.initLCAFromForest(no_la = true),\n\
    \            g.initLCAFromForest(no_la = true), dg.initLCAFromForest(no_la = true)]:\n\
    \        doAssert tree.lca(1, 2) == 1\n        doAssert tree.dist(0, 2) == 2\n\
    \nfor shape in 0..<3:\n    var labels = toSeq(0..<n)\n    rng.shuffle(labels)\n\
    \    var deepParent = newSeq[int](n)\n    var deepDepth = newSeq[int](n)\n   \
    \ deepParent[labels[0]] = -1\n    for i in 1..<n:\n        let p = (if shape ==\
    \ 0: i - 1\n            elif shape == 1: (if i < n div 2: i - 1 else: i - n div\
    \ 2)\n            else: (if i mod 1000 == 1: 0 else: i - 1))\n        deepParent[labels[i]]\
    \ = labels[p]\n        deepDepth[labels[i]] = deepDepth[labels[p]] + 1\n    let\
    \ tree = initLCAFromParent(deepParent, labels[0])\n    for trial in 0..<1000:\n\
    \        let v = rng.rand(n - 1)\n        let k = rng.rand(deepDepth[v])\n   \
    \     var a = v\n        for i in 0..<k: a = deepParent[a]\n        doAssert tree.la(v,\
    \ k) == a\n        doAssert tree.la(v, deepDepth[v]) == labels[0]\n        doAssert\
    \ tree.la(v, deepDepth[v] + 1) == -1\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/lca.nim
  - cplib/tree/lca.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/lca_test.nim
  requiredBy: []
  timestamp: '2026-09-16 23:45:18+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lca_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lca_test.nim
- /verify/verify/AI/lca_test.nim.html
title: verify/AI/lca_test.nim
---
