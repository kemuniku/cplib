---
data:
  _extendedDependsOn: []
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
  code: "when not declared(CPLIB_MATH_BASER):\n  const CPLIB_MATH_BASER* = 1\n\n \
    \ proc baser*(num,base,size:int):seq[int]=\n      var num = num\n      for _ in\
    \ 0..<size:\n          result.add(num mod base)\n          num = num div base\n\
    \      return result"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/baser.nim
  requiredBy: []
  timestamp: '2026-03-23 02:52:45+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/math/baser.nim
layout: document
redirect_from:
- /library/cplib/math/baser.nim
- /library/cplib/math/baser.nim.html
title: cplib/math/baser.nim
---
