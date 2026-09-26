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
    path: verify/AI/auto_rollback_test.nim
    title: verify/AI/auto_rollback_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/auto_rollback_test.nim
    title: verify/AI/auto_rollback_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/offline_dynamic_queries_test.nim
    title: verify/AI/offline_dynamic_queries_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/offline_dynamic_queries_test.nim
    title: verify/AI/offline_dynamic_queries_test.nim
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
  code: "when not declared CPLIB_UTILS_OFFLINE_DYNAMIC_QUERIES:\n    const CPLIB_UTILS_OFFLINE_DYNAMIC_QUERIES*\
    \ = 1\n    import tables\n\n    type OfflineDynamicQueries*[T = void] = object\n\
    \        active: Table[int, int]\n        intervals: seq[tuple[left, right, idx:\
    \ int]]\n        outputs: seq[int]\n        when T isnot void:\n            values:\
    \ seq[T]\n            indices: seq[int]\n\n    proc initOfflineDynamicQueries*(T:\
    \ typedesc): OfflineDynamicQueries[T] =\n        ## \u64CD\u4F5C\u306E\u8FFD\u52A0\
    \u30FB\u53D6\u308A\u6D88\u3057\u30FB\u51FA\u529B\u3092\u30AA\u30D5\u30E9\u30A4\
    \u30F3\u3067\u51E6\u7406\u3059\u308B\u578B\u3092\u521D\u671F\u5316\u3059\u308B\
    \u3002O(1)\u3002\n        result.active = initTable[int, int]()\n\n    proc initOfflineDynamicQueries*():\
    \ OfflineDynamicQueries[void] =\n        ## \u8FFD\u52A0\u60C5\u5831\u3092\u6301\
    \u305F\u306A\u3044\u578B\u3092\u521D\u671F\u5316\u3059\u308B\u3002O(1)\u3002\n\
    \        initOfflineDynamicQueries(void)\n\n    proc add*(self: var OfflineDynamicQueries[void],\
    \ idx: int) =\n        ## \u64CD\u4F5Cidx\u3092\u6709\u52B9\u306B\u3059\u308B\u3002\
    \u6709\u52B9\u306A\u756A\u53F7\u306E\u91CD\u8907\u8FFD\u52A0\u306F\u7981\u6B62\
    \u3001\u53D6\u308A\u6D88\u3057\u5F8C\u306E\u518D\u8FFD\u52A0\u306F\u53EF\u80FD\
    \u3002\u671F\u5F85O(1)\u3002\n        assert not self.active.hasKey(idx), \"\u65E2\
    \u306B\u6709\u52B9\u306A\u64CD\u4F5C\u3067\u3059\"\n        self.active[idx] =\
    \ self.outputs.len\n\n    proc add*[T](self: var OfflineDynamicQueries[T], idx:\
    \ int, value: T) =\n        ## \u64CD\u4F5Cidx\u3068\u60C5\u5831value\u3092\u767B\
    \u9332\u3059\u308B\u3002\u53D6\u308A\u6D88\u3057\u5F8C\u306F\u5225\u306E\u5024\
    \u3067\u518D\u8FFD\u52A0\u53EF\u80FD\u3002\u671F\u5F85\u30FB\u511F\u5374O(1)\u3002\
    \n        assert not self.active.hasKey(idx), \"\u65E2\u306B\u6709\u52B9\u306A\
    \u64CD\u4F5C\u3067\u3059\"\n        self.active[idx] = self.values.len\n     \
    \   self.values.add(value)\n        self.indices.add(idx)\n        self.intervals.add((self.outputs.len,\
    \ -1, self.values.len - 1))\n\n    proc remove*[T](self: var OfflineDynamicQueries[T],\
    \ idx: int) =\n        ## \u6709\u52B9\u306A\u64CD\u4F5Cidx\u3092\u53D6\u308A\u6D88\
    \u3059\u3002\u671F\u5F85\u30FB\u511F\u5374O(1)\u3002\n        assert self.active.hasKey(idx),\
    \ \"\u6709\u52B9\u3067\u306A\u3044\u64CD\u4F5C\u306F\u53D6\u308A\u6D88\u305B\u307E\
    \u305B\u3093\"\n        when T is void:\n            let left = self.active[idx]\n\
    \            if left < self.outputs.len:\n                self.intervals.add((left,\
    \ self.outputs.len, idx))\n        else:\n            self.intervals[self.active[idx]].right\
    \ = self.outputs.len\n        self.active.del(idx)\n\n    proc output*[T](self:\
    \ var OfflineDynamicQueries[T], query_idx: int) =\n        ## \u73FE\u5728\u306E\
    \u72B6\u614B\u306E\u51FA\u529B\u3092\u767B\u9332\u3057\u3001\u5B9F\u884C\u6642\
    \u306Bquery_idx\u3092answer\u3078\u6E21\u3059\u3002\u511F\u5374O(1)\u3002\n  \
    \      self.outputs.add(query_idx)\n\n    proc runImpl[T, F](self: OfflineDynamicQueries[T],\
    \ apply: F,\n            rollback: proc(), answer: proc(query_idx: int)) =\n \
    \       ## \u6709\u52B9\u306A\u64CD\u4F5C\u3092\u9069\u7528\u3057\u3066\u767B\u9332\
    \u9806\u306Banswer\u3092\u547C\u3073\u3001\u7D42\u4E86\u6642\u306B\u5B9F\u884C\
    \u524D\u306E\u72B6\u614B\u3078\u623B\u3059\u3002\n        ## \u9069\u7528\u9806\
    \u306F\u767B\u9332\u9806\u3068\u306F\u9650\u3089\u306A\u3044\u305F\u3081\u3001\
    \u51FA\u529B\u304C\u64CD\u4F5C\u306E\u9069\u7528\u9806\u306B\u3088\u3089\u306A\
    \u3044\u3053\u3068\u304C\u5FC5\u8981\u3002\n        ## apply 1\u56DE\u306B\u3064\
    \u304Drollback 1\u56DE\u3067\u623B\u3059\u3053\u3068\u3002\u72B6\u614B\u304C\u5909\
    \u5316\u3057\u306A\u3044apply\u306B\u3082\u5BFE\u5FDC\u304C\u5FC5\u8981\u3002\n\
    \        ## answer\u306F\u72B6\u614B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\
    \u3068\u3002\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u304B\u3089\u767B\u9332\u5185\
    \u5BB9\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\u3002\n        ## \u8FFD\
    \u52A0\u56DE\u6570A\u3001\u51FA\u529B\u56DE\u6570Q\u306B\u5BFE\u3057\u3001\u30B3\
    \u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u9664\u304D\u6642\u9593\u30FB\u9818\u57DF\
    O(A log(Q+1) + Q)\u3002\n        ## apply\u30FBrollback\u306F\u5404O(A log(Q+1))\u56DE\
    \u3001answer\u306FQ\u56DE\u3002\u767B\u9332\u5185\u5BB9\u306F\u4FDD\u6301\u3059\
    \u308B\u3002\n        let q = self.outputs.len\n        if q == 0: return\n  \
    \      var size = 1\n        while size < q: size *= 2\n        var nodes = newSeq[seq[int]](size\
    \ * 2)\n\n        proc insert(left, right, idx: int) =\n            ## \u534A\u958B\
    \u533A\u9593[left, right)\u306B\u64CD\u4F5Cidx\u3092\u767B\u9332\u3059\u308B\u3002\
    O(log Q)\u3002\n            var l = left + size\n            var r = right + size\n\
    \            while l < r:\n                if (l and 1) != 0:\n              \
    \      nodes[l].add(idx)\n                    inc l\n                if (r and\
    \ 1) != 0:\n                    dec r\n                    nodes[r].add(idx)\n\
    \                l = l shr 1\n                r = r shr 1\n\n        for interval\
    \ in self.intervals:\n            let right = if interval.right < 0: q else: interval.right\n\
    \            insert(interval.left, right, interval.idx)\n        when T is void:\n\
    \            for idx, left in self.active.pairs:\n                insert(left,\
    \ q, idx)\n\n        proc visit(node, left, right: int) =\n            ## \u533A\
    \u9593\u6728\u3092\u6DF1\u3055\u512A\u5148\u3067\u8D70\u67FB\u3057\u3001\u9069\
    \u7528\u3057\u305F\u64CD\u4F5C\u3092\u9006\u9806\u306B\u53D6\u308A\u6D88\u3059\
    \u3002\n            if left >= q: return\n            for idx in nodes[node]:\n\
    \                when T is void: apply(idx)\n                else: apply(self.indices[idx],\
    \ self.values[idx])\n            if right - left == 1:\n                answer(self.outputs[left])\n\
    \            else:\n                let mid = (left + right) div 2\n         \
    \       visit(node * 2, left, mid)\n                visit(node * 2 + 1, mid, right)\n\
    \            for i in 0..<nodes[node].len: rollback()\n\n        visit(1, 0, size)\n\
    \n    proc run*[T](self: OfflineDynamicQueries[T], apply: proc(idx: int, value:\
    \ T),\n            rollback: proc(), answer: proc(query_idx: int)) =\n       \
    \ ## \u5404\u8FFD\u52A0\u6642\u306E\u756A\u53F7\u3068\u60C5\u5831\u3092apply\u3078\
    \u6E21\u3057\u3066\u5B9F\u884C\u3059\u308B\u3002\u9069\u7528\u9806\u306B\u3088\
    \u3089\u305A\u56DE\u7B54\u304C\u6C7A\u307E\u308B\u3053\u3068\u304C\u5FC5\u8981\
    \u3002\n        ## apply\u3054\u3068\u306Brollback\u30921\u56DE\u547C\u3073\u3001\
    \u7D42\u4E86\u6642\u306B\u5143\u306E\u72B6\u614B\u3078\u623B\u3059\u3002answer\u306F\
    \u767B\u9332\u9806\u3067\u72B6\u614B\u3092\u53C2\u7167\u3059\u308B\u3002\n   \
    \     ## \u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u306B\u3088\u308B\u767B\u9332\u5909\
    \u66F4\u306F\u7981\u6B62\u3002\u8FFD\u52A0A\u56DE\u3001\u51FA\u529BQ\u56DE\u3067\
    \u6642\u9593\u30FB\u9818\u57DFO(A log(Q+1) + Q)\u3002\n        ## \u8A08\u7B97\
    \u91CF\u306F\u60C5\u5831\u306E\u4FDD\u6301\u30FB\u53D7\u3051\u6E21\u3057\u3068\
    \u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u306E\u30B3\u30B9\u30C8\u3092\u9664\u304F\
    \u3002\u767B\u9332\u5185\u5BB9\u306F\u4FDD\u6301\u3059\u308B\u3002\n        self.runImpl(apply,\
    \ rollback, answer)\n\n    proc run*(self: OfflineDynamicQueries[void], apply:\
    \ proc(idx: int),\n            rollback: proc(), answer: proc(query_idx: int))\
    \ =\n        ## \u8FFD\u52A0\u60C5\u5831\u306A\u3057\u3067\u5B9F\u884C\u3059\u308B\
    \u3002\u578B\u4ED8\u304Drun\u3068\u540C\u3058\u6761\u4EF6\u30FB\u8A08\u7B97\u91CF\
    \u3067\u3001apply\u306B\u306F\u756A\u53F7\u306E\u307F\u6E21\u3059\u3002\n    \
    \    self.runImpl(apply, rollback, answer)\n\n    # runAutoRollback(apply, answer)\u306F\
    \u901A\u5E38\u306E\u578B\u30FB\u95A2\u6570\u304B\u3089\u5FA9\u5143\u51E6\u7406\
    \u3092\u81EA\u52D5\u751F\u6210\u3059\u308B\u8A66\u9A13\u7684\u306AAPI\u3002\n\
    \    # apply\u306E\u9759\u7684\u306A\u547C\u3073\u51FA\u3057\u5148\u3082\u5909\
    \u63DB\u3059\u308B\u3002\u6570\u5024\u306A\u3069\u306E\u5024\u306E\u4EE3\u5165\
    \u30FBinc\u30FBdec\u30FBswap\u306B\u5BFE\u5FDC\u3059\u308B\u3002\n    # seq\u306E\
    \u4F38\u7E2E\u3001\u53C2\u7167\u306E\u5DEE\u3057\u66FF\u3048\u3001\u52D5\u7684\
    \u547C\u3073\u51FA\u3057\u306A\u3069\u3001\u672A\u5BFE\u5FDC\u306E\u51E6\u7406\
    \u306F\u30B3\u30F3\u30D1\u30A4\u30EB\u30A8\u30E9\u30FC\u306B\u306A\u308B\u3002\
    \n    # answer\u306F\u72B6\u614B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\u3068\
    \u3002UnionFind\u306E\u7D4C\u8DEF\u5727\u7E2E\u3092\u4F34\u3046\u53C2\u7167\u64CD\
    \u4F5C\u306B\u3082\u6CE8\u610F\u3059\u308B\u3053\u3068\u3002\n    import cplib/utils/private/auto_rollback\n\
    \n    proc runAutoRollbackTyped[T](solver: OfflineDynamicQueries[T],\n       \
    \     apply: proc(idx: int, value: T), rollback: proc(), answer: proc(query_idx:\
    \ int)) =\n        ## \u81EA\u52D5\u751F\u6210\u3057\u305F\u30B3\u30FC\u30EB\u30D0\
    \u30C3\u30AF\u306E\u578B\u3092\u78BA\u5B9A\u3057\u3066\u304B\u3089\u901A\u5E38\
    \u306E\u5B9F\u884C\u51E6\u7406\u3078\u6E21\u3059\u3002\n        solver.run(apply,\
    \ rollback, answer)\n\n    proc runAutoRollbackWithoutValue(solver: OfflineDynamicQueries[void],\n\
    \            apply: proc(idx: int), rollback: proc(), answer: proc(query_idx:\
    \ int)) =\n        ## \u8FFD\u52A0\u60C5\u5831\u306A\u3057\u306E\u30B3\u30FC\u30EB\
    \u30D0\u30C3\u30AF\u306E\u578B\u3092\u78BA\u5B9A\u3057\u3066\u304B\u3089\u901A\
    \u5E38\u306E\u5B9F\u884C\u51E6\u7406\u3078\u6E21\u3059\u3002\n        solver.run(apply,\
    \ rollback, answer)\n\n    template runAutoRollback*[T](solver: OfflineDynamicQueries[T],\n\
    \            apply: proc(idx: int, value: T), answer: proc(query_idx: int)) =\n\
    \        ## \u901A\u5E38\u306E\u578B\u3068\u95A2\u6570\u3092\u4F7F\u3063\u3066\
    \u81EA\u52D5\u3067rollback\u3059\u308B\u8A66\u9A13\u7684\u306AAPI\u3002apply\u3068\
    \u9759\u7684\u306A\u547C\u3073\u51FA\u3057\u5148\u3092\u5909\u63DB\u3059\u308B\
    \u3002\n        ## \u5BFE\u8C61\u306F\u6570\u5024\u306A\u3069\u306E\u5024\u306E\
    \u66F8\u304D\u8FBC\u307F\u3002seq\u306E\u4F38\u7E2E\u30FB\u53C2\u7167\u5909\u66F4\
    \u30FB\u52D5\u7684\u547C\u3073\u51FA\u3057\u306A\u3069\u306F\u30B3\u30F3\u30D1\
    \u30A4\u30EB\u30A8\u30E9\u30FC\u3002\n        ## seq\u306A\u3069\u3092\u542B\u3080\
    object\u30FBtuple\u30FBarray\u306E\u5024\u6E21\u3057\u306F\u3001\u53C2\u7167\u5148\
    \u307E\u3067\u8AAD\u307F\u53D6\u308A\u5C02\u7528\u3068\u3057\u3066\u8A31\u53EF\
    \u3059\u308B\u3002\n        ## \u30ED\u30FC\u30AB\u30EB\u5909\u6570\u3068\u623B\
    \u308A\u5024\u306F\u6570\u5024\u30FB\u305D\u308C\u3089\u306E\u30BF\u30D7\u30EB\
    \u30FB\u56FA\u5B9A\u9577\u914D\u5217\u306B\u9650\u5B9A\u3059\u308B\u3002\u3053\
    \u308C\u3089\u306Evar\u5F15\u6570\u6E21\u3057\u306B\u3082\u5BFE\u5FDC\u3002\n\
    \        ## answer\u306F\u72B6\u614B\u3092\u5909\u66F4\u3057\u306A\u3044\u3053\
    \u3068\uFF08\u7D4C\u8DEF\u5727\u7E2E\u3082\u4E0D\u53EF\uFF09\u3002\u9069\u7528\
    \u9806\u306B\u3088\u3089\u305A\u56DE\u7B54\u304C\u6C7A\u307E\u308B\u3053\u3068\
    \u3002\n        ## \u8A18\u9332\u30FB\u5FA9\u5143\u306E\u6642\u9593\u3068\u9818\
    \u57DF\u306F\u4FDD\u5B58\u3059\u308B\u5024\u306E\u5408\u8A08\u30B5\u30A4\u30BA\
    \u306B\u6BD4\u4F8B\u3059\u308B\u3002\u4F8B\u5916\u6642\u3082\u5B9F\u884C\u524D\
    \u306E\u72B6\u614B\u3078\u623B\u3059\u3002\n        runAutoRollbackImpl(solver,\
    \ apply, answer, runAutoRollbackTyped)\n\n    template runAutoRollback*(solver:\
    \ OfflineDynamicQueries[void],\n            apply: proc(idx: int), answer: proc(query_idx:\
    \ int)) =\n        ## \u8FFD\u52A0\u60C5\u5831\u306A\u3057\u3067\u81EA\u52D5rollback\u3059\
    \u308B\u3002\u578B\u4ED8\u304DrunAutoRollback\u3068\u540C\u3058\u6761\u4EF6\u30FB\
    \u8A08\u7B97\u91CF\u3002\n        runAutoRollbackImpl(solver, apply, answer, runAutoRollbackWithoutValue)\n"
  dependsOn:
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  - cplib/utils/private/auto_rollback.nim
  - cplib/utils/private/temporary_rollback_log.nim
  isVerificationFile: false
  path: cplib/utils/offline_dynamic_queries.nim
  requiredBy: []
  timestamp: '2026-09-23 01:31:00+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/offline_dynamic_queries_test.nim
  - verify/AI/offline_dynamic_queries_test.nim
  - verify/AI/rollback_mo_test.nim
  - verify/AI/rollback_mo_test.nim
  - verify/AI/auto_rollback_test.nim
  - verify/AI/auto_rollback_test.nim
documentation_of: cplib/utils/offline_dynamic_queries.nim
layout: document
redirect_from:
- /library/cplib/utils/offline_dynamic_queries.nim
- /library/cplib/utils/offline_dynamic_queries.nim.html
title: cplib/utils/offline_dynamic_queries.nim
---
