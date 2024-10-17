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
    PROBLEM: https://atcoder.jp/contests/abc284/tasks/abc284_d
    links:
    - https://atcoder.jp/contests/abc284/tasks/abc284_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc284/tasks/abc284_d\n\
    import cplib/math/primefactor\nimport strutils, tables\n\nproc solve() =\n   \
    \ var n = stdin.readLine.parseInt\n    var p, q: int\n    for k, v in primefactor_table(n):\n\
    \        if v == 2: p = k\n        else: q = k\n    echo p, \" \", q\n\nvar t\
    \ = stdin.readLine.parseInt\nfor _ in 0..<t: solve()\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/primefactor.nim
  - cplib/math/powmod.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/isprime.nim
  - cplib/math/primefactor.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/str/run_length_encode.nim
  isVerificationFile: true
  path: verify/math/factorize_table_abc284d_test.nim
  requiredBy: []
  timestamp: '2024-03-16 01:58:47+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/factorize_table_abc284d_test.nim
layout: document
redirect_from:
- /verify/verify/math/factorize_table_abc284d_test.nim
- /verify/verify/math/factorize_table_abc284d_test.nim.html
title: verify/math/factorize_table_abc284d_test.nim
---
