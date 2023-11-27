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
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/sheep.nim
    title: cplib/tmpl/sheep.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/primality_test
    links:
    - https://judge.yosupo.jp/problem/primality_test
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/primality_test\n\
    include cplib/tmpl/sheep\nimport cplib/math/isprime\n\nvar Q = ii()\n\nfor i in\
    \ 0..<Q:\n    var N = ii()\n    if isprime(N):\n        echo \"Yes\"\n    else:\n\
    \        echo \"No\"\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/tmpl/sheep.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/math/isprime.nim
  - cplib/tmpl/sheep.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  isVerificationFile: true
  path: verify/math/isprime_yosupo_test.nim
  requiredBy: []
  timestamp: '2023-11-22 08:15:35+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/isprime_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/math/isprime_yosupo_test.nim
- /verify/verify/math/isprime_yosupo_test.nim.html
title: verify/math/isprime_yosupo_test.nim
---
