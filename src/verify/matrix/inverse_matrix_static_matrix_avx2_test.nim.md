---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/inverse_matrix
    links:
    - https://judge.yosupo.jp/problem/inverse_matrix
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/inverse_matrix

    {.define: testStaticMatrix.}

    {.define: testStaticAvxMatrix.}

    const matrixProblem = "inverse_matrix"

    include linear_algebra/judge_driver

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/matrix/inverse_matrix_static_matrix_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/inverse_matrix_static_matrix_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/inverse_matrix_static_matrix_avx2_test.nim
- /verify/verify/matrix/inverse_matrix_static_matrix_avx2_test.nim.html
title: verify/matrix/inverse_matrix_static_matrix_avx2_test.nim
---
