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
    path: verify/AI/rollback_mo_test.nim
    title: verify/AI/rollback_mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/rollback_mo_test.nim
    title: verify/AI/rollback_mo_test.nim
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
  code: "when not declared CPLIB_UTILS_ROLLBACK_MO:\n    const CPLIB_UTILS_ROLLBACK_MO*\
    \ = 1\n    import algorithm, math\n    import cplib/utils/private/auto_rollback\n\
    \n    type RollbackMo* = object\n        n, width: int\n        queries: seq[tuple[left,\
    \ right, idx: int]]\n\n    proc initRollbackMo*(N: int, Q: int = 0, width: int\
    \ = 0): RollbackMo =\n        ## \u9577\u3055N\u306E\u5217\u306B\u5BFE\u3059\u308B\
    Rollback Mo\u3092\u521D\u671F\u5316\u3059\u308B\u3002O(1)\u3002\n        ## \u5E45\
    0\u306A\u3089Q>0\u3067N/sqrt(Q)\u3001Q=0\u3067sqrt(N)\u3092\u76EE\u5B89\u306B\u5E45\
    \u3092\u6C7A\u3081\u308B\u3002Q\u306F\u60F3\u5B9A\u30AF\u30A8\u30EA\u6570\u3002\
    \n        assert N >= 0 and Q >= 0 and width >= 0\n        result.n = N\n    \
    \    let estimated = if Q > 0: float(N) / sqrt(float(Q)) else: sqrt(float(N))\n\
    \        result.width = if width > 0: width else: max(1, int(estimated))\n   \
    \     result.width = min(result.width, max(1, N))\n\n    proc insert*(self: var\
    \ RollbackMo, l, r: int): int {.discardable.} =\n        ## \u534A\u958B\u533A\
    \u9593[l, r)\u3092\u767B\u9332\u3057\u30010\u59CB\u307E\u308A\u306E\u767B\u9332\
    \u756A\u53F7\u3092\u8FD4\u3059\u3002\u7A7A\u533A\u9593\u3082\u8A31\u53EF\u3059\
    \u308B\u3002\u511F\u5374O(1)\u3002\n        assert 0 <= l and l <= r and r <=\
    \ self.n\n        result = self.queries.len\n        self.queries.add((l, r, result))\n\
    \n    proc run*(self: RollbackMo, add: proc(idx: int),\n            rollback:\
    \ proc(), answer: proc(query_idx: int)) =\n        ## \u533A\u9593\u3092\u4E26\
    \u3079\u66FF\u3048\u3066\u51E6\u7406\u3057\u3001\u767B\u9332\u756A\u53F7\u3092\
    answer\u3078\u6E21\u3059\u3002\u7D42\u4E86\u6642\u306F\u5B9F\u884C\u524D\u306E\
    \u72B6\u614B\u306B\u623B\u3059\u3002\n        ## add\u306F\u6307\u5B9A\u4F4D\u7F6E\
    \u306E\u8981\u7D20\u3092\u8FFD\u52A0\u3057\u3001rollback\u306F\u76F4\u524D\u306E\
    add\u30921\u56DE\u53D6\u308A\u6D88\u3059\u3002\u5909\u5316\u304C\u306A\u3044add\u3082\
    \u5BFE\u5FDC\u304C\u5FC5\u8981\u3002\n        ## \u56DE\u7B54\u306F\u8FFD\u52A0\
    \u9806\u306B\u3088\u3089\u306A\u3044\u3053\u3068\u3002answer\u306F\u72B6\u614B\
    \u3092\u5909\u66F4\u305B\u305A\u3001\u7D50\u679C\u3092\u767B\u9332\u756A\u53F7\
    \u3067\u4FDD\u5B58\u3059\u308B\u3053\u3068\u3002\n        ## \u5B9F\u884C\u4E2D\
    \u306B\u767B\u9332\u5185\u5BB9\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\
    \u3002\u767B\u9332\u5185\u5BB9\u306F\u4FDD\u6301\u3057\u3001\u7E70\u308A\u8FD4\
    \u3057\u5B9F\u884C\u3067\u304D\u308B\u3002\n        ## \u5E45B\u3001\u30AF\u30A8\
    \u30EA\u6570Q\u306B\u5BFE\u3057\u3001\u30BD\u30FC\u30C8O(Q log Q)\u3001\u8FFD\u52A0\
    \u30FB\u53D6\u308A\u6D88\u3057\u5404O(N\xB2/B + QB)\u3001\u8FFD\u52A0\u9818\u57DF\
    O(Q)\u3002\n        assert self.width > 0, \"initRollbackMo\u3067\u521D\u671F\u5316\
    \u3057\u3066\u304F\u3060\u3055\u3044\"\n        var queries = newSeq[tuple[left,\
    \ right, idx: int]](self.queries.len)\n        for i, query in self.queries: queries[i]\
    \ = query\n        let width = self.width\n        queries.sort(proc(a, b: tuple[left,\
    \ right, idx: int]): int =\n            result = cmp(a.left div width, b.left\
    \ div width)\n            if result == 0: result = cmp(a.right, b.right)\n   \
    \         if result == 0: result = cmp(a.idx, b.idx)\n        )\n        var currentBlock\
    \ = -1\n        var boundary = 0\n        var right = 0\n        for query in\
    \ queries:\n            let nextBlock = query.left div width\n            if nextBlock\
    \ != currentBlock:\n                while right > boundary:\n                \
    \    rollback()\n                    dec right\n                currentBlock =\
    \ nextBlock\n                boundary = query.left - query.left mod width\n  \
    \              boundary += min(width, self.n - boundary)\n                right\
    \ = boundary\n            if query.right <= boundary:\n                for i in\
    \ query.left..<query.right: add(i)\n                answer(query.idx)\n      \
    \          for i in query.left..<query.right: rollback()\n            else:\n\
    \                while right < query.right:\n                    add(right)\n\
    \                    inc right\n                var left = boundary\n        \
    \        while left > query.left:\n                    dec left\n            \
    \        add(left)\n                answer(query.idx)\n                for i in\
    \ query.left..<boundary: rollback()\n        while right > boundary:\n       \
    \     rollback()\n            dec right\n\n    template runAutoRollback*(self:\
    \ RollbackMo, add: proc(idx: int),\n            answer: proc(query_idx: int))\
    \ =\n        ## add\u3068\u9759\u7684\u306A\u547C\u3073\u51FA\u3057\u5148\u3092\
    \u5909\u63DB\u3057\u3001rollback\u3092\u81EA\u52D5\u751F\u6210\u3057\u3066\u533A\
    \u9593\u3092\u51E6\u7406\u3059\u308B\u3002\n        ## \u901A\u5E38\u306E\u578B\
    \u3078\u306E\u6570\u5024\u306A\u3069\u306E\u66F8\u304D\u8FBC\u307F\u306B\u5BFE\
    \u5FDC\u3002seq\u306E\u4F38\u7E2E\u30FB\u53C2\u7167\u306E\u5909\u66F4\u30FB\u52D5\
    \u7684\u547C\u3073\u51FA\u3057\u306A\u3069\u306F\u672A\u5BFE\u5FDC\u3002\n   \
    \     ## \u5024\u6E21\u3057\u306E\u8907\u5408\u578B\u306F\u8AAD\u307F\u53D6\u308A\
    \u5C02\u7528\u3002\u30ED\u30FC\u30AB\u30EB\u5909\u6570\u3068\u623B\u308A\u5024\
    \u306F\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\u30BF\u30D7\u30EB\u30FB\u56FA\
    \u5B9A\u9577\u914D\u5217\u306B\u9650\u5B9A\u3059\u308B\u3002\n        ## answer\u306F\
    \u72B6\u614B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\uFF08\u7D4C\u8DEF\
    \u5727\u7E2E\u3082\u4E0D\u53EF\uFF09\u3002\u7D50\u679C\u306F\u767B\u9332\u756A\
    \u53F7\u3067\u4FDD\u5B58\u3059\u308B\u3053\u3068\u3002\n        ## \u672A\u5BFE\
    \u5FDC\u306E\u51E6\u7406\u306F\u30B3\u30F3\u30D1\u30A4\u30EB\u30A8\u30E9\u30FC\
    \u3002\u4F8B\u5916\u6642\u3082\u5B9F\u884C\u524D\u306E\u72B6\u614B\u3078\u623B\
    \u3059\u3002\n        ## run\u306E\u8A08\u7B97\u91CF\u306B\u3001\u8A18\u9332\u30FB\
    \u5FA9\u5143\u3059\u308B\u5024\u306E\u5408\u8A08\u30B5\u30A4\u30BA\u306B\u6BD4\
    \u4F8B\u3059\u308B\u6642\u9593\u30FB\u9818\u57DF\u304C\u52A0\u308F\u308B\u3002\
    \n        runAutoRollbackImpl(self, add, answer, run)\n"
  dependsOn:
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: false
  path: cplib/utils/rollback_mo.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/rollback_mo_test.nim
  - verify/AI/rollback_mo_test.nim
documentation_of: cplib/utils/rollback_mo.nim
layout: document
redirect_from:
- /library/cplib/utils/rollback_mo.nim
- /library/cplib/utils/rollback_mo.nim.html
title: cplib/utils/rollback_mo.nim
---
