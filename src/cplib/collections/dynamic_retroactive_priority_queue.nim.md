---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
    title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
    title: cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - icon: ':warning:'
    path: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - icon: ':warning:'
    path: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
    title: verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
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
    retroactive_priority_queue\u3067\u5B9A\u7FA9\u3057\u307E\u3059\u3002\n## \u4EFB\
    \u610F\u306E\u6BD4\u8F03\u53EF\u80FD\u306A\u6642\u523B\u306Bpush/pop\u3092\u633F\
    \u5165\u30FB\u4E0A\u66F8\u304D\u30FB\u524A\u9664\u3067\u304D\u307E\u3059\u3002\
    \u6642\u523B\u306E\u4E8B\u524D\u767B\u9332\u306F\u4E0D\u8981\u3067\u3059\u3002\
    \n## M\u3092\u767B\u9332\u4E2D\u306E\u64CD\u4F5C\u6570\u3068\u3057\u3066\u3001\
    \u66F4\u65B0\u306F\u511F\u5374O(log(M+2))\u3001isRemaining\u306F\u6700\u60AAO(log(M+2))\u3067\
    \u3059\u3002\n## AVL\u6728\u306E\u51E6\u7406\u81EA\u4F53\u306F\u6700\u60AAO(log(M+2))\u3067\
    \u3059\u304C\u3001\u7BC0\u70B9\u914D\u5217\u306E\u9818\u57DF\u62E1\u5F35\u306F\
    \u511F\u5374\u8A08\u7B97\u91CF\u3067\u3059\u3002\n## len\u30FBsum\u30FBpeek\u306F\
    O(1)\u3002\u9818\u57DF\u306F\u767B\u9332\u64CD\u4F5C\u6570\u306E\u904E\u53BB\u6700\
    \u5927\u5024\u306B\u6BD4\u4F8B\u3057\u3001\u524A\u9664\u3057\u305F\u9818\u57DF\
    \u306F\u518D\u5229\u7528\u3057\u307E\u3059\u3002\n## \u6642\u523B\u306F\u6607\u9806\
    \u306B\u5B9F\u884C\u3057\u307E\u3059\u3002\u7A7A\u3078\u306Epop\u306F\u7121\u8996\
    \u3057\u3001\u540C\u5024\u306A\u3089\u65E9\u3044\u6642\u523B\u306Epush\u3092\u5148\
    \u306B\u53D6\u308A\u51FA\u3057\u307E\u3059\u3002\n## \u904E\u53BB\u306Epop\u306E\
    \u8FD4\u308A\u5024\u3084\u9014\u4E2D\u6642\u523B\u306E\u30AD\u30E5\u30FC\u306F\
    \u7BA1\u7406\u3057\u307E\u305B\u3093\u3002sum\u306B\u306F\u5341\u5206\u306A\u5E45\
    \u306E\u578B\u3092\u6307\u5B9A\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n##\n\
    ## .. code-block:: nim\n##   import options\n##   import cplib/collections/dynamic_retroactive_priority_queue\n\
    ##   let pq = initDynamicRetroactivePriorityQueue[int, int64]()\n##   pq.setPop(100)\n\
    ##   pq.setPush(30, 5)\n##   pq.setPush(-10, 2)\n##   assert pq.sum == 5\n## \
    \  pq.erase(100)\n##   assert pq.peek() == some(2'i64)\n\nwhen not declared CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE:\n\
    \    const CPLIB_COLLECTIONS_DYNAMIC_RETROACTIVE_PRIORITY_QUEUE* = 1\n    import\
    \ algorithm, options\n    import cplib/collections/retroactive_priority_queue\n\
    \n    type\n        DynamicRetroactiveOperation = enum\n            drqNone, drqPush,\
    \ drqPop\n        DynamicRetroactiveNode[K, T, S] = object\n            left,\
    \ right, height, size: int\n            time: K\n            value: T\n      \
    \      operation: DynamicRetroactiveOperation\n            remains: bool\n   \
    \         balance, minPrefix, remaining, removed: int\n            when S isnot\
    \ void:\n                mapped, aggregate: S\n        DynamicRetroactivePriorityQueue*[K,\
    \ T, S = void] = ref object\n            nodes: seq[DynamicRetroactiveNode[K,\
    \ T, S]]\n            free: seq[int]\n            root, count, dummyRemoved: int\n\
    \            order: SortOrder\n            when S is void:\n                when\
    \ T is SomeNumber:\n                    total, pushTotal: T\n            else:\n\
    \                op: proc(a, b: S): S\n                lift: proc(value: T): S\n\
    \                identity: S\n\n    proc before[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], a, b: int): bool =\n        ## \u8981\u7D20a\u3092b\u3088\u308A\u5148\
    \u306B\u53D6\u308A\u51FA\u3059\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        mixin `<`\n        if a == 1: return false\n        if b == 1: return\
    \ true\n        if self.nodes[a].value < self.nodes[b].value: return self.order\
    \ == Ascending\n        if self.nodes[b].value < self.nodes[a].value: return self.order\
    \ == Descending\n        self.nodes[a].time < self.nodes[b].time\n\n    proc choose[K,\
    \ T, S](self: DynamicRetroactivePriorityQueue[K, T, S], a, b: int,\n         \
    \   remaining: bool): int =\n        ## \u6B8B\u5B58\u6700\u512A\u5148\u307E\u305F\
    \u306F\u524A\u9664\u6E08\u307F\u6700\u4F4E\u512A\u5148\u306E\u5019\u88DC\u3092\
    \u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        if a == 0: return b\n      \
    \  if b == 0: return a\n        if self.before(a, b) == remaining: a else: b\n\
    \n    proc ownBalance[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],\
    \ i: int): int =\n        ## \u4E00\u64CD\u4F5C\u306E\u53CE\u652F\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(1)\u3002\n        if i == 1: self.dummyRemoved\n        elif\
    \ self.nodes[i].operation == drqPop: -1\n        elif self.nodes[i].operation\
    \ == drqPush and not self.nodes[i].remains: 1\n        else: 0\n\n    proc ownCandidate[K,\
    \ T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int,\n            remaining:\
    \ bool): int =\n        ## \u4E00\u64CD\u4F5C\u306E\u5019\u88DC\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\u756A\u5175\u306F\u7121\u9650\u500B\u306E\u4F4E\u512A\u5148\
    \u8981\u7D20\u3092\u8868\u3057\u307E\u3059\u3002O(1)\u3002\n        if i == 1:\n\
    \            if remaining or self.dummyRemoved > 0: return 1\n        elif self.nodes[i].operation\
    \ == drqPush and self.nodes[i].remains == remaining:\n            return i\n\n\
    \    proc pull[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int)\
    \ =\n        ## \u90E8\u5206\u6728\u306E\u9AD8\u3055\u30FB\u8981\u7D20\u6570\u30FB\
    \u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   let l = self.nodes[i].left\n        let r = self.nodes[i].right\n        let\
    \ mid = self.nodes[l].balance + self.ownBalance(i)\n        self.nodes[i].height\
    \ = max(self.nodes[l].height, self.nodes[r].height) + 1\n        self.nodes[i].size\
    \ = self.nodes[l].size + 1 + self.nodes[r].size\n        self.nodes[i].balance\
    \ = mid + self.nodes[r].balance\n        self.nodes[i].minPrefix = mid\n     \
    \   if l != 0: self.nodes[i].minPrefix = min(self.nodes[i].minPrefix, self.nodes[l].minPrefix)\n\
    \        if r != 0: self.nodes[i].minPrefix = min(self.nodes[i].minPrefix, mid\
    \ + self.nodes[r].minPrefix)\n        self.nodes[i].remaining = self.choose(self.choose(self.nodes[l].remaining,\n\
    \            self.ownCandidate(i, true), true), self.nodes[r].remaining, true)\n\
    \        self.nodes[i].removed = self.choose(self.choose(self.nodes[l].removed,\n\
    \            self.ownCandidate(i, false), false), self.nodes[r].removed, false)\n\
    \        when S isnot void:\n            let own = if i != 1 and self.nodes[i].operation\
    \ == drqPush and self.nodes[i].remains:\n                self.nodes[i].mapped\n\
    \            else:\n                self.identity\n            self.nodes[i].aggregate\
    \ = self.op(self.op(self.nodes[l].aggregate, own),\n                self.nodes[r].aggregate)\n\
    \n    proc rotateLeft[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],\
    \ i: int): int =\n        ## \u5DE6\u56DE\u8EE2\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        result = self.nodes[i].right\n        self.nodes[i].right = self.nodes[result].left\n\
    \        self.nodes[result].left = i\n        self.pull(i)\n        self.pull(result)\n\
    \n    proc rotateRight[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],\
    \ i: int): int =\n        ## \u53F3\u56DE\u8EE2\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        result = self.nodes[i].left\n        self.nodes[i].left = self.nodes[result].right\n\
    \        self.nodes[result].right = i\n        self.pull(i)\n        self.pull(result)\n\
    \n    proc rebalance[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],\
    \ i: int): int =\n        ## \u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u3001\
    AVL\u6728\u306E\u5E73\u8861\u3092\u4FDD\u3061\u307E\u3059\u3002O(1)\u3002\n  \
    \      self.pull(i)\n        let l = self.nodes[i].left\n        let r = self.nodes[i].right\n\
    \        if self.nodes[l].height > self.nodes[r].height + 1:\n            if self.nodes[self.nodes[l].left].height\
    \ < self.nodes[self.nodes[l].right].height:\n                self.nodes[i].left\
    \ = self.rotateLeft(l)\n            return self.rotateRight(i)\n        if self.nodes[r].height\
    \ > self.nodes[l].height + 1:\n            if self.nodes[self.nodes[r].right].height\
    \ < self.nodes[self.nodes[r].left].height:\n                self.nodes[i].right\
    \ = self.rotateRight(r)\n            return self.rotateLeft(i)\n        i\n\n\
    \    proc earlier[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], a,\
    \ b: int): bool =\n        ## \u756A\u5175\u3092\u6700\u5C0F\u3068\u3057\u3066\
    \u6642\u523B\u3092\u6BD4\u8F03\u3057\u307E\u3059\u3002O(1)\u3002\n        mixin\
    \ `<`\n        if a == 1: return b != 1\n        if b == 1: return false\n   \
    \     self.nodes[a].time < self.nodes[b].time\n\n    proc insertNode[K, T, S](self:\
    \ DynamicRetroactivePriorityQueue[K, T, S], root, i: int): int =\n        ## \u672A\
    \u767B\u9332\u306E\u7BC0\u70B9\u3092\u633F\u5165\u3057\u307E\u3059\u3002O(log\
    \ M)\u3002\n        if root == 0: return i\n        if self.earlier(i, root):\n\
    \            self.nodes[root].left = self.insertNode(self.nodes[root].left, i)\n\
    \        else:\n            self.nodes[root].right = self.insertNode(self.nodes[root].right,\
    \ i)\n        self.rebalance(root)\n\n    proc detachMin[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], root: int,\n            minimum: var int): int =\n        ## \u6700\u5C0F\
    \u7BC0\u70B9\u3092\u5207\u308A\u96E2\u3057\u3001\u6B8B\u308A\u306E\u6839\u3092\
    \u8FD4\u3057\u307E\u3059\u3002O(log M)\u3002\n        if self.nodes[root].left\
    \ == 0:\n            minimum = root\n            return self.nodes[root].right\n\
    \        self.nodes[root].left = self.detachMin(self.nodes[root].left, minimum)\n\
    \        self.rebalance(root)\n\n    proc deleteNode[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], root, i: int): int =\n        ## \u7BC0\u70B9ID\u3092\u5909\u3048\u305A\
    \u306B\u6307\u5B9A\u7BC0\u70B9\u3092\u524A\u9664\u3057\u307E\u3059\u3002O(log\
    \ M)\u3002\n        if root == i:\n            let l = self.nodes[root].left\n\
    \            let r = self.nodes[root].right\n            if l == 0: return r\n\
    \            if r == 0: return l\n            var successor: int\n           \
    \ let rest = self.detachMin(r, successor)\n            self.nodes[successor].left\
    \ = l\n            self.nodes[successor].right = rest\n            return self.rebalance(successor)\n\
    \        if self.earlier(i, root):\n            self.nodes[root].left = self.deleteNode(self.nodes[root].left,\
    \ i)\n        else:\n            self.nodes[root].right = self.deleteNode(self.nodes[root].right,\
    \ i)\n        self.rebalance(root)\n\n    proc refresh[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], root, i: int) =\n        ## \u6307\u5B9A\u7BC0\u70B9\u304B\u3089\u6839\
    \u307E\u3067\u306E\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002\
    O(log M)\u3002\n        if root != i:\n            if self.earlier(i, root): self.refresh(self.nodes[root].left,\
    \ i)\n            else: self.refresh(self.nodes[root].right, i)\n        self.pull(root)\n\
    \n    proc locate[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S], t:\
    \ K): tuple[id, rank: int] =\n        ## \u6642\u523B\u306B\u5BFE\u5FDC\u3059\u308B\
    \u7BC0\u70B9ID\u3068\u633F\u5165\u4F4D\u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \u672A\u767B\u9332ID\u306F0\u3067\u3059\u3002O(log M)\u3002\n        mixin `<`\n\
    \        var i = self.root\n        while i != 0:\n            if i == 1 or self.nodes[i].time\
    \ < t:\n                result.rank += self.nodes[self.nodes[i].left].size + 1\n\
    \                i = self.nodes[i].right\n            elif t < self.nodes[i].time:\n\
    \                i = self.nodes[i].left\n            else:\n                result.rank\
    \ += self.nodes[self.nodes[i].left].size\n                result.id = i\n    \
    \            return\n\n    proc ensureNode[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], t: K): tuple[id, rank: int] =\n        ## \u672A\u767B\u9332\u306A\u3089\
    \u7A7A\u64CD\u4F5C\u306E\u7BC0\u70B9\u3092\u7528\u610F\u3057\u307E\u3059\u3002\
    O(log M)\u3001\u9818\u57DF\u62E1\u5F35\u306F\u511F\u5374O(1)\u3002\n        result\
    \ = self.locate(t)\n        if result.id != 0: return\n        if self.free.len\
    \ > 0: result.id = self.free.pop()\n        else:\n            result.id = self.nodes.len\n\
    \            self.nodes.add(default(DynamicRetroactiveNode[K, T, S]))\n      \
    \  self.nodes[result.id].time = t\n        self.pull(result.id)\n        self.root\
    \ = self.insertNode(self.root, result.id)\n\n    proc findBridge[K, T, S](self:\
    \ DynamicRetroactivePriorityQueue[K, T, S], i, start,\n            t, prefix:\
    \ int, first: bool): int =\n        ## t\u4EE5\u4E0A\u3067\u6700\u521D\u3001\u307E\
    \u305F\u306Ft\u4EE5\u4E0B\u3067\u6700\u5F8C\u306E\u53CE\u652F0\u306E\u5883\u754C\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(log M)\u3002\n        if i == 0: return\
    \ -1\n        let finish = start + self.nodes[i].size\n        if first:\n   \
    \         if finish < t: return -1\n        elif start >= t: return -1\n     \
    \   if prefix + self.nodes[i].minPrefix > 0: return -1\n        let l = self.nodes[i].left\n\
    \        let r = self.nodes[i].right\n        let mid = start + self.nodes[l].size\n\
    \        let after = prefix + self.nodes[l].balance + self.ownBalance(i)\n   \
    \     if first:\n            result = self.findBridge(l, start, t, prefix, first)\n\
    \            if result >= 0: return\n            if mid + 1 >= t and after ==\
    \ 0: return mid + 1\n            result = self.findBridge(r, mid + 1, t, after,\
    \ first)\n        else:\n            result = self.findBridge(r, mid + 1, t, after,\
    \ first)\n            if result >= 0: return\n            if mid + 1 <= t and\
    \ after == 0: return mid + 1\n            result = self.findBridge(l, start, t,\
    \ prefix, first)\n\n    proc candidate[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], i, start,\n            left, right: int, remaining: bool): int =\n  \
    \      ## \u534A\u958B\u533A\u9593\u306E\u6B8B\u5B58\u6700\u512A\u5148\u307E\u305F\
    \u306F\u524A\u9664\u6E08\u307F\u6700\u4F4E\u512A\u5148\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(log M)\u3002\n        if i == 0 or right <= start or start + self.nodes[i].size\
    \ <= left: return 0\n        if left <= start and start + self.nodes[i].size <=\
    \ right:\n            return (if remaining: self.nodes[i].remaining else: self.nodes[i].removed)\n\
    \        let mid = start + self.nodes[self.nodes[i].left].size\n        result\
    \ = self.candidate(self.nodes[i].left, start, left, right, remaining)\n      \
    \  if left <= mid and mid < right:\n            result = self.choose(result, self.ownCandidate(i,\
    \ remaining), remaining)\n        result = self.choose(result,\n            self.candidate(self.nodes[i].right,\
    \ mid + 1, left, right, remaining), remaining)\n\n    proc changeRemaining[K,\
    \ T, S](self: DynamicRetroactivePriorityQueue[K, T, S], i: int,\n            remains:\
    \ bool, delta: var QueueDelta[K, T]) =\n        ## \u6700\u7D42\u72B6\u614B\u306E\
    \u5DEE\u5206\u30FB\u7DCF\u548C\u3068\u6728\u306E\u96C6\u7D04\u5024\u3092\u66F4\
    \u65B0\u3057\u307E\u3059\u3002O(log M)\u3002\n        mixin `<`\n        assert\
    \ i != 0\n        if i == 1:\n            self.dummyRemoved += (if remains: -1\
    \ else: 1)\n        else:\n            self.nodes[i].remains = remains\n     \
    \       let entry = (time: self.nodes[i].time, value: self.nodes[i].value)\n \
    \           if remains:\n                inc self.count\n                when\
    \ S is void:\n                    when T is SomeNumber: self.total += entry.value\n\
    \                delta.added.add(entry)\n            else:\n                dec\
    \ self.count\n                when S is void:\n                    when T is SomeNumber:\
    \ self.total -= entry.value\n                var transient = -1\n            \
    \    for j, added in delta.added:\n                    if not (added.time < entry.time)\
    \ and not (entry.time < added.time): transient = j\n                if transient\
    \ >= 0: delta.added.delete(transient)\n                else: delta.removed.add(entry)\n\
    \        self.refresh(self.root, i)\n\n    proc eraseOperation[K, T, S](self:\
    \ DynamicRetroactivePriorityQueue[K, T, S], i, rank: int,\n            delta:\
    \ var QueueDelta[K, T]) =\n        ## \u7BC0\u70B9\u3092\u6B8B\u3057\u3066\u64CD\
    \u4F5C\u306E\u307F\u6D88\u3057\u3001\u6700\u7D42\u72B6\u614B\u3092\u66F4\u65B0\
    \u3057\u307E\u3059\u3002O(log M)\u3002\n        case self.nodes[i].operation\n\
    \        of drqNone: return\n        of drqPush:\n            when S is void:\n\
    \                when T is SomeSignedInt: self.pushTotal = self.pushTotal -% self.nodes[i].value\n\
    \                elif T is SomeNumber: self.pushTotal -= self.nodes[i].value\n\
    \            if self.nodes[i].remains:\n                self.changeRemaining(i,\
    \ false, delta)\n            else:\n                let bridge = self.findBridge(self.root,\
    \ 0, rank + 1, 0, true)\n                let x = self.candidate(self.root, 0,\
    \ 0, bridge, true)\n                self.changeRemaining(x, false, delta)\n  \
    \      of drqPop:\n            let bridge = max(0, self.findBridge(self.root,\
    \ 0, rank, 0, false))\n            let x = self.candidate(self.root, 0, bridge,\
    \ self.nodes[self.root].size, false)\n            self.changeRemaining(x, true,\
    \ delta)\n        self.nodes[i].operation = drqNone\n        self.nodes[i].value\
    \ = default(T)\n        when S isnot void: self.nodes[i].mapped = default(S)\n\
    \        self.nodes[i].remains = false\n        self.refresh(self.root, i)\n\n\
    \    proc initDynamicRetroactivePriorityQueue*[K, T](\n            order = Ascending):\
    \ DynamicRetroactivePriorityQueue[K, T] =\n        ## \u7A7A\u306E\u64CD\u4F5C\
    \u5217\u3092O(1)\u3067\u751F\u6210\u3057\u307E\u3059\u3002K\u3068T\u306B\u306F\
    \u4E00\u8CAB\u3057\u305F < \u304C\u5FC5\u8981\u3067\u3059\u3002\n        ## Ascending\u306F\
    pop min\u3001Descending\u306Fpop max\u3067\u3059\u3002\n        result = DynamicRetroactivePriorityQueue[K,\
    \ T](root: 1, order: order,\n            nodes: newSeq[DynamicRetroactiveNode[K,\
    \ T, void]](2))\n        result.pull(1)\n\n    proc initDynamicRetroactivePriorityQueue*[K,\
    \ T, S](op: proc(a, b: S): S,\n            e: S, lift: proc(value: T): S,\n  \
    \          order = Ascending): DynamicRetroactivePriorityQueue[K, T, S] =\n  \
    \      ## \u30E2\u30CE\u30A4\u30C9\u96C6\u7D04\u4ED8\u304D\u306E\u7A7A\u306E\u64CD\
    \u4F5C\u5217\u3092\u751F\u6210\u3057\u307E\u3059\u3002op\u30FBlift\u3068\u5024\
    \u306E\u30B3\u30D4\u30FC\u304CO(1)\u306A\u3089O(1)\u3002\n        ## \u6B8B\u5B58\
    push\u3092\u6642\u523B\u9806\u3067\u96C6\u7D04\u3057\u307E\u3059\u3002op\u306F\
    \u7D50\u5408\u7684\u3001e\u306F\u5358\u4F4D\u5143\u3001op\u30FBlift\u306F\u526F\
    \u4F5C\u7528\u306A\u3057\u3068\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n   \
    \     result = DynamicRetroactivePriorityQueue[K, T, S](root: 1, order: order,\n\
    \            nodes: newSeq[DynamicRetroactiveNode[K, T, S]](2), op: op, lift:\
    \ lift, identity: e)\n        result.nodes[0].aggregate = e\n        result.pull(1)\n\
    \n    proc fold*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): S =\n\
    \        ## \u6B8B\u5B58push\u306E\u6642\u523B\u9806\u306E\u30E2\u30CE\u30A4\u30C9\
    \u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\u3089\u5358\u4F4D\u5143\
    \u3067\u3059\u3002\u5024\u306E\u30B3\u30D4\u30FC\u304CO(1)\u306A\u3089O(1)\u3002\
    \n        self.nodes[self.root].aggregate\n\n    proc setPush*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueue[K, T, S],\n            t: K, value: T): QueueDelta[K,\
    \ T] {.discardable.} =\n        ## \u6642\u523Bt\u306Bpush\u3092\u633F\u5165\u30FB\
    \u4E0A\u66F8\u304D\u3057\u3001\u6700\u7D42\u72B6\u614B\u306E\u5DEE\u5206\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u511F\u5374O(log(M+2))\u3002\n        let (i, rank)\
    \ = self.ensureNode(t)\n        self.eraseOperation(i, rank, result)\n       \
    \ let bridge = max(0, self.findBridge(self.root, 0, rank, 0, false))\n       \
    \ let x = self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)\n\
    \        self.nodes[i].operation = drqPush\n        self.nodes[i].value = value\n\
    \        when S is void:\n            when T is SomeSignedInt: self.pushTotal\
    \ = self.pushTotal +% value\n            elif T is SomeNumber: self.pushTotal\
    \ += value\n        when S isnot void: self.nodes[i].mapped = self.lift(value)\n\
    \        if x == 0 or self.before(x, i):\n            self.changeRemaining(i,\
    \ true, result)\n        else:\n            self.nodes[i].remains = false\n  \
    \          self.refresh(self.root, i)\n            self.changeRemaining(x, true,\
    \ result)\n\n    proc setPop*[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S],\n            t: K): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\
    \u523Bt\u306Bpop\u3092\u633F\u5165\u30FB\u4E0A\u66F8\u304D\u3057\u3001\u6700\u7D42\
    \u72B6\u614B\u306E\u5DEE\u5206\u3092\u8FD4\u3057\u307E\u3059\u3002\u511F\u5374\
    O(log(M+2))\u3002\n        let (i, rank) = self.ensureNode(t)\n        if self.nodes[i].operation\
    \ == drqPop: return\n        self.eraseOperation(i, rank, result)\n        let\
    \ bridge = self.findBridge(self.root, 0, rank, 0, true)\n        let x = self.candidate(self.root,\
    \ 0, 0, bridge, true)\n        self.changeRemaining(x, false, result)\n      \
    \  self.nodes[i].operation = drqPop\n        self.refresh(self.root, i)\n\n  \
    \  proc erase*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S],\n    \
    \        t: K): QueueDelta[K, T] {.discardable.} =\n        ## \u6642\u523Bt\u306E\
    \u64CD\u4F5C\u3092\u524A\u9664\u3057\u307E\u3059\u3002\u672A\u767B\u9332\u306A\
    \u3089\u4F55\u3082\u3057\u307E\u305B\u3093\u3002\u511F\u5374O(log(M+2))\u3002\n\
    \        let (i, rank) = self.locate(t)\n        if i == 0: return\n        self.eraseOperation(i,\
    \ rank, result)\n        self.root = self.deleteNode(self.root, i)\n        self.nodes[i]\
    \ = default(DynamicRetroactiveNode[K, T, S])\n        self.free.add(i)\n\n   \
    \ proc len*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): int =\n\
    \        ## \u5168\u64CD\u4F5C\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\u5B9F\u8981\
    \u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.count\n\
    \n    proc sum*[K; T: SomeNumber](self: DynamicRetroactivePriorityQueue[K, T]):\
    \ T =\n        ## \u5168\u64CD\u4F5C\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\u5024\
    \u306E\u7DCF\u548C\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.total\n\
    \n    proc peek*[K, T, S](self: DynamicRetroactivePriorityQueue[K, T, S]): Option[T]\
    \ =\n        ## \u6700\u7D42\u72B6\u614B\u306E\u6700\u512A\u5148\u8981\u7D20\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\u3089none\u3067\u3059\u3002O(1)\u3002\
    \n        let i = self.nodes[self.root].remaining\n        if i <= 1: none(T)\
    \ else: some(self.nodes[i].value)\n\n    proc isRemaining*[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S], t: K): bool =\n        ## \u6642\u523Bt\u306Epush\u304C\u6700\u5F8C\u306B\
    \u6B8B\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\u672A\u767B\u9332\u30FB\
    pop\u306A\u3089false\u3067\u3059\u3002O(log M)\u3002\n        let i = self.locate(t).id\n\
    \        i != 0 and self.nodes[i].operation == drqPush and self.nodes[i].remains\n\
    \n    proc debugOperations*[K, T, S](self: DynamicRetroactivePriorityQueue[K,\
    \ T, S]): seq[QueueDebugEntry[K, T]] =\n        ## \u767B\u9332\u4E2D\u306E\u64CD\
    \u4F5C\u3092\u6642\u523B\u9806\u3067\u8FD4\u3057\u307E\u3059\u3002\u756A\u5175\
    \u30FB\u524A\u9664\u6E08\u307F\u6642\u523B\u3092\u9664\u304D\u3001pop\u7D50\u679C\
    \u306F\u672A\u8A08\u7B97\u3067\u3059\u3002O(M)\u3002\n        var stack: seq[int]\n\
    \        var i = self.root\n        while i != 0 or stack.len > 0:\n         \
    \   while i != 0:\n                stack.add(i)\n                i = self.nodes[i].left\n\
    \            i = stack.pop()\n            if i != 1:\n                var entry\
    \ = QueueDebugEntry[K, T](time: self.nodes[i].time)\n                case self.nodes[i].operation\n\
    \                of drqNone: entry.kind = qdkNone\n                of drqPush:\n\
    \                    entry.kind = qdkPush\n                    entry.value = some(self.nodes[i].value)\n\
    \                of drqPop: entry.kind = qdkPop\n                result.add(entry)\n\
    \            i = self.nodes[i].right\n\n    proc debugTimeline*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueue[K, T, S]): seq[QueueDebugEntry[K, T]] =\n  \
    \      ## \u767B\u9332\u4E2D\u306E\u5168\u64CD\u4F5C\u3068\u5B9F\u969B\u306Epop\u7D50\
    \u679C\u3092\u6642\u523B\u9806\u3067\u8FD4\u3057\u307E\u3059\u3002O(M log(M+2))\u6642\
    \u9593\u30FBO(M)\u7A7A\u9593\u3002\n        result = self.debugOperations()\n\
    \        replayQueueDebug(result, self.order)\n\n    proc debugDump*[K, T, S](self:\
    \ DynamicRetroactivePriorityQueue[K, T, S]): string =\n        ## \u64CD\u4F5C\
    \u3068\u5B9F\u969B\u306Epop\u7D50\u679C\u3092\u8868\u793A\u7528\u6587\u5B57\u5217\
    \u3067\u8FD4\u3057\u307E\u3059\u3002O(M log(M+2)+\u51FA\u529B\u6587\u5B57\u6570\
    )\u3002\n        formatQueueDebug(self.debugTimeline())\n\n    proc `$`*[K, T,\
    \ S](self: DynamicRetroactivePriorityQueue[K, T, S]): string =\n        ## debugDump\u3068\
    \u540C\u3058\u64CD\u4F5C\u30FBpop\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(M log(M+2)+\u51FA\u529B\u6587\u5B57\u6570)\u3002\n        self.debugDump()\n\
    \n    proc poppedSum*[K; T: SomeNumber](self: DynamicRetroactivePriorityQueue[K,\
    \ T]): T =\n        ## \u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067pop\u3055\u308C\
    \u308B\u5024\u306E\u7DCF\u548C\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u3078\
    \u306Epop\u306F0\u3068\u3057\u3066\u6271\u3044\u307E\u3059\u3002O(1)\u3002\n \
    \       ## \u6574\u6570\u306F\u7D50\u679C\u304C\u578B\u306B\u53CE\u307E\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\u3002\u5185\u90E8\u306E\u5168push\u7DCF\u548C\
    \u306F\u6841\u3042\u3075\u308C\u3092\u8A31\u5BB9\u3057\u307E\u3059\u3002\n   \
    \     ## \u6D6E\u52D5\u5C0F\u6570\u70B9\u306F\u5168push\u7DCF\u548C\u304B\u3089\
    \u6B8B\u5B58\u7DCF\u548C\u3092\u5F15\u304F\u305F\u3081\u3001\u6841\u843D\u3061\
    \u304C\u751F\u3058\u308B\u5834\u5408\u304C\u3042\u308A\u307E\u3059\u3002\n   \
    \     when T is SomeSignedInt: self.pushTotal -% self.total\n        else: self.pushTotal\
    \ - self.total\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  isVerificationFile: false
  path: cplib/collections/dynamic_retroactive_priority_queue.nim
  requiredBy:
  - verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - verify/collections/dynamic_retroactive_priority_queue_abc363g_test_.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  - cplib/collections/dynamic_retroactive_priority_queue_monoid.nim
  timestamp: '2026-09-28 01:13:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_monoid_test.nim
  - verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - verify/collections/retroactive_priority_queue_popped_sum_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
  - verify/collections/retroactive_priority_queue_debug_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_test.nim
  - verify/collections/dynamic_retroactive_priority_queue_test.nim
documentation_of: cplib/collections/dynamic_retroactive_priority_queue.nim
layout: document
redirect_from:
- /library/cplib/collections/dynamic_retroactive_priority_queue.nim
- /library/cplib/collections/dynamic_retroactive_priority_queue.nim.html
title: cplib/collections/dynamic_retroactive_priority_queue.nim
---
