---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_lazysegtree.nim
    title: cplib/collections/range_reverse_lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/range_reverse_lazysegtree.nim
    title: cplib/collections/range_reverse_lazysegtree.nim
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
    echo \"Hello World\"\nimport sequtils, strutils\nimport cplib/collections/range_reverse_lazysegtree\n\
    \ntype SumLen = tuple[sum: int, len: int]\n\nproc op(a, b: SumLen): SumLen =\n\
    \    (sum: a.sum + b.sum, len: a.len + b.len)\n\nproc mapping(f: int, x: SumLen):\
    \ SumLen =\n    (sum: x.sum + f * x.len, len: x.len)\n\nproc composition(f, g:\
    \ int): int =\n    f + g\n\nvar v: seq[SumLen]\nfor i in 0..<8:\n    v.add((sum:\
    \ i, len: 1))\n\nvar seg = initRangeReverseLazySegmentTree(v, op, (sum: 0, len:\
    \ 0), mapping, composition, 0)\nassert seg.len == 8\nassert seg.get_all.sum ==\
    \ 28\nassert seg.get(2, 6).sum == 14\nassert seg[2..5].sum == 14\n\nseg.apply(1,\
    \ 5, 10)\nassert seg.toSeq.mapIt(it.sum) == @[0, 11, 12, 13, 14, 5, 6, 7]\nassert\
    \ seg.get_all.sum == 68\nassert seg.get(1, 4).sum == 36\n\nseg.reverse(2, 7)\n\
    assert seg.toSeq.mapIt(it.sum) == @[0, 11, 6, 5, 14, 13, 12, 7]\nassert seg.get(2,\
    \ 6).sum == 38\n\nseg.apply(3..5, -3)\nassert seg.toSeq.mapIt(it.sum) == @[0,\
    \ 11, 6, 2, 11, 10, 12, 7]\nassert seg.get_all.sum == 59\n\nseg[4] = (sum: 100,\
    \ len: 1)\nassert seg.toSeq.mapIt(it.sum) == @[0, 11, 6, 2, 100, 10, 12, 7]\n\
    assert seg[^1].sum == 7\nassert seg.fold.sum == 148\n\nvar seg2 = newRangeReverseLazySegWith(\n\
    \    v,\n    (sum: l.sum + r.sum, len: l.len + r.len),\n    (sum: 0, len: 0),\n\
    \    (sum: x.sum + f * x.len, len: x.len),\n    f + g,\n    0\n)\nseg2.reverse(0..<8)\n\
    seg2.apply(0, 3, 1)\nassert seg2.toSeq.mapIt(it.sum) == @[8, 7, 6, 4, 3, 2, 1,\
    \ 0]\n\nproc concat(a, b: string): string =\n    a & b\n\nproc upperMapping(f:\
    \ bool, x: string): string =\n    if f: x.toUpperAscii else: x\n\nproc upperComposition(f,\
    \ g: bool): bool =\n    f or g\n\nvar s = initRangeReverseLazySegmentTree([\"\
    a\", \"b\", \"c\", \"d\", \"e\"], concat, \"\", upperMapping, upperComposition,\
    \ false)\nassert s.get_all == \"abcde\"\ns.apply(1, 4, true)\nassert s.get_all\
    \ == \"aBCDe\"\ns.reverse(0, 5)\nassert s.get_all == \"eDCBa\"\ns.apply(0..<2,\
    \ true)\nassert s.get_all == \"EDCBa\"\ns.reverse(1..3)\nassert s.toSeq == @[\"\
    E\", \"B\", \"C\", \"D\", \"a\"]\ns[2] = \"x\"\nassert s.get_all == \"EBxDa\"\n\
    assert $s == \"E B x D a\"\n"
  dependsOn:
  - cplib/collections/range_reverse_lazysegtree.nim
  - cplib/collections/range_reverse_lazysegtree.nim
  isVerificationFile: true
  path: verify/collections/range_reverse_lazysegtree_test.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/range_reverse_lazysegtree_test.nim
layout: document
redirect_from:
- /verify/verify/collections/range_reverse_lazysegtree_test.nim
- /verify/verify/collections/range_reverse_lazysegtree_test.nim.html
title: verify/collections/range_reverse_lazysegtree_test.nim
---
