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
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/ntt.nim
    title: cplib/convolution/ntt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/relaxed_convolution.nim
    title: cplib/convolution/relaxed_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/relaxed_convolution.nim
    title: cplib/convolution/relaxed_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
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
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/convolution_mod
    links:
    - https://judge.yosupo.jp/problem/convolution_mod
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod\n\
    \nimport sequtils, strutils\nimport cplib/convolution/relaxed_convolution\nimport\
    \ cplib/modint/modint\n\nproc scanf(formatstr: cstring) {.header: \"<stdio.h>\"\
    , varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\ntype\
    \ Mint = modint998244353_barrett\n\nlet n = ii()\nlet m = ii()\nlet a = newSeqWith(n,\
    \ Mint(ii()))\nlet b = newSeqWith(m, Mint(ii()))\nlet coefficientCount = n + m\
    \ - 1\nvar convolution = initRelaxedConvolution[Mint](coefficientCount)\nvar result\
    \ = newSeq[Mint](coefficientCount)\nfor i in 0..<coefficientCount:\n    let left\
    \ = if i < n: a[i] else: Mint(0)\n    let right = if i < m: b[i] else: Mint(0)\n\
    \    result[i] = convolution.add(left, right)\necho result.join(\" \")\n"
  dependsOn:
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  - cplib/convolution/ntt.nim
  - cplib/convolution/ntt.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inner_math.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/powmod.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/convolution/relaxed_convolution.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/convolution/relaxed_convolution_test.nim
  requiredBy: []
  timestamp: '2026-09-03 22:19:58+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/convolution/relaxed_convolution_test.nim
layout: document
redirect_from:
- /verify/verify/convolution/relaxed_convolution_test.nim
- /verify/verify/convolution/relaxed_convolution_test.nim.html
title: verify/convolution/relaxed_convolution_test.nim
---
