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
    path: verify/collections/avl_seq_test.nim
    title: verify/collections/avl_seq_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/avl_seq_test.nim
    title: verify/collections/avl_seq_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_AVL_SEQ:\n    const CPLIB_COLLECTIONS_AVL_SEQ*\
    \ = 1\n    import cplib/utils/backwards_index\n    import strutils\n\n    type\
    \ AvlSeqNode[T] = ref object\n        left, right: AvlSeqNode[T]\n        height:\
    \ int\n        size: int\n        value: T\n\n    type AvlSeq*[T] = ref object\n\
    \        root: AvlSeqNode[T]\n        length: int\n\n    proc nodeLen[T](node:\
    \ AvlSeqNode[T]): int {.inline.} =\n        ## \u90E8\u5206\u6728\u306E\u8981\u7D20\
    \u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil: 0\
    \ else: node.size\n\n    proc nodeHeight[T](node: AvlSeqNode[T]): int {.inline.}\
    \ =\n        ## \u90E8\u5206\u6728\u306E\u9AD8\u3055\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(1)\u3002\n        if node.isNil: 0 else: node.height\n\n    proc update[T](node:\
    \ AvlSeqNode[T]) =\n        ## \u5B50\u306E\u60C5\u5831\u304B\u3089\u8981\u7D20\
    \u6570\u3068\u9AD8\u3055\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n\
    \        node.size = 1 + node.left.nodeLen + node.right.nodeLen\n        node.height\
    \ = 1 + max(node.left.nodeHeight, node.right.nodeHeight)\n\n    proc newNode[T](value:\
    \ T): AvlSeqNode[T] =\n        ## \u4E00\u8981\u7D20\u306E\u30CE\u30FC\u30C9\u3092\
    \u4F5C\u308A\u307E\u3059\u3002O(1)\u3002\n        AvlSeqNode[T](height: 1, size:\
    \ 1, value: value)\n\n    proc buildRange[T](v: openArray[T], l, r: int): AvlSeqNode[T]\
    \ =\n        ## \u6307\u5B9A\u533A\u9593\u304B\u3089\u9AD8\u3055\u306E\u91E3\u308A\
    \u5408\u3063\u305F\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(r-l)\u3002\
    \n        if l == r: return nil\n        let mid = (l + r) shr 1\n        result\
    \ = newNode(v[mid])\n        result.left = buildRange(v, l, mid)\n        result.right\
    \ = buildRange(v, mid + 1, r)\n        result.update\n\n    proc rotateLeft[T](node:\
    \ AvlSeqNode[T]): AvlSeqNode[T] =\n        ## \u5DE6\u56DE\u8EE2\u3057\u3066\u8981\
    \u7D20\u6570\u3068\u9AD8\u3055\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        var child = move(node.right)\n        node.right = move(child.left)\n\
    \        child.left = node\n        node.update\n        child.update\n      \
    \  child\n\n    proc rotateRight[T](node: AvlSeqNode[T]): AvlSeqNode[T] =\n  \
    \      ## \u53F3\u56DE\u8EE2\u3057\u3066\u8981\u7D20\u6570\u3068\u9AD8\u3055\u3092\
    \u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n        var child = move(node.left)\n\
    \        node.left = move(child.right)\n        child.right = node\n        node.update\n\
    \        child.update\n        child\n\n    proc rebalance[T](node: AvlSeqNode[T]):\
    \ AvlSeqNode[T] =\n        ## \u90E8\u5206\u6728\u3092 AVL \u6761\u4EF6\u306B\u623B\
    \u3057\u307E\u3059\u3002O(1)\u3002\n        node.update\n        if node.left.nodeHeight\
    \ > node.right.nodeHeight + 1:\n            if node.left.left.nodeHeight < node.left.right.nodeHeight:\n\
    \                var child = move(node.left)\n                node.left = child.rotateLeft\n\
    \            return node.rotateRight\n        if node.right.nodeHeight > node.left.nodeHeight\
    \ + 1:\n            if node.right.right.nodeHeight < node.right.left.nodeHeight:\n\
    \                var child = move(node.right)\n                node.right = child.rotateRight\n\
    \            return node.rotateLeft\n        node\n\n    proc join[T](left, pivot,\
    \ right: AvlSeqNode[T]): AvlSeqNode[T] =\n        ## \u4E00\u8981\u7D20\u3092\u631F\
    \u3093\u3067\u4E8C\u3064\u306E\u6728\u3092\u7D50\u5408\u3057\u307E\u3059\u3002\
    O(|hL-hR|+1)\u3002\n        if left.nodeHeight > right.nodeHeight + 1:\n     \
    \       var branch = move(left.right)\n            left.right = join(branch, pivot,\
    \ right)\n            return left.rebalance\n        if right.nodeHeight > left.nodeHeight\
    \ + 1:\n            var branch = move(right.left)\n            right.left = join(left,\
    \ pivot, branch)\n            return right.rebalance\n        pivot.left = left\n\
    \        pivot.right = right\n        pivot.update\n        pivot\n\n    proc\
    \ popMax[T](node: AvlSeqNode[T]): (AvlSeqNode[T], AvlSeqNode[T]) =\n        ##\
    \ \u6700\u5927\u4F4D\u7F6E\u306E\u30CE\u30FC\u30C9\u3092\u53D6\u308A\u51FA\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        if node.right.isNil:\n            var\
    \ branch = move(node.left)\n            result = (branch, node)\n            node.update\n\
    \        else:\n            var branch = move(node.right)\n            var (rest,\
    \ pivot) = popMax(branch)\n            node.right = rest\n            result =\
    \ (node.rebalance, pivot)\n\n    proc merge[T](left, right: AvlSeqNode[T]): AvlSeqNode[T]\
    \ =\n        ## \u4E8C\u3064\u306E\u6728\u3092\u9806\u5E8F\u3092\u4FDD\u3063\u3066\
    \u9023\u7D50\u3057\u307E\u3059\u3002O(log N)\u3002\n        if left.isNil: return\
    \ right\n        if right.isNil: return left\n        var (rest, pivot) = popMax(left)\n\
    \        join(rest, pivot, right)\n\n    proc split[T](node: AvlSeqNode[T], k:\
    \ int): (AvlSeqNode[T], AvlSeqNode[T]) =\n        ## \u5148\u982D k \u8981\u7D20\
    \u3067\u6728\u3092\u5206\u5272\u3057\u307E\u3059\u3002O(log N)\u3002\n       \
    \ if node.isNil: return (nil, nil)\n        let leftSize = node.left.nodeLen\n\
    \        var leftTree = move(node.left)\n        var rightTree = move(node.right)\n\
    \        if k <= leftSize:\n            var (left, middle) = split(leftTree, k)\n\
    \            return (left, join(middle, node, rightTree))\n        else:\n   \
    \         var (middle, right) = split(rightTree, k - leftSize - 1)\n         \
    \   return (join(leftTree, node, middle), right)\n\n    proc initAvlSeq*[T](v:\
    \ openArray[T]): AvlSeq[T] =\n        ## \u914D\u5217\u304B\u3089 AVL \u5217\u3092\
    \u69CB\u7BC9\u3057\u307E\u3059\u3002O(N)\u3002\n        AvlSeq[T](root: buildRange(v,\
    \ 0, v.len), length: v.len)\n\n    proc toAvlSeq*[T](v: openArray[T]): AvlSeq[T]\
    \ =\n        ## \u914D\u5217\u3092 AVL \u5217\u306B\u5909\u63DB\u3057\u307E\u3059\
    \u3002O(N)\u3002\n        initAvlSeq(v)\n\n    proc len*[T](self: AvlSeq[T]):\
    \ int =\n        ## \u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\
    \n        self.length\n\n    proc split*[T](self: AvlSeq[T], k: int): (AvlSeq[T],\
    \ AvlSeq[T]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\u5206\u5272\u3057\
    \u3001\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        assert 0 <= k and k <= self.length, \"0 <= k <= len \u304C\u5FC5\u8981\
    \u3067\u3059\"\n        let n = self.length\n        var root = move(self.root)\n\
    \        let (leftRoot, rightRoot) = split(root, k)\n        self.length = 0\n\
    \        result = (AvlSeq[T](root: leftRoot, length: k), AvlSeq[T](root: rightRoot,\
    \ length: n - k))\n\n    proc merge*[T](left, right: AvlSeq[T]): AvlSeq[T] =\n\
    \        ## \u5DE6\u53F3\u306E\u5217\u3092\u9023\u7D50\u3057\u3001\u4E21\u65B9\
    \u306E\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        assert left != right, \"\u540C\u3058\u5217\u3092\u9023\u7D50\u3067\u304D\
    \u307E\u305B\u3093\"\n        let n = left.length + right.length\n        var\
    \ leftRoot = move(left.root)\n        var rightRoot = move(right.root)\n     \
    \   result = AvlSeq[T](root: merge(leftRoot, rightRoot), length: n)\n        left.length\
    \ = 0\n        right.length = 0\n\n    proc insertNode[T](root, node: AvlSeqNode[T],\
    \ k: int): AvlSeqNode[T] =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306B\u30CE\u30FC\
    \u30C9\u3092\u633F\u5165\u3057\u307E\u3059\u3002O(log N)\u3002\n        if root.isNil:\
    \ return node\n        let leftSize = root.left.nodeLen\n        if k <= leftSize:\n\
    \            var branch = move(root.left)\n            root.left = insertNode(branch,\
    \ node, k)\n        else:\n            var branch = move(root.right)\n       \
    \     root.right = insertNode(branch, node, k - leftSize - 1)\n        root.rebalance\n\
    \n    proc insert*[T](self: AvlSeq[T], index: int, value: T) =\n        ## index\
    \ \u306E\u76F4\u524D\u306B\u633F\u5165\u3057\u307E\u3059\u3002\u672B\u5C3E\u306B\
    \u306F len \u3092\u6307\u5B9A\u3057\u307E\u3059\u3002O(log N)\u3002\n        assert\
    \ 0 <= index and index <= self.length, \"0 <= index <= len \u304C\u5FC5\u8981\u3067\
    \u3059\"\n        var root = move(self.root)\n        self.root = insertNode(root,\
    \ newNode(value), index)\n        inc self.length\n\n    proc insort*[T](self:\
    \ AvlSeq[T], value: T, less: proc(x, y: T): bool): int {.discardable.} =\n   \
    \     ## \u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\u5024\u306E\u672B\
    \u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\u3001\u305D\u306E\
    \u4F4D\u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        var node\
    \ = self.root\n        while not node.isNil:\n            if less(value, node.value):\n\
    \                node = node.left\n            else:\n                result +=\
    \ node.left.nodeLen + 1\n                node = node.right\n        self.insert(result,\
    \ value)\n\n    proc insort*[T](self: AvlSeq[T], value: T): int {.discardable.}\
    \ =\n        ## < \u3067\u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\
    \u5024\u306E\u672B\u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        self.insort(value, proc(x, y: T): bool\
    \ = x < y)\n\n    proc eraseNode[T](node: AvlSeqNode[T], k: int): AvlSeqNode[T]\
    \ =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u30CE\u30FC\u30C9\u3092\u524A\u9664\
    \u3057\u307E\u3059\u3002O(log N)\u3002\n        let leftSize = node.left.nodeLen\n\
    \        if k == leftSize:\n            var left = move(node.left)\n         \
    \   var right = move(node.right)\n            return merge(left, right)\n    \
    \    if k < leftSize:\n            var branch = move(node.left)\n            node.left\
    \ = eraseNode(branch, k)\n        else:\n            var branch = move(node.right)\n\
    \            node.right = eraseNode(branch, k - leftSize - 1)\n        node.rebalance\n\
    \n    proc erase*[T](self: AvlSeq[T], index: int) =\n        ## \u6307\u5B9A\u4F4D\
    \u7F6E\u306E\u8981\u7D20\u3092\u524A\u9664\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        assert 0 <= index and index < self.length, \"0 <= index < len \u304C\
    \u5FC5\u8981\u3067\u3059\"\n        var root = move(self.root)\n        self.root\
    \ = eraseNode(root, index)\n        dec self.length\n\n    proc erase*[T](self:\
    \ AvlSeq[T], l, r: int) =\n        ## \u534A\u958B\u533A\u9593 [l, r) \u3092\u524A\
    \u9664\u3057\u307E\u3059\u3002\u6728\u306E\u64CD\u4F5C\u306F O(log N)\u3002\n\
    \        assert 0 <= l and l <= r and r <= self.length, \"0 <= l <= r <= len \u304C\
    \u5FC5\u8981\u3067\u3059\"\n        if l == r: return\n        var root = move(self.root)\n\
    \        let (left, rest) = split(root, l)\n        let (_, right) = split(rest,\
    \ r - l)\n        self.root = merge(left, right)\n        self.length -= r - l\n\
    \n    proc erase*[T](self: AvlSeq[T], segment: HSlice[int, int]) =\n        ##\
    \ \u9589\u533A\u9593\u306E\u8981\u7D20\u3092\u524A\u9664\u3057\u307E\u3059\u3002\
    \u6728\u306E\u64CD\u4F5C\u306F O(log N)\u3002\n        self.erase(segment.a, segment.b\
    \ + 1)\n\n    proc get*[T](self: AvlSeq[T], index: int): T =\n        ## \u6307\
    \u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        assert 0 <= index and index < self.length, \"0 <= index < len \u304C\
    \u5FC5\u8981\u3067\u3059\"\n        var node = self.root\n        var k = index\n\
    \        while true:\n            let leftSize = node.left.nodeLen\n         \
    \   if k < leftSize:\n                node = node.left\n            elif k ==\
    \ leftSize:\n                return node.value\n            else:\n          \
    \      k -= leftSize + 1\n                node = node.right\n\n    proc update*[T](self:\
    \ AvlSeq[T], index: Natural, value: T) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\
    \u5024\u3092\u5909\u66F4\u3057\u307E\u3059\u3002O(log N)\u3002\n        assert\
    \ index < self.length, \"index < len \u304C\u5FC5\u8981\u3067\u3059\"\n      \
    \  var node = self.root\n        var k = int(index)\n        while true:\n   \
    \         let leftSize = node.left.nodeLen\n            if k < leftSize:\n   \
    \             node = node.left\n            elif k == leftSize:\n            \
    \    node.value = value\n                return\n            else:\n         \
    \       k -= leftSize + 1\n                node = node.right\n\n    proc `[]`*[T](self:\
    \ AvlSeq[T], index: int): T =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.get(index)\n\n\
    \    proc `[]`*[T](self: AvlSeq[T], index: BackwardsIndex): T =\n        ## \u672B\
    \u5C3E\u304B\u3089\u6307\u5B9A\u3057\u305F\u4F4D\u7F6E\u306E\u5024\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(log N)\u3002\n        self.get(self.length - int(index))\n\
    \n    proc `[]=`*[T](self: AvlSeq[T], index: Natural, value: T) {.backwardsIndex.}\
    \ =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\u5909\u66F4\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        self.update(index, value)\n\n    iterator\
    \ items*[T](self: AvlSeq[T]): T =\n        ## \u5168\u8981\u7D20\u3092\u9806\u756A\
    \u306B\u8D70\u67FB\u3057\u307E\u3059\u3002O(N)\u3002\n        if not self.root.isNil:\n\
    \            var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                let (state, node) = stack.pop()\n                if state ==\
    \ 0:\n                    if not node.right.isNil: stack.add((0, node.right))\n\
    \                    stack.add((1, node))\n                    if not node.left.isNil:\
    \ stack.add((0, node.left))\n                else:\n                    yield\
    \ node.value\n\n    proc toSeq*[T](self: AvlSeq[T]): seq[T] =\n        ## \u5168\
    \u8981\u7D20\u3092\u914D\u5217\u3068\u3057\u3066\u8FD4\u3057\u307E\u3059\u3002\
    O(N)\u3002\n        for x in self:\n            result.add(x)\n\n    proc `$`*[T](self:\
    \ AvlSeq[T]): string =\n        ## \u5168\u8981\u7D20\u306E\u6587\u5B57\u5217\u8868\
    \u73FE\u3092\u8FD4\u3057\u307E\u3059\u3002O(N)\u3002\n        var parts: seq[string]\n\
    \        for x in self:\n            parts.add($x)\n        parts.join(\" \")\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/avl_seq.nim
  requiredBy: []
  timestamp: '2026-10-15 20:57:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/avl_seq_test.nim
  - verify/collections/avl_seq_test.nim
documentation_of: cplib/collections/avl_seq.nim
layout: document
redirect_from:
- /library/cplib/collections/avl_seq.nim
- /library/cplib/collections/avl_seq.nim.html
title: cplib/collections/avl_seq.nim
---
