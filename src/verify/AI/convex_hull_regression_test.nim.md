---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/polygon.nim
    title: cplib/geometry/polygon.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import algorithm, random, sequtils, sets\nimport cplib/geometry/base\nimport cplib/geometry/polygon\n\
    import cplib/math/fractions\n\nproc oracle(input: seq[Point[int]], strict: bool):\
    \ seq[Point[int]] =\n    var points: seq[Point[int]]\n    for p in input:\n  \
    \      if p notin points: points.add(p)\n    if points.len <= 1: return points\n\
    \    let first = points.min\n    var current = first\n    var corners: seq[Point[int]]\n\
    \    while true:\n        corners.add(current)\n        var next = points[0]\n\
    \        for p in points:\n            if p == current: continue\n           \
    \ let turn = cross(next - current, p - current)\n            if next == current\
    \ or turn < 0 or\n                    (turn == 0 and norm(p - current) > norm(next\
    \ - current)):\n                next = p\n        current = next\n        if current\
    \ == first: break\n        doAssert corners.len <= points.len\n    if strict:\
    \ return corners\n    if corners.len == 2: return points.sorted\n    for i, a\
    \ in corners:\n        let b = corners[(i + 1) mod corners.len]\n        var edge:\
    \ seq[Point[int]]\n        for p in points:\n            if p != b and cross(b\
    \ - a, p - a) == 0 and dot(p - a, p - b) <= 0:\n                edge.add(p)\n\
    \        edge.sort(proc(p, q: Point[int]): int = cmp(norm(p - a), norm(q - a)))\n\
    \        result.add(edge)\n\nproc check(points: seq[Point[int]]) =\n    let original\
    \ = points\n    for strict in [false, true]:\n        let expected = oracle(points,\
    \ strict)\n        let actual = convex_hull(points, strict).v\n        doAssert\
    \ actual == expected, $points & \" / \" & $strict & \" / \" & $actual & \" / \"\
    \ & $expected\n        doAssert points == original\n        doAssert actual.toHashSet.len\
    \ == actual.len\n        doAssert convex_hull(actual, strict).v == actual\n  \
    \      for reflected in [false, true]:\n            let floats = points.mapIt(initPoint(float(it.x),\
    \ float(if reflected: -it.y else: it.y)))\n            let transformed = points.mapIt(initPoint(it.x,\
    \ if reflected: -it.y else: it.y))\n            let floatExpected = oracle(transformed,\
    \ strict).mapIt(initPoint(float(it.x), float(it.y)))\n            doAssert convex_hull(floats,\
    \ strict).v.mapIt(it.toPointKey) == floatExpected.mapIt(it.toPointKey)\n     \
    \   let fractions = points.mapIt(initPoint(initFraction(it.x), initFraction(it.y)))\n\
    \        let fractionExpected = expected.mapIt(initPoint(initFraction(it.x), initFraction(it.y)))\n\
    \        doAssert convex_hull(fractions, strict).v == fractionExpected\n\ncheck(@[])\n\
    check(@[initPoint(0, 0)])\ncheck(@[initPoint(2, 1), initPoint(0, 0)])\ncheck(newSeqWith(10,\
    \ initPoint(2, 3)))\ncheck(@[initPoint(0, 0), initPoint(0, 0), initPoint(1, 1)])\n\
    check(@[initPoint(0, 0), initPoint(1, 0), initPoint(2, 0)])\ncheck(@[initPoint(0,\
    \ 0), initPoint(0, 1), initPoint(0, 2)])\ncheck(@[initPoint(0, 0), initPoint(1,\
    \ 1), initPoint(2, 2)])\ncheck(@[initPoint(-1, 1), initPoint(0, 0), initPoint(1,\
    \ -1)])\n\nvar rng = initRand(20261003)\nfor mask in 0..<512:\n    var points:\
    \ seq[Point[int]]\n    for i in 0..<9:\n        if (mask and (1 shl i)) != 0:\n\
    \            points.add(initPoint(i div 3 - 1, i mod 3 - 1))\n    check(points)\n\
    \    points.add(points)\n    rng.shuffle(points)\n    check(points)\nfor trial\
    \ in 0..<500:\n    var points: seq[Point[int]]\n    for i in 0..<rng.rand(0..20):\n\
    \        points.add(initPoint(rng.rand(-10..10), rng.rand(-10..10)))\n    check(points)\n\
    \nblock:\n    let points = @[initPoint(0.0, 0.0), initPoint(1e-12, 0.0),\n   \
    \     initPoint(1.0, 0.0), initPoint(1.0, 1.0), initPoint(0.0, 1.0)]\n    doAssert\
    \ convex_hull(points, false).v.mapIt(it.toPointKey) == points.mapIt(it.toPointKey)\n\
    \    doAssert convex_hull(points).v.mapIt(it.toPointKey) == @[points[0], points[2],\
    \ points[3], points[4]].mapIt(it.toPointKey)\n    let small = points.mapIt(initPoint(float32(it.x),\
    \ float32(it.y)))\n    doAssert convex_hull(small, false).v.mapIt(it.toPointKey)\
    \ == small.mapIt(it.toPointKey)\n    let fraction32 = @[initPoint(initFraction(0'i32),\
    \ initFraction(0'i32)),\n        initPoint(initFraction(1'i32), initFraction(0'i32)),\n\
    \        initPoint(initFraction(0'i32), initFraction(1'i32))]\n    doAssert convex_hull(fraction32).v\
    \ == fraction32\n    let oldEps = GEOMETRY_EPS\n    GEOMETRY_EPS = 1\n    doAssert\
    \ convex_hull(points, false).v.mapIt(it.toPointKey) == points.mapIt(it.toPointKey)\n\
    \    GEOMETRY_EPS = oldEps\n    let tiny = @[initPoint(0.0, 0.0), initPoint(1e-12,\
    \ 0.0), initPoint(0.0, 1e-12)]\n    doAssert convex_hull(tiny).v.mapIt(it.toPointKey)\
    \ == tiny.mapIt(it.toPointKey)\n    var shuffledTiny = tiny\n    for repeat in\
    \ 0..<20:\n        rng.shuffle(shuffledTiny)\n        doAssert convex_hull(shuffledTiny).v.mapIt(it.toPointKey)\
    \ == tiny.mapIt(it.toPointKey)\n    let near = @[initPoint(0.0, 0.0), initPoint(1e-12,\
    \ 0.0)]\n    doAssert near[0] == near[1]\n    doAssert convex_hull(near.reversed).v.mapIt(it.toPointKey)\
    \ == near.mapIt(it.toPointKey)\n\nblock:\n    const n = 10000\n    var line: seq[Point[int]]\n\
    \    for i in 0..<n:\n        line.add(initPoint(i, -i))\n        line.add(initPoint(i,\
    \ -i))\n    rng.shuffle(line)\n    doAssert convex_hull(line).v == @[initPoint(0,\
    \ 0), initPoint(n-1, 1-n)]\n    doAssert convex_hull(line, false).len == n\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/math/fractions.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/polygon.nim
  - cplib/math/fractions.nim
  - cplib/geometry/polygon.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/AI/convex_hull_regression_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:20:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/convex_hull_regression_test.nim
layout: document
redirect_from:
- /verify/verify/AI/convex_hull_regression_test.nim
- /verify/verify/AI/convex_hull_regression_test.nim.html
title: verify/AI/convex_hull_regression_test.nim
---
