---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/fixedlength_merged_static_string.nim
    title: cplib/str/fixedlength_merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/fixedlength_merged_static_string.nim
    title: cplib/str/fixedlength_merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/repeated_static_string_test.nim
    title: verify/AI/repeated_static_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/repeated_static_string_test.nim
    title: verify/AI/repeated_static_string_test.nim
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
  code: "when not declared CPLIB_STR_REPEATED_STATIC_STRING:\n    const CPLIB_STR_REPEATED_STATIC_STRING*\
    \ = 1\n    import cplib/str/static_string\n    import cplib/str/fixedlength_merged_static_string\n\
    \n    type RepeatedStaticString*[T] = object\n        ## `period` \u3092\u7121\
    \u9650\u306B\u7E70\u308A\u8FD4\u3057\u305F\u5217\u306E\u5148\u982D `size` \u8981\
    \u7D20\u3092\u8868\u3059\u3002\n        period*: StaticString[T]\n        size*:\
    \ int\n\n    proc initRepeatedStaticString*[T](S: StaticString[T], k: Natural):\
    \ RepeatedStaticString[T] {.inline.} =\n        ## SSS... \u306E\u5148\u982D k\
    \ \u6587\u5B57\u3092\u69CB\u7BC9\u3059\u308B\u3002\n        assert k == 0 or len(S)\
    \ > 0\n        result.period = S\n        result.size = int(k)\n\n    proc len*[T](S:\
    \ RepeatedStaticString[T]): int {.inline.} =\n        result = S.size\n\n    proc\
    \ `[]`*[T](S: RepeatedStaticString[T], idx: Natural): T {.inline.} =\n       \
    \ assert idx < len(S)\n        result = S.period[idx mod len(S.period)]\n\n  \
    \  proc infiniteLcp[T](S, U: StaticString[T]): int {.inline.} =\n        ## 2\u3064\
    \u306E\u7121\u9650\u5217\u304C\u7570\u306A\u308B\u306A\u3089\u3001\u305D\u306E\
    LCP\u306FST\u3068TS\u306ELCP\u306B\u7B49\u3057\u3044\u3002\n        ## 2\u3064\
    \u306E\u7121\u9650\u5217\u304C\u7B49\u3057\u3044\u5834\u5408\u306F high(int) \u3092\
    \u8FD4\u3059\u3002\n        assert S.base == U.base\n        assert len(S) > 0\
    \ and len(U) > 0\n        result = lcp(S & U, U & S)\n        if result == len(S)+len(U):\n\
    \            result = high(int)\n\n    proc lcp*[T](S, U: RepeatedStaticString[T]):\
    \ int {.inline.} =\n        assert S.period.base == U.period.base\n        result\
    \ = min(len(S), len(U))\n        if result == 0:\n            return\n       \
    \ result = min(result, infiniteLcp(S.period, U.period))\n\n    proc lcp*[T](S:\
    \ RepeatedStaticString[T], U: StaticString[T]): int {.inline.} =\n        assert\
    \ S.period.base == U.base\n        result = min(len(S), len(U))\n        if result\
    \ == 0:\n            return\n        result = min(result, infiniteLcp(S.period,\
    \ U))\n\n    proc lcp*[T](S: StaticString[T], U: RepeatedStaticString[T]): int\
    \ {.inline.} =\n        result = lcp(U, S)\n\n    proc compareFromLcp[A, B](left:\
    \ A, right: B, commonPrefix: int): int {.inline.} =\n        let commonLength\
    \ = min(len(left), len(right))\n        if commonPrefix == commonLength:\n   \
    \         if len(left) == len(right):\n                return 0\n            if\
    \ len(left) < len(right):\n                return -1\n            return 1\n \
    \       if left[commonPrefix] < right[commonPrefix]:\n            return -1\n\
    \        return 1\n\n    proc cmp*[T](S, U: RepeatedStaticString[T]): int {.inline.}\
    \ =\n        result = compareFromLcp(S, U, lcp(S, U))\n\n    proc cmp*[T](S: RepeatedStaticString[T],\
    \ U: StaticString[T]): int {.inline.} =\n        result = compareFromLcp(S, U,\
    \ lcp(S, U))\n\n    proc cmp*[T](S: StaticString[T], U: RepeatedStaticString[T]):\
    \ int {.inline.} =\n        result = compareFromLcp(S, U, lcp(S, U))\n\n    proc\
    \ `<`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) < 0\n  \
    \  proc `>`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) >\
    \ 0\n    proc `<=`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} = cmp(S,\
    \ U) <= 0\n    proc `>=`*[T](S, U: RepeatedStaticString[T]): bool {.inline.} =\
    \ cmp(S, U) >= 0\n    proc `==`*[T](S, U: RepeatedStaticString[T]): bool {.inline.}\
    \ =\n        len(S) == len(U) and lcp(S, U) == len(S)\n\n    proc `<`*[T](S: RepeatedStaticString[T],\
    \ U: StaticString[T]): bool {.inline.} = cmp(S, U) < 0\n    proc `>`*[T](S: RepeatedStaticString[T],\
    \ U: StaticString[T]): bool {.inline.} = cmp(S, U) > 0\n    proc `<=`*[T](S: RepeatedStaticString[T],\
    \ U: StaticString[T]): bool {.inline.} = cmp(S, U) <= 0\n    proc `>=`*[T](S:\
    \ RepeatedStaticString[T], U: StaticString[T]): bool {.inline.} = cmp(S, U) >=\
    \ 0\n    proc `==`*[T](S: RepeatedStaticString[T], U: StaticString[T]): bool {.inline.}\
    \ =\n        len(S) == len(U) and lcp(S, U) == len(S)\n\n    proc `<`*[T](S: StaticString[T],\
    \ U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) < 0\n    proc `>`*[T](S:\
    \ StaticString[T], U: RepeatedStaticString[T]): bool {.inline.} = cmp(S, U) >\
    \ 0\n    proc `<=`*[T](S: StaticString[T], U: RepeatedStaticString[T]): bool {.inline.}\
    \ = cmp(S, U) <= 0\n    proc `>=`*[T](S: StaticString[T], U: RepeatedStaticString[T]):\
    \ bool {.inline.} = cmp(S, U) >= 0\n    proc `==`*[T](S: StaticString[T], U: RepeatedStaticString[T]):\
    \ bool {.inline.} = U == S\n\n    proc `$`*[T](S: RepeatedStaticString[T]): string\
    \ =\n        when T is char:\n            result = newString(len(S))\n       \
    \     for i in 0..<len(S):\n                result[i] = S[i]\n        else:\n\
    \            for i in 0..<len(S):\n                if i > 0:\n               \
    \     result &= \" \"\n                result &= $S[i]\n"
  dependsOn:
  - cplib/str/fixedlength_merged_static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  - cplib/str/fixedlength_merged_static_string.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: false
  path: cplib/str/repeated_static_string.nim
  requiredBy: []
  timestamp: '2026-08-28 03:06:46+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/repeated_static_string_test.nim
  - verify/AI/repeated_static_string_test.nim
documentation_of: cplib/str/repeated_static_string.nim
layout: document
redirect_from:
- /library/cplib/str/repeated_static_string.nim
- /library/cplib/str/repeated_static_string.nim.html
title: cplib/str/repeated_static_string.nim
---
