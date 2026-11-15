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
    import cplib/geometry/base\nimport cplib/geometry/circle\nimport cplib/geometry/minimum_enclosing_circle\n\
    let c = initCircle(initPoint(0, 0), 1)\nlet d = initCircle(initPoint(2, 0), 1)\n\
    doAssert c.contains(initPoint(0, 0))\ndoAssert c.on_circle(initPoint(1, 0))\n\
    doAssert c.classify(initPoint(2, 0)) == circleOutside\ndoAssert intersection_count(c,\
    \ d) == 1\ndoAssert common_tangent_count(c, d) == 3\ndoAssert intersection_count(c,\
    \ Line[int](s: initPoint(-2, 0), t: initPoint(2, 0))) == 2\ndoAssert intersection_count(c,\
    \ Segment[int](s: initPoint(-1, 0), t: initPoint(0, 0))) == 1\ndoAssert cross_points_approx(c,\
    \ d).points.len == 1\ndoAssert tangent_lines_approx(c, initPoint(2, 0)).tangents.len\
    \ == 2\ndoAssert c.center_approx.x == 0 and c.radius_approx == 1\nlet mec = minimum_enclosing_circle(@[initPoint(0,\
    \ 0), initPoint(1, 0)])\ndoAssert mec.contains(initPoint(0, 0)) and mec.contains(initPoint(1,\
    \ 0))\ndoAssert mec.center_approx.x == 0.5 and mec.radius_approx == 0.5\nstatic:\n\
    \    doAssert typeof(c) is Circle[int]\n    doAssert typeof(c.radius_squared_exact.num)\
    \ is int\n    doAssert typeof(c.center_exact.x.num) is int\n    doAssert typeof(c.points[0].x)\
    \ is int\n    doAssert typeof(mec) is Circle[int]\n    doAssert typeof(mec.point_scale)\
    \ is int\n    doAssert not declared(CPLIB_MATH_BIGINT)\n    doAssert not declared(CPLIB_MATH_INT128)\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/minimum_enclosing_circle.nim
  - cplib/geometry/circle.nim
  - cplib/geometry/circle_integer_impl.nim
  - cplib/geometry/circle_integer_impl.nim
  isVerificationFile: true
  path: verify/AI/exact_circle_import_test.nim
  requiredBy: []
  timestamp: '2026-11-15 07:34:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/exact_circle_import_test.nim
layout: document
redirect_from:
- /verify/verify/AI/exact_circle_import_test.nim
- /verify/verify/AI/exact_circle_import_test.nim.html
title: verify/AI/exact_circle_import_test.nim
---
