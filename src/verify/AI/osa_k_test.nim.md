---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/osa_k.nim
    title: cplib/math/osa_k.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/osa_k.nim
    title: cplib/math/osa_k.nim
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

    echo "Hello World"


    import tables

    import cplib/math/osa_k


    let table = initPrimeFactorTable(100)

    assert table.primefactor(1) == @[]

    assert table.primefactor(84) == @[2, 2, 3, 7]

    let pf = table.primefactor_table(84)

    assert pf[2] == 2

    assert pf[3] == 1

    assert pf[7] == 1

    assert table.primefactor_tuple(84) == @[(2, 2), (3, 1), (7, 1)]

    '
  dependsOn:
  - cplib/math/osa_k.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/osa_k.nim
  - cplib/str/run_length_encode.nim
  isVerificationFile: true
  path: verify/AI/osa_k_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/osa_k_test.nim
layout: document
redirect_from:
- /verify/verify/AI/osa_k_test.nim
- /verify/verify/AI/osa_k_test.nim.html
title: verify/AI/osa_k_test.nim
---
