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
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    import cplib/geometry/base\nimport cplib/geometry/circle\nimport cplib/geometry/minimum_enclosing_circle\n\
    import cplib/math/int128\nimport cplib/math/fractions\n\nproc check[T](zero, one:\
    \ T) =\n    let o = initPoint(zero, zero)\n    let p = initPoint(one, zero)\n\
    \    let c = initCircle(o, p)\n    let d = initDiameterCircle(o, p)\n    let m\
    \ = minimum_enclosing_circle(@[o, p])\n    static:\n        doAssert typeof(c)\
    \ is Circle[T]\n        doAssert typeof(d) is Circle[T]\n        doAssert typeof(m)\
    \ is Circle[T]\n        doAssert typeof(c.points[0].x) is T\n        doAssert\
    \ typeof(d.point_scale) is T\n        when T is Fraction:\n            doAssert\
    \ typeof(c.center_exact.x.num) is typeof(zero.num)\n            doAssert typeof(c.radius_squared_exact.num)\
    \ is typeof(zero.num)\n        else:\n            doAssert typeof(c.center_exact)\
    \ is Point[Fraction[T]]\n            doAssert typeof(c.radius_squared_exact) is\
    \ Fraction[T]\n    doAssert c.contains(o) and c.on_circle(p)\n    doAssert intersection_count(c,\
    \ m) == 1\n    doAssert common_tangent_count(c, m) == 1\n    doAssert tangent_count(m,\
    \ p) == 1\n    doAssert intersection_count(m, Line[T](s: o, t: p)) == 2\n    doAssert\
    \ intersection_count(m, Segment[T](s: o, t: p)) == 2\n    doAssert cross_points_approx(m,\
    \ c).points.len == 1\n    doAssert tangent_lines_approx(c, p).tangents.len ==\
    \ 1\n    doAssert c.radius_approx == 1\n    doAssert m.radius_approx == 0.5 and\
    \ m.center_approx.x == 0.5\n    for q in m.points_exact: doAssert m.on_circle(q)\n\
    \ncheck(0, 1)\ncheck(parseInt128(\"0\"), parseInt128(\"1\"))\ncheck(initFraction(0),\
    \ initFraction(1))\ncheck(initFraction(parseInt128(\"0\")), initFraction(parseInt128(\"\
    1\")))\nstatic:\n    doAssert not declared(CPLIB_MATH_BIGINT)\n    doAssert not\
    \ compiles(initCircle(initPoint(0'u64, 0'u64), 1))\necho \"Hello World\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: true
  path: verify/AI/exact_circle_type_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/exact_circle_type_test.nim
layout: document
redirect_from:
- /verify/verify/AI/exact_circle_type_test.nim
- /verify/verify/AI/exact_circle_type_test.nim.html
title: verify/AI/exact_circle_type_test.nim
---
