---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/combination_arbitrary_mod_test.nim
    title: verify/AI/combination_arbitrary_mod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/combination_arbitrary_mod_test.nim
    title: verify/AI/combination_arbitrary_mod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_arbitrary_mod_test.nim
    title: verify/math/combination_arbitrary_mod_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_arbitrary_mod_test.nim
    title: verify/math/combination_arbitrary_mod_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://nyaannyaan.github.io/library/modulo/arbitrary-mod-binomial.hpp.html
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_COMBINATION_ARBITRARY_MOD:\n    const CPLIB_MATH_COMBINATION_ARBITRARY_MOD*\
    \ = 1\n\n    # \u53C2\u8003: https://nyaannyaan.github.io/library/modulo/arbitrary-mod-binomial.hpp.html\n\
    \    type\n        CombinationPrimePower = object\n            p, q, modulus,\
    \ coefficient: int\n            fact, factInv: seq[int32]\n        CombinationArbitraryMod*\
    \ = object\n            modulus: int\n            factors: seq[CombinationPrimePower]\n\
    \n    proc power(a, exponent, modulus: int): int =\n        ## a\u306E\u975E\u8CA0\
    \u6574\u6570\u4E57\u3092modulus\u3067\u5272\u3063\u305F\u4F59\u308A\u3092\u8FD4\
    \u3059\u3002O(log(exponent + 1))\u3002\n        var a = a\n        var exponent\
    \ = exponent\n        result = 1\n        while exponent > 0:\n            if\
    \ (exponent and 1) != 0:\n                result = result * a mod modulus\n  \
    \          a = a * a mod modulus\n            exponent = exponent shr 1\n\n  \
    \  proc initCombinationArbitraryMod*(max_N, modulus: int): CombinationArbitraryMod\
    \ =\n        ## \u4EFB\u610Fmod\u306E\u7D44\u5408\u305B\u3092\u524D\u8A08\u7B97\
    \u3059\u308B\u300264bit\u74B0\u5883\u30670 <= max_N\u30011 <= modulus < 2^30\u3002\
    \n        ## \u7D20\u6570\u51AAm\u3054\u3068\u306BL = min(max_N, m - 1)\u3068\u3057\
    \u3066\u3001\u6642\u9593O(sqrt(modulus) + \u03A3(L + log m))\u3001\u7A7A\u9593\
    O(\u03A3(L + 1))\u3002\n        ## n <= max_N\u3092\u6271\u3048\u308B\u3002\u5168\
    \u7D20\u6570\u51AAm\u306B\u3064\u3044\u3066max_N >= m - 1\u306A\u3089\u4EFB\u610F\
    \u306E\u975E\u8CA0int\u306En\u3092\u6271\u3048\u308B\u3002\n        assert max_N\
    \ >= 0, \"max_N\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        assert modulus >= 1 and modulus < (1 shl 30), \"\u6CD5\
    \u306F1\u4EE5\u4E0A2^30\u672A\u6E80\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        result.modulus = modulus\n        var remaining = modulus\n\
    \        var p = 2\n        while remaining > 1:\n            if p > remaining\
    \ div p:\n                p = remaining\n            if remaining mod p == 0:\n\
    \                var f = CombinationPrimePower(p: p, modulus: 1)\n           \
    \     while remaining mod p == 0:\n                    remaining = remaining div\
    \ p\n                    f.modulus *= p\n                    inc f.q\n       \
    \         let limit = min(max_N, f.modulus - 1)\n                f.fact = newSeq[int32](limit\
    \ + 1)\n                f.factInv = newSeq[int32](limit + 1)\n               \
    \ f.fact[0] = 1\n                for i in 1..limit:\n                    f.fact[i]\
    \ = f.fact[i - 1]\n                    if i mod p != 0:\n                    \
    \    f.fact[i] = int32(int(f.fact[i]) * i mod f.modulus)\n                let\
    \ phi = f.modulus div p * (p - 1)\n                f.factInv[limit] = int32(power(int(f.fact[limit]),\
    \ phi - 1, f.modulus))\n                for i in countdown(limit, 1):\n      \
    \              f.factInv[i - 1] = f.factInv[i]\n                    if i mod p\
    \ != 0:\n                        f.factInv[i - 1] = int32(int(f.factInv[i]) *\
    \ i mod f.modulus)\n                let other = modulus div f.modulus\n      \
    \          f.coefficient = other * power(other mod f.modulus, phi - 1, f.modulus)\n\
    \                result.factors.add(f)\n            inc p\n\n    proc factorialRatio(f:\
    \ CombinationPrimePower, n, a, b: int): int =\n        ## n!/(a!b!)\u3092\u7D20\
    \u6570\u51AA\u3067\u5272\u3063\u305F\u4F59\u308A\u3092\u8FD4\u3059\u3002a+b <=\
    \ n\u3092\u4EEE\u5B9A\u3057\u3001O(log_p(n + 1))\u3002\n        assert n < f.fact.len\
    \ or f.fact.len == f.modulus, \"\u524D\u8A08\u7B97\u306E\u7BC4\u56F2\u3092\u8D85\
    \u3048\u3066\u3044\u307E\u3059\"\n        var (n, a, b) = (n, a, b)\n        var\
    \ exponent = 0\n        var negative = false\n        result = 1\n        while\
    \ n > 0:\n            result = result * int(f.fact[n mod f.modulus]) mod f.modulus\n\
    \            result = result * int(f.factInv[a mod f.modulus]) mod f.modulus\n\
    \            result = result * int(f.factInv[b mod f.modulus]) mod f.modulus\n\
    \            if ((n div f.modulus - a div f.modulus - b div f.modulus) and 1)\
    \ != 0:\n                negative = not negative\n            n = n div f.p\n\
    \            a = a div f.p\n            b = b div f.p\n            exponent +=\
    \ n - a - b\n            if exponent >= f.q:\n                return 0\n     \
    \   if negative and not (f.p == 2 and f.q >= 3):\n            result = f.modulus\
    \ - result\n        result = result * power(f.p, exponent, f.modulus) mod f.modulus\n\
    \n    proc ncr*(c: CombinationArbitraryMod, n, r: int): int =\n        ## nCr\
    \ mod modulus\u3092\u8FD4\u3059\u3002\u4E0D\u6B63\u306An,r\u306B\u306F0\u3092\u8FD4\
    \u3059\u3002\u6642\u9593O(\u03A3 log_p(n + 1))\u3002\n        if n < 0 or r <\
    \ 0 or n < r:\n            return 0\n        for f in c.factors:\n           \
    \ result = (result + f.factorialRatio(n, r, n - r) * f.coefficient) mod c.modulus\n\
    \n    proc npr*(c: CombinationArbitraryMod, n, r: int): int =\n        ## nPr\
    \ mod modulus\u3092\u8FD4\u3059\u3002\u4E0D\u6B63\u306An,r\u306B\u306F0\u3092\u8FD4\
    \u3059\u3002\u6642\u9593O(\u03A3 log_p(n + 1))\u3002\n        if n < 0 or r <\
    \ 0 or n < r:\n            return 0\n        for f in c.factors:\n           \
    \ result = (result + f.factorialRatio(n, n - r, 0) * f.coefficient) mod c.modulus\n\
    \n    proc nhr*(c: CombinationArbitraryMod, n, r: int): int =\n        ## nHr\
    \ mod modulus\u3092\u8FD4\u3059\u3002n+r-1\u304Cint\u3068\u524D\u8A08\u7B97\u306E\
    \u7BC4\u56F2\u306B\u53CE\u307E\u308B\u5FC5\u8981\u304C\u3042\u308B\u3002\u6642\
    \u9593O(\u03A3 log_p(n + r))\u3002\n        if n < 0 or r < 0:\n            return\
    \ 0\n        if r == 0:\n            return 1 mod c.modulus\n        if n == 0:\n\
    \            return 0\n        assert n <= high(int) - (r - 1), \"n+r-1\u304C\
    int\u306E\u7BC4\u56F2\u3092\u8D85\u3048\u3066\u3044\u307E\u3059\"\n        return\
    \ c.ncr(n + (r - 1), r)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/combination_arbitrary_mod.nim
  requiredBy: []
  timestamp: '2026-09-18 12:34:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/combination_arbitrary_mod_test.nim
  - verify/AI/combination_arbitrary_mod_test.nim
  - verify/math/combination_arbitrary_mod_test.nim
  - verify/math/combination_arbitrary_mod_test.nim
documentation_of: cplib/math/combination_arbitrary_mod.nim
layout: document
redirect_from:
- /library/cplib/math/combination_arbitrary_mod.nim
- /library/cplib/math/combination_arbitrary_mod.nim.html
title: cplib/math/combination_arbitrary_mod.nim
---
