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
    import cplib/math/stern_brocot_tree\nimport strutils\n\nlet t = stdin.readLine.parseInt\n\
    for _ in 0..<t:\n    let query = stdin.readLine.splitWhitespace\n    let n = query[0].parseInt\n\
    \    let x = query[1].parseInt\n    let y = query[2].parseInt\n    let bounds\
    \ = get_bounds(proc(v: SBTNode[int]): bool =\n        v.den() != 0 and v.num()\
    \ * y <= x * v.den()\n    , n)\n    if bounds.p * y == bounds.q * x:\n       \
    \ echo bounds.p, \" \", bounds.q, \" \", bounds.p, \" \", bounds.q\n    else:\n\
    \        echo bounds.p, \" \", bounds.q, \" \", bounds.r, \" \", bounds.s\n"
  dependsOn:
  - cplib/math/fractions.nim
  - cplib/math/fractions.nim
  - cplib/graph/graph.nim
  - cplib/math/stern_brocot_tree.nim
  - cplib/graph/graph.nim
  - cplib/math/stern_brocot_tree.nim
  isVerificationFile: true
  path: verify/math/stern_brocot_tree_rational_approximation_test.nim
  requiredBy: []
  timestamp: '2026-09-27 01:47:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/stern_brocot_tree_rational_approximation_test.nim
layout: document
redirect_from:
- /verify/verify/math/stern_brocot_tree_rational_approximation_test.nim
- /verify/verify/math/stern_brocot_tree_rational_approximation_test.nim.html
title: verify/math/stern_brocot_tree_rational_approximation_test.nim
---
