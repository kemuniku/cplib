---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats.nim
    title: cplib/collections/segtree_beats.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree_beats.nim
    title: cplib/collections/segtree_beats.nim
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
    echo \"Hello World\"\n\nimport strutils\nimport cplib/collections/segtree_beats\n\
    \ntype Node = object\n  sum: int\n  sz: int\n  fail: bool\n\nproc node(x: int):\
    \ Node = Node(sum: x, sz: 1, fail: false)\nproc merge(l, r: Node): Node = Node(sum:\
    \ l.sum + r.sum, sz: l.sz + r.sz, fail: false)\nproc mapping(f: int, x: Node):\
    \ Node = Node(sum: x.sum + f * x.sz, sz: x.sz, fail: false)\nproc composition(f,\
    \ g: int): int = f + g\n\nvar seg = initSegmentTreeBeats(@[node(1), node(2), node(3),\
    \ node(4)], merge, Node(sum: 0, sz: 0, fail: false), mapping, composition, 0)\n\
    assert seg.len == 4\nassert seg.get(0, 4).sum == 10\nassert seg[1..2].sum == 5\n\
    seg.apply(1, 3, 10)\nassert seg.get(0, 4).sum == 30\nassert seg[1].sum == 12\n\
    seg.apply(0..1, -2)\nassert seg[0].sum == -1\nassert seg[1].sum == 10\nseg.update(2,\
    \ node(100))\nassert seg[2].sum == 100\nseg[3] = node(7)\nassert seg.get(0, 4).sum\
    \ == 116\nassert ($seg).contains(\"sum: -1\")\n\nvar seg2 = newLazySegWith(\n\
    \  @[node(2), node(3)],\n  Node(sum: l.sum + r.sum, sz: l.sz + r.sz, fail: false),\n\
    \  Node(sum: 0, sz: 0, fail: false),\n  Node(sum: x.sum + f * x.sz, sz: x.sz,\
    \ fail: false),\n  f + g,\n  0\n)\nseg2.apply(0, 2, 5)\nassert seg2.get(0, 2).sum\
    \ == 15\n"
  dependsOn:
  - cplib/collections/segtree_beats.nim
  - cplib/collections/segtree_beats.nim
  isVerificationFile: true
  path: verify/AI/segtree_beats_test.nim
  requiredBy: []
  timestamp: '2026-07-06 22:23:54+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/segtree_beats_test.nim
layout: document
redirect_from:
- /verify/verify/AI/segtree_beats_test.nim
- /verify/verify/AI/segtree_beats_test.nim.html
title: verify/AI/segtree_beats_test.nim
---
