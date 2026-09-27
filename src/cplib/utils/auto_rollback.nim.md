---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/auto_rollback.nim
    title: cplib/utils/private/auto_rollback.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/private/temporary_rollback_log.nim
    title: cplib/utils/private/temporary_rollback_log.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_scope_test.nim
    title: verify/AI/auto_rollback_scope_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_scope_test.nim
    title: verify/AI/auto_rollback_scope_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_values_test.nim
    title: verify/AI/auto_rollback_values_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_values_test.nim
    title: verify/AI/auto_rollback_values_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_index_cache_test.nim
    title: verify/AI/temporary_index_cache_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_index_cache_test.nim
    title: verify/AI/temporary_index_cache_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_rollback_log_test.nim
    title: verify/AI/temporary_rollback_log_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/temporary_rollback_log_test.nim
    title: verify/AI/temporary_rollback_log_test.nim
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
  code: "when not declared CPLIB_UTILS_AUTO_ROLLBACK:\n    const CPLIB_UTILS_AUTO_ROLLBACK*\
    \ = 1\n    import macros\n    import cplib/utils/private/auto_rollback\n\n   \
    \ macro withAutoRollback*(update: typed, body: untyped): untyped =\n        ##\
    \ \u30D6\u30ED\u30C3\u30AF\u5185\u3067\u306Fupdate\u3092\u540C\u540D\u306E\u5C65\
    \u6B74\u4ED8\u304D\u95A2\u6570\u3078\u7F6E\u304D\u63DB\u3048\u3001snapshot()\u3068\
    rollback(position)\u3092\u7528\u610F\u3059\u308B\u3002\n        ## snapshot\u306F\
    O(1)\u3001rollback\u306F\u5FA9\u5143\u3059\u308B\u5024\u306E\u5408\u8A08\u30B5\
    \u30A4\u30BA\u306B\u6BD4\u4F8B\u3059\u308B\u6642\u9593\u3002\u7D42\u4E86\u30FB\
    \u4F8B\u5916\u6642\u3082\u958B\u59CB\u524D\u3078\u623B\u3059\u3002\n        ##\
    \ snapshot\u306F\u540C\u3058\u30D6\u30ED\u30C3\u30AF\u5185\u306E\u73FE\u5728\u306E\
    \u5C65\u6B74\u4E0A\u306B\u3042\u308B\u4F4D\u7F6E\u306E\u307F\u4F7F\u7528\u3067\
    \u304D\u3001\u53D6\u308A\u6D88\u3057\u305F\u5148\u306E\u4F4D\u7F6E\u306F\u518D\
    \u5229\u7528\u3057\u306A\u3044\u3053\u3068\u3002\n        ## \u8A18\u9332\u5BFE\
    \u8C61\u306Fupdate\u7D4C\u7531\u306E\u5909\u66F4\u306E\u307F\u3002\u5909\u66F4\
    \u5148\u306F\u30D6\u30ED\u30C3\u30AF\u7D42\u4E86\u307E\u3067\u751F\u5B58\u3057\
    \u3001\u4ED6\u306E\u51E6\u7406\u304B\u3089\u5909\u66F4\u30FB\u89E3\u653E\u3057\
    \u306A\u3044\u3053\u3068\u3002\n        ## \u6570\u5024\u30FB\u305D\u308C\u3089\
    \u306E\u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306E\u66F4\u65B0\
    \u306B\u5BFE\u5FDC\u3059\u308B\u3002seq\u306E\u4F38\u7E2E\u306A\u3069\u672A\u5BFE\
    \u5FDC\u306E\u64CD\u4F5C\u306F\u30B3\u30F3\u30D1\u30A4\u30EB\u30A8\u30E9\u30FC\
    \u3002\n        newCall(bindSym\"withAutoRollbackImpl\", update, body)\n\n   \
    \ macro Temporary*(body: untyped): untyped =\n        ## \u30D6\u30ED\u30C3\u30AF\
    \u5185\u306E\u4EE3\u5165\u3068\u9759\u7684\u306A\u547C\u3073\u51FA\u3057\u5148\
    \u306E\u5909\u66F4\u3092\u8A18\u9332\u3057\u3001\u7D42\u4E86\u30FB\u4F8B\u5916\
    \u6642\u306B\u958B\u59CB\u524D\u3078\u623B\u3059\u3002\n        ## let answer\
    \ = Temporary: ... \u306E\u5F62\u3067\u306F\u3001\u672B\u5C3E\u306E\u5F0F\u306E\
    \u5024\u3092\u4FDD\u5B58\u3057\u3066\u304B\u3089\u72B6\u614B\u3092\u5FA9\u5143\
    \u3059\u308B\u3002\n        ## \u623B\u308A\u5024\u306F\u6570\u5024\u30FB\u305D\
    \u308C\u3089\u306E\u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306B\
    \u9650\u308B\u3002\u51FA\u529B\u306F\u30D6\u30ED\u30C3\u30AF\u5916\u3067\u884C\
    \u3046\u3053\u3068\u3002\n        ## \u5165\u308C\u5B50\u3082\u53EF\u80FD\u3002\
    \u30D6\u30ED\u30C3\u30AF\u5185\u3067\u5BA3\u8A00\u3057\u305F\u4E00\u6642\u5909\
    \u6570\u306F\u305D\u306E\u30D6\u30ED\u30C3\u30AF\u306E\u5C65\u6B74\u5BFE\u8C61\
    \u306B\u542B\u3081\u306A\u3044\u3002\n        ## \u540C\u3058\u30B9\u30B3\u30FC\
    \u30D7\u30FB\u5224\u5B9A\u9818\u57DF\u3067\u306F\u5909\u66F4\u5148\u306E\u6700\
    \u521D\u306E\u5024\u3060\u3051\u4FDD\u5B58\u3059\u308B\u3002\u5165\u308C\u5B50\
    \u306F\u5185\u5074\u306E\u958B\u59CB\u6642\u70B9\u3078\u623B\u3059\u3002\n   \
    \     ## \u5024\u306F\u9023\u7D9A\u30D0\u30C3\u30D5\u30A1\u3078\u4FDD\u5B58\u3057\
    \u3001\u5909\u66F4\u5148\u3054\u3068\u306E\u30AF\u30ED\u30FC\u30B8\u30E3\u78BA\
    \u4FDD\u3092\u884C\u308F\u306A\u3044\u3002\n        ## \u5358\u7D14\u306Aseq\u30FB\
    array\u8981\u7D20\u3078\u306E\u66F8\u304D\u8FBC\u307F\u306F\u6DFB\u5B57\u3067\u91CD\
    \u8907\u5224\u5B9A\u3059\u308B\u3002\u305D\u306E\u4ED6\u306F\u30CF\u30C3\u30B7\
    \u30E5\u8868\u3092\u4F7F\u3046\u3002\n        ## \u5224\u5B9A\u9818\u57DF\u306F\
    \u540C\u3058Temporary\u306E\u547C\u3073\u51FA\u3057\u9593\u3067\u30B9\u30EC\u30C3\
    \u30C9\u3054\u3068\u306B\u518D\u5229\u7528\u3057\u3001\u5FA9\u5143\u6642\u306B\
    \u8A2A\u554F\u3057\u305F\u6DFB\u5B57\u3060\u3051\u3092\u623B\u3059\u3002\n   \
    \     ## \u5404\u5224\u5B9A\u9818\u57DF\u306E\u6700\u5927\u914D\u5217\u9577\u3092\
    N\u3068\u3059\u308B\u3068\u78BA\u4FDD\u30FB\u521D\u671F\u5316\u306F\u5408\u8A08\
    O(N)\u3001\u8FFD\u52A0\u9818\u57DFO(N)\u3002\u6BCE\u56DE\u306E\u5168\u521D\u671F\
    \u5316\u306F\u884C\u308F\u306A\u3044\u3002\n        ## \u914D\u5217\u306E\u6DF7\
    \u5728\u3084\u518D\u5165\u306A\u3069\u3067\u5224\u5B9A\u9818\u57DF\u3092\u5171\
    \u6709\u3067\u304D\u306A\u3044\u5834\u5408\u306F\u30CF\u30C3\u30B7\u30E5\u8868\
    \u3078\u623B\u3059\u3002\n        ## \u6DFB\u5B57\u5224\u5B9A\u3068\u30CF\u30C3\
    \u30B7\u30E5\u5224\u5B9A\u3092\u307E\u305F\u3050\u66F4\u65B0\u3067\u306F\u3001\
    \u540C\u3058\u5834\u6240\u3092\u305D\u308C\u305E\u308C\u306B\u4FDD\u5B58\u3059\
    \u308B\u5834\u5408\u304C\u3042\u308B\u3002\n        ## \u66F8\u304D\u8FBC\u307F\
    \u3054\u3068\u306E\u5224\u5B9A\u306F\u901A\u5E38O(1)\u3001\u30CF\u30C3\u30B7\u30E5\
    \u8868\u3067\u306F\u671F\u5F85O(1)\u3002\u5024\u306E\u4FDD\u5B58\u30FB\u5FA9\u5143\
    \u306F\u521D\u56DE\u306B\u8A18\u9332\u3059\u308B\u5024\u306E\u5408\u8A08\u30B5\
    \u30A4\u30BA\u306B\u6BD4\u4F8B\u3059\u308B\u3002\n        ## \u5909\u66F4\u5148\
    \u306F\u30D6\u30ED\u30C3\u30AF\u7D42\u4E86\u307E\u3067\u751F\u5B58\u3059\u308B\
    \u3053\u3068\u3002\u914D\u5217\u5168\u4F53\u3068\u8981\u7D20\u306E\u3088\u3046\
    \u306B\u7BC4\u56F2\u304C\u91CD\u306A\u308B\u66F8\u304D\u8FBC\u307F\u3082\u5FA9\
    \u5143\u3067\u304D\u308B\u3002\n        ## \u6570\u5024\u30FB\u305D\u308C\u3089\
    \u306E\u30BF\u30D7\u30EB\u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306E\u66F4\u65B0\
    \u306B\u5BFE\u5FDC\u3059\u308B\u3002seq\u306E\u4F38\u7E2E\u306A\u3069\u672A\u5BFE\
    \u5FDC\u306E\u64CD\u4F5C\u306F\u30B3\u30F3\u30D1\u30A4\u30EB\u30A8\u30E9\u30FC\
    \u3002\n        newCall(bindSym\"temporaryImpl\", prepareTemporary(body))\n"
  dependsOn:
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: false
  path: cplib/utils/auto_rollback.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/auto_rollback_scope_test.nim
  - verify/AI/auto_rollback_scope_test.nim
  - verify/AI/temporary_rollback_log_test.nim
  - verify/AI/temporary_rollback_log_test.nim
  - verify/AI/temporary_index_cache_test.nim
  - verify/AI/temporary_index_cache_test.nim
  - verify/AI/auto_rollback_values_test.nim
  - verify/AI/auto_rollback_values_test.nim
documentation_of: cplib/utils/auto_rollback.nim
layout: document
redirect_from:
- /library/cplib/utils/auto_rollback.nim
- /library/cplib/utils/auto_rollback.nim.html
title: cplib/utils/auto_rollback.nim
---
