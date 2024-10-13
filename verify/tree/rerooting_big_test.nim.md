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
    PROBLEM: https://atcoder.jp/contests/abc220/tasks/abc220_f
    links:
    - https://atcoder.jp/contests/abc220/tasks/abc220_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
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
  - cplib/graph/graph.nim
  - cplib/tree/rerooting.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/rerooting_big_test.nim
  requiredBy: []
  timestamp: '2024-10-03 01:54:09+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/rerooting_big_test.nim
layout: document
redirect_from:
- /verify/verify/tree/rerooting_big_test.nim
- /verify/verify/tree/rerooting_big_test.nim.html
title: verify/tree/rerooting_big_test.nim
---