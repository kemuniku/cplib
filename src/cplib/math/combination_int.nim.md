---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_COMBINATION_INT:\n    const CPLIB_MATH_COMBINATION_INT*\
    \ = 1\n\n    import cplib/math/int128\n    import cplib/utils/constants\n\n  \
    \  proc ncr_int*(n,r:int,limit:int=INF64):int=\n        ## nCr\u3092\u8A08\u7B97\
    \u3059\u308B\u3002\u7D50\u679C\u306Fint\u3067\u8FD4\u3059\u3002\n        ## \u305F\
    \u3060\u3057\u3001limit\u4EE5\u4E0A\u306B\u306A\u308B\u5834\u5408\u3001limit\u3092\
    \u8FD4\u3059\u3002\n        ## limit = INF64\u306E\u3068\u304D\u3001\u6700\u5927\
    \u306732\u56DE\u307B\u3069\u306E\u6F14\u7B97\u304C\u767A\u751F\u3059\u308B\u3002\
    \n        if limit <= 0:\n            return limit\n        if n < 0 or r < 0\
    \ or n < r:\n            return 0\n\n        let rr = min(r,n-r)\n        let\
    \ limit128 = to_Int128(limit)\n        var res = to_Int128(1)\n        for i in\
    \ 1..rr:\n            res = res*(n-rr+i) div i\n            if res >= limit128:\n\
    \                return limit\n        return res.to_int\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/math/int128.nim
  - cplib/utils/constants.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/math/combination_int.nim
  requiredBy: []
  timestamp: '2026-07-16 13:29:31+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/math/combination_int.nim
layout: document
redirect_from:
- /library/cplib/math/combination_int.nim
- /library/cplib/math/combination_int.nim.html
title: cplib/math/combination_int.nim
---
