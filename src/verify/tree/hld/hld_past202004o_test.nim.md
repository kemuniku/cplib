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
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
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
    PROBLEM: https://atcoder.jp/contests/past202004-open/tasks/past202004_o
    links:
    - https://atcoder.jp/contests/past202004-open/tasks/past202004_o
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/past202004-open/tasks/past202004_o\n\
    import sequtils, tables, strutils, heapqueue, hashes\nimport cplib/graph/graph\n\
    import cplib/collections/unionfind\nimport cplib/collections/segtree\nimport cplib/utils/constants\n\
    import cplib/tree/heavylightdecomposition\nproc scanf(formatstr: cstring){.header:\
    \ \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr\
    \ result)\n\nvar n, m = ii()\nvar ans = newSeqWith(m, -1)\nvar hq = initHeapQueue[(int,\
    \ int, int, int)]()\nvar e = initTable[(int, int), int](m)\nvar abc = newSeq[(int,\
    \ int, int)]()\nfor i in 0..<m:\n    var a, b = ii() - 1\n    var c = ii()\n \
    \   abc.add((a, b, c))\n    e[(a, b)] = c\n    e[(b, a)] = c\n    hq.push((c,\
    \ a, b, i))\nvar uf = initUnionFind(n)\nvar g = initUnWeightedUnDirectedGraph(n)\n\
    \nvar ai = 0\nwhile hq.len > 0:\n    var (c, a, b, id) = hq.pop\n    if uf.issame(a,\
    \ b): continue\n    uf.unite(a, b)\n    g.add_edge(a, b)\n    ans[id] = 0\n  \
    \  ai += c\nfor i in 0..<m:\n    if ans[i] == 0: ans[i] = ai\n\nvar hld = initHld(g,\
    \ 0)\nvar v = (0..<n).toSeq.mapIt(hld.toVtx(it)).mapIt(if hld.P[it] == -1: 0 else:\
    \ e[(it, hld.P[it])])\n\nvar seg = newSegWith(v, max(l, r), -INF64)\n\nfor i in\
    \ 0..<m:\n    if ans[i] != -1: continue\n    var (a, b, c) = abc[i]\n    var l\
    \ = hld.lca(a, b)\n    var mx = -INF64\n    for (l, r) in hld.path(l, a, false,\
    \ false): mx = max(mx, seg.get(l..<r))\n    for (l, r) in hld.path(l, b, false,\
    \ false): mx = max(mx, seg.get(l..<r))\n    ans[i] = ai - mx + c\necho ans.join(\"\
    \\n\")\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/collections/unionfind.nim
  - cplib/collections/segtree.nim
  - cplib/utils/constants.nim
  - cplib/collections/unionfind.nim
  - cplib/collections/segtree.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  isVerificationFile: true
  path: verify/tree/hld/hld_past202004o_test.nim
  requiredBy: []
  timestamp: '2024-06-25 03:55:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/hld/hld_past202004o_test.nim
layout: document
redirect_from:
- /verify/verify/tree/hld/hld_past202004o_test.nim
- /verify/verify/tree/hld/hld_past202004o_test.nim.html
title: verify/tree/hld/hld_past202004o_test.nim
---