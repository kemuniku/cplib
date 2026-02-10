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
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://yukicoder.me/problems/no/8030
    links:
    - https://yukicoder.me/problems/no/8030
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/8030\ninclude\
    \ cplib/tmpl/sheep\nimport cplib/math/isprime\n\nvar N = ii()\nfor i in 0..<N:\n\
    \    let x = ii()\n    if isprime(x):\n        echo x, \" \", 1\n    else:\n \
    \       echo x, \" \", 0\n"
  dependsOn:
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/utils/constants.nim
  - cplib/math/powmod.nim
  - cplib/tmpl/sheep.nim
  - cplib/utils/constants.nim
  - cplib/math/isprime.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/tmpl/sheep.nim
  isVerificationFile: true
  path: verify/math/isprime_yukicoder_test.nim
  requiredBy: []
  timestamp: '2025-04-01 08:20:08+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/isprime_yukicoder_test.nim
layout: document
redirect_from:
- /verify/verify/math/isprime_yukicoder_test.nim
- /verify/verify/math/isprime_yukicoder_test.nim.html
title: verify/math/isprime_yukicoder_test.nim
---
