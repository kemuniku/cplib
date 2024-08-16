---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/base.nim
    title: cplib/geometry/base.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/projection_cgl1a_test.nim
    title: verify/geometry/CGL_1/projection_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/projection_cgl1a_test.nim
    title: verify/geometry/CGL_1/projection_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
    title: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
    title: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/reflection_cgl1a_test.nim
    title: verify/geometry/CGL_1/reflection_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/reflection_cgl1a_test.nim
    title: verify/geometry/CGL_1/reflection_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/reflection_fractions_cgl1a_test.nim
    title: verify/geometry/CGL_1/reflection_fractions_cgl1a_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/geometry/CGL_1/reflection_fractions_cgl1a_test.nim
    title: verify/geometry/CGL_1/reflection_fractions_cgl1a_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GEOMETRY_PROJECTION:\n    const CPLIB_GEOMETRY_PROJECTION*\
    \ = 1\n    import cplib/geometry/base\n    proc projection*[T](l: Line[T], p:\
    \ Point[T]): Point[T] =\n        ##\u76F4\u7DDA l \u3078\u306E\u70B9 p \u306E\u5C04\
    \u5F71\n        var t = dot(p - l.s, l.vector) / norm(l.vector)\n        return\
    \ l.s + l.vector * t\n    proc reflection*[T](l: Line[T], p: Point[T]): Point[T]\
    \ =\n        ##\u70B9 p \u306E\u76F4\u7DDA l \u306B\u5BFE\u3059\u308B\u53CD\u5C04\
    \n        p + (projection(l, p) - p) * 2\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  isVerificationFile: false
  path: cplib/geometry/projection.nim
  requiredBy: []
  timestamp: '2024-03-28 16:38:54+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/geometry/CGL_1/reflection_fractions_cgl1a_test.nim
  - verify/geometry/CGL_1/reflection_fractions_cgl1a_test.nim
  - verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
  - verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
  - verify/geometry/CGL_1/reflection_cgl1a_test.nim
  - verify/geometry/CGL_1/reflection_cgl1a_test.nim
  - verify/geometry/CGL_1/projection_cgl1a_test.nim
  - verify/geometry/CGL_1/projection_cgl1a_test.nim
documentation_of: cplib/geometry/projection.nim
layout: document
redirect_from:
- /library/cplib/geometry/projection.nim
- /library/cplib/geometry/projection.nim.html
title: cplib/geometry/projection.nim
---
