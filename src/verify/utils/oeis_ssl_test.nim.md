---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/oeis.nim
    title: cplib/utils/oeis.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/oeis.nim
    title: cplib/utils/oeis.nim
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
    \nimport cplib/utils/oeis\nimport net\n\nstatic:\n    doAssert declared(newContext)\n\
    \nlet context = newContext()\ncontext.destroyContext()\ndoAssert searchOEIS(newSeq[int]()).len\
    \ == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/utils/oeis.nim
  - cplib/math/fractions.nim
  - cplib/utils/oeis.nim
  isVerificationFile: true
  path: verify/utils/oeis_ssl_test.nim
  requiredBy: []
  timestamp: '2026-10-14 21:36:14+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/oeis_ssl_test.nim
layout: document
redirect_from:
- /verify/verify/utils/oeis_ssl_test.nim
- /verify/verify/utils/oeis_ssl_test.nim.html
title: verify/utils/oeis_ssl_test.nim
---
