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
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/tree_diameter
    links:
    - https://judge.yosupo.jp/problem/tree_diameter
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_diameter\n\
    import strutils\nimport cplib/tree/tree\nimport cplib/tree/diameter\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n = ii()\nvar g = initWeightedStaticTree(n)\nfor\
    \ i in 0..<n-1:\n    var a, b, c = ii()\n    g.add_edge(a, b, c)\ng.build\nvar\
    \ (d, path) = g.diameter_path\necho d, \" \", path.len\necho path.join(\" \")\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/tree.nim
  - cplib/tree/diameter.nim
  - cplib/graph/graph.nim
  - cplib/tree/tree.nim
  - cplib/tree/diameter.nim
  isVerificationFile: true
  path: verify/tree/diameter_yosupo_test.nim
  requiredBy: []
  timestamp: '2024-06-12 20:25:01+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/diameter_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/tree/diameter_yosupo_test.nim
- /verify/verify/tree/diameter_yosupo_test.nim.html
title: verify/tree/diameter_yosupo_test.nim
---