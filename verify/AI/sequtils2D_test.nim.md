---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/sequtils2D.nim
    title: cplib/utils/sequtils2D.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/sequtils2D.nim
    title: cplib/utils/sequtils2D.nim
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


    import cplib/utils/sequtils2D


    let mat = @[@[3, 1], @[4, 2]]

    assert mat.maxIndex == (1, 0)

    assert mat.minIndex == (0, 1)

    '
  dependsOn:
  - cplib/utils/sequtils2D.nim
  - cplib/utils/sequtils2D.nim
  isVerificationFile: true
  path: verify/AI/sequtils2D_test.nim
  requiredBy: []
  timestamp: '2026-07-07 07:12:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/sequtils2D_test.nim
layout: document
redirect_from:
- /verify/verify/AI/sequtils2D_test.nim
- /verify/verify/AI/sequtils2D_test.nim.html
title: verify/AI/sequtils2D_test.nim
---
