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
    PROBLEM: https://atcoder.jp/contests/typical90/tasks/typical90_078
    links:
    - https://atcoder.jp/contests/typical90/tasks/typical90_078
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/typical90/tasks/typical90_078\n\
    import cplib/graph/graph\nimport strscans\n\nvar n, m: int\ndiscard stdin.readline.scanf(\"\
    $i $i\", n, m)\nvar g = initUnWeightedDirectedGraph(n)\nfor i in 0..<m:\n    var\
    \ a, b: int\n    discard stdin.readline.scanf(\"$i $i\", a, b)\n    if b > a:\
    \ swap(a, b)\n    g.add_edge(a-1, b-1)\nvar ans = 0\nfor i in 0..<n:\n    if g.edges[i].len\
    \ == 1: ans += 1\necho ans\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/unweighted_directed_graph_typical90_test.nim
  requiredBy: []
  timestamp: '2023-11-14 01:23:52+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/graph/unweighted_directed_graph_typical90_test.nim
layout: document
redirect_from:
- /verify/verify/graph/unweighted_directed_graph_typical90_test.nim
- /verify/verify/graph/unweighted_directed_graph_typical90_test.nim.html
title: verify/graph/unweighted_directed_graph_typical90_test.nim
---
