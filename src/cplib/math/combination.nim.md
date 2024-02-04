---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_npr_test.nim
    title: verify/math/combination_npr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_npr_test.nim
    title: verify/math/combination_npr_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_test.nim
    title: verify/math/combination_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_test.nim
    title: verify/math/combination_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_COMBINATION:\n    const CPLIB_MATH_COMBINATION*\
    \ = 1\n    import atcoder/modint\n    type Combination_Type[ModInt] = ref object\n\
    \        fact: seq[ModInt]\n        inv: seq[ModInt]\n        fact_inv: seq[ModInt]\n\
    \n    proc initCombination*[ModInt](max_N: int): Combination_Type[ModInt] =\n\
    \        var fact = newSeq[ModInt](max_N+1)\n        var inv = newSeq[ModInt](max_N+1)\n\
    \        var fact_inv = newSeq[ModInt](max_N+1)\n        fact[0] = 1\n       \
    \ fact[1] = 1\n        inv[1] = 1\n        fact_inv[0] = 1\n        fact_inv[1]\
    \ = 1\n        for i in 2..max_N:\n            fact[i] = fact[i-1] * i\n     \
    \       inv[i] = -inv[int(ModInt.umod()) mod i]*(int(ModInt.umod()) div i)\n \
    \           fact_inv[i] = fact_inv[i-1] * inv[i]\n        result = Combination_Type[ModInt](fact:\
    \ fact, inv: inv, fact_inv: fact_inv)\n\n    proc ncr*[ModInt](c: Combination_Type[ModInt],\
    \ n, r: int): ModInt =\n        if n < 0 or r < 0 or n < r:\n            return\
    \ 0\n        return c.fact[n]*c.fact_inv[n-r]*c.fact_inv[r]\n\n    proc npr*[ModInt](c:\
    \ Combination_Type[ModInt], n, r: int): ModInt =\n        if n < 0 or r < 0 or\
    \ n < r:\n            return 0\n        return c.fact[n]*c.fact_inv[n-r]\n\n \
    \   proc nhr*[ModInt](c: Combination_Type[ModInt], n, r: int): ModInt =\n    \
    \    return c.ncr(n+r-1, r)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/combination.nim
  requiredBy: []
  timestamp: '2023-12-25 07:39:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/combination_test.nim
  - verify/math/combination_test.nim
  - verify/math/combination_npr_test.nim
  - verify/math/combination_npr_test.nim
documentation_of: cplib/math/combination.nim
layout: document
redirect_from:
- /library/cplib/math/combination.nim
- /library/cplib/math/combination.nim.html
title: cplib/math/combination.nim
---
