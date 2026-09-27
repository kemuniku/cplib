---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_retroactive_priority_queue.nim
    title: cplib/collections/compressed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_retroactive_priority_queue.nim
    title: cplib/collections/compressed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue.nim
    title: cplib/collections/dynamic_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
    title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
    title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/indexed_retroactive_priority_queue.nim
    title: cplib/collections/indexed_retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/indexed_retroactive_priority_queue.nim
    title: cplib/collections/indexed_retroactive_priority_queue.nim
  - icon: ':warning:'
    path: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - icon: ':warning:'
    path: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - icon: ':warning:'
    path: verify/collections/retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/retroactive_priority_queue_abc363g_test_.nim
  - icon: ':warning:'
    path: verify/collections/retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/retroactive_priority_queue_abc363g_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
    title: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
    title: verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dynamic_retroactive_priority_queue_test.nim
    title: verify/collections/dynamic_retroactive_priority_queue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dynamic_retroactive_priority_queue_test.nim
    title: verify/collections/dynamic_retroactive_priority_queue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/indexed_retroactive_priority_queue_test.nim
    title: verify/collections/indexed_retroactive_priority_queue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/indexed_retroactive_priority_queue_test.nim
    title: verify/collections/indexed_retroactive_priority_queue_test.nim
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
  code: "## poppedSum\u306F\u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067pop\u3055\u308C\
    \u305F\u5024\u306E\u7DCF\u548C\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002sum\u306F\
    \u6B8B\u5B58\u5024\u306E\u7DCF\u548C\u3067\u3059\u3002\n## \u30C7\u30D0\u30C3\u30B0\
    : debugOperations()\u306F\u64CD\u4F5C\u4E00\u89A7\u3001debugTimeline()\u306F\u518D\
    \u5B9F\u884C\u3057\u305Fpop\u7D50\u679C\u4ED8\u304D\u4E00\u89A7\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n## \u4E00\u89A7\u306F\u6642\u523B\u9806\u3067\u3059\u3002\
    echo pq \u307E\u305F\u306F echo pq.debugDump() \u3067pop\u5143\u306E\u6642\u523B\
    \u3082\u542B\u3081\u3066\u8868\u793A\u3067\u304D\u307E\u3059\u3002\n## \u30C7\u30D0\
    \u30C3\u30B0\u7D50\u679C\u306E\u578BQueueDebugEntry\u3068\u5217\u6319\u5024qdkNone/qdkPush/qdkPop\u306F\
    retroactive_priority_queue\u3067\u5B9A\u7FA9\u3057\u307E\u3059\u3002\n## \u904E\
    \u53BB\u306Epush/pop\u3092\u7DE8\u96C6\u3057\u3001\u5168\u64CD\u4F5C\u306E\u5B9F\
    \u884C\u5F8C\u306E\u30AD\u30E5\u30FC\u3092\u7BA1\u7406\u3057\u307E\u3059\u3002\
    \n## \u5404\u66F4\u65B0\u306F\u6700\u60AAO(log N)\u3001len\u30FBsum\u30FBpeek\u30FB\
    isRemaining\u306FO(1)\u3001\u69CB\u7BC9\u3068\u7A7A\u9593\u306FO(N)\u3067\u3059\
    \u3002\n## sum\u306FSomeNumber\u306B\u5BFE\u5FDC\u3057\u3001\u5024\u3068\u540C\
    \u3058\u578B\u3067\u52A0\u6E1B\u7B97\u3059\u308B\u305F\u3081\u3001\u5341\u5206\
    \u306A\u5E45\u306E\u578B\u3092\u6307\u5B9A\u3057\u3066\u304F\u3060\u3055\u3044\
    \u3002\n## \u66F4\u65B0\u304C\u8FD4\u3059QueueDelta\u306F\u7121\u8996\u3067\u304D\
    \u307E\u3059\u3002\u4EFB\u610F\u578B\u306E\u96C6\u8A08\u306F\u3053\u306E\u5DEE\
    \u5206\u304B\u3089\u66F4\u65B0\u3067\u304D\u307E\u3059\u3002\n## \u904E\u53BB\u306E\
    \u5404pop\u306E\u8FD4\u308A\u5024\u3084\u3001\u9014\u4E2D\u306E\u6642\u523B\u306B\
    \u304A\u3051\u308B\u30AD\u30E5\u30FC\u306E\u72B6\u614B\u306F\u7BA1\u7406\u3057\
    \u307E\u305B\u3093\u3002\n##\n## .. code-block:: nim\n##   import options\n##\
    \   import cplib/collections/retroactive_priority_queue\n##   var pq = initRetroactivePriorityQueue[int64](3)\n\
    ##   pq.setPush(0, 5)\n##   pq.setPop(2)\n##   pq.setPush(1, 2)\n##   assert pq.sum\
    \ == 5\n##   assert pq.peek() == some(5'i64)\n##   pq.erase(2)\n##   assert pq.sum\
    \ == 7\n\nwhen not declared CPLIB_COLLECTIONS_RETROACTIVE_PRIORITY_QUEUE:\n  \
    \  const CPLIB_COLLECTIONS_RETROACTIVE_PRIORITY_QUEUE* = 1\n    import algorithm,\
    \ options\n\n    type\n        QueueDebugKind* = enum\n            qdkNone, qdkPush,\
    \ qdkPop\n        QueueDebugEntry*[K, T] = object\n            ## value\u306F\
    push\u306E\u5024\u3001popped\u306Fpop\u3055\u308C\u305F\u8981\u7D20\u306E\u5143\
    \u306Epush\u6642\u523B\u3068\u5024\u3067\u3059\u3002\n            ## \u7A7A\u3078\
    \u306Epop\u306Epopped\u306Fnone\u3067\u3059\u3002debugOperations\u3067\u306Fpopped\u306F\
    \u5E38\u306Bnone\u3067\u3059\u3002\n            time*: K\n            kind*: QueueDebugKind\n\
    \            value*: Option[T]\n            popped*: Option[tuple[time: K, value:\
    \ T]]\n        QueueDebugHeapItem[T] = object\n            index: int\n      \
    \      value: T\n            order: SortOrder\n        QueueDelta*[K, T] = object\n\
    \            ## \u6700\u7D42\u72B6\u614B\u306E\u5DEE\u5206\u3067\u3059\u3002removed\u3092\
    \u524A\u9664\u3057\u3066\u304B\u3089added\u3092\u8FFD\u52A0\u3057\u3066\u304F\u3060\
    \u3055\u3044\u3002\n            ## \u540C\u3058\u6642\u523B\u306E\u5024\u306E\u4E0A\
    \u66F8\u304D\u3067\u306F\u3001\u5909\u66F4\u524D\u3068\u5909\u66F4\u5F8C\u306E\
    \u5024\u3092\u305D\u308C\u305E\u308C\u542B\u307F\u307E\u3059\u3002\n         \
    \   added*, removed*: seq[tuple[time: K, value: T]]\n        RetroactiveOperation\
    \ = enum\n            rqNone, rqPush, rqPop\n        RetroactiveNode = object\n\
    \            # \u524A\u9664\u6E08\u307Fpush\u3092+1\u3001pop\u3092-1\u3001\u6B8B\
    \u5B58push\u30920\u3068\u3057\u305F\u975E\u7A7A\u63A5\u982D\u8F9E\u306E\u6700\u5C0F\
    \u548C\u3067\u3059\u3002\n            # \u5168\u4F53\u306E\u7D2F\u7A4D\u548C\u306F\
    \u5E38\u306B\u975E\u8CA0\u3067\u30010\u306E\u5883\u754C\u3067\u306F\u5C06\u6765\
    \u6D88\u3048\u308B\u8981\u7D20\u304C\u30AD\u30E5\u30FC\u5185\u306B\u3042\u308A\
    \u307E\u305B\u3093\u3002\n            balance, minPrefix: int\n            remaining,\
    \ removed: int\n        RetroactivePriorityQueue*[T] = ref object\n          \
    \  capacity, size, count, dummyRemoved: int\n            order: SortOrder\n  \
    \          operations: seq[RetroactiveOperation]\n            values: seq[T]\n\
    \            remaining: seq[bool]\n            tree: seq[RetroactiveNode]\n  \
    \          when T is SomeNumber:\n                total, pushTotal: T\n\n    proc\
    \ before[T](self: RetroactivePriorityQueue[T], a, b: int): bool {.inline.} =\n\
    \        ## \u8981\u7D20a\u304Cb\u3088\u308A\u5148\u306B\u53D6\u308A\u51FA\u3055\
    \u308C\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        mixin\
    \ `<`\n        if a == 0: return false\n        if b == 0: return true\n     \
    \   if self.values[a] < self.values[b]: return self.order == Ascending\n     \
    \   if self.values[b] < self.values[a]: return self.order == Descending\n    \
    \    a < b\n\n    proc choose[T](self: RetroactivePriorityQueue[T], a, b: int,\n\
    \            remaining: bool): int {.inline.} =\n        ## \u6B8B\u5B58\u8981\
    \u7D20\u306E\u6700\u512A\u5148\u3001\u307E\u305F\u306F\u524A\u9664\u6E08\u307F\
    \u8981\u7D20\u306E\u6700\u4F4E\u512A\u5148\u3092\u9078\u3073\u307E\u3059\u3002\
    O(1)\u3002\n        if a < 0: return b\n        if b < 0: return a\n        if\
    \ self.before(a, b) == remaining: a else: b\n\n    proc pull[T](self: RetroactivePriorityQueue[T],\
    \ i: int) {.inline.} =\n        ## \u5B50\u306E\u96C6\u7D04\u5024\u304B\u3089\u7BC0\
    \u70B9\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n        let a = self.tree[i\
    \ * 2]\n        let b = self.tree[i * 2 + 1]\n        self.tree[i] = RetroactiveNode(\n\
    \            balance: a.balance + b.balance,\n            minPrefix: min(a.minPrefix,\
    \ a.balance + b.minPrefix),\n            remaining: self.choose(a.remaining, b.remaining,\
    \ true),\n            removed: self.choose(a.removed, b.removed, false))\n\n \
    \   proc refresh[T](self: RetroactivePriorityQueue[T], t: int) =\n        ## \u6642\
    \u523Bt\u306E\u72B6\u614B\u3092\u30BB\u30B0\u30E1\u30F3\u30C8\u6728\u306B\u53CD\
    \u6620\u3057\u307E\u3059\u3002O(log N)\u3002\n        var node = RetroactiveNode(remaining:\
    \ -1, removed: -1)\n        if t == 0:\n            node.balance = self.dummyRemoved\n\
    \            if self.dummyRemoved < self.capacity: node.remaining = 0\n      \
    \      if self.dummyRemoved > 0: node.removed = 0\n        elif self.operations[t]\
    \ == rqPush:\n            if self.remaining[t]: node.remaining = t\n         \
    \   else:\n                node.removed = t\n                node.balance = 1\n\
    \        elif self.operations[t] == rqPop:\n            node.balance = -1\n  \
    \      node.minPrefix = node.balance\n        var i = self.size + t\n        self.tree[i]\
    \ = node\n        while i > 1:\n            i = i shr 1\n            self.pull(i)\n\
    \n    proc initRetroactivePriorityQueue*[T](n: int,\n            order = Ascending):\
    \ RetroactivePriorityQueue[T] =\n        ## \u6642\u523B0..<n\u304C\u3059\u3079\
    \u3066\u7A7A\u64CD\u4F5C\u306E\u30AD\u30E5\u30FC\u3092O(n)\u6642\u9593\u30FB\u7A7A\
    \u9593\u3067\u751F\u6210\u3057\u307E\u3059\u3002\n        ## Ascending\u306Fpop\
    \ min\u3001Descending\u306Fpop max\u3067\u3059\u3002\u7A7A\u3078\u306Epop\u306F\
    \u7121\u8996\u3057\u307E\u3059\u3002\n        ## T\u306B\u306F\u4E00\u8CAB\u3057\
    \u305F < \u304C\u5FC5\u8981\u3067\u3059\u3002\u540C\u5024\u306A\u3089\u65E9\u3044\
    \u6642\u523B\u306Epush\u3092\u5148\u306B\u53D6\u308A\u51FA\u3057\u307E\u3059\u3002\
    \n        assert n >= 0, \"\u6642\u523B\u6570\u306F\u975E\u8CA0\u306B\u3057\u3066\
    \u304F\u3060\u3055\u3044\"\n        var size = 1\n        while size < n + 1:\
    \ size *= 2\n        result = RetroactivePriorityQueue[T](capacity: n, size: size,\
    \ order: order,\n            operations: newSeq[RetroactiveOperation](n + 1),\
    \ values: newSeq[T](n + 1),\n            remaining: newSeq[bool](n + 1), tree:\
    \ newSeq[RetroactiveNode](size * 2))\n        for node in result.tree.mitems:\n\
    \            node.remaining = -1\n            node.removed = -1\n        # \u5168\
    \u5B9F\u8981\u7D20\u3088\u308A\u512A\u5148\u5EA6\u304C\u4F4E\u3044n\u500B\u306E\
    \u756A\u5175\u3092\u6642\u523B0\u306B\u307E\u3068\u3081\u3001\u7A7A\u3078\u306E\
    pop\u3092\u5438\u53CE\u3057\u307E\u3059\u3002\n        result.refresh(0)\n\n \
    \   proc findBridge[T](self: RetroactivePriorityQueue[T], node, l, r,\n      \
    \      t, prefix: int, first: bool): int =\n        ## \u6642\u523Bt\u306E\u524D\
    \u5F8C\u3067\u7D2F\u7A4D\u548C\u304C0\u306B\u306A\u308B\u6700\u5BC4\u308A\u306E\
    \u5883\u754C\u3092\u63A2\u7D22\u3057\u307E\u3059\u3002O(log N)\u3002\n       \
    \ if first:\n            if r < t: return -1\n        elif l >= t:\n         \
    \   return -1\n        if prefix + self.tree[node].minPrefix > 0: return -1\n\
    \        if r - l == 1: return r\n        let m = (l + r) shr 1\n        let rightPrefix\
    \ = prefix + self.tree[node * 2].balance\n        if first:\n            result\
    \ = self.findBridge(node * 2, l, m, t, prefix, first)\n            if result <\
    \ 0:\n                result = self.findBridge(node * 2 + 1, m, r, t, rightPrefix,\
    \ first)\n        else:\n            result = self.findBridge(node * 2 + 1, m,\
    \ r, t, rightPrefix, first)\n            if result < 0:\n                result\
    \ = self.findBridge(node * 2, l, m, t, prefix, first)\n\n    proc previousBridge[T](self:\
    \ RetroactivePriorityQueue[T], t: int): int =\n        ## t\u4EE5\u4E0B\u3067\u7D2F\
    \u7A4D\u548C\u304C0\u306B\u306A\u308B\u6700\u5F8C\u306E\u5883\u754C\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(log N)\u3002\n        max(0, self.findBridge(1, 0, self.size,\
    \ t, 0, false))\n\n    proc nextBridge[T](self: RetroactivePriorityQueue[T], t:\
    \ int): int =\n        ## t\u4EE5\u4E0A\u3067\u7D2F\u7A4D\u548C\u304C0\u306B\u306A\
    \u308B\u6700\u521D\u306E\u5883\u754C\u3092\u8FD4\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        self.findBridge(1, 0, self.size, t, 0, true)\n\n    proc candidate[T](self:\
    \ RetroactivePriorityQueue[T], left, right: int,\n            remaining: bool):\
    \ int =\n        ## \u534A\u958B\u533A\u9593\u306E\u6B8B\u5B58\u6700\u512A\u5148\
    \u8981\u7D20\u307E\u305F\u306F\u524A\u9664\u6E08\u307F\u6700\u4F4E\u512A\u5148\
    \u8981\u7D20\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        var l\
    \ = left + self.size\n        var r = right + self.size\n        result = -1\n\
    \        while l < r:\n            if (l and 1) != 0:\n                let x =\
    \ if remaining: self.tree[l].remaining else: self.tree[l].removed\n          \
    \      result = self.choose(result, x, remaining)\n                inc l\n   \
    \         if (r and 1) != 0:\n                dec r\n                let x = if\
    \ remaining: self.tree[r].remaining else: self.tree[r].removed\n             \
    \   result = self.choose(result, x, remaining)\n            l = l shr 1\n    \
    \        r = r shr 1\n\n    proc changeRemaining[T](self: RetroactivePriorityQueue[T],\
    \ t: int,\n            remains: bool, delta: var QueueDelta[int, T]) =\n     \
    \   ## \u6700\u7D42\u72B6\u614B\u3078\u306E\u51FA\u5165\u308A\u3092\u5DEE\u5206\
    \u30FB\u7DCF\u548C\u30FB\u63A2\u7D22\u6728\u306B\u53CD\u6620\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        if t == 0:\n            self.dummyRemoved += (if\
    \ remains: -1 else: 1)\n        else:\n            self.remaining[t] = remains\n\
    \            let entry = (time: t - 1, value: self.values[t])\n            if\
    \ remains:\n                inc self.count\n                when T is SomeNumber:\
    \ self.total += self.values[t]\n                delta.added.add(entry)\n     \
    \       else:\n                dec self.count\n                when T is SomeNumber:\
    \ self.total -= self.values[t]\n                var transient = -1\n         \
    \       for i, added in delta.added:\n                    if added.time == entry.time:\
    \ transient = i\n                if transient >= 0: delta.added.delete(transient)\n\
    \                else: delta.removed.add(entry)\n        self.refresh(t)\n\n \
    \   proc eraseOperation[T](self: RetroactivePriorityQueue[T], t: int,\n      \
    \      delta: var QueueDelta[int, T]) =\n        ## \u5185\u90E8\u6642\u523Bt\u306E\
    \u64CD\u4F5C\u3092\u524A\u9664\u3057\u3001\u6700\u7D42\u72B6\u614B\u3092\u66F4\
    \u65B0\u3057\u307E\u3059\u3002O(log N)\u3002\n        case self.operations[t]\n\
    \        of rqNone:\n            return\n        of rqPush:\n            when\
    \ T is SomeSignedInt: self.pushTotal = self.pushTotal -% self.values[t]\n    \
    \        elif T is SomeNumber: self.pushTotal -= self.values[t]\n            if\
    \ self.remaining[t]:\n                self.changeRemaining(t, false, delta)\n\
    \            else:\n                let bridge = self.nextBridge(t + 1)\n    \
    \            let x = self.candidate(0, bridge, true)\n                self.changeRemaining(x,\
    \ false, delta)\n        of rqPop:\n            let bridge = self.previousBridge(t)\n\
    \            let x = self.candidate(bridge, self.capacity + 1, false)\n      \
    \      self.changeRemaining(x, true, delta)\n        self.operations[t] = rqNone\n\
    \        self.values[t] = default(T)\n        self.refresh(t)\n\n    proc erase*[T](self:\
    \ RetroactivePriorityQueue[T], t: int): QueueDelta[int, T] {.discardable.} =\n\
    \        ## \u6642\u523Bt\u306E\u64CD\u4F5C\u3092\u4F55\u3082\u3057\u306A\u3044\
    \u64CD\u4F5C\u306B\u5909\u66F4\u3057\u3001\u6700\u7D42\u72B6\u614B\u306E\u5DEE\
    \u5206\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        assert 0 <=\
    \ t and t < self.capacity, \"\u6642\u523B\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\
    \n        self.eraseOperation(t + 1, result)\n\n    proc setPush*[T](self: RetroactivePriorityQueue[T],\
    \ t: int,\n            value: T): QueueDelta[int, T] {.discardable.} =\n     \
    \   ## \u6642\u523Bt\u306E\u64CD\u4F5C\u3092push(value)\u3067\u4E0A\u66F8\u304D\
    \u3057\u3001\u6700\u7D42\u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        assert 0 <= t and t < self.capacity, \"\u6642\
    \u523B\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        let i = t + 1\n        self.eraseOperation(i,\
    \ result)\n        let bridge = self.previousBridge(i)\n        let x = self.candidate(bridge,\
    \ self.capacity + 1, false)\n        self.operations[i] = rqPush\n        self.values[i]\
    \ = value\n        when T is SomeSignedInt: self.pushTotal = self.pushTotal +%\
    \ value\n        elif T is SomeNumber: self.pushTotal += value\n        if x <\
    \ 0 or self.before(x, i):\n            self.changeRemaining(i, true, result)\n\
    \        else:\n            self.remaining[i] = false\n            self.refresh(i)\n\
    \            self.changeRemaining(x, true, result)\n\n    proc setPop*[T](self:\
    \ RetroactivePriorityQueue[T], t: int): QueueDelta[int, T] {.discardable.} =\n\
    \        ## \u6642\u523Bt\u306E\u64CD\u4F5C\u3092pop\u3067\u4E0A\u66F8\u304D\u3057\
    \u3001\u6700\u7D42\u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        assert 0 <= t and t < self.capacity, \"\u6642\u523B\
    \u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        let i = t + 1\n        if self.operations[i]\
    \ == rqPop: return\n        self.eraseOperation(i, result)\n        let bridge\
    \ = self.nextBridge(i)\n        let x = self.candidate(0, bridge, true)\n    \
    \    self.changeRemaining(x, false, result)\n        self.operations[i] = rqPop\n\
    \        self.refresh(i)\n\n    proc len*[T](self: RetroactivePriorityQueue[T]):\
    \ int =\n        ## \u5168\u64CD\u4F5C\u306E\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\
    \u5B9F\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   self.count\n\n    proc sum*[T: SomeNumber](self: RetroactivePriorityQueue[T]):\
    \ T =\n        ## \u5168\u64CD\u4F5C\u306E\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\
    \u5024\u306E\u7DCF\u548C\u3092T\u578B\u3067\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        self.total\n\n    proc peek*[T](self: RetroactivePriorityQueue[T]):\
    \ Option[T] =\n        ## \u6700\u7D42\u72B6\u614B\u306E\u6700\u512A\u5148\u8981\
    \u7D20\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\u3089none\u3067\u3059\u3002\
    O(1)\u3002\n        let i = self.tree[1].remaining\n        if i <= 0: none(T)\n\
    \        else: some(self.values[i])\n\n    proc isRemaining*[T](self: RetroactivePriorityQueue[T],\
    \ t: int): bool =\n        ## \u6642\u523Bt\u3067push\u3057\u305F\u8981\u7D20\u304C\
    \u6700\u5F8C\u306B\u6B8B\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002push\u4EE5\
    \u5916\u306Ffalse\u3067\u3059\u3002O(1)\u3002\n        assert 0 <= t and t < self.capacity,\
    \ \"\u6642\u523B\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        self.operations[t\
    \ + 1] == rqPush and self.remaining[t + 1]\n\n    proc debugHeapBefore[T](a, b:\
    \ QueueDebugHeapItem[T]): bool =\n        ## \u30C7\u30D0\u30C3\u30B0\u518D\u5B9F\
    \u884C\u7528\u306E\u512A\u5148\u5EA6\u3092\u6BD4\u8F03\u3057\u307E\u3059\u3002\
    \u540C\u5024\u306A\u3089\u65E9\u3044push\u3092\u512A\u5148\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        mixin `<`\n        if a.value < b.value: return a.order ==\
    \ Ascending\n        if b.value < a.value: return a.order == Descending\n    \
    \    a.index < b.index\n\n    proc replayQueueDebug*[K, T](entries: var seq[QueueDebugEntry[K,\
    \ T]], order: SortOrder) =\n        ## \u6642\u523B\u9806\u306E\u64CD\u4F5C\u5217\
    \u3092\u518D\u5B9F\u884C\u3057\u3001popped\u3092\u57CB\u3081\u307E\u3059\u3002\
    O(N log(N+2))\u6642\u9593\u30FBO(N)\u8FFD\u52A0\u7A7A\u9593\u3002\n        ##\
    \ \u5404\u7248\u306EdebugTimeline\u3067\u5171\u7528\u3057\u307E\u3059\u3002\u5143\
    \u306E\u30AD\u30E5\u30FC\u306F\u5909\u66F4\u3057\u307E\u305B\u3093\u3002\n   \
    \     var heap: seq[QueueDebugHeapItem[T]]\n        for i in 0..<entries.len:\n\
    \            entries[i].popped = none(tuple[time: K, value: T])\n            case\
    \ entries[i].kind\n            of qdkNone: discard\n            of qdkPush:\n\
    \                heap.add(QueueDebugHeapItem[T](index: i, value: entries[i].value.get,\
    \ order: order))\n                var child = heap.high\n                while\
    \ child > 0:\n                    let parent = (child - 1) div 2\n           \
    \         if not debugHeapBefore(heap[child], heap[parent]): break\n         \
    \           swap(heap[child], heap[parent])\n                    child = parent\n\
    \            of qdkPop:\n                if heap.len > 0:\n                  \
    \  let item = heap[0]\n                    let last = heap.pop()\n           \
    \         if heap.len > 0:\n                        heap[0] = last\n         \
    \               var parent = 0\n                        while parent * 2 + 1 <\
    \ heap.len:\n                            var child = parent * 2 + 1\n        \
    \                    if child + 1 < heap.len and debugHeapBefore(heap[child +\
    \ 1], heap[child]): inc child\n                            if not debugHeapBefore(heap[child],\
    \ heap[parent]): break\n                            swap(heap[child], heap[parent])\n\
    \                            parent = child\n                    entries[i].popped\
    \ = some((time: entries[item.index].time, value: item.value))\n\n    proc debugOperations*[T](self:\
    \ RetroactivePriorityQueue[T]): seq[QueueDebugEntry[int, T]] =\n        ## \u5168\
    \u30B9\u30ED\u30C3\u30C8\u306E\u64CD\u4F5C\u3092\u6642\u523B\u9806\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\u7A7A\u64CD\u4F5C\u3082\u542B\u307F\u3001pop\u7D50\u679C\
    \u306F\u672A\u8A08\u7B97\u3067\u3059\u3002O(N)\u3002\n        for t in 0..<self.capacity:\n\
    \            var entry = QueueDebugEntry[int, T](time: t)\n            case self.operations[t\
    \ + 1]\n            of rqNone: entry.kind = qdkNone\n            of rqPush:\n\
    \                entry.kind = qdkPush\n                entry.value = some(self.values[t\
    \ + 1])\n            of rqPop: entry.kind = qdkPop\n            result.add(entry)\n\
    \n    proc debugTimeline*[T](self: RetroactivePriorityQueue[T]): seq[QueueDebugEntry[int,\
    \ T]] =\n        ## \u5168\u64CD\u4F5C\u3068\u5B9F\u969B\u306Epop\u7D50\u679C\u3092\
    \u6642\u523B\u9806\u3067\u8FD4\u3057\u307E\u3059\u3002O(N log(N+2))\u6642\u9593\
    \u30FBO(N)\u7A7A\u9593\u3002\n        result = self.debugOperations()\n      \
    \  replayQueueDebug(result, self.order)\n\n    proc formatQueueDebug*[K, T](entries:\
    \ openArray[QueueDebugEntry[K, T]]): string =\n        ## \u30C7\u30D0\u30C3\u30B0\
    \u4E00\u89A7\u3092\u4E00\u64CD\u4F5C\u4E00\u884C\u306B\u6574\u5F62\u3057\u307E\
    \u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593\u306F\u51FA\u529B\u6587\u5B57\u6570\
    \u306B\u6BD4\u4F8B\u3057\u307E\u3059\u3002\n        mixin `$`\n        for i,\
    \ entry in entries:\n            if i > 0: result.add(\"\\n\")\n            result.add($entry.time\
    \ & \": \")\n            case entry.kind\n            of qdkNone: result.add(\"\
    noop\")\n            of qdkPush: result.add(\"push(\" & $entry.value.get & \"\
    )\")\n            of qdkPop:\n                if entry.popped.isNone: result.add(\"\
    pop -> empty\")\n                else:\n                    let popped = entry.popped.get\n\
    \                    result.add(\"pop -> \" & $popped.value & \" (push at \" &\
    \ $popped.time & \")\")\n\n    proc debugDump*[T](self: RetroactivePriorityQueue[T]):\
    \ string =\n        ## \u64CD\u4F5C\u3068\u5B9F\u969B\u306Epop\u7D50\u679C\u3092\
    \u8868\u793A\u7528\u6587\u5B57\u5217\u3067\u8FD4\u3057\u307E\u3059\u3002O(N log(N+2)+\u51FA\
    \u529B\u6587\u5B57\u6570)\u3002\n        formatQueueDebug(self.debugTimeline())\n\
    \n    proc `$`*[T](self: RetroactivePriorityQueue[T]): string =\n        ## debugDump\u3068\
    \u540C\u3058\u64CD\u4F5C\u30FBpop\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(N log(N+2)+\u51FA\u529B\u6587\u5B57\u6570)\u3002\n        self.debugDump()\n\
    \n    proc poppedSum*[T: SomeNumber](self: RetroactivePriorityQueue[T]): T =\n\
    \        ## \u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067pop\u3055\u308C\u308B\u5024\
    \u306E\u7DCF\u548C\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u3078\u306Epop\u306F\
    0\u3068\u3057\u3066\u6271\u3044\u307E\u3059\u3002O(1)\u3002\n        ## \u6574\
    \u6570\u306F\u7D50\u679C\u304C\u578B\u306B\u53CE\u307E\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059\u3002\u5185\u90E8\u306E\u5168push\u7DCF\u548C\u306F\u6841\
    \u3042\u3075\u308C\u3092\u8A31\u5BB9\u3057\u307E\u3059\u3002\n        ## \u6D6E\
    \u52D5\u5C0F\u6570\u70B9\u306F\u5168push\u7DCF\u548C\u304B\u3089\u6B8B\u5B58\u7DCF\
    \u548C\u3092\u5F15\u304F\u305F\u3081\u3001\u6841\u843D\u3061\u304C\u751F\u3058\
    \u308B\u5834\u5408\u304C\u3042\u308A\u307E\u3059\u3002\n        when T is SomeSignedInt:\
    \ self.pushTotal -% self.total\n        else: self.pushTotal - self.total\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/retroactive_priority_queue.nim
  requiredBy:
  - verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - verify/collections/retroactive_priority_queue_abc363g_test_.nim
  - verify/collections/retroactive_priority_queue_abc363g_test_.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/compressed_retroactive_priority_queue.nim
  - cplib/collections/indexed_retroactive_priority_queue.nim
  - cplib/collections/indexed_retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/indexed_retroactive_priority_queue_test.nim
  - verify/collections/indexed_retroactive_priority_queue_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - verify/collections/retroactive_priority_queue_test.nim
  - verify/collections/retroactive_priority_queue_test.nim
  - verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_test.nim
documentation_of: cplib/collections/retroactive_priority_queue.nim
layout: document
redirect_from:
- /library/cplib/collections/retroactive_priority_queue.nim
- /library/cplib/collections/retroactive_priority_queue.nim.html
title: cplib/collections/retroactive_priority_queue.nim
---
