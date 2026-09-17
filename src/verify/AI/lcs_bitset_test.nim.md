---
data:
  _extendedDependsOn: []
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
    \nimport random, strutils, algorithm\nimport cplib/str/lcs as original\nimport\
    \ cplib/str/lcs_bitset as packed\n\nproc naive[T](a, b: openArray[T]): int =\n\
    \    var dp = newSeq[int](b.len + 1)\n    for x in a:\n        var diagonal =\
    \ 0\n        for j, y in b:\n            let old = dp[j + 1]\n            dp[j\
    \ + 1] = if x == y: diagonal + 1 else: max(dp[j], old)\n            diagonal =\
    \ old\n    dp[^1]\n\nproc isSubsequence[T](sub, values: openArray[T]): bool =\n\
    \    var i = 0\n    for value in values:\n        if i < sub.len and sub[i] ==\
    \ value:\n            inc i\n    i == sub.len\n\nproc checkRestored[T](a, b: openArray[T],\
    \ expected: int) =\n    let restored = packed.restoreLCS(a, b)\n    doAssert restored.len\
    \ == expected\n    doAssert isSubsequence(restored, a)\n    doAssert isSubsequence(restored,\
    \ b)\n\nproc check[T](a, b: openArray[T]) =\n    let expected = naive(a, b)\n\
    \    doAssert packed.LCS(a, b) == expected\n    doAssert packed.LCS(b, a) == expected\n\
    \    checkRestored(a, b, expected)\n    checkRestored(b, a, expected)\n    if\
    \ a.len <= 20 and b.len <= 20:\n        doAssert original.LCS(a, b) == expected\n\
    \ncheck(@[1, 3, 4, 1], @[3, 4, 1, 2])\ncheck(\"abcbdab\", \"bdcaba\")\ncheck(\"\
    \", \"\")\ncheck(\"\", \"abc\")\ncheck(\"\\0\\xff$\\0\", \"\\xff\\0$\\0\")\ncheck([true,\
    \ false, true], [false, true])\ncheck([low(int), 0, high(int)], [high(int), low(int)])\n\
    check([0'u64, high(uint64)], [high(uint64), 0'u64])\ncheck([\"hello\", \"world\"\
    , \"hello\"], [\"world\", \"hello\"])\ncheck(@[1, 2, 3, 4].toOpenArray(1, 3),\
    \ [2, 4])\ncheck(newSeq[int](), @[1, 2])\n\ntype Color = enum red, green, blue\n\
    check([red, green, blue, green], [green, blue])\ntype EqualOnly = object\n   \
    \ key: int\n    ignored: string\nproc `==`(a, b: EqualOnly): bool = a.key == b.key\n\
    check([EqualOnly(key: 1, ignored: \"a\"), EqualOnly(key: 2)],\n    [EqualOnly(key:\
    \ 1, ignored: \"b\")])\ncheck(@[@[1, 2], @[3], @[1, 2]], @[@[3], @[1, 2]])\ncheck([1.5,\
    \ -0.0, 3.0], [0.0, 3.0])\n\nvar words = @[\"\"]\nfor length in 1..5:\n    for\
    \ bits in 0..<(1 shl length):\n        var s = newString(length)\n        for\
    \ i in 0..<length:\n            s[i] = char(ord('a') + ((bits shr i) and 1))\n\
    \        words.add(s)\nfor s in words:\n    for t in words:\n        check(s,\
    \ t)\n\nvar rng = initRand(20260918)\nfor n in [1, 2, 63, 64, 65, 127, 128, 129,\
    \ 255, 256, 257, 511, 512, 513, 1023, 1024, 1025]:\n    check(repeat('a', n),\
    \ repeat('a', n))\n    check(repeat('a', n), repeat('b', n))\n    check(repeat('a',\
    \ n), \"b\" & repeat('a', n))\n    check(repeat(\"ab\", n div 2), repeat(\"ba\"\
    , n div 2))\n    for alphabet in [1, 25, 255]:\n        var s = newString(n)\n\
    \        var t = newString(n + rng.rand(3))\n        for c in s.mitems:\n    \
    \        c = char(rng.rand(alphabet))\n        for c in t.mitems:\n          \
    \  c = char(rng.rand(alphabet))\n        check(s, t)\n    let wordCount = (n +\
    \ 63) div 64\n    for count in [wordCount, wordCount + 1]:\n        var a = newSeq[int](n)\n\
    \        for i in 0..<n:\n            a[i] = if i < count: -1 else: i\n      \
    \  check(a, a.reversed())\n\nfor trial in 0..<300:\n    var a = newSeq[int](rng.rand(200))\n\
    \    var b = newSeq[int](rng.rand(200))\n    let alphabet = if trial mod 2 ==\
    \ 0: 3 else: 1000\n    for x in a.mitems:\n        x = rng.rand(alphabet) - alphabet\
    \ div 2\n    for x in b.mitems:\n        x = rng.rand(alphabet) - alphabet div\
    \ 2\n    check(a, b)\n\nvar allBytes = newString(256)\nfor i in 0..<256:\n   \
    \ allBytes[i] = char(i)\ncheck(allBytes, allBytes[1..^1] & \"\\0\")\nvar uniqueValues\
    \ = newSeq[int](10000)\nfor i in 0..<uniqueValues.len:\n    uniqueValues[i] =\
    \ i\ndoAssert packed.LCS(uniqueValues, uniqueValues) == uniqueValues.len\ndoAssert\
    \ packed.LCS(uniqueValues, uniqueValues.reversed()) == 1\ndoAssert packed.LCS(repeat('a',\
    \ 10000), repeat('a', 10000)) == 10000\ncheckRestored(uniqueValues, uniqueValues,\
    \ uniqueValues.len)\ncheckRestored(uniqueValues, uniqueValues.reversed(), 1)\n\
    checkRestored(repeat('a', 10000), repeat('a', 10000), 10000)\ncheckRestored(\"\
    a\", repeat('b', 10000), 0)\ncheckRestored(repeat('b', 10000) & \"a\", \"a\",\
    \ 1)\n\nfor n in [65, 513, 2049]:\n    for m in [2, 63, 65]:\n        var a =\
    \ newSeq[int](n)\n        var b = newSeq[int](m)\n        for x in a.mitems:\n\
    \            x = rng.rand(3)\n        for x in b.mitems:\n            x = rng.rand(3)\n\
    \        check(a, b)\n        check(repeat('a', m) & repeat('b', n), repeat('a',\
    \ m))\n        check(repeat('b', n) & repeat('a', m), repeat('a', m))\n\necho\
    \ \"Hello World\"\n"
  dependsOn: []
  isVerificationFile: true
  path: verify/AI/lcs_bitset_test.nim
  requiredBy: []
  timestamp: '2026-09-17 19:03:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lcs_bitset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lcs_bitset_test.nim
- /verify/verify/AI/lcs_bitset_test.nim.html
title: verify/AI/lcs_bitset_test.nim
---
