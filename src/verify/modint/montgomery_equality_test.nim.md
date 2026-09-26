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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport hashes, sets, tables\nimport cplib/modint/modint\n\
    \nproc checkEquality[T: MontgomeryModint]() =\n    let modulus = int(T.umod)\n\
    \    let zero = init(T, 0)\n    var alternateZero = init(T, 1)\n    alternateZero\
    \ += init(T, modulus - 1)\n    assert alternateZero == zero\n    assert not (alternateZero\
    \ != zero)\n    assert hash(alternateZero) == hash(zero)\n    var values = initHashSet[T]()\n\
    \    var counts = initTable[T, int]()\n    for i in 0..<min(modulus, 30):\n  \
    \      let canonical = init(T, i)\n        var other = canonical\n        other\
    \ += alternateZero\n        for value in [canonical, other, -(-other)]:\n    \
    \        assert value == canonical\n            assert hash(value) == hash(canonical)\n\
    \            values.incl(value)\n            counts[value] = counts.getOrDefault(value)\
    \ + 1\n        assert counts[canonical] == 3\n        for j in 0..<min(modulus,\
    \ 30):\n            assert (other == init(T, j)) == (i == j)\n    assert values.len\
    \ == min(modulus, 30)\n\ncheckEquality[StaticMontgomeryModint[17u32]]()\ncheckEquality[StaticMontgomeryModint[998244353u32]]()\n\
    checkEquality[StaticMontgomeryModint[1u32]]()\ntype Dynamic = DynamicMontgomeryModint[39001u32]\n\
    for modulus in [17, 19, 998244353, 1]:\n    Dynamic.setMod(modulus)\n    checkEquality[Dynamic]()\n\
    let a: modint998244353_montgomery = 1\nlet z = a + 998244352\nassert z == 0\n\
    assert 0 == z\nassert z != 1\n"
  dependsOn:
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  isVerificationFile: true
  path: verify/modint/montgomery_equality_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/modint/montgomery_equality_test.nim
layout: document
redirect_from:
- /verify/verify/modint/montgomery_equality_test.nim
- /verify/verify/modint/montgomery_equality_test.nim.html
title: verify/modint/montgomery_equality_test.nim
---
