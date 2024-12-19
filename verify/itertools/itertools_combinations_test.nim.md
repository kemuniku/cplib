---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/unionfind.nim
    title: cplib/collections/unionfind.nim
  - icon: ':heavy_check_mark:'
    path: cplib/itertools/combinations.nim
    title: cplib/itertools/combinations.nim
  - icon: ':heavy_check_mark:'
    path: cplib/itertools/combinations.nim
    title: cplib/itertools/combinations.nim
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
    import math, sequtils\nimport cplib/itertools/combinations\nimport cplib/collections/unionfind\n\
    \nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii():\
    \ int {.inline.} = scanf(\"%lld\\n\", addr result)\nvar N, M, K = ii()\nvar edges:\
    \ seq[(int, int, int)]\nfor i in 0..<M:\n    var u, v, w = ii()-1\n    w += 1\n\
    \    edges.add((u, v, w))\nvar ans = 10^18\nfor x in combinations((0..<M).toseq,\
    \ N-1):\n    var uf = initUnionFind(N)\n    var tmp = 0\n    for j in x:\n   \
    \     var (u, v, w) = edges[j]\n        uf.unite(u, v)\n        tmp += w\n   \
    \     tmp = tmp mod K\n    if uf.count == 1:\n        ans = min(ans, tmp)\necho\
    \ ans\n\n"
  dependsOn:
  - cplib/collections/unionfind.nim
  - cplib/collections/unionfind.nim
  - cplib/itertools/combinations.nim
  - cplib/itertools/combinations.nim
  isVerificationFile: true
  path: verify/itertools/itertools_combinations_test.nim
  requiredBy: []
  timestamp: '2024-11-02 13:05:22+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/itertools/itertools_combinations_test.nim
layout: document
redirect_from:
- /verify/verify/itertools/itertools_combinations_test.nim
- /verify/verify/itertools/itertools_combinations_test.nim.html
title: verify/itertools/itertools_combinations_test.nim
---
