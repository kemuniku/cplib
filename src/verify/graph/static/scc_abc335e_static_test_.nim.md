---
data:
  _extendedDependsOn:
  - icon: ':warning:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':warning:'
    path: cplib/graph/SCC.nim
    title: cplib/graph/SCC.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc335/tasks/abc335_e
    links:
    - https://atcoder.jp/contests/abc335/tasks/abc335_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc335/tasks/abc335_e\n\
    import strutils, sequtils\nimport cplib/graph/graph\nimport cplib/graph/SCC\n\n\
    var n, m: int\n(n, m) = stdin.readline.split.map parseInt\nvar a = stdin.readLine.split.map\
    \ parseInt\nvar g = initUnWeightedDirectedStaticGraph(n)\nfor i in 0..<m:\n  \
    \  var u, v: int\n    (u, v) = stdin.readLine.split.map parseInt\n    u -= 1;\
    \ v -= 1\n    if a[u] != a[v]:\n        if a[u] > a[v]: swap(u, v)\n        g.add_edge(u,\
    \ v)\n    else:\n        g.add_edge(u, v)\n        g.add_edge(v, u)\ng.build()\n\
    var (newg, itg, _) = g.SCCG()\nvar dp = newSeqWith(n, 0)\ndp[itg[0]] = 1\nfor\
    \ i in 0..<newg.len:\n    if dp[i] > 0:\n        for j in newG[i]:\n         \
    \   dp[j] = max(dp[j], dp[i] + 1)\necho dp[itg[n-1]]\n"
  dependsOn:
  - cplib/graph/SCC.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/SCC.nim
  isVerificationFile: false
  path: verify/graph/static/scc_abc335e_static_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/static/scc_abc335e_static_test_.nim
layout: document
redirect_from:
- /library/verify/graph/static/scc_abc335e_static_test_.nim
- /library/verify/graph/static/scc_abc335e_static_test_.nim.html
title: verify/graph/static/scc_abc335e_static_test_.nim
---
