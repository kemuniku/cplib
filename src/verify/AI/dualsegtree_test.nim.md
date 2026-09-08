---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dualsegtree.nim
    title: cplib/collections/dualsegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dualsegtree.nim
    title: cplib/collections/dualsegtree.nim
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
    echo \"Hello World\"\n\nimport cplib/collections/dualsegtree\n\ntype Affine =\
    \ tuple[a, b: int]\n\nproc mapping(f: Affine, x: int): int =\n    f.a * x + f.b\n\
    \nproc composition(f, g: Affine): Affine =\n    (f.a * g.a, f.a * g.b + f.b)\n\
    \nlet id = (a: 1, b: 0)\nvar seg = initDualSegmentTree([1, 2, 3, 4, 5], mapping,\
    \ composition, id)\nassert seg.len == 5\nseg.apply(0, 5, (a: 2, b: 1))\nseg.apply(1,\
    \ 4, (a: 3, b: -2))\nassert seg.toSeq == @[3, 13, 19, 25, 11]\nseg.apply(2..4,\
    \ (a: 1, b: 10))\nassert seg[2] == 29\nassert seg[^1] == 21\nseg[3] = 100\nassert\
    \ seg.toSeq == @[3, 13, 29, 100, 21]\nassert $seg == \"3 13 29 100 21\"\n\nvar\
    \ bySize = newDualSegWith(\n    4,\n    5,\n    f.a * x + f.b,\n    (a: f.a *\
    \ g.a, b: f.a * g.b + f.b),\n    (a: 1, b: 0)\n)\nbySize.apply(1, 4, (a: 2, b:\
    \ 0))\nassert bySize.toSeq == @[5, 10, 10, 10]\n\nvar empty = initDualSegmentTree(newSeq[int](),\
    \ mapping, composition, id)\nempty.apply(0, 0, (a: 2, b: 3))\nassert empty.len\
    \ == 0\nassert empty.toSeq == newSeq[int]()\n"
  dependsOn:
  - cplib/collections/dualsegtree.nim
  - cplib/collections/dualsegtree.nim
  isVerificationFile: true
  path: verify/AI/dualsegtree_test.nim
  requiredBy: []
  timestamp: '2026-09-08 11:59:51+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dualsegtree_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dualsegtree_test.nim
- /verify/verify/AI/dualsegtree_test.nim.html
title: verify/AI/dualsegtree_test.nim
---
