---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':x:'
    path: cplib/math/generalized_floor_sum.nim
    title: cplib/math/generalized_floor_sum.nim
  - icon: ':x:'
    path: cplib/math/generalized_floor_sum.nim
    title: cplib/math/generalized_floor_sum.nim
  _extendedVerifiedWith:
  - icon: ':x:'
    path: verify/math/generalized_floor_sum_test.nim
    title: verify/math/generalized_floor_sum_test.nim
  - icon: ':x:'
    path: verify/math/generalized_floor_sum_test.nim
    title: verify/math/generalized_floor_sum_test.nim
  - icon: ':x:'
    path: verify/math/monoid_floor_sum_test.nim
    title: verify/math/monoid_floor_sum_test.nim
  - icon: ':x:'
    path: verify/math/monoid_floor_sum_test.nim
    title: verify/math/monoid_floor_sum_test.nim
  _isVerificationFailed: true
  _pathExtension: nim
  _verificationStatusIcon: ':x:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_MONOID_FLOOR_SUM:\n    const CPLIB_MATH_MONOID_FLOOR_SUM*\
    \ = 1\n\n    proc monoidFloorSum*[T](n, m, a, b: int, x, y: T,\n             \
    \                    op: proc(l, r: T): T, e: T): T =\n        ## h(i) = floor((a*i+b)/m)\
    \ \u3068\u3057\u3066 y^h(0) * \u03A0(i=1..n, x*y^(h(i)-h(i-1))) \u3092\u8FD4\u3059\
    \u3002\n        ## op \u306F\u7D50\u5408\u7684\u306A\u7A4D\u3001e \u306F\u5358\
    \u4F4D\u5143\u3002\u7A4D\u306F\u5DE6\u304B\u3089\u9806\u306B\u53D6\u308A\u3001\
    \u53EF\u63DB\u6027\u306F\u4E0D\u8981\u3002\n        ## n,a,b >= 0\u3001m > 0\u3001\
    a*n+b <= high(int) \u304C\u5FC5\u8981\u3002n=0 \u3067\u306F y^h(0) \u3092\u8FD4\
    \u3059\u3002\n        ## op \u306E\u547C\u3073\u51FA\u3057\u56DE\u6570\u306F O(log(m+1)*log(n+a+b+2))\u3001\
    \u8FFD\u52A0\u9818\u57DF\u306F O(1) \u500B\u306E T\u3002\n        proc power(value:\
    \ T, exponent: int): T =\n            ## \u30E2\u30CE\u30A4\u30C9\u306E\u975E\u8CA0\
    \u6574\u6570\u4E57\u3092 O(log(exponent+1)) \u56DE\u306E\u6F14\u7B97\u3067\u6C42\
    \u3081\u308B\u3002\n            var value = value\n            var exponent =\
    \ exponent\n            result = e\n            while exponent > 0:\n        \
    \        if (exponent and 1) != 0:\n                    result = op(result, value)\n\
    \                exponent = exponent shr 1\n                if exponent > 0:\n\
    \                    value = op(value, value)\n\n        assert n >= 0 and m >\
    \ 0 and a >= 0 and b >= 0, \"n\u3001a\u3001b\u306F\u975E\u8CA0\u3067\u3001m\u306F\
    \u6B63\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ assert n == 0 or a <= (high(int) - b) div n, \"a * n + b\u304Cint\u306E\u7BC4\
    \u56F2\u306B\u53CE\u307E\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       var\n            n = n\n            m = m\n            a = a\n       \
    \     b = b\n            x = x\n            y = y\n            prefix = e\n  \
    \          suffix = e\n        while true:\n            prefix = op(prefix, power(y,\
    \ b div m))\n            x = op(x, power(y, a div m))\n            a = a mod m\n\
    \            b = b mod m\n            let height = (a * n + b) div m\n       \
    \     if height == 0:\n                return op(op(prefix, power(x, n)), suffix)\n\
    \n            let lastX = (m * height - b - 1) div a + 1\n            prefix =\
    \ op(prefix, x)\n            suffix = op(op(y, power(x, n - lastX)), suffix)\n\
    \            # \u7E26\u6A2A\u3092\u4EA4\u63DB\u3059\u308B\u3002\u5207\u7247\u304B\
    \u3089 a \u3092\u5916\u3057\u3066\u5148\u982D\u306E x \u306B\u79FB\u3057\u3001\
    \u52A0\u7B97\u306E\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3092\u907F\u3051\
    \u308B\u3002\n            n = height - 1\n            b = m - b - 1\n        \
    \    swap(a, m)\n            swap(x, y)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/monoid_floor_sum.nim
  requiredBy:
  - cplib/math/generalized_floor_sum.nim
  - cplib/math/generalized_floor_sum.nim
  timestamp: '2026-09-13 17:15:27+09:00'
  verificationStatus: LIBRARY_ALL_WA
  verifiedWith:
  - verify/math/monoid_floor_sum_test.nim
  - verify/math/monoid_floor_sum_test.nim
  - verify/math/generalized_floor_sum_test.nim
  - verify/math/generalized_floor_sum_test.nim
documentation_of: cplib/math/monoid_floor_sum.nim
layout: document
redirect_from:
- /library/cplib/math/monoid_floor_sum.nim
- /library/cplib/math/monoid_floor_sum.nim.html
title: cplib/math/monoid_floor_sum.nim
---
