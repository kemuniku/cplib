---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/distance.nim
    title: cplib/geometry/distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/distance.nim
    title: cplib/geometry/distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  - icon: ':warning:'
    path: verify/geometry/CGL_2/intersect_past16m_test_.nim
    title: verify/geometry/CGL_2/intersect_past16m_test_.nim
  - icon: ':warning:'
    path: verify/geometry/CGL_2/intersect_past16m_test_.nim
    title: verify/geometry/CGL_2/intersect_past16m_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/cross_point_cgl2c_test.nim
    title: verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/cross_point_cgl2c_test.nim
    title: verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
    title: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
    title: verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/distance_cgl2d_test.nim
    title: verify/geometry/CGL_2/distance_cgl2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/distance_cgl2d_test.nim
    title: verify/geometry/CGL_2/distance_cgl2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/intersect_cgl2b_test.nim
    title: verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/intersect_cgl2b_test.nim
    title: verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/parallel_cgl2a_float_test.nim
    title: verify/geometry/CGL_2/parallel_cgl2a_float_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/parallel_cgl2a_float_test.nim
    title: verify/geometry/CGL_2/parallel_cgl2a_float_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
    title: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
    title: verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/parallel_cgl2a_test.nim
    title: verify/geometry/CGL_2/parallel_cgl2a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_2/parallel_cgl2a_test.nim
    title: verify/geometry/CGL_2/parallel_cgl2a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/convex_hull_abc286ex_test.nim
    title: verify/geometry/convex_hull_abc286ex_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/convex_hull_abc286ex_test.nim
    title: verify/geometry/convex_hull_abc286ex_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_ANGLE:\n    const CPLIB_GEOMETRY_ANGLE*\
    \ = 1\n    import cplib/geometry/base\n    const ANGLE_0* = 0;\n    const ANGLE_0_90*\
    \ = 1;\n    const ANGLE_90* = 2;\n    const ANGLE_90_180* = 3;\n    const ANGLE_180*\
    \ = 4;\n    const ANGLE_180_270* = -3;\n    const ANGLE_270* = -2;\n    const\
    \ ANGLE_270_360* = -1;\n\n    proc angle*[T](p1, p2: Point[T]): int =\n      \
    \  ##p1, p2\u306E\u306A\u3059\u89D2\u3092\u516B\u65B9\u4F4D\u3067\u8FD4\u3059\n\
    \        proc iszero(p: Point[T]): bool = geometry_eq(p1.x, 0) and geometry_eq(p1.y,\
    \ 0)\n        assert (not iszero(p1)) and (not iszero(p2))\n        var d = dot(p1,\
    \ p2)\n        var c = cross(p1, p2)\n        if geometry_eq(c, 0):\n        \
    \    if geometry_gt(c, 0): return ANGLE_0\n            else: return ANGLE_180\n\
    \        if geometry_eq(d, 0):\n            if geometry_gt(c, 0): return ANGLE_90\n\
    \            else: return ANGLE_270\n        if geometry_gt(d, 0) and geometry_gt(c,\
    \ 0): return ANGLE_0_90\n        if geometry_lt(d, 0) and geometry_gt(c, 0): return\
    \ ANGLE_90_180\n        if geometry_lt(d, 0) and geometry_lt(c, 0): return ANGLE_180_270\n\
    \        if geometry_gt(d, 0) and geometry_lt(c, 0): return ANGLE_270_360\n\n\
    \    proc angle*[T](l1, l2: Line[T]): int = angle(l1.vector, l2.vector)\n    type\
    \ PointOrLine = Point or Line\n    proc is_parallel*(p1, p2: PointOrLine): bool\
    \ =\n        ##p1, p2\u304C\u5E73\u884C\u304B\u3069\u3046\u304B\u3092\u5224\u5B9A\
    \n        var a = angle(p1, p2)\n        return (a == ANGLE_0) or (a == ANGLE_180)\n\
    \    proc is_orthogonal*(p1, p2: PointOrLine): bool =\n        ##p1, p2\u304C\u76F4\
    \u89D2\u304B\u3069\u3046\u304B\u3092\u5224\u5B9A\n        var a = angle(p1, p2)\n\
    \        return (a == ANGLE_90) or (a == ANGLE_270)\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  isVerificationFile: false
  path: cplib/geometry/angle.nim
  requiredBy:
  - verify/geometry/CGL_2/intersect_past16m_test_.nim
  - verify/geometry/CGL_2/intersect_past16m_test_.nim
  - cplib/geometry/distance.nim
  - cplib/geometry/distance.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/intersect.nim
  timestamp: '2024-03-20 10:45:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/parallel_cgl2a_float_test.nim
  - verify/geometry/CGL_2/parallel_cgl2a_float_test.nim
  - verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
  - verify/geometry/CGL_2/parallel_cgl2a_fraction_test.nim
  - verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - verify/geometry/CGL_2/parallel_cgl2a_test.nim
  - verify/geometry/CGL_2/parallel_cgl2a_test.nim
  - verify/geometry/convex_hull_abc286ex_test.nim
  - verify/geometry/convex_hull_abc286ex_test.nim
documentation_of: cplib/geometry/angle.nim
layout: document
redirect_from:
- /library/cplib/geometry/angle.nim
- /library/cplib/geometry/angle.nim.html
title: cplib/geometry/angle.nim
---
