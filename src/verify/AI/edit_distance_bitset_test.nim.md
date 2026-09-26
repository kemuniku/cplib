---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitset_avx512.nim
    title: cplib/collections/bitset_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse.nim
    title: cplib/collections/private/bitset_avx512_fuse.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
    title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
    title: cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_block.nim
    title: cplib/collections/private/bitset_avx512_fuse_block.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_block.nim
    title: cplib/collections/private/bitset_avx512_fuse_block.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_fuse_shift.nim
    title: cplib/collections/private/bitset_avx512_fuse_shift.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_impl.nim
    title: cplib/collections/private/bitset_avx512_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_shift_assign.nim
    title: cplib/collections/private/bitset_avx512_shift_assign.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx512_shift_assign.nim
    title: cplib/collections/private/bitset_avx512_shift_assign.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_search_impl.nim
    title: cplib/collections/private/bitset_search_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_search_impl.nim
    title: cplib/collections/private/bitset_search_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/edit_distance_bitset.nim
    title: cplib/str/edit_distance_bitset.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
    \nimport random, strutils\nimport cplib/str/edit_distance_bitset\n\nproc naive(s,\
    \ t: string): int =\n    var dp = newSeq[int](t.len + 1)\n    for j in 0..t.len:\n\
    \        dp[j] = j\n    for i in 0..<s.len:\n        var diagonal = dp[0]\n  \
    \      dp[0] = i + 1\n        for j in 0..<t.len:\n            let old = dp[j\
    \ + 1]\n            dp[j + 1] = min(min(dp[j] + 1, old + 1), diagonal + ord(s[i]\
    \ != t[j]))\n            diagonal = old\n    dp[t.len]\n\nproc check(s, t: string)\
    \ =\n    let expected = naive(s, t)\n    doAssert editDistance_bitset(s, t) ==\
    \ expected\n    doAssert editDistance_bitset(t, s) == expected\n\nvar words =\
    \ @[\"\"]\nfor length in 1..5:\n    for bits in 0..<(1 shl length):\n        var\
    \ s = newString(length)\n        for i in 0..<length:\n            s[i] = char(ord('a')\
    \ + ((bits shr i) and 1))\n        words.add(s)\nfor s in words:\n    for t in\
    \ words:\n        check(s, t)\n\ncheck(\"kitten\", \"sitting\")\ncheck(\"ab\"\
    , \"ba\")\ncheck(\"\\0\\xff$\\0\", \"\\xff\\0$\\0\")\n\nvar rng = initRand(20260917)\n\
    for n in [1, 2, 63, 64, 65, 127, 128, 129, 255, 256, 257, 511, 512, 513, 1023,\
    \ 1024, 1025]:\n    let repeated = repeat('a', n)\n    check(repeated, repeated)\n\
    \    check(repeated, repeat('b', n))\n    check(repeated, \"b\" & repeated)\n\
    \    check(repeated, repeated & \"b\")\n    var changed = repeated\n    for p\
    \ in [0, n div 2, n - 1]:\n        changed[p] = 'b'\n    check(repeated, changed)\n\
    \    let periodic = repeat(\"ab\", n div 2) & (if n mod 2 == 0: \"\" else: \"\
    a\")\n    check(periodic, periodic[1..^1] & \"b\")\n    for alphabet in [1, 25,\
    \ 255]:\n        var s = newString(n)\n        var t = newString(n + rng.rand(3))\n\
    \        for c in s.mitems:\n            c = char(rng.rand(alphabet))\n      \
    \  for c in t.mitems:\n            c = char(rng.rand(alphabet))\n        check(s,\
    \ t)\n\nfor trial in 0..<500:\n    var s = newString(rng.rand(200))\n    var t\
    \ = newString(rng.rand(200))\n    let alphabet = if trial mod 2 == 0: 3 else:\
    \ 255\n    for c in s.mitems:\n        c = char(rng.rand(alphabet))\n    for c\
    \ in t.mitems:\n        c = char(rng.rand(alphabet))\n    check(s, t)\n\nvar allBytes\
    \ = newString(256)\nfor i in 0..<256:\n    allBytes[i] = char(i)\ncheck(allBytes,\
    \ allBytes[1..^1] & \"\\0\")\ncheck(\"a\", repeat('b', 10000))\ndoAssert editDistance_bitset(repeat('a',\
    \ 10000), repeat('a', 10000)) == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_search_impl.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/str/edit_distance_bitset.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_impl.nim
  - cplib/collections/bitset_avx512.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/private/bitset_avx512_fuse_block.nim
  - cplib/str/edit_distance_bitset.nim
  - cplib/collections/private/bitset_avx512_fuse.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_avx512_shift_assign.nim
  - cplib/collections/private/bitset_avx512_fuse_arithmetic.nim
  - cplib/collections/private/bitset_avx512_fuse_shift.nim
  - cplib/collections/private/bitset_search_impl.nim
  isVerificationFile: true
  path: verify/AI/edit_distance_bitset_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/edit_distance_bitset_test.nim
layout: document
redirect_from:
- /verify/verify/AI/edit_distance_bitset_test.nim
- /verify/verify/AI/edit_distance_bitset_test.nim.html
title: verify/AI/edit_distance_bitset_test.nim
---
