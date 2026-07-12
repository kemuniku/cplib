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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/geometry/base

    import cplib/geometry/intersect


    let s1 = initSegment(initPoint(0, 0), initPoint(4, 0))

    let s2 = initSegment(initPoint(2, -1), initPoint(2, 1))

    let s3 = initSegment(initPoint(5, 0), initPoint(6, 0))

    let s4 = initSegment(initPoint(4, 0), initPoint(4, 2))

    assert intersect(s1, s2)

    assert not intersect(s1, s3)

    assert intersect(s1, s4)

    assert not intersect(s1, s4, true)


    let l1 = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))

    let l2 = initLine(initPoint(1.0, -1.0), initPoint(1.0, 1.0))

    let l3 = initLine(initPoint(0.0, 1.0), initPoint(2.0, 1.0))

    assert intersect(l1, l2)

    assert not intersect(l1, l3)

    assert cross_point(l1, l2) == initPoint(1.0, 0.0)

    '
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/AI/intersect_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/intersect_test.nim
layout: document
redirect_from:
- /verify/verify/AI/intersect_test.nim
- /verify/verify/AI/intersect_test.nim.html
title: verify/AI/intersect_test.nim
---
