---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_dualsegtree_test.nim
    title: verify/collections/range_reverse_dualsegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_dualsegtree_test.nim
    title: verify/collections/range_reverse_dualsegtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_DUALSEGTREE:\n    const\
    \ CPLIB_COLLECTIONS_RANGE_REVERSE_DUALSEGTREE* = 1\n    import random, sequtils,\
    \ strutils\n\n    randomize()\n\n    type RangeReverseDualSegmentTreeNode[S, F]\
    \ {.acyclic.} = ref object\n        left, right: RangeReverseDualSegmentTreeNode[S,\
    \ F]\n        priority: uint64\n        size: int\n        rev: bool\n       \
    \ value: S\n        lazy: F\n\n    type RangeReverseDualSegmentTree*[S, F] = ref\
    \ object\n        root: RangeReverseDualSegmentTreeNode[S, F]\n        length:\
    \ int\n        mapping: proc(f: F, x: S): S\n        composition: proc(f, g: F):\
    \ F\n        id: F\n\n    proc nodeLen[S, F](node: RangeReverseDualSegmentTreeNode[S,\
    \ F]): int {.inline.} =\n        if node.isNil: 0 else: node.size\n\n    proc\
    \ update[S, F](node: RangeReverseDualSegmentTreeNode[S, F]) =\n        if node.isNil:\
    \ return\n        node.size = 1 + node.left.nodeLen + node.right.nodeLen\n\n \
    \   proc allApply[S, F](\n        node: RangeReverseDualSegmentTreeNode[S, F],\n\
    \        f: F,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f,\
    \ g: F): F\n    ) =\n        if node.isNil: return\n        node.value = mapping(f,\
    \ node.value)\n        node.lazy = composition(f, node.lazy)\n\n    proc toggle[S,\
    \ F](node: RangeReverseDualSegmentTreeNode[S, F]) =\n        if not node.isNil:\n\
    \            node.rev = not node.rev\n\n    proc push[S, F](\n        node: RangeReverseDualSegmentTreeNode[S,\
    \ F],\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g:\
    \ F): F,\n        id: F\n    ) =\n        if node.isNil: return\n        if node.rev:\n\
    \            let tmp = node.left\n            node.left = node.right\n       \
    \     node.right = tmp\n            node.left.toggle\n            node.right.toggle\n\
    \            node.rev = false\n        node.left.allApply(node.lazy, mapping,\
    \ composition)\n        node.right.allApply(node.lazy, mapping, composition)\n\
    \        node.lazy = id\n\n    proc newNode[S, F](value: S, priority: uint64,\
    \ id: F): RangeReverseDualSegmentTreeNode[S, F] =\n        RangeReverseDualSegmentTreeNode[S,\
    \ F](priority: priority, size: 1, value: value, lazy: id)\n\n    proc updateAll[S,\
    \ F](node: RangeReverseDualSegmentTreeNode[S, F]) =\n        if node.isNil: return\n\
    \        node.left.updateAll\n        node.right.updateAll\n        node.update\n\
    \n    proc build[S, F](v: openArray[S], id: F): RangeReverseDualSegmentTreeNode[S,\
    \ F] =\n        var stack: seq[RangeReverseDualSegmentTreeNode[S, F]]\n      \
    \  for i in 0..<v.len:\n            let node = newNode(v[i], rand(uint64), id)\n\
    \            var last: RangeReverseDualSegmentTreeNode[S, F] = nil\n         \
    \   while stack.len > 0 and stack[^1].priority < node.priority:\n            \
    \    last = stack.pop()\n            node.left = last\n            if stack.len\
    \ > 0:\n                stack[^1].right = node\n            stack.add(node)\n\
    \        if stack.len == 0:\n            return nil\n        result = stack[0]\n\
    \        result.updateAll\n\n    proc mergeNode[S, F](\n        left, right: RangeReverseDualSegmentTreeNode[S,\
    \ F],\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g:\
    \ F): F,\n        id: F\n    ): RangeReverseDualSegmentTreeNode[S, F] =\n    \
    \    if left.isNil: return right\n        if right.isNil: return left\n      \
    \  if left.priority > right.priority:\n            left.push(mapping, composition,\
    \ id)\n            left.right = mergeNode(left.right, right, mapping, composition,\
    \ id)\n            left.update\n            return left\n        else:\n     \
    \       right.push(mapping, composition, id)\n            right.left = mergeNode(left,\
    \ right.left, mapping, composition, id)\n            right.update\n          \
    \  return right\n\n    proc split[S, F](\n        node: RangeReverseDualSegmentTreeNode[S,\
    \ F],\n        k: int,\n        mapping: proc(f: F, x: S): S,\n        composition:\
    \ proc(f, g: F): F,\n        id: F\n    ): (RangeReverseDualSegmentTreeNode[S,\
    \ F], RangeReverseDualSegmentTreeNode[S, F]) =\n        if node.isNil:\n     \
    \       return (nil, nil)\n        node.push(mapping, composition, id)\n     \
    \   let leftSize = node.left.nodeLen\n        if k <= leftSize:\n            var\
    \ (left, right) = split(node.left, k, mapping, composition, id)\n            node.left\
    \ = right\n            node.update\n            return (left, node)\n        else:\n\
    \            var (left, right) = split(node.right, k - leftSize - 1, mapping,\
    \ composition, id)\n            node.right = left\n            node.update\n \
    \           return (node, right)\n\n    proc initRangeReverseDualSegmentTree*[S,\
    \ F](\n        v: openArray[S],\n        mapping: proc(f: F, x: S): S,\n     \
    \   composition: proc(f, g: F): F,\n        id: F\n    ): RangeReverseDualSegmentTree[S,\
    \ F] =\n        RangeReverseDualSegmentTree[S, F](root: build(v, id), length:\
    \ v.len, mapping: mapping, composition: composition, id: id)\n\n    proc initRangeReverseDualSegmentTree*[S,\
    \ F](\n        n: int,\n        initValue: S,\n        mapping: proc(f: F, x:\
    \ S): S,\n        composition: proc(f, g: F): F,\n        id: F\n    ): RangeReverseDualSegmentTree[S,\
    \ F] =\n        initRangeReverseDualSegmentTree(newSeqWith(n, initValue), mapping,\
    \ composition, id)\n\n    template newRangeReverseDualSegWith*(v, mapping, composition,\
    \ id: untyped): untyped =\n        type S = typeof(v[0])\n        type F = typeof(id)\n\
    \        initRangeReverseDualSegmentTree[S, F](\n            v,\n            proc\
    \ (f{.inject.}: F, x{.inject.}: S): S = mapping,\n            proc (f{.inject.},\
    \ g{.inject.}: F): F = composition,\n            id\n        )\n\n    template\
    \ newRangeReverseDualSegWith*(n, initValue, mapping, composition, id: untyped):\
    \ untyped =\n        type S = typeof(initValue)\n        type F = typeof(id)\n\
    \        initRangeReverseDualSegmentTree[S, F](\n            n,\n            initValue,\n\
    \            proc (f{.inject.}: F, x{.inject.}: S): S = mapping,\n           \
    \ proc (f{.inject.}, g{.inject.}: F): F = composition,\n            id\n     \
    \   )\n\n    proc len*[S, F](self: RangeReverseDualSegmentTree[S, F]): int =\n\
    \        self.length\n\n    proc mergeRoot[S, F](\n        self: RangeReverseDualSegmentTree[S,\
    \ F],\n        left, right: RangeReverseDualSegmentTreeNode[S, F]\n    ): RangeReverseDualSegmentTreeNode[S,\
    \ F] =\n        mergeNode(left, right, self.mapping, self.composition, self.id)\n\
    \n    proc splitRoot[S, F](\n        self: RangeReverseDualSegmentTree[S, F],\n\
    \        node: RangeReverseDualSegmentTreeNode[S, F],\n        k: int\n    ):\
    \ (RangeReverseDualSegmentTreeNode[S, F], RangeReverseDualSegmentTreeNode[S, F])\
    \ =\n        split(node, k, self.mapping, self.composition, self.id)\n\n    proc\
    \ reverse*[S, F](self: RangeReverseDualSegmentTree[S, F], l, r: int) =\n     \
    \   assert 0 <= l and l <= r and r <= self.length\n        var (left, middleRight)\
    \ = self.splitRoot(self.root, l)\n        var (middle, right) = self.splitRoot(middleRight,\
    \ r - l)\n        middle.toggle\n        self.root = self.mergeRoot(left, self.mergeRoot(middle,\
    \ right))\n\n    proc reverse*[S, F](self: RangeReverseDualSegmentTree[S, F],\
    \ segment: HSlice[int, int]) =\n        self.reverse(segment.a, segment.b + 1)\n\
    \n    proc apply*[S, F](self: RangeReverseDualSegmentTree[S, F], l, r: int, f:\
    \ F) =\n        assert 0 <= l and l <= r and r <= self.length\n        var (left,\
    \ middleRight) = self.splitRoot(self.root, l)\n        var (middle, right) = self.splitRoot(middleRight,\
    \ r - l)\n        middle.allApply(f, self.mapping, self.composition)\n       \
    \ self.root = self.mergeRoot(left, self.mergeRoot(middle, right))\n\n    proc\
    \ apply*[S, F](self: RangeReverseDualSegmentTree[S, F], segment: HSlice[int, int],\
    \ f: F) =\n        self.apply(segment.a, segment.b + 1, f)\n\n    proc get*[S,\
    \ F](self: RangeReverseDualSegmentTree[S, F], index: int): S =\n        assert\
    \ 0 <= index and index < self.length\n        var node = self.root\n        var\
    \ k = index\n        while true:\n            node.push(self.mapping, self.composition,\
    \ self.id)\n            let leftSize = node.left.nodeLen\n            if k < leftSize:\n\
    \                node = node.left\n            elif k == leftSize:\n         \
    \       return node.value\n            else:\n                k -= leftSize +\
    \ 1\n                node = node.right\n\n    proc update*[S, F](self: RangeReverseDualSegmentTree[S,\
    \ F], index: Natural, value: S) =\n        assert index < self.length\n      \
    \  var (left, middleRight) = self.splitRoot(self.root, int(index))\n        var\
    \ (middle, right) = self.splitRoot(middleRight, 1)\n        middle.value = value\n\
    \        middle.lazy = self.id\n        middle.rev = false\n        self.root\
    \ = self.mergeRoot(left, self.mergeRoot(middle, right))\n\n    proc `[]`*[S, F](self:\
    \ RangeReverseDualSegmentTree[S, F], index: int): S =\n        self.get(index)\n\
    \n    proc `[]`*[S, F](self: RangeReverseDualSegmentTree[S, F], index: BackwardsIndex):\
    \ S =\n        self.get(self.length - int(index))\n\n    proc `[]=`*[S, F](self:\
    \ RangeReverseDualSegmentTree[S, F], index: Natural, value: S) =\n        self.update(index,\
    \ value)\n\n    iterator items*[S, F](self: RangeReverseDualSegmentTree[S, F]):\
    \ S =\n        if not self.root.isNil:\n            var stack = @[(0, self.root)]\n\
    \            while stack.len > 0:\n                var (t, node) = stack.pop()\n\
    \                node.push(self.mapping, self.composition, self.id)\n        \
    \        if t == 0:\n                    if not node.right.isNil: stack.add((0,\
    \ node.right))\n                    stack.add((1, node))\n                   \
    \ if not node.left.isNil: stack.add((0, node.left))\n                else:\n \
    \                   yield node.value\n\n    proc toSeq*[S, F](self: RangeReverseDualSegmentTree[S,\
    \ F]): seq[S] =\n        for x in self:\n            result.add(x)\n\n    proc\
    \ `$`*[S, F](self: RangeReverseDualSegmentTree[S, F]): string =\n        var s:\
    \ seq[string]\n        for x in self:\n            s.add($x)\n        return s.join(\"\
    \ \")\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/range_reverse_dualsegtree.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_reverse_dualsegtree_test.nim
  - verify/collections/range_reverse_dualsegtree_test.nim
documentation_of: cplib/collections/range_reverse_dualsegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/range_reverse_dualsegtree.nim
- /library/cplib/collections/range_reverse_dualsegtree.nim.html
title: cplib/collections/range_reverse_dualsegtree.nim
---
