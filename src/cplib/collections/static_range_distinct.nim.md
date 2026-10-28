---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_range_distinct_test.nim
    title: verify/AI/static_range_distinct_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_range_distinct_test.nim
    title: verify/AI/static_range_distinct_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/static_range_distinct_test.nim
    title: verify/collections/static_range_distinct_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/static_range_distinct_test.nim
    title: verify/collections/static_range_distinct_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_STATIC_RANGE_DISTINCT:\n    const CPLIB_COLLECTIONS_STATIC_RANGE_DISTINCT*\
    \ = 1\n    import cplib/collections/waveletmatrix\n    import algorithm, tables\n\
    \n    type StaticRangeDistinct* = object\n        wm: WaveletMatrix\n        N:\
    \ int\n\n    proc initStaticRangeDistinct*[T](v: openArray[T], cmp: proc(a, b:\
    \ T): int): StaticRangeDistinct =\n        ## \u6BD4\u8F03\u95A2\u6570\u3060\u3051\
    \u3092\u4F7F\u3044\u3001\u9759\u7684\u306A\u5217\u306E\u533A\u9593\u7A2E\u985E\
    \u6570\u3092\u6C42\u3081\u308B\u69CB\u9020\u3092 O(N log(N+1)) \u6642\u9593\u3067\
    \u69CB\u7BC9\u3059\u308B\u3002\n        ## cmp \u306F\u8CA0\u30FB0\u30FB\u6B63\
    \u3067\u5927\u5C0F\u30FB\u540C\u5024\u3092\u8868\u3059\u6574\u5408\u3057\u305F\
    \u9806\u5E8F\u3092\u5B9A\u3081\u3001cmp(a, b) == 0 \u3092\u540C\u3058\u7A2E\u985E\
    \u3068\u3059\u308B\u3002\n        ## T \u306E hash \u3068 == \u306F\u4E0D\u8981\
    \u3002\u6BD4\u8F03\u3092 O(1) \u3068\u4EEE\u5B9A\u3057\u3001\u305D\u308C\u4EE5\
    \u5916\u306E\u6BD4\u8F03\u30B3\u30B9\u30C8\u306F\u5225\u9014\u5FC5\u8981\u3002\
    \n        ## \u4FDD\u6301\u9818\u57DF\u306F\u901A\u5E38\u7248\u3068\u540C\u3058\
    \u3067\u3001\u69CB\u7BC9\u4E2D\u306F\u3055\u3089\u306B O(N) \u500B\u306E\u5024\
    \u3068\u6DFB\u5B57\u3092\u4FDD\u6301\u3059\u308B\u3002\n        var ordered =\
    \ newSeq[tuple[value: T, index: int]](v.len)\n        for i, value in v:\n   \
    \         ordered[i] = (value, i)\n        ordered.sort(proc(a, b: tuple[value:\
    \ T, index: int]): int =\n            let c = cmp(a.value, b.value)\n        \
    \    if c != 0: c\n            else: system.cmp(a.index, b.index)\n        )\n\
    \        var previous = newSeq[int](v.len)\n        for i in 1..<ordered.len:\n\
    \            if cmp(ordered[i - 1].value, ordered[i].value) == 0:\n          \
    \      previous[ordered[i].index] = ordered[i - 1].index + 1\n        result.N\
    \ = v.len\n        result.wm = initWaveletMatrix(previous)\n\n    proc initStaticRangeDistinct*[T](v:\
    \ openArray[T]): StaticRangeDistinct =\n        ## \u9759\u7684\u306A\u5217\u306E\
    \u533A\u9593\u7A2E\u985E\u6570\u3092\u30AA\u30F3\u30E9\u30A4\u30F3\u3067\u6C42\
    \u3081\u308B\u69CB\u9020\u3092\u69CB\u7BC9\u3059\u308B\u3002\u30AF\u30A8\u30EA\
    \u306E\u4E8B\u524D\u53CE\u96C6\u306F\u4E0D\u8981\u3002\n        ## T \u304C tables.Table\
    \ \u306E\u30AD\u30FC\u306B\u3067\u304D\u308B\u578B\uFF08\u6574\u5408\u3059\u308B\
    \ hash \u3068 ==\uFF09\u306A\u3089\u30CF\u30C3\u30B7\u30E5\u3092\u4F7F\u3044\u3001\
    \u5927\u5C0F\u6BD4\u8F03\u306F\u4E0D\u8981\u3002\n        ## Table \u304C\u4F7F\
    \u3048\u306A\u3044\u578B\u306F cmp \u306B\u3088\u308B\u6BD4\u8F03\u7248\u306B\u5207\
    \u308A\u66FF\u3048\u308B\u3002\u6BD4\u8F03\u95A2\u6570\u3092\u7B2C2\u5F15\u6570\
    \u306B\u6307\u5B9A\u3059\u308B\u3053\u3068\u3082\u3067\u304D\u308B\u3002\n   \
    \     ## \u8CA0\u6570\u30FB\u5927\u304D\u306A\u6574\u6570\u30FB\u6587\u5B57\u5217\
    \u3082\u6271\u3048\u308B\u3002\u5165\u529B\u5024\u81EA\u4F53\u3092 Wavelet Matrix\
    \ \u306B\u683C\u7D0D\u3057\u306A\u3044\u3002\n        ## N = v.len, H = O(log(N+1))\
    \ \u3068\u3057\u3066\u3001\u30CF\u30C3\u30B7\u30E5\u7248\u306E\u69CB\u7BC9\u306F\
    \u671F\u5F85 O(N(H+1)) \u6642\u9593\u3002\n        ## hash \u3068 == \u3092 O(1)\
    \ \u3068\u4EEE\u5B9A\u3059\u308B\uFF08\u6587\u5B57\u5217\u306A\u3069\u3067\u306F\
    \u305D\u306E\u30B3\u30B9\u30C8\u304C\u5225\u9014\u5FC5\u8981\uFF09\u3002\n   \
    \     ## \u30CF\u30C3\u30B7\u30E5\u885D\u7A81\u304C\u96C6\u4E2D\u3059\u308B\u3068\
    \u524D\u51E6\u7406\u304C\u6700\u60AA O(N^2) \u6642\u9593\u306B\u306A\u308B\u3002\
    \n        ## \u4FDD\u6301\u9818\u57DF\u306F O(N + (ceil(N/64)+1)H) \u30EF\u30FC\
    \u30C9\u3001\u69CB\u7BC9\u4E2D\u306F\u3055\u3089\u306B O(N) \u30EF\u30FC\u30C9\
    \u3002\n        ## \u30AD\u30FC\u306E\u30B3\u30D4\u30FC\u30FB\u4FDD\u6301\u306B\
    \u5FC5\u8981\u306A\u9818\u57DF\u306F\u5225\u9014\u5FC5\u8981\u3002\u69CB\u7BC9\
    \u5F8C\u306B\u5165\u529B\u5217\u306F\u4FDD\u6301\u3057\u306A\u3044\u3002\n   \
    \     ## \u4E00\u70B9\u5909\u66F4\u306F\u975E\u5BFE\u5FDC\u3002\u66F4\u65B0\u3057\
    \u305F\u5217\u306B\u306F\u518D\u69CB\u7BC9\u304C\u5FC5\u8981\u3002\n        runnableExamples:\n\
    \            let d = initStaticRangeDistinct(@[-5, 10, -5, 20, 10])\n        \
    \    assert d.count(0, 5) == 3\n            assert d.count(1, 3) == 2\n      \
    \      assert d.count(2, 2) == 0\n            let empty = initStaticRangeDistinct(newSeq[int]())\n\
    \            assert empty.count(0, 0) == 0\n        when compiles(block:\n   \
    \         var last = initTable[T, int]()\n            last[default(T)] = 1\n \
    \           discard last.getOrDefault(default(T), 0)\n        ):\n           \
    \ var last = initTable[T, int]()\n            var previous = newSeq[int](v.len)\n\
    \            for i, value in v:\n                previous[i] = last.getOrDefault(value,\
    \ 0)\n                last[value] = i + 1\n            result.N = v.len\n    \
    \        result.wm = initWaveletMatrix(previous)\n        else:\n            mixin\
    \ cmp\n            result = initStaticRangeDistinct(v, proc(a, b: T): int = cmp(a,\
    \ b))\n\n    proc len*(self: StaticRangeDistinct): int {.inline.} =\n        ##\
    \ \u5143\u306E\u5217\u306E\u9577\u3055\u3092 O(1) \u3067\u8FD4\u3059\u3002\n \
    \       self.N\n\n    proc count*(self: StaticRangeDistinct, l, r: int): int =\n\
    \        ## \u534A\u958B\u533A\u9593 [l,r) \u306E\u7A2E\u985E\u6570\u3092 O(log(N+1))\
    \ \u6642\u9593\u3067\u8FD4\u3059\u3002\u7A7A\u533A\u9593\u306F O(1) \u3067 0\u3002\
    \n        ## 0 <= l <= r <= len \u304C\u5FC5\u8981\u3002\u9055\u53CD\u306F assert\
    \ \u3067\u691C\u51FA\u3059\u308B\uFF08assertions \u7121\u52B9\u6642\u306F\u672A\
    \u5B9A\u7FA9\uFF09\u3002\n        assert 0 <= l and l <= r and r <= self.N, \"\
    \u533A\u9593\u306F 0 <= l <= r <= len \u3092\u6E80\u305F\u3059\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\"\n        if l == r:\n            return 0\n       \
    \ # \u533A\u9593\u5185\u306E\u5404\u5024\u306E\u6700\u521D\u306E\u51FA\u73FE\u3060\
    \u3051\u304C prev < l\u3001\u3059\u306A\u308F\u3061 prev+1 < l+1 \u3092\u6E80\u305F\
    \u3059\u3002\n        self.wm.range_lowerbound(l, r, l + 1)\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  isVerificationFile: false
  path: cplib/collections/static_range_distinct.nim
  requiredBy: []
  timestamp: '2026-10-25 20:56:05+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/static_range_distinct_test.nim
  - verify/collections/static_range_distinct_test.nim
  - verify/AI/static_range_distinct_test.nim
  - verify/AI/static_range_distinct_test.nim
documentation_of: cplib/collections/static_range_distinct.nim
layout: document
redirect_from:
- /library/cplib/collections/static_range_distinct.nim
- /library/cplib/collections/static_range_distinct.nim.html
title: cplib/collections/static_range_distinct.nim
---
