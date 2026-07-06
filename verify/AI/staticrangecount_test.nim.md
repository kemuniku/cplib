---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticrangecount.nim
    title: cplib/collections/staticrangecount.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticrangecount.nim
    title: cplib/collections/staticrangecount.nim
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


    import cplib/collections/staticrangecount


    var rc = initStaticRangeCount(@[1, 2, 1, 3, 1, 2])

    assert rc.count(0, 6, 1) == 3

    assert rc.count(1, 5, 1) == 2

    assert rc.count(0..2, 1) == 2

    assert rc.count(2..5, 2) == 1

    assert rc.count(0, 6, 9) == 0

    '
  dependsOn:
  - cplib/collections/staticrangecount.nim
  - cplib/collections/staticrangecount.nim
  isVerificationFile: true
  path: verify/AI/staticrangecount_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/staticrangecount_test.nim
layout: document
redirect_from:
- /verify/verify/AI/staticrangecount_test.nim
- /verify/verify/AI/staticrangecount_test.nim.html
title: verify/AI/staticrangecount_test.nim
---
