---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matops.nim
    title: cplib/matrix/matops.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix.nim
    title: cplib/matrix/matrix.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport sequtils, strutils, sets\nimport cplib/matrix/matrix\n\
    import cplib/matrix/matops\nimport random\n\nvar rng = initRand(0)\n\nvar l, r\
    \ = newSeq[Matrix[int]]()\nfor i in 0..<2:\n    var a = newSeqWith(2, newSeqWith(3,\
    \ rng.rand(-5..5)))\n    l.add(initMatrix(a))\n    r.add(initMatrix(a.transposed))\n\
    for i in 0..<2:\n    var a = newSeqWith(2, newSeqWith(3, rng.rand(-5..5)))\n \
    \   l.add(a.toMatrix)\n    r.add(a.transposed.toMatrix)\nfor i in -1..1:\n   \
    \ l.add(initMatrix(2, 3, i))\n    r.add(initMatrix(3, 2, i))\nvar r2 = initMatrix((1..2).toSeq)\n\
    var r3 = initMatrix((1..3).toSeq)\nvar c2 = initMatrix((1..2).toSeq, true)\nvar\
    \ c3 = initMatrix((1..3).toSeq, true)\n\nassert l.mapIt(it.h).allIt(it == 2) and\
    \ l.mapIt(it.w).allIt(it == 3)\nassert r.mapIt(it.h).allIt(it == 3) and r.mapIt(it.w).allIt(it\
    \ == 2)\nassert r2.h == 1 and r2.w == 2\nassert r3.h == 1 and r3.w == 3\nassert\
    \ c2.h == 2 and c2.w == 1\nassert c3.h == 3 and c3.w == 1\n\n\ntemplate assert_op(op1,\
    \ op2: untyped) =\n    for lr in [l, r]:\n        for a in lr:\n            for\
    \ b in lr:\n                check(op1, op2, a, b)\ntemplate check(op1, op2, a,\
    \ b: untyped) =\n    var m1 = op1(a, b)\n    var m2 = a\n    op2(m2, b)\n    for\
    \ i in 0..<a.h:\n        for j in 0..<a.w:\n            assert m1[i][j] == m2[i,\
    \ j]\nassert_op(`+`, `+=`)\nassert_op(`-`, `-=`)\nassert_op(`*`, `*=`)\nassert_op(`and`,\
    \ `and=`)\nassert_op(`or`, `or=`)\nassert_op(`xor`, `xor=`)\ncheck(`shl`, `shl=`,\
    \ l[^1], l[^1])\ncheck(`shr`, `shr=`, l[^1], l[^1])\ncheck(`div`, `div=`, l[^1],\
    \ l[^1])\ncheck(`mod`, `mod=`, l[^1], l[^1])\n\nfor item in l:\n    assert item\
    \ == item\n    assert $item == $item\n    assert hash(item) == hash(item)\n  \
    \  assert -item + 10 != item\nfor item in r:\n    assert item == item\n    assert\
    \ $item == $item\n    assert -item + 10 != item\n\nvar st = initHashSet[Matrix[int]]()\n\
    for item in l: st.incl(item)\nfor item in r: st.incl(item)\nassert st.len == 14\n\
    \nvar iden = identity_matrix[int](3)\nfor i in 0..<3:\n    for j in 0..<3:\n \
    \       if i == j: assert iden[i, j] == 1\n        else: assert iden[i, j] ==\
    \ 0\nfor i in [0, 1, 2, 10, 100, 1000]:\n    assert iden.pow(i) == iden\nassert\
    \ iden.sum == 3\n\nfor a in l:\n    for b in r:\n        var m1 = a @ b\n    \
    \    var m2 = a\n        m2 @= b\n        assert m1 == m2\n    var m3 = r2 @ a\n\
    \    var m4 = a @ c3\n    assert m3.h == 1 and m3.w == 3\n    assert m4.h == 2\
    \ and m4.w == 1\n"
  dependsOn:
  - cplib/matrix/matrix.nim
  - cplib/matrix/matops.nim
  - cplib/matrix/matrix.nim
  - cplib/matrix/matops.nim
  isVerificationFile: true
  path: verify/matrix/matrix_unit_test.nim
  requiredBy: []
  timestamp: '2024-03-28 20:27:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_unit_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_unit_test.nim
- /verify/verify/matrix/matrix_unit_test.nim.html
title: verify/matrix/matrix_unit_test.nim
---
