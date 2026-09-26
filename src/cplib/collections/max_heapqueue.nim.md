---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/max_heapqueue_test.nim
    title: verify/collections/max_heapqueue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/max_heapqueue_test.nim
    title: verify/collections/max_heapqueue_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_MAX_HEAPQUEUE:\n    const CPLIB_COLLECTIONS_MAX_HEAPQUEUE*\
    \ = 1\n\n    type MaxHeapQueue*[T] = object\n        ## \u6700\u5927\u5024\u3092\
    \u5148\u982D\u306B\u6301\u3064\u512A\u5148\u5EA6\u4ED8\u304D\u30AD\u30E5\u30FC\
    \u3002\u8981\u7D20\u306E\u6BD4\u8F03\u306B\u306F `<` \u3092\u4F7F\u3046\u3002\n\
    \        data: seq[T]\n\n    proc initMaxHeapQueue*[T](): MaxHeapQueue[T] =\n\
    \        ## \u7A7A\u306E\u30AD\u30E5\u30FC\u3092\u4F5C\u308B\u3002\u5909\u6570\
    \u306E\u5BA3\u8A00\u3060\u3051\u3067\u3082\u7A7A\u306B\u521D\u671F\u5316\u3055\
    \u308C\u308B\u3002O(1)\u3002\n        result = default(MaxHeapQueue[T])\n\n  \
    \  proc len*[T](heap: MaxHeapQueue[T]): int {.inline.} =\n        ## \u8981\u7D20\
    \u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        heap.data.len\n\n    proc `[]`*[T](heap:\
    \ MaxHeapQueue[T], i: Natural): lent T {.inline.} =\n        ## \u5185\u90E8\u914D\
    \u5217\u306E i \u756A\u76EE\u3092\u53C2\u7167\u3059\u308B\u3002\u6700\u5927\u5024\
    \u306F\u6DFB\u5B57 0 \u3067\u3001\u5168\u4F53\u306F\u672A\u6574\u5217\u3002O(1)\u3002\
    \n        heap.data[i]\n\n    iterator items*[T](heap: MaxHeapQueue[T]): lent\
    \ T {.inline.} =\n        ## \u5185\u90E8\u914D\u5217\u306E\u9806\u306B\u5168\u8981\
    \u7D20\u3092\u5217\u6319\u3059\u308B\u3002\u5217\u6319\u4E2D\u306E\u8981\u7D20\
    \u6570\u5909\u66F4\u306F\u4E0D\u53EF\u3002O(N)\u3002\n        let length = heap.len\n\
    \        for i in 0..<length:\n            yield heap.data[i]\n            assert\
    \ heap.len == length, \"\u5217\u6319\u4E2D\u306B\u30AD\u30E5\u30FC\u306E\u8981\
    \u7D20\u6570\u304C\u5909\u66F4\u3055\u308C\u307E\u3057\u305F\"\n\n    proc siftUp[T](heap:\
    \ var MaxHeapQueue[T], index: int) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\
    \u8981\u7D20\u3092\u4E0A\u306B\u79FB\u52D5\u3057\u3001\u30D2\u30FC\u30D7\u6761\
    \u4EF6\u3092\u5FA9\u5143\u3059\u308B\u3002O(log N)\u3002\n        let item = heap.data[index]\n\
    \        var pos = index\n        while pos > 0:\n            let parent = (pos\
    \ - 1) shr 1\n            if not (heap.data[parent] < item): break\n         \
    \   heap.data[pos] = heap.data[parent]\n            pos = parent\n        heap.data[pos]\
    \ = item\n\n    proc siftDown[T](heap: var MaxHeapQueue[T], index: int) =\n  \
    \      ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u8981\u7D20\u3092\u4E0B\u306B\u79FB\u52D5\
    \u3057\u3001\u30D2\u30FC\u30D7\u6761\u4EF6\u3092\u5FA9\u5143\u3059\u308B\u3002\
    O(log N)\u3002\n        let item = heap.data[index]\n        var pos = index\n\
    \        var child = pos * 2 + 1\n        while child < heap.len:\n          \
    \  if child + 1 < heap.len and not (heap.data[child + 1] < heap.data[child]):\n\
    \                inc child\n            if not (item < heap.data[child]): break\n\
    \            heap.data[pos] = heap.data[child]\n            pos = child\n    \
    \        child = pos * 2 + 1\n        heap.data[pos] = item\n\n    proc push*[T](heap:\
    \ var MaxHeapQueue[T], item: sink T) =\n        ## \u8981\u7D20\u3092\u8FFD\u52A0\
    \u3059\u308B\u3002\u511F\u5374 O(log N)\u3002\n        heap.data.add(item)\n \
    \       heap.siftUp(heap.len - 1)\n\n    proc toMaxHeapQueue*[T](x: openArray[T]):\
    \ MaxHeapQueue[T] =\n        ## \u914D\u5217\u306E\u8981\u7D20\u304B\u3089\u30AD\
    \u30E5\u30FC\u3092\u4F5C\u308B\u3002O(N)\u3002\n        result.data = @x\n   \
    \     for i in countdown(x.len div 2 - 1, 0):\n            result.siftDown(i)\n\
    \n    proc pop*[T](heap: var MaxHeapQueue[T]): T =\n        ## \u6700\u5927\u5024\
    \u3092\u53D6\u308A\u9664\u3044\u3066\u8FD4\u3059\u3002\u7A7A\u306E\u30AD\u30E5\
    \u30FC\u306B\u306F\u4F7F\u7528\u4E0D\u53EF\u3002O(log N)\u3002\n        result\
    \ = heap.data[0]\n        let last = heap.data.pop()\n        if heap.len > 0:\n\
    \            heap.data[0] = last\n            heap.siftDown(0)\n\n    proc find*[T](heap:\
    \ MaxHeapQueue[T], x: T): int =\n        ## x \u3068\u7B49\u3057\u3044\u6700\u521D\
    \u306E\u8981\u7D20\u306E\u6DFB\u5B57\u3092\u8FD4\u3059\u3002\u5B58\u5728\u3057\
    \u306A\u3051\u308C\u3070 -1\u3002O(N)\u3002\n        for i in 0..<heap.len:\n\
    \            if heap.data[i] == x: return i\n        return -1\n\n    proc contains*[T](heap:\
    \ MaxHeapQueue[T], x: T): bool =\n        ## x \u3068\u7B49\u3057\u3044\u8981\u7D20\
    \u304C\u5B58\u5728\u3059\u308B\u304B\u8FD4\u3059\u3002O(N)\u3002\n        heap.find(x)\
    \ >= 0\n\n    proc del*[T](heap: var MaxHeapQueue[T], index: Natural) =\n    \
    \    ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\u8981\u7D20\u3092\u524A\u9664\
    \u3059\u308B\u3002O(log N)\u3002\n        swap(heap.data[index], heap.data[^1])\n\
    \        heap.data.setLen(heap.len - 1)\n        if index < heap.len:\n      \
    \      if index > 0 and heap.data[(index - 1) shr 1] < heap.data[index]:\n   \
    \             heap.siftUp(index)\n            else:\n                heap.siftDown(index)\n\
    \n    proc replace*[T](heap: var MaxHeapQueue[T], item: sink T): T =\n       \
    \ ## \u6700\u5927\u5024\u3092\u53D6\u308A\u9664\u3044\u3066\u8FD4\u3057\u3001\
    item \u3092\u8FFD\u52A0\u3059\u308B\u3002\u7A7A\u306B\u306F\u4F7F\u7528\u4E0D\u53EF\
    \u3002O(log N)\u3002\n        result = heap.data[0]\n        heap.data[0] = item\n\
    \        heap.siftDown(0)\n\n    proc pushpop*[T](heap: var MaxHeapQueue[T], item:\
    \ sink T): T =\n        ## item \u306E\u8FFD\u52A0\u5F8C\u306B\u6700\u5927\u5024\
    \u3092\u53D6\u308A\u9664\u3044\u3066\u8FD4\u3059\u3002\u7A7A\u306A\u3089 item\
    \ \u3092\u8FD4\u3059\u3002O(log N)\u3002\n        result = item\n        if heap.len\
    \ > 0 and result < heap.data[0]:\n            swap(result, heap.data[0])\n   \
    \         heap.siftDown(0)\n\n    proc clear*[T](heap: var MaxHeapQueue[T]) =\n\
    \        ## \u5168\u8981\u7D20\u3092\u524A\u9664\u3059\u308B\u3002\u8981\u7D20\
    \u306E\u7834\u68C4\u3092\u542B\u3081\u3066 O(N)\u3002\n        heap.data.setLen(0)\n\
    \n    proc `$`*[T](heap: MaxHeapQueue[T]): string =\n        ## \u5185\u90E8\u914D\
    \u5217\u306E\u9806\u306B\u6587\u5B57\u5217\u5316\u3059\u308B\u3002O(N + \u51FA\
    \u529B\u6587\u5B57\u5217\u9577)\u3002\n        result = \"[\"\n        for x in\
    \ heap.data:\n            if result.len > 1: result.add(\", \")\n            result.addQuoted(x)\n\
    \        result.add(\"]\")\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/max_heapqueue.nim
  requiredBy: []
  timestamp: '2026-09-27 01:42:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/max_heapqueue_test.nim
  - verify/collections/max_heapqueue_test.nim
documentation_of: cplib/collections/max_heapqueue.nim
layout: document
redirect_from:
- /library/cplib/collections/max_heapqueue.nim
- /library/cplib/collections/max_heapqueue.nim.html
title: cplib/collections/max_heapqueue.nim
---
