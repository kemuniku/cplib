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
    \ bytes, '\\0')\ncheck(bytes & bytes, bytes, '\\255')\ncheck(repeat(\"\\255\"\
    , 300), repeat(\"a\", 150), '\\255')\ncheck(repeat(\"~\", 300), repeat(\"~\",\
    \ 150))\ncheck(repeat(\"\\255\", 300), repeat(\"\\254\", 150))\n\nvar rng = initRand(20260910)\n\
    for trial in 0..<300:\n    let n = rng.rand(0..220)\n    let m = rng.rand(0..240)\n\
    \    let wild = if trial mod 2 == 0: '?' else: '\\0'\n    var s = newString(n)\n\
    \    var t = newString(m)\n    for c in s.mitems:\n        c = if rng.rand(0..3)\
    \ == 0: wild else: char(rng.rand(0..255))\n    for c in t.mitems:\n        c =\
    \ if rng.rand(0..3) == 0: wild else: char(rng.rand(0..255))\n    check(s, t, wild)\n\
    \    if m <= n:\n        let offset = rng.rand(0..n - m)\n        for j in 0..<m:\n\
    \            if t[j] != wild and s[offset + j] != wild:\n                t[j]\
    \ = s[offset + j]\n        check(s, t, wild)\n\nfor n in [60, 61, 63, 64, 65,\
    \ 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023, 1024, 1025]:\n    for m in\
    \ [1, 59, 60, 61, n div 2, n - 1, n, n + 1]:\n        check(repeat(\"a\", n),\
    \ repeat(\"b\", m))\n        check(repeat(\"a\", n), repeat(\"a\", m))\n     \
    \   check(repeat(\"?\", n), repeat(\"\\255\", m))\n        check(repeat(\"\\0\"\
    , n), repeat(\"?\", m))\n        var s = newString(n)\n        var t = newString(m)\n\
    \        for i in 0..<n: s[i] = char((i * 73) mod 256)\n        for i in 0..<m:\
    \ t[i] = char((i * 73 + 19) mod 256)\n        check(s, t)\n        if m <= n:\n\
    \            for i in 0..<m: t[i] = s[n - m + i]\n            check(s, t)\n\n\
    for trial in 0..<80:\n    let n = rng.rand(7300..16000)\n    let m = rng.rand(7230..n)\n\
    \    var s = newString(n)\n    var t = newString(m)\n    for c in s.mitems: c\
    \ = char(rng.rand(0..255))\n    for c in t.mitems: c = char(rng.rand(0..255))\n\
    \    check(s, t)\n    let offset = rng.rand(0..n - m)\n    for i in 0..<m: t[i]\
    \ = s[offset + i]\n    for i in countup(0, m - 1, 7): t[i] = '?'\n    check(s,\
    \ t)\n\n# 469762049 = 7224*255^2 + 146^2 + 9^2 + 6^2 + 4^2\u3002\nvar collisionS\
    \ = repeat(\"\\0\", 7228)\nvar collisionT = repeat(\"\\255\", 7224)\nfor x in\
    \ [146, 9, 6, 4]: collisionT.add(char(x))\ncheck(collisionS, collisionT)\n\n#\
    \ \u5358\u4E00\u7D20\u6570\u306Eweighted\u30B9\u30B3\u30A2\u30672*998244353\u3068\
    \u306A\u308B586\u6587\u5B57\u306E\u53CD\u4F8B\u3002\ncheck(repeat(\"a\", 138)\
    \ & repeat(\"a\", 273) & repeat(\"k\", 5) & repeat(\"a\", 170),\n    repeat(\"\
    k\", 138) & repeat(\"y\", 273) & repeat(\"v\", 5) & repeat(\"a\", 170))\ncheck(repeat(\"\
    a\", 81) & repeat(\"a\", 413) & repeat(\"u\", 3) & repeat(\"a\", 89),\n    repeat(\"\
    k\", 81) & repeat(\"u\", 413) & repeat(\"x\", 3) & repeat(\"a\", 89))\n\nvar words\
    \ = @[\"\"]\nfor length in 1..6:\n    let start = words.len\n    for wi in 0..<start:\n\
    \        let w = words[wi]\n        if w.len == length - 1:\n            for c\
    \ in ['\\0', '?', '\\255']: words.add(w & c)\n    doAssert words.len > start\n\
    for s in words:\n    for t in words:\n        if t.len <= 4: check(s, t)\n\nvar\
    \ rejected = false\ntry:\n    discard wildcard_match(repeat(\"a\", 1 shl 24),\
    \ \"aa\")\nexcept AssertionDefect:\n    rejected = true\ndoAssert rejected\n\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/str/wildcard_matching.nim
  - cplib/str/wildcard_matching.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/inv_gcd.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  isVerificationFile: true
  path: verify/AI/wildcard_matching_test.nim
  requiredBy: []
  timestamp: '2026-10-02 14:56:06+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/wildcard_matching_test.nim
layout: document
redirect_from:
- /verify/verify/AI/wildcard_matching_test.nim
- /verify/verify/AI/wildcard_matching_test.nim.html
title: verify/AI/wildcard_matching_test.nim
---
