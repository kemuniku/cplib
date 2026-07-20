---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination.nim
    title: cplib/math/combination.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_prefix_sum.nim
    title: cplib/math/combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_prefix_sum.nim
    title: cplib/math/combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
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
    echo \"Hello World\"\n\nimport atcoder/modint\nimport cplib/math/combination\n\
    import cplib/math/combination_prefix_sum\n\nproc check[ModInt]() =\n    var queries:\
    \ seq[(int, int)]\n    for x in countdown(20, 0):\n        for y in 0..25:\n \
    \           queries.add((x, y))\n\n    let actual = combination_prefix_sum.combinationPrefixSum[ModInt](queries)\n\
    \    let combination = initCombination[ModInt](20)\n    for queryIndex, (x, y)\
    \ in queries:\n        var expected: ModInt = 0\n        for i in 0..min(x, y):\n\
    \            expected += combination.ncr(x, i)\n        doAssert actual[queryIndex]\
    \ == expected\n\n    let empty: seq[(int, int)] = @[]\n    doAssert combination_prefix_sum.combinationPrefixSum[ModInt](empty).len\
    \ == 0\n\n    var rangeQueries: seq[(int, int, int)]\n    for n in countdown(20,\
    \ 0):\n        for l in -2..22:\n            for r in -2..22:\n              \
    \  rangeQueries.add((n, l, r))\n\n    let rangeActual = combinationRangeSum[ModInt](rangeQueries)\n\
    \    for queryIndex, (n, l, r) in rangeQueries:\n        var expected: ModInt\
    \ = 0\n        for i in max(0, l)..<min(n + 1, r):\n            expected += combination.ncr(n,\
    \ i)\n        doAssert rangeActual[queryIndex] == expected\n\n    let emptyRange:\
    \ seq[(int, int, int)] = @[]\n    doAssert combinationRangeSum[ModInt](emptyRange).len\
    \ == 0\n\ncheck[modint998244353]()\ncheck[modint1000000007]()\n\ntype DynamicModInt\
    \ = modint\nDynamicModInt.setMod(1_000_000_007)\ncheck[DynamicModInt]()\n"
  dependsOn:
  - cplib/math/combination.nim
  - cplib/math/combination.nim
  - cplib/math/combination_prefix_sum.nim
  - cplib/utils/mo.nim
  - cplib/math/combination_prefix_sum.nim
  - cplib/utils/mo.nim
  isVerificationFile: true
  path: verify/math/combination_prefix_sum_test.nim
  requiredBy: []
  timestamp: '2026-07-16 13:30:07+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/combination_prefix_sum_test.nim
layout: document
redirect_from:
- /verify/verify/math/combination_prefix_sum_test.nim
- /verify/verify/math/combination_prefix_sum_test.nim.html
title: verify/math/combination_prefix_sum_test.nim
---
