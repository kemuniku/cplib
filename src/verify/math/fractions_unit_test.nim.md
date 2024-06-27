---
data:
  _extendedDependsOn:
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
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\nimport sequtils, math, sets, algorithm\nimport cplib/math/fractions\n\
    \nvar r = newSeq[Fraction[int]](0)\nfor i in -3..3:\n    for j in -3..3:\n   \
    \     if i == 0 or j == 0: continue\n        r.add(initFraction(i, j))\nfor i\
    \ in 1..2:\n    r.add(initFraction(0, i))\n    r.add(initFraction(0, -i))\nfor\
    \ i in 1..2:\n    r.add(initFraction(i, 0))\n    r.add(initFraction(-i, 0))\n\
    var t = (-3..3).toSeq\n\ntemplate assert_op(op1, op2: untyped) =\n    var x =\
    \ initFraction(1, 0)\n    for i in r:\n        for j in r:\n            if isNaN(x):\
    \ x = initFraction(1, 0)\n            var xi = x\n            op2(x, i)\n    \
    \        assert op1(xi, i) == x or isNaN(x)\n            assert (abs(op1(i, j).tofloat\
    \ - op1(i.tofloat, j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify\
    \ == fcInf) or (op1(i.toFloat, j.toFloat).abs.classify == fcNan)\n    x = initFraction(1,\
    \ 0)\n    for i in r:\n        for j in t:\n            if isNaN(x): x = initFraction(1,\
    \ 0)\n            var xi = x\n            op2(x, i)\n            assert op1(xi,\
    \ i) == x or isNaN(x)\n            assert (abs(op1(i, j).tofloat - op1(i.tofloat,\
    \ j.tofloat)) <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or\
    \ (op1(i.toFloat, j.toFloat).abs.classify == fcNan)\n    for i in t:\n       \
    \ for j in r:\n            assert (abs(op1(i, j).tofloat - op1(i.tofloat, j.tofloat))\
    \ <= 1e-10) or (op1(i.toFloat, j.toFloat).abs.classify == fcInf) or (op1(i.toFloat,\
    \ j.toFloat).abs.classify == fcNan)\nassert_op(`+`, `+=`)\nassert_op(`-`, `-=`)\n\
    assert_op(`*`, `*=`)\nassert_op(`/`, `/=`)\n\nproc assert_cmp() =\n    proc eq(x,\
    \ y: float): bool = (x == y) or (abs(x - y) < 1e-10)\n    proc lt(x, y: float):\
    \ bool = (not eq(x, y)) and (x < y)\n    proc gt(x, y: float): bool = (not eq(x,\
    \ y)) and (x > y)\n    proc cmp(x, y: float): int = (if lt(x, y): -1 elif eq(x,\
    \ y): 0 else: 1)\n    for i in r:\n        for j in r:\n            assert lt(i.toFloat,\
    \ j.toFloat) == (i < j)\n            assert gt(i.toFloat, j.toFloat) == (i > j)\n\
    \            assert eq(i.toFloat, j.toFloat) == (i == j)\n            assert (not\
    \ lt(i.toFloat, j.toFloat)) == (i >= j)\n            assert (not gt(i.toFloat,\
    \ j.toFloat)) == (i <= j)\n            assert (not eq(i.toFloat, j.toFloat)) ==\
    \ (i != j)\n            assert cmp(i.toFloat, j.toFloat) == cmp(i, j)\n    for\
    \ i in r:\n        for j in t:\n            assert lt(i.toFloat, j.toFloat) ==\
    \ (i < j)\n            assert gt(i.toFloat, j.toFloat) == (i > j)\n          \
    \  assert eq(i.toFloat, j.toFloat) == (i == j)\n            assert (not lt(i.toFloat,\
    \ j.toFloat)) == (i >= j)\n            assert (not gt(i.toFloat, j.toFloat)) ==\
    \ (i <= j)\n            assert (not eq(i.toFloat, j.toFloat)) == (i != j)\n  \
    \          assert cmp(i.toFloat, j.toFloat) == cmp(i, j)\n    for i in t:\n  \
    \      for j in r:\n            assert lt(i.toFloat, j.toFloat) == (i < j)\n \
    \           assert gt(i.toFloat, j.toFloat) == (i > j)\n            assert eq(i.toFloat,\
    \ j.toFloat) == (i == j)\n            assert (not lt(i.toFloat, j.toFloat)) ==\
    \ (i >= j)\n            assert (not gt(i.toFloat, j.toFloat)) == (i <= j)\n  \
    \          assert (not eq(i.toFloat, j.toFloat)) == (i != j)\n            assert\
    \ cmp(i.toFloat, j.toFloat) == cmp(i, j)\nassert_cmp()\n\nvar st = initHashSet[Fraction[int]](0)\n\
    for _ in 0..1:\n    for ri in r:\n        st.incl(ri)\nfor ri in r:\n    assert\
    \ ri.inv == (1 / ri)\n    assert ri.abs == (if ri < 0: -ri else: ri)\nassert st.len\
    \ == r.sorted.deduplicate(true).len\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  isVerificationFile: true
  path: verify/math/fractions_unit_test.nim
  requiredBy: []
  timestamp: '2024-06-27 15:21:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/fractions_unit_test.nim
layout: document
redirect_from:
- /verify/verify/math/fractions_unit_test.nim
- /verify/verify/math/fractions_unit_test.nim.html
title: verify/math/fractions_unit_test.nim
---
