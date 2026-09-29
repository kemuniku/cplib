---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/parallel_binary_search_test.nim
    title: verify/AI/parallel_binary_search_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/parallel_binary_search_test.nim
    title: verify/AI/parallel_binary_search_test.nim
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
  code: "when not declared CPLIB_UTILS_PARALLEL_BINARY_SEARCH:\n    const CPLIB_UTILS_PARALLEL_BINARY_SEARCH*\
    \ = 1\n\n    proc parallelBinarySearch*(updateCount, queryCount: int,\n      \
    \      reset: proc(), apply: proc(updateIdx: int),\n            check: proc(queryIdx:\
    \ int): bool): seq[int] =\n        ## \u5404\u30AF\u30A8\u30EA\u304C\u6210\u7ACB\
    \u3059\u308B\u6700\u5C0F\u306E\u64CD\u4F5C\u6570\u3092\u8FD4\u3059\u3002\u521D\
    \u671F\u72B6\u614B\u3067\u6210\u7ACB\u306A\u30890\u3001\u4E0D\u6210\u7ACB\u306A\
    \u3089updateCount + 1\u3002\n        ## reset\u306F\u521D\u56DE\u3092\u542B\u3080\
    \u5404\u5DE1\u56DE\u306E\u5148\u982D\u3067\u521D\u671F\u72B6\u614B\u3078\u623B\
    \u3057\u3001apply\u306F0\u59CB\u307E\u308A\u306E\u64CD\u4F5C\u3092\u6DFB\u5B57\
    \u9806\u306B\u9069\u7528\u3059\u308B\u3002\n        ## check\u306B\u306F0\u59CB\
    \u307E\u308A\u306E\u30AF\u30A8\u30EA\u756A\u53F7\u3092\u6E21\u3059\u3002\u6210\
    \u7ACB\u6761\u4EF6\u306F\u64CD\u4F5C\u6570\u306B\u5BFE\u3057\u3066false\u304B\u3089\
    true\u3078\u5358\u8ABF\u3067\u3042\u308B\u3053\u3068\u3002\n        ## check\u306F\
    \u5224\u5B9A\u7D50\u679C\u306B\u5F71\u97FF\u3059\u308B\u72B6\u614B\u3092\u5909\
    \u66F4\u3057\u306A\u3044\u3053\u3068\u3002UnionFind\u306E\u7D4C\u8DEF\u5727\u7E2E\
    \u306A\u3069\u306F\u8A31\u53EF\u3059\u308B\u3002\n        ## \u7D42\u4E86\u6642\
    \u306E\u72B6\u614B\u306F\u5FA9\u5143\u3057\u306A\u3044\u3002\u30AF\u30A8\u30EA\
    \u304C0\u500B\u306A\u3089\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u547C\u3070\
    \u306A\u3044\u3002\n        ## M\u64CD\u4F5C\u3001Q\u30AF\u30A8\u30EA\u306B\u5BFE\
    \u3057\u3001\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u9664\u304D\u6642\u9593\
    O((M + Q) log(M + 2))\u3001\u8FFD\u52A0\u9818\u57DFO(M + Q)\u3002\n        ##\
    \ reset\u306FO(log(M + 2))\u56DE\u3001apply\u306FO(M log(M + 2))\u56DE\u3001check\u306F\
    O(Q log(M + 2))\u56DE\u3002\n        assert 0 <= updateCount and updateCount <\
    \ high(int)\n        assert queryCount >= 0\n        result = newSeq[int](queryCount)\n\
    \        if queryCount == 0: return\n        var lower = newSeq[int](queryCount)\n\
    \        var heads = newSeq[int](updateCount + 1)\n        var next = newSeq[int](queryCount)\n\
    \        for q in 0..<queryCount: result[q] = updateCount + 1\n\n        while\
    \ true:\n            for head in heads.mitems: head = -1\n            var last\
    \ = -1\n            for q in 0..<queryCount:\n                if lower[q] < result[q]:\n\
    \                    let mid = lower[q] + (result[q] - lower[q]) div 2\n     \
    \               next[q] = heads[mid]\n                    heads[mid] = q\n   \
    \                 last = max(last, mid)\n            if last < 0: break\n\n  \
    \          reset()\n            for count in 0..last:\n                if count\
    \ > 0: apply(count - 1)\n                var q = heads[count]\n              \
    \  while q >= 0:\n                    if check(q): result[q] = count\n       \
    \             else: lower[q] = count + 1\n                    q = next[q]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/parallel_binary_search.nim
  requiredBy: []
  timestamp: '2026-09-30 05:21:31+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/parallel_binary_search_test.nim
  - verify/AI/parallel_binary_search_test.nim
documentation_of: cplib/utils/parallel_binary_search.nim
layout: document
redirect_from:
- /library/cplib/utils/parallel_binary_search.nim
- /library/cplib/utils/parallel_binary_search.nim.html
title: cplib/utils/parallel_binary_search.nim
---
