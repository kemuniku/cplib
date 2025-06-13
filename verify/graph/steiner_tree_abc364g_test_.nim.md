---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':warning:'
    path: cplib/graph/steiner_tree.nim
    title: cplib/graph/steiner_tree.nim
  - icon: ':warning:'
    path: cplib/graph/steiner_tree.nim
    title: cplib/graph/steiner_tree.nim
  - icon: ':warning:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':warning:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc364/tasks/abc364_g
    links:
    - https://atcoder.jp/contests/abc364/tasks/abc364_g
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc364/tasks/abc364_g\n\
    import cplib/graph/graph\nimport cplib/graph/steiner_tree\nimport cplib/utils/constants\n\
    import sequtils\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\n\
    proc ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\n{.warning[UnusedImport]:\
    \ off.}\n{.hint[XDeclaredButNotUsed]: off.}\n\nvar n, m, k = ii()\nvar g = initWeightedUnDirectedGraph(n)\n\
    for i in 0..<m:\n    var u, v = ii() - 1\n    var c = ii()\n    g.add_edge(u,\
    \ v, c)\n\nvar terminal = (0..<k-1).toseq\n\nvar dp = steiner_tree_dp(g, terminal,\
    \ INF64)\nfor i in k-1..<n:\n    echo dp[^1][i]\n"
  dependsOn:
  - cplib/graph/steiner_tree.nim
  - cplib/utils/bititers.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/utils/bititers.nim
  - cplib/graph/steiner_tree.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/graph/steiner_tree_abc364g_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:49:49+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/steiner_tree_abc364g_test_.nim
layout: document
redirect_from:
- /library/verify/graph/steiner_tree_abc364g_test_.nim
- /library/verify/graph/steiner_tree_abc364g_test_.nim.html
title: verify/graph/steiner_tree_abc364g_test_.nim
---
