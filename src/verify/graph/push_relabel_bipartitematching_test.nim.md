---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/push_relabel.nim
    title: cplib/graph/push_relabel.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/push_relabel.nim
    title: cplib/graph/push_relabel.nim
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
    import cplib/graph/push_relabel\ninclude cplib/tmpl/fastio\n\nlet left = ii()\n\
    let right = ii()\nlet m = ii()\nlet src = left + right\nlet dst = src + 1\nvar\
    \ g = initPushRelabel[int](dst + 1)\nfor i in 0..<left:\n    g.add_edge(src, i,\
    \ 1)\nfor i in 0..<right:\n    g.add_edge(left + i, dst, 1)\nfor i in 0..<m:\n\
    \    let a = ii()\n    let b = ii()\n    g.add_edge(a, left + b, 1)\nprint g.flow(src,\
    \ dst)\nfor i in left + right..<left + right + m:\n    let e = g.get_edge(i)\n\
    \    if e.flow == 1:\n        print(e.src, e.dst - left)\n"
  dependsOn:
  - cplib/graph/push_relabel.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/push_relabel.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/graph/push_relabel_bipartitematching_test.nim
  requiredBy: []
  timestamp: '2026-09-12 08:37:53+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/push_relabel_bipartitematching_test.nim
layout: document
redirect_from:
- /verify/verify/graph/push_relabel_bipartitematching_test.nim
- /verify/verify/graph/push_relabel_bipartitematching_test.nim.html
title: verify/graph/push_relabel_bipartitematching_test.nim
---
