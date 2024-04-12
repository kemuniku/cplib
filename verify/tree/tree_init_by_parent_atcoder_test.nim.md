---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':x:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  - icon: ':x:'
    path: cplib/tree/tree.nim
    title: cplib/tree/tree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc309/tasks/abc309_e
    links:
    - https://atcoder.jp/contests/abc309/tasks/abc309_e
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc309/tasks/abc309_e\n\
    import strutils, sequtils\nimport cplib/tree/tree\n\nvar n, m, x, y: int\n(n,\
    \ m) = stdin.readLine.split.map(parseInt)\nvar p = stdin.readLine.split.map(parseInt).mapIt(it-1)\n\
    var g = initUnWeightedTree(p)\nvar ins = newSeqWith(n, 0)\nfor i in 0..<m:\n \
    \   (x, y) = stdin.readLine.split.map(parseInt)\n    ins[x-1] = max(ins[x-1],\
    \ y+1)\n\nproc dfs(u, par, insi: int): int =\n    var insi = max(insi, ins[u])\n\
    \    if insi > 0: result = 1\n    for (v, c) in g.edges[u]:\n        if v == par:\
    \ continue\n        result += dfs(v, u, insi-1)\necho dfs(0, -1, 0)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/tree.nim
  - cplib/tree/tree.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/tree_init_by_parent_atcoder_test.nim
  requiredBy: []
  timestamp: '2024-04-11 03:42:22+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/tree/tree_init_by_parent_atcoder_test.nim
layout: document
redirect_from:
- /verify/verify/tree/tree_init_by_parent_atcoder_test.nim
- /verify/verify/tree/tree_init_by_parent_atcoder_test.nim.html
title: verify/tree/tree_init_by_parent_atcoder_test.nim
---
