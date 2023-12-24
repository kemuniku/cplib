---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/inversion_number_test.nim
    title: verify/utils/inversion_number_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/inversion_number_test.nim
    title: verify/utils/inversion_number_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_INVERSION_NUMBER:\n    const COMPETITIVE_UTILS_INVERSION_NUMBER*\
    \ = 1\n    import algorithm, sequtils\n    import atcoder/fenwicktree\n    proc\
    \ inversion_number*(a: seq[int]): int =\n        let c = a.sorted.deduplicate(isSorted\
    \ = true)\n        var tree = initFenwickTree[int](c.len)\n        var ans = 0\n\
    \        for i in 0..<a.len:\n            var pos = c.lowerBound(a[i])\n     \
    \       if pos + 1 < c.len:\n                ans += tree.sum(pos+1..<c.len)\n\
    \            tree.add(pos, 1)\n        return ans\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/inversion_number.nim
  requiredBy: []
  timestamp: '2023-12-25 07:39:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/inversion_number_test.nim
  - verify/utils/inversion_number_test.nim
documentation_of: cplib/utils/inversion_number.nim
layout: document
title: "\u8EE2\u5012\u6570"
---

## 計算量
$\mathrm{O} (N \log N)$

## 概要
配列に対して、転倒数（バブルソートの操作回数の最小値）を返します。
