---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix.nim
    title: cplib/matrix/static_matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/static_matrix.nim
    title: cplib/matrix/static_matrix.nim
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


    import cplib/matrix/static_matrix


    var a = initMatrix([[1, 2], [3, 4]])

    let b = toMatrix([[5, 6], [7, 8]])

    assert a.h == 2

    assert a.w == 2

    assert a[0] == [1, 2]

    assert a[1, 0] == 3

    a[0, 1] = 9

    assert a[0, 1] == 9

    a[0] = [1, 2]

    assert a == initMatrix([[1, 2], [3, 4]])

    assert $a == "1 2\n3 4"

    assert -a == initMatrix([[-1, -2], [-3, -4]])

    assert a + b == initMatrix([[6, 8], [10, 12]])

    assert b - a == initMatrix([[4, 4], [4, 4]])

    assert a * b == initMatrix([[19, 22], [43, 50]])

    assert a * 2 == initMatrix([[2, 4], [6, 8]])

    assert 2 * a == initMatrix([[2, 4], [6, 8]])

    assert (a + 1) == initMatrix([[2, 3], [4, 5]])

    assert (a and initMatrix([[1, 0], [1, 0]])) == initMatrix([[1, 0], [1, 0]])

    assert identity_matrix[2, 2, int](2) == initMatrix([[1, 0], [0, 1]])

    assert a.pow(2) == initMatrix([[7, 10], [15, 22]])

    assert (a ** 2) == a.pow(2)

    assert a.sum == 10

    assert initMatrix[2, 3, int](7).sum == 42

    '
  dependsOn:
  - cplib/matrix/static_matrix.nim
  - cplib/matrix/static_matrix.nim
  isVerificationFile: true
  path: verify/AI/static_matrix_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/static_matrix_test.nim
layout: document
redirect_from:
- /verify/verify/AI/static_matrix_test.nim
- /verify/verify/AI/static_matrix_test.nim.html
title: verify/AI/static_matrix_test.nim
---
