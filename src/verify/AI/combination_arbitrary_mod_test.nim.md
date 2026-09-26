---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_arbitrary_mod.nim
    title: cplib/math/combination_arbitrary_mod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_arbitrary_mod.nim
    title: cplib/math/combination_arbitrary_mod.nim
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
    import cplib/math/combination_arbitrary_mod\n\nfor modulus in 1..160:\n    let\
    \ c = initCombinationArbitraryMod(160, modulus)\n    var rows = newSeq[seq[int]](161)\n\
    \    for n in 0..160:\n        rows[n] = newSeq[int](n + 1)\n        rows[n][0]\
    \ = 1 mod modulus\n        rows[n][n] = 1 mod modulus\n        for r in 1..<n:\n\
    \            rows[n][r] = (rows[n - 1][r - 1] + rows[n - 1][r]) mod modulus\n\
    \        var permutation = 1 mod modulus\n        for r in 0..n:\n           \
    \ doAssert c.ncr(n, r) == rows[n][r]\n            doAssert c.npr(n, r) == permutation\n\
    \            permutation = permutation * (n - r) mod modulus\n    for n in 0..50:\n\
    \        for r in 0..50:\n            let expected = if r == 0: 1 mod modulus\n\
    \                           elif n == 0: 0\n                           else: rows[n\
    \ + r - 1][r]\n            doAssert c.nhr(n, r) == expected\n    doAssert c.ncr(-1,\
    \ 0) == 0\n    doAssert c.ncr(3, -1) == 0\n    doAssert c.ncr(3, 4) == 0\n   \
    \ doAssert c.npr(-1, 0) == 0\n    doAssert c.npr(3, -1) == 0\n    doAssert c.npr(3,\
    \ 4) == 0\n    doAssert c.nhr(-1, 0) == 0\n    doAssert c.nhr(1, -1) == 0\n  \
    \  let n = high(int)\n    doAssert c.ncr(n, 0) == 1 mod modulus\n    doAssert\
    \ c.ncr(n, 1) == n mod modulus\n    doAssert c.ncr(n, 2) == (n mod modulus) *\
    \ ((n div 2) mod modulus) mod modulus\n    doAssert c.ncr(n, n - 2) == c.ncr(n,\
    \ 2)\n    doAssert c.npr(n, 2) == (n mod modulus) * ((n - 1) mod modulus) mod\
    \ modulus\n    doAssert c.nhr(n, 1) == n mod modulus\n\nfor modulus in [1, 2,\
    \ 8, 9, 72, 998244353, (1 shl 30) - 1]:\n    let c0 = initCombinationArbitraryMod(0,\
    \ modulus)\n    doAssert c0.ncr(0, 0) == 1 mod modulus\n    doAssert c0.npr(0,\
    \ 0) == 1 mod modulus\n    doAssert c0.nhr(0, 0) == 1 mod modulus\n    let c =\
    \ initCombinationArbitraryMod(60, modulus)\n    var row = @[1 mod modulus]\n \
    \   for n in 1..60:\n        var next = newSeq[int](n + 1)\n        next[0] =\
    \ 1 mod modulus\n        next[n] = 1 mod modulus\n        for r in 1..<n:\n  \
    \          next[r] = (row[r - 1] + row[r]) mod modulus\n        row = next\n \
    \       for r in 0..n:\n            doAssert c.ncr(n, r) == row[r]\n\necho \"\
    Hello World\"\n"
  dependsOn:
  - cplib/math/combination_arbitrary_mod.nim
  - cplib/math/combination_arbitrary_mod.nim
  isVerificationFile: true
  path: verify/AI/combination_arbitrary_mod_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:34:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/combination_arbitrary_mod_test.nim
layout: document
redirect_from:
- /verify/verify/AI/combination_arbitrary_mod_test.nim
- /verify/verify/AI/combination_arbitrary_mod_test.nim.html
title: verify/AI/combination_arbitrary_mod_test.nim
---
