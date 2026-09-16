---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/optimize.nim
    title: cplib/tmpl/optimize.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/optimize.nim
    title: cplib/tmpl/optimize.nim
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
    import cplib/tmpl/optimize\n\noptimizeCpp()\n\nwhen defined(second_compile):\n\
    \    doAssert defined(cpp)\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tmpl/optimize.nim
  - cplib/tmpl/optimize.nim
  isVerificationFile: true
  path: verify/AI/optimize_cpp_test.nim
  requiredBy: []
  timestamp: '2026-09-14 23:47:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/optimize_cpp_test.nim
layout: document
redirect_from:
- /verify/verify/AI/optimize_cpp_test.nim
- /verify/verify/AI/optimize_cpp_test.nim.html
title: verify/AI/optimize_cpp_test.nim
---
