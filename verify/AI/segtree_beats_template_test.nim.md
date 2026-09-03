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
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    - https://github.com/kemuniku/cplib/issues/485.
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport strutils\nimport cplib/collections/segtree_beats_template\n\
    import cplib/math/int128\n\nvar seg = initRangeChminChmaxRangeSumMaxMin(@[1, 5,\
    \ 2, 7])\nassert seg.len == 4\nassert seg[0..3].sum == 15\nassert seg[0..3].min\
    \ == 1\nassert seg[0..3].max == 7\nseg.chmin(0..3, 4)\nassert seg[0..3].sum ==\
    \ 11\nseg.chmax(1..2, 3)\nassert seg[0..3].sum == 12\nseg.add(2..3, 2)\nassert\
    \ seg[0..3].sum == 16\nseg.update(0, 10)\nassert seg[0].sum == 10\nassert seg[0..3].sum\
    \ == 25\nassert ($seg).contains(\"sum: 10\")\n\n# Regression test for https://github.com/kemuniku/cplib/issues/485.\n\
    # Int128 fields used to be lost when the wrapped segment tree was copied.\nlet\
    \ inf128 = parseInt128(\"1000000000000000000000000000000\")\nvar seg128 = initRangeChminChmaxRangeSumMaxMin(\n\
    \  @[to_Int128(-15), to_Int128(-10), to_Int128(-5), to_Int128(0), to_Int128(5)],\n\
    \  inf128,\n  to_Int128(0)\n)\nseg128.chmax(0..4, to_Int128(-10))\nseg128.add(0..4,\
    \ to_Int128(10))\nseg128.chmin(0..4, to_Int128(10))\nfor i, expected in @[0, 0,\
    \ 5, 10, 10]:\n  assert seg128[i].sum == expected\n"
  dependsOn:
  - cplib/collections/segtree_beats_template.nim
  - cplib/collections/segtree_beats.nim
  - cplib/math/int128.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/collections/segtree_beats.nim
  - cplib/collections/segtree_beats_template.nim
  - cplib/math/int128.nim
  isVerificationFile: true
  path: verify/AI/segtree_beats_template_test.nim
  requiredBy: []
  timestamp: '2026-09-03 23:04:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/segtree_beats_template_test.nim
layout: document
redirect_from:
- /verify/verify/AI/segtree_beats_template_test.nim
- /verify/verify/AI/segtree_beats_template_test.nim.html
title: verify/AI/segtree_beats_template_test.nim
---
