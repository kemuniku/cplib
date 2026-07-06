---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/mex_naive_test.nim
    title: verify/AI/mex_naive_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/mex_naive_test.nim
    title: verify/AI/mex_naive_test.nim
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
  code: "when not declared CPLIB_MATH_MEX_NAIVE:\n    const CPLIB_MATH_MEX_NAIVE*\
    \ = 1\n    import sequtils\n    proc mex_naive*(X:openArray[int]):int=\n     \
    \   var tmp = newseqwith(len(X),false)\n        for x in X:\n            if x\
    \ in 0..<len(X):\n                tmp[x] = true\n        \n        for i in 0..<len(X):\n\
    \            if not tmp[i]:\n                return i\n        \n        return\
    \ len(X)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/mex_naive.nim
  requiredBy: []
  timestamp: '2026-07-06 04:42:52+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/mex_naive_test.nim
  - verify/AI/mex_naive_test.nim
documentation_of: cplib/math/mex_naive.nim
layout: document
redirect_from:
- /library/cplib/math/mex_naive.nim
- /library/cplib/math/mex_naive.nim.html
title: cplib/math/mex_naive.nim
---
