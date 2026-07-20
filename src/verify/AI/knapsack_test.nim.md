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
  code: '# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A

    echo "Hello World"


    import cplib/utils/knapsack


    let items = @[(v: 6, w: 2), (v: 10, w: 4), (v: 12, w: 6)]

    assert solve_01knapsack_NW(items, 8) == 18

    assert solve_01knapsack_NV(items, 8) == 18

    assert solve_01knapsack_meet_in_middle(items, 8) == 18

    assert solve_UBknapsack_NW(@[(v: 3, w: 2), (v: 4, w: 3)], 7) == 10

    assert solve_BoundedKnapsack(@[(v: 5, w: 2, m: 2), (v: 6, w: 3, m: 1)], 5) ==
    11

    '
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/utils/knapsack.nim
  - cplib/utils/knapsack.nim
  isVerificationFile: true
  path: verify/AI/knapsack_test.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/knapsack_test.nim
layout: document
redirect_from:
- /verify/verify/AI/knapsack_test.nim
- /verify/verify/AI/knapsack_test.nim.html
title: verify/AI/knapsack_test.nim
---
