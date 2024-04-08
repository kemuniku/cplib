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
    PROBLEM: https://judge.yosupo.jp/problem/vertex_add_path_sum
    links:
    - https://judge.yosupo.jp/problem/vertex_add_path_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/vertex_add_path_sum\n\
    import sequtils, strutils, sugar\nimport cplib/graph/graph\nimport cplib/collections/segtree\n\
    import cplib/tree/heavylightdecomposition\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar n, q = ii()\nvar a = newSeqWith(n, ii())\nvar g = initUnWeightedUnDirectedStaticGraph(n)\n\
    for i in 0..<n-1:\n    var u, v = ii()\n    g.add_edge(u, v)\ng.build\n\nvar hld\
    \ = initHld(g, 0)\nvar v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(a[it])\n\n\
    var seg = newSegWith(v, l+r, 0)\nvar ans = newSeqOfCap[int](q)\n\nfor i in 0..<q:\n\
    \    var t = ii()\n    if t == 0:\n        var p, x = ii()\n        seg[hld.toSeq(p)]\
    \ = seg[hld.toSeq(p)] + x\n    else:\n        var u, v = ii()\n        var l =\
    \ hld.lca(u, v)\n        var a = 0\n        for (l, r) in hld.path(l, u, true,\
    \ false): a += seg.get(l..<r)\n        for (l, r) in hld.path(l, v, false, false):\
    \ a += seg.get(l..<r)\n        ans.add(a)\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/collections/segtree.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/hld/hld_vertex_add_path_sum_test.nim
  requiredBy: []
  timestamp: '2024-03-22 19:57:48+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/hld/hld_vertex_add_path_sum_test.nim
layout: document
redirect_from:
- /verify/verify/tree/hld/hld_vertex_add_path_sum_test.nim
- /verify/verify/tree/hld/hld_vertex_add_path_sum_test.nim.html
title: verify/tree/hld/hld_vertex_add_path_sum_test.nim
---
