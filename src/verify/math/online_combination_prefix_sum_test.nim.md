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
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isqrt.nim
    title: cplib/math/isqrt.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/online_combination_prefix_sum.nim
    title: cplib/math/online_combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/online_combination_prefix_sum.nim
    title: cplib/math/online_combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/barrett_impl.nim
    title: cplib/modint/barrett_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/modint.nim
    title: cplib/modint/modint.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/modint/montgomery_impl.nim
    title: cplib/modint/montgomery_impl.nim
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
    import random\nimport cplib/modint/modint\nimport cplib/math/online_combination_prefix_sum\n\
    import cplib/math/combination_prefix_sum\n\ntemplate expectValueError(body: untyped)\
    \ =\n    block:\n        var caught = false\n        try:\n            body\n\
    \        except ValueError:\n            caught = true\n        doAssert caught\n\
    \nproc check[M](limit: int) =\n    var pascal = newSeq[seq[M]](limit + 1)\n  \
    \  var prefixes = newSeq[seq[M]](limit + 1)\n    for n in 0..limit:\n        pascal[n]\
    \ = newSeq[M](n + 1)\n        pascal[n][0] = 1\n        pascal[n][n] = 1\n   \
    \     for k in 1..<n:\n            pascal[n][k] = pascal[n - 1][k - 1] + pascal[n\
    \ - 1][k]\n        prefixes[n] = newSeq[M](n + 1)\n        var s: M = 0\n    \
    \    for k in 0..n:\n            s += pascal[n][k]\n            prefixes[n][k]\
    \ = s\n    proc expected(n, k: int): M =\n        if k < 0: return M(0)\n    \
    \    return prefixes[n][min(n, k)]\n\n    # \u5C0F\u3055\u3044\u69CB\u7BC9\u4E0A\
    \u9650\u3092\u5168\u63A2\u7D22\u3057\u3001\u5947\u5076\u306E\u884C\u30FB\u5E45\
    \u3001\u4E2D\u592E\u306E\u53CD\u5C04\u70B9\u3068\u30D6\u30ED\u30C3\u30AF\u5883\
    \u754C\u3092\u691C\u67FB\u3002\n    for cap in 0..limit:\n        if cap > 64\
    \ and cap != limit: continue\n        let sums = initOnlineCombinationPrefixSum[M](cap)\n\
    \        for n in countdown(cap, 0):\n            for k in -2..cap + 2:\n    \
    \            doAssert sums.prefixSum(n, k) == expected(n, k)\n            doAssert\
    \ sums.prefixSum(n, low(int)) == M(0)\n            doAssert sums.prefixSum(n,\
    \ high(int)) == expected(n, n)\n            doAssert sums.rangeSum(n, low(int),\
    \ high(int)) == expected(n, n)\n            doAssert sums.rangeSum(n, high(int),\
    \ low(int)) == M(0)\n            doAssert sums.rangeSum(n, low(int), low(int))\
    \ == M(0)\n            doAssert sums.rangeSum(n, high(int), high(int)) == M(0)\n\
    \            if cap <= 26:\n                for l in -2..cap + 2:\n          \
    \          for r in -2..cap + 2:\n                        var want: M = 0\n  \
    \                      for k in max(l, 0)..<min(r, n + 1):\n                 \
    \           want += pascal[n][k]\n                        doAssert sums.rangeSum(n,\
    \ l, r) == want\n        expectValueError: discard sums.prefixSum(-1, 0)\n   \
    \     expectValueError: discard sums.prefixSum(cap + 1, -1)\n        expectValueError:\
    \ discard sums.rangeSum(-1, 5, 2)\n    let sums = initOnlineCombinationPrefixSum[M](limit)\n\
    \    var rng = initRand(1085)\n    var previous = 0\n    for q in 0..<10000:\n\
    \        let n = (rng.rand(limit) + previous) mod (limit + 1)\n        let k =\
    \ rng.rand(limit + 10) - 5\n        let answer = sums.prefixSum(n, k)\n      \
    \  doAssert answer == expected(n, k)\n        previous = int(answer.val) mod (limit\
    \ + 1)\n        let l = rng.rand(limit + 10) - 5\n        let r = rng.rand(limit\
    \ + 10) - 5\n        let want = if l >= r: M(0) else: expected(n, r - 1) - expected(n,\
    \ l - 1)\n        doAssert sums.rangeSum(n, l, r) == want\n    expectValueError:\
    \ discard initOnlineCombinationPrefixSum[M](-1)\n    expectValueError: discard\
    \ initOnlineCombinationPrefixSum[M](int(M.umod()))\n\ncheck[modint998244353_barrett](250)\n\
    check[modint1000000007_barrett](250)\ncheck[modint998244353_montgomery](250)\n\
    check[modint1000000007_montgomery](250)\nmodint_barrett.setMod(101)\ncheck[modint_barrett](100)\n\
    modint_barrett.setMod(2)\ncheck[modint_barrett](1)\nmodint_montgomery.setMod(101)\n\
    check[modint_montgomery](100)\nmodint_barrett.setMod(101)\nlet dynamicSums = initOnlineCombinationPrefixSum[modint_barrett](10)\n\
    modint_barrett.setMod(103)\nexpectValueError: discard dynamicSums.prefixSum(0,\
    \ -1)\nexpectValueError: discard dynamicSums.rangeSum(0, 2, 1)\nmodint_barrett.setMod(101)\n\
    doAssert dynamicSums.prefixSum(4, 2).val == 11\n\nlet online = initOnlineCombinationPrefixSum[modint998244353_barrett](100)\n\
    var queries: seq[(int, int)]\nfor n in 0..100:\n    for k in 0..n:\n        queries.add((n,\
    \ k))\nlet offline = combinationPrefixSum[modint998244353_barrett](queries)\n\
    for i, query in queries:\n    doAssert online.prefixSum(query[0], query[1]) ==\
    \ offline[i]\nblock:\n    type Mint = modint998244353_barrett\n    const limit\
    \ = 200000\n    let sums = initOnlineCombinationPrefixSum[Mint](limit)\n    var\
    \ rng = initRand(1085)\n    for i in 0..<1000:\n        let n = rng.rand(limit)\n\
    \        let k = rng.rand(n)\n        doAssert sums.prefixSum(n, k) + sums.prefixSum(n,\
    \ n - k - 1) == Mint(2).pow(n)\n        if n < limit:\n            doAssert sums.prefixSum(n\
    \ + 1, k) == sums.prefixSum(n, k) + sums.prefixSum(n, k - 1)\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/math/combination.nim
  - cplib/modint/modint.nim
  - cplib/math/online_combination_prefix_sum.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/modint/modint.nim
  - cplib/math/isqrt.nim
  - cplib/utils/mo.nim
  - cplib/math/combination_prefix_sum.nim
  - cplib/modint/barrett_impl.nim
  - cplib/modint/montgomery_impl.nim
  - cplib/utils/mo.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/math/isqrt.nim
  - cplib/modint/barrett_impl.nim
  - cplib/math/online_combination_prefix_sum.nim
  - cplib/math/combination_prefix_sum.nim
  - cplib/math/combination.nim
  isVerificationFile: true
  path: verify/math/online_combination_prefix_sum_test.nim
  requiredBy: []
  timestamp: '2026-10-29 04:34:39+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/math/online_combination_prefix_sum_test.nim
layout: document
redirect_from:
- /verify/verify/math/online_combination_prefix_sum_test.nim
- /verify/verify/math/online_combination_prefix_sum_test.nim.html
title: verify/math/online_combination_prefix_sum_test.nim
---
