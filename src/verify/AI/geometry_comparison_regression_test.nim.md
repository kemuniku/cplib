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
    import algorithm, hashes, sets, tables, random, sequtils\nimport cplib/geometry/base\n\
    import cplib/math/fractions\n\nlet originalEps = GEOMETRY_EPS\nblock:\n    doAssert\
    \ geometry_eq(1e9, 1e9 + 0.01)\n    doAssert geometry_eq(-1e9, -1e9 - 0.01)\n\
    \    let values = @[-1e12, -1e9, -1.0, -1e-12, 0.0, 1e-12, 1.0, 1e9, 1e12]\n \
    \   for a in values:\n        for b in values:\n            doAssert geometry_eq(a,\
    \ b) == geometry_eq(b, a)\n            doAssert geometry_eq(a, b) == geometry_eq(-a,\
    \ -b)\n            doAssert geometry_lt(a, b) == geometry_gt(b, a)\n    GEOMETRY_EPS\
    \ = 0.125\n    doAssert geometry_eq(8.0, 9.1) == geometry_eq(9.1, 8.0)\n    doAssert\
    \ geometry_eq(8.0, 9.1)\n    doAssert geometry_eq(0.0, 0.0625)\n    doAssert not\
    \ geometry_eq(0.0, 0.125)\n    doAssert not geometry_eq(1.0, 2.0)\n    GEOMETRY_EPS\
    \ = 0\n    doAssert geometry_eq(3.0, 3.0)\n    doAssert not geometry_eq(3.0, 3.0\
    \ + 1e-12)\n    doAssert geometry_eq(0.0, -0.0)\n    doAssert geometry_eq(system.Inf,\
    \ system.Inf)\n    doAssert geometry_eq(-system.Inf, -system.Inf)\n    doAssert\
    \ not geometry_eq(system.Inf, -system.Inf)\n    doAssert not geometry_eq(system.Inf,\
    \ 1.0)\n    doAssert not geometry_eq(1.0, system.Inf)\n    doAssert not geometry_eq(NaN,\
    \ NaN)\n    GEOMETRY_EPS = originalEps\n    doAssert not geometry_eq(system.Inf,\
    \ 1.0)\n    doAssert not geometry_eq(NaN, 0.0)\n    doAssert geometry_eq(1, 1.0)\n\
    \    doAssert geometry_eq(-1.0, -1)\n\nproc checkFloatPoints[T: SomeFloat]() =\n\
    \    let p = initPoint(T(1), T(2))\n    let delta = (when T is float32: T(1e-6)\
    \ else: T(1e-12))\n    let q = initPoint(T(1) + delta, T(2))\n    GEOMETRY_EPS\
    \ = 1e-5\n    doAssert p == q and p.almost_equal(q) and not p.exact_equal(q)\n\
    \    doAssert p < q and cmp(p, q) == -1 and cmp(q, p) == 1\n    let pk = p.toPointKey\n\
    \    let qk = q.toPointKey\n    doAssert pk != qk\n    var seen = initHashSet[PointKey[T]]()\n\
    \    var table = initTable[PointKey[T], int]()\n    seen.incl(pk)\n    seen.incl(qk)\n\
    \    table[pk] = 1\n    table[qk] = 2\n    doAssert seen.len == 2 and pk in seen\
    \ and qk in seen\n    doAssert table[pk] == 1 and table[qk] == 2\n    let zero\
    \ = initPoint(T(0), T(0))\n    let negativeZero = initPoint(-T(0), -T(0))\n  \
    \  doAssert zero == negativeZero and zero.exact_equal(negativeZero)\n    doAssert\
    \ hash(zero.toPointKey) == hash(negativeZero.toPointKey)\n    seen.incl(zero.toPointKey)\n\
    \    doAssert negativeZero.toPointKey in seen\n    let tiny = initPoint(T(1e-12),\
    \ T(0))\n    doAssert zero == tiny and not zero.exact_equal(tiny)\n    when compileOption(\"\
    assertions\"):\n        var lineRejected, segmentRejected = false\n        try:\n\
    \            discard initLine(zero, tiny)\n        except AssertionDefect:\n \
    \           lineRejected = true\n        try:\n            discard initSegment(zero,\
    \ tiny)\n        except AssertionDefect:\n            segmentRejected = true\n\
    \        doAssert lineRejected and segmentRejected\n    doAssert initLine(zero,\
    \ p).t.exact_equal(p)\n    doAssert initSegment(zero, p).t.exact_equal(p)\n  \
    \  GEOMETRY_EPS = 1\n    doAssert table[p.toPointKey] == 1 and table[q.toPointKey]\
    \ == 2 and seen.len == 3\n    GEOMETRY_EPS = 0\n    doAssert p != q and table[pk]\
    \ == 1 and table[qk] == 2\n    GEOMETRY_EPS = originalEps\n\nstatic:\n    doAssert\
    \ not compiles(hash(initPoint(0.0, 0.0)))\n    doAssert not compiles(hash(initPoint(0.0'f32,\
    \ 0.0'f32)))\n    doAssert not compiles(block:\n        var seen = initHashSet[Point[float]]()\n\
    \        seen.incl(initPoint(1.0, 2.0)))\n    doAssert not compiles(block:\n \
    \       var table = initTable[Point[float], int]()\n        table[initPoint(1.0,\
    \ 2.0)] = 1)\n\ncheckFloatPoints[float32]()\ncheckFloatPoints[float64]()\n\nblock:\n\
    \    let a = initPoint(0.0, 0.0)\n    let b = initPoint(0.75e-10, 0.0)\n    let\
    \ c = initPoint(1.5e-10, 0.0)\n    doAssert a == b and b == c and a != c\n   \
    \ doAssert a < b and b < c and a < c\n    doAssert cmp(a, b) == -1 and cmp(b,\
    \ a) == 1\n    doAssert a.toPointKey != b.toPointKey and b.toPointKey != c.toPointKey\n\
    \nblock:\n    let a = initPoint(0.0, 2.0)\n    let b = initPoint(0.75e-10, 1.0)\n\
    \    let c = initPoint(1.5e-10, 0.0)\n    doAssert a < b and b < c and a < c\n\
    \    var points = @[a, b, c, a, initPoint(-0.0, 2.0)]\n    var rng = initRand(20261003)\n\
    \    for i in 0..<100:\n        points.add(initPoint(float(rng.rand(-10..10))\
    \ * 1e-11,\n            float(rng.rand(-10..10))))\n    for p in points:\n   \
    \     doAssert not (p < p)\n        for q in points:\n            doAssert (cmp(p,\
    \ q) == 0) == exact_equal(p, q)\n            doAssert cmp(p, q) == -cmp(q, p)\n\
    \            doAssert (p <= q) == (p < q or exact_equal(p, q))\n            doAssert\
    \ (p >= q) == (q <= p)\n            for r in points:\n                if p < q\
    \ and q < r: doAssert p < r\n    let expected = points.sorted(proc(p, q: Point[float]):\
    \ int =\n        cmp((p.x, p.y), (q.x, q.y)))\n    for i in 0..<20:\n        rng.shuffle(points)\n\
    \        let actual = points.sorted(proc(p, q: Point[float]): int = cmp(p, q))\n\
    \        doAssert actual.mapIt(it.toPointKey) == expected.mapIt(it.toPointKey)\n\
    \        points.sort(proc(p, q: Point[float]): int = cmp(p, q), Descending)\n\
    \        doAssert points.mapIt(it.toPointKey) == expected.reversed.mapIt(it.toPointKey)\n\
    \nblock:\n    let p = initPoint(initFraction(1, 2), initFraction(3, 4))\n    let\
    \ q = initPoint(initFraction(2, 4, false), initFraction(6, 8, false))\n    doAssert\
    \ p == q and p.almost_equal(q)\n    doAssert hash(p) == hash(q)\n    var seen\
    \ = initHashSet[Point[Fraction[int]]]()\n    seen.incl(p)\n    doAssert q in seen\n\
    \    doAssert initPoint(1, 2) < initPoint(1, 3)\n    doAssert not almost_equal(initPoint(1,\
    \ 2), initPoint(1, 3))\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/AI/geometry_comparison_regression_test.nim
  requiredBy: []
  timestamp: '2026-10-06 01:57:50+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/geometry_comparison_regression_test.nim
layout: document
redirect_from:
- /verify/verify/AI/geometry_comparison_regression_test.nim
- /verify/verify/AI/geometry_comparison_regression_test.nim.html
title: verify/AI/geometry_comparison_regression_test.nim
---
