---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc324/tasks/abc324_b
    links:
    - https://atcoder.jp/contests/abc324/tasks/abc324_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc324/tasks/abc324_b\n\
    include cplib/math/primefactor\nimport strutils\n\nvar n = stdin.readLine.parseInt\n\
    for (k, v) in primefactor_tuple(n):\n    if k != 2 and k != 3:\n        echo \"\
    No\"\n        quit()\necho \"Yes\"\n\n"
  dependsOn:
  - cplib/str/run_length_encode.nim
  - cplib/math/primefactor.nim
  - cplib/math/primefactor.nim
  - cplib/math/inner_math.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/powmod.nim
  isVerificationFile: true
  path: verify/math/factorize_tuple_abc324b_test.nim
  requiredBy: []
  timestamp: '2024-03-16 01:58:47+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/factorize_tuple_abc324b_test.nim
layout: document
redirect_from:
- /verify/verify/math/factorize_tuple_abc324b_test.nim
- /verify/verify/math/factorize_tuple_abc324b_test.nim.html
title: verify/math/factorize_tuple_abc324b_test.nim
---
