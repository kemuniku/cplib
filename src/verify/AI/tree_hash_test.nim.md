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
    path: cplib/tree/tree_hash.nim
    title: cplib/tree/tree_hash.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree_hash.nim
    title: cplib/tree/tree_hash.nim
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
    include cplib/tree/tree_hash\nimport algorithm, tables\n\nproc slowMul(a, b: uint64):\
    \ uint64 =\n    ## \u52A0\u7B97\u3060\u3051\u3067\u5270\u4F59\u4E57\u7B97\u306E\
    \u6B63\u89E3\u3092\u6C42\u3081\u308B\u3002\n    var a = a\n    var b = b\n   \
    \ while b > 0:\n        if (b and 1) != 0: result = (result + a) mod TREE_HASH_MOD\n\
    \        a = (a + a) mod TREE_HASH_MOD\n        b = b shr 1\n\nproc canonical(g:\
    \ UnWeightedUnDirectedGraph, u, p: int): string =\n    ## \u5B50\u306E\u8868\u73FE\
    \u3092\u30BD\u30FC\u30C8\u3057\u3066\u6839\u4ED8\u304D\u6728\u306E\u540C\u578B\
    \u3092\u53B3\u5BC6\u306B\u5224\u5B9A\u3059\u308B\u3002\n    var children: seq[string]\n\
    \    for v in g[u]:\n        if v != p: children.add(canonical(g, v, u))\n   \
    \ children.sort()\n    result = \"(\"\n    for child in children: result.add(child)\n\
    \    result.add(\")\")\n\nproc naive(g: UnWeightedUnDirectedGraph, u, p: int,\n\
    \           hashes: var seq[uint64]): int =\n    ## \u5143\u30B3\u30FC\u30C9\u306E\
    \u518D\u5E30\u3068\u72EC\u7ACB\u3057\u305F\u5270\u4F59\u4E57\u7B97\u3067\u90E8\
    \u5206\u6728\u30CF\u30C3\u30B7\u30E5\u3092\u6C42\u3081\u308B\u3002\n    var product\
    \ = 1'u64\n    for v in g[u]:\n        if v == p: continue\n        result = max(result,\
    \ naive(g, v, u, hashes) + 1)\n        product = slowMul(product, hashes[v])\n\
    \    hashes[u] = (product + treeHashDepth[result]) mod TREE_HASH_MOD\n\nvar rng\
    \ = initRand(20260906)\nlet limits = @[0'u64, 1'u64, TREE_HASH_MOD - 2, TREE_HASH_MOD\
    \ - 1]\nfor a in limits:\n    for b in limits: doAssert treeHashMul(a, b) == slowMul(a,\
    \ b)\nfor i in 0..<1000:\n    let a = rng.rand(0'u64..TREE_HASH_MOD - 1)\n   \
    \ let b = rng.rand(0'u64..TREE_HASH_MOD - 1)\n    doAssert treeHashMul(a, b) ==\
    \ slowMul(a, b)\n\ndoAssert initUnWeightedUnDirectedGraph(0).tree_hash() ==\n\
    \    (newSeq[uint64](), newSeq[uint64]())\nvar shapeToHash = initTable[string,\
    \ uint64]()\nvar hashToShape = initTable[uint64, string]()\nfor n in 1..35:\n\
    \    for trial in 0..<8:\n        var g = initUnWeightedUnDirectedGraph(n)\n \
    \       var directed = initUnWeightedDirectedGraph(n)\n        var staticG = initUnWeightedUnDirectedStaticGraph(n)\n\
    \        var weighted = initWeightedUnDirectedGraph(n, float)\n        var weightedStatic\
    \ = initWeightedUnDirectedStaticGraph(n, int64)\n        var directedStatic =\
    \ initUnWeightedDirectedStaticGraph(n)\n        var weightedDirected = initWeightedDirectedGraph(n)\n\
    \        var weightedDirectedStatic = initWeightedDirectedStaticGraph(n)\n   \
    \     for v in 1..<n:\n            let p = rng.rand(v - 1)\n            g.add_edge(p,\
    \ v)\n            directed.add_edge(p, v)\n            staticG.add_edge(p, v)\n\
    \            weighted.add_edge(p, v, float(v))\n            weightedStatic.add_edge(p,\
    \ v, int64(v))\n            directedStatic.add_edge(p, v)\n            weightedDirected.add_edge(p,\
    \ v, v)\n            weightedDirectedStatic.add_edge(p, v, v)\n        staticG.build()\n\
    \        weightedStatic.build()\n        directedStatic.build()\n        weightedDirectedStatic.build()\n\
    \        let hashes = g.tree_hash()\n        doAssert hashes.subtree == directed.subtree_hash()\n\
    \        doAssert hashes.subtree == directedStatic.subtree_hash()\n        doAssert\
    \ hashes.subtree == weightedDirected.subtree_hash()\n        doAssert hashes.subtree\
    \ == weightedDirectedStatic.subtree_hash()\n        doAssert hashes == staticG.tree_hash()\n\
    \        doAssert hashes == weighted.tree_hash()\n        doAssert hashes == weightedStatic.tree_hash()\n\
    \        for root in 0..<n:\n            let actual = g.tree_hash(root)\n    \
    \        var expected = newSeq[uint64](n)\n            discard naive(g, root,\
    \ -1, expected)\n            doAssert actual.subtree == expected\n           \
    \ doAssert actual.subtree == g.subtree_hash(root)\n            doAssert actual.all_roots\
    \ == hashes.all_roots\n            doAssert actual.all_roots[root] == expected[root]\n\
    \            let shape = canonical(g, root, -1)\n            let hash = actual.all_roots[root]\n\
    \            if shape in shapeToHash: doAssert shapeToHash[shape] == hash\n  \
    \          if hash in hashToShape: doAssert hashToShape[hash] == shape\n     \
    \       shapeToHash[shape] = hash\n            hashToShape[hash] = shape\n   \
    \     var reversed = initUnWeightedUnDirectedGraph(n)\n        for u in countdown(n\
    \ - 1, 0):\n            for v in g[u]:\n                if u < v: reversed.add_edge(n\
    \ - 1 - v, n - 1 - u)\n        let reversedHashes = reversed.all_roots_hash(n\
    \ - 1)\n        for v in 0..<n:\n            doAssert reversedHashes[n - 1 - v]\
    \ == hashes.all_roots[v]\n\nblock:\n    let saved = treeHashDepth[0]\n    treeHashDepth[0]\
    \ = TREE_HASH_MOD - 1\n    var g = initUnWeightedUnDirectedGraph(5)\n    for v\
    \ in 1..<5: g.add_edge(0, v)\n    let hashes = g.tree_hash()\n    doAssert hashes.subtree[1]\
    \ == 0\n    for root in 0..<5:\n        var expected = newSeq[uint64](5)\n   \
    \     discard naive(g, root, -1, expected)\n        doAssert hashes.all_roots[root]\
    \ == expected[root]\n    treeHashDepth[0] = saved\n\nblock:\n    const n = 200000\n\
    \    var path = initUnWeightedUnDirectedGraph(n)\n    var star = initUnWeightedUnDirectedGraph(n)\n\
    \    for v in 1..<n:\n        path.add_edge(v - 1, v)\n        star.add_edge(0,\
    \ v)\n    let pathHashes = path.all_roots_hash()\n    for v in 0..<n: doAssert\
    \ pathHashes[v] == pathHashes[n - 1 - v]\n    let starHashes = star.all_roots_hash(n\
    \ - 1)\n    for v in 2..<n: doAssert starHashes[v] == starHashes[1]\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/tree_hash.nim
  - cplib/graph/graph.nim
  - cplib/tree/tree_hash.nim
  isVerificationFile: true
  path: verify/AI/tree_hash_test.nim
  requiredBy: []
  timestamp: '2026-09-06 08:45:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/tree_hash_test.nim
layout: document
redirect_from:
- /verify/verify/AI/tree_hash_test.nim
- /verify/verify/AI/tree_hash_test.nim.html
title: verify/AI/tree_hash_test.nim
---
