---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_lazysegtree_test.nim
    title: verify/collections/range_reverse_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_lazysegtree_test.nim
    title: verify/collections/range_reverse_lazysegtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_LAZYSEGTREE:\n    const\
    \ CPLIB_COLLECTIONS_RANGE_REVERSE_LAZYSEGTREE* = 1\n    import random, sequtils,\
    \ strutils\n\n    randomize()\n\n    type RangeReverseLazySegmentTreeNode[S, F]\
    \ {.acyclic.} = ref object\n        left, right: RangeReverseLazySegmentTreeNode[S,\
    \ F]\n        priority: uint64\n        size: int\n        rev: bool\n       \
    \ value, prod, rprod: S\n        lazy: F\n\n    type RangeReverseLazySegmentTree*[S,\
    \ F] = ref object\n        root: RangeReverseLazySegmentTreeNode[S, F]\n     \
    \   length: int\n        merge: proc(x, y: S): S\n        default: S\n       \
    \ mapping: proc(f: F, x: S): S\n        composition: proc(f, g: F): F\n      \
    \  id: F\n\n    proc nodeLen[S, F](node: RangeReverseLazySegmentTreeNode[S, F]):\
    \ int {.inline.} =\n        if node.isNil: 0 else: node.size\n\n    proc nodeProd[S,\
    \ F](node: RangeReverseLazySegmentTreeNode[S, F], default: S): S {.inline.} =\n\
    \        if node.isNil: default else: node.prod\n\n    proc nodeRProd[S, F](node:\
    \ RangeReverseLazySegmentTreeNode[S, F], default: S): S {.inline.} =\n       \
    \ if node.isNil: default else: node.rprod\n\n    proc update[S, F](node: RangeReverseLazySegmentTreeNode[S,\
    \ F], merge: proc(x, y: S): S, default: S) =\n        if node.isNil: return\n\
    \        node.size = 1 + node.left.nodeLen + node.right.nodeLen\n        node.prod\
    \ = merge(merge(node.left.nodeProd(default), node.value), node.right.nodeProd(default))\n\
    \        node.rprod = merge(merge(node.right.nodeRProd(default), node.value),\
    \ node.left.nodeRProd(default))\n\n    proc allApply[S, F](\n        node: RangeReverseLazySegmentTreeNode[S,\
    \ F],\n        f: F,\n        mapping: proc(f: F, x: S): S,\n        composition:\
    \ proc(f, g: F): F\n    ) =\n        if node.isNil: return\n        node.value\
    \ = mapping(f, node.value)\n        node.prod = mapping(f, node.prod)\n      \
    \  node.rprod = mapping(f, node.rprod)\n        node.lazy = composition(f, node.lazy)\n\
    \n    proc toggle[S, F](node: RangeReverseLazySegmentTreeNode[S, F]) =\n     \
    \   if not node.isNil:\n            node.rev = not node.rev\n            let tmp\
    \ = node.prod\n            node.prod = node.rprod\n            node.rprod = tmp\n\
    \n    proc push[S, F](\n        node: RangeReverseLazySegmentTreeNode[S, F],\n\
    \        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g: F): F,\n\
    \        id: F\n    ) =\n        if node.isNil: return\n        if node.rev:\n\
    \            let tmp = node.left\n            node.left = node.right\n       \
    \     node.right = tmp\n            node.left.toggle\n            node.right.toggle\n\
    \            node.rev = false\n        node.left.allApply(node.lazy, mapping,\
    \ composition)\n        node.right.allApply(node.lazy, mapping, composition)\n\
    \        node.lazy = id\n\n    proc newNode[S, F](value: S, priority: uint64,\
    \ id: F): RangeReverseLazySegmentTreeNode[S, F] =\n        RangeReverseLazySegmentTreeNode[S,\
    \ F](priority: priority, size: 1, value: value, prod: value, rprod: value, lazy:\
    \ id)\n\n    proc updateAll[S, F](\n        node: RangeReverseLazySegmentTreeNode[S,\
    \ F],\n        merge: proc(x, y: S): S,\n        default: S\n    ) =\n       \
    \ if node.isNil: return\n        node.left.updateAll(merge, default)\n       \
    \ node.right.updateAll(merge, default)\n        node.update(merge, default)\n\n\
    \    proc build[S, F](v: openArray[S], merge: proc(x, y: S): S, default: S, id:\
    \ F): RangeReverseLazySegmentTreeNode[S, F] =\n        var stack: seq[RangeReverseLazySegmentTreeNode[S,\
    \ F]]\n        for i in 0..<v.len:\n            let node = newNode(v[i], rand(uint64),\
    \ id)\n            var last: RangeReverseLazySegmentTreeNode[S, F] = nil\n   \
    \         while stack.len > 0 and stack[^1].priority < node.priority:\n      \
    \          last = stack.pop()\n            node.left = last\n            if stack.len\
    \ > 0:\n                stack[^1].right = node\n            stack.add(node)\n\
    \        if stack.len == 0:\n            return nil\n        result = stack[0]\n\
    \        result.updateAll(merge, default)\n\n    proc mergeNode[S, F](\n     \
    \   left, right: RangeReverseLazySegmentTreeNode[S, F],\n        merge: proc(x,\
    \ y: S): S,\n        default: S,\n        mapping: proc(f: F, x: S): S,\n    \
    \    composition: proc(f, g: F): F,\n        id: F\n    ): RangeReverseLazySegmentTreeNode[S,\
    \ F] =\n        if left.isNil: return right\n        if right.isNil: return left\n\
    \        if left.priority > right.priority:\n            left.push(mapping, composition,\
    \ id)\n            left.right = mergeNode(left.right, right, merge, default, mapping,\
    \ composition, id)\n            left.update(merge, default)\n            return\
    \ left\n        else:\n            right.push(mapping, composition, id)\n    \
    \        right.left = mergeNode(left, right.left, merge, default, mapping, composition,\
    \ id)\n            right.update(merge, default)\n            return right\n\n\
    \    proc split[S, F](\n        node: RangeReverseLazySegmentTreeNode[S, F],\n\
    \        k: int,\n        merge: proc(x, y: S): S,\n        default: S,\n    \
    \    mapping: proc(f: F, x: S): S,\n        composition: proc(f, g: F): F,\n \
    \       id: F\n    ): (RangeReverseLazySegmentTreeNode[S, F], RangeReverseLazySegmentTreeNode[S,\
    \ F]) =\n        if node.isNil:\n            return (nil, nil)\n        node.push(mapping,\
    \ composition, id)\n        let leftSize = node.left.nodeLen\n        if k <=\
    \ leftSize:\n            var (left, right) = split(node.left, k, merge, default,\
    \ mapping, composition, id)\n            node.left = right\n            node.update(merge,\
    \ default)\n            return (left, node)\n        else:\n            var (left,\
    \ right) = split(node.right, k - leftSize - 1, merge, default, mapping, composition,\
    \ id)\n            node.right = left\n            node.update(merge, default)\n\
    \            return (node, right)\n\n    proc initRangeReverseLazySegmentTree*[S,\
    \ F](\n        v: openArray[S],\n        merge: proc(x, y: S): S,\n        default:\
    \ S,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g: F):\
    \ F,\n        id: F\n    ): RangeReverseLazySegmentTree[S, F] =\n        RangeReverseLazySegmentTree[S,\
    \ F](\n            root: build(v, merge, default, id),\n            length: v.len,\n\
    \            merge: merge,\n            default: default,\n            mapping:\
    \ mapping,\n            composition: composition,\n            id: id\n      \
    \  )\n\n    proc initRangeReverseLazySegmentTree*[S, F](\n        n: int,\n  \
    \      merge: proc(x, y: S): S,\n        default: S,\n        mapping: proc(f:\
    \ F, x: S): S,\n        composition: proc(f, g: F): F,\n        id: F\n    ):\
    \ RangeReverseLazySegmentTree[S, F] =\n        initRangeReverseLazySegmentTree(newSeqWith(n,\
    \ default), merge, default, mapping, composition, id)\n\n    template newRangeReverseLazySegWith*(vOrN,\
    \ merge, default, mapping, composition, id: untyped): untyped =\n        type\
    \ S = typeof(default)\n        type F = typeof(id)\n        initRangeReverseLazySegmentTree[S,\
    \ F](\n            vOrN,\n            proc (l{.inject.}, r{.inject.}: S): S =\
    \ merge,\n            default, proc (f{.inject.}: F, x{.inject.}: S): S = mapping,\n\
    \            proc (f{.inject.}, g{.inject.}: F): F = composition,\n          \
    \  id\n        )\n\n    proc len*[S, F](self: RangeReverseLazySegmentTree[S, F]):\
    \ int =\n        self.length\n\n    proc mergeRoot[S, F](\n        self: RangeReverseLazySegmentTree[S,\
    \ F],\n        left, right: RangeReverseLazySegmentTreeNode[S, F]\n    ): RangeReverseLazySegmentTreeNode[S,\
    \ F] =\n        mergeNode(left, right, self.merge, self.default, self.mapping,\
    \ self.composition, self.id)\n\n    proc splitRoot[S, F](\n        self: RangeReverseLazySegmentTree[S,\
    \ F],\n        node: RangeReverseLazySegmentTreeNode[S, F],\n        k: int\n\
    \    ): (RangeReverseLazySegmentTreeNode[S, F], RangeReverseLazySegmentTreeNode[S,\
    \ F]) =\n        split(node, k, self.merge, self.default, self.mapping, self.composition,\
    \ self.id)\n\n    proc reverse*[S, F](self: RangeReverseLazySegmentTree[S, F],\
    \ l, r: int) =\n        assert 0 <= l and l <= r and r <= self.length\n      \
    \  var (left, middleRight) = self.splitRoot(self.root, l)\n        var (middle,\
    \ right) = self.splitRoot(middleRight, r - l)\n        middle.toggle\n       \
    \ self.root = self.mergeRoot(left, self.mergeRoot(middle, right))\n\n    proc\
    \ reverse*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int,\
    \ int]) =\n        self.reverse(segment.a, segment.b + 1)\n\n    proc apply*[S,\
    \ F](self: RangeReverseLazySegmentTree[S, F], l, r: int, f: F) =\n        assert\
    \ 0 <= l and l <= r and r <= self.length\n        var (left, middleRight) = self.splitRoot(self.root,\
    \ l)\n        var (middle, right) = self.splitRoot(middleRight, r - l)\n     \
    \   middle.allApply(f, self.mapping, self.composition)\n        self.root = self.mergeRoot(left,\
    \ self.mergeRoot(middle, right))\n\n    proc apply*[S, F](self: RangeReverseLazySegmentTree[S,\
    \ F], segment: HSlice[int, int], f: F) =\n        self.apply(segment.a, segment.b\
    \ + 1, f)\n\n    proc get*[S, F](self: RangeReverseLazySegmentTree[S, F], l, r:\
    \ int): S =\n        assert 0 <= l and l <= r and r <= self.length\n        var\
    \ (left, middleRight) = self.splitRoot(self.root, l)\n        var (middle, right)\
    \ = self.splitRoot(middleRight, r - l)\n        result = middle.nodeProd(self.default)\n\
    \        self.root = self.mergeRoot(left, self.mergeRoot(middle, right))\n\n \
    \   proc get*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int,\
    \ int]): S =\n        self.get(segment.a, segment.b + 1)\n\n    proc fold*[S,\
    \ F](self: RangeReverseLazySegmentTree[S, F], l, r: int): S =\n        self.get(l,\
    \ r)\n\n    proc fold*[S, F](self: RangeReverseLazySegmentTree[S, F], segment:\
    \ HSlice[int, int]): S =\n        self.get(segment)\n\n    proc fold*[S, F](self:\
    \ RangeReverseLazySegmentTree[S, F]): S =\n        self.root.nodeProd(self.default)\n\
    \n    proc get_all*[S, F](self: RangeReverseLazySegmentTree[S, F]): S =\n    \
    \    self.root.nodeProd(self.default)\n\n    proc get*[S, F](self: RangeReverseLazySegmentTree[S,\
    \ F], index: int): S =\n        assert 0 <= index and index < self.length\n  \
    \      var node = self.root\n        var k = index\n        while true:\n    \
    \        node.push(self.mapping, self.composition, self.id)\n            let leftSize\
    \ = node.left.nodeLen\n            if k < leftSize:\n                node = node.left\n\
    \            elif k == leftSize:\n                return node.value\n        \
    \    else:\n                k -= leftSize + 1\n                node = node.right\n\
    \n    proc update*[S, F](self: RangeReverseLazySegmentTree[S, F], index: Natural,\
    \ value: S) =\n        assert index < self.length\n        var (left, middleRight)\
    \ = self.splitRoot(self.root, int(index))\n        var (middle, right) = self.splitRoot(middleRight,\
    \ 1)\n        middle.value = value\n        middle.prod = value\n        middle.rprod\
    \ = value\n        middle.lazy = self.id\n        middle.rev = false\n       \
    \ self.root = self.mergeRoot(left, self.mergeRoot(middle, right))\n\n    proc\
    \ `[]`*[S, F](self: RangeReverseLazySegmentTree[S, F], index: int): S =\n    \
    \    self.get(index)\n\n    proc `[]`*[S, F](self: RangeReverseLazySegmentTree[S,\
    \ F], index: BackwardsIndex): S =\n        self.get(self.length - int(index))\n\
    \n    proc `[]`*[S, F](self: RangeReverseLazySegmentTree[S, F], segment: HSlice[int,\
    \ int]): S =\n        self.get(segment)\n\n    proc `[]=`*[S, F](self: RangeReverseLazySegmentTree[S,\
    \ F], index: Natural, value: S) =\n        self.update(index, value)\n\n    iterator\
    \ items*[S, F](self: RangeReverseLazySegmentTree[S, F]): S =\n        if not self.root.isNil:\n\
    \            var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                var (t, node) = stack.pop()\n                node.push(self.mapping,\
    \ self.composition, self.id)\n                if t == 0:\n                   \
    \ if not node.right.isNil: stack.add((0, node.right))\n                    stack.add((1,\
    \ node))\n                    if not node.left.isNil: stack.add((0, node.left))\n\
    \                else:\n                    yield node.value\n\n    proc toSeq*[S,\
    \ F](self: RangeReverseLazySegmentTree[S, F]): seq[S] =\n        for x in self:\n\
    \            result.add(x)\n\n    proc `$`*[S, F](self: RangeReverseLazySegmentTree[S,\
    \ F]): string =\n        var s: seq[string]\n        for x in self:\n        \
    \    s.add($x)\n        return s.join(\" \")\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/range_reverse_lazysegtree.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_reverse_lazysegtree_test.nim
  - verify/collections/range_reverse_lazysegtree_test.nim
documentation_of: cplib/collections/range_reverse_lazysegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/range_reverse_lazysegtree.nim
- /library/cplib/collections/range_reverse_lazysegtree.nim.html
title: cplib/collections/range_reverse_lazysegtree.nim
---
