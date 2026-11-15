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
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle.nim
    title: cplib/geometry/circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/circle_integer_impl.nim
    title: cplib/geometry/circle_integer_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/minimum_enclosing_circle.nim
    title: cplib/geometry/minimum_enclosing_circle.nim
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
    import math, random, algorithm\nimport cplib/geometry/base\nimport cplib/geometry/circle\n\
    import cplib/geometry/minimum_enclosing_circle\n\ntype Candidate = tuple[x, y,\
    \ radius: float]\nproc oracle(points: seq[Point[float]]): float =\n    var candidates:\
    \ seq[Candidate]\n    for p in points: candidates.add((p.x, p.y, 0.0))\n    for\
    \ i in 0..<points.len:\n        for j in 0..<i:\n            let a = points[i]\n\
    \            let b = points[j]\n            candidates.add(((a.x + b.x) / 2, (a.y\
    \ + b.y) / 2, hypot(a.x - b.x, a.y - b.y) / 2))\n            for k in 0..<j:\n\
    \                let c = points[k]\n                let det = 2 * (a.x * (b.y\
    \ - c.y) + b.x * (c.y - a.y) + c.x * (a.y - b.y))\n                if det == 0:\
    \ continue\n                let aa = a.x * a.x + a.y * a.y\n                let\
    \ bb = b.x * b.x + b.y * b.y\n                let cc = c.x * c.x + c.y * c.y\n\
    \                let x = (aa * (b.y - c.y) + bb * (c.y - a.y) + cc * (a.y - b.y))\
    \ / det\n                let y = (aa * (c.x - b.x) + bb * (a.x - c.x) + cc * (b.x\
    \ - a.x)) / det\n                candidates.add((x, y, hypot(x - a.x, y - a.y)))\n\
    \    result = system.Inf\n    for candidate in candidates:\n        var feasible\
    \ = true\n        for p in points:\n            if hypot(p.x - candidate.x, p.y\
    \ - candidate.y) > candidate.radius + 1e-9:\n                feasible = false\n\
    \        if feasible: result = min(result, candidate.radius)\n\nproc check(points:\
    \ seq[Point[float]], expected: float, seed: int64 = 0, error = 1e-8) =\n    var\
    \ saved: seq[(float, float)]\n    for p in points: saved.add((p.x, p.y))\n   \
    \ let res = minimum_enclosing_circle(points, seed)\n    for i, p in points: doAssert\
    \ p.x == saved[i][0] and p.y == saved[i][1]\n    let circle = res\n    doAssert\
    \ abs(circle.radius - expected) <= error\n    for p in points:\n        doAssert\
    \ circle.contains(p, 0)\n        doAssert hypot(p.x - circle.center.x, p.y - circle.center.y)\
    \ <= circle.radius + error\n    let repeated = minimum_enclosing_circle(points,\
    \ seed)\n    doAssert repeated.center.x == circle.center.x and repeated.center.y\
    \ == circle.center.y\n    doAssert repeated.radius == circle.radius\n\nlet empty:\
    \ seq[Point[float]] = @[]\nvar emptyRejected = false\ntry: discard minimum_enclosing_circle(empty)\n\
    except ValueError: emptyRejected = true\ndoAssert emptyRejected\ncheck(@[initPoint(3.0,\
    \ 4.0)], 0)\ncheck(@[initPoint(3.0, 4.0), initPoint(3.0, 4.0)], 0)\ncheck(@[initPoint(-5.0,\
    \ 0.0), initPoint(2.0, 0.0), initPoint(5.0, 0.0)], 5)\ncheck(@[initPoint(0.0,\
    \ 0.0), initPoint(4.0, 0.0), initPoint(1.0, 1.0)], 2)\ncheck(@[initPoint(0.0,\
    \ 0.0), initPoint(2.0, 0.0), initPoint(1.0, sqrt(3.0))], 2 / sqrt(3.0))\nfor seed\
    \ in 0'i64..50'i64:\n    check(@[initPoint(0.0, 0.0), initPoint(1.0, 1e-13), initPoint(2.0,\
    \ 0.0), initPoint(3.0, -1e-13)], 1.5, seed)\nfor invalid in [-1.0, 1.0, system.Inf,\
    \ NaN]:\n    var rejected = false\n    try: discard minimum_enclosing_circle(empty,\
    \ tolerance = invalid)\n    except ValueError: rejected = true\n    doAssert rejected\n\
    for invalid in [system.Inf, NaN]:\n    var rejected = false\n    try: discard\
    \ minimum_enclosing_circle(@[initPoint(invalid, 0.0)])\n    except ValueError:\
    \ rejected = true\n    doAssert rejected\nlet ints = @[initPoint(0.0, 0.0), initPoint(4000000000.0,\
    \ 0.0)]\ndoAssert minimum_enclosing_circle(ints).radius == 2000000000.0\nlet singleHuge\
    \ = minimum_enclosing_circle(@[initPoint(1.7e308, 1.7e308)])\ndoAssert singleHuge.radius\
    \ == 0\nfor scale in [1e-150, 1.0, 1e150]:\n    check(@[initPoint(-scale, 0.0),\
    \ initPoint(scale, 0.0), initPoint(0.0, scale)], scale, error = scale * 1e-8)\n\
    \    check(@[initPoint(0.0, 0.0), initPoint(scale, 0.0)], scale / 2, error = scale\
    \ * 1e-8)\ncheck(@[initPoint(1e12 - 3, -1e12), initPoint(1e12 + 3, -1e12), initPoint(1e12,\
    \ -1e12 + 4)], 3.125, error = 0.001)\n\nlet sampleOne = @[initPoint(0.0, 0.0),\
    \ initPoint(1.0, 0.0)]\ncheck(sampleOne, 0.5)\nlet sampleTwo = @[initPoint(0.0,\
    \ 0.0), initPoint(0.0, 1.0), initPoint(1.0, 0.0)]\ncheck(sampleTwo, 0.707106781186497524)\n\
    let sampleThree = @[\n    initPoint(10.0, 9.0), initPoint(5.0, 9.0), initPoint(2.0,\
    \ 0.0),\n    initPoint(0.0, 0.0), initPoint(2.0, 7.0), initPoint(3.0, 3.0),\n\
    \    initPoint(2.0, 5.0), initPoint(10.0, 0.0), initPoint(3.0, 7.0), initPoint(1.0,\
    \ 9.0)]\ncheck(sampleThree, 6.726812023536805158)\n\nvar rng = initRand(409301)\n\
    for trial in 0..<2200:\n    var points: seq[Point[float]]\n    for _ in 0..<rng.rand(1..8):\n\
    \        points.add(initPoint(float(rng.rand(-10..10)), float(rng.rand(-10..10))))\n\
    \    let expected = oracle(points)\n    for seed in [0'i64, 1'i64, 612903'i64]:\
    \ check(points, expected, seed)\n    if trial < 30:\n        for scale in [1e-150,\
    \ 1e150]:\n            var scaled: seq[Point[float]]\n            for p in points:\
    \ scaled.add(initPoint(p.x * scale, p.y * scale))\n            check(scaled, expected\
    \ * scale, error = max(expected, 1.0) * scale * 1e-8)\n        var translated:\
    \ seq[Point[float]]\n        for p in points: translated.add(initPoint(p.x + 1e12,\
    \ p.y - 1e12))\n        check(translated, expected, error = 0.001)\n    points.reverse\n\
    \    check(points, expected, 42)\nvar stress: seq[Point[float]]\nfor i in 0..<10000:\n\
    \    let angle = 2 * PI * float(i) / 10000\n    stress.add(initPoint(cos(angle),\
    \ sin(angle)))\ncheck(stress, 1)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: true
  path: verify/AI/minimum_enclosing_circle_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/minimum_enclosing_circle_test.nim
layout: document
redirect_from:
- /verify/verify/AI/minimum_enclosing_circle_test.nim
- /verify/verify/AI/minimum_enclosing_circle_test.nim.html
title: verify/AI/minimum_enclosing_circle_test.nim
---
