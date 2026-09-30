---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/manhattan_mst.nim
    title: cplib/geometry/manhattan_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/manhattan_mst.nim
    title: cplib/geometry/manhattan_mst.nim
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
    import algorithm, random, sequtils\nimport cplib/geometry/base\nimport cplib/geometry/manhattan_mst\n\
    import cplib/collections/unionfind\n\nproc distance(a, b: (int64, int64)): int64\
    \ =\n    abs(a[0] - b[0]) + abs(a[1] - b[1])\n\nproc naiveWeights(points: seq[(int64,\
    \ int64)]): seq[int64] =\n    if points.len == 0:\n        return @[]\n    var\
    \ best = newSeqWith(points.len, high(int64))\n    var used = newSeq[bool](points.len)\n\
    \    best[0] = 0\n    for step in 0..<points.len:\n        var v = -1\n      \
    \  for i in 0..<points.len:\n            if not used[i] and (v < 0 or best[i]\
    \ < best[v]):\n                v = i\n        used[v] = true\n        if step\
    \ > 0:\n            result.add(best[v])\n        for i in 0..<points.len:\n  \
    \          if not used[i]:\n                best[i] = min(best[i], distance(points[v],\
    \ points[i]))\n    result.sort()\n\nproc check(points: seq[(int64, int64)]) =\n\
    \    let original = points\n    let edges = manhattan_mst(points)\n    doAssert\
    \ points == original\n    doAssert edges.len == max(0, points.len - 1)\n    let\
    \ uf = initUnionFind(points.len)\n    var weights: seq[int64]\n    for (u, v)\
    \ in edges:\n        doAssert 0 <= u and u < v and v < points.len\n        doAssert\
    \ not uf.issame(u, v)\n        uf.unite(u, v)\n        weights.add(distance(points[u],\
    \ points[v]))\n    doAssert uf.count == min(1, points.len)\n    weights.sort()\n\
    \    doAssert weights == naiveWeights(points), $points\n    doAssert manhattan_mst(points.mapIt(initPoint(it)))\
    \ == edges\n\ncheck(@[])\ncheck(@[(0'i64, 0'i64)])\ncheck(@[(0'i64, 0'i64), (3'i64,\
    \ 4'i64)])\ncheck(newSeqWith(100, (7'i64, -11'i64)))\ncheck(@[(0'i64, 0'i64),\
    \ (1'i64, 1'i64), (0'i64, 0'i64),\n    (0'i64, 1'i64), (1'i64, 0'i64), (1'i64,\
    \ 1'i64)])\n\nfor mask in 0..<512:\n    var points: seq[(int64, int64)]\n    for\
    \ i in 0..<9:\n        if (mask and (1 shl i)) != 0:\n            points.add((int64(i\
    \ div 3 - 1), int64(i mod 3 - 1)))\n    check(points)\n\nvar rng = initRand(20260930)\n\
    for direction in [(0'i64, 1'i64), (1'i64, 0'i64), (1'i64, 1'i64),\n        (1'i64,\
    \ -1'i64), (2'i64, 3'i64), (2'i64, -3'i64)]:\n    var points: seq[(int64, int64)]\n\
    \    for i in -60..60:\n        points.add((direction[0] * int64(i) + 17, direction[1]\
    \ * int64(i) - 31))\n    rng.shuffle(points)\n    check(points)\n\nconst bound\
    \ = high(int64) div 4\ncheck(@[(-bound, -bound), (bound, bound)])\ncheck(@[(-bound,\
    \ -bound), (-bound, bound), (bound, -bound), (bound, bound)])\ncheck(@[(-bound,\
    \ -bound), (bound, bound), (bound - 1, bound - 2),\n    (bound - 2, bound - 3),\
    \ (0'i64, 0'i64), (-1'i64, -1'i64)])\nfor trial in 0..<1500:\n    var points:\
    \ seq[(int64, int64)]\n    let n = rng.rand(0..70)\n    for i in 0..<n:\n    \
    \    if trial mod 3 == 0:\n            points.add((int64(rng.rand(-5..5)), int64(rng.rand(-5..5))))\n\
    \        elif trial mod 3 == 1:\n            points.add((int64(rng.rand(-10000..10000)),\
    \ int64(rng.rand(-10000..10000))))\n        else:\n            points.add((int64(rng.rand(-1_000_000_000..1_000_000_000)),\n\
    \                int64(rng.rand(-1_000_000_000..1_000_000_000))))\n    check(points)\n\
    \nblock:\n    var grid: seq[(int64, int64)]\n    for x in 0..<25:\n        for\
    \ y in 0..<25:\n            grid.add((int64(x), int64(y)))\n    rng.shuffle(grid)\n\
    \    check(grid)\n\ndoAssert manhattan_mst([(0, 0), (3, 4)]) == @[(0, 1)]\ndoAssert\
    \ manhattan_mst([initPoint(low(int32), high(int32)),\n    initPoint(high(int32),\
    \ low(int32))]) == @[(0, 1)]\ndoAssert manhattan_mst([(low(int8), high(int8)),\
    \ (high(int8), low(int8))]) == @[(0, 1)]\n\nblock:\n    const n = 200000\n   \
    \ var points = newSeq[(int64, int64)](n)\n    for i in 0..<n:\n        points[i]\
    \ = (int64(i), -int64(i))\n    rng.shuffle(points)\n    let edges = manhattan_mst(points)\n\
    \    doAssert edges.len == n - 1\n    let uf = initUnionFind(n)\n    for (u, v)\
    \ in edges:\n        doAssert distance(points[u], points[v]) == 2\n        doAssert\
    \ not uf.issame(u, v)\n        uf.unite(u, v)\n    doAssert uf.count == 1\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/geometry/manhattan_mst.nim
  - cplib/geometry/manhattan_mst.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/collections/unionfind.nim
  isVerificationFile: true
  path: verify/geometry/manhattan_mst_random_test.nim
  requiredBy: []
  timestamp: '2026-09-30 07:06:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/manhattan_mst_random_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/manhattan_mst_random_test.nim
- /verify/verify/geometry/manhattan_mst_random_test.nim.html
title: verify/geometry/manhattan_mst_random_test.nim
---
