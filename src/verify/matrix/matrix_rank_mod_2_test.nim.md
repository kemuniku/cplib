---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_mod2.nim
    title: cplib/matrix/matrix_mod2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/matrix/matrix_mod2.nim
    title: cplib/matrix/matrix_mod2.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/matrix_rank_mod_2
    links:
    - https://judge.yosupo.jp/problem/matrix_rank_mod_2
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/matrix_rank_mod_2\n\
    {.checks: off.}\nimport cplib/matrix/matrix_mod2\nimport std/[strutils, sequtils]\n\
    \nlet nm = stdin.readLine.split.map(parseInt)\nlet (n, m) = (nm[0], nm[1])\nvar\
    \ a = initMatrixMod2(n, m)\nfor i in 0..<n:\n    let s = stdin.readLine\n    for\
    \ j in 0..<m: a[i, j] = s[j] == '1'\necho a.rank\n"
  dependsOn:
  - cplib/matrix/matrix_mod2.nim
  - cplib/matrix/matrix_mod2.nim
  isVerificationFile: true
  path: verify/matrix/matrix_rank_mod_2_test.nim
  requiredBy: []
  timestamp: '2026-07-14 07:36:02+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/matrix/matrix_rank_mod_2_test.nim
layout: document
redirect_from:
- /verify/verify/matrix/matrix_rank_mod_2_test.nim
- /verify/verify/matrix/matrix_rank_mod_2_test.nim.html
title: verify/matrix/matrix_rank_mod_2_test.nim
---
