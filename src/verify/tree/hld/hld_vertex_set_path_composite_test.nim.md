---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/vertex_set_path_composite
    links:
    - https://judge.yosupo.jp/problem/vertex_set_path_composite
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_set_path_composite\n\
    import sequtils, strutils, algorithm\nimport cplib/graph/graph\nimport cplib/collections/segtree\n\
    import cplib/tree/heavylightdecomposition\ninclude atcoder/modint\ntype mint =\
    \ modint998244353\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar n, q = ii()\n\
    var a = newSeqWith(n, (mint(ii()), mint(ii())))\nvar g = initUnWeightedUnDirectedStaticGraph(n)\n\
    for i in 0..<n-1:\n    var u, v = ii()\n    g.add_edge(u, v)\ng.build\n\nvar hld\
    \ = initHld(g, 0)\nvar v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(a[it])\nproc\
    \ op(x, y: (mint, mint)): (mint, mint) =\n    var (a, b) = x\n    var (c, d) =\
    \ y\n    return (a*c, c*b+d)\n\nvar seg = initSegmentTree[(mint, mint)](v, op,\
    \ (mint(1), mint(0)))\nvar segr = initSegmentTree[(mint, mint)](v.reversed, op,\
    \ (mint(1), mint(0)))\nvar ans = newSeqOfCap[int](q)\n\nfor i in 0..<q:\n    var\
    \ t = ii()\n    if t == 0:\n        var p, c, d = ii()\n        seg[hld.toSeq(p)]\
    \ = (mint(c), mint(d))\n        segr[n - 1 - hld.toSeq(p)] = (mint(c), mint(d))\n\
    \    else:\n        var u, v, x = ii()\n        var l = hld.lca(u, v)\n      \
    \  var a = (mint(1), mint(0))\n        for (l, r) in hld.path(l, u, true, true):\
    \ a = op(a, segr.get(l..<r))\n        for (l, r) in hld.path(l, v, false, false):\
    \ a = op(a, seg.get(l..<r))\n        ans.add((a[0] * x + a[1]).val)\necho ans.join(\"\
    \\n\")\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/collections/segtree.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/tree/hld/hld_vertex_set_path_composite_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/hld/hld_vertex_set_path_composite_test.nim
layout: document
redirect_from:
- /verify/verify/tree/hld/hld_vertex_set_path_composite_test.nim
- /verify/verify/tree/hld/hld_vertex_set_path_composite_test.nim.html
title: verify/tree/hld/hld_vertex_set_path_composite_test.nim
---
