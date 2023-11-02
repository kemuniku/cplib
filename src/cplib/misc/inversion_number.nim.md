---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/misc/inversion_number_test.nim
    title: verify/misc/inversion_number_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/misc/inversion_number_test.nim
    title: verify/misc/inversion_number_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MISC_INVERSION_NUMBER:\n    const COMPETITIVE_MISC_INVERSION_NUMBER\
    \ * = 1\n    import algorithm, sequtils\n    import atcoder/fenwicktree\n    proc\
    \ inversion_number*(a: seq[int]): int =\n        let c = a.sorted.deduplicate(isSorted\
    \ = true)\n        var tree = initFenwickTree[int](c.len)\n        var ans = 0\n\
    \        for i in 0..<a.len:\n            var pos = c.lowerBound(a[i])\n     \
    \       if pos + 1 < c.len:\n                ans += tree.sum(pos+1..<c.len)\n\
    \            tree.add(pos, 1)\n        return ans\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/misc/inversion_number.nim
  requiredBy: []
  timestamp: '2023-11-02 23:17:10+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/misc/inversion_number_test.nim
  - verify/misc/inversion_number_test.nim
documentation_of: cplib/misc/inversion_number.nim
layout: document
redirect_from:
- /library/cplib/misc/inversion_number.nim
- /library/cplib/misc/inversion_number.nim.html
title: cplib/misc/inversion_number.nim
---
