---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/system_of_linear_equations_mod_2
    links:
    - https://judge.yosupo.jp/problem/system_of_linear_equations_mod_2
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: '# verification-helper: PROBLEM https://judge.yosupo.jp/problem/system_of_linear_equations_mod_2

    include linear_algebra/system_mod2_driver

    '
  dependsOn: []
  isVerificationFile: true
  path: verify/matrix/system_of_linear_equations_mod_2_test.nim
  requiredBy: []
  timestamp: '2026-09-10 08:33:37+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/matrix/system_of_linear_equations_mod_2_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/system_of_linear_equations_mod_2_test.nim
- /verify/verify/matrix/system_of_linear_equations_mod_2_test.nim.html
title: verify/matrix/system_of_linear_equations_mod_2_test.nim
---
