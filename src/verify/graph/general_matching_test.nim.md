---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':question:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  - icon: ':question:'
    path: cplib/tmpl/fastio.nim
    title: cplib/tmpl/fastio.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/general_matching
    links:
    - https://judge.yosupo.jp/problem/general_matching
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/general_matching\n\
    import cplib/graph/graph\nimport cplib/graph/general_matching\ninclude cplib/tmpl/fastio\n\
    \nlet n = ii()\nlet m = ii()\nvar g = initUnWeightedUnDirectedGraph(n)\nfor i\
    \ in 0..<m:\n    let u = ii()\n    let v = ii()\n    g.add_edge(u, v)\nlet matching\
    \ = g.maximum_matching()\necho matching.len\nfor (u, v) in matching:\n    echo\
    \ u, \" \", v\n"
  dependsOn:
  - cplib/tmpl/fastio.nim
  - cplib/graph/general_matching.nim
  - cplib/graph/graph.nim
  - cplib/graph/general_matching.nim
  - cplib/tmpl/fastio.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/general_matching_test.nim
  requiredBy: []
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: TEST_WRONG_ANSWER
  verifiedWith: []
documentation_of: verify/graph/general_matching_test.nim
layout: document
redirect_from:
- /verify/verify/graph/general_matching_test.nim
- /verify/verify/graph/general_matching_test.nim.html
title: verify/graph/general_matching_test.nim
---
