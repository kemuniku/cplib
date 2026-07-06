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


    var p = initPoint(1, 2)

    let q = initPoint((3, -1))

    assert +p == p

    assert -p == initPoint(-1, -2)

    p += q

    assert p == initPoint(4, 1)

    p -= q

    assert p == initPoint(1, 2)

    assert p + q == initPoint(4, 1)

    assert p - q == initPoint(-2, 3)

    assert p * 3 == initPoint(3, 6)

    assert 2 * p == initPoint(2, 4)

    assert dot(p, q) == 1

    assert cross(p, q) == -7

    assert (p * q) == 1

    assert (p @ q) == -7

    assert norm(p) == 5

    assert $p == "(1, 2)"

    assert geometry_eq(1.0, 1.0 + 1e-12)

    assert geometry_neq(1, 2)

    assert geometry_ge(2, 1.5)

    assert geometry_le(1, 1.5)

    assert geometry_gt(2, 1)

    assert geometry_lt(1, 2)

    assert initPoint(1, 2) < initPoint(1, 3)

    assert cmp(initPoint(1, 2), initPoint(1, 2)) == 0


    let line = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))

    assert line.vector == initPoint(2.0, 0.0)

    assert $line == "((0.0, 0.0), (2.0, 0.0))"

    let line2 = initLine(0.0, 1.0, -1.0)

    assert line2.s == initPoint(0.0, 1.0)

    let seg = initSegment(initPoint(0.0, 0.0), initPoint(0.0, 2.0))

    assert seg.toLine.vector == initPoint(0.0, 2.0)

    '
  dependsOn:
  - cplib/geometry/base.nim
  - cplib/geometry/base.nim
  isVerificationFile: true
  path: verify/AI/geometry_base_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/geometry_base_test.nim
layout: document
redirect_from:
- /verify/verify/AI/geometry_base_test.nim
- /verify/verify/AI/geometry_base_test.nim.html
title: verify/AI/geometry_base_test.nim
---
