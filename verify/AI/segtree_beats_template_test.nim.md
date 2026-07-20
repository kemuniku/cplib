---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats.nim
    title: cplib/collections/segtree_beats.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats.nim
    title: cplib/collections/segtree_beats.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats_template.nim
    title: cplib/collections/segtree_beats_template.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats_template.nim
    title: cplib/collections/segtree_beats_template.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
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


    import strutils

    import cplib/collections/segtree_beats_template


    var seg = initRangeChminChmaxRangeSumMaxMin(@[1, 5, 2, 7])

    assert seg.len == 4

    assert seg[0..3].sum == 15

    assert seg[0..3].min == 1

    assert seg[0..3].max == 7

    seg.chmin(0..3, 4)

    assert seg[0..3].sum == 11

    seg.chmax(1..2, 3)

    assert seg[0..3].sum == 12

    seg.add(2..3, 2)

    assert seg[0..3].sum == 16

    seg.update(0, 10)

    assert seg[0].sum == 10

    assert seg[0..3].sum == 25

    assert ($seg).contains("sum: 10")

    '
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/collections/segtree_beats.nim
  - cplib/collections/segtree_beats.nim
  - cplib/collections/segtree_beats_template.nim
  - cplib/collections/segtree_beats_template.nim
  isVerificationFile: true
  path: verify/AI/segtree_beats_template_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/segtree_beats_template_test.nim
layout: document
redirect_from:
- /verify/verify/AI/segtree_beats_template_test.nim
- /verify/verify/AI/segtree_beats_template_test.nim.html
title: verify/AI/segtree_beats_template_test.nim
---
