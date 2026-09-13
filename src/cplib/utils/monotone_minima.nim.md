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
  code: "when not declared CPLIB_UTILS_MONOTONE_MINIMA:\n    const CPLIB_UTILS_MONOTONE_MINIMA*\
    \ = 1\n\n    proc monotoneMinima*[F](height, width: int, better: F): seq[int]\
    \ =\n        ## \u5DE6\u7AEF\u6700\u5C0F\u5217\u304C\u5E83\u7FA9\u5358\u8ABF\u5897\
    \u52A0\u3059\u308B\u884C\u5217\u3092 O(height + width * log(height + 1)) \u56DE\
    \u306E\u6BD4\u8F03\u3067\u63A2\u7D22\u3059\u308B\u3002\n        ## better(row,\
    \ oldCol, newCol) \u306F\u65B0\u3057\u3044\u5217\u304C\u771F\u306B\u5C0F\u3055\
    \u3044\u3068\u304D true\u3002\u5E45 0 \u306A\u3089 -1\u3002\n        assert height\
    \ >= 0 and width >= 0, \"\u9AD8\u3055\u3068\u5E45\u306F\u975E\u8CA0\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var answer = newSeq[int](height)\n\
    \        for r in 0..<height: answer[r] = -1\n        if height == 0 or width\
    \ == 0: return answer\n        proc solve(top, bottom, left, right: int) =\n \
    \           ## \u4E2D\u592E\u884C\u3092\u63A2\u7D22\u3057\u3001\u6700\u5C0F\u5217\
    \u3067\u4E0A\u4E0B\u306E\u63A2\u7D22\u7BC4\u56F2\u3092\u5236\u9650\u3059\u308B\
    \u3002\n            if top >= bottom: return\n            let row = (top + bottom)\
    \ div 2\n            var best = left\n            for col in left + 1..right:\n\
    \                if better(row, best, col): best = col\n            answer[row]\
    \ = best\n            solve(top, row, left, best)\n            solve(row + 1,\
    \ bottom, best, right)\n        solve(0, height, 0, width - 1)\n        return\
    \ answer\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/monotone_minima.nim
  requiredBy:
  - cplib/convolution/min_plus_convolution.nim
  - cplib/convolution/min_plus_convolution.nim
  timestamp: '2026-09-13 17:15:27+09:00'
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
documentation_of: cplib/utils/monotone_minima.nim
layout: document
redirect_from:
- /library/cplib/utils/monotone_minima.nim
- /library/cplib/utils/monotone_minima.nim.html
title: cplib/utils/monotone_minima.nim
---
