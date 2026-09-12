---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/hopcroft_karp.nim
    title: cplib/graph/hopcroft_karp.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/hopcroft_karp.nim
    title: cplib/graph/hopcroft_karp.nim
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
    PROBLEM: https://judge.yosupo.jp/problem/bipartitematching
    links:
    - https://judge.yosupo.jp/problem/bipartitematching
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching\n\
    import cplib/graph/hopcroft_karp\ninclude cplib/tmpl/fastio\n\nlet left = ii()\n\
    let right = ii()\nlet m = ii()\nvar g = initHopcroftKarp(left, right)\nfor i in\
    \ 0..<m:\n    let a = ii()\n    let b = ii()\n    g.add_edge(a, b)\necho g.matching()\n\
    for (a, b) in g.get_matching():\n    echo a, \" \", b\n"
  dependsOn:
  - cplib/graph/hopcroft_karp.nim
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/hopcroft_karp.nim
  isVerificationFile: true
  path: verify/graph/hopcroft_karp_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/hopcroft_karp_test.nim
layout: document
redirect_from:
- /verify/verify/graph/hopcroft_karp_test.nim
- /verify/verify/graph/hopcroft_karp_test.nim.html
title: verify/graph/hopcroft_karp_test.nim
---
