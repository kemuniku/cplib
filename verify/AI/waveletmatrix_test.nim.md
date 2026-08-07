---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
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


    import cplib/collections/waveletmatrix


    let wm = initWaveletMatrix(@[3, 1, 4, 1, 5, 9, 2, 6])

    assert wm.kth_smallest(0, 8, 0) == 1

    assert wm.kth_smallest(0, 8, 3) == 3

    assert wm.kth_smallest(2, 6, 1) == 4

    assert wm.range_lowerbound(0, 8, 4) == 4

    assert wm.range_upperbound(0, 8, 4) == 5

    assert wm.range_lowerbound(1, 5, 2) == 2

    assert wm.range_upperbound(1, 5, 1) == 2

    let child = wm.get_child(3, 0, 8)

    assert child == (l0: 0, r0: 7, l1: 7, r1: 8)


    let empty = initWaveletMatrix(@[])

    assert empty.range_lowerbound(0, 0, 10) == 0

    '
  dependsOn:
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  isVerificationFile: true
  path: verify/AI/waveletmatrix_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/waveletmatrix_test.nim
layout: document
redirect_from:
- /verify/verify/AI/waveletmatrix_test.nim
- /verify/verify/AI/waveletmatrix_test.nim.html
title: verify/AI/waveletmatrix_test.nim
---
