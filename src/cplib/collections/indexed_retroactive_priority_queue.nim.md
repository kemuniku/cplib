---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/retroactive_priority_queue.nim
    title: cplib/collections/retroactive_priority_queue.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/indexed_retroactive_priority_queue_test.nim
    title: verify/collections/indexed_retroactive_priority_queue_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/indexed_retroactive_priority_queue_test.nim
    title: verify/collections/indexed_retroactive_priority_queue_test.nim
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
  code: "## \u64CD\u4F5C\u5217\u306E\u4F4D\u7F6E\u3092\u6307\u5B9A\u3057\u3066push/pop\u3092\
    \u633F\u5165\u30FB\u4E0A\u66F8\u304D\u30FB\u524A\u9664\u3059\u308BRetroactivePriorityQueue\u3067\
    \u3059\u3002\n## k\u30FBindex\u306F0\u59CB\u307E\u308A\u306E\u73FE\u5728\u4F4D\
    \u7F6E\u3067\u3059\u3002\u633F\u5165\u306F\u8FFD\u52A0\u9806\u306B0\u304B\u3089\
    \u63A1\u756A\u3057\u305F\u64CD\u4F5CID\u3092\u8FD4\u3057\u307E\u3059\u3002\n##\
    \ ID\u306F\u524A\u9664\u5F8C\u3082\u518D\u5229\u7528\u305B\u305A\u3001setPush/setPop\u306B\
    \u3088\u308B\u4E0A\u66F8\u304D\u3067\u306F\u5909\u308F\u308A\u307E\u305B\u3093\
    \u3002eraseById\u3067\u524A\u9664\u3067\u304D\u307E\u3059\u3002\n## push/pop\u306E\
    \u9806\u756A\u306F\u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067\u6570\u3048\u307E\
    \u3059\u3002pop\u306F\u7A7A\u3078\u306Epop\u3092\u542B\u307F\u3001push\u306F\u53D6\
    \u308A\u51FA\u3057\u6E08\u307F\u3082\u542B\u307F\u307E\u3059\u3002\n## M\u3092\
    \u64CD\u4F5C\u6570\u3068\u3057\u3066\u3001\u66F4\u65B0\u306F\u511F\u5374O(log(M+2))\u3001\
    \u7A2E\u985E\u5225\u306E\u4F4D\u7F6E\u691C\u7D22\u306F\u6700\u60AAO(log(M+2))\u3067\
    \u3059\u3002\n## AVL\u6728\u306E\u64CD\u4F5C\u306F\u6700\u60AAO(log(M+2))\u3001\
    \u9818\u57DF\u62E1\u5F35\u306F\u511F\u5374\u3067\u3059\u3002\u7BC0\u70B9\u9818\
    \u57DF\u306F\u64CD\u4F5C\u6570\u306E\u904E\u53BB\u6700\u5927\u5024\u3001ID\u7BA1\
    \u7406\u9818\u57DF\u306F\u7D2F\u8A08\u633F\u5165\u56DE\u6570\u306B\u6BD4\u4F8B\
    \u3057\u307E\u3059\u3002\n## len\u306F\u6700\u5F8C\u306B\u6B8B\u308B\u8981\u7D20\
    \u6570\u3001operationCount\u306F\u64CD\u4F5C\u6570\u3067\u3059\u3002sum/poppedSum\u306B\
    \u306F\u5341\u5206\u306A\u5E45\u306E\u6570\u5024\u578B\u3092\u4F7F\u3063\u3066\
    \u304F\u3060\u3055\u3044\u3002\n## \u540C\u5024\u306A\u3089\u64CD\u4F5C\u5217\u3067\
    \u5148\u306Epush\u3092\u5148\u306B\u53D6\u308A\u51FA\u3057\u307E\u3059\u3002\u5404\
    pop\u306E\u8FD4\u308A\u5024\u3084\u9014\u4E2D\u6642\u523B\u306E\u72B6\u614B\u306F\
    \u7BA1\u7406\u3057\u307E\u305B\u3093\u3002\n## \u4F4D\u7F6E\u304C\u5909\u5316\u3059\
    \u308B\u305F\u3081QueueDelta\u306F\u8FD4\u3057\u307E\u305B\u3093\u3002\u30C7\u30D0\
    \u30C3\u30B0\u306Fecho pq\u3067\u8868\u793A\u3067\u304D\u307E\u3059\u3002\n##\n\
    ## .. code-block:: nim\n##   import cplib/collections/indexed_retroactive_priority_queue\n\
    ##   let pq = initIndexedRetroactivePriorityQueue[int]()\n##   pq.insertPop(0)\n\
    ##   pq.insertPushBeforePop(0, 10)\n##   assert pq.poppedSum == 10\n##   pq.insertPopBeforePush(0)\n\
    ##   assert pq.popCount == 2\n\nwhen not declared CPLIB_COLLECTIONS_INDEXED_RETROACTIVE_PRIORITY_QUEUE:\n\
    \    const CPLIB_COLLECTIONS_INDEXED_RETROACTIVE_PRIORITY_QUEUE* = 1\n    import\
    \ algorithm, options\n    import cplib/collections/retroactive_priority_queue\n\
    \n    type\n        IndexedRetroactiveOperation = enum\n            irqNone, irqPush,\
    \ irqPop\n        IndexedRetroactiveNode[T] = object\n            left, right,\
    \ parent, height, size, pushes, pops, operationId: int\n            value: T\n\
    \            operation: IndexedRetroactiveOperation\n            remains: bool\n\
    \            balance, minPrefix, remaining, removed: int\n        IndexedRetroactivePriorityQueue*[T]\
    \ = ref object\n            nodes: seq[IndexedRetroactiveNode[T]]\n          \
    \  free, idNodes: seq[int]\n            root, count, dummyRemoved: int\n     \
    \       order: SortOrder\n            when T is SomeNumber:\n                total,\
    \ pushTotal: T\n\n    proc nodeRank[T](self: IndexedRetroactivePriorityQueue[T],\
    \ id: int): int =\n        ## \u7BC0\u70B9\u306E\u5185\u90E8\u4F4D\u7F6E\u3092\
    \u89AA\u30EA\u30F3\u30AF\u304B\u3089\u6C42\u3081\u307E\u3059\u3002O(log M)\u3002\
    \n        var i = id\n        result = self.nodes[self.nodes[i].left].size\n \
    \       while self.nodes[i].parent != 0:\n            let p = self.nodes[i].parent\n\
    \            if self.nodes[p].right == i: result += self.nodes[self.nodes[p].left].size\
    \ + 1\n            i = p\n\n    proc before[T](self: IndexedRetroactivePriorityQueue[T],\
    \ a, b: int): bool =\n        ## \u5019\u88DC\u3068\u65B0\u898Fpush\u306E\u512A\
    \u5148\u9806\u4F4D\u3092\u6BD4\u8F03\u3057\u307E\u3059\u3002\u540C\u5024\u306E\
    \u4F4D\u7F6E\u6BD4\u8F03\u3092\u542B\u3081O(log M)\u3002\n        mixin `<`\n\
    \        if a == 1: return false\n        if b == 1: return true\n        if self.nodes[a].value\
    \ < self.nodes[b].value: return self.order == Ascending\n        if self.nodes[b].value\
    \ < self.nodes[a].value: return self.order == Descending\n        self.nodeRank(a)\
    \ < self.nodeRank(b)\n\n    proc choose[T](self: IndexedRetroactivePriorityQueue[T],\
    \ a, b: int,\n            remaining: bool): int =\n        ## \u5DE6\u5074\u306E\
    \u5019\u88DCa\u3068\u53F3\u5074\u306E\u5019\u88DCb\u3092\u7D50\u5408\u3057\u307E\
    \u3059\u3002\u540C\u5024\u306F\u4F4D\u7F6E\u306E\u524D\u5F8C\u3067\u89E3\u6C7A\
    \u3057O(1)\u3002\n        mixin `<`\n        if a == 0: return b\n        if b\
    \ == 0: return a\n        var first: bool\n        if a == 1: first = false\n\
    \        elif b == 1: first = true\n        elif self.nodes[a].value < self.nodes[b].value:\
    \ first = self.order == Ascending\n        elif self.nodes[b].value < self.nodes[a].value:\
    \ first = self.order == Descending\n        else: first = true\n        if first\
    \ == remaining: a else: b\n\n    proc ownBalance[T](self: IndexedRetroactivePriorityQueue[T],\
    \ i: int): int =\n        ## \u4E00\u64CD\u4F5C\u306E\u53CE\u652F\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(1)\u3002\n        if i == 1: self.dummyRemoved\n        elif\
    \ self.nodes[i].operation == irqPop: -1\n        elif self.nodes[i].operation\
    \ == irqPush and not self.nodes[i].remains: 1\n        else: 0\n\n    proc ownCandidate[T](self:\
    \ IndexedRetroactivePriorityQueue[T], i: int,\n            remaining: bool): int\
    \ =\n        ## \u4E00\u64CD\u4F5C\u306E\u5019\u88DC\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\u756A\u5175\u306F\u7121\u9650\u500B\u306E\u4F4E\u512A\u5148\u8981\u7D20\
    \u3092\u8868\u3057\u307E\u3059\u3002O(1)\u3002\n        if i == 1:\n         \
    \   if remaining or self.dummyRemoved > 0: return 1\n        elif self.nodes[i].operation\
    \ == irqPush and self.nodes[i].remains == remaining:\n            return i\n\n\
    \    proc pull[T](self: IndexedRetroactivePriorityQueue[T], i: int) =\n      \
    \  ## \u90E8\u5206\u6728\u306E\u9AD8\u3055\u30FB\u8981\u7D20\u6570\u30FB\u96C6\
    \u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n        let\
    \ l = self.nodes[i].left\n        let r = self.nodes[i].right\n        if l !=\
    \ 0: self.nodes[l].parent = i\n        if r != 0: self.nodes[r].parent = i\n \
    \       self.nodes[i].pushes = self.nodes[l].pushes + self.nodes[r].pushes + int(self.nodes[i].operation\
    \ == irqPush)\n        self.nodes[i].pops = self.nodes[l].pops + self.nodes[r].pops\
    \ + int(self.nodes[i].operation == irqPop)\n        let mid = self.nodes[l].balance\
    \ + self.ownBalance(i)\n        self.nodes[i].height = max(self.nodes[l].height,\
    \ self.nodes[r].height) + 1\n        self.nodes[i].size = self.nodes[l].size +\
    \ 1 + self.nodes[r].size\n        self.nodes[i].balance = mid + self.nodes[r].balance\n\
    \        self.nodes[i].minPrefix = mid\n        if l != 0: self.nodes[i].minPrefix\
    \ = min(self.nodes[i].minPrefix, self.nodes[l].minPrefix)\n        if r != 0:\
    \ self.nodes[i].minPrefix = min(self.nodes[i].minPrefix, mid + self.nodes[r].minPrefix)\n\
    \        self.nodes[i].remaining = self.choose(self.choose(self.nodes[l].remaining,\n\
    \            self.ownCandidate(i, true), true), self.nodes[r].remaining, true)\n\
    \        self.nodes[i].removed = self.choose(self.choose(self.nodes[l].removed,\n\
    \            self.ownCandidate(i, false), false), self.nodes[r].removed, false)\n\
    \n    proc rotateLeft[T](self: IndexedRetroactivePriorityQueue[T], i: int): int\
    \ =\n        ## \u5DE6\u56DE\u8EE2\u3057\u307E\u3059\u3002O(1)\u3002\n       \
    \ result = self.nodes[i].right\n        self.nodes[i].right = self.nodes[result].left\n\
    \        self.nodes[result].left = i\n        self.pull(i)\n        self.pull(result)\n\
    \n    proc rotateRight[T](self: IndexedRetroactivePriorityQueue[T], i: int): int\
    \ =\n        ## \u53F3\u56DE\u8EE2\u3057\u307E\u3059\u3002O(1)\u3002\n       \
    \ result = self.nodes[i].left\n        self.nodes[i].left = self.nodes[result].right\n\
    \        self.nodes[result].right = i\n        self.pull(i)\n        self.pull(result)\n\
    \n    proc rebalance[T](self: IndexedRetroactivePriorityQueue[T], i: int): int\
    \ =\n        ## \u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u3001AVL\u6728\u306E\
    \u5E73\u8861\u3092\u4FDD\u3061\u307E\u3059\u3002O(1)\u3002\n        self.pull(i)\n\
    \        let l = self.nodes[i].left\n        let r = self.nodes[i].right\n   \
    \     if self.nodes[l].height > self.nodes[r].height + 1:\n            if self.nodes[self.nodes[l].left].height\
    \ < self.nodes[self.nodes[l].right].height:\n                self.nodes[i].left\
    \ = self.rotateLeft(l)\n            return self.rotateRight(i)\n        if self.nodes[r].height\
    \ > self.nodes[l].height + 1:\n            if self.nodes[self.nodes[r].right].height\
    \ < self.nodes[self.nodes[r].left].height:\n                self.nodes[i].right\
    \ = self.rotateRight(r)\n            return self.rotateLeft(i)\n        i\n\n\
    \    proc insertNode[T](self: IndexedRetroactivePriorityQueue[T], root, i, position:\
    \ int): int =\n        ## \u5185\u90E8\u4F4D\u7F6Eposition\u306E\u76F4\u524D\u306B\
    \u7BC0\u70B9\u3092\u633F\u5165\u3057\u307E\u3059\u3002O(log M)\u3002\n       \
    \ if root == 0: return i\n        let mid = self.nodes[self.nodes[root].left].size\n\
    \        if position <= mid:\n            self.nodes[root].left = self.insertNode(self.nodes[root].left,\
    \ i, position)\n        else:\n            self.nodes[root].right = self.insertNode(self.nodes[root].right,\
    \ i, position - mid - 1)\n        self.rebalance(root)\n\n    proc detachMin[T](self:\
    \ IndexedRetroactivePriorityQueue[T], root: int,\n            minimum: var int):\
    \ int =\n        ## \u6700\u5C0F\u7BC0\u70B9\u3092\u5207\u308A\u96E2\u3057\u3001\
    \u6B8B\u308A\u306E\u6839\u3092\u8FD4\u3057\u307E\u3059\u3002O(log M)\u3002\n \
    \       if self.nodes[root].left == 0:\n            minimum = root\n         \
    \   return self.nodes[root].right\n        self.nodes[root].left = self.detachMin(self.nodes[root].left,\
    \ minimum)\n        self.rebalance(root)\n\n    proc deleteNode[T](self: IndexedRetroactivePriorityQueue[T],\
    \ root, position: int): int =\n        ## \u5185\u90E8\u4F4D\u7F6Eposition\u306E\
    \u7BC0\u70B9\u3092\u524A\u9664\u3057\u307E\u3059\u3002O(log M)\u3002\n       \
    \ let mid = self.nodes[self.nodes[root].left].size\n        if position == mid:\n\
    \            let l = self.nodes[root].left\n            let r = self.nodes[root].right\n\
    \            if l == 0: return r\n            if r == 0: return l\n          \
    \  var successor: int\n            let rest = self.detachMin(r, successor)\n \
    \           self.nodes[successor].left = l\n            self.nodes[successor].right\
    \ = rest\n            return self.rebalance(successor)\n        if position <\
    \ mid:\n            self.nodes[root].left = self.deleteNode(self.nodes[root].left,\
    \ position)\n        else:\n            self.nodes[root].right = self.deleteNode(self.nodes[root].right,\
    \ position - mid - 1)\n        self.rebalance(root)\n\n    proc refresh[T](self:\
    \ IndexedRetroactivePriorityQueue[T], id: int) =\n        ## \u89AA\u30EA\u30F3\
    \u30AF\u3092\u8FBF\u3063\u3066\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\
    \u3059\u3002O(log M)\u3002\n        var i = id\n        while i != 0:\n      \
    \      self.pull(i)\n            i = self.nodes[i].parent\n\n    proc nodeAt[T](self:\
    \ IndexedRetroactivePriorityQueue[T], position: int): int =\n        ## \u756A\
    \u5175\u3092\u542B\u3080\u5185\u90E8\u4F4D\u7F6E\u306B\u3042\u308B\u7BC0\u70B9\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(log M)\u3002\n        var i = self.root\n\
    \        var k = position\n        while i != 0:\n            let mid = self.nodes[self.nodes[i].left].size\n\
    \            if k < mid: i = self.nodes[i].left\n            elif k == mid: return\
    \ i\n            else:\n                k -= mid + 1\n                i = self.nodes[i].right\n\
    \n    proc addEmptyNode[T](self: IndexedRetroactivePriorityQueue[T], position:\
    \ int): int =\n        ## \u5185\u90E8\u4F4D\u7F6Eposition\u306B\u4E00\u6642\u7684\
    \u306A\u7A7A\u64CD\u4F5C\u3092\u633F\u5165\u3057\u3001\u64CD\u4F5CID\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\u511F\u5374O(log(M+2))\u3002\n        var i: int\n  \
    \      if self.free.len > 0: i = self.free.pop()\n        else:\n            i\
    \ = self.nodes.len\n            self.nodes.add(default(IndexedRetroactiveNode[T]))\n\
    \        result = self.idNodes.len\n        self.idNodes.add(i)\n        self.nodes[i].operationId\
    \ = result\n        self.pull(i)\n        self.root = self.insertNode(self.root,\
    \ i, position)\n        self.nodes[self.root].parent = 0\n\n    proc findBridge[T](self:\
    \ IndexedRetroactivePriorityQueue[T], i, start,\n            t, prefix: int, first:\
    \ bool): int =\n        ## t\u4EE5\u4E0A\u3067\u6700\u521D\u3001\u307E\u305F\u306F\
    t\u4EE5\u4E0B\u3067\u6700\u5F8C\u306E\u53CE\u652F0\u306E\u5883\u754C\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(log M)\u3002\n        if i == 0: return -1\n       \
    \ let finish = start + self.nodes[i].size\n        if first:\n            if finish\
    \ < t: return -1\n        elif start >= t: return -1\n        if prefix + self.nodes[i].minPrefix\
    \ > 0: return -1\n        let l = self.nodes[i].left\n        let r = self.nodes[i].right\n\
    \        let mid = start + self.nodes[l].size\n        let after = prefix + self.nodes[l].balance\
    \ + self.ownBalance(i)\n        if first:\n            result = self.findBridge(l,\
    \ start, t, prefix, first)\n            if result >= 0: return\n            if\
    \ mid + 1 >= t and after == 0: return mid + 1\n            result = self.findBridge(r,\
    \ mid + 1, t, after, first)\n        else:\n            result = self.findBridge(r,\
    \ mid + 1, t, after, first)\n            if result >= 0: return\n            if\
    \ mid + 1 <= t and after == 0: return mid + 1\n            result = self.findBridge(l,\
    \ start, t, prefix, first)\n\n    proc candidate[T](self: IndexedRetroactivePriorityQueue[T],\
    \ i, start,\n            left, right: int, remaining: bool): int =\n        ##\
    \ \u534A\u958B\u533A\u9593\u306E\u6B8B\u5B58\u6700\u512A\u5148\u307E\u305F\u306F\
    \u524A\u9664\u6E08\u307F\u6700\u4F4E\u512A\u5148\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(log M)\u3002\n        if i == 0 or right <= start or start + self.nodes[i].size\
    \ <= left: return 0\n        if left <= start and start + self.nodes[i].size <=\
    \ right:\n            return (if remaining: self.nodes[i].remaining else: self.nodes[i].removed)\n\
    \        let mid = start + self.nodes[self.nodes[i].left].size\n        result\
    \ = self.candidate(self.nodes[i].left, start, left, right, remaining)\n      \
    \  if left <= mid and mid < right:\n            result = self.choose(result, self.ownCandidate(i,\
    \ remaining), remaining)\n        result = self.choose(result,\n            self.candidate(self.nodes[i].right,\
    \ mid + 1, left, right, remaining), remaining)\n\n    proc changeRemaining[T](self:\
    \ IndexedRetroactivePriorityQueue[T], i: int, remains: bool) =\n        ## \u6B8B\
    \u5B58\u72B6\u614B\u30FB\u7DCF\u548C\u3068\u6728\u306E\u96C6\u7D04\u5024\u3092\
    \u66F4\u65B0\u3057\u307E\u3059\u3002O(log M)\u3002\n        assert i != 0\n  \
    \      if i == 1:\n            self.dummyRemoved += (if remains: -1 else: 1)\n\
    \        else:\n            self.nodes[i].remains = remains\n            if remains:\n\
    \                inc self.count\n                when T is SomeNumber: self.total\
    \ += self.nodes[i].value\n            else:\n                dec self.count\n\
    \                when T is SomeNumber: self.total -= self.nodes[i].value\n   \
    \     self.refresh(i)\n\n    proc eraseOperation[T](self: IndexedRetroactivePriorityQueue[T],\
    \ i, rank: int) =\n        ## \u7BC0\u70B9\u3092\u6B8B\u3057\u3066\u64CD\u4F5C\
    \u306E\u307F\u6D88\u3057\u3001\u6700\u7D42\u72B6\u614B\u3092\u66F4\u65B0\u3057\
    \u307E\u3059\u3002O(log M)\u3002\n        case self.nodes[i].operation\n     \
    \   of irqNone: return\n        of irqPush:\n            when T is SomeSignedInt:\
    \ self.pushTotal = self.pushTotal -% self.nodes[i].value\n            elif T is\
    \ SomeNumber: self.pushTotal -= self.nodes[i].value\n            if self.nodes[i].remains:\n\
    \                self.changeRemaining(i, false)\n            else:\n         \
    \       let bridge = self.findBridge(self.root, 0, rank + 1, 0, true)\n      \
    \          let x = self.candidate(self.root, 0, 0, bridge, true)\n           \
    \     self.changeRemaining(x, false)\n        of irqPop:\n            let bridge\
    \ = max(0, self.findBridge(self.root, 0, rank, 0, false))\n            let x =\
    \ self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)\n  \
    \          self.changeRemaining(x, true)\n        self.nodes[i].operation = irqNone\n\
    \        self.nodes[i].value = default(T)\n        self.nodes[i].remains = false\n\
    \        self.refresh(i)\n\n    proc initIndexedRetroactivePriorityQueue*[T](order\
    \ = Ascending): IndexedRetroactivePriorityQueue[T] =\n        ## \u7A7A\u306E\u64CD\
    \u4F5C\u5217\u3092O(1)\u3067\u751F\u6210\u3057\u307E\u3059\u3002Ascending\u306F\
    pop min\u3001Descending\u306Fpop max\u3067\u3059\u3002\n        result = IndexedRetroactivePriorityQueue[T](root:\
    \ 1, order: order,\n            nodes: newSeq[IndexedRetroactiveNode[T]](2))\n\
    \        result.pull(1)\n\n    proc operationCount*[T](self: IndexedRetroactivePriorityQueue[T]):\
    \ int =\n        ## \u64CD\u4F5C\u5217\u306E\u9577\u3055\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\u30AD\u30E5\u30FC\u5185\u306E\u8981\u7D20\u6570len\u3068\u306F\u7570\
    \u306A\u308A\u307E\u3059\u3002O(1)\u3002\n        self.nodes[self.root].size -\
    \ 1\n\n    proc pushCount*[T](self: IndexedRetroactivePriorityQueue[T]): int =\n\
    \        ## \u64CD\u4F5C\u5217\u5185\u306Epush\u306E\u500B\u6570\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\u53D6\u308A\u51FA\u3057\u6E08\u307F\u306Epush\u3082\u542B\u307F\
    \u307E\u3059\u3002O(1)\u3002\n        self.nodes[self.root].pushes\n\n    proc\
    \ popCount*[T](self: IndexedRetroactivePriorityQueue[T]): int =\n        ## \u64CD\
    \u4F5C\u5217\u5185\u306Epop\u306E\u500B\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \u7A7A\u3078\u306Epop\u3082\u542B\u307F\u307E\u3059\u3002O(1)\u3002\n        self.nodes[self.root].pops\n\
    \n    proc setPush*[T](self: IndexedRetroactivePriorityQueue[T], index: int, value:\
    \ T) =\n        ## \u65E2\u5B58\u306Eindex\u756A\u76EE\u306E\u64CD\u4F5C\u3092\
    push\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002O(log(M+2))\u3002\n      \
    \  assert 0 <= index and index < self.operationCount, \"\u64CD\u4F5C\u4F4D\u7F6E\
    \u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        let rank = index + 1\n       \
    \ let i = self.nodeAt(rank)\n        self.eraseOperation(i, rank)\n        let\
    \ bridge = max(0, self.findBridge(self.root, 0, rank, 0, false))\n        let\
    \ x = self.candidate(self.root, 0, bridge, self.nodes[self.root].size, false)\n\
    \        self.nodes[i].operation = irqPush\n        self.nodes[i].value = value\n\
    \        when T is SomeSignedInt: self.pushTotal = self.pushTotal +% value\n \
    \       elif T is SomeNumber: self.pushTotal += value\n        if x == 0 or self.before(x,\
    \ i):\n            self.changeRemaining(i, true)\n        else:\n            self.nodes[i].remains\
    \ = false\n            self.refresh(i)\n            self.changeRemaining(x, true)\n\
    \n    proc setPop*[T](self: IndexedRetroactivePriorityQueue[T], index: int) =\n\
    \        ## \u65E2\u5B58\u306Eindex\u756A\u76EE\u306E\u64CD\u4F5C\u3092pop\u3067\
    \u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002O(log(M+2))\u3002\n        assert 0\
    \ <= index and index < self.operationCount, \"\u64CD\u4F5C\u4F4D\u7F6E\u304C\u7BC4\
    \u56F2\u5916\u3067\u3059\"\n        let rank = index + 1\n        let i = self.nodeAt(rank)\n\
    \        if self.nodes[i].operation == irqPop: return\n        self.eraseOperation(i,\
    \ rank)\n        let bridge = self.findBridge(self.root, 0, rank, 0, true)\n \
    \       let x = self.candidate(self.root, 0, 0, bridge, true)\n        self.changeRemaining(x,\
    \ false)\n        self.nodes[i].operation = irqPop\n        self.refresh(i)\n\n\
    \    proc insertPush*[T](self: IndexedRetroactivePriorityQueue[T], index: int,\
    \ value: T): int {.discardable.} =\n        ## index\u306E\u76F4\u524D\u306Bpush\u3092\
    \u633F\u5165\u3057\u3001\u64CD\u4F5CID\u3092\u8FD4\u3057\u307E\u3059\u3002index=operationCount\u306A\
    \u3089\u672B\u5C3E\u3067\u3059\u3002\u511F\u5374O(log(M+2))\u3002\n        assert\
    \ 0 <= index and index <= self.operationCount, \"\u633F\u5165\u4F4D\u7F6E\u304C\
    \u7BC4\u56F2\u5916\u3067\u3059\"\n        result = self.addEmptyNode(index + 1)\n\
    \        self.setPush(index, value)\n\n    proc insertPop*[T](self: IndexedRetroactivePriorityQueue[T],\
    \ index: int): int {.discardable.} =\n        ## index\u306E\u76F4\u524D\u306B\
    pop\u3092\u633F\u5165\u3057\u3001\u64CD\u4F5CID\u3092\u8FD4\u3057\u307E\u3059\u3002\
    index=operationCount\u306A\u3089\u672B\u5C3E\u3067\u3059\u3002\u511F\u5374O(log(M+2))\u3002\
    \n        assert 0 <= index and index <= self.operationCount, \"\u633F\u5165\u4F4D\
    \u7F6E\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        result = self.addEmptyNode(index\
    \ + 1)\n        self.setPop(index)\n\n    proc operationIndex[T](self: IndexedRetroactivePriorityQueue[T],\
    \ k: int, push: bool): int =\n        ## \u7A2E\u985E\u5225\u306Ek\u756A\u76EE\
    \u306E\u64CD\u4F5C\u306E\u4F4D\u7F6E\u3092\u6C42\u3081\u307E\u3059\u3002O(log(M+2))\u3002\
    \n        let count = if push: self.pushCount else: self.popCount\n        assert\
    \ 0 <= k and k < count, \"\u6307\u5B9A\u3057\u305F\u7A2E\u985E\u306E\u64CD\u4F5C\
    \u756A\u53F7\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        var i = self.root\n\
    \        var start = 0\n        var rank = k\n        while i != 0:\n        \
    \    let l = self.nodes[i].left\n            let leftCount = if push: self.nodes[l].pushes\
    \ else: self.nodes[l].pops\n            if rank < leftCount:\n               \
    \ i = l\n                continue\n            rank -= leftCount\n           \
    \ let mid = start + self.nodes[l].size\n            if self.nodes[i].operation\
    \ == (if push: irqPush else: irqPop):\n                if rank == 0: return mid\
    \ - 1\n                dec rank\n            start = mid + 1\n            i =\
    \ self.nodes[i].right\n\n    proc pushIndex*[T](self: IndexedRetroactivePriorityQueue[T],\
    \ k: int): int =\n        ## \u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067k\u756A\
    \u76EE\u306Epush\u306E\u4F4D\u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002k\u306F\
    0\u59CB\u307E\u308A\u3067\u3059\u3002O(log(M+2))\u3002\n        self.operationIndex(k,\
    \ true)\n\n    proc popIndex*[T](self: IndexedRetroactivePriorityQueue[T], k:\
    \ int): int =\n        ## \u73FE\u5728\u306E\u64CD\u4F5C\u5217\u3067k\u756A\u76EE\
    \u306Epop\u306E\u4F4D\u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u3078\u306E\
    pop\u3082\u6570\u3048\u307E\u3059\u3002O(log(M+2))\u3002\n        self.operationIndex(k,\
    \ false)\n\n    proc insertPushBeforePop*[T](self: IndexedRetroactivePriorityQueue[T],\
    \ k: int, value: T): int {.discardable.} =\n        ## 0\u59CB\u307E\u308A\u3067\
    k\u756A\u76EE\u306Epop\u306E\u76F4\u524D\u306Bpush\u3092\u633F\u5165\u3057\u3001\
    \u64CD\u4F5CID\u3092\u8FD4\u3057\u307E\u3059\u3002\u511F\u5374O(log(M+2))\u3002\
    \n        self.insertPush(self.popIndex(k), value)\n\n    proc insertPopBeforePush*[T](self:\
    \ IndexedRetroactivePriorityQueue[T], k: int): int {.discardable.} =\n       \
    \ ## 0\u59CB\u307E\u308A\u3067k\u756A\u76EE\u306Epush\u306E\u76F4\u524D\u306B\
    pop\u3092\u633F\u5165\u3057\u3001\u64CD\u4F5CID\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \u511F\u5374O(log(M+2))\u3002\n        self.insertPop(self.pushIndex(k))\n\n \
    \   proc erase*[T](self: IndexedRetroactivePriorityQueue[T], index: int) =\n \
    \       ## index\u756A\u76EE\u306E\u64CD\u4F5C\u3092\u524A\u9664\u3057\u307E\u3059\
    \u3002\u5F8C\u7D9A\u306E\u4F4D\u7F6E\u306F1\u3064\u524D\u306B\u305A\u308C\u307E\
    \u3059\u3002\u511F\u5374O(log(M+2))\u3002\n        assert 0 <= index and index\
    \ < self.operationCount, \"\u64CD\u4F5C\u4F4D\u7F6E\u304C\u7BC4\u56F2\u5916\u3067\
    \u3059\"\n        let rank = index + 1\n        let i = self.nodeAt(rank)\n  \
    \      self.eraseOperation(i, rank)\n        self.root = self.deleteNode(self.root,\
    \ rank)\n        self.nodes[self.root].parent = 0\n        self.idNodes[self.nodes[i].operationId]\
    \ = 0\n        self.nodes[i] = default(IndexedRetroactiveNode[T])\n        self.free.add(i)\n\
    \n    proc indexOf*[T](self: IndexedRetroactivePriorityQueue[T], id: int): int\
    \ =\n        ## \u64CD\u4F5CID\u306E\u73FE\u5728\u4F4D\u7F6E\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\u524A\u9664\u6E08\u307F\u30FB\u672A\u767A\u884CID\u306A\u3089\
    -1\u3067\u3059\u3002O(log(M+2))\u3002\n        if id < 0 or id >= self.idNodes.len\
    \ or self.idNodes[id] == 0: return -1\n        self.nodeRank(self.idNodes[id])\
    \ - 1\n\n    proc eraseById*[T](self: IndexedRetroactivePriorityQueue[T], id:\
    \ int) =\n        ## \u64CD\u4F5CID\u3067\u524A\u9664\u3057\u307E\u3059\u3002\u524A\
    \u9664\u6E08\u307F\u30FB\u672A\u767A\u884CID\u306A\u3089\u4F55\u3082\u3057\u307E\
    \u305B\u3093\u3002\u511F\u5374O(log(M+2))\u3002\n        let index = self.indexOf(id)\n\
    \        if index >= 0: self.erase(index)\n\n    proc len*[T](self: IndexedRetroactivePriorityQueue[T]):\
    \ int =\n        ## \u5168\u64CD\u4F5C\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\u5B9F\
    \u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.count\n\
    \n    proc sum*[T: SomeNumber](self: IndexedRetroactivePriorityQueue[T]): T =\n\
    \        ## \u5168\u64CD\u4F5C\u5B9F\u884C\u5F8C\u306B\u6B8B\u308B\u5024\u306E\
    \u7DCF\u548C\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.total\n\
    \n    proc peek*[T](self: IndexedRetroactivePriorityQueue[T]): Option[T] =\n \
    \       ## \u6700\u7D42\u72B6\u614B\u306E\u6700\u512A\u5148\u8981\u7D20\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\u7A7A\u306A\u3089none\u3067\u3059\u3002O(1)\u3002\n \
    \       let i = self.nodes[self.root].remaining\n        if i <= 1: none(T) else:\
    \ some(self.nodes[i].value)\n\n    proc isRemaining*[T](self: IndexedRetroactivePriorityQueue[T],\
    \ index: int): bool =\n        ## index\u756A\u76EE\u306E\u64CD\u4F5C\u304C\u6700\
    \u5F8C\u306B\u6B8B\u308Bpush\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002O(log(M+2))\u3002\
    \n        assert 0 <= index and index < self.operationCount, \"\u64CD\u4F5C\u4F4D\
    \u7F6E\u304C\u7BC4\u56F2\u5916\u3067\u3059\"\n        let i = self.nodeAt(index\
    \ + 1)\n        self.nodes[i].operation == irqPush and self.nodes[i].remains\n\
    \n    proc poppedSum*[T: SomeNumber](self: IndexedRetroactivePriorityQueue[T]):\
    \ T =\n        ## pop\u3055\u308C\u305F\u5024\u306E\u7DCF\u548C\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(1)\u3002\u6D6E\u52D5\u5C0F\u6570\u70B9\u3067\u306F\u5DEE\u306B\
    \u3088\u308B\u6841\u843D\u3061\u306B\u6CE8\u610F\u3057\u3066\u304F\u3060\u3055\
    \u3044\u3002\n        ## \u6574\u6570\u306F\u8FD4\u308A\u5024\u304C\u578B\u306B\
    \u53CE\u307E\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\u5185\u90E8\
    \u306E\u5168push\u7DCF\u548C\u306F\u6841\u3042\u3075\u308C\u3092\u8A31\u5BB9\u3057\
    \u307E\u3059\u3002\n        when T is SomeSignedInt: self.pushTotal -% self.total\n\
    \        else: self.pushTotal - self.total\n\n    proc debugOperations*[T](self:\
    \ IndexedRetroactivePriorityQueue[T]): seq[QueueDebugEntry[int, T]] =\n      \
    \  ## \u73FE\u5728\u306E\u4F4D\u7F6E\u3092time\u3068\u3057\u305F\u64CD\u4F5C\u4E00\
    \u89A7\u3092\u8FD4\u3057\u307E\u3059\u3002pop\u7D50\u679C\u306F\u672A\u8A08\u7B97\
    \u3067\u3059\u3002O(M)\u3002\n        var stack: seq[int]\n        var i = self.root\n\
    \        while i != 0 or stack.len > 0:\n            while i != 0:\n         \
    \       stack.add(i)\n                i = self.nodes[i].left\n            i =\
    \ stack.pop()\n            if i != 1:\n                var entry = QueueDebugEntry[int,\
    \ T](time: result.len)\n                case self.nodes[i].operation\n       \
    \         of irqNone: entry.kind = qdkNone\n                of irqPush:\n    \
    \                entry.kind = qdkPush\n                    entry.value = some(self.nodes[i].value)\n\
    \                of irqPop: entry.kind = qdkPop\n                result.add(entry)\n\
    \            i = self.nodes[i].right\n\n    proc debugTimeline*[T](self: IndexedRetroactivePriorityQueue[T]):\
    \ seq[QueueDebugEntry[int, T]] =\n        ## \u64CD\u4F5C\u4E00\u89A7\u306B\u5B9F\
    \u969B\u306Epop\u7D50\u679C\u3092\u4ED8\u3051\u3066\u8FD4\u3057\u307E\u3059\u3002\
    O(M log(M+2))\u6642\u9593\u30FBO(M)\u7A7A\u9593\u3002\n        result = self.debugOperations()\n\
    \        replayQueueDebug(result, self.order)\n\n    proc debugDump*[T](self:\
    \ IndexedRetroactivePriorityQueue[T]): string =\n        ## \u64CD\u4F5C\u3068\
    \u5B9F\u969B\u306Epop\u7D50\u679C\u3092\u8868\u793A\u7528\u6587\u5B57\u5217\u3067\
    \u8FD4\u3057\u307E\u3059\u3002O(M log(M+2)+\u51FA\u529B\u6587\u5B57\u6570)\u3002\
    \n        formatQueueDebug(self.debugTimeline())\n\n    proc `$`*[T](self: IndexedRetroactivePriorityQueue[T]):\
    \ string =\n        ## debugDump\u3068\u540C\u3058\u6587\u5B57\u5217\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(M log(M+2)+\u51FA\u529B\u6587\u5B57\u6570)\u3002\n \
    \       self.debugDump()\n"
  dependsOn:
  - cplib/collections/retroactive_priority_queue.nim
  - cplib/collections/retroactive_priority_queue.nim
  isVerificationFile: false
  path: cplib/collections/indexed_retroactive_priority_queue.nim
  requiredBy: []
  timestamp: '2026-09-28 02:12:34+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/indexed_retroactive_priority_queue_test.nim
  - verify/collections/indexed_retroactive_priority_queue_test.nim
documentation_of: cplib/collections/indexed_retroactive_priority_queue.nim
layout: document
redirect_from:
- /library/cplib/collections/indexed_retroactive_priority_queue.nim
- /library/cplib/collections/indexed_retroactive_priority_queue.nim.html
title: cplib/collections/indexed_retroactive_priority_queue.nim
---
