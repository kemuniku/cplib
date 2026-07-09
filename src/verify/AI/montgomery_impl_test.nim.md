---
data:
  _extendedDependsOn:
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


    import cplib/modint/montgomery_impl


    type Mint = StaticMontgomeryModint[17u32]

    assert Mint.umod == 17u32

    assert Mint.mod == 17

    assert Mint.get_M == 17u32

    assert Mint.get_param[0] == 17u32

    assert get_r(17u32) * 17u32 == 1u32

    assert get_n2(17u32) < 17u32


    var a = init(Mint, 20)

    assert a.val == 3

    a += 20

    assert a.val == 6

    a -= 10

    assert a.val == 13

    a *= 4

    assert a.val == 1

    a /= 1

    assert a.val == 1

    assert inv(init(Mint, 5)).val == 7

    assert (-init(Mint, 3)).val == 14


    type DMint = DynamicMontgomeryModint[101u32]

    DMint.setMod(19)

    assert DMint.umod == 19u32

    var b = init(DMint, -2)

    assert b.val == 17

    b += 5

    assert b.val == 3

    '
  dependsOn:
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  isVerificationFile: true
  path: verify/AI/montgomery_impl_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/montgomery_impl_test.nim
layout: document
redirect_from:
- /verify/verify/AI/montgomery_impl_test.nim
- /verify/verify/AI/montgomery_impl_test.nim.html
title: verify/AI/montgomery_impl_test.nim
---
