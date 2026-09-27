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
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
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
    echo \"Hello World\"\n\nimport cplib/math/powmod\n\nassert powmod(2, 10, 1000)\
    \ == 24\nassert powmod(3, 0, 7) == 1\nassert powmod(10, 2, 6) == 4\nassert powmod(-2,\
    \ 3, 5) == 2\nassert powmod(-2, 2, 5) == 4\nassert powmod(-5, 3, 5) == 0\nassert\
    \ powmod(-2, 0, 5) == 1\nassert powmod(-2, 3, 1) == 0\nassert powmod(low(int),\
    \ 1, high(int)) == high(int) - 1\n\nfor m in 1..31:\n    for a in -64..64:\n \
    \       var expected = 1 mod m\n        let base = ((a mod m) + m) mod m\n   \
    \     for n in 0..20:\n            assert powmod(a, n, m) == expected\n      \
    \      expected = expected * base mod m\n\nwhen compileOption(\"assertions\"):\n\
    \    for m in [-5, 0]:\n        var rejected = false\n        try:\n         \
    \   discard powmod(2, 3, m)\n        except AssertionDefect:\n            rejected\
    \ = true\n        assert rejected\n"
  dependsOn:
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  - cplib/math/inner_math.nim
  - cplib/math/powmod.nim
  isVerificationFile: true
  path: verify/AI/powmod_test.nim
  requiredBy: []
  timestamp: '2026-09-18 02:04:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/powmod_test.nim
layout: document
redirect_from:
- /verify/verify/AI/powmod_test.nim
- /verify/verify/AI/powmod_test.nim.html
title: verify/AI/powmod_test.nim
---
