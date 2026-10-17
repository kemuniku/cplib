---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/internal/weighted_matching_engine.nim
    title: cplib/graph/internal/weighted_matching_engine.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/internal/weighted_matching_engine.nim
    title: cplib/graph/internal/weighted_matching_engine.nim
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
    import random\ninclude cplib/graph/internal/weighted_matching_engine\n\nconst\
    \ n = 1500\nvar s = MatchingMachine[true](n: n, leaves: newSeq[MatchingLeaf](n\
    \ + 1))\nvar order = newSeq[int](n)\nvar expected = newSeq[int64](n + 1)\nvar\
    \ root = 0\nfor v in 1..n:\n    s.leaves[v] = MatchingLeaf(height: 1, count: 1,\
    \ potential: int64(v), edge: -1, minimum: MatchingInfinity)\n    expected[v] =\
    \ int64(v)\n    order[v - 1] = v\n    root = s.concatenate(root, v)\n\nproc inspect(v,\
    \ parent: int): tuple[height, count: int] =\n    if v == 0: return\n    doAssert\
    \ s.leaves[v].parent == parent\n    let a = inspect(s.leaves[v].left, v)\n   \
    \ let b = inspect(s.leaves[v].right, v)\n    doAssert abs(a.height - b.height)\
    \ <= 1\n    result = (1 + max(a.height, b.height), 1 + a.count + b.count)\n  \
    \  doAssert result == (s.leaves[v].height, s.leaves[v].count)\n\nvar rng = initRand(6132701)\n\
    for trial in 0..<3000:\n    let cut = rng.rand(0..n)\n    let delta = int64(rng.rand(-1000..1000))\n\
    \    let parts = s.split(root, cut)\n    s.apply(parts.left, delta)\n    for i\
    \ in 0..<cut: expected[order[i]] += delta\n    root = s.concatenate(parts.right,\
    \ parts.left)\n    order = order[cut..<n] & order[0..<cut]\n    if trial mod 10\
    \ == 0:\n        doAssert inspect(root, 0).count == n\n        for i, v in order:\n\
    \            doAssert s.rank(v) == i\n            doAssert s.potential(v) == expected[v]\n\
    echo \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/internal/weighted_matching_engine.nim
  - cplib/graph/internal/weighted_matching_engine.nim
  isVerificationFile: true
  path: verify/AI/weighted_matching_structure_test.nim
  requiredBy: []
  timestamp: '2026-09-29 03:00:17+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/weighted_matching_structure_test.nim
layout: document
redirect_from:
- /verify/verify/AI/weighted_matching_structure_test.nim
- /verify/verify/AI/weighted_matching_structure_test.nim.html
title: verify/AI/weighted_matching_structure_test.nim
---
