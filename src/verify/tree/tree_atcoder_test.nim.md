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
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc138/tasks/abc138_d
    links:
    - https://atcoder.jp/contests/abc138/tasks/abc138_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc138/tasks/abc138_d\n\
    import sequtils, strutils\nimport cplib/tree/tree\n\nvar n, q, a, b, p, x: int\n\
    (n, q) = stdin.readLine.split.map(parseInt)\nvar g = initUnWeightedTree(n)\nfor\
    \ i in 0..<n-1:\n    (a, b) = stdin.readLine.split.map(parseInt)\n    g.add_edge(a-1,\
    \ b-1)\nvar cnt = newSeqWith(n, 0)\nfor i in 0..<q:\n    (p, x) = stdin.readLine.split.map(parseInt)\n\
    \    cnt[p-1] += x\nproc dfs(u, par, val: int): void =\n    cnt[u] += val\n  \
    \  for (v, c) in g.edges[u]:\n        if v == par: continue\n        dfs(v, u,\
    \ cnt[u])\ndfs(0, -1, 0)\necho cnt.join(\" \")\n"
  dependsOn:
  - cplib/tree/tree.nim
  - cplib/tree/tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/tree_atcoder_test.nim
  requiredBy: []
  timestamp: '2024-03-22 18:42:41+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/tree_atcoder_test.nim
layout: document
redirect_from:
- /verify/verify/tree/tree_atcoder_test.nim
- /verify/verify/tree/tree_atcoder_test.nim.html
title: verify/tree/tree_atcoder_test.nim
---
