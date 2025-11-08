---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/math/nearear_equiv_abc342e_test_.nim
    title: verify/math/nearear_equiv_abc342e_test_.nim
  - icon: ':warning:'
    path: verify/math/nearear_equiv_abc342e_test_.nim
    title: verify/math/nearear_equiv_abc342e_test_.nim
  - icon: ':warning:'
    path: verify/math/nearest_equiv_test_.nim
    title: verify/math/nearest_equiv_test_.nim
  - icon: ':warning:'
    path: verify/math/nearest_equiv_test_.nim
    title: verify/math/nearest_equiv_test_.nim
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
  code: "when not declared CPLIB_MATH_NEAREST_EQUIV:\n    const CPLIB_MATH_NEAREST_EQUIV*\
    \ = 1\n    proc nearest_equiv*(x, l, m: int): int =\n        ## (y \u2261 x mod\
    \ m) \u304B\u3064 (y \u2267 l) \u3067\u3042\u308B\u3088\u3046\u306A\u6700\u5C0F\
    \u306E\u6574\u6570 y \u3092\u8FD4\u3057\u307E\u3059\u3002\n        var m = abs(m)\n\
    \        if x < l: return x + (l - x + m - 1) div m * m\n        return x - (x\
    \ - l) div m * m\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/nearest_equiv.nim
  requiredBy:
  - verify/math/nearest_equiv_test_.nim
  - verify/math/nearest_equiv_test_.nim
  - verify/math/nearear_equiv_abc342e_test_.nim
  - verify/math/nearear_equiv_abc342e_test_.nim
  timestamp: '2024-03-21 20:57:05+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/math/nearest_equiv.nim
layout: document
redirect_from:
- /library/cplib/math/nearest_equiv.nim
- /library/cplib/math/nearest_equiv.nim.html
title: cplib/math/nearest_equiv.nim
---
