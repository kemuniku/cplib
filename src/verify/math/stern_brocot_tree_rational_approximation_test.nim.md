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
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/fractions.nim
    title: cplib/math/fractions.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/stern_brocot_tree.nim
    title: cplib/math/stern_brocot_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/stern_brocot_tree.nim
    title: cplib/math/stern_brocot_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/rational_approximation
    links:
    - https://judge.yosupo.jp/problem/rational_approximation
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/rational_approximation\n\
    import cplib/math/stern_brocot_tree\ninclude cplib/tmpl/fastio\n\nlet t = input(int)\n\
    for _ in 0..<t:\n    let n = input(int)\n    let x = input(int)\n    let y = input(int)\n\
    \    let bounds = get_bounds(x, y, n)\n    if bounds.p * y == bounds.q * x:\n\
    \        print(bounds.p, bounds.q, bounds.p, bounds.q)\n    else:\n        print(bounds.p,\
    \ bounds.q, bounds.r, bounds.s)\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/graph/graph.nim
  - cplib/math/fractions.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/fastio.nim
  - cplib/math/stern_brocot_tree.nim
  - cplib/math/stern_brocot_tree.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/math/stern_brocot_tree_rational_approximation_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:31:44+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/stern_brocot_tree_rational_approximation_test.nim
layout: document
redirect_from:
- /verify/verify/math/stern_brocot_tree_rational_approximation_test.nim
- /verify/verify/math/stern_brocot_tree_rational_approximation_test.nim.html
title: verify/math/stern_brocot_tree_rational_approximation_test.nim
---
