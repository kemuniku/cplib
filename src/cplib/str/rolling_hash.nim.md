---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_abcbac_test.nim
    title: verify/str/rolling_hash_abcbac_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_abcbac_test.nim
    title: verify/str/rolling_hash_abcbac_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_aoj_test.nim
    title: verify/str/rolling_hash_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_aoj_test.nim
    title: verify/str/rolling_hash_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_pun_test.nim
    title: verify/str/rolling_hash_pun_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_pun_test.nim
    title: verify/str/rolling_hash_pun_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_yosupo_enumerate_palindromes_test.nim
    title: verify/str/rolling_hash_yosupo_enumerate_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_yosupo_enumerate_palindromes_test.nim
    title: verify/str/rolling_hash_yosupo_enumerate_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
    title: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
    title: verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_ROLLING_HASH:\n    const CPLIB_STR_ROLLING_HASH*\
    \ = 1\n    import random, math\n\n    type RollingHash*[T] = object\n        s:\
    \ T\n        hash_accum, base_pow, base_inv_pow: seq[uint]\n\n    const MASK30\
    \ = (1u shl 30) - 1\n    const MASK31 = (1u shl 31) - 1\n    const RH_MOD = (1u\
    \ shl 61) - 1\n    const RH_ROOT = 37\n\n    proc calc_mod(x: uint): uint =\n\
    \        result = (x shr 61) + (x and RH_MOD)\n        if result > RH_MOD:\n \
    \           result -= RH_MOD\n\n    proc mul(a, b: uint): uint =\n        let\n\
    \            a_upper = a shr 31\n            a_lower = a and MASK31\n        \
    \    b_upper = b shr 31\n            b_lower = b and MASK31\n            mid =\
    \ a_lower * b_upper + a_upper * b_lower\n            mid_upper = mid shr 30\n\
    \            mid_lower = mid and MASK30\n        result = a_upper * b_upper *\
    \ 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower\n\n    proc pow(a, n:\
    \ uint): uint =\n        var a = a\n        var n = n\n        result = 1\n  \
    \      while n > 0:\n            if (n and 1u) != 0u:\n                result\
    \ = mul(result, a).calc_mod\n            a = mul(a, a).calc_mod\n            n\
    \ = n shr 1\n\n    proc find_base(maxa: uint, seed: int64 = -1): (uint, uint)\
    \ =\n        var\n            rng = if seed == -1: initRand() else: initRand(seed)\n\
    \            k = 0u\n            base = pow(RH_ROOT, k)\n        while base <=\
    \ maxa or gcd(RH_MOD, k) != 1:\n            k = rng.rand(0u..<RH_MOD)\n      \
    \      base = pow(RH_ROOT, k)\n        let base_inv = pow(base, RH_MOD-2)\n  \
    \      return (base, base_inv)\n\n    var base, base_inv: uint\n    var initialized\
    \ = false\n\n    proc build*(rh: var RollingHash, maxa: uint = 1000000000, seed:\
    \ int = -1) =\n        if not initialized:\n            initialized = true\n \
    \           (base, base_inv) = find_base(maxa, seed)\n        rh.hash_accum =\
    \ newSeq[uint](rh.s.len + 1)\n        rh.hash_accum[0] = 0u\n        rh.base_pow\
    \ = newSeq[uint](rh.s.len + 1)\n        rh.base_pow[0] = 1u\n        rh.base_inv_pow\
    \ = newSeq[uint](rh.s.len + 1)\n        rh.base_inv_pow[0] = 1u\n        for i\
    \ in 0..<rh.s.len:\n            rh.hash_accum[i+1] = (rh.hash_accum[i] + mul(uint(rh.s[i]),\
    \ rh.base_pow[i])).calc_mod\n            rh.base_pow[i+1] = mul(rh.base_pow[i],\
    \ base).calc_mod\n            rh.base_inv_pow[i+1] = mul(rh.base_inv_pow[i], base_inv).calc_mod\n\
    \n    proc initRollingHash*[T](s: T): RollingHash[T] =\n        result = RollingHash[T](s:\
    \ s, hash_accum: newSeq[uint](), base_pow: newSeq[uint](), base_inv_pow: newSeq[uint]())\n\
    \        result.build\n\n    proc query*(rh: RollingHash, rng: HSlice[int, int]):\
    \ uint =\n        var\n            l = rng.a\n            r = rng.b + 1\n    \
    \    assert l in 0..<rh.hash_accum.len and r in 0..<rh.hash_accum.len\n      \
    \  return mul(rh.hash_accum[r] + RH_MOD - rh.hash_accum[l], rh.base_inv_pow[l]).calc_mod\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/rolling_hash.nim
  requiredBy: []
  timestamp: '2023-11-19 20:31:33+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - verify/str/rolling_hash_yosupo_zalgorithm_test.nim
  - verify/str/rolling_hash_yosupo_enumerate_palindromes_test.nim
  - verify/str/rolling_hash_yosupo_enumerate_palindromes_test.nim
  - verify/str/rolling_hash_aoj_test.nim
  - verify/str/rolling_hash_aoj_test.nim
  - verify/str/rolling_hash_abcbac_test.nim
  - verify/str/rolling_hash_abcbac_test.nim
  - verify/str/rolling_hash_pun_test.nim
  - verify/str/rolling_hash_pun_test.nim
documentation_of: cplib/str/rolling_hash.nim
layout: document
redirect_from:
- /library/cplib/str/rolling_hash.nim
- /library/cplib/str/rolling_hash.nim.html
title: cplib/str/rolling_hash.nim
---
