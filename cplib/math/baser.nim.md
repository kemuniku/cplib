---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/baser_test.nim
    title: verify/AI/baser_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/baser_test.nim
    title: verify/AI/baser_test.nim
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
  code: "when not declared(CPLIB_MATH_BASER):\n    const CPLIB_MATH_BASER* = 1\n\n\
    \    proc baser*(num,base:int,size:int = -1):seq[int]=\n        ## K\u9032\u6570\
    \u306B\u5909\u63DB\u3059\u308B\u3002\n        ## size\u3092\u6307\u5B9A\u3057\u306A\
    \u3044\u5834\u5408\u3001\u305D\u306E\u6570\u306E\u6841\u6570\u3068\u306A\u308B\
    \u30020\u306E\u5834\u5408\u306F\u7A7A\u914D\u5217\u3092\u8FD4\u3059\u70B9\u306B\
    \u6CE8\u610F\u3002\n        if size == -1:\n            var num = num\n      \
    \      while num > 0:\n                result.add(num mod base)\n            \
    \    num = num div base\n            return result\n        else:\n          \
    \  var num = num\n            for _ in 0..<size:\n                result.add(num\
    \ mod base)\n                num = num div base\n            return result"
  dependsOn: []
  isVerificationFile: false
  path: cplib/math/baser.nim
  requiredBy: []
  timestamp: '2026-07-05 21:15:28+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/baser_test.nim
  - verify/AI/baser_test.nim
documentation_of: cplib/math/baser.nim
layout: document
redirect_from:
- /library/cplib/math/baser.nim
- /library/cplib/math/baser.nim.html
title: cplib/math/baser.nim
---
