---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dualsegtree_static_op.nim
    title: cplib/collections/dualsegtree_static_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dualsegtree_static_op.nim
    title: cplib/collections/dualsegtree_static_op.nim
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
    echo \"Hello World\"\n\nimport cplib/collections/dualsegtree_static_op\n\ntype\
    \ Affine = tuple[a, b: int]\n\nvar seg = newDualSegWith(\n    @[1, 2, 3, 4, 5],\n\
    \    f.a * x + f.b,\n    (a: f.a * g.a, b: f.a * g.b + f.b),\n    (a: 1, b: 0)\n\
    )\nassert seg.len == 5\nseg.apply(0, 5, (a: 2, b: 1))\nseg.apply(1, 4, (a: 3,\
    \ b: -2))\nassert seg.toSeq == @[3, 13, 19, 25, 11]\nseg.apply(2..4, (a: 1, b:\
    \ 10))\nassert seg[2] == 29\nassert seg[^1] == 21\nseg[3] = 100\nassert seg.toSeq\
    \ == @[3, 13, 29, 100, 21]\nassert $seg == \"3 13 29 100 21\"\n\nvar bySize =\
    \ newDualSegWith(\n    4,\n    5,\n    f.a * x + f.b,\n    (a: f.a * g.a, b: f.a\
    \ * g.b + f.b),\n    (a: 1, b: 0)\n)\nbySize.apply(1, 4, (a: 2, b: 0))\nassert\
    \ bySize.toSeq == @[5, 10, 10, 10]\n\nvar initializedWithProc = initDualSegmentTree(\n\
    \    @[1, 2, 3],\n    proc(f: Affine, x: int): int = f.a * x + f.b,\n    proc(f,\
    \ g: Affine): Affine = (f.a * g.a, f.a * g.b + f.b),\n    (a: 1, b: 0)\n)\ninitializedWithProc.apply(0,\
    \ 3, (a: 2, b: 1))\nassert initializedWithProc.toSeq == @[3, 5, 7]\n\nvar empty\
    \ = initDualSegmentTree(\n    newSeq[int](),\n    proc(f: Affine, x: int): int\
    \ = f.a * x + f.b,\n    proc(f, g: Affine): Affine = (f.a * g.a, f.a * g.b + f.b),\n\
    \    (a: 1, b: 0)\n)\nempty.apply(0, 0, (a: 2, b: 3))\nassert empty.len == 0\n\
    assert empty.toSeq == newSeq[int]()\n"
  dependsOn:
  - cplib/collections/dualsegtree_static_op.nim
  - cplib/collections/dualsegtree_static_op.nim
  isVerificationFile: true
  path: verify/AI/dualsegtree_static_op_test.nim
  requiredBy: []
  timestamp: '2026-09-08 12:23:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/dualsegtree_static_op_test.nim
layout: document
redirect_from:
- /verify/verify/AI/dualsegtree_static_op_test.nim
- /verify/verify/AI/dualsegtree_static_op_test.nim.html
title: verify/AI/dualsegtree_static_op_test.nim
---
