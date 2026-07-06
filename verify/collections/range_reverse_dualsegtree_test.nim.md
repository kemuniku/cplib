---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_dualsegtree.nim
    title: cplib/collections/range_reverse_dualsegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_dualsegtree.nim
    title: cplib/collections/range_reverse_dualsegtree.nim
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
    echo \"Hello World\"\nimport sequtils\nimport cplib/collections/range_reverse_dualsegtree\n\
    \nproc addMapping(f, x: int): int =\n    x + f\n\nproc addComposition(f, g: int):\
    \ int =\n    f + g\n\nvar seg = initRangeReverseDualSegmentTree([0, 1, 2, 3, 4,\
    \ 5, 6, 7], addMapping, addComposition, 0)\nassert seg.len == 8\nassert seg.toSeq\
    \ == @[0, 1, 2, 3, 4, 5, 6, 7]\n\nseg.apply(2, 6, 10)\nassert seg.toSeq == @[0,\
    \ 1, 12, 13, 14, 15, 6, 7]\nassert seg[3] == 13\n\nseg.reverse(1, 7)\nassert seg.toSeq\
    \ == @[0, 6, 15, 14, 13, 12, 1, 7]\nassert seg[^1] == 7\n\nseg.apply(3..5, -2)\n\
    assert seg.toSeq == @[0, 6, 15, 12, 11, 10, 1, 7]\n\nseg[4] = 100\nassert seg.toSeq\
    \ == @[0, 6, 15, 12, 100, 10, 1, 7]\nseg.reverse(0..<8)\nassert seg.toSeq == @[7,\
    \ 1, 10, 100, 12, 15, 6, 0]\n\nvar empty = initRangeReverseDualSegmentTree(newSeq[int](),\
    \ addMapping, addComposition, 0)\nempty.apply(0, 0, 1)\nempty.reverse(0, 0)\n\
    assert empty.len == 0\nassert empty.toSeq == newSeq[int]()\n\ntype Affine = tuple[a:\
    \ int, b: int]\n\nproc affineMapping(f: Affine, x: int): int =\n    f.a * x +\
    \ f.b\n\nproc affineComposition(f, g: Affine): Affine =\n    (a: f.a * g.a, b:\
    \ f.a * g.b + f.b)\n\nvar affine = newRangeReverseDualSegWith(\n    @[1, 2, 3,\
    \ 4],\n    f.a * x + f.b,\n    (a: f.a * g.a, b: f.a * g.b + f.b),\n    (a: 1,\
    \ b: 0)\n)\naffine.apply(0, 4, (a: 2, b: 1))\naffine.apply(1, 3, (a: 3, b: -2))\n\
    assert affine.toSeq == @[3, 13, 19, 9]\naffine.reverse(0..3)\nassert affine.toSeq\
    \ == @[9, 19, 13, 3]\n\nvar initializedBySize = initRangeReverseDualSegmentTree(4,\
    \ 5, affineMapping, affineComposition, (a: 1, b: 0))\ninitializedBySize.apply(1,\
    \ 4, (a: 2, b: 0))\nassert initializedBySize.toSeq == @[5, 10, 10, 10]\ninitializedBySize.reverse(0,\
    \ 4)\nassert initializedBySize.toSeq == @[10, 10, 10, 5]\n\nvar initializedBySizeTemplate\
    \ = newRangeReverseDualSegWith(\n    3,\n    1,\n    f.a * x + f.b,\n    (a: f.a\
    \ * g.a, b: f.a * g.b + f.b),\n    (a: 1, b: 0)\n)\ninitializedBySizeTemplate.apply(0,\
    \ 3, (a: 4, b: 2))\nassert initializedBySizeTemplate.toSeq == @[6, 6, 6]\n"
  dependsOn:
  - cplib/collections/range_reverse_dualsegtree.nim
  - cplib/collections/range_reverse_dualsegtree.nim
  isVerificationFile: true
  path: verify/collections/range_reverse_dualsegtree_test.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_dualsegtree_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_dualsegtree_test.nim
- /verify/verify/collections/range_reverse_dualsegtree_test.nim.html
title: verify/collections/range_reverse_dualsegtree_test.nim
---
