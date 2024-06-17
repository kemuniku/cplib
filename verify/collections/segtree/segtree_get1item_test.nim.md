---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc265/tasks/abc265_b
    links:
    - https://atcoder.jp/contests/abc265/tasks/abc265_b
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc265/tasks/abc265_b\n\
    import sequtils, tables, sugar\nimport cplib/collections/segtree\n\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar N, M, T = ii()\nvar A = newSeqWith(N-1, ii())\n\
    var st = initSegmentTree(A, (a, b: int) => (a + b), 0)\nvar bonus = initTable[int,\
    \ int]()\nfor _ in 0..<M:\n    var X, Y = ii()\n    bonus[X] = Y\nvar now = 1\n\
    for i in 0..<N-1:\n    if T > st[i]:\n        T -= st[i]\n        now += 1\n \
    \       if now in bonus:\n            T += bonus[now]\n    else:\n        echo\
    \ (\"No\")\n        quit()\necho (\"Yes\")\n"
  dependsOn:
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/collections/segtree/segtree_get1item_test.nim
  requiredBy: []
  timestamp: '2024-06-17 22:20:15+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/collections/segtree/segtree_get1item_test.nim
layout: document
redirect_from:
- /verify/verify/collections/segtree/segtree_get1item_test.nim
- /verify/verify/collections/segtree/segtree_get1item_test.nim.html
title: verify/collections/segtree/segtree_get1item_test.nim
---
