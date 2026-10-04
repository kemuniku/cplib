---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dominator_tree.nim
    title: cplib/graph/dominator_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dominator_tree.nim
    title: cplib/graph/dominator_tree.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/dominatortree
    links:
    - https://judge.yosupo.jp/problem/dominatortree
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/dominatortree\n\
    import cplib/graph/graph\nimport cplib/graph/dominator_tree\ninclude cplib/tmpl/fastio\n\
    \nlet n = ii()\nlet m = ii()\nlet root = ii()\nvar g = initUnWeightedDirectedStaticGraph(n,\
    \ capacity = m)\nfor i in 0..<m:\n    let u = ii()\n    let v = ii()\n    g.add_edge(u,\
    \ v)\ng.build()\necho g.dominator_tree(root).join(\" \")\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/dominator_tree.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/dominator_tree.nim
  isVerificationFile: true
  path: verify/graph/dominator_tree_test.nim
  requiredBy: []
  timestamp: '2026-10-01 03:10:25+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/dominator_tree_test.nim
layout: document
redirect_from:
- /verify/verify/graph/dominator_tree_test.nim
- /verify/verify/graph/dominator_tree_test.nim.html
title: verify/graph/dominator_tree_test.nim
---
