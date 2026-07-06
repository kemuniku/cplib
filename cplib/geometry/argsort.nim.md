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
    path: verify/AI/argsort_test.nim
    title: verify/AI/argsort_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/argsort_test.nim
    title: verify/AI/argsort_test.nim
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
  code: "when not declared CPLIB_GEOMETRY_ARGSORT:\n    const CPLIB_GEOMETRY_ARGSORT*\
    \ = 1\n    import algorithm\n    import cplib/math/int128\n    proc argcmp*(L,R:(int,int)):int=\n\
    \        # < : -\n        # = : 0\n        # > : +\n        var a = L[1] > 0 or\
    \ (L[1] == 0 and L[0] > 0)\n        var b = R[1] > 0 or (R[1] == 0 and R[0] >\
    \ 0)\n        if a != b:\n            return cmp(b,a)\n        else:\n       \
    \     return cmp(to_Int128(L[1])*R[0],to_Int128(L[0])*R[1])\n\n    proc argsorted*(X:seq[(int,int)]):seq[(int,int)]=\n\
    \        ## \u504F\u89D2\u30BD\u30FC\u30C8\n        ## 0\xB0 opened\n        return\
    \ sorted(X,argcmp)\n\n    proc argsort*(X:var seq[(int,int)])=\n        X.sort(argcmp)\n"
  dependsOn:
  - cplib/math/int128.nim
  - cplib/math/int128.nim
  isVerificationFile: false
  path: cplib/geometry/argsort.nim
  requiredBy: []
  timestamp: '2026-07-07 06:48:43+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/argsort_test.nim
  - verify/AI/argsort_test.nim
documentation_of: cplib/geometry/argsort.nim
layout: document
redirect_from:
- /library/cplib/geometry/argsort.nim
- /library/cplib/geometry/argsort.nim.html
title: cplib/geometry/argsort.nim
---
