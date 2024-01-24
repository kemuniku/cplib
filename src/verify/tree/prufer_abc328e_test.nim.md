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
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
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
    PROBLEM: https://atcoder.jp/contests/abc328/tasks/abc328_e
    links:
    - https://atcoder.jp/contests/abc328/tasks/abc328_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc328/tasks/abc328_e\n\
    import sequtils, strutils\nimport cplib/tree/prufer\n\nvar n, m, k: int\n(n, m,\
    \ k) = stdin.readline.split.map parseInt\nvar inf = int(300000000000000000)\n\
    var g = newSeqWith(n, newSeqWith(n, inf))\nfor i in 0..<m:\n    var u, v, w: int\n\
    \    (u, v, w) = stdin.readLine.split.map parseInt\n    g[u-1][v-1] = w\n    g[v-1][u-1]\
    \ = w\n\nvar a = newSeqWith(n-2, 0)\nvar ans = inf\nproc dfs(d: int) =\n    if\
    \ d == n-2:\n        var t = a.prufer_decode\n        var cur = 0\n        for\
    \ i in 0..<n:\n            for (j, c) in t.edges[i]:\n                if i < j:\
    \ continue\n                if g[i][j] == inf: return\n                cur +=\
    \ g[i][j]\n        ans = min(ans, cur mod k)\n        return\n    for i in 0..<n:\n\
    \        a[d] = i\n        dfs(d+1)\ndfs(0)\necho ans\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  - cplib/tree/prufer.nim
  - cplib/tree/tree.nim
  - cplib/tree/tree.nim
  isVerificationFile: true
  path: verify/tree/prufer_abc328e_test.nim
  requiredBy: []
  timestamp: '2024-01-20 09:29:29+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/prufer_abc328e_test.nim
layout: document
redirect_from:
- /verify/verify/tree/prufer_abc328e_test.nim
- /verify/verify/tree/prufer_abc328e_test.nim.html
title: verify/tree/prufer_abc328e_test.nim
---
