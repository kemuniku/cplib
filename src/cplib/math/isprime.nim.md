---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yosupo_test.nim
    title: verify/math/isprime_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/isprime_yukicoder_test.nim
    title: verify/math/isprime_yukicoder_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_ISPRIME:\n    const COMPETITIVE_MATH_ISPRIME*\
    \ = 1\n    import cplib/math/powmod\n    proc isprime*(N: int): bool =\n     \
    \   let bases = [2, 325, 9375, 28178, 450775, 9780504, 1795265022]\n        if\
    \ N == 2:\n            return true\n        if N < 2 or (N and 1) == 0:\n    \
    \        return false\n        let N1 = N-1\n        var d = N1\n        var s\
    \ = 0\n        while (d and 1) == 0:\n            d = d shr 1\n            s +=\
    \ 1\n        for a in bases:\n            var t: int\n            if a mod N ==\
    \ 0:\n                continue\n            t = powmod(a, d, N)\n            if\
    \ t == 1 or t == N1:\n                continue\n            block test:\n    \
    \            for _ in 0..<(s-1):\n                    t = powmod(t, 2, N)\n  \
    \                  if t == N1:\n                        break test\n         \
    \       return false\n        return true\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  isVerificationFile: false
  path: cplib/math/isprime.nim
  requiredBy:
  - cplib/math/primefactor.nim
  - cplib/math/primefactor.nim
  timestamp: '2023-11-10 01:03:01+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yosupo_test.nim
  - verify/math/isprime_yukicoder_test.nim
  - verify/math/isprime_yukicoder_test.nim
documentation_of: cplib/math/isprime.nim
layout: document
redirect_from:
- /library/cplib/math/isprime.nim
- /library/cplib/math/isprime.nim.html
title: cplib/math/isprime.nim
---
