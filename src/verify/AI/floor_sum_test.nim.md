---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/floor_sum.nim
    title: cplib/math/floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/floor_sum.nim
    title: cplib/math/floor_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    import cplib/math/floor_sum\n\nfor n in 0..20:\n    for m in 1..20:\n        for\
    \ a in 0..30:\n            for b in 0..30:\n                var expected = 0\n\
    \                for i in 0..<n:\n                    expected += (a * i + b)\
    \ div m\n                doAssert floor_sum(n, m, a, b) == expected\n\nlet limit\
    \ = high(int)\ndoAssert floor_sum(0, 1, limit, limit) == 0\ndoAssert floor_sum(limit,\
    \ limit, 0, limit) == limit\ndoAssert floor_sum(limit, limit, 1, 0) == 0\ndoAssert\
    \ floor_sum(limit, limit, 1, limit - 1) == limit - 1\ndoAssert floor_sum(1, 1,\
    \ limit, limit) == limit\ndoAssert floor_sum(2, limit, limit, limit) == 3\nlet\
    \ large = int(4_000_000_000)\ndoAssert floor_sum(large, 1, 1, 0) == 7_999_999_998_000_000_000\n\
    doAssert floor_sum(large, large, large - 1, large - 1) == 7_999_999_998_000_000_000\n\
    \necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  - cplib/math/floor_sum.nim
  - cplib/math/floor_sum.nim
  isVerificationFile: true
  path: verify/AI/floor_sum_test.nim
  requiredBy: []
  timestamp: '2026-09-12 14:53:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/floor_sum_test.nim
layout: document
redirect_from:
- /verify/verify/AI/floor_sum_test.nim
- /verify/verify/AI/floor_sum_test.nim.html
title: verify/AI/floor_sum_test.nim
---
