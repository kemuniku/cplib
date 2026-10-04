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
    import cplib/graph/functional_graph_with_op\n\nproc sum(a, b: int): int = a +\
    \ b\nproc maximum(a, b: int): int = max(a, b)\nproc xorValue(a, b: int): int =\
    \ a xor b\nlet zeroGraph = initFunctionalGraph_with_op(@[0], @[0], sum, 0)\nlet\
    \ maxGraph = initFunctionalGraph_with_op(@[0], @[7], maximum, low(int))\nlet xorGraph\
    \ = initFunctionalGraph_with_op(@[0], @[7], xorValue, 0)\nfor k in [high(int)-2,\
    \ high(int)-1, high(int)]:\n    doAssert zeroGraph.prod(0, k) == 0\n    doAssert\
    \ zeroGraph.prod(0, k, false) == 0\n    doAssert maxGraph.prod(0, k) == 7\n  \
    \  doAssert maxGraph.prod(0, k, false) == 7\n    doAssert xorGraph.prod(0, k)\
    \ == (if (k and 1) == 0: 7 else: 0)\n    doAssert xorGraph.prod(0, k, false) ==\
    \ (if (k and 1) == 1: 7 else: 0)\n\nlet cycleGraph = initFunctionalGraph_with_op(@[1,\
    \ 2, 0], @[1, 2, 4], xorValue, 0)\nfor start in 0..2:\n    for k in [0, 1, 2,\
    \ 5, 6, high(int)-2, high(int)-1, high(int)]:\n        var expected = 0\n    \
    \    for offset in 0..<int((uint(k)+1'u) mod 6'u):\n            expected = expected\
    \ xor [1, 2, 4][(start+offset) mod 3]\n        doAssert cycleGraph.prod(start,\
    \ k) == expected\n        expected = 0\n        for offset in 0..<int(uint(k)\
    \ mod 6'u):\n            expected = expected xor [1, 2, 4][(start+offset+1) mod\
    \ 3]\n        doAssert cycleGraph.prod(start, k, false) == expected\n\nlet next\
    \ = @[1, 2, 0, 2, 3]\nlet values = @[1, 2, 4, 8, 16]\nlet tailGraph = initFunctionalGraph_with_op(next,\
    \ values, maximum, low(int))\nfor start in 0..<next.len:\n    var vertex = start\n\
    \    var expected = low(int)\n    for k in 0..30:\n        expected = max(expected,\
    \ values[vertex])\n        doAssert tailGraph.prod(start, k) == expected\n   \
    \     vertex = next[vertex]\n    doAssert tailGraph.prod(start, high(int)) ==\
    \ expected\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/functional_graph.nim
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  - cplib/graph/graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  - cplib/graph/functional_graph_with_op.nim
  isVerificationFile: true
  path: verify/graph/functional_graph_prod_max_count_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:33:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/functional_graph_prod_max_count_test.nim
layout: document
redirect_from:
- /verify/verify/graph/functional_graph_prod_max_count_test.nim
- /verify/verify/graph/functional_graph_prod_max_count_test.nim.html
title: verify/graph/functional_graph_prod_max_count_test.nim
---
