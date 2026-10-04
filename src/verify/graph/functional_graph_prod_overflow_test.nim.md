---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph_with_op.nim
    title: cplib/graph/functional_graph_with_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph_with_op.nim
    title: cplib/graph/functional_graph_with_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import cplib/graph/functional_graph_with_op\n\nproc sum(a, b: int): int =\n  \
    \  doAssert a >= 0 and b >= 0\n    doAssert a <= high(int)-b\n    a + b\nlet singleton\
    \ = initFunctionalGraph_with_op(@[0], @[1], sum, 0)\nfor k in [0, 1, 2, 10, high(int)\
    \ div 2, high(int)-2, high(int)-1]:\n    doAssert singleton.prod(0, k) == k +\
    \ 1\n    doAssert singleton.prod(0, k, false) == k\n\nproc concatenate(a, b: string):\
    \ string = a & b\nlet next = @[1, 2, 0, 2, 3]\nlet values = @[\"a\", \"b\", \"\
    c\", \"d\", \"e\"]\nlet textGraph = initFunctionalGraph_with_op(next, values,\
    \ concatenate, \"\")\nfor start in 0..<next.len:\n    var expected = \"\"\n  \
    \  var expectedWithout = \"\"\n    var vertex = start\n    for k in 0..30:\n \
    \       expected &= values[vertex]\n        if k > 0:\n            expectedWithout\
    \ &= values[vertex]\n        doAssert textGraph.prod(start, k) == expected\n \
    \       doAssert textGraph.prod(start, k, false) == expectedWithout\n        vertex\
    \ = next[vertex]\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/functional_graph.nim
  - cplib/collections/segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/backwards_index.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/graph/graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/collections/segtree.nim
  isVerificationFile: true
  path: verify/graph/functional_graph_prod_overflow_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:33:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/functional_graph_prod_overflow_test.nim
layout: document
redirect_from:
- /verify/verify/graph/functional_graph_prod_overflow_test.nim
- /verify/verify/graph/functional_graph_prod_overflow_test.nim.html
title: verify/graph/functional_graph_prod_overflow_test.nim
---
