---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx512.nim
    title: cplib/graph/warshall_floyd_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_avx512.nim
    title: cplib/graph/warshall_floyd_avx512.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/warshall_floyd_negative.nim
    title: cplib/graph/warshall_floyd_negative.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_cases.nim
    title: verify/AI/warshall_floyd_avx512_register_cases.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/warshall_floyd_avx512_register_cases.nim
    title: verify/AI/warshall_floyd_avx512_register_cases.nim
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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    import verify/AI/warshall_floyd_avx512_register_cases


    runRegisterTests(5)

    '
  dependsOn:
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/warshall_floyd_negative.nim
  - cplib/graph/graph.nim
  - verify/AI/warshall_floyd_avx512_register_cases.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/warshall_floyd_avx512.nim
  - cplib/utils/constants.nim
  - verify/AI/warshall_floyd_avx512_register_cases.nim
  isVerificationFile: true
  path: verify/AI/warshall_floyd_avx512_register_int32_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/warshall_floyd_avx512_register_int32_test.nim
layout: document
redirect_from:
- /verify/verify/AI/warshall_floyd_avx512_register_int32_test.nim
- /verify/verify/AI/warshall_floyd_avx512_register_int32_test.nim.html
title: verify/AI/warshall_floyd_avx512_register_int32_test.nim
---
