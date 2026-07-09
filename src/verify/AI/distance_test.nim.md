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


    import std/math

    import cplib/geometry/base

    import cplib/geometry/distance


    let p = initPoint(0, 0)

    let q = initPoint(3, 4)

    assert norm(p, q) == 25

    assert manhattan(q) == 7

    assert manhattan(p, q) == 7


    let pf = initPoint(0.0, 0.0)

    let qf = initPoint(3.0, 4.0)

    assert abs(distance(pf, qf) - 5.0) < 1e-12

    let line = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))

    assert norm(initPoint(1.0, 3.0), line) == 9.0

    assert abs(distance(initPoint(1.0, 3.0), line) - 3.0) < 1e-12

    let seg = initSegment(initPoint(0.0, 0.0), initPoint(2.0, 0.0))

    assert norm(initPoint(3.0, 4.0), seg) == 17.0

    assert abs(distance(initPoint(3.0, 4.0), seg) - sqrt(17.0)) < 1e-12

    let seg2 = initSegment(initPoint(3.0, 0.0), initPoint(3.0, 4.0))

    assert norm(seg, seg2) == 1.0

    assert abs(distance(seg, seg2) - 1.0) < 1e-12

    '
  dependsOn:
  - cplib/geometry/distance.nim
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/intersect.nim
  - cplib/geometry/ccw.nim
  - cplib/geometry/base.nim
  - cplib/geometry/angle.nim
  - cplib/geometry/distance.nim
  isVerificationFile: true
  path: verify/AI/distance_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/distance_test.nim
layout: document
redirect_from:
- /verify/verify/AI/distance_test.nim
- /verify/verify/AI/distance_test.nim.html
title: verify/AI/distance_test.nim
---
