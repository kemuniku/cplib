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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport sets\nimport cplib/matrix/static_matrix\n\nvar l\
    \ = @[\n    [[-4, 0, 5], [1, -2, 3]].initMatrix(),\n    [[3, -5, 2], [4, 0, -1]].toMatrix(),\n\
    \    initMatrix[2,3,int](-1),\n    initMatrix[2,3,int](0),\n    initMatrix[2,3,int](1),\n\
    ]\nvar r = @[\n    [[-4, 1], [0, -2], [5, 3]].initMatrix(),\n    [[3, 4], [-5,\
    \ 0], [2, -1]].toMatrix(),\n    initMatrix[3,2,int](-1),\n    initMatrix[3,2,int](0),\n\
    \    initMatrix[3,2,int](1),\n]\nvar r2 = [[1, 2]].initMatrix()\nvar r3 = [[1,\
    \ 2, 3]].initMatrix()\nvar c2 = [[1], [2]].initMatrix()\nvar c3 = [[1], [2], [3]].initMatrix()\n\
    var sq3 = [[1, 2, 3], [0, 1, 4], [5, 6, 0]].initMatrix()\n\nassert l[0].h == 2\
    \ and l[0].w == 3\nassert r[0].h == 3 and r[0].w == 2\nassert r2.h == 1 and r2.w\
    \ == 2\nassert r3.h == 1 and r3.w == 3\nassert c2.h == 2 and c2.w == 1\nassert\
    \ c3.h == 3 and c3.w == 1\n\ntemplate check(op1, op2, a, b: untyped) =\n    var\
    \ m1 = op1(a, b)\n    var m2 = a\n    op2(m2, b)\n    for i in 0..<a.h:\n    \
    \    for j in 0..<a.w:\n            assert m1[i][j] == m2[i, j]\n\ntemplate assert_op(op1,\
    \ op2: untyped) =\n    for a in l:\n        for b in l:\n            check(op1,\
    \ op2, a, b)\n    for a in r:\n        for b in r:\n            check(op1, op2,\
    \ a, b)\n\nassert_op(`+`, `+=`)\nassert_op(`-`, `-=`)\nassert_op(`and`, `and=`)\n\
    assert_op(`or`, `or=`)\nassert_op(`xor`, `xor=`)\ncheck(`shl`, `shl=`, l[^1],\
    \ l[^1])\ncheck(`shr`, `shr=`, l[^1], l[^1])\ncheck(`div`, `div=`, l[^1], l[^1])\n\
    check(`mod`, `mod=`, l[^1], l[^1])\n\nfor item in l:\n    assert item == item\n\
    \    assert $item == $item\n    assert hash(item) == hash(item)\n    assert -item\
    \ + 10 != item\nfor item in r:\n    assert item == item\n    assert $item == $item\n\
    \    assert -item + 10 != item\n\nvar st = initHashSet[StaticMatrix[2,3,int]]()\n\
    for item in l: st.incl(item)\nassert st.len == 5\n\nvar iden = identity_matrix[3,3,int](3)\n\
    for i in 0..<3:\n    for j in 0..<3:\n        if i == j: assert iden[i, j] ==\
    \ 1\n        else: assert iden[i, j] == 0\nfor i in [0, 1, 2, 10, 100, 1000]:\n\
    \    assert iden.pow(i) == iden\n    assert iden ** i == iden\nassert iden.sum\
    \ == 3\n\nfor a in l:\n    for b in r:\n        var m1 = a * b\n        assert\
    \ m1.h == 2 and m1.w == 2\n    var m2 = a\n    m2 *= sq3\n    assert m2 == a *\
    \ sq3\n    var m3 = r2 * a\n    var m4 = a * c3\n    assert m3.h == 1 and m3.w\
    \ == 3\n    assert m4.h == 2 and m4.w == 1\n"
  dependsOn:
  - cplib/matrix/static_matrix.nim
  - cplib/matrix/static_matrix.nim
  isVerificationFile: true
  path: verify/matrix/static_string/static_matrix_unit_test.nim
  requiredBy: []
  timestamp: '2026-05-26 07:54:36+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/static_string/static_matrix_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/static_string/static_matrix_unit_test.nim
- /verify/verify/matrix/static_string/static_matrix_unit_test.nim.html
title: verify/matrix/static_string/static_matrix_unit_test.nim
---
