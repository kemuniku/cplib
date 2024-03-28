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
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/intersect.nim
    title: cplib/geometry/intersect.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_B\n\
    include cplib/geometry/intersect\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar\
    \ q = ii()\nfor _ in 0..<q:\n    proc get(): Point[int] = initPoint(ii(), ii())\n\
    \    var s1, s2 = initSegment(get(), get())\n    echo int(intersect(s1, s2))\n\
    \n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/base.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: true
  path: verify/geometry/CGL_2/intersect_cgl2b_test.nim
  requiredBy: []
  timestamp: '2024-03-28 16:38:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_2/intersect_cgl2b_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_2/intersect_cgl2b_test.nim
- /verify/verify/geometry/CGL_2/intersect_cgl2b_test.nim.html
title: verify/geometry/CGL_2/intersect_cgl2b_test.nim
---
