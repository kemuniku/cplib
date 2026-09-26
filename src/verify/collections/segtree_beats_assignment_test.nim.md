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
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
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
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    echo \"Hello World\"\n\nimport random, sequtils\nimport cplib/collections/segtree_beats_template\n\
    import cplib/math/int128\n\nproc checkAssignment[T](zero, inf: T) =\n    var seg\
    \ = initRangeChminChmaxRangeSumMaxMin(@[T(1), T(5), T(2), T(7)], inf, zero)\n\
    \    seg.chmin(0..3, T(4))\n    seg.add(0..3, T(3))\n    seg[1] = T(-2)\n    assert\
    \ seg[1].sum == T(-2)\n    assert seg[0..3].sum == T(14)\n    assert seg[0..3].min\
    \ == T(-2)\n    assert seg[0..3].max == T(7)\n    seg.chmax(0..3, T(0))\n    seg[0]\
    \ = T(10)\n    assert seg[0..3].sum == T(22)\n\ncheckAssignment(0, 1_000_000_000)\n\
    checkAssignment(0i32, 1_000_000_000i32)\ncheckAssignment(0.0, 1e100)\ncheckAssignment(to_Int128(0),\
    \ parseInt128(\"1000000000000000000000000000000\"))\n\nvar rng = initRand(2500)\n\
    var a = newSeqWith(12, 0)\nvar seg = initRangeChminChmaxRangeSumMaxMin(a)\nfor\
    \ trial in 0..<300:\n    let l = rng.rand(0..<a.len)\n    let r = rng.rand(l..<a.len)\n\
    \    let x = rng.rand(-20..20)\n    case rng.rand(0..3)\n    of 0:\n        seg[l]\
    \ = x\n        a[l] = x\n    of 1:\n        seg.add(l..r, x)\n        for i in\
    \ l..r: a[i] += x\n    of 2:\n        seg.chmin(l..r, x)\n        for i in l..r:\
    \ a[i] = min(a[i], x)\n    else:\n        seg.chmax(l..r, x)\n        for i in\
    \ l..r: a[i] = max(a[i], x)\n    var total = 0\n    for i, value in a:\n     \
    \   total += value\n        assert seg[i].sum == value\n    assert seg[0..<a.len].sum\
    \ == total\n    assert seg[0..<a.len].min == min(a)\n    assert seg[0..<a.len].max\
    \ == max(a)\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/collections/segtree_beats_template.nim
  - cplib/collections/segtree_beats.nim
  - cplib/math/int128.nim
  - cplib/collections/segtree_beats_template.nim
  - cplib/utils/backwards_index.nim
  - cplib/math/int128.nim
  - cplib/utils/constants.nim
  - cplib/collections/segtree_beats.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/collections/segtree_beats_assignment_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree_beats_assignment_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree_beats_assignment_test.nim
- /verify/verify/collections/segtree_beats_assignment_test.nim.html
title: verify/collections/segtree_beats_assignment_test.nim
---
