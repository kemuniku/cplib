---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
    title: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
    title: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_debug_test.nim
    title: verify/collections/retroactive_priority_queue_debug_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/retroactive_priority_queue_debug_test.nim
    title: verify/collections/retroactive_priority_queue_debug_test.nim
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
    \u5B9A\u7FA9\u3057\u307E\u3059\u3002\n## \u4EFB\u610F\u6642\u523B\u306Epush/pop\u3092\
    \u7DE8\u96C6\u3057\u3001\u6700\u5F8C\u306B\u6B8B\u308Bpush\u306E\u5024\u3092\u6642\
    \u523B\u306E\u6607\u9806\u3067\u30E2\u30CE\u30A4\u30C9\u96C6\u7D04\u3057\u307E\
    \u3059\u3002\n## K\u306F\u6642\u523B\u3001T\u306F\u512A\u5148\u5EA6\u6BD4\u8F03\
    \u306B\u4F7F\u3046\u5024\u3001S\u306F\u96C6\u7D04\u5024\u3067\u3059\u3002\u975E\
    \u53EF\u63DB\u30E2\u30CE\u30A4\u30C9\u306B\u3082\u5BFE\u5FDC\u3057\u307E\u3059\
    \u3002\n## op\u30FBlift\u30FB\u5024\u306E\u30B3\u30D4\u30FC\u3092O(1)\u3068\u3057\
    \u3066\u3001\u66F4\u65B0\u306F\u511F\u5374O(log(M+2))\u3001fold\u30FBlen\u30FB\
    peek\u306FO(1)\u3067\u3059\u3002\n## \u7A7A\u9593\u306F\u767B\u9332\u64CD\u4F5C\
    \u6570\u306E\u904E\u53BB\u6700\u5927\u5024\u306B\u6BD4\u4F8B\u3057\u307E\u3059\
    \u3002\u6642\u523B\u306E\u4E8B\u524D\u767B\u9332\u306F\u4E0D\u8981\u3067\u3059\
    \u3002\n## \u7A7A\u3078\u306Epop\u306F\u7121\u8996\u3057\u3001\u540C\u5024\u306A\
    \u3089\u65E9\u3044\u6642\u523B\u306Epush\u3092\u5148\u306B\u53D6\u308A\u51FA\u3057\
    \u307E\u3059\u3002\n## QueueDelta\u306B\u306F\u96C6\u7D04\u524D\u306E\u5024\u304C\
    \u5165\u308A\u307E\u3059\u3002\u904E\u53BB\u306Epop\u306E\u8FD4\u308A\u5024\u3084\
    \u9014\u4E2D\u6642\u523B\u306E\u72B6\u614B\u306F\u7BA1\u7406\u3057\u307E\u305B\
    \u3093\u3002\n##\n## .. code-block:: nim\n##   import cplib/collections/dynamic_retroactive_priority_queue_monoid\n\
    ##   let pq = initDynamicRetroactivePriorityQueueMonoid[int, int, int](\n##  \
    \   proc(a, b: int): int = max(a, b), low(int), proc(x: int): int = x)\n##   pq.setPush(20,\
    \ 7)\n##   pq.setPush(10, 3)\n##   pq.setPop(30)\n##   assert pq.fold() == 7\n\
    \nwhen not declared CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE_MONOID:\n\
    \    const CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE_MONOID* = 1\n\
    \    import algorithm, options\n    import cplib/collections/retroactive_priority_queue\n\
    \    import cplib/collections/dynamic_retroactive_priority_queue\n\n    type DynamicRetroactivePriorityQueueMonoid*[K,\
    \ T, S] = object\n        queue: DynamicRetroactivePriorityQueue[K, T, S]\n\n\
    \    proc initDynamicRetroactivePriorityQueueMonoid*[K, T, S](op: proc(a, b: S):\
    \ S,\n            e: S, lift: proc(value: T): S,\n            order = Ascending):\
    \ DynamicRetroactivePriorityQueueMonoid[K, T, S] =\n        ## \u7A7A\u306E\u64CD\
    \u4F5C\u5217\u3092\u751F\u6210\u3057\u307E\u3059\u3002op\u306F\u7D50\u5408\u7684\
    \u3001e\u306F\u5358\u4F4D\u5143\u3001op\u30FBlift\u306F\u526F\u4F5C\u7528\u306A\
    \u3057\u3068\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        ## K\u3068T\u306B\
    \u306F\u4E00\u8CAB\u3057\u305F < \u304C\u5FC5\u8981\u3067\u3059\u3002Ascending\u306F\
    pop min\u3001Descending\u306Fpop max\u3067\u3059\u3002\n        result.queue =\
    \ initDynamicRetroactivePriorityQueue[K, T, S](op, e, lift, order)\n\n    proc\
    \ setPush*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S],\n  \
    \          t: K, value: T): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\
    \u523Bt\u306Bpush\u3092\u633F\u5165\u30FB\u4E0A\u66F8\u304D\u3057\u3001\u6700\u7D42\
    \u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\u3059\u3002\u511F\u5374\
    O(log(M+2))\u3002\n        setPush(self.queue, t, value)\n\n    proc setPop*[K,\
    \ T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S],\n            t:\
    \ K): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\u523Bt\u306Bpop\u3092\
    \u633F\u5165\u30FB\u4E0A\u66F8\u304D\u3057\u3001\u6700\u7D42\u72B6\u614B\u306E\
    \u5DEE\u5206\u3092\u8FD4\u3057\u307E\u3059\u3002\u511F\u5374O(log(M+2))\u3002\n\
    \        setPop(self.queue, t)\n\n    proc erase*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K,\
    \ T, S],\n            t: K): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\
    \u523Bt\u306E\u64CD\u4F5C\u3092\u524A\u9664\u3057\u307E\u3059\u3002\u672A\u767B\
    \u9332\u306A\u3089\u4F55\u3082\u3057\u307E\u305B\u3093\u3002\u511F\u5374O(log(M+2))\u3002\
    \n        erase(self.queue, t)\n\n    proc fold*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K,\
    \ T, S]): S =\n        ## \u6B8B\u5B58push\u306E\u6642\u523B\u9806\u306E\u7A4D\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\u3089\u5358\u4F4D\u5143\u3067\
    \u3059\u3002O(1)\u3002\n        fold(self.queue)\n\n    proc get_all*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueueMonoid[K, T, S]): S =\n        ## fold\u3068\u540C\
    \u3058\u30E2\u30CE\u30A4\u30C9\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        self.fold()\n\n    proc len*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K,\
    \ T, S]): int =\n        ## \u5168\u64CD\u4F5C\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\
    \u5B9F\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   len(self.queue)\n\n    proc peek*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K,\
    \ T, S]): Option[T] =\n        ## \u6700\u7D42\u72B6\u614B\u306E\u6700\u512A\u5148\
    \u8981\u7D20\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\u3089none\u3067\u3059\
    \u3002O(1)\u3002\n        peek(self.queue)\n\n    proc isRemaining*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueueMonoid[K, T, S], t: K): bool =\n        ## \u6642\
    \u523Bt\u306Epush\u304C\u6700\u5F8C\u306B\u6B8B\u308B\u304B\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\u672A\u767B\u9332\u30FBpop\u306A\u3089false\u3067\u3059\u3002O(log(M+2))\u3002\
    \n        isRemaining(self.queue, t)\n\n    proc debugOperations*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueueMonoid[K, T, S]): seq[QueueDebugEntry[K, T]]\
    \ =\n        ## \u767B\u9332\u4E2D\u306E\u64CD\u4F5C\u3092\u6642\u523B\u9806\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\u96C6\u7D04\u524D\u306E\u5024\u3092\u4F7F\u3044\
    \u3001pop\u7D50\u679C\u306F\u672A\u8A08\u7B97\u3067\u3059\u3002O(M)\u3002\n  \
    \      self.queue.debugOperations()\n\n    proc debugTimeline*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueueMonoid[K, T, S]): seq[QueueDebugEntry[K, T]]\
    \ =\n        ## \u767B\u9332\u4E2D\u306E\u5168\u64CD\u4F5C\u3068\u5B9F\u969B\u306E\
    pop\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002O(M log(M+2))\u6642\u9593\u30FB\
    O(M)\u7A7A\u9593\u3002\n        self.queue.debugTimeline()\n\n    proc debugDump*[K,\
    \ T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]): string =\n    \
    \    ## \u64CD\u4F5C\u3068\u5B9F\u969B\u306Epop\u7D50\u679C\u3092\u8868\u793A\u7528\
    \u6587\u5B57\u5217\u3067\u8FD4\u3057\u307E\u3059\u3002O(M log(M+2)+\u51FA\u529B\
    \u6587\u5B57\u6570)\u3002\n        formatQueueDebug(self.debugTimeline())\n\n\
    \    proc `$`*[K, T, S](self: DynamicRetroactivePriorityQueueMonoid[K, T, S]):\
    \ string =\n        ## debugDump\u3068\u540C\u3058\u64CD\u4F5C\u30FBpop\u7D50\u679C\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(M log(M+2)+\u51FA\u529B\u6587\u5B57\u6570\
    )\u3002\n        self.debugDump()\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  isVerificationFile: false
  path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  requiredBy: []
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
documentation_of: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
layout: document
redirect_from:
- /library/cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
- /library/cplib/collections/dynamic_retroactive_priority_queue_monoid.nim.html
title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
---
