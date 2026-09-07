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
    path: cplib/tree/tree_hash.nim
    title: cplib/tree/tree_hash.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/tree_hash.nim
    title: cplib/tree/tree_hash.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://judge.yosupo.jp/problem/rooted_tree_isomorphism_classification
    links:
    - https://judge.yosupo.jp/problem/rooted_tree_isomorphism_classification
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://judge.yosupo.jp/problem/rooted_tree_isomorphism_classification\n\
    import algorithm, sequtils, strutils\nimport cplib/graph/graph\nimport cplib/tree/tree_hash\n\
    \nproc scanf(formatstr: cstring) {.header: \"<stdio.h>\", varargs.}\nproc ii():\
    \ int {.inline.} =\n    scanf(\"%lld\", addr result)\n\nlet n = ii()\nvar g =\
    \ initUnWeightedUnDirectedStaticGraph(n)\nfor i in 1..<n:\n    let p = ii()\n\
    \    g.add_edge(i, p)\ng.build()\n\nlet hashes = g.subtree_hash()\nlet values\
    \ = hashes.sorted().deduplicate(true)\necho values.len\necho hashes.mapIt(values.lowerBound(it)).join(\"\
    \ \")\n"
  dependsOn:
  - cplib/tree/tree_hash.nim
  - cplib/tree/tree_hash.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/tree/rooted_tree_isomorphism_classification_test.nim
  requiredBy: []
  timestamp: '2026-09-06 08:45:23+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/tree/rooted_tree_isomorphism_classification_test.nim
layout: document
redirect_from:
- /verify/verify/tree/rooted_tree_isomorphism_classification_test.nim
- /verify/verify/tree/rooted_tree_isomorphism_classification_test.nim.html
title: verify/tree/rooted_tree_isomorphism_classification_test.nim
---
