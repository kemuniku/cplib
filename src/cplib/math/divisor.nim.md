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
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/math/divisor_atcoder_test_.nim
    title: verify/math/divisor_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/divisor_atcoder_test_.nim
    title: verify/math/divisor_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/divisor_many_atcoder_test_.nim
    title: verify/math/divisor_many_atcoder_test_.nim
  - icon: ':warning:'
    path: verify/math/divisor_many_atcoder_test_.nim
    title: verify/math/divisor_many_atcoder_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/euler_phi_yukicoder_test.nim
    title: verify/math/euler_phi_yukicoder_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_DIVISOR:\n    const CPLIB_MATH_DIVISOR* = 1\n\
    \    import sequtils, tables, algorithm\n    import cplib/math/primefactor\n \
    \   proc divisor_naive(x: int, sorted: bool): seq[int] =\n        for i in 1..x:\n\
    \            if i*i > x: break\n            if x mod i == 0:\n               \
    \ result.add(i)\n                if i*i != x:\n                    result.add(x\
    \ div i)\n        if sorted: result.sort\n\n    proc divisor*(x: int, sorted:\
    \ bool = true): seq[int] =\n        if x <= 1000_000: return divisor_naive(x,\
    \ sorted)\n        var factor = primefactor(x).toCountTable.pairs.toSeq\n    \
    \    var ans = newSeq[int](0)\n        proc dfs(d, x: int) =\n            if d\
    \ == factor.len:\n                ans.add(x)\n                return\n       \
    \     var mul = 1\n            for i in 0..factor[d][1]:\n                dfs(d+1,\
    \ x*mul)\n                if i != factor[d][1]: mul *= factor[d][0]\n        dfs(0,\
    \ 1)\n        if sorted: ans.sort\n        return ans\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/primefactor.nim
  - cplib/math/powmod.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/primefactor.nim
  isVerificationFile: false
  path: cplib/math/divisor.nim
  requiredBy:
  - verify/math/divisor_many_atcoder_test_.nim
  - verify/math/divisor_many_atcoder_test_.nim
  - verify/math/divisor_atcoder_test_.nim
  - verify/math/divisor_atcoder_test_.nim
  timestamp: '2024-11-07 17:54:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/euler_phi_yukicoder_test.nim
  - verify/math/euler_phi_yukicoder_test.nim
documentation_of: cplib/math/divisor.nim
layout: document
redirect_from:
- /library/cplib/math/divisor.nim
- /library/cplib/math/divisor.nim.html
title: cplib/math/divisor.nim
---
