---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs.nim
    title: cplib/str/lcs.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/lcs.nim
    title: cplib/str/lcs.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import random, sequtils, strutils\nimport cplib/str/lcs\n\nproc oracle[T](a, b:\
    \ openArray[T]): int =\n    var dp = newSeqWith(a.len + 1, newSeq[int](b.len +\
    \ 1))\n    for i in 0..<a.len:\n        for j in 0..<b.len:\n            dp[i+1][j+1]\
    \ = max(dp[i][j+1], dp[i+1][j])\n            if a[i] == b[j]:\n              \
    \  dp[i+1][j+1] = max(dp[i+1][j+1], dp[i][j] + 1)\n    return dp[a.len][b.len]\n\
    \nvar words = @[\"\"]\nfor length in 1..6:\n    for bits in 0..<(1 shl length):\n\
    \        var word = newString(length)\n        for i in 0..<length:\n        \
    \    word[i] = char(ord('a') + ((bits shr i) and 1))\n        words.add(word)\n\
    for a in words:\n    for b in words:\n        doAssert LCS(a, b) == oracle(a,\
    \ b)\nvar rng = initRand(20261005)\nfor trial in 0..<1000:\n    var a = newSeq[int](rng.rand(50))\n\
    \    var b = newSeq[int](rng.rand(50))\n    for i in 0..<a.len:\n        a[i]\
    \ = rng.rand(-4..4)\n    for i in 0..<b.len:\n        b[i] = rng.rand(-4..4)\n\
    \    doAssert LCS(a, b) == oracle(a, b)\nlet limits = [low(int), high(int), 0,\
    \ low(int)]\ndoAssert LCS(limits, limits) == 4\ndoAssert LCS(limits.toOpenArray(1,\
    \ 2), limits.toOpenArray(0, 2)) == 2\ndoAssert LCS([0'u64, high(uint64), 0'u64],\
    \ [high(uint64), 0'u64]) == 2\ndoAssert LCS([\"aaa\", \"bbb\", \"ccc\"], [\"bbb\"\
    , \"ccc\"]) == 2\ndoAssert LCS([0.0, NaN, 1.0], [NaN, 0.0, 1.0]) == 2\nlet bytes\
    \ = \"\\0\\xff\\0\\x80\"\ndoAssert LCS(bytes, bytes) == bytes.len\ndoAssert LCS(\"\
    \", bytes) == 0\ndoAssert LCS(bytes, \"\") == 0\n\ntype EqOnly = object\n    value:\
    \ int\nproc `==`(a, b: EqOnly): bool = a.value == b.value\nlet eqA = [EqOnly(value:\
    \ 1), EqOnly(value: 2), EqOnly(value: 1)]\nlet eqB = [EqOnly(value: 2), EqOnly(value:\
    \ 1)]\ndoAssert LCS(eqA, eqB) == 2\n\ntype Asymmetric = object\n    value: int\n\
    proc `==`(a, b: Asymmetric): bool = a.value < b.value\nlet asymA = [Asymmetric(value:\
    \ 1), Asymmetric(value: 2)]\nlet asymB = [Asymmetric(value: 2), Asymmetric(value:\
    \ 3)]\ndoAssert LCS(asymA, asymB) == oracle(asymA, asymB)\ndoAssert LCS(asymB,\
    \ asymA) == oracle(asymB, asymA)\ndoAssert LCS(repeat(\"ab\", 5000), \"ba\") ==\
    \ 2\ndoAssert LCS(\"ba\", repeat(\"ab\", 5000)) == 2\ndoAssert LCS(repeat(\"a\"\
    , 1000), repeat(\"b\", 1000)) == 0\necho \"Hello World\"\n"
  dependsOn:
  - cplib/str/lcs.nim
  - cplib/str/lcs.nim
  isVerificationFile: true
  path: verify/str/lcs_linear_memory_test.nim
  requiredBy: []
  timestamp: '2026-10-05 02:26:20+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/str/lcs_linear_memory_test.nim
layout: document
redirect_from:
- /verify/verify/str/lcs_linear_memory_test.nim
- /verify/verify/str/lcs_linear_memory_test.nim.html
title: verify/str/lcs_linear_memory_test.nim
---
