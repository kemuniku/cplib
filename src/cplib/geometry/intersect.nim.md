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
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_INTERSECT:\n    const CPLIB_GEOMETRY_INTERSECT*\
    \ = 1\n    import cplib/geometry/base\n    import cplib/geometry/ccw\n    import\
    \ cplib/geometry/angle\n    proc intersect*[T](s1, s2: Segment[T], strict: bool\
    \ = false): bool =\n        if strict:\n            if ccw(s1, s2.s, true) ==\
    \ ON_SEGMENT: return online(s1, s2.t)\n            if ccw(s1, s2.t, true) == ON_SEGMENT:\
    \ return online(s1, s2.s)\n            if ccw(s2, s2.s, true) == ON_SEGMENT: return\
    \ online(s2, s2.t)\n            if ccw(s2, s2.t, true) == ON_SEGMENT: return online(s2,\
    \ s2.s)\n            return (ccw(s1, s2.s) * ccw(s1, s2.t) < 0) and (ccw(s2, s1.s)\
    \ * ccw(s2, s1.t) < 0)\n        return (ccw(s1, s2.s) * ccw(s1, s2.t) <= 0) and\
    \ (ccw(s2, s1.s) * ccw(s2, s1.t) <= 0)\n\n    proc intersect*[T](l1, l2: Line[T]):\
    \ bool =\n        if not is_parallel(l1, l2): return true\n        return online(l1,\
    \ l2.s)\n\n    proc cross_point*[T](l1, l2: Line[T]): Point[T] =\n        assert(intersect(l1,\
    \ l2))\n        if is_parallel(l1, l2): return l1.s\n        var d1 = cross(l1.vector,\
    \ l2.vector)\n        var d2 = cross(l1.vector, l1.t - l2.s)\n        return l2.s\
    \ + l2.vector * (d2 / d1)\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/angle.nim
  isVerificationFile: false
  path: cplib/geometry/intersect.nim
  requiredBy:
  - verify/geometry/CGL_2/intersect_past16m_test_.nim
  - verify/geometry/CGL_2/intersect_past16m_test_.nim
  - cplib/geometry/distance.nim
  - cplib/geometry/distance.nim
  timestamp: '2024-03-19 10:05:44+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - verify/geometry/CGL_2/cross_point_cgl2c_test.nim
  - verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - verify/geometry/CGL_2/intersect_cgl2b_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/distance_cgl2d_test.nim
  - verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
  - verify/geometry/CGL_2/cross_point_fraction_cgl2c_test.nim
documentation_of: cplib/geometry/intersect.nim
layout: document
redirect_from:
- /library/cplib/geometry/intersect.nim
- /library/cplib/geometry/intersect.nim.html
title: cplib/geometry/intersect.nim
---
