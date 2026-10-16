---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/general_matching.nim
    title: cplib/graph/general_matching.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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
    import random\ninclude cplib/graph/general_matching\n\nvar rng = initRand(876123)\n\
    for shape in 0..<5:\n    for trial in 0..<20:\n        let n = rng.rand(200..2000)\n\
    \        var tree = initMatchingTreeUnion(n)\n        var parent = newSeq[int](n)\n\
    \        var deleted = newSeq[bool](n)\n        var grown = 1\n        for step\
    \ in 0..<3*n:\n            if grown < n and (step mod 3 != 2 or rng.rand(1) ==\
    \ 0):\n                let v = grown\n                let p = case shape\n   \
    \                 of 0: v - 1\n                    of 1: 0\n                 \
    \   of 2: (v - 1) div 2\n                    of 3: max(0, v - 2)\n           \
    \         else: rng.rand(v - 1)\n                parent[v] = p\n             \
    \   tree.grow(p, v)\n                inc grown\n            elif grown > 1:\n\
    \                let v = rng.rand(1..<grown)\n                tree.joinParent(v)\n\
    \                deleted[v] = true\n            for j in 0..<5:\n            \
    \    let v = rng.rand(grown - 1)\n                var expected = v\n         \
    \       while deleted[expected]: expected = parent[expected]\n               \
    \ doAssert tree.root(v) == expected\n        for v in 1..<grown:\n           \
    \ tree.joinParent(v)\n        for v in 0..<grown:\n            doAssert tree.root(v)\
    \ == 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/general_matching.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/general_matching.nim
  isVerificationFile: true
  path: verify/AI/general_matching_tree_union_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/general_matching_tree_union_test.nim
layout: document
redirect_from:
- /verify/verify/AI/general_matching_tree_union_test.nim
- /verify/verify/AI/general_matching_tree_union_test.nim.html
title: verify/AI/general_matching_tree_union_test.nim
---
