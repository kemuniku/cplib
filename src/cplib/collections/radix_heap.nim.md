---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra_radix.nim
    title: cplib/graph/dijkstra_radix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra_radix.nim
    title: cplib/graph/dijkstra_radix.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_radix_test.nim
    title: verify/AI/dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dijkstra_radix_test.nim
    title: verify/AI/dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/radix_heap_test.nim
    title: verify/AI/radix_heap_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/radix_heap_test.nim
    title: verify/AI/radix_heap_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_radix_test.nim
    title: verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/dynamic/restore_dijkstra_radix_test.nim
    title: verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_radix_static_test.nim
    title: verify/graph/static/restore_dijkstra_radix_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/static/restore_dijkstra_radix_static_test.nim
    title: verify/graph/static/restore_dijkstra_radix_static_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_RADIX_HEAP:\n    const CPLIB_COLLECTIONS_RADIX_HEAP*\
    \ = 1\n    import bitops\n\n    type RadixHeap*[K: SomeInteger, V] = object\n\
    \        buckets: array[sizeof(K) * 8 + 1, seq[tuple[key: K, value: V]]]\n   \
    \     minima: array[sizeof(K) * 8 + 1, K]\n        last: K\n        size: int\n\
    \n    proc radixHeapKey[K: SomeInteger](key: K): uint64 {.inline.} =\n       \
    \ ## \u6574\u6570\u306E\u5927\u5C0F\u95A2\u4FC2\u3092\u4FDD\u3064\u7B26\u53F7\u306A\
    \u3057\u30AD\u30FC\u306B\u5909\u63DB\u3059\u308B\u3002O(1)\u3002\n        when\
    \ K is SomeSignedInt:\n            result = cast[uint64](int64(key)) xor (1'u64\
    \ shl (sizeof(K) * 8 - 1))\n            when sizeof(K) < 8:\n                result\
    \ = result and (high(uint64) shr (64 - sizeof(K) * 8))\n        else:\n      \
    \      result = uint64(key)\n\n    proc radixHeapBucket[K: SomeInteger](key, last:\
    \ K): int {.inline.} =\n        ## \u6700\u5F8C\u306B\u78BA\u5B9A\u3057\u305F\u30AD\
    \u30FC\u3068\u306E\u5DEE\u304B\u3089\u30D0\u30B1\u30C3\u30C8\u756A\u53F7\u3092\
    \u6C42\u3081\u308B\u3002O(1)\u3002\n        let difference = radixHeapKey(key)\
    \ xor radixHeapKey(last)\n        if difference == 0: 0\n        else: 64 - countLeadingZeroBits(difference)\n\
    \n    proc initRadixHeap*[K: SomeInteger, V](minKey: K = low(K)): RadixHeap[K,\
    \ V] =\n        ## minKey \u4EE5\u4E0A\u306E\u30AD\u30FC\u3092\u6271\u3046\u5358\
    \u8ABF\u6700\u5C0F\u30D2\u30FC\u30D7\u3092\u4F5C\u308B\u3002O(B)\u3001B \u306F\
    \u30AD\u30FC\u306E\u30D3\u30C3\u30C8\u6570\u3002\n        result.last = minKey\n\
    \n    proc len*[K: SomeInteger, V](self: RadixHeap[K, V]): int {.inline.} =\n\
    \        ## \u8981\u7D20\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        self.size\n\
    \n    proc isEmpty*[K: SomeInteger, V](self: RadixHeap[K, V]): bool {.inline.}\
    \ =\n        ## \u7A7A\u304B\u3069\u3046\u304B\u3092\u8FD4\u3059\u3002O(1)\u3002\
    \n        self.size == 0\n\n    proc push*[K: SomeInteger, V](self: var RadixHeap[K,\
    \ V], key: K, value: V) =\n        ## \u6700\u5F8C\u306B top/pop \u3067\u53C2\u7167\
    \u3057\u305F\u30AD\u30FC\u4EE5\u4E0A\u306E\u8981\u7D20\u3092\u8FFD\u52A0\u3059\
    \u308B\u3002\u511F\u5374 O(1)\u3002\u540C\u5024\u306E\u9806\u5E8F\u306F\u4E0D\u5B9A\
    \u3002\n        assert key >= self.last, \"RadixHeap\u306B\u306F\u6700\u5F8C\u306B\
    \u53C2\u7167\u3057\u305F\u30AD\u30FC\u4EE5\u4E0A\u306E\u5024\u304C\u5FC5\u8981\
    \u3067\u3059\"\n        let b = radixHeapBucket(key, self.last)\n        if self.buckets[b].len\
    \ == 0 or key < self.minima[b]:\n            self.minima[b] = key\n        self.buckets[b].add((key,\
    \ value))\n        inc self.size\n\n    proc push*[K: SomeInteger, V](self: var\
    \ RadixHeap[K, V], item: tuple[key: K, value: V]) =\n        ## \u30AD\u30FC\u3068\
    \u5024\u306E\u7D44\u3092\u8FFD\u52A0\u3059\u308B\u3002\u511F\u5374 O(1)\u3002\u30AD\
    \u30FC\u306E\u5236\u7D04\u306F push(key, value) \u3068\u540C\u3058\u3002\n   \
    \     self.push(item.key, item.value)\n\n    proc prepareRadixHeap[K: SomeInteger,\
    \ V](self: var RadixHeap[K, V]) =\n        ## \u6700\u5C0F\u30D0\u30B1\u30C3\u30C8\
    \u3092\u518D\u5206\u914D\u3059\u308B\u3002\u5404\u8981\u7D20\u306E\u79FB\u52D5\
    \u306F\u633F\u5165\u304B\u3089\u524A\u9664\u307E\u3067\u306B\u9AD8\u3005 B \u56DE\
    \u3002\n        assert self.size > 0, \"\u7A7A\u306ERadixHeap\u306F\u53C2\u7167\
    \u3067\u304D\u307E\u305B\u3093\"\n        if self.buckets[0].len != 0: return\n\
    \        var b = 1\n        while self.buckets[b].len == 0: inc b\n        self.last\
    \ = self.minima[b]\n        for item in self.buckets[b]:\n            let dest\
    \ = radixHeapBucket(item.key, self.last)\n            if self.buckets[dest].len\
    \ == 0 or item.key < self.minima[dest]:\n                self.minima[dest] = item.key\n\
    \            self.buckets[dest].add(item)\n        self.buckets[b].setLen(0)\n\
    \n    proc top*[K: SomeInteger, V](self: var RadixHeap[K, V]): tuple[key: K, value:\
    \ V] =\n        ## \u6700\u5C0F\u8981\u7D20\u3092\u8FD4\u3057\u3001\u4EE5\u5F8C\
    \u8FFD\u52A0\u3067\u304D\u308B\u30AD\u30FC\u306E\u4E0B\u9650\u3092\u66F4\u65B0\
    \u3059\u308B\u3002push \u3068\u5408\u308F\u305B\u3066\u4E00\u8981\u7D20\u3042\u305F\
    \u308A\u511F\u5374 O(B)\u3002\n        self.prepareRadixHeap()\n        self.buckets[0][^1]\n\
    \n    proc `[]`*[K: SomeInteger, V](self: var RadixHeap[K, V], i: Natural): tuple[key:\
    \ K, value: V] =\n        ## \u6DFB\u5B57 0 \u3067\u6700\u5C0F\u8981\u7D20\u3092\
    \u8FD4\u3059\u3002\u8A08\u7B97\u91CF\u3068\u30AD\u30FC\u306E\u5236\u7D04\u306F\
    \ top \u3068\u540C\u3058\u3002\n        assert i == 0, \"\u53C2\u7167\u3067\u304D\
    \u308B\u306E\u306F\u5148\u982D\u8981\u7D20\uFF08\u6DFB\u5B570\uFF09\u306E\u307F\
    \u3067\u3059\"\n        self.top()\n\n    proc pop*[K: SomeInteger, V](self: var\
    \ RadixHeap[K, V]): tuple[key: K, value: V] =\n        ## \u6700\u5C0F\u8981\u7D20\
    \u3092\u53D6\u308A\u9664\u3044\u3066\u8FD4\u3059\u3002push \u3068\u5408\u308F\u305B\
    \u3066\u4E00\u8981\u7D20\u3042\u305F\u308A\u511F\u5374 O(B)\u3002\n        self.prepareRadixHeap()\n\
    \        result = self.buckets[0].pop()\n        dec self.size\n\n    proc clear*[K:\
    \ SomeInteger, V](self: var RadixHeap[K, V], minKey: K = low(K)) =\n        ##\
    \ \u5168\u8981\u7D20\u3092\u524A\u9664\u3057\u3066\u30AD\u30FC\u306E\u4E0B\u9650\
    \u3092\u30EA\u30BB\u30C3\u30C8\u3059\u308B\u3002O(N + B)\u3002\n        for bucket\
    \ in self.buckets.mitems: bucket.setLen(0)\n        self.last = minKey\n     \
    \   self.size = 0\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/radix_heap.nim
  requiredBy:
  - cplib/graph/dijkstra_radix.nim
  - cplib/graph/dijkstra_radix.nim
  timestamp: '2026-09-23 19:26:35+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/static/restore_dijkstra_radix_static_test.nim
  - verify/graph/static/restore_dijkstra_radix_static_test.nim
  - verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - verify/graph/dynamic/restore_dijkstra_radix_test.nim
  - verify/AI/radix_heap_test.nim
  - verify/AI/radix_heap_test.nim
  - verify/AI/dijkstra_radix_test.nim
  - verify/AI/dijkstra_radix_test.nim
documentation_of: cplib/collections/radix_heap.nim
layout: document
redirect_from:
- /library/cplib/collections/radix_heap.nim
- /library/cplib/collections/radix_heap.nim.html
title: cplib/collections/radix_heap.nim
---
