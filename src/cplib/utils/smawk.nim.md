---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/min_plus_convolution.nim
    title: cplib/convolution/min_plus_convolution.nim
  - icon: ':heavy_check_mark:'
    path: cplib/convolution/min_plus_convolution.nim
    title: cplib/convolution/min_plus_convolution.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/min_plus_convolution_test.nim
    title: verify/AI/min_plus_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/min_plus_convolution_test.nim
    title: verify/AI/min_plus_convolution_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_concave_arbitrary_test.nim
    title: verify/convolution/min_plus_convolution_concave_arbitrary_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_concave_arbitrary_test.nim
    title: verify/convolution/min_plus_convolution_concave_arbitrary_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
    title: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
    title: verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_convex_arbitrary_smawk_test.nim
    title: verify/convolution/min_plus_convolution_convex_arbitrary_smawk_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_convex_arbitrary_smawk_test.nim
    title: verify/convolution/min_plus_convolution_convex_arbitrary_smawk_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_convex_convex_test.nim
    title: verify/convolution/min_plus_convolution_convex_convex_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/convolution/min_plus_convolution_convex_convex_test.nim
    title: verify/convolution/min_plus_convolution_convex_convex_test.nim
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
  code: "when not declared CPLIB_UTILS_SMAWK:\n    const CPLIB_UTILS_SMAWK* = 1\n\n\
    \    proc smawk*[F](height, width: int, better: F): seq[int] =\n        ## \u5168\
    \u5358\u8ABF\u884C\u5217\u306E\u5404\u884C\u306E\u6700\u5C0F\u5217\u3092 O(height\
    \ + width) \u56DE\u306E\u6BD4\u8F03\u3067\u6C42\u3081\u308B\u3002\n        ##\
    \ better(row, oldCol, newCol) \u306F\u65B0\u3057\u3044\u5217\u304C\u771F\u306B\
    \u5C0F\u3055\u3044\u3068\u304D true\u3002\n        ## \u540C\u5024\u306A\u3089\
    \u5DE6\u7AEF\u3092\u8FD4\u3059\u3002\u5E45\u304C 0 \u306A\u3089\u5404\u884C\u306B\
    \ -1 \u3092\u8FD4\u3059\u3002\n        assert height >= 0 and width >= 0, \"\u9AD8\
    \u3055\u3068\u5E45\u306F\u975E\u8CA0\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        var answer = newSeq[int](height)\n        if width\
    \ == 0:\n            for r in 0..<height: answer[r] = -1\n            return answer\n\
    \        if height == 0: return answer\n        var capacity = width\n       \
    \ var count = height\n        while count > 0:\n            capacity += min(count,\
    \ width)\n            count = count div 2\n        var columns = newSeq[int](capacity)\n\
    \        for i in 0..<width: columns[i] = i\n        proc solve(first, step, count,\
    \ offset, width: int) =\n            ## \u884C\u3092\u7B49\u5DEE\u6570\u5217\u3067\
    \u8868\u3057\u3001\u5217\u524A\u6E1B\u306B\u5171\u6709\u914D\u5217\u3092\u4F7F\
    \u3046\u3002\u6642\u9593 O(count + width)\u3002\n            let reduced = offset\
    \ + width\n            var size = 0\n            for p in offset..<reduced:\n\
    \                let col = columns[p]\n                while size > 0 and better(first\
    \ + (size - 1) * step, columns[reduced + size - 1], col):\n                  \
    \  dec size\n                if size < count:\n                    columns[reduced\
    \ + size] = col\n                    inc size\n            if count > 1:\n   \
    \             solve(first + step, step * 2, count div 2, reduced, size)\n    \
    \        var left = 0\n            var i = 0\n            while i < count:\n \
    \               let row = first + i * step\n                let right = if i +\
    \ 1 < count: answer[row + step]\n                            else: columns[reduced\
    \ + size - 1]\n                var best = columns[reduced + left]\n          \
    \      while columns[reduced + left] < right:\n                    inc left\n\
    \                    let col = columns[reduced + left]\n                    if\
    \ better(row, best, col): best = col\n                answer[row] = best\n   \
    \             i += 2\n        solve(0, 1, height, 0, width)\n        return answer\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/smawk.nim
  requiredBy:
  - cplib/convolution/min_plus_convolution.nim
  - cplib/convolution/min_plus_convolution.nim
  timestamp: '2026-09-14 23:21:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/convolution/min_plus_convolution_convex_arbitrary_smawk_test.nim
  - verify/convolution/min_plus_convolution_convex_arbitrary_smawk_test.nim
  - verify/convolution/min_plus_convolution_concave_arbitrary_test.nim
  - verify/convolution/min_plus_convolution_concave_arbitrary_test.nim
  - verify/convolution/min_plus_convolution_convex_convex_test.nim
  - verify/convolution/min_plus_convolution_convex_convex_test.nim
  - verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
  - verify/convolution/min_plus_convolution_convex_arbitrary_monotone_minima_test.nim
  - verify/AI/min_plus_convolution_test.nim
  - verify/AI/min_plus_convolution_test.nim
documentation_of: cplib/utils/smawk.nim
layout: document
redirect_from:
- /library/cplib/utils/smawk.nim
- /library/cplib/utils/smawk.nim.html
title: cplib/utils/smawk.nim
---
