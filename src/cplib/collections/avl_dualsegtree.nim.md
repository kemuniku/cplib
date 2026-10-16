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
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_AVL_DUALSEGTREE:\n    const CPLIB_COLLECTIONS_AVL_DUALSEGTREE*\
    \ = 1\n    import cplib/utils/backwards_index\n    import sequtils, strutils\n\
    \n    type AvlDualSegmentTreeNode[S, F] = ref object\n        left, right: AvlDualSegmentTreeNode[S,\
    \ F]\n        height: int\n        size: int\n        value: S\n        lazy:\
    \ F\n        hasLazy: bool\n\n    type AvlDualSegmentTree*[S, F] = ref object\n\
    \        root: AvlDualSegmentTreeNode[S, F]\n        length: int\n        mapping:\
    \ proc(f: F, x: S): S\n        composition: proc(f, g: F): F\n        id: F\n\n\
    \    proc nodeLen[S, F](node: AvlDualSegmentTreeNode[S, F]): int {.inline.} =\n\
    \        ## \u90E8\u5206\u6728\u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\
    \u3059\u3002O(1)\u3002\n        if node.isNil: 0 else: node.size\n\n    proc nodeHeight[S,\
    \ F](node: AvlDualSegmentTreeNode[S, F]): int {.inline.} =\n        ## \u90E8\u5206\
    \u6728\u306E\u9AD8\u3055\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   if node.isNil: 0 else: node.height\n\n    proc update[S, F](node: AvlDualSegmentTreeNode[S,\
    \ F]) =\n        ## \u5B50\u306E\u60C5\u5831\u304B\u3089\u30CE\u30FC\u30C9\u306E\
    \u8981\u7D20\u6570\u3068\u9AD8\u3055\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        if node.isNil: return\n        node.size = 1 + node.left.nodeLen\
    \ + node.right.nodeLen\n        node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)\n\
    \n    proc allApply[S, F](\n        node: AvlDualSegmentTreeNode[S, F],\n    \
    \    f: F,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f,\
    \ g: F): F\n    ) =\n        ## \u90E8\u5206\u6728\u5168\u4F53\u306B\u4F5C\u7528\
    \u3092\u8A18\u9332\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil: return\n\
    \        node.value = mapping(f, node.value)\n        if node.hasLazy:\n     \
    \       node.lazy = composition(f, node.lazy)\n        else:\n            node.lazy\
    \ = f\n            node.hasLazy = true\n\n    proc push[S, F](\n        node:\
    \ AvlDualSegmentTreeNode[S, F],\n        mapping: proc(f: F, x: S): S,\n     \
    \   composition: proc(f, g: F): F,\n        id: F\n    ) =\n        ## \u8A18\u9332\
    \u3057\u305F\u4F5C\u7528\u3092\u5B50\u3078\u4F1D\u64AD\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        if node.isNil or not node.hasLazy: return\n        node.left.allApply(node.lazy,\
    \ mapping, composition)\n        node.right.allApply(node.lazy, mapping, composition)\n\
    \        node.lazy = id\n        node.hasLazy = false\n\n    proc newNode[S, F](value:\
    \ S, id: F): AvlDualSegmentTreeNode[S, F] =\n        ## \u4E00\u8981\u7D20\u306E\
    \u30CE\u30FC\u30C9\u3092\u4F5C\u308A\u307E\u3059\u3002O(1)\u3002\n        AvlDualSegmentTreeNode[S,\
    \ F](height: 1, size: 1, value: value, lazy: id)\n\n    proc buildRange[S, F](v:\
    \ openArray[S], l, r: int, id: F): AvlDualSegmentTreeNode[S, F] =\n        ##\
    \ \u6307\u5B9A\u533A\u9593\u304B\u3089\u9AD8\u3055\u306E\u91E3\u308A\u5408\u3063\
    \u305F\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(r-l)\u3002\n        if\
    \ l == r: return nil\n        let mid = (l + r) shr 1\n        result = newNode(v[mid],\
    \ id)\n        result.left = buildRange(v, l, mid, id)\n        result.right =\
    \ buildRange(v, mid + 1, r, id)\n        result.update\n\n    proc build[S, F](v:\
    \ openArray[S], id: F): AvlDualSegmentTreeNode[S, F] =\n        ## \u914D\u5217\
    \u304B\u3089 AVL \u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(N)\u3002\n\
    \        buildRange(v, 0, v.len, id)\n\n\n    proc rotateLeft[S, F](node: AvlDualSegmentTreeNode[S,\
    \ F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S,\
    \ F] =\n        ## \u5DE6\u56DE\u8EE2\u3057\u3001\u96C6\u7D04\u5024\u3092\u66F4\
    \u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n        node.push(mapping, composition,\
    \ id)\n        var child = move(node.right)\n        child.push(mapping, composition,\
    \ id)\n        node.right = move(child.left)\n        child.left = node\n    \
    \    node.update\n        child.update\n        child\n\n    proc rotateRight[S,\
    \ F](node: AvlDualSegmentTreeNode[S, F], mapping: proc(f: F, x: S): S, composition:\
    \ proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S, F] =\n        ## \u53F3\u56DE\
    \u8EE2\u3057\u3001\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        node.push(mapping, composition, id)\n        var child = move(node.left)\n\
    \        child.push(mapping, composition, id)\n        node.left = move(child.right)\n\
    \        child.right = node\n        node.update\n        child.update\n     \
    \   child\n\n    proc rebalance[S, F](node: AvlDualSegmentTreeNode[S, F], mapping:\
    \ proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S,\
    \ F] =\n        ## \u90E8\u5206\u6728\u3092 AVL \u6761\u4EF6\u306B\u623B\u3057\
    \u307E\u3059\u3002O(1)\u3002\n        node.push(mapping, composition, id)\n  \
    \      node.update\n        if node.left.nodeHeight > node.right.nodeHeight +\
    \ 1:\n            if node.left.left.nodeHeight < node.left.right.nodeHeight:\n\
    \                var child = move(node.left)\n                node.left = child.rotateLeft(mapping,\
    \ composition, id)\n            return node.rotateRight(mapping, composition,\
    \ id)\n        if node.right.nodeHeight > node.left.nodeHeight + 1:\n        \
    \    if node.right.right.nodeHeight < node.right.left.nodeHeight:\n          \
    \      var child = move(node.right)\n                node.right = child.rotateRight(mapping,\
    \ composition, id)\n            return node.rotateLeft(mapping, composition, id)\n\
    \        node\n\n    proc join[S, F](left, pivot, right: AvlDualSegmentTreeNode[S,\
    \ F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S,\
    \ F] =\n        ## \u8981\u7D20\u4E00\u3064\u3092\u631F\u3093\u3067\u4E8C\u3064\
    \u306E\u6728\u3092\u7D50\u5408\u3057\u307E\u3059\u3002O(|hL-hR|+1)\u3002\n   \
    \     if left.nodeHeight > right.nodeHeight + 1:\n            left.push(mapping,\
    \ composition, id)\n            var branch = move(left.right)\n            left.right\
    \ = join(branch, pivot, right, mapping, composition, id)\n            return left.rebalance(mapping,\
    \ composition, id)\n        if right.nodeHeight > left.nodeHeight + 1:\n     \
    \       right.push(mapping, composition, id)\n            var branch = move(right.left)\n\
    \            right.left = join(left, pivot, branch, mapping, composition, id)\n\
    \            return right.rebalance(mapping, composition, id)\n        pivot.push(mapping,\
    \ composition, id)\n        pivot.left = left\n        pivot.right = right\n \
    \       pivot.update\n        pivot\n\n    proc popMax[S, F](node: AvlDualSegmentTreeNode[S,\
    \ F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): (AvlDualSegmentTreeNode[S,\
    \ F], AvlDualSegmentTreeNode[S, F]) =\n        ## \u6700\u5927\u4F4D\u7F6E\u306E\
    \u30CE\u30FC\u30C9\u3092\u53D6\u308A\u51FA\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        node.push(mapping, composition, id)\n        if node.right.isNil:\n\
    \            var branch = move(node.left)\n            result = (branch, node)\n\
    \            node.update\n        else:\n            var branch = move(node.right)\n\
    \            var (rest, pivot) = popMax(branch, mapping, composition, id)\n  \
    \          node.right = rest\n            result = (node.rebalance(mapping, composition,\
    \ id), pivot)\n\n    proc mergeNode[S, F](left, right: AvlDualSegmentTreeNode[S,\
    \ F], mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlDualSegmentTreeNode[S,\
    \ F] =\n        ## \u4E8C\u3064\u306E\u6728\u3092\u9806\u5E8F\u3092\u4FDD\u3063\
    \u3066\u7D50\u5408\u3057\u307E\u3059\u3002O(log N)\u3002\n        if left.isNil:\
    \ return right\n        if right.isNil: return left\n        var (rest, pivot)\
    \ = popMax(left, mapping, composition, id)\n        join(rest, pivot, right, mapping,\
    \ composition, id)\n\n    proc split[S, F](node: AvlDualSegmentTreeNode[S, F],\
    \ k: int, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F):\
    \ (AvlDualSegmentTreeNode[S, F], AvlDualSegmentTreeNode[S, F]) =\n        ## \u5148\
    \u982D k \u8981\u7D20\u3067\u6728\u3092\u5206\u5272\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        if node.isNil: return (nil, nil)\n        node.push(mapping,\
    \ composition, id)\n        let leftSize = node.left.nodeLen\n        var leftTree\
    \ = move(node.left)\n        var rightTree = move(node.right)\n        if k <=\
    \ leftSize:\n            var (left, middle) = split(leftTree, k, mapping, composition,\
    \ id)\n            return (left, join(middle, node, rightTree, mapping, composition,\
    \ id))\n        else:\n            var (middle, right) = split(rightTree, k -\
    \ leftSize - 1, mapping, composition, id)\n            return (join(leftTree,\
    \ node, middle, mapping, composition, id), right)\n\n    proc initAvlDualSegmentTree*[S,\
    \ F](\n        v: openArray[S],\n        mapping: proc(f: F, x: S): S,\n     \
    \   composition: proc(f, g: F): F,\n        id: F\n    ): AvlDualSegmentTree[S,\
    \ F] =\n        ## \u533A\u9593\u4F5C\u7528\u3092\u6301\u3064\u5217\u3092\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002O(N)\u3002\n        AvlDualSegmentTree[S, F](root:\
    \ build(v, id), length: v.len, mapping: mapping, composition: composition, id:\
    \ id)\n\n\n    proc initAvlDualSegmentTree*[S, F](\n        n: int,\n        initValue:\
    \ S,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g: F):\
    \ F,\n        id: F\n    ): AvlDualSegmentTree[S, F] =\n        ## \u533A\u9593\
    \u4F5C\u7528\u3092\u6301\u3064\u5217\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    O(N)\u3002\n        initAvlDualSegmentTree(newSeqWith(n, initValue), mapping,\
    \ composition, id)\n\n    template newAvlDualSegWith*(v, mapping, composition,\
    \ id: untyped): untyped =\n        type S = typeof(v[0])\n        type F = typeof(id)\n\
    \        initAvlDualSegmentTree[S, F](\n            v,\n            proc (f{.inject.}:\
    \ F, x{.inject.}: S): S = mapping,\n            proc (f{.inject.}, g{.inject.}:\
    \ F): F = composition,\n            id\n        )\n\n    template newAvlDualSegWith*(n,\
    \ initValue, mapping, composition, id: untyped): untyped =\n        type S = typeof(initValue)\n\
    \        type F = typeof(id)\n        initAvlDualSegmentTree[S, F](\n        \
    \    n,\n            initValue,\n            proc (f{.inject.}: F, x{.inject.}:\
    \ S): S = mapping,\n            proc (f{.inject.}, g{.inject.}: F): F = composition,\n\
    \            id\n        )\n\n    proc len*[S, F](self: AvlDualSegmentTree[S,\
    \ F]): int =\n        ## \u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        self.length\n\n    proc mergeRoot[S, F](\n        self: AvlDualSegmentTree[S,\
    \ F],\n        left, right: AvlDualSegmentTreeNode[S, F]\n    ): AvlDualSegmentTreeNode[S,\
    \ F] =\n        ## \u4E8C\u3064\u306E\u6728\u3092\u9806\u5E8F\u3092\u4FDD\u3063\
    \u3066\u7D50\u5408\u3057\u307E\u3059\u3002O(log N)\u3002\n        mergeNode(left,\
    \ right, self.mapping, self.composition, self.id)\n\n    proc splitRoot[S, F](\n\
    \        self: AvlDualSegmentTree[S, F],\n        node: AvlDualSegmentTreeNode[S,\
    \ F],\n        k: int\n    ): (AvlDualSegmentTreeNode[S, F], AvlDualSegmentTreeNode[S,\
    \ F]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\u6728\u3092\u5206\u5272\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        split(node, k, self.mapping, self.composition,\
    \ self.id)\n\n    proc split*[S, F](self: AvlDualSegmentTree[S, F], k: int): (AvlDualSegmentTree[S,\
    \ F], AvlDualSegmentTree[S, F]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\
    \u5206\u5272\u3057\u3001\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        assert 0 <= k and k <= self.length, \"0 <= k <=\
    \ len \u304C\u5FC5\u8981\u3067\u3059\"\n        let n = self.length\n        var\
    \ root = move(self.root)\n        let (leftRoot, rightRoot) = self.splitRoot(root,\
    \ k)\n        self.length = 0\n        result = (\n            AvlDualSegmentTree[S,\
    \ F](root: leftRoot, length: k, mapping: self.mapping, composition: self.composition,\
    \ id: self.id),\n            AvlDualSegmentTree[S, F](root: rightRoot, length:\
    \ n - k, mapping: self.mapping, composition: self.composition, id: self.id)\n\
    \        )\n\n    proc merge*[S, F](left, right: AvlDualSegmentTree[S, F]): AvlDualSegmentTree[S,\
    \ F] =\n        ## \u5DE6\u53F3\u306E\u5217\u3092\u9023\u7D50\u3057\u3001\u4E21\
    \u65B9\u306E\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002\u540C\
    \u3058\u6F14\u7B97\u304C\u5FC5\u8981\u3067\u3059\u3002O(log N)\u3002\n       \
    \ assert left != right, \"\u540C\u3058\u5217\u3092\u9023\u7D50\u3067\u304D\u307E\
    \u305B\u3093\"\n        let n = left.length + right.length\n        var leftRoot\
    \ = move(left.root)\n        var rightRoot = move(right.root)\n        result\
    \ = AvlDualSegmentTree[S, F](root: left.mergeRoot(leftRoot, rightRoot), length:\
    \ n, mapping: left.mapping, composition: left.composition, id: left.id)\n    \
    \    left.length = 0\n        right.length = 0\n\n\n    proc insertNode[S, F](self:\
    \ AvlDualSegmentTree[S, F], root, node: AvlDualSegmentTreeNode[S, F], k: int):\
    \ AvlDualSegmentTreeNode[S, F] =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306B\u30CE\
    \u30FC\u30C9\u3092\u633F\u5165\u3057\u307E\u3059\u3002O(log N)\u3002\n       \
    \ if root.isNil: return node\n        root.push(self.mapping, self.composition,\
    \ self.id)\n        let leftSize = root.left.nodeLen\n        if k <= leftSize:\n\
    \            var branch = move(root.left)\n            root.left = self.insertNode(branch,\
    \ node, k)\n        else:\n            var branch = move(root.right)\n       \
    \     root.right = self.insertNode(branch, node, k - leftSize - 1)\n        root.rebalance(self.mapping,\
    \ self.composition, self.id)\n\n    proc eraseNode[S, F](self: AvlDualSegmentTree[S,\
    \ F], root: AvlDualSegmentTreeNode[S, F], k: int): AvlDualSegmentTreeNode[S, F]\
    \ =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u30CE\u30FC\u30C9\u3092\u524A\u9664\
    \u3057\u307E\u3059\u3002O(log N)\u3002\n        root.push(self.mapping, self.composition,\
    \ self.id)\n        let leftSize = root.left.nodeLen\n        if k == leftSize:\n\
    \            var left = move(root.left)\n            var right = move(root.right)\n\
    \            return self.mergeRoot(left, right)\n        if k < leftSize:\n  \
    \          var branch = move(root.left)\n            root.left = self.eraseNode(branch,\
    \ k)\n        else:\n            var branch = move(root.right)\n            root.right\
    \ = self.eraseNode(branch, k - leftSize - 1)\n        root.rebalance(self.mapping,\
    \ self.composition, self.id)\n\n    proc insert*[S, F](self: AvlDualSegmentTree[S,\
    \ F], index: int, value: S) =\n        ## index \u306E\u76F4\u524D\u306B value\
    \ \u3092\u633F\u5165\u3059\u308B\u3002\u672B\u5C3E\u306B\u306F index = len \u3092\
    \u6307\u5B9A\u3059\u308B\u3002\n        ## O(log N)\u3002\u633F\u5165\u524D\u306E\
    \u533A\u9593\u66F4\u65B0\u306F\u65B0\u3057\u3044\u8981\u7D20\u306B\u306F\u4F5C\
    \u7528\u3057\u306A\u3044\u3002\n        assert 0 <= index and index <= self.length,\
    \ \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index and index <=\
    \ self.length\"\n        let node = newNode(value, self.id)\n        var root\
    \ = move(self.root)\n        self.root = self.insertNode(root, node, index)\n\
    \        inc self.length\n\n    proc insort*[S, F](self: AvlDualSegmentTree[S,\
    \ F], value: S, less: proc(x, y: S): bool): int {.discardable.} =\n        ##\
    \ \u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\u5024\u306E\u672B\u5C3E\
    \u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\u3001\u305D\u306E\u4F4D\
    \u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        var node = self.root\n\
    \        while not node.isNil:\n            node.push(self.mapping, self.composition,\
    \ self.id)\n            if less(value, node.value):\n                node = node.left\n\
    \            else:\n                result += node.left.nodeLen + 1\n        \
    \        node = node.right\n        self.insert(result, value)\n\n    proc insort*[S,\
    \ F](self: AvlDualSegmentTree[S, F], value: S): int {.discardable.} =\n      \
    \  ## < \u3067\u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\u5024\u306E\
    \u672B\u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        self.insort(value, proc(x, y: S): bool = x < y)\n\
    \n    proc erase*[S, F](self: AvlDualSegmentTree[S, F], l, r: int) =\n       \
    \ ## \u534A\u958B\u533A\u9593 [l, r) \u3092\u524A\u9664\u3059\u308B\u3002\u6728\
    \u306E\u64CD\u4F5C\u306FO(log N)\u3002\n        ## \u524A\u9664\u3057\u305F K\
    \ \u500B\u306E\u30CE\u30FC\u30C9\u306E\u89E3\u653E\u306B\u306F\u5225\u9014 O(K)\
    \ \u304B\u304B\u308A\u3046\u308B\u3002\n        assert 0 <= l and l <= r and r\
    \ <= self.length, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : 0 <= l and l <= r and r <= self.length\"\n        if l == r: return\n      \
    \  var (left, middleRight) = self.splitRoot(self.root, l)\n        var (_, right)\
    \ = self.splitRoot(middleRight, r - l)\n        self.root = self.mergeRoot(left,\
    \ right)\n        self.length -= r - l\n\n    proc erase*[S, F](self: AvlDualSegmentTree[S,\
    \ F], index: int) =\n        ## index \u756A\u76EE\u306E\u8981\u7D20\u3092\u524A\
    \u9664\u3059\u308B\u3002O(log N)\u3002\n        assert 0 <= index and index <\
    \ self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\
    \u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index\
    \ and index < self.length\"\n        var root = move(self.root)\n        self.root\
    \ = self.eraseNode(root, index)\n        dec self.length\n\n    proc erase*[S,\
    \ F](self: AvlDualSegmentTree[S, F], segment: HSlice[int, int]) =\n        ##\
    \ \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\u533A\u9593\u306E\u8981\u7D20\u3092\
    \u524A\u9664\u3057\u307E\u3059\u3002\u6728\u306E\u64CD\u4F5C\u306FO(log N)\u3002\
    \n        self.erase(segment.a, segment.b + 1)\n\n    proc apply*[S, F](self:\
    \ AvlDualSegmentTree[S, F], l, r: int, f: F) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\
    \u307E\u305F\u306F\u533A\u9593\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        assert 0 <= l and l <= r and r <= self.length,\
    \ \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <=\
    \ r and r <= self.length\"\n        var (left, middleRight) = self.splitRoot(self.root,\
    \ l)\n        var (middle, right) = self.splitRoot(middleRight, r - l)\n     \
    \   middle.allApply(f, self.mapping, self.composition)\n        self.root = self.mergeRoot(left,\
    \ self.mergeRoot(middle, right))\n\n    proc apply*[S, F](self: AvlDualSegmentTree[S,\
    \ F], index: int, f: F) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\
    \u533A\u9593\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        assert 0 <= index and index < self.length, \"\u6307\u5B9A\u3057\
    \u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index and index < self.length\"\n \
    \       var node = self.root\n        var k = index\n        while true:\n   \
    \         node.push(self.mapping, self.composition, self.id)\n            let\
    \ leftSize = node.left.nodeLen\n            if k < leftSize:\n               \
    \ node = node.left\n            elif k == leftSize:\n                node.value\
    \ = self.mapping(f, node.value)\n                return\n            else:\n \
    \               k -= leftSize + 1\n                node = node.right\n\n    proc\
    \ apply*[S, F](self: AvlDualSegmentTree[S, F], segment: HSlice[int, int], f: F)\
    \ =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\u533A\u9593\u306B\u4F5C\
    \u7528\u3092\u9069\u7528\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.apply(segment.a,\
    \ segment.b + 1, f)\n\n    proc get*[S, F](self: AvlDualSegmentTree[S, F], index:\
    \ int): S =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\u8FD4\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        assert 0 <= index and index < self.length,\
    \ \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index and index <\
    \ self.length\"\n        var node = self.root\n        var k = index\n       \
    \ while true:\n            node.push(self.mapping, self.composition, self.id)\n\
    \            let leftSize = node.left.nodeLen\n            if k < leftSize:\n\
    \                node = node.left\n            elif k == leftSize:\n         \
    \       return node.value\n            else:\n                k -= leftSize +\
    \ 1\n                node = node.right\n\n    proc update*[S, F](self: AvlDualSegmentTree[S,\
    \ F], index: Natural, value: S) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\
    \u3092\u7F6E\u304D\u63DB\u3048\u307E\u3059\u3002O(log N)\u3002\n        assert\
    \ index < self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : index < self.length\"\n        var node = self.root\n        var k = int(index)\n\
    \        while true:\n            node.push(self.mapping, self.composition, self.id)\n\
    \            let leftSize = node.left.nodeLen\n            if k < leftSize:\n\
    \                node = node.left\n            elif k == leftSize:\n         \
    \       node.value = value\n                return\n            else:\n      \
    \          k -= leftSize + 1\n                node = node.right\n\n    proc `[]`*[S,\
    \ F](self: AvlDualSegmentTree[S, F], index: int): S =\n        ## \u6307\u5B9A\
    \u4F4D\u7F6E\u306E\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n \
    \       self.get(index)\n\n    proc `[]`*[S, F](self: AvlDualSegmentTree[S, F],\
    \ index: BackwardsIndex): S =\n        ## \u672B\u5C3E\u304B\u3089\u6307\u5B9A\
    \u3057\u305F\u4F4D\u7F6E\u306E\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        self.get(self.length - int(index))\n\n    proc `[]=`*[S, F](self:\
    \ AvlDualSegmentTree[S, F], index: Natural, value: S) {.backwardsIndex.} =\n \
    \       ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        self.update(index, value)\n\n    iterator items*[S,\
    \ F](self: AvlDualSegmentTree[S, F]): S =\n        if not self.root.isNil:\n \
    \           var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                var (t, node) = stack.pop()\n                node.push(self.mapping,\
    \ self.composition, self.id)\n                if t == 0:\n                   \
    \ if not node.right.isNil: stack.add((0, node.right))\n                    stack.add((1,\
    \ node))\n                    if not node.left.isNil: stack.add((0, node.left))\n\
    \                else:\n                    yield node.value\n\n    proc toSeq*[S,\
    \ F](self: AvlDualSegmentTree[S, F]): seq[S] =\n        ## \u5168\u8981\u7D20\u3092\
    \u914D\u5217\u3068\u3057\u3066\u8FD4\u3057\u307E\u3059\u3002O(N)\u3002\n     \
    \   for x in self:\n            result.add(x)\n\n    proc `$`*[S, F](self: AvlDualSegmentTree[S,\
    \ F]): string =\n        ## \u5168\u8981\u7D20\u306E\u6587\u5B57\u5217\u8868\u73FE\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(N)\u3002\n        var s: seq[string]\n \
    \       for x in self:\n            s.add($x)\n        return s.join(\" \")\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/avl_dualsegtree.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/avl_dualsegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/avl_dualsegtree.nim
- /library/cplib/collections/avl_dualsegtree.nim.html
title: cplib/collections/avl_dualsegtree.nim
---
