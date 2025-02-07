---
data:
  _extendedDependsOn:
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':question:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':question:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':question:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':question:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2891
    links:
    - https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2891
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.u-aizu.ac.jp/onlinejudge/description.jsp?id=2891\n\
    proc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc ii(): int\
    \ {.inline.} = scanf(\"%lld\\n\", addr result)\n\nimport cplib/graph/graph\nimport\
    \ cplib/graph/namori_graph\n\nvar N = ii()\nvar G = initUnWeightedUnDirectedGraph(N)\n\
    for i in 0..<N:\n    var u,v = ii()-1\n    G.add_edge(u,v)\nvar namori = G.initNamoriGraph()\n\
    var Q = ii()\nfor i in 0..<Q:\n    var a,b = ii()-1\n    if namori.incycle(a)\
    \ and namori.incycle(b):\n        echo 2\n    else:\n        echo 1\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/graph/namori_graph.nim
  - cplib/graph/namori_graph.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/graph/namori_incycle_test.nim
  requiredBy: []
  timestamp: '2025-01-30 13:56:50+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/namori_incycle_test.nim
layout: document
redirect_from:
- /verify/verify/graph/namori_incycle_test.nim
- /verify/verify/graph/namori_incycle_test.nim.html
title: verify/graph/namori_incycle_test.nim
---
