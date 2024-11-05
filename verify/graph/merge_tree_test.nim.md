---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticrangecount.nim
    title: cplib/collections/staticrangecount.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticrangecount.nim
    title: cplib/collections/staticrangecount.nim
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
    path: cplib/graph/merge_tree.nim
    title: cplib/graph/merge_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/merge_tree.nim
    title: cplib/graph/merge_tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc183/tasks/abc183_f
    links:
    - https://atcoder.jp/contests/abc183/tasks/abc183_f
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc183/tasks/abc183_f\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\nimport cplib/graph/merge_tree\n\
    import cplib/collections/staticrangecount\nimport sequtils\n\n\nvar N,Q = ii()\n\
    var C = newseqwith(N,ii())\nvar querys: seq[(int,int,int)]\nvar v : seq[(int,int)]\n\
    for i in 0..<(Q):\n    var t,x,y = ii()\n    querys.add((t,x,y))\n    if t ==\
    \ 1:\n        v.add((x-1,y-1))\n\nvar MT = initMergeTree(N,v)\nvar SRC = initStaticRangeCount(MT.make_seq(C))\n\
    for i in 0..<(Q):\n    var (t,x,y) = querys[i]\n    if t == 1:\n        MT.unite(x-1,y-1)\n\
    \    else:\n        echo SRC.count(MT.get_range(x-1),y)"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/collections/staticrangecount.nim
  - cplib/collections/staticrangecount.nim
  - cplib/collections/unionfind.nim
  - cplib/graph/merge_tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/merge_tree.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/merge_tree_test.nim
  requiredBy: []
  timestamp: '2024-11-02 13:05:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/merge_tree_test.nim
layout: document
redirect_from:
- /verify/verify/graph/merge_tree_test.nim
- /verify/verify/graph/merge_tree_test.nim.html
title: verify/graph/merge_tree_test.nim
---
