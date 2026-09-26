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
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/suffix_array.nim
    title: cplib/str/suffix_array.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_string_search_test.nim
    title: verify/AI/static_string_search_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_string_search_test.nim
    title: verify/AI/static_string_search_test.nim
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
  code: "when not declared CPLIB_STR_STATIC_STRING_SEARCH:\n    const CPLIB_STR_STATIC_STRING_SEARCH*\
    \ = 1\n    import tables\n    import cplib/str/static_string\n    import cplib/collections/staticRMQ\n\
    \    import cplib/collections/waveletmatrix\n\n    type StaticStringSearch*[T]\
    \ = object\n        base: StaticStringBase[T]\n        wm: WaveletMatrix\n\n \
    \   type StaticStringSearchView*[T] = object\n        search: StaticStringSearch[T]\n\
    \        target: StaticString[T]\n\n    type StaticStringSearchCacheEntry[T] =\
    \ ref object of RootObj\n        search: StaticStringSearch[T]\n\n    # \u7D22\
    \u5F15\u304C\u57FA\u5E95\u3092\u4FDD\u6301\u3059\u308B\u305F\u3081\u3001\u767B\
    \u9332\u4E2D\u306B\u540C\u3058\u30A2\u30C9\u30EC\u30B9\u304C\u5225\u306E\u57FA\
    \u5E95\u3078\u518D\u5229\u7528\u3055\u308C\u308B\u3053\u3068\u306F\u306A\u3044\
    \u3002\n    var staticStringSearchCache: Table[pointer, RootRef]\n\n    proc clearStaticStringSearchCache*[T](base:\
    \ StaticStringBase[T]) =\n        ## \u6307\u5B9A\u3057\u305F\u57FA\u5E95\u306E\
    \u7D22\u5F15\u3092\u30AD\u30E3\u30C3\u30B7\u30E5\u304B\u3089\u9664\u304F\u3002\
    \u4FDD\u6301\u6E08\u307F\u306E\u691C\u7D22\u30AA\u30D6\u30B8\u30A7\u30AF\u30C8\
    \u306F\u5F15\u304D\u7D9A\u304D\u4F7F\u3048\u308B\u3002\n        staticStringSearchCache.del(cast[pointer](base))\n\
    \n    proc clearStaticStringSearchCache*() =\n        ## \u5168\u3066\u306E\u578B\
    \u30FB\u57FA\u5E95\u306E\u7D22\u5F15\u3068\u30AD\u30E3\u30C3\u30B7\u30E5\u306E\
    \u9818\u57DF\u3092\u624B\u653E\u3059\u3002\u4FDD\u6301\u6E08\u307F\u306E\u691C\
    \u7D22\u30AA\u30D6\u30B8\u30A7\u30AF\u30C8\u306F\u5F15\u304D\u7D9A\u304D\u4F7F\
    \u3048\u308B\u3002\n        staticStringSearchCache = default(Table[pointer, RootRef])\n\
    \n    proc initStaticStringSearch*[T](base: StaticStringBase[T]): StaticStringSearch[T]\
    \ =\n        ## \u57FA\u5E95\u3054\u3068\u306E\u7D22\u5F15\u3092\u53D6\u5F97\u3059\
    \u308B\u3002\u521D\u56DE O(N log(N+2)) \u6642\u9593\u3001\u518D\u53D6\u5F97\u306F\
    \u671F\u5F85 O(1) \u6642\u9593\u3002N \u306F base.S.len\u3002\n        ## \u30AD\
    \u30E3\u30C3\u30B7\u30E5\u306F clearStaticStringSearchCache \u3092\u547C\u3076\
    \u307E\u3067\u7D22\u5F15\u3068\u57FA\u5E95\u3092\u4FDD\u6301\u3059\u308B\u3002\
    \n        let key = cast[pointer](base)\n        let existing = staticStringSearchCache.getOrDefault(key)\n\
    \        if existing != nil:\n            return StaticStringSearchCacheEntry[T](existing).search\n\
    \        result.base = base\n        var positions = newSeq[int](base.SA.len)\n\
    \        for i, position in base.SA:\n            positions[i] = int(position)\n\
    \        result.wm = initWaveletMatrix(positions)\n        staticStringSearchCache[key]\
    \ = StaticStringSearchCacheEntry[T](search: result)\n\n    proc suffixRange[T](search:\
    \ StaticStringSearch[T], pattern: StaticString[T]): tuple[first, last: int] =\n\
    \        ## \u7A7A\u3067\u306A\u3044 pattern \u3092\u63A5\u982D\u8F9E\u306B\u6301\
    \u3064\u63A5\u5C3E\u8F9E\u306E SA \u4E0A\u306E\u534A\u958B\u533A\u9593\u3092 O(log(N+2))\
    \ \u6642\u9593\u3067\u6C42\u3081\u308B\u3002\n        let m = len(pattern)\n \
    \       let rank = int(search.base.RSA[pattern.l])\n        var left = 0\n   \
    \     var right = rank\n        while left < right:\n            let mid = (left\
    \ + right) shr 1\n            if search.base.RMQ.query(mid, rank) >= m:\n    \
    \            right = mid\n            else:\n                left = mid + 1\n\
    \        result.first = left\n\n        left = rank\n        right = search.base.SA.len\
    \ - 1\n        while left < right:\n            let mid = (left + right + 1) shr\
    \ 1\n            if search.base.RMQ.query(rank, mid) >= m:\n                left\
    \ = mid\n            else:\n                right = mid - 1\n        result.last\
    \ = left + 1\n\n    proc count*[Element](search: StaticStringSearch[Element],\
    \ S, T: StaticString[Element]): int =\n        ## \u540C\u3058\u57FA\u5E95\u306E\
    \ S \u5185\u3067\u91CD\u8907\u3092\u8A31\u3057\u305F T \u306E\u51FA\u73FE\u56DE\
    \u6570\u3092 O(log(N+2)) \u6642\u9593\u3067\u8FD4\u3059\u3002\u7A7A\u306E T \u306F\
    \ len(S)+1 \u56DE\u3002\n        assert S.base == search.base and T.base == search.base,\
    \ \"\u6587\u5B57\u5217\u306F\u691C\u7D22\u7528\u7D22\u5F15\u3068\u540C\u3058\u57FA\
    \u5E95\u6587\u5B57\u5217\u304B\u3089\u4F5C\u6210\u3055\u308C\u3066\u3044\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let m = len(T)\n       \
    \ if m == 0:\n            return len(S) + 1\n        if m > len(S):\n        \
    \    return 0\n        let (first, last) = search.suffixRange(T)\n        return\
    \ search.wm.range_freq(first, last, int(S.l), int(S.r) - m + 1)\n\n    proc contains*[Element](search:\
    \ StaticStringSearch[Element], S, T: StaticString[Element]): bool =\n        ##\
    \ \u540C\u3058\u57FA\u5E95\u306E S \u306B T \u304C\u542B\u307E\u308C\u308B\u304B\
    \ O(log(N+2)) \u6642\u9593\u3067\u5224\u5B9A\u3059\u308B\u3002\u7A7A\u306E T \u306F\
    \u5E38\u306B\u542B\u307E\u308C\u308B\u3002\n        return search.count(S, T)\
    \ > 0\n\n    iterator findAll*[Element](search: StaticStringSearch[Element], S,\
    \ T: StaticString[Element]): int =\n        ## \u540C\u3058\u57FA\u5E95\u306E\
    \ S \u5185\u3067\u91CD\u8907\u3092\u8A31\u3057\u305F T \u306E\u51FA\u73FE\u4F4D\
    \u7F6E\u3092\u3001S \u306E\u5148\u982D\u3092 0 \u3068\u3059\u308B\u6607\u9806\u3067\
    \u5217\u6319\u3059\u308B\u3002\n        ## \u6E96\u5099\u3068\u5404\u8981\u7D20\
    \u306E\u53D6\u5F97\u306F O(log(N+2)) \u6642\u9593\u3001\u8FFD\u52A0\u7A7A\u9593\
    \u306F O(1)\u3002\u7A7A\u306E T \u306F 0..len(S) \u3092\u5217\u6319\u3059\u308B\
    \u3002\n        assert S.base == search.base and T.base == search.base, \"\u6587\
    \u5B57\u5217\u306F\u691C\u7D22\u7528\u7D22\u5F15\u3068\u540C\u3058\u57FA\u5E95\
    \u6587\u5B57\u5217\u304B\u3089\u4F5C\u6210\u3055\u308C\u3066\u3044\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        let m = len(T)\n        if m ==\
    \ 0:\n            for position in 0..len(S):\n                yield position\n\
    \        elif m <= len(S):\n            let (first, last) = search.suffixRange(T)\n\
    \            let begin = search.wm.range_lowerbound(first, last, int(S.l))\n \
    \           let finish = search.wm.range_lowerbound(first, last, int(S.r) - m\
    \ + 1)\n            for k in begin..<finish:\n                yield search.wm.kth_smallest(first,\
    \ last, k) - int(S.l)\n\n    proc count*[Element](S, T: StaticString[Element]):\
    \ int =\n        ## \u540C\u3058\u57FA\u5E95\u306E S \u5185\u3067\u91CD\u8907\u3092\
    \u8A31\u3057\u305F T \u306E\u51FA\u73FE\u56DE\u6570\u3092\u8FD4\u3059\u3002\u7A7A\
    \u306E T \u306F len(S)+1 \u56DE\u3002\n        ## \u7D22\u5F15\u304C\u5FC5\u8981\
    \u306A\u521D\u56DE\u306F O(N log(N+2)) \u6642\u9593\u3001\u69CB\u7BC9\u5F8C\u306F\
    \u671F\u5F85 O(log(N+2)) \u6642\u9593\u3002\n        assert S.base == T.base,\
    \ \"\u6587\u5B57\u5217\u306F\u540C\u3058\u57FA\u5E95\u6587\u5B57\u5217\u304B\u3089\
    \u4F5C\u6210\u3055\u308C\u3066\u3044\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        if len(T) == 0:\n            return len(S) + 1\n        if len(T)\
    \ > len(S):\n            return 0\n        return initStaticStringSearch(S.base).count(S,\
    \ T)\n\n    proc contains*[Element](S, T: StaticString[Element]): bool =\n   \
    \     ## \u540C\u3058\u57FA\u5E95\u306E S \u306B T \u304C\u542B\u307E\u308C\u308B\
    \u304B\u5224\u5B9A\u3059\u308B\u3002T in S \u3068\u66F8\u3051\u308B\u3002\u7A7A\
    \u306E T \u306F\u5E38\u306B\u542B\u307E\u308C\u308B\u3002\n        ## \u7D22\u5F15\
    \u304C\u5FC5\u8981\u306A\u521D\u56DE\u306F O(N log(N+2)) \u6642\u9593\u3001\u69CB\
    \u7BC9\u5F8C\u306F\u671F\u5F85 O(log(N+2)) \u6642\u9593\u3002\n        return\
    \ count(S, T) > 0\n\n    iterator findAll*[Element](S, T: StaticString[Element]):\
    \ int =\n        ## S \u306E\u5148\u982D\u3092 0 \u3068\u3059\u308B\u51FA\u73FE\
    \u4F4D\u7F6E\u3092\u91CD\u8907\u3092\u8A31\u3057\u3066\u6607\u9806\u306B\u5217\
    \u6319\u3059\u308B\u3002\u7A7A\u306E T \u306F 0..len(S)\u3002\n        ## \u521D\
    \u56DE\u306F\u5FC5\u8981\u306A\u3089\u7D22\u5F15\u3092\u69CB\u7BC9\u3059\u308B\
    \u3002\u69CB\u7BC9\u5F8C\u306E\u6E96\u5099\u306F\u671F\u5F85 O(log(N+2))\u3001\
    \u5404\u8981\u7D20\u306F O(log(N+2)) \u6642\u9593\u3001\u8FFD\u52A0\u7A7A\u9593\
    \u306F O(1)\u3002\n        assert S.base == T.base, \"\u6587\u5B57\u5217\u306F\
    \u540C\u3058\u57FA\u5E95\u6587\u5B57\u5217\u304B\u3089\u4F5C\u6210\u3055\u308C\
    \u3066\u3044\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        if len(T)\
    \ == 0:\n            for position in 0..len(S):\n                yield position\n\
    \        elif len(T) <= len(S):\n            let search = initStaticStringSearch(S.base)\n\
    \            for position in search.findAll(S, T):\n                yield position\n\
    \n    proc `[]`*[T](search: StaticStringSearch[T], target: StaticString[T]): StaticStringSearchView[T]\
    \ {.inline.} =\n        ## \u540C\u3058\u57FA\u5E95\u306E target \u3068\u7D22\u5F15\
    \u3092 O(1) \u6642\u9593\u3067\u7D44\u306B\u3057\u3001pattern in search[target]\
    \ \u3068\u66F8\u3051\u308B\u3088\u3046\u306B\u3059\u308B\u3002\n        assert\
    \ target.base == search.base, \"\u6587\u5B57\u5217\u306F\u691C\u7D22\u7528\u7D22\
    \u5F15\u3068\u540C\u3058\u57FA\u5E95\u6587\u5B57\u5217\u304B\u3089\u4F5C\u6210\
    \u3055\u308C\u3066\u3044\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       return StaticStringSearchView[T](search: search, target: target)\n\n \
    \   proc contains*[T](target: StaticStringSearchView[T], pattern: StaticString[T]):\
    \ bool {.inline.} =\n        ## \u691C\u7D22\u5BFE\u8C61\u306B pattern \u304C\u542B\
    \u307E\u308C\u308B\u304B O(log(N+2)) \u6642\u9593\u3067\u5224\u5B9A\u3059\u308B\
    \u3002in \u3068 notin \u306B\u5BFE\u5FDC\u3059\u308B\u3002\n        return target.search.contains(target.target,\
    \ pattern)\n\n    proc count*[T](target: StaticStringSearchView[T], pattern: StaticString[T]):\
    \ int {.inline.} =\n        ## \u691C\u7D22\u5BFE\u8C61\u5185\u3067\u91CD\u8907\
    \u3092\u8A31\u3057\u305F pattern \u306E\u51FA\u73FE\u56DE\u6570\u3092 O(log(N+2))\
    \ \u6642\u9593\u3067\u8FD4\u3059\u3002\u7A7A\u306E pattern \u306F\u5BFE\u8C61\u9577\
    +1 \u56DE\u3002\n        return target.search.count(target.target, pattern)\n\n\
    \    iterator findAll*[T](target: StaticStringSearchView[T], pattern: StaticString[T]):\
    \ int =\n        ## \u5BFE\u8C61\u306E\u5148\u982D\u3092 0 \u3068\u3059\u308B\u51FA\
    \u73FE\u4F4D\u7F6E\u3092\u6607\u9806\u3067\u5217\u6319\u3059\u308B\u3002\u6E96\
    \u5099\u3068\u5404\u8981\u7D20\u306E\u53D6\u5F97\u306F O(log(N+2)) \u6642\u9593\
    \u3001\u8FFD\u52A0\u7A7A\u9593\u306F O(1)\u3002\n        for position in target.search.findAll(target.target,\
    \ pattern):\n            yield position\n"
  dependsOn:
  - cplib/collections/waveletmatrix.nim
  - cplib/str/suffix_array.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/suffix_array.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/str/static_string_search.nim
  requiredBy: []
  timestamp: '2026-09-27 01:42:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/static_string_search_test.nim
  - verify/AI/static_string_search_test.nim
documentation_of: cplib/str/static_string_search.nim
layout: document
redirect_from:
- /library/cplib/str/static_string_search.nim
- /library/cplib/str/static_string_search.nim.html
title: cplib/str/static_string_search.nim
---
