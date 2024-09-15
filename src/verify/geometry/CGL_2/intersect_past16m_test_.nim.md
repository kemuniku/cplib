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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/past202309-open/tasks/past202309_m
    links:
    - https://atcoder.jp/contests/past202309-open/tasks/past202309_m
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '#FIXME: remove "_" in filename after PAST 16 testcases added to AtCoder Dropbox

    # verification-helper: PROBLEM https://atcoder.jp/contests/past202309-open/tasks/past202309_m

    include cplib/geometry/intersect

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)


    proc get(): Point[float] = initPoint(float(ii()), float(ii()))

    var s1, s2 = initSegment(get(), get())

    if intersect(s1, s2): echo "Yes"

    else: echo "No"

    '
  dependsOn:
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/base.nim
  isVerificationFile: false
  path: verify/geometry/CGL_2/intersect_past16m_test_.nim
  requiredBy: []
  timestamp: '2024-03-28 16:38:54+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/geometry/CGL_2/intersect_past16m_test_.nim
layout: document
redirect_from:
- /library/verify/geometry/CGL_2/intersect_past16m_test_.nim
- /library/verify/geometry/CGL_2/intersect_past16m_test_.nim.html
title: verify/geometry/CGL_2/intersect_past16m_test_.nim
---
