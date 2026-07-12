---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
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


    import cplib/modint/modint


    type MintM = modint998244353_montgomery

    var a = init(MintM, 10)

    var b = init(MintM, 3)

    assert (a + b).val == 13

    assert (a - b).val == 7

    assert (a * b).val == 30

    assert (a / b * b).val == 10

    assert (a + 998244353).val == 10

    assert (2 + b).val == 5

    assert (20 - b).val == 17

    assert (4 * b).val == 12

    assert (MintM.init(2).pow(10)).val == 1024

    assert $MintM.init(-1) == "998244352"

    assert (MintM.init(2) / 2).val == 1

    assert MintM.init(3).estimate_rational() == "3/1"


    type MintB = modint1000000007_barrett

    assert (MintB.init(1_000_000_008) + MintB.init(2)).val == 3

    assert (MintB.init(2).pow(5)).val == 32


    type DynM = modint_montgomery

    DynM.setMod(101)

    assert (DynM.init(100) + 2).val == 1

    assert (DynM.init(3) * 4).val == 12


    type DynB = modint_barrett

    DynB.setMod(97)

    assert (DynB.init(-1) + 2).val == 1

    assert (DynB.init(5) / 5).val == 1

    '
  dependsOn:
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/AI/modint_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/modint_test.nim
layout: document
redirect_from:
- /verify/verify/AI/modint_test.nim
- /verify/verify/AI/modint_test.nim.html
title: verify/AI/modint_test.nim
---
