---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/collections/retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/retroactive_priority_queue_abc363g_test_.nim
  - icon: ':warning:'
    path: verify/collections/retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/retroactive_priority_queue_abc363g_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_debug_test.nim
    title: verify/collections/retroactive_priority_queue_debug_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_debug_test.nim
    title: verify/collections/retroactive_priority_queue_debug_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_popped_sum_test.nim
    title: verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_popped_sum_test.nim
    title: verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_test.nim
    title: verify/collections/retroactive_priority_queue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_test.nim
    title: verify/collections/retroactive_priority_queue_test.nim
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
  code: "## \u30C7\u30D0\u30C3\u30B0: debugOperations()\u306F\u64CD\u4F5C\u4E00\u89A7\
    \u3001debugTimeline()\u306F\u518D\u5B9F\u884C\u3057\u305Fpop\u7D50\u679C\u4ED8\
    \u304D\u4E00\u89A7\u3092\u8FD4\u3057\u307E\u3059\u3002\n## \u4E00\u89A7\u306F\u6642\
    \u523B\u9806\u3067\u3059\u3002echo pq \u307E\u305F\u306F echo pq.debugDump() \u3067\
    pop\u5143\u306E\u6642\u523B\u3082\u542B\u3081\u3066\u8868\u793A\u3067\u304D\u307E\
    \u3059\u3002\n## \u30C7\u30D0\u30C3\u30B0\u7D50\u679C\u306E\u578BQueueDebugEntry\u3068\
    \u5217\u6319\u5024qdkNone/qdkPush/qdkPop\u306Fretroactive_priority_queue\u3067\
    \u5B9A\u7FA9\u3057\u307E\u3059\u3002\n## \u4EFB\u610F\u306E\u6BD4\u8F03\u53EF\u80FD\
    \u306A\u6642\u523B\u3092\u4E8B\u524D\u767B\u9332\u3057\u3066\u4F7F\u3046RetroactivePriorityQueue\u3067\
    \u3059\u3002\n## \u6642\u523B\u306F\u6607\u9806\u306B\u4E26\u3079\u3066\u91CD\u8907\
    \u9664\u53BB\u3057\u307E\u3059\u3002\u672A\u767B\u9332\u6642\u523B\u3078\u306E\
    \u66F4\u65B0\u306Fassert\u3067\u62D2\u5426\u3057\u307E\u3059\u3002\n## \u64CD\u4F5C\
    \u306E\u4E0A\u66F8\u304D\u3001\u7A7A\u3078\u306Epop\u3001\u540C\u5024\u306E\u512A\
    \u5148\u9806\u4F4D\u306F\u56FA\u5B9A\u9577\u7248\u3068\u540C\u3058\u3067\u3059\
    \u3002\n## QueueDelta\u306Etime\u306B\u306F\u5727\u7E2E\u524D\u306E\u6642\u523B\
    \u304C\u5165\u308A\u307E\u3059\u3002\n##\n## .. code-block:: nim\n##   import\
    \ algorithm\n##   import cplib/collections/compressed_retroactive_priority_queue\n\
    ##   type Time = tuple[day, id: int]\n##   var pq = initCompressedRetroactivePriorityQueue[Time,\
    \ int64](\n##     @[(0, 0), (0, 1), (0, 2)], order = Descending)\n##   pq.setPush((0,\
    \ 0), 10)\n##   pq.setPush((0, 1), 20)\n##   pq.setPop((0, 2))\n##   assert pq.sum\
    \ == 10\n\nwhen not declared CPLIB_COLLECTIONS_COMPRESSED_RETROACTIVE_PRIORITY_QUEUE:\n\
    \    const CPLIB_COLLECTIONS_COMPRESSED_RETROACTIVE_PRIORITY_QUEUE* = 1\n    import\
    \ algorithm, options\n    import cplib/collections/retroactive_priority_queue\n\
    \    include cplib/collections/compressed_coordinates_internal\n\n    type CompressedRetroactivePriorityQueue*[K,\
    \ T] = ref object\n        coords: seq[K]\n        indexSlots: seq[int]\n    \
    \    queue: RetroactivePriorityQueue[T]\n\n    proc initCompressedRetroactivePriorityQueue*[K,\
    \ T](times: openArray[K],\n            order = Ascending): CompressedRetroactivePriorityQueue[K,\
    \ T] =\n        ## \u6642\u523B\u3092\u30BD\u30FC\u30C8\u30FB\u91CD\u8907\u9664\
    \u53BB\u3057\u3066O(N log N)\u6642\u9593\u30FBO(N)\u7A7A\u9593\u3067\u751F\u6210\
    \u3057\u307E\u3059\u3002\n        ## \u64CD\u4F5C\u306F\u6642\u523B\u306E\u6607\
    \u9806\u3067\u3059\u3002\u69CB\u7BC9\u5F8C\u306E\u6642\u523B\u8FFD\u52A0\u306F\
    \u3067\u304D\u307E\u305B\u3093\u3002K\u306B\u306F < \u3068 == \u304C\u5FC5\u8981\
    \u3067\u3059\u3002\n        var coords = @times\n        sortCompressedCoordinates(coords)\n\
    \        var count = 0\n        for i in 0..<coords.len:\n            if count\
    \ == 0 or coords[count - 1] != coords[i]:\n                if count != i: coords[count]\
    \ = coords[i]\n                inc count\n        coords.setLen(count)\n     \
    \   result = CompressedRetroactivePriorityQueue[K, T](coords: coords,\n      \
    \      indexSlots: initCompressedCoordinateIndex(coords),\n            queue:\
    \ initRetroactivePriorityQueue[T](count, order))\n\n    proc coordinateIndex[K,\
    \ T](self: CompressedRetroactivePriorityQueue[K, T], t: K): int =\n        ##\
    \ \u767B\u9332\u6E08\u307F\u6642\u523B\u306E\u6DFB\u5B57\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\u672A\u767B\u9332\u306A\u3089assert\u3067\u3059\u3002O(log N)\u3002\
    \n        result = findCompressedCoordinate(self.coords, self.indexSlots, t)\n\
    \        assert result >= 0, \"\u66F4\u65B0\u3059\u308B\u6642\u523B\u306F\u4E8B\
    \u524D\u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\"\n\n    proc convertDelta[K,\
    \ T](self: CompressedRetroactivePriorityQueue[K, T],\n            delta: QueueDelta[int,\
    \ T]): QueueDelta[K, T] =\n        ## \u5DEE\u5206\u306E\u6DFB\u5B57\u3092\u5143\
    \u306E\u6642\u523B\u306B\u623B\u3057\u307E\u3059\u3002O(1)\u3002\n        for\
    \ entry in delta.added:\n            result.added.add((self.coords[entry.time],\
    \ entry.value))\n        for entry in delta.removed:\n            result.removed.add((self.coords[entry.time],\
    \ entry.value))\n\n    proc setPush*[K, T](self: CompressedRetroactivePriorityQueue[K,\
    \ T],\n            t: K, value: T): QueueDelta[K, T] {.discardable.} =\n     \
    \   ## \u6642\u523Bt\u306E\u64CD\u4F5C\u3092push(value)\u3067\u4E0A\u66F8\u304D\
    \u3057\u3001\u6700\u7D42\u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        self.convertDelta(self.queue.setPush(self.coordinateIndex(t),\
    \ value))\n\n    proc setPop*[K, T](self: CompressedRetroactivePriorityQueue[K,\
    \ T],\n            t: K): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\
    \u523Bt\u306E\u64CD\u4F5C\u3092pop\u3067\u4E0A\u66F8\u304D\u3057\u3001\u6700\u7D42\
    \u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        self.convertDelta(self.queue.setPop(self.coordinateIndex(t)))\n\n  \
    \  proc erase*[K, T](self: CompressedRetroactivePriorityQueue[K, T],\n       \
    \     t: K): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\u523Bt\u306E\
    \u64CD\u4F5C\u3092\u4F55\u3082\u3057\u306A\u3044\u64CD\u4F5C\u306B\u5909\u66F4\
    \u3057\u3001\u6700\u7D42\u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        self.convertDelta(self.queue.erase(self.coordinateIndex(t)))\n\
    \n    proc len*[K, T](self: CompressedRetroactivePriorityQueue[K, T]): int =\n\
    \        ## \u5168\u64CD\u4F5C\u306E\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\u8981\
    \u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.queue.len\n\
    \n    proc sum*[K; T: SomeNumber](self: CompressedRetroactivePriorityQueue[K,\
    \ T]): T =\n        ## \u5168\u64CD\u4F5C\u306E\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\
    \u5024\u306E\u7DCF\u548C\u3092T\u578B\u3067\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        self.queue.sum\n\n    proc peek*[K, T](self: CompressedRetroactivePriorityQueue[K,\
    \ T]): Option[T] =\n        ## \u6700\u7D42\u72B6\u614B\u306E\u6700\u512A\u5148\
    \u8981\u7D20\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\u3089none\u3067\u3059\
    \u3002O(1)\u3002\n        self.queue.peek()\n\n    proc isRemaining*[K, T](self:\
    \ CompressedRetroactivePriorityQueue[K, T], t: K): bool =\n        ## \u6642\u523B\
    t\u306Epush\u304C\u6700\u5F8C\u306B\u6B8B\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\u672A\u767B\u9332\u6642\u523B\u306Ffalse\u3067\u3059\u3002O(log N)\u3002\
    \n        let i = findCompressedCoordinate(self.coords, self.indexSlots, t)\n\
    \        i >= 0 and self.queue.isRemaining(i)\n\n    proc debugOperations*[K,\
    \ T](self: CompressedRetroactivePriorityQueue[K, T]): seq[QueueDebugEntry[K, T]]\
    \ =\n        ## \u4E8B\u524D\u767B\u9332\u3057\u305F\u5168\u6642\u523B\u306E\u64CD\
    \u4F5C\u3092\u6607\u9806\u3067\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u64CD\u4F5C\
    \u3082\u542B\u307F\u3001pop\u7D50\u679C\u306F\u672A\u8A08\u7B97\u3067\u3059\u3002\
    O(N)\u3002\n        for entry in self.queue.debugOperations():\n            result.add(QueueDebugEntry[K,\
    \ T](time: self.coords[entry.time],\n                kind: entry.kind, value:\
    \ entry.value))\n\n    proc debugTimeline*[K, T](self: CompressedRetroactivePriorityQueue[K,\
    \ T]): seq[QueueDebugEntry[K, T]] =\n        ## \u5168\u64CD\u4F5C\u3068\u5B9F\
    \u969B\u306Epop\u7D50\u679C\u3092\u5143\u306E\u6642\u523B\u3067\u8FD4\u3057\u307E\
    \u3059\u3002O(N log(N+2))\u6642\u9593\u30FBO(N)\u7A7A\u9593\u3002\n        for\
    \ entry in self.queue.debugTimeline():\n            var converted = QueueDebugEntry[K,\
    \ T](time: self.coords[entry.time],\n                kind: entry.kind, value:\
    \ entry.value)\n            if entry.popped.isSome:\n                let popped\
    \ = entry.popped.get\n                converted.popped = some((time: self.coords[popped.time],\
    \ value: popped.value))\n            result.add(converted)\n\n    proc debugDump*[K,\
    \ T](self: CompressedRetroactivePriorityQueue[K, T]): string =\n        ## \u64CD\
    \u4F5C\u3068\u5B9F\u969B\u306Epop\u7D50\u679C\u3092\u8868\u793A\u7528\u6587\u5B57\
    \u5217\u3067\u8FD4\u3057\u307E\u3059\u3002O(N log(N+2)+\u51FA\u529B\u6587\u5B57\
    \u6570)\u3002\n        formatQueueDebug(self.debugTimeline())\n\n    proc `$`*[K,\
    \ T](self: CompressedRetroactivePriorityQueue[K, T]): string =\n        ## debugDump\u3068\
    \u540C\u3058\u64CD\u4F5C\u30FBpop\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(N log(N+2)+\u51FA\u529B\u6587\u5B57\u6570)\u3002\n        self.debugDump()\n\
    \n    proc poppedSum*[K; T: SomeNumber](self: CompressedRetroactivePriorityQueue[K,\
    \ T]): T =\n        ## \u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067pop\u3055\u308C\
    \u308B\u5024\u306E\u7DCF\u548C\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u3078\
    \u306Epop\u306F0\u3068\u3057\u3066\u6271\u3044\u307E\u3059\u3002O(1)\u3002\n \
    \       self.queue.poppedSum\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/compressed_coordinates_internal.nim
  isVerificationFile: false
  path: cplib/collections/compressed_retroactive_priority_queue.nim
  requiredBy:
  - verify/collections/retroactive_priority_queue_abc363g_test_.nim
  - verify/collections/retroactive_priority_queue_abc363g_test_.nim
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/retroactive_priority_queue_test.nim
  - verify/collections/retroactive_priority_queue_test.nim
  - verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
documentation_of: cplib/collections/compressed_retroactive_priority_queue.nim
layout: document
redirect_from:
- /library/cplib/collections/compressed_retroactive_priority_queue.nim
- /library/cplib/collections/compressed_retroactive_priority_queue.nim.html
title: cplib/collections/compressed_retroactive_priority_queue.nim
---
