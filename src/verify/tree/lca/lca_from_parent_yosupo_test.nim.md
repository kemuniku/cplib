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
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
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
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/lca\ninclude\
    \ cplib/tmpl/fastio\nimport cplib/tree/lca\n\nlet n = ii()\nlet q = ii()\nlet\
    \ parent = @[-1] & lii(n - 1)\nlet tree = initLCAFromParent(parent, 0)\nfor _\
    \ in 0..<q:\n    let u = ii()\n    let v = ii()\n    print(tree.lca(u, v))\n"
  dependsOn:
  - cplib/tree/lca.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/graph.nim
  - cplib/tree/lca.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/tree/lca/lca_from_parent_yosupo_test.nim
  requiredBy: []
  timestamp: '2026-09-17 21:06:55+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/lca/lca_from_parent_yosupo_test.nim
layout: document
redirect_from:
- /verify/verify/tree/lca/lca_from_parent_yosupo_test.nim
- /verify/verify/tree/lca/lca_from_parent_yosupo_test.nim.html
title: verify/tree/lca/lca_from_parent_yosupo_test.nim
---
