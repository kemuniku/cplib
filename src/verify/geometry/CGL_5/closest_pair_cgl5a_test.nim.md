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
    path: cplib/geometry/closest_pair.nim
    title: cplib/geometry/closest_pair.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/closest_pair.nim
    title: cplib/geometry/closest_pair.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    ERROR: 1e-6
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/CGL_5_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/CGL_5_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_5_A\n\
    # verification-helper: ERROR 1e-6\nimport math, options, strformat, strutils\n\
    import cplib/geometry/base\nimport cplib/geometry/closest_pair\ninclude cplib/tmpl/fastio\n\
    \nlet n = ii()\nvar points = newSeq[Point[float64]](n)\nfor i in 0..<n:\n    points[i]\
    \ = initPoint(parseFloat(si()), parseFloat(si()))\necho &\"{sqrt(closest_pair(points).get.distanceSquared):.10f}\"\
    \n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/geometry/closest_pair.nim
  - cplib/geometry/closest_pair.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
  requiredBy: []
  timestamp: '2026-11-13 04:16:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
- /verify/verify/geometry/CGL_5/closest_pair_cgl5a_test.nim.html
title: verify/geometry/CGL_5/closest_pair_cgl5a_test.nim
---
