---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/tree/cartesiantree.nim
    title: cplib/tree/cartesiantree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/cartesiantree.nim
    title: cplib/tree/cartesiantree.nim
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


    import cplib/tree/cartesiantree


    let t = cartesian_tree_tuple(@[3, 1, 4, 2])

    assert t[1].p == -1

    assert t[1].l == 0

    assert t[1].r == 3

    assert t[3].l == 2

    assert t[0].p == 1

    assert t[2].p == 3

    '
  dependsOn:
  - cplib/tree/cartesiantree.nim
  - cplib/tree/cartesiantree.nim
  isVerificationFile: true
  path: verify/AI/cartesiantree_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/cartesiantree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/cartesiantree_test.nim
- /verify/verify/AI/cartesiantree_test.nim.html
title: verify/AI/cartesiantree_test.nim
---
