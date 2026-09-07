---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':question:'
    path: cplib/convolution/convolution.nim
    title: cplib/convolution/convolution.nim
  - icon: ':question:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':question:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':question:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':question:'
    path: cplib/math/inv_gcd.nim
    title: cplib/math/inv_gcd.nim
  - icon: ':question:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':question:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':question:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':question:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':question:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':question:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':question:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':question:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':question:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/convolution_mod
    links:
    - https://judge.yosupo.jp/problem/convolution_mod
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod


    import cplib/convolution/convolution

    import cplib/modint/modint

    import sequtils, strutils

    proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}

    proc ii(): int {.inline.} = scanf("%lld\n", addr result)

    type mint = modint_montgomery

    mint.setMod(998244353)


    var n, m = ii()

    var a = newseqwith(n, ii().mint())

    var b = newSeqWith(m, ii().mint())

    var c = convolution(a, b)

    echo c.join(" ")

    '
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/powmod.nim
  isVerificationFile: true
  path: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
  requiredBy: []
  timestamp: '2026-09-04 10:21:15+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
layout: document
redirect_from:
- /verify/verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
- /verify/verify/convolution/convolution/convolution_dynamic_montgomery_test.nim.html
title: verify/convolution/convolution/convolution_dynamic_montgomery_test.nim
---
