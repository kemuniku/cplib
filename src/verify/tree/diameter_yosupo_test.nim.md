---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/diameter.nim
    title: cplib/tree/diameter.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/tree_diameter
    links:
    - https://judge.yosupo.jp/problem/tree_diameter
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/tree_diameter\n\
    import strutils\nimport cplib/graph/graph\nimport cplib/tree/diameter\nproc scanf(formatstr:\
    \ cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int {.inline.} = scanf(\"\
    %lld\\n\", addr result)\n\nvar n = ii()\nvar g = initWeightedUnDirectedStaticGraph(n)\n\
    for i in 0..<n-1:\n    var a, b, c = ii()\n    g.add_edge(a, b, c)\ng.build\n\
    var (d, path) = g.diameter_path\necho d, \" \", path.len\necho path.join(\" \"\
    )\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/diameter.nim
  - cplib/graph/graph.nim
  - cplib/tree/diameter.nim
  isVerificationFile: true
  path: verify/tree/diameter_yosupo_test.nim
  requiredBy: []
  timestamp: '2024-10-02 22:06:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/diameter_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/tree/diameter_yosupo_test.nim
- /verify/verify/tree/diameter_yosupo_test.nim.html
title: verify/tree/diameter_yosupo_test.nim
---
