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
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc220/tasks/abc220_f
    links:
    - https://atcoder.jp/contests/abc220/tasks/abc220_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc220/tasks/abc220_f\n\
    import sequtils, strutils, tables\nimport cplib/tree/rerooting\nimport cplib/graph/graph\n\
    import atcoder/modint\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\",\
    \ varargs.}\nproc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nvar\
    \ N = ii()\nvar G = initUnWeightedUnDirectedGraph(N)\nfor i in 0..<(N-1):\n  \
    \  var A,B = ii()-1\n    G.add_edge(A,B)\n\nproc merge(x,y:(int,int)):(int,int)=\n\
    \    return (x[0]+y[0],x[1]+y[1])\nproc put_vertex(x:(int,int),v:int):(int,int)=\n\
    \    return x\nproc put_edge(x:(int,int),u,v:int):(int,int)=\n    return (x[0]+x[1]+1,x[1]+1)\n\
    \necho G.solve_Rerooting(merge,(0,0),put_edge,put_vertex).mapit(it[0]).join(\"\
    \\n\")\n"
  dependsOn:
  - cplib/tree/rerooting.nim
  - cplib/tree/rerooting.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/tree/rerooting_big_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:49:49+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/tree/rerooting_big_test_.nim
layout: document
redirect_from:
- /library/verify/tree/rerooting_big_test_.nim
- /library/verify/tree/rerooting_big_test_.nim.html
title: verify/tree/rerooting_big_test_.nim
---
