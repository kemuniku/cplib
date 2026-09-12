---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/hopcroft_karp.nim
    title: cplib/graph/hopcroft_karp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/hopcroft_karp.nim
    title: cplib/graph/hopcroft_karp.nim
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
    import cplib/graph/hopcroft_karp\nimport random\n\nproc brute(edges: seq[seq[bool]],\
    \ right: int): int =\n    var dp = newSeq[int](1 shl right)\n    for row in edges:\n\
    \        var next = dp\n        for mask in 0..<dp.len:\n            for u in\
    \ 0..<right:\n                if row[u] and (mask and (1 shl u)) == 0:\n     \
    \               let target = mask or (1 shl u)\n                    next[target]\
    \ = max(next[target], dp[mask] + 1)\n        dp = next\n    for count in dp:\n\
    \        result = max(result, count)\n\nproc check(g: var HopcroftKarp, edges:\
    \ seq[seq[bool]], right: int) =\n    let expected = brute(edges, right)\n    var\
    \ plain = g\n    doAssert plain.matching(useRelabel = false) == expected\n   \
    \ doAssert g.matching() == expected\n    doAssert g.matching() == expected\n \
    \   for pairs in [g.get_matching(), plain.get_matching()]:\n        doAssert pairs.len\
    \ == expected\n        var usedLeft = newSeq[bool](edges.len)\n        var usedRight\
    \ = newSeq[bool](right)\n        for (v, u) in pairs:\n            doAssert edges[v][u]\n\
    \            doAssert not usedLeft[v] and not usedRight[u]\n            usedLeft[v]\
    \ = true\n            usedRight[u] = true\n\nfor left in 0..3:\n    for right\
    \ in 0..4:\n        for mask in 0..<(1 shl (left * right)):\n            var g\
    \ = initHopcroftKarp(left, right)\n            var edges = newSeq[seq[bool]](left)\n\
    \            for v in 0..<left:\n                edges[v] = newSeq[bool](right)\n\
    \                for u in 0..<right:\n                    if (mask and (1 shl\
    \ (v * right + u))) != 0:\n                        edges[v][u] = true\n      \
    \                  g.add_edge(v, u)\n            g.check(edges, right)\n\nvar\
    \ rng = initRand(712367)\nfor trial in 0..<500:\n    let left = rng.rand(1..10)\n\
    \    let right = rng.rand(1..8)\n    var g = initHopcroftKarp(left, right)\n \
    \   var edges = newSeq[seq[bool]](left)\n    for v in 0..<left:\n        edges[v]\
    \ = newSeq[bool](right)\n    for step in 0..<40:\n        let v = rng.rand(left\
    \ - 1)\n        let u = rng.rand(right - 1)\n        g.add_edge(v, u)\n      \
    \  edges[v][u] = true\n        if step mod 5 == 0:\n            g.check(edges,\
    \ right)\n    g.check(edges, right)\n\nfor trial in 0..<400:\n    let left = rng.rand(1..12)\n\
    \    let right = rng.rand(1..8)\n    var g = initHopcroftKarp(left, right)\n \
    \   var edges = newSeq[seq[bool]](left)\n    for v in 0..<left:\n        edges[v]\
    \ = newSeq[bool](right)\n    for step in 0..<rng.rand(0..left * right):\n    \
    \    let v = rng.rand(left - 1)\n        let u = rng.rand(right - 1)\n       \
    \ g.add_edge(v, u)\n        edges[v][u] = true\n    g.check(edges, right)\n\n\
    block:\n    const n = 128 * 129 div 2\n    var g = initHopcroftKarp(n, n)\n  \
    \  var offset = 0\n    for length in 1..128:\n        for v in offset..<offset\
    \ + length - 1:\n            g.add_edge(v, v)\n            g.add_edge(v, v + 1)\n\
    \        g.add_edge(offset + length - 1, offset)\n        offset += length\n \
    \   doAssert g.matching() == n\n    let pairs = g.get_matching()\n    offset =\
    \ 0\n    for length in 1..128:\n        for v in offset..<offset + length - 1:\n\
    \            doAssert pairs[v] == (v, v + 1)\n        doAssert pairs[offset +\
    \ length - 1] == (offset + length - 1, offset)\n        offset += length\n\nblock:\n\
    \    const n = 200000\n    var g = initHopcroftKarp(n, n)\n    for v in 0..<n\
    \ - 1:\n        g.add_edge(v, v)\n        g.add_edge(v, v + 1)\n    g.add_edge(n\
    \ - 1, 0)\n    doAssert g.matching() == n\n    let pairs = g.get_matching()\n\
    \    for v in 0..<n - 1:\n        doAssert pairs[v] == (v, v + 1)\n    doAssert\
    \ pairs[n - 1] == (n - 1, 0)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/hopcroft_karp.nim
  - cplib/graph/hopcroft_karp.nim
  isVerificationFile: true
  path: verify/AI/hopcroft_karp_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/hopcroft_karp_test.nim
layout: document
redirect_from:
- /verify/verify/AI/hopcroft_karp_test.nim
- /verify/verify/AI/hopcroft_karp_test.nim.html
title: verify/AI/hopcroft_karp_test.nim
---
