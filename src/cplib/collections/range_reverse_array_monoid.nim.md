---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_array_monoid_test.nim
    title: verify/collections/range_reverse_array_monoid_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_array_monoid_test.nim
    title: verify/collections/range_reverse_array_monoid_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY_MONOID:\n    const\
    \ CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY_MONOID* = 1\n    import random, strutils\n\
    \n    randomize()\n\n    type RangeReverseArrayMonoidNode[T] {.acyclic.} = ref\
    \ object\n        left, right: RangeReverseArrayMonoidNode[T]\n        priority:\
    \ uint64\n        size: int\n        rev: bool\n        value, prod, rprod: T\n\
    \n    type RangeReverseArrayMonoid*[T] = ref object\n        root: RangeReverseArrayMonoidNode[T]\n\
    \        length: int\n        op: proc(x, y: T): T\n        e: T\n\n    proc nodeLen[T](node:\
    \ RangeReverseArrayMonoidNode[T]): int {.inline.} =\n        if node.isNil: 0\
    \ else: node.size\n\n    proc nodeProd[T](node: RangeReverseArrayMonoidNode[T],\
    \ e: T): T {.inline.} =\n        if node.isNil: e else: node.prod\n\n    proc\
    \ nodeRProd[T](node: RangeReverseArrayMonoidNode[T], e: T): T {.inline.} =\n \
    \       if node.isNil: e else: node.rprod\n\n    proc update[T](node: RangeReverseArrayMonoidNode[T],\
    \ op: proc(x, y: T): T, e: T) =\n        if node.isNil: return\n        node.size\
    \ = 1 + node.left.nodeLen + node.right.nodeLen\n        node.prod = op(op(node.left.nodeProd(e),\
    \ node.value), node.right.nodeProd(e))\n        node.rprod = op(op(node.right.nodeRProd(e),\
    \ node.value), node.left.nodeRProd(e))\n\n    proc toggle[T](node: RangeReverseArrayMonoidNode[T])\
    \ =\n        if not node.isNil:\n            node.rev = not node.rev\n       \
    \     let tmp = node.prod\n            node.prod = node.rprod\n            node.rprod\
    \ = tmp\n\n    proc push[T](node: RangeReverseArrayMonoidNode[T]) =\n        if\
    \ node.isNil or not node.rev: return\n        let tmp = node.left\n        node.left\
    \ = node.right\n        node.right = tmp\n        node.left.toggle\n        node.right.toggle\n\
    \        node.rev = false\n\n    proc newNode[T](value: T, priority: uint64):\
    \ RangeReverseArrayMonoidNode[T] =\n        RangeReverseArrayMonoidNode[T](priority:\
    \ priority, size: 1, value: value, prod: value, rprod: value)\n\n    proc updateAll[T](node:\
    \ RangeReverseArrayMonoidNode[T], op: proc(x, y: T): T, e: T) =\n        if node.isNil:\
    \ return\n        node.left.updateAll(op, e)\n        node.right.updateAll(op,\
    \ e)\n        node.update(op, e)\n\n    proc build[T](v: openArray[T], op: proc(x,\
    \ y: T): T, e: T): RangeReverseArrayMonoidNode[T] =\n        var stack: seq[RangeReverseArrayMonoidNode[T]]\n\
    \        for i in 0..<v.len:\n            let node = newNode(v[i], rand(uint64))\n\
    \            var last: RangeReverseArrayMonoidNode[T] = nil\n            while\
    \ stack.len > 0 and stack[^1].priority < node.priority:\n                last\
    \ = stack.pop()\n            node.left = last\n            if stack.len > 0:\n\
    \                stack[^1].right = node\n            stack.add(node)\n       \
    \ if stack.len == 0:\n            return nil\n        result = stack[0]\n    \
    \    result.updateAll(op, e)\n\n    proc merge[T](left, right: RangeReverseArrayMonoidNode[T],\
    \ op: proc(x, y: T): T, e: T): RangeReverseArrayMonoidNode[T] =\n        if left.isNil:\
    \ return right\n        if right.isNil: return left\n        if left.priority\
    \ > right.priority:\n            left.push\n            left.right = merge(left.right,\
    \ right, op, e)\n            left.update(op, e)\n            return left\n   \
    \     else:\n            right.push\n            right.left = merge(left, right.left,\
    \ op, e)\n            right.update(op, e)\n            return right\n\n    proc\
    \ split[T](node: RangeReverseArrayMonoidNode[T], k: int, op: proc(x, y: T): T,\
    \ e: T): (RangeReverseArrayMonoidNode[T], RangeReverseArrayMonoidNode[T]) =\n\
    \        if node.isNil:\n            return (nil, nil)\n        node.push\n  \
    \      let leftSize = node.left.nodeLen\n        if k <= leftSize:\n         \
    \   var (left, right) = split(node.left, k, op, e)\n            node.left = right\n\
    \            node.update(op, e)\n            return (left, node)\n        else:\n\
    \            var (left, right) = split(node.right, k - leftSize - 1, op, e)\n\
    \            node.right = left\n            node.update(op, e)\n            return\
    \ (node, right)\n\n    proc initRangeReverseArrayMonoid*[T](v: openArray[T], op:\
    \ proc(x, y: T): T, e: T): RangeReverseArrayMonoid[T] =\n        ## v\u3067\u521D\
    \u671F\u5316\u3057\u307E\u3059\u3002\n        ## \u533A\u9593\u53CD\u8EE2\u3001\
    \u4E00\u70B9\u53D6\u5F97\u3001\u4E00\u70B9\u66F4\u65B0\u3001\u533A\u9593\u7DCF\
    \u7A4D\u306F\u3059\u3079\u3066O(log N)\u3067\u3059\u3002\n        RangeReverseArrayMonoid[T](root:\
    \ build(v, op, e), length: v.len, op: op, e: e)\n\n    proc toRangeReverseArrayMonoid*[T](v:\
    \ openArray[T], op: proc(x, y: T): T, e: T): RangeReverseArrayMonoid[T] =\n  \
    \      initRangeReverseArrayMonoid(v, op, e)\n\n    template newRangeReverseArrayMonoidWith*(V,\
    \ op, e: untyped): untyped =\n        initRangeReverseArrayMonoid[typeof(e)](V,\
    \ proc (l{.inject.}, r{.inject.}: typeof(e)): typeof(e) = op, e)\n\n    proc len*[T](self:\
    \ RangeReverseArrayMonoid[T]): int =\n        self.length\n\n    proc reverse*[T](self:\
    \ RangeReverseArrayMonoid[T], l, r: int) =\n        ## \u534A\u958B\u533A\u9593\
    [l, r)\u3092\u53CD\u8EE2\u3057\u307E\u3059\u3002\n        assert 0 <= l and l\
    \ <= r and r <= self.length\n        var (left, middleRight) = split(self.root,\
    \ l, self.op, self.e)\n        var (middle, right) = split(middleRight, r - l,\
    \ self.op, self.e)\n        middle.toggle\n        self.root = merge(left, merge(middle,\
    \ right, self.op, self.e), self.op, self.e)\n\n    proc reverse*[T](self: RangeReverseArrayMonoid[T],\
    \ segment: HSlice[int, int]) =\n        ## \u9589\u533A\u9593segment\u3092\u53CD\
    \u8EE2\u3057\u307E\u3059\u3002\n        self.reverse(segment.a, segment.b + 1)\n\
    \n    proc get*[T](self: RangeReverseArrayMonoid[T], index: int): T =\n      \
    \  ## index\u756A\u76EE\u306E\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n    \
    \    assert 0 <= index and index < self.length\n        var node = self.root\n\
    \        var k = index\n        while true:\n            node.push\n         \
    \   let leftSize = node.left.nodeLen\n            if k < leftSize:\n         \
    \       node = node.left\n            elif k == leftSize:\n                return\
    \ node.value\n            else:\n                k -= leftSize + 1\n         \
    \       node = node.right\n\n    proc get*[T](self: RangeReverseArrayMonoid[T],\
    \ l, r: int): T =\n        ## \u534A\u958B\u533A\u9593[l, r)\u306E\u7DCF\u7A4D\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert 0 <= l and l <= r and r <=\
    \ self.length\n        var (left, middleRight) = split(self.root, l, self.op,\
    \ self.e)\n        var (middle, right) = split(middleRight, r - l, self.op, self.e)\n\
    \        result = middle.nodeProd(self.e)\n        self.root = merge(left, merge(middle,\
    \ right, self.op, self.e), self.op, self.e)\n\n    proc get*[T](self: RangeReverseArrayMonoid[T],\
    \ segment: HSlice[int, int]): T =\n        ## \u9589\u533A\u9593segment\u306E\u7DCF\
    \u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert segment.a <= segment.b\
    \ + 1 and 0 <= segment.a and segment.b + 1 <= self.length\n        self.get(segment.a,\
    \ segment.b + 1)\n\n    proc fold*[T](self: RangeReverseArrayMonoid[T], l, r:\
    \ int): T =\n        self.get(l, r)\n\n    proc fold*[T](self: RangeReverseArrayMonoid[T],\
    \ segment: HSlice[int, int]): T =\n        self.get(segment)\n\n    proc fold*[T](self:\
    \ RangeReverseArrayMonoid[T]): T =\n        self.root.nodeProd(self.e)\n\n   \
    \ proc get_all*[T](self: RangeReverseArrayMonoid[T]): T =\n        ## [0,len(self))\u533A\
    \u9593\u306E\u7DCF\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n     \
    \   self.root.nodeProd(self.e)\n\n    proc update*[T](self: RangeReverseArrayMonoid[T],\
    \ index: Natural, value: T) =\n        ## index\u756A\u76EE\u306E\u5024\u3092\
    value\u306B\u5909\u66F4\u3057\u307E\u3059\u3002\n        assert index < self.length\n\
    \        var (left, middleRight) = split(self.root, int(index), self.op, self.e)\n\
    \        var (middle, right) = split(middleRight, 1, self.op, self.e)\n      \
    \  middle.value = value\n        middle.prod = value\n        middle.rprod = value\n\
    \        middle.update(self.op, self.e)\n        self.root = merge(left, merge(middle,\
    \ right, self.op, self.e), self.op, self.e)\n\n    proc `[]`*[T](self: RangeReverseArrayMonoid[T],\
    \ index: int): T =\n        self.get(index)\n\n    proc `[]`*[T](self: RangeReverseArrayMonoid[T],\
    \ index: BackwardsIndex): T =\n        self.get(self.length - int(index))\n\n\
    \    proc `[]`*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]):\
    \ T =\n        self.get(segment)\n\n    proc `[]=`*[T](self: RangeReverseArrayMonoid[T],\
    \ index: Natural, value: T) =\n        self.update(index, value)\n\n    iterator\
    \ items*[T](self: RangeReverseArrayMonoid[T]): T =\n        if not self.root.isNil:\n\
    \            var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                var (t, node) = stack.pop()\n                node.push\n    \
    \            if t == 0:\n                    if not node.right.isNil: stack.add((0,\
    \ node.right))\n                    stack.add((1, node))\n                   \
    \ if not node.left.isNil: stack.add((0, node.left))\n                else:\n \
    \                   yield node.value\n\n    proc toSeq*[T](self: RangeReverseArrayMonoid[T]):\
    \ seq[T] =\n        for x in self:\n            result.add(x)\n\n    proc `$`*[T](self:\
    \ RangeReverseArrayMonoid[T]): string =\n        var s: seq[string]\n        for\
    \ x in self:\n            s.add($x)\n        return s.join(\" \")\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/range_reverse_array_monoid.nim
  requiredBy: []
  timestamp: '2026-07-06 18:53:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_reverse_array_monoid_test.nim
  - verify/collections/range_reverse_array_monoid_test.nim
documentation_of: cplib/collections/range_reverse_array_monoid.nim
layout: document
redirect_from:
- /library/cplib/collections/range_reverse_array_monoid.nim
- /library/cplib/collections/range_reverse_array_monoid.nim.html
title: cplib/collections/range_reverse_array_monoid.nim
---
