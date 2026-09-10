---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/hafnian_of_matrix
    links:
    - https://judge.yosupo.jp/problem/hafnian_of_matrix
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/hafnian_of_matrix

    {.define: testStaticMatrix.}

    const matrixProblem = "hafnian_of_matrix"

    include linear_algebra/judge_driver

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/matrix/hafnian_of_matrix_static_matrix_test.nim
  requiredBy: []
  timestamp: '2026-09-10 06:38:45+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/hafnian_of_matrix_static_matrix_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/hafnian_of_matrix_static_matrix_test.nim
- /verify/verify/matrix/hafnian_of_matrix_static_matrix_test.nim.html
title: verify/matrix/hafnian_of_matrix_static_matrix_test.nim
---
