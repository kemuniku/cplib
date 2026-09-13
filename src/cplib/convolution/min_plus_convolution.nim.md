---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/monotone_minima.nim
    title: cplib/utils/monotone_minima.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/monotone_minima.nim
    title: cplib/utils/monotone_minima.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/smawk.nim
    title: cplib/utils/smawk.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/smawk.nim
    title: cplib/utils/smawk.nim
  _extendedRequiredBy: []
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
  code: "when not declared CPLIB_CONVOLUTION_MIN_PLUS_CONVOLUTION:\n    ## c[k] =\
    \ min(a[i] + b[j] | i+j=k) \u3092\u8FD4\u3059\u3002\u7247\u65B9\u304C\u7A7A\u306A\
    \u3089\u7A7A\u5217\u3092\u8FD4\u3059\u3002\n    ## \u51F8\u306F\u96A3\u63A5\u5DEE\
    \u5206\u304C\u5E83\u7FA9\u5358\u8ABF\u5897\u52A0\u3001\u51F9\u306F\u5E83\u7FA9\
    \u5358\u8ABF\u6E1B\u5C11\u3002\u524D\u63D0\u306E\u691C\u67FB\u306F\u884C\u308F\
    \u306A\u3044\u3002\n    ## \u3059\u3079\u3066\u306E\u5019\u88DC\u306E\u548C\u304C\
    \ T \u3067\u8868\u73FE\u53EF\u80FD\u3067\u3042\u308B\u3053\u3068\u3002\u7A7A\u9593\
    \u8A08\u7B97\u91CF\u306F\u5168 API \u3067 O(N + M)\u3002\n    const CPLIB_CONVOLUTION_MIN_PLUS_CONVOLUTION*\
    \ = 1\n    import cplib/utils/monotone_minima\n    import cplib/utils/smawk\n\n\
    \    proc minPlusConvolutionConvexConvex*[T](a, b: seq[T]): seq[T] =\n       \
    \ ## \u51F8\u6570\u5217\u540C\u58EB\u306E min-plus \u7573\u307F\u8FBC\u307F\u3092\
    \ O(N + M) \u6642\u9593\u3067\u6C42\u3081\u308B\u3002\n        if a.len == 0 or\
    \ b.len == 0: return @[]\n        result = newSeq[T](a.len + b.len - 1)\n    \
    \    var i = 0\n        var j = 0\n        result[0] = a[0] + b[0]\n        for\
    \ k in 1..<result.len:\n            if j + 1 == b.len or (i + 1 < a.len and a[i\
    \ + 1] + b[j] < a[i] + b[j + 1]):\n                inc i\n            else:\n\
    \                inc j\n            result[k] = a[i] + b[j]\n\n    proc convexArbitrary[T](a,\
    \ b: seq[T], useSmawk: static[bool]): seq[T] =\n        ## \u51F8\u306A a \u3068\
    \u4EFB\u610F\u306E b \u306E\u7573\u307F\u8FBC\u307F\u3092\u6307\u5B9A\u3055\u308C\
    \u305F\u884C\u6700\u5C0F\u5024\u63A2\u7D22\u3067\u6C42\u3081\u308B\u3002\n   \
    \     if a.len == 0 or b.len == 0: return @[]\n        let h = a.len + b.len -\
    \ 1\n        proc better(row, oldCol, newCol: int): bool =\n            ## \u7121\
    \u52B9\u306A\u5217\u3092\u6BD4\u8F03\u5024\u306B\u5909\u63DB\u305B\u305A\u3001\
    \u6709\u52B9\u533A\u9593\u306B\u8FD1\u3044\u5217\u3092\u512A\u5148\u3059\u308B\
    \u3002\n            if newCol > row: return false\n            if oldCol > row:\
    \ return true\n            if oldCol < row - a.len + 1: return true\n        \
    \    if newCol < row - a.len + 1: return false\n            return a[row - newCol]\
    \ + b[newCol] < a[row - oldCol] + b[oldCol]\n        when useSmawk:\n        \
    \    let indices = smawk(h, b.len, better)\n        else:\n            let indices\
    \ = monotoneMinima(h, b.len, better)\n        result = newSeq[T](h)\n        for\
    \ k in 0..<h: result[k] = a[k - indices[k]] + b[indices[k]]\n\n    proc minPlusConvolutionConvexArbitraryMonotoneMinima*[T](a,\
    \ b: seq[T]): seq[T] =\n        ## \u51F8\u306A a \u3068\u4EFB\u610F\u306E b \u306E\
    \ min-plus \u7573\u307F\u8FBC\u307F\u3002\u6642\u9593 O((N + M) log(N + M))\u3002\
    \n        convexArbitrary(a, b, false)\n\n    proc minPlusConvolutionConvexArbitrarySmawk*[T](a,\
    \ b: seq[T]): seq[T] =\n        ## \u51F8\u306A a \u3068\u4EFB\u610F\u306E b \u306E\
    \ min-plus \u7573\u307F\u8FBC\u307F\u3002\u6642\u9593 O(N + M)\u3002\n       \
    \ convexArbitrary(a, b, true)\n\n    proc minPlusConvolutionConcaveConcave*[T](a,\
    \ b: seq[T]): seq[T] =\n        ## \u51F9\u6570\u5217\u540C\u58EB\u306E min-plus\
    \ \u7573\u307F\u8FBC\u307F\u3092\u5019\u88DC\u533A\u9593\u306E\u4E21\u7AEF\u304B\
    \u3089 O(N + M) \u6642\u9593\u3067\u6C42\u3081\u308B\u3002\n        if a.len ==\
    \ 0 or b.len == 0: return @[]\n        result = newSeq[T](a.len + b.len - 1)\n\
    \        for k in 0..<result.len:\n            let lo = max(0, k - b.len + 1)\n\
    \            let hi = min(k, a.len - 1)\n            result[k] = min(a[lo] + b[k\
    \ - lo], a[hi] + b[k - hi])\n\n    proc concaveSmawk[T](a, b: seq[T], first, step,\
    \ count, offset, width: int,\n                         columns, indices: var seq[int])\
    \ =\n        ## \u884C\u3092\u7B49\u5DEE\u6570\u5217\u3067\u8868\u3057\u3001\u5171\
    \u6709\u30D0\u30C3\u30D5\u30A1\u5185\u3067\u5217\u3092\u524A\u6E1B\u3059\u308B\
    \u3002\u6642\u9593 O(count + width)\u3002\n        let reduced = offset + width\n\
    \        var size = 0\n        for p in offset..<reduced:\n            let col\
    \ = columns[p]\n            while size > 0:\n                let row = first +\
    \ (size - 1) * step\n                let old = columns[reduced + size - 1]\n \
    \               if not (a[row - col] + b[col] < a[row - old] + b[old]): break\n\
    \                dec size\n            if size < count:\n                columns[reduced\
    \ + size] = col\n                inc size\n        if count > 1:\n           \
    \ concaveSmawk(a, b, first + step, step * 2, count div 2,\n                  \
    \       reduced, size, columns, indices)\n        var left = 0\n        var i\
    \ = 0\n        while i < count:\n            let row = first + i * step\n    \
    \        var right = size - 1\n            if i + 1 < count:\n               \
    \ right = left\n                while columns[reduced + right] != indices[row\
    \ + step]: inc right\n            var best = columns[reduced + left]\n       \
    \     var value = a[row - best] + b[best]\n            for p in left + 1..right:\n\
    \                let col = columns[reduced + p]\n                let candidate\
    \ = a[row - col] + b[col]\n                if candidate < value:\n           \
    \         best = col\n                    value = candidate\n            indices[row]\
    \ = best\n            left = right\n            i += 2\n\n    proc concaveDivide[T](a,\
    \ b: seq[T], top, bottom, left, right: int,\n                          answer:\
    \ var seq[T], columns, indices: var seq[int]) =\n        ## \u6709\u52B9\u9818\
    \u57DF\u3092\u9577\u65B9\u5F62\u306B\u5206\u5272\u3057\u3001\u4F5C\u696D\u914D\
    \u5217\u3092\u518D\u5229\u7528\u3057\u3066\u6700\u5C0F\u5024\u3092\u66F4\u65B0\
    \u3059\u308B\u3002\n        let t = max(top, left)\n        let d = min(bottom,\
    \ right + a.len - 1)\n        let l = max(left, t - a.len + 1)\n        let r\
    \ = min(right, d)\n        if t >= d or l >= r: return\n        if d - t <= 1024\
    \ div (r - l):\n            for row in t..<d:\n                var value = answer[row]\n\
    \                for col in max(l, row - a.len + 1)..<min(r, row + 1):\n     \
    \               value = min(value, a[row - col] + b[col])\n                answer[row]\
    \ = value\n        elif r - 1 <= t and d - 1 < l + a.len:\n            for p in\
    \ 0..<r - l: columns[p] = r - 1 - p\n            concaveSmawk(a, b, t, 1, d -\
    \ t, 0, r - l, columns, indices)\n            for row in t..<d:\n            \
    \    let col = indices[row]\n                answer[row] = min(answer[row], a[row\
    \ - col] + b[col])\n        elif d - t >= r - l:\n            let mid = (t + d)\
    \ div 2\n            concaveDivide(a, b, t, mid, l, r, answer, columns, indices)\n\
    \            concaveDivide(a, b, mid, d, l, r, answer, columns, indices)\n   \
    \     else:\n            let mid = (l + r) div 2\n            concaveDivide(a,\
    \ b, t, d, l, mid, answer, columns, indices)\n            concaveDivide(a, b,\
    \ t, d, mid, r, answer, columns, indices)\n\n    proc minPlusConvolutionConcaveArbitrary*[T](a,\
    \ b: seq[T]): seq[T] =\n        ## \u51F9\u306A a \u3068\u4EFB\u610F\u306E b \u306E\
    \ min-plus \u7573\u307F\u8FBC\u307F\u3002\u6642\u9593 O((N + M) log(N + M))\u3001\
    \u7A7A\u9593 O(N + M)\u3002\n        if a.len == 0 or b.len == 0: return @[]\n\
    \        let h = a.len + b.len - 1\n        result = newSeq[T](h)\n        for\
    \ k in 0..<h:\n            let j = min(k, b.len - 1)\n            result[k] =\
    \ a[k - j] + b[j]\n        if a.len == 1 or b.len == 1: return\n        # \u5217\
    \u524A\u6E1B\u5F8C\u306E\u9577\u3055\u306F\u884C\u6570\u4EE5\u4E0B\u3067\u3001\
    \u518D\u5E30\u3054\u3068\u306B\u884C\u6570\u304C\u534A\u6E1B\u3059\u308B\u3002\
    \n        var columns = newSeq[int](b.len + 2 * h)\n        var indices = newSeq[int](h)\n\
    \        concaveDivide(a, b, 0, h, 0, b.len, result, columns, indices)\n"
  dependsOn:
  - cplib/utils/monotone_minima.nim
  - cplib/utils/smawk.nim
  - cplib/utils/monotone_minima.nim
  - cplib/utils/smawk.nim
  isVerificationFile: false
  path: cplib/convolution/min_plus_convolution.nim
  requiredBy: []
  timestamp: '2026-09-13 12:02:32+09:00'
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
documentation_of: cplib/convolution/min_plus_convolution.nim
layout: document
redirect_from:
- /library/cplib/convolution/min_plus_convolution.nim
- /library/cplib/convolution/min_plus_convolution.nim.html
title: cplib/convolution/min_plus_convolution.nim
---
