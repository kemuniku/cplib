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
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/euler_phi.nim
    title: cplib/math/euler_phi.nim
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
    PROBLEM: https://yukicoder.me/problems/no/1339
    links:
    - https://yukicoder.me/problems/no/1339
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://yukicoder.me/problems/no/1339\nimport\
    \ strutils\nimport cplib/math/euler_phi\nimport cplib/math/divisor\nimport cplib/math/powmod\n\
    \nvar t = stdin.readLine.parseint\nvar ans = newSeq[int](0)\nfor _ in 0..<t:\n\
    \    var n = stdin.readLine.parseint\n    while n mod 2 == 0: n = n div 2\n  \
    \  while n mod 5 == 0: n = n div 5\n    if n == 1:\n        ans.add(1)\n     \
    \   continue\n    for p in divisor(euler_phi(n)):\n        if powmod(10, p, n)\
    \ == 1:\n            ans.add(p)\n            break\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/math/divisor.nim
  - cplib/math/divisor.nim
  - cplib/math/euler_phi.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/euler_phi.nim
  - cplib/math/primefactor.nim
  - cplib/math/inner_math.nim
  - cplib/math/primefactor.nim
  - cplib/math/inner_math.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  - cplib/str/run_length_encode.nim
  isVerificationFile: true
  path: verify/math/euler_phi_yukicoder_test.nim
  requiredBy: []
  timestamp: '2024-11-07 17:54:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/euler_phi_yukicoder_test.nim
layout: document
redirect_from:
- /verify/verify/math/euler_phi_yukicoder_test.nim
- /verify/verify/math/euler_phi_yukicoder_test.nim.html
title: verify/math/euler_phi_yukicoder_test.nim
---
