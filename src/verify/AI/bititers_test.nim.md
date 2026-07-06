---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
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


    import sequtils

    import cplib/utils/bititers


    assert toSeq(bitcomb(4, 2)) == @[0b0011, 0b0101, 0b0110, 0b1001, 0b1010, 0b1100]

    assert toSeq(bitcomb(3, 0)) == @[0]

    assert toSeq(bitsubseteq(0b101)) == @[0, 1, 4, 5]

    assert toSeq(bitsubset(0b101)) == @[0, 1, 4]

    assert toSeq(bitsubseteq_descending(0b101)) == @[5, 4, 1, 0]

    assert toSeq(bitsubset_descending(0b101)) == @[4, 1, 0]

    assert toSeq(bitsuperseteq(0b001, 3)) == @[1, 3, 5, 7]

    assert toSeq(bitsuperset(0b001, 3)) == @[3, 5, 7]

    assert toSeq(bitsingleton(0b10110)) == @[0b10, 0b100, 0b10000]

    assert toSeq(standingbits(0b10110)) == @[1, 2, 4]

    '
  dependsOn:
  - cplib/utils/bititers.nim
  - cplib/utils/bititers.nim
  isVerificationFile: true
  path: verify/AI/bititers_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/bititers_test.nim
layout: document
redirect_from:
- /verify/verify/AI/bititers_test.nim
- /verify/verify/AI/bititers_test.nim.html
title: verify/AI/bititers_test.nim
---
