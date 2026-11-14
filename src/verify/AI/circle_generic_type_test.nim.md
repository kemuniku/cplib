---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
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
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
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
    import math\nimport cplib/geometry/base\nimport cplib/geometry/circle\nimport\
    \ cplib/geometry/minimum_enclosing_circle\nimport cplib/math/fractions\nimport\
    \ cplib/math/int128\nimport cplib/math/bigint\n\nlet integer = initCircle(initPoint(0,\
    \ 0), 2)\nlet floating = initCircle(initPoint(0, 0), 2.0)\nlet float32Circle =\
    \ initCircle(initPoint(0'f32, 0'f32), 2'f32)\nlet mixedPoints = initCircle(initPoint(2,\
    \ 0), initPoint(0.0, 2.0), initPoint(-2'f32, 0'f32))\nlet mixedThrough = initCircle(initPoint(0,\
    \ 0), initPoint(2.0, 0.0))\nlet fractionMixed = initCircle(initPoint(initFraction(0),\
    \ initFraction(0)), 2.0)\nlet int128Mixed = initCircle(initPoint(parseInt128(\"\
    0\"), parseInt128(\"0\")), 2.0)\nlet bigMixed = initCircle(initPoint(initBigInt(0),\
    \ initBigInt(0)), 2.0)\nstatic:\n    doAssert typeof(integer) is Circle[int]\n\
    \    doAssert typeof(integer.center) is Point[Fraction[int]]\n    doAssert typeof(integer.radius)\
    \ is float\n    doAssert typeof(floating) is Circle[float]\n    doAssert typeof(float32Circle)\
    \ is Circle[float]\n    doAssert typeof(mixedPoints) is Circle[float]\n    doAssert\
    \ typeof(mixedThrough) is Circle[float]\n    doAssert typeof(fractionMixed) is\
    \ Circle[float]\n    doAssert typeof(int128Mixed) is Circle[float]\n    doAssert\
    \ typeof(bigMixed) is Circle[float]\n    doAssert typeof(minimum_enclosing_circle(@[initPoint(0'f32,\
    \ 0'f32)])) is Circle[float]\n    doAssert typeof(minimum_enclosing_circle(@[initPoint(0,\
    \ 0)])) is Circle[int]\n    doAssert not declared(ExactCircle)\n    doAssert not\
    \ declared(MinimumExactCircle)\nfor c in [floating, float32Circle, mixedPoints,\
    \ mixedThrough, fractionMixed, int128Mixed, bigMixed]:\n    doAssert c == floating\n\
    \    doAssert c.center.x == 0 and c.radius == 2\n    doAssert c.classify(initPoint(0,\
    \ 0)) == circleInside\n    doAssert c.classify(initPoint(2, 0)) == circleBoundary\n\
    \    doAssert c.classify(initPoint(3, 0)) == circleOutside\n    doAssert c.on_circle(initPoint(2,\
    \ 0))\n    doAssert c.intersection_count(Line[int](s: initPoint(-3, 0), t: initPoint(3,\
    \ 0))) == 2\n    doAssert c.intersection_count(Segment[int](s: initPoint(0, 0),\
    \ t: initPoint(3, 0))) == 1\n    doAssert c.tangent_count(initPoint(3, 0)) ==\
    \ 2\n    doAssert c.common_tangent_count(initCircle(initPoint(5.0, 0.0), 2)) ==\
    \ 4\n    doAssert c.cross_points_approx(Line[int](s: initPoint(-3, 0), t: initPoint(3,\
    \ 0))).points.len == 2\n    doAssert c.tangent_lines_approx(initPoint(3, 0)).tangents.len\
    \ == 2\nlet minimum128 = parseInt128(\"-170141183460469231731687303715884105728\"\
    )\nlet minimumMixed = initCircle(initPoint(minimum128, parseInt128(\"0\")), 0.0)\n\
    doAssert minimumMixed.center.x < -1.7e38 and minimumMixed.radius == 0\nlet minimumFraction\
    \ = Fraction[int](num: low(int), den: 1)\nlet fractionMinimumMixed = initCircle(initPoint(minimumFraction,\
    \ initFraction(0)), 0.0)\ndoAssert fractionMinimumMixed.center.x < -9e18\nlet\
    \ negativeDenMixed = initCircle(initPoint(Fraction[int](num: -1, den: -2), Fraction[int](num:\
    \ 1, den: -2)), 0.0)\ndoAssert negativeDenMixed.center.x == 0.5 and negativeDenMixed.center.y\
    \ == -0.5\nvar annotated: Circle[float] = floating\nproc returnAnnotated(): Circle[float]\
    \ = annotated\ndoAssert returnAnnotated() == floating\nfor points in [@[initPoint(2.0,\
    \ 0.0), initPoint(0.0, 2.0), initPoint(-2.0, 0.0)],\n               @[initPoint(-2.0,\
    \ 0.0), initPoint(0.0, 2.0), initPoint(2.0, 0.0)]]:\n    doAssert initCircle(points[0],\
    \ points[1], points[2]) == floating\nlet diameter = initDiameterCircle(initPoint(0'f32,\
    \ 0'f32), initPoint(1'f32, 0'f32))\ndoAssert diameter.center.x == 0.5 and diameter.radius\
    \ == 0.5\nfor points in [@[initPoint(0.0, 0.0), initPoint(1.0, 0.0), initPoint(2.0,\
    \ 0.0)],\n               @[initPoint(0.0, 0.0), initPoint(0.0, 0.0), initPoint(1.0,\
    \ 0.0)]]:\n    var rejected = false\n    try: discard initCircle(points[0], points[1],\
    \ points[2])\n    except ValueError: rejected = true\n    doAssert rejected\n\
    for scale in [1e-150, 1e150]:\n    let c = initCircle(initPoint(scale, 0.0), initPoint(0.0,\
    \ scale), initPoint(-scale, 0.0))\n    doAssert abs(c.radius / scale - 1) < 1e-10\n\
    let z = initCircle(initPoint(1.0, 2.0), initPoint(1.0, 2.0), initPoint(1.0, 2.0))\n\
    doAssert z.radius == 0 and z.center == initPoint(1.0, 2.0)\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/math/bigint.nim
  - cplib/math/isprime.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/math/isqrt.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/math/bigint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/geometry/base.nim
  - cplib/convolution/convolution.nim
  - cplib/math/int128.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/geometry/circle.nim
  - cplib/math/int128.nim
  - cplib/math/fractions.nim
  - cplib/convolution/convolution.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/AI/circle_generic_type_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/circle_generic_type_test.nim
layout: document
redirect_from:
- /verify/verify/AI/circle_generic_type_test.nim
- /verify/verify/AI/circle_generic_type_test.nim.html
title: verify/AI/circle_generic_type_test.nim
---
