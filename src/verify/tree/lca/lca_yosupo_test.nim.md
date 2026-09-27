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
    path: cplib/tree/lca.nim
    title: cplib/tree/lca.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/lca.nim
    title: cplib/tree/lca.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/lca
    links:
    - https://judge.yosupo.jp/problem/lca
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/lca\nimport\
    \ strutils\nimport cplib/graph/graph\nimport cplib/tree/lca\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\", addr result)\n\nlet n = ii()\nlet q = ii()\nvar g = initUnWeightedUnDirectedStaticGraph(n)\n\
    for v in 1..<n:\n    g.add_edge(v, ii())\ng.build()\nlet tree = initLCA(g, 0)\n\
    var ans = newSeq[int](q)\nfor i in 0..<q:\n    let u = ii()\n    let v = ii()\n\
    \    ans[i] = tree.lca(u, v)\necho ans.join(\"\\n\")\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/lca.nim
  - cplib/tree/lca.nim
  isVerificationFile: true
  path: verify/tree/lca/lca_yosupo_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/lca/lca_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/tree/lca/lca_yosupo_test.nim
- /verify/verify/tree/lca/lca_yosupo_test.nim.html
title: verify/tree/lca/lca_yosupo_test.nim
---
