---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/utils/count_subarrays_with_sum_test_.nim
    title: verify/utils/count_subarrays_with_sum_test_.nim
  - icon: ':warning:'
    path: verify/utils/count_subarrays_with_sum_test_.nim
    title: verify/utils/count_subarrays_with_sum_test_.nim
  - icon: ':warning:'
    path: verify/utils/count_subarrays_with_sum_zero_test_.nim
    title: verify/utils/count_subarrays_with_sum_zero_test_.nim
  - icon: ':warning:'
    path: verify/utils/count_subarrays_with_sum_zero_test_.nim
    title: verify/utils/count_subarrays_with_sum_zero_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/count_subarrays_with_sum_test.nim
    title: verify/AI/count_subarrays_with_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/count_subarrays_with_sum_test.nim
    title: verify/AI/count_subarrays_with_sum_test.nim
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
  code: "when not declared CPLIB_UTILS_COUNT_SUBARRAYS_WITH_SUM:\n    const CPLIB_UTILS_COUNT_SUBARRAYS_WITH_SUM*\
    \ = 1\n    import tables\n\n    proc count_subarrays_with_sum*[T: SomeInteger](a:\
    \ openArray[T], x: T): int64 =\n        ## \u548C\u304Cx\u306B\u306A\u308B\u7A7A\
    \u3067\u306A\u3044\u9023\u7D9A\u90E8\u5206\u5217\u306E\u500B\u6570\u3002\u671F\
    \u5F85\u6642\u9593O(N)\u3001\u8FFD\u52A0\u7A7A\u9593O(N)\u3002\n        ## \u8CA0\
    \u6570\u30FB0\u30FB\u7A7A\u5217\u306B\u5BFE\u5FDC\u3059\u308B\u3002a\u3068x\u306F\
    \u540C\u3058\u7D44\u307F\u8FBC\u307F\u6574\u6570\u578B\u3092\u4F7F\u3046\u3002\
    \n        ## \u7D2F\u7A4D\u548C\u306F\u7B26\u53F7\u4ED8\u304D\u5165\u529B\u306A\
    \u3089int64\u3001\u7B26\u53F7\u306A\u3057\u5165\u529B\u306A\u3089uint64\u3067\u8A08\
    \u7B97\u3059\u308B\u3002\n        ## \u7D2F\u7A4D\u548C\u307E\u305F\u306F\u500B\
    \u6570\u304C\u5404\u578B\u306B\u53CE\u307E\u3089\u306A\u3044\u5834\u5408\u3001\
    release\u3067\u3082OverflowDefect\u3092\u9001\u51FA\u3059\u308B\u3002\n      \
    \  ## prefix-x\u304C\u578B\u306E\u7BC4\u56F2\u5916\u306A\u3089\u4E00\u81F4\u3059\
    \u308B\u904E\u53BB\u306E\u7D2F\u7A4D\u548C\u306F\u306A\u3044\u305F\u3081\u3001\
    \u691C\u7D22\u3092\u7701\u304F\u3002\n        when T is SomeSignedInt:\n     \
    \       type Sum = int64\n        else:\n            type Sum = uint64\n     \
    \   let target = Sum(x)\n        var prefix: Sum = 0\n        var frequency =\
    \ initTable[Sum, int64]()\n        frequency[0] = 1\n        for value in a:\n\
    \            let v = Sum(value)\n            when T is SomeSignedInt:\n      \
    \          if (v > 0 and prefix > high(Sum) - v) or\n                        (v\
    \ < 0 and prefix < low(Sum) - v):\n                    raise newException(OverflowDefect,\
    \ \"\u7D2F\u7A4D\u548C\u304Cint64\u306E\u7BC4\u56F2\u5916\u3067\u3059\")\n   \
    \         else:\n                if prefix > high(Sum) - v:\n                \
    \    raise newException(OverflowDefect, \"\u7D2F\u7A4D\u548C\u304Cuint64\u306E\
    \u7BC4\u56F2\u5916\u3067\u3059\")\n            prefix += v\n            when T\
    \ is SomeSignedInt:\n                let searchable = not ((target > 0 and prefix\
    \ < low(Sum) + target) or\n                    (target < 0 and prefix > high(Sum)\
    \ + target))\n            else:\n                let searchable = prefix >= target\n\
    \            if searchable:\n                let count = frequency.getOrDefault(prefix\
    \ - target)\n                if result > high(int64) - count:\n              \
    \      raise newException(OverflowDefect, \"\u500B\u6570\u304Cint64\u306E\u7BC4\
    \u56F2\u5916\u3067\u3059\")\n                result += count\n            # \u73FE\
    \u5728\u306E\u7D2F\u7A4D\u548C\u306F\u691C\u7D22\u5F8C\u306B\u767B\u9332\u3057\
    \u3001x=0\u3067\u3082\u7A7A\u533A\u9593\u3092\u6570\u3048\u306A\u3044\u3002\n\
    \            let previous = frequency.getOrDefault(prefix)\n            if previous\
    \ == high(int64):\n                raise newException(OverflowDefect, \"\u7D2F\
    \u7A4D\u548C\u306E\u983B\u5EA6\u304Cint64\u306E\u7BC4\u56F2\u5916\u3067\u3059\"\
    )\n            frequency[prefix] = previous + 1\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/count_subarrays_with_sum.nim
  requiredBy:
  - verify/utils/count_subarrays_with_sum_zero_test_.nim
  - verify/utils/count_subarrays_with_sum_zero_test_.nim
  - verify/utils/count_subarrays_with_sum_test_.nim
  - verify/utils/count_subarrays_with_sum_test_.nim
  timestamp: '2026-10-05 11:50:12+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/count_subarrays_with_sum_test.nim
  - verify/AI/count_subarrays_with_sum_test.nim
documentation_of: cplib/utils/count_subarrays_with_sum.nim
layout: document
redirect_from:
- /library/cplib/utils/count_subarrays_with_sum.nim
- /library/cplib/utils/count_subarrays_with_sum.nim.html
title: cplib/utils/count_subarrays_with_sum.nim
---
