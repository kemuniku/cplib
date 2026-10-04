---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching.nim
    title: cplib/graph/general_weighted_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching.nim
    title: cplib/graph/general_weighted_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching_sparse.nim
    title: cplib/graph/general_weighted_matching_sparse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_weighted_matching_sparse.nim
    title: cplib/graph/general_weighted_matching_sparse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/internal/weighted_matching_engine.nim
    title: cplib/graph/internal/weighted_matching_engine.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/internal/weighted_matching_engine.nim
    title: cplib/graph/internal/weighted_matching_engine.nim
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
    import random, bitops, tables\nimport cplib/graph/graph\nimport cplib/graph/general_weighted_matching\n\
    import cplib/graph/general_weighted_matching_sparse\nimport cplib/graph/general_matching\n\
    \ntype Edge = tuple[u, v: int, w: int64]\n\nproc brute(n: int, edges: seq[Edge]):\
    \ int64 =\n    var weights = newSeq[seq[int64]](n)\n    for row in weights.mitems:\
    \ row = newSeq[int64](n)\n    for (u, v, w) in edges:\n        if u == v: continue\n\
    \        weights[u][v] = max(weights[u][v], w)\n        weights[v][u] = max(weights[v][u],\
    \ w)\n    var dp = newSeq[int64](1 shl n)\n    for mask in 1..<dp.len:\n     \
    \   let u = countTrailingZeroBits(mask)\n        let rest = mask xor (1 shl u)\n\
    \        dp[mask] = dp[rest]\n        var candidates = rest\n        while candidates\
    \ != 0:\n            let v = countTrailingZeroBits(candidates)\n            candidates\
    \ = candidates and (candidates - 1)\n            dp[mask] = max(dp[mask], weights[u][v]\
    \ + dp[rest xor (1 shl v)])\n    dp[^1]\n\nproc validate(n: int, edges: seq[Edge],\
    \ answer: tuple[weight: int64, matching: seq[tuple[u, v: int]]], want: int64)\
    \ =\n    var weights = initTable[(int, int), int64]()\n    for (u, v, w) in edges:\n\
    \        let key = (min(u, v), max(u, v))\n        weights[key] = max(weights.getOrDefault(key),\
    \ w)\n    var used = newSeq[bool](n)\n    var total = 0'i64\n    for (u, v) in\
    \ answer.matching:\n        doAssert u in 0..<n and v in 0..<n and u < v\n   \
    \     doAssert not used[u] and not used[v]\n        doAssert (u, v) in weights\
    \ and weights[(u, v)] > 0\n        used[u] = true\n        used[v] = true\n  \
    \      total += weights[(u, v)]\n    doAssert total == answer.weight\n    doAssert\
    \ answer.weight == want, $n & \" \" & $edges & \" got \" & $answer & \" want \"\
    \ & $want\n\nproc check(n: int, edges: seq[Edge], expected = -1'i64) =\n    let\
    \ want = if expected < 0: brute(n, edges) else: expected\n    var g = initWeightedUnDirectedGraph(n,\
    \ int64)\n    var sg = initWeightedUnDirectedStaticGraph(n, int64)\n    for (u,\
    \ v, w) in edges:\n        g.add_edge(u, v, w)\n        sg.add_edge(u, v, w)\n\
    \    sg.build()\n    let before = g.edges\n    let infoBefore = g.edge_info\n\
    \    let staticBefore = sg.elist\n    let answer = g.maximum_weight_matching_sparse()\n\
    \    validate(n, edges, answer, want)\n    validate(n, edges, g.maximum_weight_matching(),\
    \ want)\n    validate(n, edges, sg.maximum_weight_matching_sparse(), want)\n \
    \   doAssert g.maximum_weight_matching_sparse() == answer\n    doAssert g.edges\
    \ == before and g.edge_info == infoBefore\n    doAssert sg.elist == staticBefore\
    \ and sg.edge_info == infoBefore\n\nstatic:\n    doAssert not compiles(initWeightedDirectedGraph(2).maximum_weight_matching_sparse())\n\
    \    doAssert not compiles(initWeightedDirectedStaticGraph(2).maximum_weight_matching_sparse())\n\
    \    doAssert not compiles(initUnWeightedUnDirectedGraph(2).maximum_weight_matching_sparse())\n\
    \    doAssert not compiles(initWeightedUnDirectedGraph(2, float).maximum_weight_matching_sparse())\n\
    \    doAssert not compiles(initWeightedUnDirectedGraph(2, uint64).maximum_weight_matching_sparse())\n\
    \ncheck(0, @[])\ncheck(1, @[(0, 0, high(int64))])\ncheck(9, @[])\ncheck(3, @[(0,\
    \ 1, low(int64)), (1, 2, 0'i64), (0, 0, 7'i64)])\ncheck(4, @[(0, 1, 10'i64), (1,\
    \ 2, 25'i64), (2, 3, 10'i64)], 25)\ncheck(4, @[(0, 1, 10'i64), (1, 2, 19'i64),\
    \ (2, 3, 10'i64)], 20)\ncheck(4, @[(0, 1, 5'i64), (1, 0, 20'i64), (0, 1, 7'i64),\
    \ (2, 3, 11'i64)], 31)\ncheck(6, @[(0, 1, 8'i64), (1, 2, 8'i64), (2, 0, 8'i64),\n\
    \    (0, 3, 7'i64), (1, 4, 7'i64), (2, 5, 7'i64)], 21)\ncheck(10, @[(0, 1, 20'i64),\
    \ (1, 2, 20'i64), (2, 0, 20'i64),\n    (2, 3, 19'i64), (3, 4, 19'i64), (4, 0,\
    \ 19'i64),\n    (0, 5, 18'i64), (1, 6, 18'i64), (2, 7, 18'i64),\n    (3, 8, 18'i64),\
    \ (4, 9, 18'i64)])\nblock:\n    let w = high(int64) div 4 div 6\n    check(6,\
    \ @[(0, 1, w), (1, 2, w - 1), (2, 0, w - 2),\n        (0, 3, w - 3), (1, 4, w\
    \ - 4), (2, 5, w - 5)])\n\nfor mask in 0..<4096:\n    var code = mask\n    var\
    \ edges: seq[Edge]\n    for u in 0..<4:\n        for v in u + 1..<4:\n       \
    \     let digit = code mod 4\n            code = code div 4\n            if digit\
    \ > 0: edges.add((u, v, [-2'i64, 1, 4][digit - 1]))\n    check(4, edges)\n\nvar\
    \ rng = initRand(981723)\nfor trial in 0..<2500:\n    let n = rng.rand(2..14)\n\
    \    let density = rng.rand(5..100)\n    let scale = if trial mod 4 == 0: 100000000003'i64\
    \ else: 1'i64\n    var edges: seq[Edge]\n    for u in 0..<n:\n        for v in\
    \ u..<n:\n            if rng.rand(99) < density:\n                edges.add((u,\
    \ v, int64(rng.rand(-10..30)) * scale))\n                if rng.rand(9) == 0:\n\
    \                    edges.add((v, u, int64(rng.rand(-10..30)) * scale))\n   \
    \ rng.shuffle(edges)\n    check(n, edges)\n\nfor n in [30, 70, 120]:\n    var\
    \ g = initWeightedUnDirectedGraph(n)\n    var edges: seq[Edge]\n    for u in 0..<n:\n\
    \        for v in u + 1..<n:\n            if rng.rand(99) < 15:\n            \
    \    g.add_edge(u, v, 17)\n                edges.add((u, v, 17'i64))\n    validate(n,\
    \ edges, g.maximum_weight_matching_sparse(), 17'i64 * int64(g.maximum_matching().len))\n\
    \nblock:\n    var g = initWeightedUnDirectedGraph(4, int32)\n    g.add_edge(1,\
    \ 2, 2000000000'i32)\n    doAssert g.maximum_weight_matching_sparse().weight ==\
    \ 2000000000'i64\n    g.add_edge(0, 1, 1500000000'i32)\n    g.add_edge(2, 3, 1500000000'i32)\n\
    \    doAssert g.maximum_weight_matching_sparse().weight == 3000000000'i64\nblock:\n\
    \    var g = initWeightedUnDirectedStaticGraph(3, int16)\n    g.add_edge(0, 1,\
    \ 13'i16)\n    g.add_edge(1, 2, 17'i16)\n    g.build()\n    doAssert g.maximum_weight_matching_sparse().weight\
    \ == 17\n    g.add_edge(2, 0, 21'i16)\n    g.build()\n    doAssert g.maximum_weight_matching_sparse().weight\
    \ == 21\nblock:\n    var g = initWeightedUnDirectedGraph(2, int8)\n    g.add_edge(1,\
    \ 0, 127'i8)\n    doAssert g.maximum_weight_matching_sparse() == (127'i64, @[(0,\
    \ 1)])\n\ncheck(100000, @[(99999, 99998, 27'i64), (4, 5, -1'i64), (0, 0, 100'i64)],\
    \ 27)\nfor trial in 0..<150:\n    let n = rng.rand(20..100)\n    var g = initWeightedUnDirectedGraph(n,\
    \ int64)\n    var edges: seq[Edge]\n    for u in 0..<n:\n        for v in u +\
    \ 1..<n:\n            if rng.rand(99) < 25:\n                let w = if trial\
    \ mod 3 == 0: int64(rng.rand(999990..1000000)) else: int64(rng.rand(1..1000000))\n\
    \                g.add_edge(u, v, w)\n                edges.add((u, v, w))\n \
    \   validate(n, edges, g.maximum_weight_matching_sparse(), g.maximum_weight_matching().weight)\n\
    \nfor n in [1000, 10000]:\n    var g = initWeightedUnDirectedGraph(n)\n    for\
    \ v in 1..<n: g.add_edge(v - 1, v, 23)\n    doAssert g.maximum_weight_matching_sparse().weight\
    \ == int64(n div 2) * 23\n\nblock:\n    var g = initWeightedUnDirectedGraph(3)\n\
    \    for w in 1..10000:\n        g.add_edge(0, 1, w)\n        g.add_edge(1, 2,\
    \ w + 1)\n        g.add_edge(2, 0, w + 2)\n    doAssert g.maximum_weight_matching_sparse().weight\
    \ == 10002\n\nblock:\n    let count = 2100\n    var g = initWeightedUnDirectedGraph(2\
    \ * count + 1)\n    for i in 0..<count:\n        let a = 2 * i + 1\n        let\
    \ b = a + 1\n        g.add_edge(0, a, 1)\n        g.add_edge(a, b, 1)\n      \
    \  g.add_edge(b, 0, 1)\n    doAssert g.maximum_weight_matching_sparse().weight\
    \ == int64(count)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/general_matching.nim
  - cplib/graph/internal/weighted_matching_engine.nim
  - cplib/graph/general_weighted_matching.nim
  - cplib/graph/graph.nim
  - cplib/graph/internal/weighted_matching_engine.nim
  - cplib/graph/general_weighted_matching.nim
  - cplib/graph/graph.nim
  - cplib/graph/general_matching.nim
  - cplib/graph/general_weighted_matching_sparse.nim
  - cplib/graph/general_weighted_matching_sparse.nim
  isVerificationFile: true
  path: verify/AI/general_weighted_matching_sparse_test.nim
  requiredBy: []
  timestamp: '2026-09-29 03:00:17+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/general_weighted_matching_sparse_test.nim
layout: document
redirect_from:
- /verify/verify/AI/general_weighted_matching_sparse_test.nim
- /verify/verify/AI/general_weighted_matching_sparse_test.nim.html
title: verify/AI/general_weighted_matching_sparse_test.nim
---
