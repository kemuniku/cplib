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
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_atcoder_test.nim
    title: verify/math/divisor_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_atcoder_test.nim
    title: verify/math/divisor_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_many_atcoder_test.nim
    title: verify/math/divisor_many_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/divisor_many_atcoder_test.nim
    title: verify/math/divisor_many_atcoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/factorize_yosupo_test.nim
    title: verify/math/factorize_yosupo_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_PRIMEFACTOR:\n    const CPLIB_MATH_PRIMEFACTOR*\
    \ = 1\n    import cplib/math/inner_math\n    import cplib/math/isprime\n    import\
    \ random, std/math, algorithm, tables\n\n    randomize()\n    proc find_factor(n:\
    \ int): int =\n        if not ((n and 1) != 0): return 2\n        if isprime(n):\
    \ return n\n        const m = 128\n        while true:\n            var x, ys,\
    \ q, r, g = 1\n            var rnd, y = rand(0..n-3) + 2\n            proc f(x:\
    \ int): int = (mul(x, x, n) + rnd) mod n\n            while g == 1:\n        \
    \        x = y\n                for i in 0..<r: y = f(y)\n                for\
    \ k in countup(0, r-1, m):\n                    ys = y\n                    for\
    \ _ in 0..<min(m, r-k):\n                        y = f(y)\n                  \
    \      q = mul(q, abs(x-y), n)\n                    g = gcd(q, n)\n          \
    \          if g != 1: break\n                r = r shl 1\n            if g ==\
    \ n:\n                g = 1\n                while g == 1:\n                 \
    \   ys = f(ys)\n                    g = gcd(n, abs(x - ys))\n            if g\
    \ < n:\n                if isprime(g): return g\n                elif isprime(n\
    \ div g): return n div g\n                return find_factor(g)\n\n    proc primefactor*(n:\
    \ int, sorted: bool = true): seq[int] =\n        var n = n\n        while n >\
    \ 1 and not isprime(n):\n            var p = find_factor(n)\n            while\
    \ n mod p == 0:\n                result.add(p)\n                n = n div p\n\
    \        if n > 1: result.add(n)\n        if sorted: return result.sorted\n\n\
    \    proc primefactor_cnt*(n: int): Table[int, int] =\n        for p in primefactor(n):\n\
    \            if p in result: result[p] += 1\n            else: result[p] = 1\n"
  dependsOn:
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  isVerificationFile: false
  path: cplib/math/primefactor.nim
  requiredBy:
  - cplib/math/divisor.nim
  - cplib/math/divisor.nim
  timestamp: '2023-11-10 01:29:02+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/divisor_atcoder_test.nim
  - verify/math/divisor_atcoder_test.nim
  - verify/math/divisor_many_atcoder_test.nim
  - verify/math/divisor_many_atcoder_test.nim
  - verify/math/factorize_yosupo_test.nim
  - verify/math/factorize_yosupo_test.nim
documentation_of: cplib/math/primefactor.nim
layout: document
redirect_from:
- /library/cplib/math/primefactor.nim
- /library/cplib/math/primefactor.nim.html
title: cplib/math/primefactor.nim
---
