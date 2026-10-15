---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/knapsack.nim
    title: cplib/utils/knapsack.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/knapsack.nim
    title: cplib/utils/knapsack.nim
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
    echo \"Hello World\"\n\nimport random\nimport cplib/utils/knapsack\n\nassert solve_BoundedKnapsack(@[(v:\
    \ 5, w: 2, m: 0)], 5) == 0\nassert solve_BoundedKnapsack(@[(v: 5, w: 2, m: 0),\
    \ (v: 7, w: 3, m: 2)], 6) == 14\nassert solve_BoundedKnapsack(@[(v: 5, w: 0, m:\
    \ 0)], 0) == 0\nassert solve_BoundedKnapsack(@[(v: 5, w: 0, m: 2), (v: 7, w: 3,\
    \ m: 0)], 0) == 10\nassert solve_BoundedKnapsack(@[(v: 5, w: 1, m: 0)], 0) ==\
    \ 0\nassert solve_BoundedKnapsack(@[(v: 5, w: 20, m: 0)], 5) == 0\n\nproc naive(items:\
    \ seq[tuple[v, w, m: int]], capacity: int): int =\n    var dp = newSeq[int](capacity\
    \ + 1)\n    for (value, weight, count) in items:\n        var next = newSeq[int](capacity\
    \ + 1)\n        for c in 0..capacity:\n            for k in 0..count:\n      \
    \          if k * weight <= c:\n                    next[c] = max(next[c], dp[c-k*weight]\
    \ + k*value)\n        dp = next\n    dp[capacity]\n\nvar rng = initRand(1200)\n\
    for trial in 0..<300:\n    var items: seq[tuple[v, w, m: int]]\n    for i in 0..<rng.rand(0..7):\n\
    \        items.add((rng.rand(0..20), rng.rand(0..8), rng.rand(0..5)))\n    let\
    \ capacity = rng.rand(0..25)\n    assert solve_BoundedKnapsack(items, capacity)\
    \ == naive(items, capacity)\n"
  dependsOn:
  - cplib/utils/knapsack.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/utils/knapsack.nim
  isVerificationFile: true
  path: verify/utils/knapsack/bounded_zero_count_test.nim
  requiredBy: []
  timestamp: '2026-09-18 01:13:21+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/utils/knapsack/bounded_zero_count_test.nim
layout: document
redirect_from:
- /verify/verify/utils/knapsack/bounded_zero_count_test.nim
- /verify/verify/utils/knapsack/bounded_zero_count_test.nim.html
title: verify/utils/knapsack/bounded_zero_count_test.nim
---
