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
    PROBLEM: https://judge.yosupo.jp/problem/vertex_add_subtree_sum
    links:
    - https://judge.yosupo.jp/problem/vertex_add_subtree_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_add_subtree_sum\n\
    import sequtils, strutils, algorithm, sugar\nimport cplib/graph/graph\nimport\
    \ cplib/collections/segtree\nimport cplib/tree/heavylightdecomposition\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n, q = ii()\nvar a = newSeqWith(n, ii())\nvar g\
    \ = initUnWeightedUnDirectedStaticGraph(n)\nfor i in 0..<n-1:\n    var p = ii()\n\
    \    g.add_edge(i+1, p)\ng.build\n\nvar hld = initHld(g, 0)\nvar v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(a[it])\n\
    \nvar seg = newSegWith(v, l+r, 0)\nvar ans = newSeqOfCap[int](q)\n\nfor i in 0..<q:\n\
    \    var t = ii()\n    if t == 0:\n        var u, x = ii()\n        seg[hld.toSeq(u)]\
    \ = seg[hld.toSeq(u)] + x\n    else:\n        var u = ii()\n        var (l, r)\
    \ = hld.subtree(u)\n        var a = seg.get(l..<r)\n        ans.add(a)\necho ans.join(\"\
    \\n\")\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/graph/graph.nim
  - cplib/collections/segtree.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: true
  path: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
layout: document
redirect_from:
- /verify/verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
- /verify/verify/tree/hld/hld_vertex_add_subtree_sum_test.nim.html
title: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
---
