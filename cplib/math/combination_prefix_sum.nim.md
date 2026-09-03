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
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_prefix_sum_test.nim
    title: verify/math/combination_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_prefix_sum_test.nim
    title: verify/math/combination_prefix_sum_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_COMBINATION_PREFIX_SUM:\n    const CPLIB_MATH_COMBINATION_PREFIX_SUM*\
    \ = 1\n\n    import cplib/math/combination\n    import cplib/utils/mo\n\n    proc\
    \ combinationPrefixSum*[ModInt](queries: openArray[(int, int)]): seq[ModInt] =\n\
    \        ## \u4E8C\u9805\u4FC2\u6570\u306Eprefix sum\u3092\u30AA\u30D5\u30E9\u30A4\
    \u30F3\u3067\u6C42\u3081\u308B\n        if queries.len == 0:\n            return\
    \ @[]\n\n        var maxX = 0\n        for (x, _) in queries:\n            maxX\
    \ = max(maxX, x)\n\n        let combination = initCombination[ModInt](max(1, maxX))\n\
    \        var mo = initMo(max(1, maxX), queries.len)\n        for (x, y) in queries:\n\
    \            mo.insert(x, min(x, y))\n\n        var answers = newSeq[ModInt](queries.len)\n\
    \        var\n            x = 0\n            y = 0\n            sum: ModInt =\
    \ 1\n\n        mo.run(\n            proc(newX: int) =\n                x = newX\n\
    \                sum = (sum + combination.ncr(x, y)) / 2,\n            proc(oldY:\
    \ int) =\n                y = oldY + 1\n                sum += combination.ncr(x,\
    \ y),\n            proc(oldX: int) =\n                sum = 2 * sum - combination.ncr(oldX,\
    \ y)\n                x = oldX + 1,\n            proc(newY: int) =\n         \
    \       sum -= combination.ncr(x, newY + 1)\n                y = newY,\n     \
    \       proc(queryIndex: int) =\n                answers[queryIndex] = sum\n \
    \       )\n        result = answers\n\n    proc combinationRangeSum*[ModInt](queries:\
    \ openArray[(int, int, int)]): seq[ModInt] =\n        ## \u5404 (n, l, r) \u306B\
    \u3064\u3044\u3066 sum(i=l..<r, nCi) \u3092\u30AA\u30D5\u30E9\u30A4\u30F3\u3067\
    \u6C42\u3081\u308B\n        result = newSeq[ModInt](queries.len)\n\n        var\n\
    \            prefixQueries: seq[(int, int)]\n            queryIndices: seq[(int,\
    \ int)]\n        for queryIndex, (n, l, r) in queries:\n            let\n    \
    \            left = max(0, l)\n                right = min(n + 1, r)\n       \
    \     if left >= right:\n                continue\n            queryIndices.add((queryIndex,\
    \ prefixQueries.len))\n            prefixQueries.add((n, right - 1))\n       \
    \     prefixQueries.add((n, left - 1))\n\n        let prefixSums = combinationPrefixSum[ModInt](prefixQueries)\n\
    \        for (queryIndex, prefixIndex) in queryIndices:\n            result[queryIndex]\
    \ = prefixSums[prefixIndex] - prefixSums[prefixIndex + 1]\n"
  dependsOn:
  - cplib/math/combination.nim
  - cplib/math/combination.nim
  - cplib/utils/mo.nim
  - cplib/utils/mo.nim
  isVerificationFile: false
  path: cplib/math/combination_prefix_sum.nim
  requiredBy: []
  timestamp: '2026-07-16 13:30:07+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/combination_prefix_sum_test.nim
  - verify/math/combination_prefix_sum_test.nim
documentation_of: cplib/math/combination_prefix_sum.nim
layout: document
redirect_from:
- /library/cplib/math/combination_prefix_sum.nim
- /library/cplib/math/combination_prefix_sum.nim.html
title: cplib/math/combination_prefix_sum.nim
---
