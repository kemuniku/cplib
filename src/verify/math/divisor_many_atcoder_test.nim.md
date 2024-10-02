---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/divisor.nim
    title: cplib/math/divisor.nim
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
    PROBLEM: https://atcoder.jp/contests/abc170/tasks/abc170_d
    links:
    - https://atcoder.jp/contests/abc170/tasks/abc170_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://atcoder.jp/contests/abc170/tasks/abc170_d

    import strutils, sequtils, tables, sets

    import cplib/math/divisor


    var _ = stdin.readLine.parseInt

    var a = stdin.readLine.split.map parseInt

    var cnt = a.toCountTable

    var st = a.toHashSet

    a = a.filterIt(cnt[it] <= 1)

    echo a.countit(divisor(it, true)[0..<(^1)].allIt(not (it in st)))

    '
  dependsOn:
  - cplib/str/run_length_encode.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/primefactor.nim
  - cplib/math/divisor.nim
  - cplib/math/primefactor.nim
  - cplib/math/divisor.nim
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  isVerificationFile: true
  path: verify/math/divisor_many_atcoder_test.nim
  requiredBy: []
  timestamp: '2024-03-16 01:58:47+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/divisor_many_atcoder_test.nim
layout: document
redirect_from:
- /verify/verify/math/divisor_many_atcoder_test.nim
- /verify/verify/math/divisor_many_atcoder_test.nim.html
title: verify/math/divisor_many_atcoder_test.nim
---
