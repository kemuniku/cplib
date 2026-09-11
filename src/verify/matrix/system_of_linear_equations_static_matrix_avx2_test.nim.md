---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/system_of_linear_equations
    links:
    - https://judge.yosupo.jp/problem/system_of_linear_equations
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/system_of_linear_equations

    {.define: testStaticMatrix.}

    {.define: testStaticAvxMatrix.}

    const matrixProblem = "system_of_linear_equations"

    include linear_algebra/judge_driver

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/matrix/system_of_linear_equations_static_matrix_avx2_test.nim
  requiredBy: []
  timestamp: '2026-09-11 02:58:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/system_of_linear_equations_static_matrix_avx2_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/system_of_linear_equations_static_matrix_avx2_test.nim
- /verify/verify/matrix/system_of_linear_equations_static_matrix_avx2_test.nim.html
title: verify/matrix/system_of_linear_equations_static_matrix_avx2_test.nim
---
