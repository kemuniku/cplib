---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/double_ended_priority_queue_random_test.nim
    title: verify/collections/double_ended_priority_queue_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/double_ended_priority_queue_random_test.nim
    title: verify/collections/double_ended_priority_queue_random_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/double_ended_priority_queue_test.nim
    title: verify/collections/double_ended_priority_queue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/double_ended_priority_queue_test.nim
    title: verify/collections/double_ended_priority_queue_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_DOUBLE_ENDED_PRIORITY_QUEUE:\n    const\
    \ CPLIB_COLLECTIONS_DOUBLE_ENDED_PRIORITY_QUEUE* = 1\n    import bitops\n\n  \
    \  type DoubleEndedPriorityQueue*[T] = object\n        ## \u6700\u5C0F\u5024\u3068\
    \u6700\u5927\u5024\u3092\u53D6\u308A\u51FA\u305B\u308B min-max heap\u3002\u6BD4\
    \u8F03\u306B\u306F `<` \u306E\u307F\u3092\u4F7F\u3046\u3002\u540C\u5024\u306E\u9806\
    \u5E8F\u306F\u4E0D\u5B9A\u3002\n        data: seq[T]\n\n    proc initDoubleEndedPriorityQueue*[T]():\
    \ DoubleEndedPriorityQueue[T] =\n        ## \u7A7A\u306E\u30AD\u30E5\u30FC\u3092\
    \u4F5C\u308B\u3002\u5909\u6570\u306E\u5BA3\u8A00\u3060\u3051\u3067\u3082\u7A7A\
    \u306B\u521D\u671F\u5316\u3055\u308C\u308B\u3002O(1)\u3002\n        result = default(DoubleEndedPriorityQueue[T])\n\
    \n    proc len*[T](heap: DoubleEndedPriorityQueue[T]): int {.inline.} =\n    \
    \    ## \u8981\u7D20\u6570\u3092\u8FD4\u3059\u3002O(1)\u3002\n        heap.data.len\n\
    \n    proc isEmpty*[T](heap: DoubleEndedPriorityQueue[T]): bool {.inline.} =\n\
    \        ## \u7A7A\u304B\u3069\u3046\u304B\u3092\u8FD4\u3059\u3002O(1)\u3002\n\
    \        heap.len == 0\n\n    proc depqLess[T](a, b: T, minLevel: static bool):\
    \ bool {.inline.} =\n        ## \u5C64\u306B\u5FDC\u3058\u3066\u6700\u5C0F\u5074\
    \u307E\u305F\u306F\u6700\u5927\u5074\u3092\u512A\u5148\u3057\u3066\u6BD4\u8F03\
    \u3059\u308B\u3002O(1)\u3002\n        mixin `<`\n        when minLevel: a < b\n\
    \        else: b < a\n\n    proc depqMinLevel(index: int): bool {.inline.} =\n\
    \        ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u304C\u6700\u5C0F\u5024\u3092\
    \u512A\u5148\u3059\u308B\u5076\u6570\u5C64\u306B\u5C5E\u3059\u308B\u304B\u8FD4\
    \u3059\u3002O(1)\u3002\n        (fastLog2(index + 1) and 1) == 0\n\n    proc bubbleUp[T](heap:\
    \ var DoubleEndedPriorityQueue[T], index: int,\n            minLevel: static bool)\
    \ =\n        ## \u540C\u7A2E\u306E\u5C64\u306E\u7956\u7236\u3068\u6BD4\u8F03\u3057\
    \u306A\u304C\u3089\u4E0A\u306B\u79FB\u52D5\u3059\u308B\u3002O(log N)\u3002\n \
    \       var pos = index\n        while pos >= 3:\n            let grandparent\
    \ = (pos - 3) div 4\n            if not depqLess(heap.data[pos], heap.data[grandparent],\
    \ minLevel): break\n            swap(heap.data[pos], heap.data[grandparent])\n\
    \            pos = grandparent\n\n    proc trickleDown[T](heap: var DoubleEndedPriorityQueue[T],\
    \ index: int,\n            minLevel: static bool) =\n        ## \u5B50\u3068\u5B6B\
    \u3092\u6BD4\u8F03\u3057\u3066\u4E0B\u306B\u79FB\u52D5\u3057\u3001\u30D2\u30FC\
    \u30D7\u6761\u4EF6\u3092\u5FA9\u5143\u3059\u308B\u3002O(log N)\u3002\n       \
    \ var pos = index\n        while pos * 2 + 1 < heap.len:\n            let firstChild\
    \ = pos * 2 + 1\n            let firstGrandchild = pos * 4 + 3\n            var\
    \ best = firstChild\n            if firstChild + 1 < heap.len and\n          \
    \          depqLess(heap.data[firstChild + 1], heap.data[best], minLevel):\n \
    \               best = firstChild + 1\n            for child in firstGrandchild..<min(firstGrandchild\
    \ + 4, heap.len):\n                if depqLess(heap.data[child], heap.data[best],\
    \ minLevel):\n                    best = child\n            if not depqLess(heap.data[best],\
    \ heap.data[pos], minLevel): break\n            swap(heap.data[pos], heap.data[best])\n\
    \            if best < firstGrandchild: break\n            let parent = (best\
    \ - 1) div 2\n            if depqLess(heap.data[parent], heap.data[best], minLevel):\n\
    \                swap(heap.data[parent], heap.data[best])\n            pos = best\n\
    \n    proc toDoubleEndedPriorityQueue*[T](values: openArray[T]): DoubleEndedPriorityQueue[T]\
    \ =\n        ## \u914D\u5217\u306E\u8981\u7D20\u304B\u3089\u30AD\u30E5\u30FC\u3092\
    \u4F5C\u308B\u3002O(N)\u3002\n        result.data = @values\n        for i in\
    \ countdown(values.len div 2 - 1, 0):\n            if depqMinLevel(i): result.trickleDown(i,\
    \ true)\n            else: result.trickleDown(i, false)\n\n    proc push*[T](heap:\
    \ var DoubleEndedPriorityQueue[T], item: sink T) =\n        ## \u8981\u7D20\u3092\
    \u8FFD\u52A0\u3059\u308B\u3002\u511F\u5374 O(log N)\u3002\n        heap.data.add(item)\n\
    \        let pos = heap.len - 1\n        if pos == 0: return\n        let parent\
    \ = (pos - 1) div 2\n        if depqMinLevel(pos):\n            if depqLess(heap.data[parent],\
    \ heap.data[pos], true):\n                swap(heap.data[parent], heap.data[pos])\n\
    \                heap.bubbleUp(parent, false)\n            else:\n           \
    \     heap.bubbleUp(pos, true)\n        else:\n            if depqLess(heap.data[pos],\
    \ heap.data[parent], true):\n                swap(heap.data[parent], heap.data[pos])\n\
    \                heap.bubbleUp(parent, true)\n            else:\n            \
    \    heap.bubbleUp(pos, false)\n\n    proc maxIndex[T](heap: DoubleEndedPriorityQueue[T]):\
    \ int {.inline.} =\n        ## \u7A7A\u3067\u306A\u3044\u30AD\u30E5\u30FC\u306E\
    \u6700\u5927\u8981\u7D20\u306E\u6DFB\u5B57\u3092\u8FD4\u3059\u3002O(1)\u3002\n\
    \        if heap.len == 1: 0\n        elif heap.len == 2 or depqLess(heap.data[2],\
    \ heap.data[1], true): 1\n        else: 2\n\n    proc min*[T](heap: DoubleEndedPriorityQueue[T]):\
    \ lent T {.inline.} =\n        ## \u6700\u5C0F\u5024\u3092\u8FD4\u3059\u3002\u7A7A\
    \u306E\u30AD\u30E5\u30FC\u306B\u306F\u4F7F\u7528\u4E0D\u53EF\u3002O(1)\u3002\n\
    \        assert heap.len > 0, \"\u7A7A\u306E\u30AD\u30E5\u30FC\u306E\u6700\u5C0F\
    \u5024\u306F\u53C2\u7167\u3067\u304D\u307E\u305B\u3093\"\n        heap.data[0]\n\
    \n    proc max*[T](heap: DoubleEndedPriorityQueue[T]): lent T {.inline.} =\n \
    \       ## \u6700\u5927\u5024\u3092\u8FD4\u3059\u3002\u7A7A\u306E\u30AD\u30E5\u30FC\
    \u306B\u306F\u4F7F\u7528\u4E0D\u53EF\u3002O(1)\u3002\n        assert heap.len\
    \ > 0, \"\u7A7A\u306E\u30AD\u30E5\u30FC\u306E\u6700\u5927\u5024\u306F\u53C2\u7167\
    \u3067\u304D\u307E\u305B\u3093\"\n        heap.data[heap.maxIndex()]\n\n    proc\
    \ popMin*[T](heap: var DoubleEndedPriorityQueue[T]): T =\n        ## \u6700\u5C0F\
    \u5024\u3092\u53D6\u308A\u9664\u3044\u3066\u8FD4\u3059\u3002\u7A7A\u306E\u30AD\
    \u30E5\u30FC\u306B\u306F\u4F7F\u7528\u4E0D\u53EF\u3002O(log N)\u3002\n       \
    \ assert heap.len > 0, \"\u7A7A\u306E\u30AD\u30E5\u30FC\u304B\u3089\u306F\u524A\
    \u9664\u3067\u304D\u307E\u305B\u3093\"\n        result = heap.data[0]\n      \
    \  let last = heap.data.pop()\n        if heap.len > 0:\n            heap.data[0]\
    \ = last\n            heap.trickleDown(0, true)\n\n    proc popMax*[T](heap: var\
    \ DoubleEndedPriorityQueue[T]): T =\n        ## \u6700\u5927\u5024\u3092\u53D6\
    \u308A\u9664\u3044\u3066\u8FD4\u3059\u3002\u7A7A\u306E\u30AD\u30E5\u30FC\u306B\
    \u306F\u4F7F\u7528\u4E0D\u53EF\u3002O(log N)\u3002\n        assert heap.len >\
    \ 0, \"\u7A7A\u306E\u30AD\u30E5\u30FC\u304B\u3089\u306F\u524A\u9664\u3067\u304D\
    \u307E\u305B\u3093\"\n        let index = heap.maxIndex()\n        result = heap.data[index]\n\
    \        let last = heap.data.pop()\n        if index < heap.len:\n          \
    \  heap.data[index] = last\n            heap.trickleDown(index, false)\n\n   \
    \ proc clear*[T](heap: var DoubleEndedPriorityQueue[T]) =\n        ## \u5168\u8981\
    \u7D20\u3092\u524A\u9664\u3059\u308B\u3002\u8981\u7D20\u306E\u7834\u68C4\u3092\
    \u542B\u3081\u3066 O(N)\u3002\n        heap.data.setLen(0)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/double_ended_priority_queue.nim
  requiredBy: []
  timestamp: '2026-09-30 06:04:26+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/double_ended_priority_queue_test.nim
  - verify/collections/double_ended_priority_queue_test.nim
  - verify/collections/double_ended_priority_queue_random_test.nim
  - verify/collections/double_ended_priority_queue_random_test.nim
documentation_of: cplib/collections/double_ended_priority_queue.nim
layout: document
redirect_from:
- /library/cplib/collections/double_ended_priority_queue.nim
- /library/cplib/collections/double_ended_priority_queue.nim.html
title: cplib/collections/double_ended_priority_queue.nim
---
