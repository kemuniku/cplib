---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/inner_math.nim
    title: cplib/math/inner_math.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/isprime.nim
    title: cplib/math/isprime.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/powmod.nim
    title: cplib/math/powmod.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/primefactor.nim
    title: cplib/math/primefactor.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/run_length_encode.nim
    title: cplib/str/run_length_encode.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/math/modfast.nim
    title: cplib/math/modfast.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/modfast.nim
    title: cplib/math/modfast.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/primitive_root_test.nim
    title: verify/AI/primitive_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/primitive_root_test.nim
    title: verify/AI/primitive_root_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/modfast_test.nim
    title: verify/math/modfast_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/modfast_test.nim
    title: verify/math/modfast_test.nim
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
  code: "when not declared CPLIB_MATH_PRIMITIVE_ROOT:\n    const CPLIB_MATH_PRIMITIVE_ROOT*\
    \ = 1\n    import cplib/math/isprime\n    import cplib/math/primefactor\n    import\
    \ cplib/math/powmod\n    import random\n    import sequtils\n\n    randomize()\n\
    \    \n    proc primitive_root*(p:int):int=\n        assert p.isprime(), \"\u6CD5\
    p\u306F\u7D20\u6570\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        var pf = (p-1).primefactor().deduplicate(true)\n        while true:\n\
    \            var a = rand(1..<p)\n            var flg = true\n            for\
    \ q in pf:\n                if powmod(a,(p-1) div q,p) == 1:\n               \
    \     flg = false\n                    break\n            if flg:\n          \
    \      return a"
  dependsOn:
  - cplib/math/powmod.nim
  - cplib/math/powmod.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/inner_math.nim
  - cplib/math/inner_math.nim
  - cplib/math/primefactor.nim
  - cplib/str/run_length_encode.nim
  - cplib/math/primefactor.nim
  - cplib/math/isprime.nim
  - cplib/math/isprime.nim
  isVerificationFile: false
  path: cplib/math/primitive_root.nim
  requiredBy:
  - cplib/math/modfast.nim
  - cplib/math/modfast.nim
  timestamp: '2026-09-14 18:23:55+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/math/modfast_test.nim
  - verify/math/modfast_test.nim
  - verify/AI/primitive_root_test.nim
  - verify/AI/primitive_root_test.nim
documentation_of: cplib/math/primitive_root.nim
layout: document
redirect_from:
- /library/cplib/math/primitive_root.nim
- /library/cplib/math/primitive_root.nim.html
title: cplib/math/primitive_root.nim
---
