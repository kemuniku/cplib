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
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/two_edge_connected_components.nim
    title: cplib/graph/two_edge_connected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/two_edge_connected_components.nim
    title: cplib/graph/two_edge_connected_components.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/two_edge_connected_components
    links:
    - https://judge.yosupo.jp/problem/two_edge_connected_components
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/two_edge_connected_components\n\
    import cplib/graph/graph\nimport cplib/graph/two_edge_connected_components\ninclude\
    \ cplib/tmpl/fastio\n\nlet n = ii()\nlet m = ii()\nvar g = initUnWeightedUnDirectedGraph(n)\n\
    for i in 0..<m:\n    let u = ii()\n    let v = ii()\n    g.add_edge(u, v)\nlet\
    \ decomposition = initTwoEdgeConnectedComponents(g)\necho decomposition.groups.len\n\
    for group in decomposition.groups:\n    stdout.write group.len\n    for v in group:\
    \ stdout.write \" \", v\n    stdout.write \"\\n\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/two_edge_connected_components.nim
  - cplib/graph/graph.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/two_edge_connected_components.nim
  - cplib/graph/lowlink.nim
  - cplib/tmpl/fastio.nim
  isVerificationFile: true
  path: verify/graph/two_edge_connected_components_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/two_edge_connected_components_test.nim
layout: document
redirect_from:
- /verify/verify/graph/two_edge_connected_components_test.nim
- /verify/verify/graph/two_edge_connected_components_test.nim.html
title: verify/graph/two_edge_connected_components_test.nim
---
