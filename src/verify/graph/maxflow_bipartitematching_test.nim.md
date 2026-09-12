---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxflow.nim
    title: cplib/graph/maxflow.nim
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
    import cplib/graph/maxflow\ninclude cplib/tmpl/fastio\n\nlet left = ii()\nlet\
    \ right = ii()\nlet m = ii()\nlet src = left + right\nlet dst = src + 1\nvar g\
    \ = initMaxFlow[int](dst + 1)\nfor i in 0..<left:\n    g.add_edge(src, i, 1)\n\
    for i in 0..<right:\n    g.add_edge(left + i, dst, 1)\nfor i in 0..<m:\n    let\
    \ a = ii()\n    let b = ii()\n    g.add_edge(a, left + b, 1)\necho g.flow(src,\
    \ dst)\nfor e in g.get_edges:\n    if e.src < left and e.dst >= left and e.dst\
    \ < src and e.flow == 1:\n        echo e.src, \" \", e.dst - left\n"
  dependsOn:
  - cplib/graph/maxflow.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/maxflow.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/graph/maxflow_bipartitematching_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/maxflow_bipartitematching_test.nim
layout: document
redirect_from:
- /verify/verify/graph/maxflow_bipartitematching_test.nim
- /verify/verify/graph/maxflow_bipartitematching_test.nim.html
title: verify/graph/maxflow_bipartitematching_test.nim
---
