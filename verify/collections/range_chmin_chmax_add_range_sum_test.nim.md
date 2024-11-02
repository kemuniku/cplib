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
    PROBLEM: https://judge.yosupo.jp/problem/range_chmin_chmax_add_range_sum
    links:
    - https://judge.yosupo.jp/problem/range_chmin_chmax_add_range_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/range_chmin_chmax_add_range_sum\n\
    import sequtils\nimport cplib/collections/segtree_beats_template\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n, q = ii()\nvar a = newSeqWith(n, ii())\nvar seg\
    \ = initRangeChminChmaxRangeSumMaxMin(a)\nfor _ in 0..<q:\n    var t = ii()\n\
    \    if t == 0:\n        var l, r, b = ii()\n        seg.chmin(l..<r, b)\n   \
    \ elif t == 1:\n        var l, r, b = ii()\n        seg.chmax(l..<r, b)\n    elif\
    \ t == 2:\n        var l, r, b = ii()\n        seg.add(l..<r, b)\n    else:\n\
    \        var l, r = ii()\n        echo seg[l..<r].sum\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/collections/segtree_beats.nim
  - cplib/collections/segtree_beats_template.nim
  - cplib/collections/segtree_beats_template.nim
  - cplib/collections/segtree_beats.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/collections/range_chmin_chmax_add_range_sum_test.nim
  requiredBy: []
  timestamp: '2024-09-23 17:09:04+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_chmin_chmax_add_range_sum_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_chmin_chmax_add_range_sum_test.nim
- /verify/verify/collections/range_chmin_chmax_add_range_sum_test.nim.html
title: verify/collections/range_chmin_chmax_add_range_sum_test.nim
---
