---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/angle.nim
    title: cplib/geometry/angle.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/angle.nim
    title: cplib/geometry/angle.nim
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
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/distance.nim
    title: cplib/geometry/distance.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/distance.nim
    title: cplib/geometry/distance.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_INTERSECT:\n    const CPLIB_GEOMETRY_INTERSECT*\
    \ = 1\n    import cplib/geometry/base\n    import cplib/geometry/ccw\n    import\
    \ cplib/geometry/angle\n    proc intersect*[T](s1, s2: Segment[T], strict: bool\
    \ = false): bool =\n        ##\u7DDA\u5206 s1, s2 \u304C\u4EA4\u308F\u308B\u304B\
    \u3069\u3046\u304B\u3092\u5224\u5B9A\u3001\u7AEF\u70B9\u3067\u4EA4\u308F\u308B\
    \u5834\u5408\u3092\u542B\u3080\u5834\u5408\u306F strict = true \u3092\u8A2D\u5B9A\
    \n        if strict:\n            if ccw(s1, s2.s, true) == ON_SEGMENT: return\
    \ online(s1, s2.t)\n            if ccw(s1, s2.t, true) == ON_SEGMENT: return online(s1,\
    \ s2.s)\n            if ccw(s2, s2.s, true) == ON_SEGMENT: return online(s2, s2.t)\n\
    \            if ccw(s2, s2.t, true) == ON_SEGMENT: return online(s2, s2.s)\n \
    \           return (ccw(s1, s2.s) * ccw(s1, s2.t) < 0) and (ccw(s2, s1.s) * ccw(s2,\
    \ s1.t) < 0)\n        return (ccw(s1, s2.s) * ccw(s1, s2.t) <= 0) and (ccw(s2,\
    \ s1.s) * ccw(s2, s1.t) <= 0)\n\n    proc intersect*[T](l1, l2: Line[T]): bool\
    \ =\n        ## \u76F4\u7DDA l1, l2 \u304C\u4EA4\u308F\u308B\u304B\u3069\u3046\
    \u304B\u3092\u5224\u5B9A\n        if not is_parallel(l1, l2): return true\n  \
    \      return online(l1, l2.s)\n\n    proc cross_point*(l1, l2: Line[int]): Point[int]\
    \ = assert false, \"cross point can't be called for int type, please use float\
    \ or Fraction\"\n    proc cross_point*[T](l1, l2: Line[T]): Point[T] =\n     \
    \   ## 2\u76F4\u7DDA l1, l2 \u306E\u4EA4\u70B9\n        assert(intersect(l1, l2))\n\
    \        if is_parallel(l1, l2): return l1.s\n        var d1 = cross(l1.vector,\
    \ l2.vector)\n        var d2 = cross(l1.vector, l1.t - l2.s)\n        return l2.s\
    \ + l2.vector * (d2 / d1)\n"
  dependsOn:
  - cplib/geometry/angle.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/base.nim
  isVerificationFile: false
  path: cplib/geometry/intersect.nim
  requiredBy:
  - cplib/geometry/distance.nim
  - cplib/geometry/distance.nim
  - verify/geometry/CGL_2/intersect_past16m_test_.nim
  - verify/geometry/CGL_2/intersect_past16m_test_.nim
  timestamp: '2024-03-28 16:38:54+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/convex_hull_abc286ex_test.nim
  - verify/geometry/convex_hull_abc286ex_test.nim
  - verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - verify/geometry/CGL_2/cross_point_cgl2c_test.nim
documentation_of: cplib/geometry/intersect.nim
layout: document
redirect_from:
- /library/cplib/geometry/intersect.nim
- /library/cplib/geometry/intersect.nim.html
title: cplib/geometry/intersect.nim
---
