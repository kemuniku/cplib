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
    \ -1 \u3092\u8FD4\u3059\u3002\n        assert height >= 0 and width >= 0\n   \
    \     var answer = newSeq[int](height)\n        for r in 0..<height: answer[r]\
    \ = -1\n        if height == 0 or width == 0: return answer\n        proc solve(rows,\
    \ columns: seq[int]) =\n            ## \u5217\u524A\u6E1B\u3068\u5947\u6570\u884C\
    \u3078\u306E\u518D\u5E30\u3067\u884C\u6700\u5C0F\u5024\u3092\u6C42\u3081\u308B\
    \u3002\n            if rows.len == 0: return\n            var reduced = newSeqOfCap[int](min(rows.len,\
    \ columns.len))\n            for c in columns:\n                while reduced.len\
    \ > 0 and better(rows[reduced.len - 1], reduced[^1], c):\n                   \
    \ reduced.setLen(reduced.len - 1)\n                if reduced.len < rows.len:\
    \ reduced.add(c)\n            var odd = newSeqOfCap[int](rows.len div 2)\n   \
    \         var i = 1\n            while i < rows.len:\n                odd.add(rows[i])\n\
    \                i += 2\n            solve(odd, reduced)\n            var left\
    \ = 0\n            i = 0\n            while i < rows.len:\n                var\
    \ right = reduced.len - 1\n                if i + 1 < rows.len:\n            \
    \        right = left\n                    while reduced[right] != answer[rows[i\
    \ + 1]]: inc right\n                var best = left\n                for j in\
    \ left + 1..right:\n                    if better(rows[i], reduced[best], reduced[j]):\
    \ best = j\n                answer[rows[i]] = reduced[best]\n                left\
    \ = right\n                i += 2\n        var rows = newSeq[int](height)\n  \
    \      var columns = newSeq[int](width)\n        for i in 0..<height: rows[i]\
    \ = i\n        for i in 0..<width: columns[i] = i\n        solve(rows, columns)\n\
    \        return answer\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/smawk.nim
  requiredBy:
  - cplib/convolution/min_plus_convolution.nim
  - cplib/convolution/min_plus_convolution.nim
  timestamp: '2026-09-13 11:47:37+09:00'
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
