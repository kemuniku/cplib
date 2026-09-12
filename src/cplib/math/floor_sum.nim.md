---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/floor_sum_test.nim
    title: verify/AI/floor_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/floor_sum_test.nim
    title: verify/AI/floor_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/floor_sum_yosupo_test.nim
    title: verify/math/floor_sum_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/floor_sum_yosupo_test.nim
    title: verify/math/floor_sum_yosupo_test.nim
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
  code: "when not declared CPLIB_MATH_FLOOR_SUM:\n    const CPLIB_MATH_FLOOR_SUM*\
    \ = 1\n\n    import cplib/math/int128\n\n    proc floor_sum*(n, m, a, b: int):\
    \ int =\n        ## \u03A3 floor((a*i+b)/m) (0 <= i < n) \u3092 O(log m) \u6642\
    \u9593\u3001O(1) \u7A7A\u9593\u3067\u8FD4\u3059\u3002\n        ## n, a, b >= 0\u3001\
    m > 0\u3001\u7B54\u3048\u304C int \u306B\u53CE\u307E\u308B\u3053\u3068\u3092\u524D\
    \u63D0\u3068\u3059\u308B\u3002C++ \u30D0\u30C3\u30AF\u30A8\u30F3\u30C9\u7528\u3002\
    \n        assert n >= 0 and m > 0 and a >= 0 and b >= 0\n        var n = to_Int128(n)\n\
    \        var m = to_Int128(m)\n        var a = to_Int128(a)\n        var b = to_Int128(b)\n\
    \        var answer = to_Int128(0)\n        while true:\n            if a >= m:\n\
    \                answer += n * (n - 1) div 2 * (a div m)\n                a =\
    \ a mod m\n            if b >= m:\n                answer += n * (b div m)\n \
    \               b = b mod m\n            assert answer <= to_Int128(high(int))\n\
    \            let y = a * n + b\n            if y < m:\n                break\n\
    \            n = y div m\n            b = y mod m\n            swap(m, a)\n  \
    \      return answer.to_int\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/math/floor_sum.nim
  requiredBy: []
  timestamp: '2026-09-12 14:53:22+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/floor_sum_yosupo_test.nim
  - verify/math/floor_sum_yosupo_test.nim
  - verify/AI/floor_sum_test.nim
  - verify/AI/floor_sum_test.nim
documentation_of: cplib/math/floor_sum.nim
layout: document
redirect_from:
- /library/cplib/math/floor_sum.nim
- /library/cplib/math/floor_sum.nim.html
title: cplib/math/floor_sum.nim
---
