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
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/addition_of_big_integers
    links:
    - https://judge.yosupo.jp/problem/addition_of_big_integers
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/addition_of_big_integers\n\
    include cplib/tmpl/fastio\nimport cplib/math/bigint\n\nproc tryParseSmallDecimal(s:\
    \ string, value: var int64): bool =\n    let first = ord(s.len > 0 and (s[0] ==\
    \ '+' or s[0] == '-'))\n    if s.len - first notin 1..18:\n        return false\n\
    \    var magnitude = 0'u64\n    for i in first..<s.len:\n        if s[i] < '0'\
    \ or s[i] > '9':\n            return false\n        magnitude = magnitude * 10\
    \ + uint64(ord(s[i]) - ord('0'))\n    value = if s[0] == '-': -int64(magnitude)\
    \ else: int64(magnitude)\n    true\n\nstatic:\n    for text in [\"0\", \"+0\"\
    , \"-0\", \"000000000000000000\",\n            \"+000000000000000001\", \"999999999999999999\"\
    ,\n            \"-999999999999999999\"]:\n        var value: int64\n        doAssert\
    \ tryParseSmallDecimal(text, value)\n        doAssert initBigInt(value) == parseBigInt(text)\n\
    \    for text in [\"\", \"+\", \"-\", \"1_000\", \" 1\", \"1 \", \"--1\",\n  \
    \          \"1234567890123456789\", \"0000000000000000001\",\n            \"-0000000000000000001\"\
    ]:\n        var value: int64\n        doAssert not tryParseSmallDecimal(text,\
    \ value)\n    for position in 0..<18:\n        for byte in 0..255:\n         \
    \   var text = \"123456789012345678\"\n            text[position] = char(byte)\n\
    \            for sign in [\"\", \"+\", \"-\"]:\n                var value: int64\n\
    \                let accepted = tryParseSmallDecimal(sign & text, value)\n   \
    \             let expected = (byte >= ord('0') and byte <= ord('9')) or\n    \
    \                (position == 0 and sign.len == 0 and char(byte) in ['+', '-'])\n\
    \                doAssert accepted == expected\n                if accepted:\n\
    \                    doAssert initBigInt(value) == parseBigInt(sign & text)\n\
    \    for a in [999999999999999999'i64, -999999999999999999'i64, 0'i64]:\n    \
    \    for b in [999999999999999999'i64, -999999999999999999'i64, 0'i64]:\n    \
    \        doAssert initBigInt(a + b) == initBigInt(a) + initBigInt(b)\n\nlet queryCount\
    \ = input(int)\nfor _ in 0..<queryCount:\n    let a = input(string)\n    let b\
    \ = input(string)\n    var smallA, smallB: int64\n    if tryParseSmallDecimal(a,\
    \ smallA) and tryParseSmallDecimal(b, smallB):\n        print(smallA + smallB)\n\
    \    else:\n        print(parseBigInt(a) + parseBigInt(b))\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/inv_gcd.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/bigint.nim
  - cplib/math/isqrt.nim
  - cplib/modint/modint.nim
  - cplib/math/inv_gcd.nim
  - cplib/math/bigint.nim
  - cplib/convolution/convolution.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/isqrt.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/math/addition_of_big_integers_test.nim
  requiredBy: []
  timestamp: '2026-10-02 14:56:06+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/addition_of_big_integers_test.nim
layout: document
redirect_from:
- /verify/verify/math/addition_of_big_integers_test.nim
- /verify/verify/math/addition_of_big_integers_test.nim.html
title: verify/math/addition_of_big_integers_test.nim
---
