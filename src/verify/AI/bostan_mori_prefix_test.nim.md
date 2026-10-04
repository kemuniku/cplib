---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/bostan_mori.nim
    title: cplib/fps/bostan_mori.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/fps/formal_power_series.nim
    title: cplib/fps/formal_power_series.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
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
    import cplib/fps/bostan_mori\nimport cplib/modint/modint\n\nproc check[T: BarrettModint\
    \ or MontgomeryModint](M: typedesc[T]) =\n    for size in [0, 1, 2, 7, 63, 64,\
    \ 65, 129]:\n        var p = newSeq[T](size)\n        var q = newSeq[T](size +\
    \ 3)\n        for i in 0..<p.len: p[i] = init(T, i * i + 3)\n        for i in\
    \ 0..<q.len: q[i] = init(T, i * 7 + 2)\n        let savedP = p\n        let savedQ\
    \ = q\n        var expected = newSeq[T](140)\n        for k in 0..<expected.len:\n\
    \            var value = if k < p.len: p[k] else: init(T, 0)\n            for\
    \ i in 1..min(k, q.high): value -= q[i] * expected[k - i]\n            expected[k]\
    \ = value / q[0]\n        for k in [0, 1, 2, 3, 7, 31, 63, 64, 65, 127, 139]:\n\
    \            doAssert bostanMori(p, q, k) == expected[k]\n            doAssert\
    \ p == savedP and q == savedQ\n        p.add(init(T, 0))\n        q.add(init(T,\
    \ 0))\n        doAssert bostanMori(p, q, 3) == expected[3]\n    let one = @[init(T,\
    \ 1)]\n    let geometric = @[init(T, 1), init(T, -1)]\n    doAssert bostanMori(one,\
    \ geometric, high(int)) == init(T, 1)\n    doAssert bostanMori(one, one, high(int))\
    \ == init(T, 0)\n    doAssert bostanMori(newSeq[T](), one, high(int)) == init(T,\
    \ 0)\n    let initial = @[init(T, 2), init(T, 3)]\n    let coefficients = @[init(T,\
    \ 1), init(T, 1)]\n    var a = init(T, 2)\n    var b = init(T, 3)\n    for k in\
    \ 0..100:\n        doAssert linearRecurrenceKth(initial, coefficients, k) == a\n\
    \        (a, b) = (b, a + b)\n\ncheck(modint998244353_barrett)\ncheck(modint998244353_montgomery)\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/fps/bostan_mori.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/fps/bostan_mori.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isprime.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/fps/formal_power_series.nim
  - cplib/fps/formal_power_series.nim
  isVerificationFile: true
  path: verify/AI/bostan_mori_prefix_test.nim
  requiredBy: []
  timestamp: '2026-10-02 14:56:06+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bostan_mori_prefix_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bostan_mori_prefix_test.nim
- /verify/verify/AI/bostan_mori_prefix_test.nim.html
title: verify/AI/bostan_mori_prefix_test.nim
---
