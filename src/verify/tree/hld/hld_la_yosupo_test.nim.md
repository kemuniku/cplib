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
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/jump_on_tree
    links:
    - https://judge.yosupo.jp/problem/jump_on_tree
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/jump_on_tree\n\
    import strutils\nimport cplib/graph/graph\nimport cplib/tree/heavylightdecomposition\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nvar n, q = ii()\nvar g = initUnWeightedUnDirectedStaticGraph(n)\n\
    for i in 0..<n-1:\n    var a, b = ii()\n    g.add_edge(a, b)\ng.build\n\nvar hld\
    \ = initHld(g, 0)\nvar ans = newSeq[int](q)\nfor i in 0..<q:\n    var s, t, k\
    \ = ii()\n    ans[i] = hld.la(s, t, k)\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/hld/hld_la_yosupo_test.nim
  requiredBy: []
  timestamp: '2024-06-28 02:03:34+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/hld/hld_la_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/tree/hld/hld_la_yosupo_test.nim
- /verify/verify/tree/hld/hld_la_yosupo_test.nim.html
title: verify/tree/hld/hld_la_yosupo_test.nim
---
