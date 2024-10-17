---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting.nim
    title: cplib/tree/rerooting.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/rerooting.nim
    title: cplib/tree/rerooting.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/tree_path_composite_sum
    links:
    - https://judge.yosupo.jp/problem/tree_path_composite_sum
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_path_composite_sum\n\
    import sequtils, strutils, tables\nimport cplib/tree/rerooting\nimport cplib/graph/graph\n\
    import atcoder/modint\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\",\
    \ varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\ntype\
    \ mint = modint998244353\nvar N = ii()\nvar A = newseqwith(N,ii())\nvar G = initUnWeightedUnDirectedGraph(N)\n\
    var T = initTable[(int,int),(mint,mint)]()\nfor i in 0..<(N-1):\n    var u,v =\
    \ ii()\n    var b,c = ii().mint()\n    G.add_edge(u,v)\n    T[(u,v)] = (b,c)\n\
    \    T[(v,u)] = (b,c)\n\nproc merge(x,y:(mint,int)):(mint,int)=\n    return (x[0]+y[0],x[1]+y[1])\n\
    \nproc put_vertex(x:(mint,int),v:int):(mint,int)=\n    return (x[0] + A[v],x[1]+1)\n\
    \nproc put_edge(x:(mint,int),u,v:int):(mint,int)=\n    var (b,c) = T[(u,v)]\n\
    \    return (b*x[0]+c*x[1],x[1])\n\necho G.solve_Rerooting(merge,(mint(0),0),put_edge,put_vertex).mapit(it[0]).join(\"\
    \ \")\n\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/rerooting.nim
  - cplib/tree/rerooting.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/rerooting_test.nim
  requiredBy: []
  timestamp: '2024-10-03 01:54:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/rerooting_test.nim
layout: document
redirect_from:
- /verify/verify/tree/rerooting_test.nim
- /verify/verify/tree/rerooting_test.nim.html
title: verify/tree/rerooting_test.nim
---
