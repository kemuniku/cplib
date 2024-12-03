---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dag_minimum_path_cover.nim
    title: cplib/graph/dag_minimum_path_cover.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dag_minimum_path_cover.nim
    title: cplib/graph/dag_minimum_path_cover.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc237/tasks/abc237_ex
    links:
    - https://atcoder.jp/contests/abc237/tasks/abc237_ex
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc237/tasks/abc237_ex\n\
    import cplib/graph/graph\nimport cplib/graph/dag_minimum_path_cover\nimport sets\n\
    import sequtils\nimport strutils\nimport algorithm\n\nvar S = stdin.readLine()\n\
    var N = len(S)\nvar tmp = initHashSet[string]()\nfor i in 0..<(N):\n    for x\
    \ in 1..(N-i):\n        if S[i..<(i+x)] == S[i..<(i+x)].reversed().join(\"\"):\n\
    \            tmp.incl(S[i..<(i+x)])\n\nvar palindromes = tmp.toseq()\nvar G =\
    \ initUnWeightedDirectedGraph(len(palindromes))\n\nfor i in 0..<(len(palindromes)):\n\
    \    for j in 0..<(len(palindromes)):\n        if i != j:\n            if palindromes[i]\
    \ in palindromes[j]:\n                G.add_edge(i,j)\n\necho G.dag_minimum_path_cover()"
  dependsOn:
  - cplib/graph/dag_minimum_path_cover.nim
  - cplib/graph/dag_minimum_path_cover.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  - cplib/graph/topologicalsort.nim
  isVerificationFile: true
  path: verify/graph/dag_minimum_path_cover_hakata_test.nim
  requiredBy: []
  timestamp: '2024-10-23 03:33:01+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dag_minimum_path_cover_hakata_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dag_minimum_path_cover_hakata_test.nim
- /verify/verify/graph/dag_minimum_path_cover_hakata_test.nim.html
title: verify/graph/dag_minimum_path_cover_hakata_test.nim
---
