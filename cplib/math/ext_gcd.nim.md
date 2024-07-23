---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/math/ext_gcd_aoj_test.nim
    title: verify/math/ext_gcd_aoj_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/ext_gcd_aoj_test.nim
    title: verify/math/ext_gcd_aoj_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATH_EXT_GCD:\n    const CPLIB_MATH_EXT_GCD* = 1\n\
    \    import algorithm\n    proc ext_gcd*(a, b: int): (int, int) =\n        ##\
    \ a*x + b*y = gcd(a, b) \u3068\u306A\u308B (x, y) \u3092\u3072\u3068\u3064\u8FD4\
    \u3059\u3002\n        ## \u8FD4\u3059\u5024\u306F\u305D\u306E\u3088\u3046\u306A\
    (x, y) \u306E\u3046\u3061 |x| + |y| \u304C\u6700\u5C0F\u3068\u306A\u308B\u3082\
    \u306E\n        var invert_a = a < 0\n        var invert_b = b < 0\n        var\
    \ a = abs(a)\n        var b = abs(b)\n        var swap_ab = a < b\n        if\
    \ swap_ab: swap(a, b)\n        var line = @[(a, b)]\n        while a > 0 and b\
    \ > 0:\n            if line.len mod 2 == 1: a = a mod b\n            else: b =\
    \ b mod a\n            line.add((a, b))\n        var x = line.len and 1\n    \
    \    var y = 1 xor (line.len and 1)\n        for (a, b) in line[0..^2].reversed:\n\
    \            if a < b: x -= (b div a) * y\n            else: y -= (a div b) *\
    \ x\n        if swap_ab: swap(x, y)\n        if invert_a: x = -x\n        if invert_b:\
    \ y = -y\n        return (x, y)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/ext_gcd.nim
  requiredBy: []
  timestamp: '2024-07-21 21:50:59+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/ext_gcd_aoj_test.nim
  - verify/math/ext_gcd_aoj_test.nim
documentation_of: cplib/math/ext_gcd.nim
layout: document
redirect_from:
- /library/cplib/math/ext_gcd.nim
- /library/cplib/math/ext_gcd.nim.html
title: cplib/math/ext_gcd.nim
---
