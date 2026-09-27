---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/eratosthenes.nim
    title: cplib/math/eratosthenes.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/eratosthenes.nim
    title: cplib/math/eratosthenes.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
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
    import cplib/math/eratosthenes\nimport cplib/math/isprime\nimport random, sequtils\n\
    \nconst Limit = 3_000_000\nvar reference = newSeq[bool](Limit + 1)\nfor i in 2..Limit:\n\
    \    reference[i] = true\nfor p in 2..Limit:\n    if p > Limit div p:\n      \
    \  break\n    if reference[p]:\n        for j in countup(p * p, Limit, p):\n \
    \           reference[j] = false\n\nproc checkRange(low, high: int) =\n    let\
    \ sieve = initSegmentedEratosthenes(low, high)\n    var expected: seq[int]\n \
    \   for n in low..high:\n        doAssert sieve.is_prime(n) == reference[n]\n\
    \        if reference[n]:\n            expected.add(n)\n    doAssert toSeq(sieve.items())\
    \ == expected\n    doAssert get_primes(low, high + 1) == expected\n    doAssert\
    \ sieve.count_primes() == expected.len\n    doAssert sieve.byte_size() == high\
    \ div 30 - low div 30 + 1\n    doAssert not sieve.is_prime(low - 1)\n    doAssert\
    \ not sieve.is_prime(high + 1)\n\nlet full = initEratosthenes(Limit)\nvar count\
    \ = 0\nfor n in 0..Limit:\n    doAssert full.is_prime(n) == reference[n]\n   \
    \ if reference[n]:\n        inc count\nlet listed = toSeq(full.items())\ndoAssert\
    \ get_primes(Limit) == listed\nfor n in [-10, -1, 0, 1]:\n    doAssert get_primes(n)\
    \ == newSeq[int]()\ndoAssert get_primes(2) == @[2]\ndoAssert get_primes(2, 3)\
    \ == @[2]\ndoAssert get_primes(7, 19) == @[7, 11, 13, 17]\ndoAssert get_primes(-10,\
    \ 8) == @[2, 3, 5, 7]\nfor bounds in [(7, 7), (8, 7), (-10, 2), (low(int), low(int)),\
    \ (high(int), high(int))]:\n    doAssert get_primes(bounds[0], bounds[1]) == newSeq[int]()\n\
    doAssert get_primes(29) == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29]\ndoAssert get_primes(30)\
    \ == get_primes(29)\ndoAssert get_primes(31) == @[2, 3, 5, 7, 11, 13, 17, 19,\
    \ 23, 29, 31]\ndoAssert listed.len == count\ndoAssert full.count_primes() == count\n\
    for i, p in listed:\n    doAssert reference[p]\n    if i > 0:\n        doAssert\
    \ listed[i - 1] < p\ndoAssert not full.is_prime(-1)\ndoAssert not full.is_prime(Limit\
    \ + 1)\n\nfor low in 0..150:\n    for width in 0..60:\n        checkRange(low,\
    \ low + width)\nfor limit in 0..100:\n    let sieve = initEratosthenes(limit)\n\
    \    for n in 0..limit:\n        doAssert sieve.is_prime(n) == reference[n]\n\
    for boundary in [32_768 * 30, 2 * 32_768 * 30, 47 * 47, 53 * 53, 997 * 997]:\n\
    \    checkRange(boundary - 61, boundary + 61)\ncheckRange(12345, 2_345_678)\n\
    var rng = initRand(20260913)\nfor _ in 0..<100:\n    let low = rng.rand(0..Limit\
    \ - 20_000)\n    checkRange(low, low + rng.rand(0..20_000))\n\nwhen sizeof(int)\
    \ >= 8:\n    for low in [int(999_999_999_900), int(1_000_006_000_000)]:\n    \
    \    let sieve = initSegmentedEratosthenes(low, low + 2000)\n        var expected:\
    \ seq[int]\n        for n in low..low + 2000:\n            let prime = isprime(n)\n\
    \            doAssert sieve.is_prime(n) == prime\n            if prime:\n    \
    \            expected.add(n)\n        doAssert toSeq(sieve.items()) == expected\n\
    \        doAssert get_primes(low, low + 2001) == expected\n        doAssert sieve.count_primes()\
    \ == expected.len\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/eratosthenes.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/math/eratosthenes.nim
  isVerificationFile: true
  path: verify/AI/eratosthenes_test.nim
  requiredBy: []
  timestamp: '2026-09-14 18:23:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/eratosthenes_test.nim
layout: document
redirect_from:
- /verify/verify/AI/eratosthenes_test.nim
- /verify/verify/AI/eratosthenes_test.nim.html
title: verify/AI/eratosthenes_test.nim
---
