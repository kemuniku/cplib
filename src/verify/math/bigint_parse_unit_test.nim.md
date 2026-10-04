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
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/bigint.nim
    title: cplib/math/bigint.nim
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
    import random, strutils\nimport cplib/math/bigint\n\nstatic:\n    for text in\
    \ [\"123456789\", \"123456789012345678\", \"+000000000000000001\", \"-999999999999999999\"\
    ]:\n        doAssert $parseBigInt(text) == $parseBigInt($parseBigInt(text))\n\
    \    for text in [\"12345678a\", \"a12345678\", \"12345678\\x00\", \"+12345678/\"\
    , \"123456789\\xff00000000\"]:\n        doAssertRaises(ValueError):\n        \
    \    discard parseBigInt(text)\n\nblock:\n    for background in [\"000000000\"\
    , \"999999999\", \"123456789\"]:\n        for position in 0..<9:\n           \
    \ for value in 0..255:\n                var text = background\n              \
    \  text[position] = char(value)\n                if value >= ord('0') and value\
    \ <= ord('9'):\n                    doAssert parseBigInt(text) == initBigInt(parseInt(text))\n\
    \                else:\n                    doAssertRaises(ValueError):\n    \
    \                    discard parseBigInt(\"0\" & text)\n                    doAssertRaises(ValueError):\n\
    \                        discard parseBigInt(\"+\" & text & \"123456789\")\n \
    \                   doAssertRaises(ValueError):\n                        discard\
    \ parseBigInt(\"-123456789\" & text)\n\nblock:\n    var rng = initRand(20261002)\n\
    \    for _ in 0..<10000:\n        let value = rng.rand(999999999)\n        let\
    \ text = align($value, 9, '0')\n        doAssert parseBigInt(text) == initBigInt(value)\n\
    \        doAssert parseBigInt(\"-\" & text) == initBigInt(-value)\n        doAssert\
    \ parseBigInt(text & text) == initBigInt(value) * 1000000000 + value\n    for\
    \ length in 1..64:\n        let nines = repeat('9', length)\n        let power\
    \ = \"1\" & repeat('0', length)\n        doAssert $(parseBigInt(nines) + 1) ==\
    \ power\n        doAssert $(parseBigInt(\"-\" & nines) - 1) == \"-\" & power\n\
    \        doAssert parseBigInt(\"+\" & repeat('0', length)).isZero\n        doAssert\
    \ parseBigInt(\"-\" & repeat('0', length)).sgn == 0\n        let value = parseBigInt(nines)\n\
    \        var assigned = value\n        assigned += assigned\n        doAssert\
    \ assigned == value + value\n        doAssert parseBigInt(nines) + parseBigInt(\"\
    -\" & nines) == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isprime.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/math/bigint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/isqrt.nim
  - cplib/convolution/convolution.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/math/bigint.nim
  isVerificationFile: true
  path: verify/math/bigint_parse_unit_test.nim
  requiredBy: []
  timestamp: '2026-10-02 14:56:06+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/bigint_parse_unit_test.nim
layout: document
redirect_from:
- /verify/verify/math/bigint_parse_unit_test.nim
- /verify/verify/math/bigint_parse_unit_test.nim.html
title: verify/math/bigint_parse_unit_test.nim
---
