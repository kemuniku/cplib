---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitcomb_test.nim
    title: verify/utils/bititers_bitcomb_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitcomb_test.nim
    title: verify/utils/bititers_bitcomb_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitsubseteq_descending_test.nim
    title: verify/utils/bititers_bitsubseteq_descending_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitsubseteq_descending_test.nim
    title: verify/utils/bititers_bitsubseteq_descending_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitsubseteq_test.nim
    title: verify/utils/bititers_bitsubseteq_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitsubseteq_test.nim
    title: verify/utils/bititers_bitsubseteq_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitsuperset_test.nim
    title: verify/utils/bititers_bitsuperset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/bititers_bitsuperset_test.nim
    title: verify/utils/bititers_bitsuperset_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_UTILS_BITITERS:\n    const CPLIB_UTILS_BITITERS*\
    \ = 1\n    import bitops\n    iterator bitcomb*(n, r: int): int =\n        ##n\
    \ bit\u4E2D r bit\u304C1\u3067\u3042\u308B\u3088\u3046\u306Abit\u5217\u3092\u5217\
    \u6319\u3057\u307E\u3059\u3002\n        var x = (1 shl r)-1\n        while true:\n\
    \            yield x\n            var t = x or (x-1)\n            x = (t+1) or\
    \ (((not t and - not t) - 1) shr (x.countTrailingZeroBits() + 1))\n          \
    \  if x >= (1 shl n):\n                break\n\n    iterator bitsubseteq*(bits:\
    \ int): int =\n        ##\u4E0E\u3048\u3089\u308C\u305F\u96C6\u5408\u306E\u90E8\
    \u5206\u96C6\u5408\u3092\u6607\u9806\u3067\u5217\u6319\u3057\u307E\u3059\u3002\
    \u4E0E\u3048\u3089\u308C\u305F\u96C6\u5408\u3082\u542B\u307F\u307E\u3059\u3002\
    \n        var i = 0\n        while true:\n            yield i\n            if\
    \ bits == i:\n                break\n            i = (i-bits) and bits\n    iterator\
    \ bitsubset*(bits: int): int =\n        ##\u4E0E\u3048\u3089\u308C\u305F\u96C6\
    \u5408\u306E\u90E8\u5206\u96C6\u5408\u3092\u6607\u9806\u3067\u5217\u6319\u3057\
    \u307E\u3059\u3002\u4E0E\u3048\u3089\u308C\u305F\u96C6\u5408\u306F\u542B\u307F\
    \u307E\u305B\u3093\u3002\n        var i = 0\n        while true:\n           \
    \ yield i\n            i = (i-bits) and bits\n            if bits == i:\n    \
    \            break\n    iterator bitsubseteq_descending*(bits: int): int =\n \
    \       ##\u4E0E\u3048\u3089\u308C\u305F\u96C6\u5408\u306E\u90E8\u5206\u96C6\u5408\
    \u3092\u964D\u9806\u3067\u5217\u6319\u3057\u307E\u3059\u3002\u4E0E\u3048\u3089\
    \u308C\u305F\u96C6\u5408\u3082\u542B\u307F\u307E\u3059\u3002\n        var i =\
    \ bits\n        while true:\n            yield i\n            if i == 0:\n   \
    \             break\n            i = (i-1) and bits\n    iterator bitsubset_descending*(bits:\
    \ int): int =\n        ##\u4E0E\u3048\u3089\u308C\u305F\u96C6\u5408\u306E\u90E8\
    \u5206\u96C6\u5408\u3092\u964D\u9806\u3067\u5217\u6319\u3057\u307E\u3059\u3002\
    \u4E0E\u3048\u3089\u308C\u305F\u96C6\u5408\u306F\u542B\u307F\u307E\u305B\u3093\
    \u3002\n        var i = bits\n        while true:\n            i = (i-1) and bits\n\
    \            yield i\n            if i == 0:\n                break\n\n\n    iterator\
    \ bitsuperseteq*(bits, n: int): int =\n        ## \u4E0E\u3048\u3089\u308C\u305F\
    \u96C6\u5408\u3092\u5305\u542B\u3059\u308B\u96C6\u5408(\u4E0A\u4F4D\u96C6\u5408\
    )\u3092\u5217\u6319\u3057\u307E\u3059\u3002\u4E0E\u3048\u3089\u308C\u305F\u96C6\
    \u5408\u3082\u542B\u307F\u307E\u3059\u3002bit\u6570\u4E0A\u9650\u3092n\u3068\u3057\
    \u307E\u3059\u3002\n        var i = bits\n        while true:\n            yield\
    \ i\n            i = (i+1) or bits\n            if i >= (1 shl n):\n         \
    \       break\n    iterator bitsuperset*(bits, n: int): int =\n        ## \u4E0E\
    \u3048\u3089\u308C\u305F\u96C6\u5408\u3092\u5305\u542B\u3059\u308B\u96C6\u5408\
    (\u4E0A\u4F4D\u96C6\u5408)\u3092\u5217\u6319\u3057\u307E\u3059\u3002\u4E0E\u3048\
    \u3089\u308C\u305F\u96C6\u5408\u306F\u542B\u307F\u307E\u305B\u3093\u3002bit\u6570\
    \u4E0A\u9650\u3092n\u3068\u3057\u307E\u3059\u3002\n        var i = bits\n    \
    \    while true:\n            i = (i+1) or bits\n            if i >= (1 shl n):\n\
    \                break\n            yield i\n\n\n    iterator bitsingleton*(bits:\
    \ int): int =\n        ##\u7ACB\u3063\u3066\u3044\u308Bbit\u3092\u4E00\u3064\u305A\
    \u3064\u53D6\u308A\u51FA\u3057\u307E\u3059\u3002\n        var i = bits and (-bits)\n\
    \        while true:\n            yield i\n            i = i and (not bits + (i\
    \ shl 1))\n            if i == 0:\n                break\n\n    iterator standingbits*(bits:\
    \ int): int =\n        #bits & (1<<i)\u304C0\u3067\u306A\u3044\u5024\u306B\u306A\
    \u308B\u3088\u3046\u306Ai\u3092\u5217\u6319\u3057\u307E\u3059\u3002\n        var\
    \ i = bits and (-bits)\n        if i != 0:\n            while true:\n        \
    \        yield fastLog2(i)\n                i = bits and (not bits + (i shl 1))\n\
    \                if i == 0:\n                    break\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/bititers.nim
  requiredBy: []
  timestamp: '2023-12-13 00:26:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/bititers_bitsuperset_test.nim
  - verify/utils/bititers_bitsuperset_test.nim
  - verify/utils/bititers_bitsubseteq_descending_test.nim
  - verify/utils/bititers_bitsubseteq_descending_test.nim
  - verify/utils/bititers_bitcomb_test.nim
  - verify/utils/bititers_bitcomb_test.nim
  - verify/utils/bititers_bitsubseteq_test.nim
  - verify/utils/bititers_bitsubseteq_test.nim
documentation_of: cplib/utils/bititers.nim
layout: document
redirect_from:
- /library/cplib/utils/bititers.nim
- /library/cplib/utils/bititers.nim.html
title: cplib/utils/bititers.nim
---
