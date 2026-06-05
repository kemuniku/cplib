---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':warning:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  - icon: ':warning:'
    path: cplib/graph/topologicalsort.nim
    title: cplib/graph/topologicalsort.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    PROBLEM: https://atcoder.jp/contests/abc216/tasks/abc216_d
    links:
    - https://atcoder.jp/contests/abc216/tasks/abc216_d
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://atcoder.jp/contests/abc216/tasks/abc216_d\n\
    import cplib/graph/graph\nimport cplib/graph/topologicalsort\nimport sequtils,\
    \ sets\nproc scanf(formatstr: cstring){.header: \"<stdio.h>\", varargs.}\nproc\
    \ ii(): int {.inline.} = scanf(\"%lld\\n\", addr result)\nvar N, M = ii()\nvar\
    \ G = initUnWeightedDirectedStaticGraph(N)\nfor i in 0..<M:\n    var K = ii()\n\
    \    var A = newseqwith(K, ii())\n    if len(A.toHashSet) != K:\n        echo\
    \ \"No\"\n        quit()\n    for i in 0..<K-1:\n        G.add_edge(A[i]-1, A[i+1]-1)\n\
    G.build()\nif G.isDAG():\n    echo \"Yes\"\nelse:\n    echo \"No\"\n"
  dependsOn:
  - cplib/graph/topologicalsort.nim
  - cplib/graph/topologicalsort.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: verify/graph/static/topologicalsort_1_static_test_.nim
  requiredBy: []
  timestamp: '2025-03-09 18:22:34+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: verify/graph/static/topologicalsort_1_static_test_.nim
layout: document
redirect_from:
- /library/verify/graph/static/topologicalsort_1_static_test_.nim
- /library/verify/graph/static/topologicalsort_1_static_test_.nim.html
title: verify/graph/static/topologicalsort_1_static_test_.nim
---
