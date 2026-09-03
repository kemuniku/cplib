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

    import cplib/geometry/projection


    let lf = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))

    assert projection(lf, initPoint(1.0, 3.0)) == initPoint(1.0, 0.0)

    assert reflection(lf, initPoint(1.0, 3.0)) == initPoint(1.0, -3.0)

    '
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/projection.nim
  - cplib/geometry/base.nim
  - cplib/geometry/projection.nim
  isVerificationFile: true
  path: verify/AI/projection_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/projection_test.nim
layout: document
redirect_from:
- /verify/verify/AI/projection_test.nim
- /verify/verify/AI/projection_test.nim.html
title: verify/AI/projection_test.nim
---
