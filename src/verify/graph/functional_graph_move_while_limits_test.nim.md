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
    import cplib/graph/functional_graph_with_op\n\nproc minimum(a, b: int): int =\
    \ min(a, b)\nproc nonnegative(value: int): bool = value >= 0\nproc impossible(value:\
    \ int): bool = value > 10\nlet singleton = initFunctionalGraph_with_op(@[0], @[7],\
    \ minimum, high(int))\nfor limit in [0, 1, 2, high(int)-1, high(int)]:\n    doAssert\
    \ singleton.move_while(nonnegative, 0, limit) == limit\n    doAssert singleton.move_while(impossible,\
    \ 0, limit) == 0\n\nlet tail = initFunctionalGraph_with_op(@[1, 2, 2], @[0, 0,\
    \ 0], minimum, high(int))\nfor start in 0..2:\n    for limit in [0, 1, 2, high(int)-1,\
    \ high(int)]:\n        doAssert tail.move_while(nonnegative, start, limit) ==\
    \ limit\n\nlet next = @[1, 2, 0, 2, 3]\nlet values = @[6, 2, 4, 8, 1]\nlet testGraph\
    \ = initFunctionalGraph_with_op(next, values, minimum, high(int))\nfor start in\
    \ 0..<next.len:\n    for threshold in 0..9:\n        let predicate = proc(value:\
    \ int): bool = value >= threshold\n        for limit in 0..60:\n            var\
    \ vertex = start\n            var current = high(int)\n            var expected\
    \ = limit\n            for step in 0..limit:\n                current = min(current,\
    \ values[vertex])\n                if not predicate(current):\n              \
    \      expected = step\n                    break\n                vertex = next[vertex]\n\
    \            doAssert testGraph.move_while(predicate, start, limit) == expected\n\
    \        var vertex = start\n        var current = high(int)\n        var expected\
    \ = high(int)\n        for step in 0..10:\n            current = min(current,\
    \ values[vertex])\n            if not predicate(current):\n                expected\
    \ = step\n                break\n            vertex = next[vertex]\n        doAssert\
    \ testGraph.move_while(predicate, start, high(int)) == expected\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/graph/functional_graph.nim
  - cplib/utils/backwards_index.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/collections/segtree.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/collections/segtree.nim
  - cplib/utils/backwards_index.nim
  - cplib/graph/graph.nim
  - cplib/graph/functional_graph.nim
  isVerificationFile: true
  path: verify/graph/functional_graph_move_while_limits_test.nim
  requiredBy: []
  timestamp: '2026-10-01 06:33:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/functional_graph_move_while_limits_test.nim
layout: document
redirect_from:
- /verify/verify/graph/functional_graph_move_while_limits_test.nim
- /verify/verify/graph/functional_graph_move_while_limits_test.nim.html
title: verify/graph/functional_graph_move_while_limits_test.nim
---
