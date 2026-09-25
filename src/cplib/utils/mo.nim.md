---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_prefix_sum.nim
    title: cplib/math/combination_prefix_sum.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/combination_prefix_sum.nim
    title: cplib/math/combination_prefix_sum.nim
  - icon: ':warning:'
    path: verify/utils/mo_test_.nim
    title: verify/utils/mo_test_.nim
  - icon: ':warning:'
    path: verify/utils/mo_test_.nim
    title: verify/utils/mo_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/mo_test.nim
    title: verify/AI/mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/mo_test.nim
    title: verify/AI/mo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_kth_smallest_test.nim
    title: verify/collections/range_kth_smallest_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_prefix_sum_test.nim
    title: verify/math/combination_prefix_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/math/combination_prefix_sum_test.nim
    title: verify/math/combination_prefix_sum_test.nim
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
  code: "when not declared CPLIB_UTILS_MO:\n    const CPLIB_UTILS_MO* = 1\n    import\
    \ math, algorithm\n    type Mo* = object\n        width*: int\n        N, Q: int\n\
    \        qli: seq[seq[int]]\n        size: int\n\n    proc initMo*(N, Q: int,\
    \ width = max(1, int(1.0 * float(N) / max(1.0, sqrt(float(Q) * 2.0 / 3.0))))):\
    \ Mo =\n        ## \u9577\u3055N\u3001\u30AF\u30A8\u30EA\u6570Q\u3092\u60F3\u5B9A\
    \u3057\u3066\u521D\u671F\u5316\u3059\u308B\u3002O(N / width)\u3002\n        result.width\
    \ = width\n        result.N = N\n        result.Q = Q\n        let qlisize = N\
    \ div width + 1\n        result.qli = newSeq[seq[int]](qlisize)\n\n    proc insert*(self:\
    \ var Mo, l, r: int) =\n        ## \u5EA7\u6A19(l, r)\u3092\u767B\u9332\u3059\u308B\
    \u3002l > r\u3084\u8CA0\u306Er\u3082\u8A31\u5BB9\u3059\u308B\u3002\u511F\u5374\
    O(1)\u3002\n        ## l\u3068\u30AF\u30A8\u30EA\u756A\u53F7\u306F\u975E\u8CA0\
    20bit\u3001r\u306F\u7B26\u53F7\u4ED8\u304D24bit\u3067\u683C\u7D0D\u3059\u308B\u3002\
    \n        assert 0 <= l and l <= self.N and l < (1 shl 20)\n        assert -(1\
    \ shl 23) <= r and r < (1 shl 23) and r <= self.N\n        assert self.size <\
    \ (1 shl 20)\n        self.qli[l div self.width].add((r shl 40) or ((l) shl 20)\
    \ or self.size)\n        self.size += 1\n\n    template run*(self: var Mo, add_left,\
    \ add_right, delete_left, delete_right, remember: untyped) =\n        ## \u767B\
    \u9332\u3057\u305F\u533A\u9593\u3092\u51E6\u7406\u3059\u308B\u3002\u30BD\u30FC\
    \u30C8O(Q log Q)\u3001\u7AEF\u70B9\u79FB\u52D5O(N\xB2 / width + Q * width)\u3002\
    \n        block:\n            {.push checks: off.}\n            # \u30ED\u30FC\
    \u30AB\u30EB\u306B\u4FDD\u6301\u3057\u305F\u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\
    \u3092\u547C\u3073\u51FA\u3057\u5074\u3067\u6700\u9069\u5316\u3067\u304D\u308B\
    \u3088\u3046\u306B\u3059\u308B\u3002\n            proc executeMo(solver: var Mo)\
    \ =\n                ## \u30B3\u30FC\u30EB\u30D0\u30C3\u30AF\u3092\u4E00\u5EA6\
    \u305A\u3064\u8A55\u4FA1\u3057\u3001\u767B\u9332\u9806\u306E\u756A\u53F7\u3067\
    \u7D50\u679C\u3092\u901A\u77E5\u3059\u308B\u3002\n                let callbackAddLeft\
    \ = add_left\n                let callbackAddRight = add_right\n             \
    \   let callbackDeleteLeft = delete_left\n                let callbackDeleteRight\
    \ = delete_right\n                let callbackRemember = remember\n          \
    \      var nl = 0\n                var nr = 0\n                const mask2 = ((1\
    \ shl 20)-1) shl 20\n                const mask3 = ((1 shl 20)-1)\n          \
    \      for i in 0..<len(solver.qli):\n                    if len(solver.qli[i])\
    \ == 0:\n                        continue\n                    sort(solver.qli[i])\n\
    \                    if (i and 1) == 1:\n                        reverse(solver.qli[i])\n\
    \                    for x in solver.qli[i]:\n                        let ri =\
    \ x shr 40\n                        let li = (x and mask2) shr 20\n          \
    \              let idx = x and mask3\n                        while nl > li: nl.dec;\
    \ callbackAddLeft(nl)\n                        while nr < ri: callbackAddRight(nr);\
    \ nr.inc\n                        while nl < li: callbackDeleteLeft(nl); nl.inc\n\
    \                        while nr > ri: nr.dec; callbackDeleteRight(nr)\n    \
    \                    callbackRemember(idx)\n            executeMo(self)\n    \
    \        {.pop.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/utils/mo.nim
  requiredBy:
  - verify/utils/mo_test_.nim
  - verify/utils/mo_test_.nim
  - cplib/math/combination_prefix_sum.nim
  - cplib/math/combination_prefix_sum.nim
  timestamp: '2026-09-17 19:40:34+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_kth_smallest_test.nim
  - verify/collections/range_kth_smallest_test.nim
  - verify/AI/mo_test.nim
  - verify/AI/mo_test.nim
  - verify/math/combination_prefix_sum_test.nim
  - verify/math/combination_prefix_sum_test.nim
documentation_of: cplib/utils/mo.nim
layout: document
redirect_from:
- /library/cplib/utils/mo.nim
- /library/cplib/utils/mo.nim.html
title: cplib/utils/mo.nim
---
