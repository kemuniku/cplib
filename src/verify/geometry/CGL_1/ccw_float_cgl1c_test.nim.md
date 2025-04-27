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
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  - icon: ':heavy_check_mark:'
    path: cplib/geometry/ccw.nim
    title: cplib/geometry/ccw.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_C
    links:
    - https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_C
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_C\n\
    include cplib/geometry/ccw\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nproc\
    \ get(): Point[float] = initPoint(float(ii()), float(ii()))\nvar p1 = get()\n\
    var p2 = get()\nvar s = initLine(p1, p2)\nvar q = ii()\n\nfor i in 0..<q:\n  \
    \  var p3 = get()\n    var c = ccw(s, p3)\n    if c == COUNTER_CLOCKWISE: echo\
    \ \"COUNTER_CLOCKWISE\"\n    elif c == CLOCKWISE: echo \"CLOCKWISE\"\n    elif\
    \ c == ONLINE_BACK: echo \"ONLINE_BACK\"\n    elif c == ONLINE_FRONT: echo \"\
    ONLINE_FRONT\"\n    else: echo \"ON_SEGMENT\"\n"
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/base.nim
  - cplib/geometry/ccw.nim
  isVerificationFile: true
  path: verify/geometry/CGL_1/ccw_float_cgl1c_test.nim
  requiredBy: []
  timestamp: '2024-03-28 16:38:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/geometry/CGL_1/ccw_float_cgl1c_test.nim
layout: document
redirect_from:
- /verify/verify/geometry/CGL_1/ccw_float_cgl1c_test.nim
- /verify/verify/geometry/CGL_1/ccw_float_cgl1c_test.nim.html
title: verify/geometry/CGL_1/ccw_float_cgl1c_test.nim
---
