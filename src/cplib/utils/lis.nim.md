---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/lis_aoj_test.nim
    title: verify/utils/lis_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/lis_aoj_test.nim
    title: verify/utils/lis_aoj_test.nim
  - icon: ':x:'
    path: verify/utils/lis_arc126b_test.nim
    title: verify/utils/lis_arc126b_test.nim
  - icon: ':x:'
    path: verify/utils/lis_arc126b_test.nim
    title: verify/utils/lis_arc126b_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/restore_lis_aoj_test.nim
    title: verify/utils/restore_lis_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/restore_lis_aoj_test.nim
    title: verify/utils/restore_lis_aoj_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':question:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_LIS:\n    const COMPETITIVE_UTILS_LIS* = 1\n\
    \    import algorithm\n    proc lis*[T](a: openArray[T]): int =\n        var dp\
    \ = newSeq[T]()\n        for i in 0..<a.len:\n            var pos = dp.lowerBound(a[i])\n\
    \            if pos == dp.len: dp.add(a[i])\n            else: dp[pos] = a[i]\n\
    \        return dp.len\n\n    proc restore_lis*[T](a: openArray[T]): seq[T] =\n\
    \        var p = newSeq[int](a.len)\n        var dp = newSeq[T]()\n        for\
    \ i in 0..<a.len:\n            var pos = dp.lowerBound(a[i])\n            if pos\
    \ == dp.len: dp.add(a[i])\n            else: dp[pos] = a[i]\n            p[i]\
    \ = pos\n        result = newSeq[T]()\n        var t = dp.len - 1\n        for\
    \ i in countdown(a.len - 1, 0):\n            if p[i] == t:\n                result.add(a[i])\n\
    \                t -= 1\n        result.reverse\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/lis.nim
  requiredBy: []
  timestamp: '2024-04-09 01:08:32+09:00'
  verificationStatus: LIBRARY_SOME_WA
  verifiedWith:
  - verify/utils/restore_lis_aoj_test.nim
  - verify/utils/restore_lis_aoj_test.nim
  - verify/utils/lis_aoj_test.nim
  - verify/utils/lis_aoj_test.nim
  - verify/utils/lis_arc126b_test.nim
  - verify/utils/lis_arc126b_test.nim
documentation_of: cplib/utils/lis.nim
layout: document
redirect_from:
- /library/cplib/utils/lis.nim
- /library/cplib/utils/lis.nim.html
title: cplib/utils/lis.nim
---
