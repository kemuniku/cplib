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
    path: cplib/geometry/projection.nim
    title: cplib/geometry/projection.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/projection.nim
    title: cplib/geometry/projection.nim
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
    ERROR: 1e-8
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_A\n\
    # verification-helper: ERROR 1e-8\ninclude cplib/geometry/projection\ninclude\
    \ cplib/math/fractions\nimport strformat\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nproc get(): Point[Fraction[int]] = initPoint(initFraction(ii()),\
    \ initFraction(ii()))\nvar l = initLine(get(), get())\nvar q = ii()\nfor _ in\
    \ 0..<q:\n    var p = get()\n    var ans = projection(l, p)\n    echo &\"{ans.x.toFloat:.10f}\
    \ {ans.y.toFloat:.10f}\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/geometry/base.nim
  - cplib/geometry/projection.nim
  - cplib/geometry/base.nim
  - cplib/math/fractions.nim
  - cplib/geometry/projection.nim
  isVerificationFile: true
  path: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
  requiredBy: []
  timestamp: '2024-03-28 19:09:38+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
- /verify/verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim.html
title: verify/geometry/CGL_1/projection_fractions_cgl1a_test.nim
---
