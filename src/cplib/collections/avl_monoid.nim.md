---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/avl_balance_test.nim
    title: verify/collections/avl_balance_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avl_balance_test.nim
    title: verify/collections/avl_balance_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_AVL_MONOID:\n    const CPLIB_COLLECTIONS_AVL_MONOID*\
    \ = 1\n    import cplib/utils/backwards_index\n    import strutils\n\n    type\
    \ AvlMonoidNode[T] = ref object\n        left, right: AvlMonoidNode[T]\n     \
    \   height: int\n        size: int\n        value, prod: T\n\n    type AvlMonoid*[T]\
    \ = ref object\n        root: AvlMonoidNode[T]\n        length: int\n        op:\
    \ proc(x, y: T): T\n        e: T\n\n    proc nodeLen[T](node: AvlMonoidNode[T]):\
    \ int {.inline.} =\n        ## \u90E8\u5206\u6728\u306E\u8981\u7D20\u6570\u3092\
    \u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil: 0 else: node.size\n\
    \n    proc nodeHeight[T](node: AvlMonoidNode[T]): int {.inline.} =\n        ##\
    \ \u90E8\u5206\u6728\u306E\u9AD8\u3055\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        if node.isNil: 0 else: node.height\n\n    proc nodeProd[T](node: AvlMonoidNode[T],\
    \ e: T): T {.inline.} =\n        ## \u90E8\u5206\u6728\u306E\u7DCF\u7A4D\u3092\
    \u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil: e else: node.prod\n\
    \n    proc update[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T) =\n \
    \       ## \u5B50\u306E\u60C5\u5831\u304B\u3089\u30CE\u30FC\u30C9\u306E\u96C6\u7D04\
    \u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil:\
    \ return\n        node.size = 1 + node.left.nodeLen + node.right.nodeLen\n   \
    \     node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)\n   \
    \     node.prod = op(op(node.left.nodeProd(e), node.value), node.right.nodeProd(e))\n\
    \n    proc newNode[T](value: T): AvlMonoidNode[T] =\n        ## \u4E00\u8981\u7D20\
    \u306E\u30CE\u30FC\u30C9\u3092\u4F5C\u308A\u307E\u3059\u3002O(1)\u3002\n     \
    \   AvlMonoidNode[T](height: 1, size: 1, value: value, prod: value)\n\n    proc\
    \ buildRange[T](v: openArray[T], l, r: int, op: proc(x, y: T): T, e: T): AvlMonoidNode[T]\
    \ =\n        ## \u6307\u5B9A\u533A\u9593\u304B\u3089\u9AD8\u3055\u306E\u91E3\u308A\
    \u5408\u3063\u305F\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(r-l)\u3002\
    \n        if l == r: return nil\n        let mid = (l + r) shr 1\n        result\
    \ = newNode(v[mid])\n        result.left = buildRange(v, l, mid, op, e)\n    \
    \    result.right = buildRange(v, mid + 1, r, op, e)\n        result.update(op,\
    \ e)\n\n    proc build[T](v: openArray[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T]\
    \ =\n        ## \u914D\u5217\u304B\u3089 AVL \u6728\u3092\u69CB\u7BC9\u3057\u307E\
    \u3059\u3002O(N)\u3002\n        buildRange(v, 0, v.len, op, e)\n\n\n    proc rotateLeft[T](node:\
    \ AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =\n        ##\
    \ \u5DE6\u56DE\u8EE2\u3057\u3001\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\
    \u3059\u3002O(1)\u3002\n        var child = move(node.right)\n        node.right\
    \ = move(child.left)\n        child.left = node\n        node.update(op, e)\n\
    \        child.update(op, e)\n        child\n\n    proc rotateRight[T](node: AvlMonoidNode[T],\
    \ op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =\n        ## \u53F3\u56DE\u8EE2\
    \u3057\u3001\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        var child = move(node.left)\n        node.left = move(child.right)\n\
    \        child.right = node\n        node.update(op, e)\n        child.update(op,\
    \ e)\n        child\n\n    proc rebalance[T](node: AvlMonoidNode[T], op: proc(x,\
    \ y: T): T, e: T): AvlMonoidNode[T] =\n        ## \u90E8\u5206\u6728\u3092 AVL\
    \ \u6761\u4EF6\u306B\u623B\u3057\u307E\u3059\u3002O(1)\u3002\n        node.update(op,\
    \ e)\n        if node.left.nodeHeight > node.right.nodeHeight + 1:\n         \
    \   if node.left.left.nodeHeight < node.left.right.nodeHeight:\n             \
    \   var child = move(node.left)\n                node.left = child.rotateLeft(op,\
    \ e)\n            return node.rotateRight(op, e)\n        if node.right.nodeHeight\
    \ > node.left.nodeHeight + 1:\n            if node.right.right.nodeHeight < node.right.left.nodeHeight:\n\
    \                var child = move(node.right)\n                node.right = child.rotateRight(op,\
    \ e)\n            return node.rotateLeft(op, e)\n        node\n\n    proc join[T](left,\
    \ pivot, right: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T]\
    \ =\n        ## \u8981\u7D20\u4E00\u3064\u3092\u631F\u3093\u3067\u4E8C\u3064\u306E\
    \u6728\u3092\u7D50\u5408\u3057\u307E\u3059\u3002O(|hL-hR|+1)\u3002\n        if\
    \ left.nodeHeight > right.nodeHeight + 1:\n            var branch = move(left.right)\n\
    \            left.right = join(branch, pivot, right, op, e)\n            return\
    \ left.rebalance(op, e)\n        if right.nodeHeight > left.nodeHeight + 1:\n\
    \            var branch = move(right.left)\n            right.left = join(left,\
    \ pivot, branch, op, e)\n            return right.rebalance(op, e)\n        pivot.left\
    \ = left\n        pivot.right = right\n        pivot.update(op, e)\n        pivot\n\
    \n    proc popMax[T](node: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): (AvlMonoidNode[T],\
    \ AvlMonoidNode[T]) =\n        ## \u6700\u5927\u4F4D\u7F6E\u306E\u30CE\u30FC\u30C9\
    \u3092\u53D6\u308A\u51FA\u3057\u307E\u3059\u3002O(log N)\u3002\n        if node.right.isNil:\n\
    \            var branch = move(node.left)\n            result = (branch, node)\n\
    \            node.update(op, e)\n        else:\n            var branch = move(node.right)\n\
    \            var (rest, pivot) = popMax(branch, op, e)\n            node.right\
    \ = rest\n            result = (node.rebalance(op, e), pivot)\n\n    proc merge[T](left,\
    \ right: AvlMonoidNode[T], op: proc(x, y: T): T, e: T): AvlMonoidNode[T] =\n \
    \       ## \u4E8C\u3064\u306E\u6728\u3092\u9806\u5E8F\u3092\u4FDD\u3063\u3066\u7D50\
    \u5408\u3057\u307E\u3059\u3002O(log N)\u3002\n        if left.isNil: return right\n\
    \        if right.isNil: return left\n        var (rest, pivot) = popMax(left,\
    \ op, e)\n        join(rest, pivot, right, op, e)\n\n    proc split[T](node: AvlMonoidNode[T],\
    \ k: int, op: proc(x, y: T): T, e: T): (AvlMonoidNode[T], AvlMonoidNode[T]) =\n\
    \        ## \u5148\u982D k \u8981\u7D20\u3067\u6728\u3092\u5206\u5272\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        if node.isNil: return (nil, nil)\n       \
    \ let leftSize = node.left.nodeLen\n        var leftTree = move(node.left)\n \
    \       var rightTree = move(node.right)\n        if k <= leftSize:\n        \
    \    var (left, middle) = split(leftTree, k, op, e)\n            return (left,\
    \ join(middle, node, rightTree, op, e))\n        else:\n            var (middle,\
    \ right) = split(rightTree, k - leftSize - 1, op, e)\n            return (join(leftTree,\
    \ node, middle, op, e), right)\n\n    proc initAvlMonoid*[T](v: openArray[T],\
    \ op: proc(x, y: T): T, e: T): AvlMonoid[T] =\n        ## v\u3067\u521D\u671F\u5316\
    \u3057\u307E\u3059\u3002\n        ## \u633F\u5165\u3001\u524A\u9664\u3001\u4E00\
    \u70B9\u53D6\u5F97\u3001\u4E00\u70B9\u66F4\u65B0\u3001\u533A\u9593\u7DCF\u7A4D\
    \u306F\u3059\u3079\u3066O(log N)\u3067\u3059\u3002\n        AvlMonoid[T](root:\
    \ build(v, op, e), length: v.len, op: op, e: e)\n\n    proc toAvlMonoid*[T](v:\
    \ openArray[T], op: proc(x, y: T): T, e: T): AvlMonoid[T] =\n        ## \u914D\
    \u5217\u3092\u30E2\u30CE\u30A4\u30C9\u4ED8\u304D\u5217\u306B\u5909\u63DB\u3057\
    \u307E\u3059\u3002O(N)\u3002\n        initAvlMonoid(v, op, e)\n\n    template\
    \ newAvlMonoidWith*(V, op, e: untyped): untyped =\n        initAvlMonoid[typeof(e)](V,\
    \ proc (l{.inject.}, r{.inject.}: typeof(e)): typeof(e) = op, e)\n\n    proc len*[T](self:\
    \ AvlMonoid[T]): int =\n        ## \u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(1)\u3002\n        self.length\n\n    proc split*[T](self: AvlMonoid[T],\
    \ k: int): (AvlMonoid[T], AvlMonoid[T]) =\n        ## \u5148\u982D k \u8981\u7D20\
    \u3067\u5206\u5272\u3057\u3001\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        assert 0 <= k and k <= self.length, \"0 <=\
    \ k <= len \u304C\u5FC5\u8981\u3067\u3059\"\n        let n = self.length\n   \
    \     var root = move(self.root)\n        let (leftRoot, rightRoot) = split(root,\
    \ k, self.op, self.e)\n        self.length = 0\n        result = (\n         \
    \   AvlMonoid[T](root: leftRoot, length: k, op: self.op, e: self.e),\n       \
    \     AvlMonoid[T](root: rightRoot, length: n - k, op: self.op, e: self.e)\n \
    \       )\n\n    proc merge*[T](left, right: AvlMonoid[T]): AvlMonoid[T] =\n \
    \       ## \u5DE6\u53F3\u306E\u5217\u3092\u9023\u7D50\u3057\u3001\u4E21\u65B9\u306E\
    \u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002\u540C\u3058\u6F14\
    \u7B97\u304C\u5FC5\u8981\u3067\u3059\u3002O(log N)\u3002\n        assert left\
    \ != right, \"\u540C\u3058\u5217\u3092\u9023\u7D50\u3067\u304D\u307E\u305B\u3093\
    \"\n        let n = left.length + right.length\n        var leftRoot = move(left.root)\n\
    \        var rightRoot = move(right.root)\n        result = AvlMonoid[T](root:\
    \ merge(leftRoot, rightRoot, left.op, left.e), length: n, op: left.op, e: left.e)\n\
    \        left.length = 0\n        right.length = 0\n\n    proc insertNode[T](self:\
    \ AvlMonoid[T], root, node: AvlMonoidNode[T], k: int): AvlMonoidNode[T] =\n  \
    \      ## \u6307\u5B9A\u4F4D\u7F6E\u306B\u30CE\u30FC\u30C9\u3092\u633F\u5165\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        if root.isNil: return node\n       \
    \ let leftSize = root.left.nodeLen\n        if k <= leftSize:\n            var\
    \ branch = move(root.left)\n            root.left = self.insertNode(branch, node,\
    \ k)\n        else:\n            var branch = move(root.right)\n            root.right\
    \ = self.insertNode(branch, node, k - leftSize - 1)\n        root.rebalance(self.op,\
    \ self.e)\n\n    proc insert*[T](self: AvlMonoid[T], index: int, value: T) =\n\
    \        ## index \u306E\u76F4\u524D\u306B\u633F\u5165\u3059\u308B\u3002index\
    \ = len \u306A\u3089\u672B\u5C3E\u3002\n        assert 0 <= index and index <=\
    \ self.len, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\
    \u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index\
    \ and index <= self.len\"\n        let node = newNode(value)\n        self.root\
    \ = self.insertNode(self.root, node, index)\n        inc self.length\n\n    proc\
    \ insort*[T](self: AvlMonoid[T], value: T, less: proc(x, y: T): bool): int {.discardable.}\
    \ =\n        ## \u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\u5024\u306E\
    \u672B\u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\u3001\u305D\
    \u306E\u4F4D\u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n       \
    \ var node = self.root\n        while not node.isNil:\n            if less(value,\
    \ node.value):\n                node = node.left\n            else:\n        \
    \        result += node.left.nodeLen + 1\n                node = node.right\n\
    \        self.insert(result, value)\n\n    proc insort*[T](self: AvlMonoid[T],\
    \ value: T): int {.discardable.} =\n        ## < \u3067\u30BD\u30FC\u30C8\u6E08\
    \u307F\u306E\u5217\u3078\u540C\u5024\u306E\u672B\u5C3E\u3068\u306A\u308B\u4F4D\
    \u7F6E\u306B\u633F\u5165\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.insort(value,\
    \ proc(x, y: T): bool = x < y)\n\n    proc eraseNode[T](self: AvlMonoid[T], node:\
    \ AvlMonoidNode[T], k: int): AvlMonoidNode[T] =\n        ## \u6307\u5B9A\u4F4D\
    \u7F6E\u306E\u30CE\u30FC\u30C9\u3092\u524A\u9664\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        let leftSize = node.left.nodeLen\n        if k == leftSize:\n\
    \            var left = move(node.left)\n            var right = move(node.right)\n\
    \            return merge(left, right, self.op, self.e)\n        if k < leftSize:\n\
    \            var branch = move(node.left)\n            node.left = self.eraseNode(branch,\
    \ k)\n        else:\n            var branch = move(node.right)\n            node.right\
    \ = self.eraseNode(branch, k - leftSize - 1)\n        return node.rebalance(self.op,\
    \ self.e)\n\n    proc erase*[T](self: AvlMonoid[T], index: int) =\n        ##\
    \ \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\u533A\u9593\u306E\u8981\u7D20\u3092\
    \u524A\u9664\u3057\u307E\u3059\u3002\u6728\u306E\u64CD\u4F5C\u306FO(log N)\u3002\
    \n        assert 0 <= index and index < self.len, \"\u6307\u5B9A\u3057\u305F\u5024\
    \u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059: 0 <= index and index < self.len\"\n        self.root\
    \ = self.eraseNode(self.root, index)\n        dec self.length\n\n    proc erase*[T](self:\
    \ AvlMonoid[T], l, r: int) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\
    \u533A\u9593\u306E\u8981\u7D20\u3092\u524A\u9664\u3057\u307E\u3059\u3002\u6728\
    \u306E\u64CD\u4F5C\u306FO(log N)\u3002\n        assert 0 <= l and l <= r and r\
    \ <= self.len, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\
    \u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <=\
    \ l and l <= r and r <= self.len\"\n        if l == r: return\n        let (left,\
    \ rest) = split(self.root, l, self.op, self.e)\n        let (_, right) = split(rest,\
    \ r - l, self.op, self.e)\n        self.root = merge(left, right, self.op, self.e)\n\
    \        self.length -= r - l\n\n    proc erase*[T](self: AvlMonoid[T], segment:\
    \ HSlice[int, int]) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\u533A\
    \u9593\u306E\u8981\u7D20\u3092\u524A\u9664\u3057\u307E\u3059\u3002\u6728\u306E\
    \u64CD\u4F5C\u306FO(log N)\u3002\n        self.erase(segment.a, segment.b + 1)\n\
    \n    proc get*[T](self: AvlMonoid[T], index: int): T =\n        ## index\u756A\
    \u76EE\u306E\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert 0 <= index\
    \ and index < self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : 0 <= index and index < self.length\"\n        var node = self.root\n       \
    \ var k = index\n        while true:\n            let leftSize = node.left.nodeLen\n\
    \            if k < leftSize:\n                node = node.left\n            elif\
    \ k == leftSize:\n                return node.value\n            else:\n     \
    \           k -= leftSize + 1\n                node = node.right\n\n    proc getNode[T](self:\
    \ AvlMonoid[T], node: AvlMonoidNode[T], l, r: int): T =\n        ## \u90E8\u5206\
    \u6728\u306E\u6307\u5B9A\u533A\u9593\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        if l == 0 and r == node.size: return node.prod\n\
    \        let mid = node.left.nodeLen\n        if r <= mid: return self.getNode(node.left,\
    \ l, r)\n        if l > mid: return self.getNode(node.right, l - mid - 1, r -\
    \ mid - 1)\n        result = node.value\n        if l < mid: result = self.op(self.getNode(node.left,\
    \ l, mid), result)\n        if r > mid + 1: result = self.op(result, self.getNode(node.right,\
    \ 0, r - mid - 1))\n\n    proc get*[T](self: AvlMonoid[T], l, r: int): T =\n \
    \       ## \u534A\u958B\u533A\u9593 [l, r) \u306E\u7DCF\u7A4D\u3092\u8FD4\u3059\
    \u3002\n        assert 0 <= l and l <= r and r <= self.len, \"\u6307\u5B9A\u3057\
    \u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.len\"\
    \n        if l == r: return self.e\n        self.getNode(self.root, l, r)\n\n\
    \    proc get*[T](self: AvlMonoid[T], segment: HSlice[int, int]): T =\n      \
    \  ## \u9589\u533A\u9593segment\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        assert segment.a <= segment.b + 1 and 0 <= segment.a and segment.b\
    \ + 1 <= self.length, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\
    \u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059: segment.a <= segment.b + 1 and 0 <= segment.a and segment.b + 1 <= self.length\"\
    \n        self.get(segment.a, segment.b + 1)\n\n    proc fold*[T](self: AvlMonoid[T],\
    \ l, r: int): T =\n        ## \u6307\u5B9A\u533A\u9593\u307E\u305F\u306F\u5168\
    \u4F53\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\u533A\u9593\u306F\
    O(log N)\u3001\u5168\u4F53\u306F O(1)\u3002\n        self.get(l, r)\n\n    proc\
    \ fold*[T](self: AvlMonoid[T], segment: HSlice[int, int]): T =\n        ## \u6307\
    \u5B9A\u533A\u9593\u307E\u305F\u306F\u5168\u4F53\u306E\u7DCF\u7A4D\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\u533A\u9593\u306FO(log N)\u3001\u5168\u4F53\u306F O(1)\u3002\
    \n        self.get(segment)\n\n    proc fold*[T](self: AvlMonoid[T]): T =\n  \
    \      ## \u6307\u5B9A\u533A\u9593\u307E\u305F\u306F\u5168\u4F53\u306E\u7DCF\u7A4D\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\u533A\u9593\u306FO(log N)\u3001\u5168\u4F53\
    \u306F O(1)\u3002\n        self.root.nodeProd(self.e)\n\n    proc get_all*[T](self:\
    \ AvlMonoid[T]): T =\n        ## [0,len(self))\u533A\u9593\u306E\u7DCF\u7A4D\u3092\
    O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.root.nodeProd(self.e)\n\
    \n    proc updateNode[T](self: AvlMonoid[T], node: AvlMonoidNode[T], k: int, value:\
    \ T) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\u66F4\u65B0\u3057\
    \u3001\u96C6\u7D04\u5024\u3092\u518D\u8A08\u7B97\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        let leftSize = node.left.nodeLen\n        if k == leftSize:\n\
    \            node.value = value\n        elif k < leftSize:\n            self.updateNode(node.left,\
    \ k, value)\n        else:\n            self.updateNode(node.right, k - leftSize\
    \ - 1, value)\n        node.update(self.op, self.e)\n\n    proc update*[T](self:\
    \ AvlMonoid[T], index: Natural, value: T) =\n        ## index \u756A\u76EE\u306E\
    \u5024\u3092 value \u306B\u5909\u66F4\u3059\u308B\u3002\n        assert index\
    \ < self.len, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\
    \u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: index < self.len\"\
    \n        self.updateNode(self.root, index, value)\n\n    proc searchRight[T](self:\
    \ AvlMonoid[T], node: AvlMonoidNode[T], start, l: int, acc: var T, f: proc(x:\
    \ T): bool): int =\n        ## \u53F3\u65B9\u5411\u306B\u6761\u4EF6\u3092\u6E80\
    \u305F\u3059\u5883\u754C\u3092\u63A2\u3057\u307E\u3059\u3002O(log N)\u3002\n \
    \       let finish = start + node.nodeLen\n        if node.isNil or finish <=\
    \ l: return finish\n        if l <= start:\n            let next = self.op(acc,\
    \ node.prod)\n            if f(next):\n                acc = next\n          \
    \      return finish\n        let mid = start + node.left.nodeLen\n        result\
    \ = self.searchRight(node.left, start, l, acc, f)\n        if result < mid: return\n\
    \        if l <= mid:\n            let next = self.op(acc, node.value)\n     \
    \       if not f(next): return mid\n            acc = next\n        result = self.searchRight(node.right,\
    \ mid + 1, l, acc, f)\n\n    proc max_right*[T](self: AvlMonoid[T], l: int, f:\
    \ proc(x: T): bool): int =\n        ## f(get(l, r)) \u304C\u771F\u3068\u306A\u308B\
    \u6700\u5927\u306E r \u3092\u8FD4\u3059\u3002\n        ## f(e) = true \u3067\u3001\
    \u533A\u9593\u3092\u4F38\u3070\u3057\u305F\u3068\u304D\u771F\u304B\u3089\u507D\
    \u3078\u306E\u5909\u5316\u304C\u5358\u8ABF\u3067\u3042\u308B\u3053\u3068\u3002\
    \n        assert 0 <= l and l <= self.len, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\
    \u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059: 0 <= l and l <= self.len\"\n        assert f(self.e), \"\u5224\
    \u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\
    \u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var acc = self.e\n\
    \        self.searchRight(self.root, 0, l, acc, f)\n\n    proc searchLeft[T](self:\
    \ AvlMonoid[T], node: AvlMonoidNode[T], start, r: int, acc: var T, f: proc(x:\
    \ T): bool): int =\n        ## \u5DE6\u65B9\u5411\u306B\u6761\u4EF6\u3092\u6E80\
    \u305F\u3059\u5883\u754C\u3092\u63A2\u3057\u307E\u3059\u3002O(log N)\u3002\n \
    \       if node.isNil or r <= start: return start\n        if start + node.size\
    \ <= r:\n            let next = self.op(node.prod, acc)\n            if f(next):\n\
    \                acc = next\n                return start\n        let mid = start\
    \ + node.left.nodeLen\n        result = self.searchLeft(node.right, mid + 1, r,\
    \ acc, f)\n        if result > mid + 1: return\n        if mid < r:\n        \
    \    let next = self.op(node.value, acc)\n            if not f(next): return mid\
    \ + 1\n            acc = next\n        result = self.searchLeft(node.left, start,\
    \ r, acc, f)\n\n    proc min_left*[T](self: AvlMonoid[T], r: int, f: proc(x: T):\
    \ bool): int =\n        ## f(get(l, r)) \u304C\u771F\u3068\u306A\u308B\u6700\u5C0F\
    \u306E l \u3092\u8FD4\u3059\u3002\n        ## f(e) = true \u3067\u3001\u533A\u9593\
    \u3092\u4F38\u3070\u3057\u305F\u3068\u304D\u771F\u304B\u3089\u507D\u3078\u306E\
    \u5909\u5316\u304C\u5358\u8ABF\u3067\u3042\u308B\u3053\u3068\u3002\n        assert\
    \ 0 <= r and r <= self.len, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\
    \u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059: 0 <= r and r <= self.len\"\n        assert f(self.e), \"\u5224\u5B9A\u95A2\
    \u6570\u306F\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059\"\n        var acc = self.e\n        self.searchLeft(self.root,\
    \ 0, r, acc, f)\n\n    proc `[]`*[T](self: AvlMonoid[T], index: int): T =\n  \
    \      ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\u533A\u9593\u306E\
    \u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.get(index)\n\
    \n    proc `[]`*[T](self: AvlMonoid[T], index: BackwardsIndex): T =\n        ##\
    \ \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\u533A\u9593\u306E\u7DCF\
    \u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.get(self.length\
    \ - int(index))\n\n    proc `[]`*[T](self: AvlMonoid[T], segment: HSlice[int,\
    \ int]): T =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\
    \u533A\u9593\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        self.get(segment)\n\n    proc `[]=`*[T](self: AvlMonoid[T], index: Natural,\
    \ value: T) {.backwardsIndex.} =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\
    \u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.update(index,\
    \ value)\n\n    iterator items*[T](self: AvlMonoid[T]): T =\n        if not self.root.isNil:\n\
    \            var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                var (t, node) = stack.pop()\n                if t == 0:\n   \
    \                 if not node.right.isNil: stack.add((0, node.right))\n      \
    \              stack.add((1, node))\n                    if not node.left.isNil:\
    \ stack.add((0, node.left))\n                else:\n                    yield\
    \ node.value\n\n    proc toSeq*[T](self: AvlMonoid[T]): seq[T] =\n        ## \u5168\
    \u8981\u7D20\u3092\u914D\u5217\u3068\u3057\u3066\u8FD4\u3057\u307E\u3059\u3002\
    O(N)\u3002\n        for x in self:\n            result.add(x)\n\n    proc `$`*[T](self:\
    \ AvlMonoid[T]): string =\n        ## \u5168\u8981\u7D20\u306E\u6587\u5B57\u5217\
    \u8868\u73FE\u3092\u8FD4\u3057\u307E\u3059\u3002O(N)\u3002\n        var s: seq[string]\n\
    \        for x in self:\n            s.add($x)\n        return s.join(\" \")\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/avl_monoid.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/avl_balance_test.nim
  - verify/collections/avl_balance_test.nim
documentation_of: cplib/collections/avl_monoid.nim
layout: document
redirect_from:
- /library/cplib/collections/avl_monoid.nim
- /library/cplib/collections/avl_monoid.nim.html
title: cplib/collections/avl_monoid.nim
---
