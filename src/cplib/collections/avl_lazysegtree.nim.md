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
  code: "when not declared CPLIB_COLLECTIONS_AVL_LAZYSEGTREE:\n    const CPLIB_COLLECTIONS_AVL_LAZYSEGTREE*\
    \ = 1\n    import cplib/utils/backwards_index\n    import sequtils, strutils\n\
    \n    type AvlLazySegmentTreeNode[S, F] = ref object\n        left, right: AvlLazySegmentTreeNode[S,\
    \ F]\n        height: int\n        size: int\n        value, prod: S\n       \
    \ lazy: F\n        hasLazy: bool\n\n    type AvlLazySegmentTree*[S, F] = ref object\n\
    \        root: AvlLazySegmentTreeNode[S, F]\n        length: int\n        merge:\
    \ proc(x, y: S): S\n        default: S\n        mapping: proc(f: F, x: S): S\n\
    \        composition: proc(f, g: F): F\n        id: F\n\n    proc nodeLen[S, F](node:\
    \ AvlLazySegmentTreeNode[S, F]): int {.inline.} =\n        ## \u90E8\u5206\u6728\
    \u306E\u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n     \
    \   if node.isNil: 0 else: node.size\n\n    proc nodeHeight[S, F](node: AvlLazySegmentTreeNode[S,\
    \ F]): int {.inline.} =\n        ## \u90E8\u5206\u6728\u306E\u9AD8\u3055\u3092\
    \u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil: 0 else: node.height\n\
    \n    proc nodeProd[S, F](node: AvlLazySegmentTreeNode[S, F], default: S): S {.inline.}\
    \ =\n        ## \u90E8\u5206\u6728\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(1)\u3002\n        if node.isNil: default else: node.prod\n\n    proc update[S,\
    \ F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default: S)\
    \ =\n        ## \u5B50\u306E\u60C5\u5831\u304B\u3089\u30CE\u30FC\u30C9\u306E\u96C6\
    \u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil:\
    \ return\n        node.size = 1 + node.left.nodeLen + node.right.nodeLen\n   \
    \     node.height = 1 + max(node.left.nodeHeight, node.right.nodeHeight)\n   \
    \     node.prod = merge(merge(node.left.nodeProd(default), node.value), node.right.nodeProd(default))\n\
    \n    proc allApply[S, F](\n        node: AvlLazySegmentTreeNode[S, F],\n    \
    \    f: F,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f,\
    \ g: F): F\n    ) =\n        ## \u90E8\u5206\u6728\u5168\u4F53\u306B\u4F5C\u7528\
    \u3092\u8A18\u9332\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil: return\n\
    \        node.value = mapping(f, node.value)\n        node.prod = mapping(f, node.prod)\n\
    \        if node.hasLazy:\n            node.lazy = composition(f, node.lazy)\n\
    \        else:\n            node.lazy = f\n            node.hasLazy = true\n\n\
    \    proc push[S, F](\n        node: AvlLazySegmentTreeNode[S, F],\n        mapping:\
    \ proc(f: F, x: S): S,\n        composition: proc(f, g: F): F,\n        id: F\n\
    \    ) =\n        ## \u8A18\u9332\u3057\u305F\u4F5C\u7528\u3092\u5B50\u3078\u4F1D\
    \u64AD\u3057\u307E\u3059\u3002O(1)\u3002\n        if node.isNil or not node.hasLazy:\
    \ return\n        node.left.allApply(node.lazy, mapping, composition)\n      \
    \  node.right.allApply(node.lazy, mapping, composition)\n        node.lazy = id\n\
    \        node.hasLazy = false\n\n    proc newNode[S, F](value: S, id: F): AvlLazySegmentTreeNode[S,\
    \ F] =\n        ## \u4E00\u8981\u7D20\u306E\u30CE\u30FC\u30C9\u3092\u4F5C\u308A\
    \u307E\u3059\u3002O(1)\u3002\n        AvlLazySegmentTreeNode[S, F](height: 1,\
    \ size: 1, value: value, prod: value, lazy: id)\n\n    proc buildRange[S, F](v:\
    \ openArray[S], l, r: int, merge: proc(x, y: S): S, default: S, id: F): AvlLazySegmentTreeNode[S,\
    \ F] =\n        ## \u6307\u5B9A\u533A\u9593\u304B\u3089\u9AD8\u3055\u306E\u91E3\
    \u308A\u5408\u3063\u305F\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(r-l)\u3002\
    \n        if l == r: return nil\n        let mid = (l + r) shr 1\n        result\
    \ = newNode(v[mid], id)\n        result.left = buildRange(v, l, mid, merge, default,\
    \ id)\n        result.right = buildRange(v, mid + 1, r, merge, default, id)\n\
    \        result.update(merge, default)\n\n    proc build[S, F](v: openArray[S],\
    \ merge: proc(x, y: S): S, default: S, id: F): AvlLazySegmentTreeNode[S, F] =\n\
    \        ## \u914D\u5217\u304B\u3089 AVL \u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\
    \u3002O(N)\u3002\n        buildRange(v, 0, v.len, merge, default, id)\n\n\n  \
    \  proc rotateLeft[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y:\
    \ S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F):\
    \ F, id: F): AvlLazySegmentTreeNode[S, F] =\n        ## \u5DE6\u56DE\u8EE2\u3057\
    \u3001\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(1)\u3002\n\
    \        node.push(mapping, composition, id)\n        var child = move(node.right)\n\
    \        child.push(mapping, composition, id)\n        node.right = move(child.left)\n\
    \        child.left = node\n        node.update(merge, default)\n        child.update(merge,\
    \ default)\n        child\n\n    proc rotateRight[S, F](node: AvlLazySegmentTreeNode[S,\
    \ F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition:\
    \ proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =\n        ## \u53F3\u56DE\
    \u8EE2\u3057\u3001\u96C6\u7D04\u5024\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002\
    O(1)\u3002\n        node.push(mapping, composition, id)\n        var child = move(node.left)\n\
    \        child.push(mapping, composition, id)\n        node.left = move(child.right)\n\
    \        child.right = node\n        node.update(merge, default)\n        child.update(merge,\
    \ default)\n        child\n\n    proc rebalance[S, F](node: AvlLazySegmentTreeNode[S,\
    \ F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition:\
    \ proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =\n        ## \u90E8\u5206\
    \u6728\u3092 AVL \u6761\u4EF6\u306B\u623B\u3057\u307E\u3059\u3002O(1)\u3002\n\
    \        node.push(mapping, composition, id)\n        node.update(merge, default)\n\
    \        if node.left.nodeHeight > node.right.nodeHeight + 1:\n            if\
    \ node.left.left.nodeHeight < node.left.right.nodeHeight:\n                var\
    \ child = move(node.left)\n                node.left = child.rotateLeft(merge,\
    \ default, mapping, composition, id)\n            return node.rotateRight(merge,\
    \ default, mapping, composition, id)\n        if node.right.nodeHeight > node.left.nodeHeight\
    \ + 1:\n            if node.right.right.nodeHeight < node.right.left.nodeHeight:\n\
    \                var child = move(node.right)\n                node.right = child.rotateRight(merge,\
    \ default, mapping, composition, id)\n            return node.rotateLeft(merge,\
    \ default, mapping, composition, id)\n        node\n\n    proc join[S, F](left,\
    \ pivot, right: AvlLazySegmentTreeNode[S, F], merge: proc(x, y: S): S, default:\
    \ S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S,\
    \ F] =\n        ## \u8981\u7D20\u4E00\u3064\u3092\u631F\u3093\u3067\u4E8C\u3064\
    \u306E\u6728\u3092\u7D50\u5408\u3057\u307E\u3059\u3002O(|hL-hR|+1)\u3002\n   \
    \     if left.nodeHeight > right.nodeHeight + 1:\n            left.push(mapping,\
    \ composition, id)\n            var branch = move(left.right)\n            left.right\
    \ = join(branch, pivot, right, merge, default, mapping, composition, id)\n   \
    \         return left.rebalance(merge, default, mapping, composition, id)\n  \
    \      if right.nodeHeight > left.nodeHeight + 1:\n            right.push(mapping,\
    \ composition, id)\n            var branch = move(right.left)\n            right.left\
    \ = join(left, pivot, branch, merge, default, mapping, composition, id)\n    \
    \        return right.rebalance(merge, default, mapping, composition, id)\n  \
    \      pivot.push(mapping, composition, id)\n        pivot.left = left\n     \
    \   pivot.right = right\n        pivot.update(merge, default)\n        pivot\n\
    \n    proc popMax[S, F](node: AvlLazySegmentTreeNode[S, F], merge: proc(x, y:\
    \ S): S, default: S, mapping: proc(f: F, x: S): S, composition: proc(f, g: F):\
    \ F, id: F): (AvlLazySegmentTreeNode[S, F], AvlLazySegmentTreeNode[S, F]) =\n\
    \        ## \u6700\u5927\u4F4D\u7F6E\u306E\u30CE\u30FC\u30C9\u3092\u53D6\u308A\
    \u51FA\u3057\u307E\u3059\u3002O(log N)\u3002\n        node.push(mapping, composition,\
    \ id)\n        if node.right.isNil:\n            var branch = move(node.left)\n\
    \            result = (branch, node)\n            node.update(merge, default)\n\
    \        else:\n            var branch = move(node.right)\n            var (rest,\
    \ pivot) = popMax(branch, merge, default, mapping, composition, id)\n        \
    \    node.right = rest\n            result = (node.rebalance(merge, default, mapping,\
    \ composition, id), pivot)\n\n    proc mergeNode[S, F](left, right: AvlLazySegmentTreeNode[S,\
    \ F], merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition:\
    \ proc(f, g: F): F, id: F): AvlLazySegmentTreeNode[S, F] =\n        ## \u4E8C\u3064\
    \u306E\u6728\u3092\u9806\u5E8F\u3092\u4FDD\u3063\u3066\u7D50\u5408\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        if left.isNil: return right\n        if right.isNil:\
    \ return left\n        var (rest, pivot) = popMax(left, merge, default, mapping,\
    \ composition, id)\n        join(rest, pivot, right, merge, default, mapping,\
    \ composition, id)\n\n    proc split[S, F](node: AvlLazySegmentTreeNode[S, F],\
    \ k: int, merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S, composition:\
    \ proc(f, g: F): F, id: F): (AvlLazySegmentTreeNode[S, F], AvlLazySegmentTreeNode[S,\
    \ F]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\u6728\u3092\u5206\u5272\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        if node.isNil: return (nil, nil)\n \
    \       node.push(mapping, composition, id)\n        let leftSize = node.left.nodeLen\n\
    \        var leftTree = move(node.left)\n        var rightTree = move(node.right)\n\
    \        if k <= leftSize:\n            var (left, middle) = split(leftTree, k,\
    \ merge, default, mapping, composition, id)\n            return (left, join(middle,\
    \ node, rightTree, merge, default, mapping, composition, id))\n        else:\n\
    \            var (middle, right) = split(rightTree, k - leftSize - 1, merge, default,\
    \ mapping, composition, id)\n            return (join(leftTree, node, middle,\
    \ merge, default, mapping, composition, id), right)\n\n    proc initAvlLazySegmentTree*[S,\
    \ F](\n        v: openArray[S],\n        merge: proc(x, y: S): S,\n        default:\
    \ S,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g: F):\
    \ F,\n        id: F\n    ): AvlLazySegmentTree[S, F] =\n        ## \u30E2\u30CE\
    \u30A4\u30C9\u3068\u9045\u5EF6\u4F5C\u7528\u3092\u6301\u3064\u5217\u3092\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002O(N)\u3002\n        AvlLazySegmentTree[S, F](\n\
    \            root: build(v, merge, default, id),\n            length: v.len,\n\
    \            merge: merge,\n            default: default,\n            mapping:\
    \ mapping,\n            composition: composition,\n            id: id\n      \
    \  )\n\n\n    proc initAvlLazySegmentTree*[S, F](\n        n: int,\n        merge:\
    \ proc(x, y: S): S,\n        default: S,\n        mapping: proc(f: F, x: S): S,\n\
    \        composition: proc(f, g: F): F,\n        id: F\n    ): AvlLazySegmentTree[S,\
    \ F] =\n        ## \u30E2\u30CE\u30A4\u30C9\u3068\u9045\u5EF6\u4F5C\u7528\u3092\
    \u6301\u3064\u5217\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002O(N)\u3002\n     \
    \   initAvlLazySegmentTree(newSeqWith(n, default), merge, default, mapping, composition,\
    \ id)\n\n    template newAvlLazySegWith*(vOrN, merge, default, mapping, composition,\
    \ id: untyped): untyped =\n        type S = typeof(default)\n        type F =\
    \ typeof(id)\n        initAvlLazySegmentTree[S, F](\n            vOrN,\n     \
    \       proc (l{.inject.}, r{.inject.}: S): S = merge,\n            default, proc\
    \ (f{.inject.}: F, x{.inject.}: S): S = mapping,\n            proc (f{.inject.},\
    \ g{.inject.}: F): F = composition,\n            id\n        )\n\n    proc len*[S,\
    \ F](self: AvlLazySegmentTree[S, F]): int =\n        ## \u8981\u7D20\u6570\u3092\
    \u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n        self.length\n\n    proc mergeRoot[S,\
    \ F](\n        self: AvlLazySegmentTree[S, F],\n        left, right: AvlLazySegmentTreeNode[S,\
    \ F]\n    ): AvlLazySegmentTreeNode[S, F] =\n        ## \u4E8C\u3064\u306E\u6728\
    \u3092\u9806\u5E8F\u3092\u4FDD\u3063\u3066\u7D50\u5408\u3057\u307E\u3059\u3002\
    O(log N)\u3002\n        mergeNode(left, right, self.merge, self.default, self.mapping,\
    \ self.composition, self.id)\n\n    proc splitRoot[S, F](\n        self: AvlLazySegmentTree[S,\
    \ F],\n        node: AvlLazySegmentTreeNode[S, F],\n        k: int\n    ): (AvlLazySegmentTreeNode[S,\
    \ F], AvlLazySegmentTreeNode[S, F]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\
    \u6728\u3092\u5206\u5272\u3057\u307E\u3059\u3002O(log N)\u3002\n        split(node,\
    \ k, self.merge, self.default, self.mapping, self.composition, self.id)\n\n  \
    \  proc split*[S, F](self: AvlLazySegmentTree[S, F], k: int): (AvlLazySegmentTree[S,\
    \ F], AvlLazySegmentTree[S, F]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\
    \u5206\u5272\u3057\u3001\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        assert 0 <= k and k <= self.length, \"0 <= k <=\
    \ len \u304C\u5FC5\u8981\u3067\u3059\"\n        let n = self.length\n        var\
    \ root = move(self.root)\n        let (leftRoot, rightRoot) = self.splitRoot(root,\
    \ k)\n        self.length = 0\n        result = (\n            AvlLazySegmentTree[S,\
    \ F](root: leftRoot, length: k, merge: self.merge, default: self.default, mapping:\
    \ self.mapping, composition: self.composition, id: self.id),\n            AvlLazySegmentTree[S,\
    \ F](root: rightRoot, length: n - k, merge: self.merge, default: self.default,\
    \ mapping: self.mapping, composition: self.composition, id: self.id)\n       \
    \ )\n\n    proc merge*[S, F](left, right: AvlLazySegmentTree[S, F]): AvlLazySegmentTree[S,\
    \ F] =\n        ## \u5DE6\u53F3\u306E\u5217\u3092\u9023\u7D50\u3057\u3001\u4E21\
    \u65B9\u306E\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002\u540C\
    \u3058\u6F14\u7B97\u304C\u5FC5\u8981\u3067\u3059\u3002O(log N)\u3002\n       \
    \ assert left != right, \"\u540C\u3058\u5217\u3092\u9023\u7D50\u3067\u304D\u307E\
    \u305B\u3093\"\n        let n = left.length + right.length\n        var leftRoot\
    \ = move(left.root)\n        var rightRoot = move(right.root)\n        result\
    \ = AvlLazySegmentTree[S, F](root: left.mergeRoot(leftRoot, rightRoot), length:\
    \ n, merge: left.merge, default: left.default, mapping: left.mapping, composition:\
    \ left.composition, id: left.id)\n        left.length = 0\n        right.length\
    \ = 0\n\n\n    proc insertNode[S, F](self: AvlLazySegmentTree[S, F], root, node:\
    \ AvlLazySegmentTreeNode[S, F], k: int): AvlLazySegmentTreeNode[S, F] =\n    \
    \    ## \u6307\u5B9A\u4F4D\u7F6E\u306B\u30CE\u30FC\u30C9\u3092\u633F\u5165\u3057\
    \u307E\u3059\u3002O(log N)\u3002\n        if root.isNil: return node\n       \
    \ root.push(self.mapping, self.composition, self.id)\n        let leftSize = root.left.nodeLen\n\
    \        if k <= leftSize:\n            var branch = move(root.left)\n       \
    \     root.left = self.insertNode(branch, node, k)\n        else:\n          \
    \  var branch = move(root.right)\n            root.right = self.insertNode(branch,\
    \ node, k - leftSize - 1)\n        root.rebalance(self.merge, self.default, self.mapping,\
    \ self.composition, self.id)\n\n    proc eraseNode[S, F](self: AvlLazySegmentTree[S,\
    \ F], root: AvlLazySegmentTreeNode[S, F], k: int): AvlLazySegmentTreeNode[S, F]\
    \ =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u30CE\u30FC\u30C9\u3092\u524A\u9664\
    \u3057\u307E\u3059\u3002O(log N)\u3002\n        root.push(self.mapping, self.composition,\
    \ self.id)\n        let leftSize = root.left.nodeLen\n        if k == leftSize:\n\
    \            var left = move(root.left)\n            var right = move(root.right)\n\
    \            return self.mergeRoot(left, right)\n        if k < leftSize:\n  \
    \          var branch = move(root.left)\n            root.left = self.eraseNode(branch,\
    \ k)\n        else:\n            var branch = move(root.right)\n            root.right\
    \ = self.eraseNode(branch, k - leftSize - 1)\n        root.rebalance(self.merge,\
    \ self.default, self.mapping, self.composition, self.id)\n\n    proc insert*[S,\
    \ F](self: AvlLazySegmentTree[S, F], index: int, value: S) =\n        ## index\
    \ \u306E\u76F4\u524D\u306B value \u3092\u633F\u5165\u3059\u308B\u3002\u672B\u5C3E\
    \u306B\u306F index = len \u3092\u6307\u5B9A\u3059\u308B\u3002\n        ## O(log\
    \ N)\u3002\u633F\u5165\u524D\u306E\u533A\u9593\u66F4\u65B0\u306F\u65B0\u3057\u3044\
    \u8981\u7D20\u306B\u306F\u4F5C\u7528\u3057\u306A\u3044\u3002\n        assert 0\
    \ <= index and index <= self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\
    \u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059: 0 <= index and index <= self.length\"\n        let node = newNode(value,\
    \ self.id)\n        var root = move(self.root)\n        self.root = self.insertNode(root,\
    \ node, index)\n        inc self.length\n\n    proc insort*[S, F](self: AvlLazySegmentTree[S,\
    \ F], value: S, less: proc(x, y: S): bool): int {.discardable.} =\n        ##\
    \ \u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\u5024\u306E\u672B\u5C3E\
    \u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\u3001\u305D\u306E\u4F4D\
    \u7F6E\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        var node = self.root\n\
    \        while not node.isNil:\n            node.push(self.mapping, self.composition,\
    \ self.id)\n            if less(value, node.value):\n                node = node.left\n\
    \            else:\n                result += node.left.nodeLen + 1\n        \
    \        node = node.right\n        self.insert(result, value)\n\n    proc insort*[S,\
    \ F](self: AvlLazySegmentTree[S, F], value: S): int {.discardable.} =\n      \
    \  ## < \u3067\u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\u5024\u306E\
    \u672B\u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        self.insort(value, proc(x, y: S): bool = x < y)\n\
    \n    proc erase*[S, F](self: AvlLazySegmentTree[S, F], l, r: int) =\n       \
    \ ## \u534A\u958B\u533A\u9593 [l, r) \u3092\u524A\u9664\u3059\u308B\u3002\u6728\
    \u306E\u64CD\u4F5C\u306FO(log N)\u3002\n        ## \u524A\u9664\u3057\u305F K\
    \ \u500B\u306E\u30CE\u30FC\u30C9\u306E\u89E3\u653E\u306B\u306F\u5225\u9014 O(K)\
    \ \u304B\u304B\u308A\u3046\u308B\u3002\n        assert 0 <= l and l <= r and r\
    \ <= self.length, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : 0 <= l and l <= r and r <= self.length\"\n        if l == r: return\n      \
    \  var (left, middleRight) = self.splitRoot(self.root, l)\n        var (_, right)\
    \ = self.splitRoot(middleRight, r - l)\n        self.root = self.mergeRoot(left,\
    \ right)\n        self.length -= r - l\n\n    proc erase*[S, F](self: AvlLazySegmentTree[S,\
    \ F], index: int) =\n        ## index \u756A\u76EE\u306E\u8981\u7D20\u3092\u524A\
    \u9664\u3059\u308B\u3002O(log N)\u3002\n        assert 0 <= index and index <\
    \ self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\
    \u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index\
    \ and index < self.length\"\n        var root = move(self.root)\n        self.root\
    \ = self.eraseNode(root, index)\n        dec self.length\n\n    proc erase*[S,\
    \ F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]) =\n        ##\
    \ \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\u533A\u9593\u306E\u8981\u7D20\u3092\
    \u524A\u9664\u3057\u307E\u3059\u3002\u6728\u306E\u64CD\u4F5C\u306FO(log N)\u3002\
    \n        self.erase(segment.a, segment.b + 1)\n\n    proc apply*[S, F](self:\
    \ AvlLazySegmentTree[S, F], l, r: int, f: F) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\
    \u307E\u305F\u306F\u533A\u9593\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\
    \u3059\u3002O(log N)\u3002\n        assert 0 <= l and l <= r and r <= self.length,\
    \ \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\
    \u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <=\
    \ r and r <= self.length\"\n        var (left, middleRight) = self.splitRoot(self.root,\
    \ l)\n        var (middle, right) = self.splitRoot(middleRight, r - l)\n     \
    \   middle.allApply(f, self.mapping, self.composition)\n        self.root = self.mergeRoot(left,\
    \ self.mergeRoot(middle, right))\n\n    proc applyNode[S, F](self: AvlLazySegmentTree[S,\
    \ F], node: AvlLazySegmentTreeNode[S, F], k: int, f: F) =\n        ## \u6307\u5B9A\
    \u4F4D\u7F6E\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u3066\u7DCF\u7A4D\u3092\
    \u66F4\u65B0\u3057\u307E\u3059\u3002O(log N)\u3002\n        node.push(self.mapping,\
    \ self.composition, self.id)\n        let leftSize = node.left.nodeLen\n     \
    \   if k < leftSize:\n            self.applyNode(node.left, k, f)\n        elif\
    \ k == leftSize:\n            node.value = self.mapping(f, node.value)\n     \
    \   else:\n            self.applyNode(node.right, k - leftSize - 1, f)\n     \
    \   node.update(self.merge, self.default)\n\n    proc apply*[S, F](self: AvlLazySegmentTree[S,\
    \ F], index: int, f: F) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u307E\u305F\u306F\
    \u533A\u9593\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        assert 0 <= index and index < self.length, \"\u6307\u5B9A\u3057\
    \u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index and index < self.length\"\n \
    \       self.applyNode(self.root, index, f)\n\n    proc apply*[S, F](self: AvlLazySegmentTree[S,\
    \ F], segment: HSlice[int, int], f: F) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u307E\
    \u305F\u306F\u533A\u9593\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        self.apply(segment.a, segment.b + 1, f)\n\n    proc\
    \ get*[S, F](self: AvlLazySegmentTree[S, F], l, r: int): S =\n        ## \u6307\
    \u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\u533A\u9593\u306E\u7DCF\u7A4D\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        assert 0 <= l and\
    \ l <= r and r <= self.length, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\
    \u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059: 0 <= l and l <= r and r <= self.length\"\n        var (left, middleRight)\
    \ = self.splitRoot(self.root, l)\n        var (middle, right) = self.splitRoot(middleRight,\
    \ r - l)\n        result = middle.nodeProd(self.default)\n        self.root =\
    \ self.mergeRoot(left, self.mergeRoot(middle, right))\n\n    proc get*[S, F](self:\
    \ AvlLazySegmentTree[S, F], segment: HSlice[int, int]): S =\n        ## \u6307\
    \u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\u533A\u9593\u306E\u7DCF\u7A4D\
    \u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.get(segment.a,\
    \ segment.b + 1)\n\n    proc fold*[S, F](self: AvlLazySegmentTree[S, F], l, r:\
    \ int): S =\n        ## \u6307\u5B9A\u533A\u9593\u307E\u305F\u306F\u5168\u4F53\
    \u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\u533A\u9593\u306FO(log\
    \ N)\u3001\u5168\u4F53\u306F O(1)\u3002\n        self.get(l, r)\n\n    proc fold*[S,\
    \ F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]): S =\n       \
    \ ## \u6307\u5B9A\u533A\u9593\u307E\u305F\u306F\u5168\u4F53\u306E\u7DCF\u7A4D\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\u533A\u9593\u306FO(log N)\u3001\u5168\u4F53\u306F\
    \ O(1)\u3002\n        self.get(segment)\n\n    proc fold*[S, F](self: AvlLazySegmentTree[S,\
    \ F]): S =\n        ## \u6307\u5B9A\u533A\u9593\u307E\u305F\u306F\u5168\u4F53\u306E\
    \u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\u533A\u9593\u306FO(log N)\u3001\
    \u5168\u4F53\u306F O(1)\u3002\n        self.root.nodeProd(self.default)\n\n  \
    \  proc get_all*[S, F](self: AvlLazySegmentTree[S, F]): S =\n        ## \u5168\
    \u8981\u7D20\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(1)\u3002\n\
    \        self.root.nodeProd(self.default)\n\n    proc max_right*[S, F](self: AvlLazySegmentTree[S,\
    \ F], l: int, f: proc(x: S): bool): int =\n        ## f(get(l, r)) \u304C\u771F\
    \u3068\u306A\u308B\u6700\u5927\u306E r\u3002O(log N)\u3002\n        ## f(default)\
    \ = true \u3067\u3001\u533A\u9593\u3092\u4F38\u3070\u3057\u305F\u3068\u304D\u771F\
    \u304B\u3089\u507D\u3078\u306E\u5909\u5316\u304C\u5358\u8ABF\u3067\u3042\u308B\
    \u3053\u3068\u3002\n        assert 0 <= l and l <= self.length, \"\u6307\u5B9A\
    \u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= self.length\"\n  \
    \      assert f(self.default), \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\
    \u306B\u5BFE\u3057\u3066true\u3092\u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059\"\n        var (left, right) = self.splitRoot(self.root, l)\n        var\
    \ node = right\n        var acc = self.default\n        result = l\n        while\
    \ not node.isNil:\n            node.push(self.mapping, self.composition, self.id)\n\
    \            let next = self.merge(acc, node.left.nodeProd(self.default))\n  \
    \          if not f(next):\n                node = node.left\n            else:\n\
    \                acc = next\n                result += node.left.nodeLen\n   \
    \             let withValue = self.merge(acc, node.value)\n                if\
    \ not f(withValue): break\n                acc = withValue\n                inc\
    \ result\n                node = node.right\n        self.root = self.mergeRoot(left,\
    \ right)\n\n    proc min_left*[S, F](self: AvlLazySegmentTree[S, F], r: int, f:\
    \ proc(x: S): bool): int =\n        ## f(get(l, r)) \u304C\u771F\u3068\u306A\u308B\
    \u6700\u5C0F\u306E l\u3002O(log N)\u3002\n        ## f(default) = true \u3067\u3001\
    \u533A\u9593\u3092\u4F38\u3070\u3057\u305F\u3068\u304D\u771F\u304B\u3089\u507D\
    \u3078\u306E\u5909\u5316\u304C\u5358\u8ABF\u3067\u3042\u308B\u3053\u3068\u3002\
    \n        assert 0 <= r and r <= self.length, \"\u6307\u5B9A\u3057\u305F\u5024\
    \u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059: 0 <= r and r <= self.length\"\n        assert f(self.default),\
    \ \"\u5224\u5B9A\u95A2\u6570\u306F\u5358\u4F4D\u5143\u306B\u5BFE\u3057\u3066true\u3092\
    \u8FD4\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        var (left, right)\
    \ = self.splitRoot(self.root, r)\n        var node = left\n        var acc = self.default\n\
    \        result = r\n        while not node.isNil:\n            node.push(self.mapping,\
    \ self.composition, self.id)\n            let next = self.merge(node.right.nodeProd(self.default),\
    \ acc)\n            if not f(next):\n                node = node.right\n     \
    \       else:\n                acc = next\n                result -= node.right.nodeLen\n\
    \                let withValue = self.merge(node.value, acc)\n               \
    \ if not f(withValue): break\n                acc = withValue\n              \
    \  dec result\n                node = node.left\n        self.root = self.mergeRoot(left,\
    \ right)\n\n    proc get*[S, F](self: AvlLazySegmentTree[S, F], index: int): S\
    \ =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\u533A\u9593\
    \u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n       \
    \ assert 0 <= index and index < self.length, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\
    \u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059: 0 <= index and index < self.length\"\n        var node = self.root\n\
    \        var k = index\n        while true:\n            node.push(self.mapping,\
    \ self.composition, self.id)\n            let leftSize = node.left.nodeLen\n \
    \           if k < leftSize:\n                node = node.left\n            elif\
    \ k == leftSize:\n                return node.value\n            else:\n     \
    \           k -= leftSize + 1\n                node = node.right\n\n    proc updateNode[S,\
    \ F](self: AvlLazySegmentTree[S, F], node: AvlLazySegmentTreeNode[S, F], k: int,\
    \ value: S) =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\u7F6E\u304D\
    \u63DB\u3048\u3066\u7DCF\u7A4D\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002O(log\
    \ N)\u3002\n        node.push(self.mapping, self.composition, self.id)\n     \
    \   let leftSize = node.left.nodeLen\n        if k < leftSize:\n            self.updateNode(node.left,\
    \ k, value)\n        elif k == leftSize:\n            node.value = value\n   \
    \     else:\n            self.updateNode(node.right, k - leftSize - 1, value)\n\
    \        node.update(self.merge, self.default)\n\n    proc update*[S, F](self:\
    \ AvlLazySegmentTree[S, F], index: Natural, value: S) =\n        ## \u6307\u5B9A\
    \u4F4D\u7F6E\u306E\u5024\u3092\u7F6E\u304D\u63DB\u3048\u307E\u3059\u3002O(log\
    \ N)\u3002\n        assert index < self.length, \"\u6307\u5B9A\u3057\u305F\u5024\
    \u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059: index < self.length\"\n        self.updateNode(self.root,\
    \ int(index), value)\n\n    proc `[]`*[S, F](self: AvlLazySegmentTree[S, F], index:\
    \ int): S =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\
    \u533A\u9593\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\
    \n        self.get(index)\n\n    proc `[]`*[S, F](self: AvlLazySegmentTree[S,\
    \ F], index: BackwardsIndex): S =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\
    \u307E\u305F\u306F\u533A\u9593\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\u3059\
    \u3002O(log N)\u3002\n        self.get(self.length - int(index))\n\n    proc `[]`*[S,\
    \ F](self: AvlLazySegmentTree[S, F], segment: HSlice[int, int]): S =\n       \
    \ ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u307E\u305F\u306F\u533A\u9593\u306E\u7DCF\
    \u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.get(segment)\n\
    \n    proc `[]=`*[S, F](self: AvlLazySegmentTree[S, F], index: Natural, value:\
    \ S) {.backwardsIndex.} =\n        ## \u6307\u5B9A\u4F4D\u7F6E\u306E\u5024\u3092\
    \u66F4\u65B0\u3057\u307E\u3059\u3002O(log N)\u3002\n        self.update(index,\
    \ value)\n\n    iterator items*[S, F](self: AvlLazySegmentTree[S, F]): S =\n \
    \       if not self.root.isNil:\n            var stack = @[(0, self.root)]\n \
    \           while stack.len > 0:\n                var (t, node) = stack.pop()\n\
    \                node.push(self.mapping, self.composition, self.id)\n        \
    \        if t == 0:\n                    if not node.right.isNil: stack.add((0,\
    \ node.right))\n                    stack.add((1, node))\n                   \
    \ if not node.left.isNil: stack.add((0, node.left))\n                else:\n \
    \                   yield node.value\n\n    proc toSeq*[S, F](self: AvlLazySegmentTree[S,\
    \ F]): seq[S] =\n        ## \u5168\u8981\u7D20\u3092\u914D\u5217\u3068\u3057\u3066\
    \u8FD4\u3057\u307E\u3059\u3002O(N)\u3002\n        for x in self:\n           \
    \ result.add(x)\n\n    proc `$`*[S, F](self: AvlLazySegmentTree[S, F]): string\
    \ =\n        ## \u5168\u8981\u7D20\u306E\u6587\u5B57\u5217\u8868\u73FE\u3092\u8FD4\
    \u3057\u307E\u3059\u3002O(N)\u3002\n        var s: seq[string]\n        for x\
    \ in self:\n            s.add($x)\n        return s.join(\" \")\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/utils/backwards_index.nim
  isVerificationFile: false
  path: cplib/collections/avl_lazysegtree.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/avl_lazysegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/avl_lazysegtree.nim
- /library/cplib/collections/avl_lazysegtree.nim.html
title: cplib/collections/avl_lazysegtree.nim
---
