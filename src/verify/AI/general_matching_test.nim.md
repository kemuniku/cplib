---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':question:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
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
    import random, bitops, sets\nimport cplib/graph/graph\nimport cplib/graph/general_matching\n\
    \ntype Edge = tuple[u, v: int]\n\nproc brute(n: int, edges: seq[Edge]): int =\n\
    \    var adj = newSeq[int](n)\n    for (u, v) in edges:\n        if u == v: continue\n\
    \        adj[u] = adj[u] or (1 shl v)\n        adj[v] = adj[v] or (1 shl u)\n\
    \    var dp = newSeq[int](1 shl n)\n    for mask in 1..<dp.len:\n        let u\
    \ = countTrailingZeroBits(mask)\n        let rest = mask xor (1 shl u)\n     \
    \   dp[mask] = dp[rest]\n        var candidates = adj[u] and rest\n        while\
    \ candidates != 0:\n            let v = countTrailingZeroBits(candidates)\n  \
    \          candidates = candidates and (candidates - 1)\n            dp[mask]\
    \ = max(dp[mask], 1 + dp[rest xor (1 shl v)])\n    dp[^1]\n\nproc validate(n:\
    \ int, edges, answer: seq[Edge], want: int) =\n    var edgeSet = initHashSet[Edge]()\n\
    \    for (u, v) in edges: edgeSet.incl((min(u, v), max(u, v)))\n    var used =\
    \ newSeq[bool](n)\n    for (u, v) in answer:\n        doAssert u in 0..<n and\
    \ v in 0..<n and u != v\n        doAssert not used[u] and not used[v]\n      \
    \  doAssert (min(u, v), max(u, v)) in edgeSet\n        used[u] = true\n      \
    \  used[v] = true\n    doAssert answer.len == want, $n & \" \" & $edges & \" got\
    \ \" & $answer & \" want \" & $want\n\nproc check(n: int, edges: seq[Edge], expected\
    \ = -1) =\n    let want = if expected < 0: brute(n, edges) else: expected\n  \
    \  var g = initUnWeightedUnDirectedGraph(n)\n    var sg = initUnWeightedUnDirectedStaticGraph(n)\n\
    \    var wg = initWeightedUnDirectedGraph(n, int64)\n    var wsg = initWeightedUnDirectedStaticGraph(n,\
    \ float)\n    for i, e in edges:\n        let (u, v) = e\n        g.add_edge(u,\
    \ v)\n        sg.add_edge(u, v)\n        wg.add_edge(u, v, int64(i mod 7 - 3))\n\
    \        wsg.add_edge(u, v, float(i mod 5 - 2))\n    sg.build()\n    wsg.build()\n\
    \    let before = g.edges\n    let answer = g.maximum_matching()\n    validate(n,\
    \ edges, answer, want)\n    doAssert g.maximum_matching() == answer\n    doAssert\
    \ g.edges == before\n    validate(n, edges, sg.maximum_matching(), want)\n   \
    \ validate(n, edges, wg.maximum_matching(), want)\n    validate(n, edges, wsg.maximum_matching(),\
    \ want)\n\nstatic:\n    doAssert not compiles(initUnWeightedDirectedGraph(2).maximum_matching())\n\
    \    doAssert not compiles(initWeightedDirectedGraph(2).maximum_matching())\n\
    \    doAssert not compiles(initUnWeightedDirectedStaticGraph(2).maximum_matching())\n\
    \    doAssert not compiles(initWeightedDirectedStaticGraph(2).maximum_matching())\n\
    \ncheck(0, @[])\ncheck(1, @[(0, 0)])\ncheck(8, @[])\nfor n in 1..6:\n    var all:\
    \ seq[Edge]\n    for u in 0..<n:\n        for v in u+1..<n: all.add((u, v))\n\
    \    for mask in 0..<(1 shl all.len):\n        var edges: seq[Edge]\n        for\
    \ i, e in all:\n            if (mask and (1 shl i)) != 0: edges.add(e)\n     \
    \   check(n, edges)\n\nvar rng = initRand(712367)\nfor trial in 0..<3000:\n  \
    \  let n = rng.rand(2..16)\n    var edges: seq[Edge]\n    let density = rng.rand(5..95)\n\
    \    for u in 0..<n:\n        for v in u..<n:\n            if rng.rand(99) < density:\n\
    \                edges.add((u, v))\n                if rng.rand(9) == 0: edges.add((v,\
    \ u))\n    rng.shuffle(edges)\n    check(n, edges)\n\nblock:\n    var g = initUnWeightedUnDirectedGraph(4)\n\
    \    g.add_edge(1, 2)\n    doAssert g.maximum_matching().len == 1\n    g.add_edge(0,\
    \ 1)\n    g.add_edge(2, 3)\n    doAssert g.maximum_matching().len == 2\n\nfor\
    \ n in [100, 1000, 10000]:\n    var path, cycle, star, triangles: seq[Edge]\n\
    \    for v in 1..<n:\n        path.add((v - 1, v))\n        star.add((0, v))\n\
    \    cycle = path & @[(n - 1, 0)]\n    for i in 0..<n div 3:\n        let v =\
    \ i * 3\n        triangles.add((v, v + 1))\n        triangles.add((v + 1, v +\
    \ 2))\n        triangles.add((v + 2, v))\n        if i > 0: triangles.add((v -\
    \ 1, v))\n    check(n, path, n div 2)\n    check(n, cycle, n div 2)\n    check(n,\
    \ star, 1)\n    check(n, triangles, (n div 3 * 3) div 2)\n\nblock:\n    let n\
    \ = 100000\n    var edges: seq[Edge]\n    for v in countup(1, n - 3, 2): edges.add((v,\
    \ v + 1))\n    for v in countup(0, n - 2, 2): edges.add((v, v + 1))\n    check(n,\
    \ edges, n div 2)\n\nblock:\n    var n = 0\n    var edges, remaining: seq[Edge]\n\
    \    for k in 1..50:\n        for v in countup(1, 2*k - 3, 2): edges.add((n +\
    \ v, n + v + 1))\n        for v in countup(0, 2*k - 2, 2): remaining.add((n +\
    \ v, n + v + 1))\n        n += 2*k\n    check(n, edges & remaining, n div 2)\n\
    check(100000, @[(99998, 99999), (2, 2)], 1)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/general_matching.nim
  - cplib/graph/graph.nim
  - cplib/graph/general_matching.nim
  isVerificationFile: true
  path: verify/AI/general_matching_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/general_matching_test.nim
layout: document
redirect_from:
- /verify/verify/AI/general_matching_test.nim
- /verify/verify/AI/general_matching_test.nim.html
title: verify/AI/general_matching_test.nim
---
