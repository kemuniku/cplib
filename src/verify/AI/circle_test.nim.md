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
    import math, random\nimport cplib/geometry/base\nimport cplib/geometry/circle\n\
    \nproc length(p: Point[float]): float = hypot(p.x, p.y)\nproc close(a, b: float,\
    \ scale = 1.0): bool = abs(a - b) <= 2e-8 * scale\nproc same(a, b: Point[float],\
    \ scale = 1.0): bool = length(a - b) <= 2e-8 * scale\nproc point(x, y: float):\
    \ Point[float] = initPoint(x, y)\nproc residual(c: Circle[float], p: Point[float],\
    \ scale = 1.0) =\n    doAssert close(length(p - c.center), c.radius, scale)\n\
    proc checkTangents(a, b: Circle[float], expected: int, scale = 1.0) =\n    let\
    \ res = common_tangents(a, b)\n    doAssert res.kind == circleFinite\n    doAssert\
    \ res.tangents.len == expected\n    for t in res.tangents:\n        residual(a,\
    \ t.first, scale)\n        residual(b, t.second, scale)\n        doAssert close(length(t.direction),\
    \ 1)\n        doAssert abs(dot(t.first - a.center, t.direction)) <= 2e-8 * scale\n\
    \        doAssert abs(dot(t.second - b.center, t.direction)) <= 2e-8 * scale\n\
    \        doAssert abs(cross(t.second - t.first, t.direction)) <= 2e-8 * scale\n\
    \    let reverse = common_tangents(b, a)\n    doAssert reverse.kind == res.kind\
    \ and reverse.tangents.len == res.tangents.len\n    for t in res.tangents:\n \
    \       var found = false\n        for r in reverse.tangents:\n            if\
    \ same(t.first, r.second, scale) and same(t.second, r.first, scale): found = true\n\
    \        doAssert found\n\nlet unit = initCircle(point(0, 0), 1)\ndoAssert unit.center.x\
    \ == 0 and unit.radius == 1\ndoAssert unit.contains(point(1, 0)) and not unit.contains(point(2,\
    \ 0))\ndoAssert initCircle(initPoint(0'i64, 0'i64), 2).radius == 2\nfor invalid\
    \ in [-1.0, system.Inf, NaN]:\n    var rejected = false\n    try: discard initCircle(point(0,\
    \ 0), invalid)\n    except ValueError: rejected = true\n    doAssert rejected\n\
    for invalid in [-1.0, 1.0, NaN]:\n    var rejected = false\n    try: discard unit.contains(point(0,\
    \ 0), invalid)\n    except ValueError: rejected = true\n    doAssert rejected\n\
    let zero = initCircle(point(0, 0), 0)\ndoAssert cross_points(unit, unit).kind\
    \ == circleInfinite\ndoAssert common_tangents(unit, unit).kind == circleInfinite\n\
    doAssert common_tangents(zero, zero).kind == circleInfinite\ndoAssert cross_points(zero,\
    \ zero).points.len == 1\ndoAssert cross_points(unit, zero).points.len == 0\ndoAssert\
    \ cross_points(unit, initCircle(point(0, 0), 1 + 1e-12)).points.len == 0\ndoAssert\
    \ tangent_lines(zero, point(0, 0)).kind == circleInfinite\ndoAssert tangent_lines(unit,\
    \ point(0, 0)).tangents.len == 0\ndoAssert tangent_lines(unit, point(1, 0)).tangents.len\
    \ == 1\ndoAssert tangent_lines(unit, point(2, 0)).tangents.len == 2\ncheckTangents(zero,\
    \ initCircle(point(2, 0), 0), 1)\ncheckTangents(unit, initCircle(point(3, 0),\
    \ 1), 4)\ncheckTangents(unit, initCircle(point(2, 0), 1), 3)\ncheckTangents(unit,\
    \ initCircle(point(1, 0), 1), 2)\ncheckTangents(initCircle(point(0, 0), 2), initCircle(point(1,\
    \ 0), 1), 1)\ncheckTangents(initCircle(point(0, 0), 2), initCircle(point(0.5,\
    \ 0), 1), 0)\ncheckTangents(unit, initCircle(point(1, 0), 0), 1)\nfor scale in\
    \ [1e-150, 1.0, 1e150]:\n    let a = initCircle(point(0, 0), scale)\n    let b\
    \ = initCircle(point(1.2 * scale, 0), scale)\n    let res = cross_points(a, b)\n\
    \    doAssert res.points.len == 2\n    for p in res.points:\n        residual(a,\
    \ p, scale)\n        residual(b, p, scale)\n    checkTangents(a, b, 2, scale)\n\
    \    let line = Line[float](s: point(-2 * scale, 0), t: point(2 * scale, 0))\n\
    \    doAssert cross_points(a, line).points.len == 2\n    let seg = Segment[float](s:\
    \ point(-scale, 0), t: point(0, 0))\n    doAssert cross_points(a, seg).points.len\
    \ == 1\n    doAssert cross_points(a, Segment[float](s: point(scale, 0), t: point(scale,\
    \ 0))).points.len == 1\n    doAssert cross_points(a, Segment[float](s: point(0,\
    \ 0), t: point(0, 0))).points.len == 0\n    doAssert cross_points(a, Line[float](s:\
    \ point(-scale, scale), t: point(scale, scale))).points.len == 1\nlet tinySeparation\
    \ = cross_points(unit, initCircle(point(1e-200, 0), 1))\ndoAssert tinySeparation.points.len\
    \ == 2\nfor p in tinySeparation.points: residual(unit, p)\nlet translated = initCircle(point(1e12,\
    \ -1e12), 100)\nfor p in cross_points(translated, initCircle(point(1e12 + 120,\
    \ -1e12), 100)).points:\n    residual(translated, p, 1e5)\n\nvar rng = initRand(612903)\n\
    for _ in 0..<2500:\n    let x = rng.rand(-20..20)\n    let y = rng.rand(-20..20)\n\
    \    let ra = rng.rand(0..10)\n    let rb = rng.rand(0..10)\n    let a = initCircle(point(0,\
    \ 0), ra)\n    let b = initCircle(point(float(x), float(y)), rb)\n    let dsq\
    \ = x * x + y * y\n    let sumsq = (ra + rb) * (ra + rb)\n    let diffsq = (ra\
    \ - rb) * (ra - rb)\n    let res = cross_points(a, b)\n    var expected = 0\n\
    \    if dsq == 0:\n        if ra == rb:\n            if ra == 0: expected = 1\n\
    \            else: doAssert res.kind == circleInfinite\n    elif dsq == sumsq\
    \ or dsq == diffsq: expected = 1\n    elif diffsq < dsq and dsq < sumsq: expected\
    \ = 2\n    doAssert res.points.len == expected\n    for p in res.points:\n   \
    \     residual(a, p)\n        residual(b, p)\n    let reverse = cross_points(b,\
    \ a)\n    doAssert reverse.kind == res.kind and reverse.points.len == res.points.len\n\
    \    for p in res.points:\n        var found = false\n        for q in reverse.points:\n\
    \            if same(p, q): found = true\n        doAssert found\n    if dsq >\
    \ 0:\n        var tangentCount = 0\n        if ra == 0 and rb == 0: tangentCount\
    \ = 1\n        elif ra == 0 or rb == 0:\n            if dsq == sumsq: tangentCount\
    \ = 1\n            elif dsq > sumsq: tangentCount = 2\n        else:\n       \
    \     if dsq == diffsq: tangentCount = 1\n            elif dsq > diffsq: tangentCount\
    \ = 2\n            if dsq == sumsq: inc tangentCount\n            elif dsq > sumsq:\
    \ tangentCount += 2\n        checkTangents(a, b, tangentCount)\n    let line =\
    \ Line[float](s: point(-30, float(y)), t: point(30, float(y)))\n    let lr = cross_points(a,\
    \ line)\n    let lineCount = if y * y == ra * ra: 1 elif y * y < ra * ra: 2 else:\
    \ 0\n    doAssert lr.points.len == lineCount\n    for p in lr.points:\n      \
    \  residual(a, p)\n        doAssert close(p.y, float(y))\n    let sl = Segment[float](s:\
    \ point(float(x), float(y)), t: point(float(x + 1), float(y)))\n    var segmentCount\
    \ = 0\n    for p in lr.points:\n        if p.x >= float(x) - 1e-9 and p.x <= float(x\
    \ + 1) + 1e-9: inc segmentCount\n    doAssert cross_points(a, sl).points.len ==\
    \ segmentCount\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/AI/circle_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/circle_test.nim
layout: document
redirect_from:
- /verify/verify/AI/circle_test.nim
- /verify/verify/AI/circle_test.nim.html
title: verify/AI/circle_test.nim
---
