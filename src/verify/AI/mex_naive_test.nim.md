---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/mex_naive.nim
    title: cplib/math/mex_naive.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/mex_naive.nim
    title: cplib/math/mex_naive.nim
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


    import cplib/math/mex_naive


    assert mex_naive(@[0, 1, 3, 1]) == 2

    assert mex_naive(@[1, 2, 3]) == 0

    '
  dependsOn:
  - cplib/math/mex_naive.nim
  - cplib/math/mex_naive.nim
  isVerificationFile: true
  path: verify/AI/mex_naive_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/mex_naive_test.nim
layout: document
redirect_from:
- /verify/verify/AI/mex_naive_test.nim
- /verify/verify/AI/mex_naive_test.nim.html
title: verify/AI/mex_naive_test.nim
---
