---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/rollback_unionfind.nim
    title: cplib/collections/rollback_unionfind.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc302/tasks/abc302_ex
    links:
    - https://atcoder.jp/contests/abc302/tasks/abc302_ex
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc302/tasks/abc302_ex\n\
    import sequtils, strutils\nimport cplib/graph/graph\nimport cplib/collections/rollback_unionfind\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar n = ii()\nvar ab = newSeqWith(n,\
    \ (ii()-1, ii()-1))\nvar g = initUnWeightedUnDirectedStaticGraph(n)\nfor i in\
    \ 0..<n-1:\n    var u, v = ii() - 1\n    g.add_edge(u, v)\ng.build\n\nvar es =\
    \ newSeqWith(n, (0, 1))\nvar uf = initRollbackUnionFind(n)\nvar cur = 0\nvar ans\
    \ = newSeq[int](n-1)\nproc dfs(x, par: int) =\n    var (a, b) = ab[x]\n    a =\
    \ uf.root(a)\n    b = uf.root(b)\n    var merge = false\n    var (ea, sa) = es[a]\n\
    \    var (eb, sb) = es[b]\n    if not uf.issame(a, b):\n        uf.unite(a, b)\n\
    \        es[uf.root(a)] = (ea+eb+1, sa+sb)\n        cur -= min(ea, sa) + min(eb,\
    \ sb)\n        cur += min(ea+eb+1, sa+sb)\n        merge = true\n    else:\n \
    \       var (e, s) = es[uf.root(a)]\n        cur -= min(e, s)\n        es[uf.root(a)]\
    \ = (e+1, s)\n        cur += min(e+1, s)\n    if x != 0: ans[x-1] = cur\n    for\
    \ y in g[x]:\n        if y == par: continue\n        dfs(y, x)\n    if merge:\n\
    \        var (e, s) = es[uf.root(a)]\n        cur -= min(e, s)\n        uf.undo()\n\
    \        es[a] = (ea, sa)\n        es[b] = (eb, sb)\n        cur += min(ea, sa)\
    \ + min(eb, sb)\n    else:\n        var (e, s) = es[uf.root(a)]\n        cur -=\
    \ min(e, s)\n        es[uf.root(a)] = (e-1, s)\n        cur += min(e-1, s)\ndfs(0,\
    \ -1)\necho ans.join(\" \")\n"
  dependsOn:
  - cplib/collections/rollback_unionfind.nim
  - cplib/collections/rollback_unionfind.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/collections/rollback_uf_abc302ex_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/rollback_uf_abc302ex_test.nim
layout: document
redirect_from:
- /verify/verify/collections/rollback_uf_abc302ex_test.nim
- /verify/verify/collections/rollback_uf_abc302ex_test.nim.html
title: verify/collections/rollback_uf_abc302ex_test.nim
---
