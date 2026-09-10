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
  - icon: ':heavy_check_mark:'
    path: cplib/str/wildcard_matching.nim
    title: cplib/str/wildcard_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/wildcard_matching.nim
    title: cplib/str/wildcard_matching.nim
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
    import random, strutils\nimport cplib/str/wildcard_matching\n\nproc naive(s, t:\
    \ string, wild: char): seq[bool] =\n    if t.len > s.len:\n        return @[]\n\
    \    for i in 0..s.len - t.len:\n        var matches = true\n        for j in\
    \ 0..<t.len:\n            if s[i + j] != wild and t[j] != wild and s[i + j] !=\
    \ t[j]:\n                matches = false\n                break\n        result.add(matches)\n\
    \nproc check(s, t: string, wild: char = '?') =\n    doAssert wildcard_match(s,\
    \ t, wild) == naive(s, t, wild)\n\ndoAssert wildcard_match(\"ab?abc\", \"a?c\"\
    ) == @[true, false, false, true]\ndoAssert wildcard_match(\"\", \"\") == @[true]\n\
    doAssert wildcard_match(\"abc\", \"\") == @[true, true, true, true]\ndoAssert\
    \ wildcard_match(\"\", \"a\") == @[]\ncheck(\"ab\", \"abc\")\ncheck(\"????\",\
    \ \"??\")\ncheck(\"abcd\", \"??\")\ncheck(\"****\", \"ab\", '*')\ncheck(\"a b\\\
    0\\255\", \" b\\0\")\ncheck(\"?a*b?\", \"?*\", '*')\n\nvar bytes = \"\"\nfor i\
    \ in 0..255:\n    bytes.add(char(i))\ncheck(bytes, bytes)\ncheck(bytes & bytes,\
    \ bytes, '\\0')\ncheck(repeat(\"~\", 300), repeat(\"~\", 150))\ncheck(repeat(\"\
    \\255\", 300), repeat(\"\\254\", 150))\n\nvar rng = initRand(20260910)\nfor trial\
    \ in 0..<300:\n    let n = rng.rand(0..220)\n    let m = rng.rand(0..240)\n  \
    \  let wild = if trial mod 2 == 0: '?' else: '\\0'\n    var s = newString(n)\n\
    \    var t = newString(m)\n    for c in s.mitems:\n        c = if rng.rand(0..3)\
    \ == 0: wild else: char(rng.rand(0..255))\n    for c in t.mitems:\n        c =\
    \ if rng.rand(0..3) == 0: wild else: char(rng.rand(0..255))\n    check(s, t, wild)\n\
    \    if m <= n:\n        let offset = rng.rand(0..n - m)\n        for j in 0..<m:\n\
    \            if t[j] != wild and s[offset + j] != wild:\n                t[j]\
    \ = s[offset + j]\n        check(s, t, wild)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/str/wildcard_matching.nim
  - cplib/math/isqrt.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/powmod.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/inner_math.nim
  - cplib/math/isqrt.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/modint/modint.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/str/wildcard_matching.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/wildcard_matching_test.nim
  requiredBy: []
  timestamp: '2026-09-10 06:14:46+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/wildcard_matching_test.nim
layout: document
redirect_from:
- /verify/verify/AI/wildcard_matching_test.nim
- /verify/verify/AI/wildcard_matching_test.nim.html
title: verify/AI/wildcard_matching_test.nim
---
