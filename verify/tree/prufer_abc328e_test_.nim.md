---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':warning:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':warning:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc328/tasks/abc328_e
    links:
    - https://atcoder.jp/contests/abc328/tasks/abc328_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
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
  - cplib/tree/prufer.nim
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/tree/prufer_abc328e_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/tree/prufer_abc328e_test_.nim
layout: document
redirect_from:
- /library/verify/tree/prufer_abc328e_test_.nim
- /library/verify/tree/prufer_abc328e_test_.nim.html
title: verify/tree/prufer_abc328e_test_.nim
---
