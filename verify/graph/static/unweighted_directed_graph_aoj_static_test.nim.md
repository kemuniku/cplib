---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_11_B
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_11_B
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ALDS1_11_B\n\
    import cplib/graph/graph\nimport strutils, sequtils\n\nvar n = stdin.readLine.parseint\n\
    var g = initUnWeightedDirectedStaticGraph(n)\nfor i in 0..<n:\n    var line =\
    \ stdin.readLine.split().map(parseInt)\n    for j in 0..<line[1]:\n        g.add_edge(line[0]-1,\
    \ line[2+j]-1)\ng.build()\n\nvar ans = newSeqWith(n, (-1, -1))\nproc dfs(x, cnt:\
    \ int): int =\n    if ans[x][0] != -1:\n        return cnt - 1\n    var cnt =\
    \ cnt\n    ans[x][0] = cnt\n    for y in g[x]:\n        cnt = dfs(y, cnt+1)\n\
    \    ans[x][1] = cnt + 1\n    return cnt + 1\n\nvar pos = 1\nfor i in 0..<n:\n\
    \    if ans[i][0] == -1:\n        pos = dfs(i, pos) + 1\n\nfor i in 0..<n:\n \
    \   var (s, t) = ans[i]\n    echo i+1, \" \", s, \" \", t\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/static/unweighted_directed_graph_aoj_static_test.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/graph/static/unweighted_directed_graph_aoj_static_test.nim
layout: document
redirect_from:
- /verify/verify/graph/static/unweighted_directed_graph_aoj_static_test.nim
- /verify/verify/graph/static/unweighted_directed_graph_aoj_static_test.nim.html
title: verify/graph/static/unweighted_directed_graph_aoj_static_test.nim
---
