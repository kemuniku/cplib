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
    \u7A4D\u306F\u3059\u3079\u3066\u671F\u5F85O(log N)\u3067\u3059\u3002\n       \
    \ RangeReverseArrayMonoid[T](root: build(v, op, e), length: v.len, op: op, e:\
    \ e)\n\n    proc toRangeReverseArrayMonoid*[T](v: openArray[T], op: proc(x, y:\
    \ T): T, e: T): RangeReverseArrayMonoid[T] =\n        initRangeReverseArrayMonoid(v,\
    \ op, e)\n\n    template newRangeReverseArrayMonoidWith*(V, op, e: untyped): untyped\
    \ =\n        initRangeReverseArrayMonoid[typeof(e)](V, proc (l{.inject.}, r{.inject.}:\
    \ typeof(e)): typeof(e) = op, e)\n\n    proc len*[T](self: RangeReverseArrayMonoid[T]):\
    \ int =\n        self.length\n\n    proc insertNode[T](self: RangeReverseArrayMonoid[T],\
    \ root, node: RangeReverseArrayMonoidNode[T], k: int): RangeReverseArrayMonoidNode[T]\
    \ =\n        if root.isNil: return node\n        if node.priority > root.priority:\n\
    \            (node.left, node.right) = split(root, k, self.op, self.e)\n     \
    \       node.update(self.op, self.e)\n            return node\n        root.push\n\
    \        let leftSize = root.left.nodeLen\n        if k <= leftSize:\n       \
    \     root.left = self.insertNode(root.left, node, k)\n        else:\n       \
    \     root.right = self.insertNode(root.right, node, k - leftSize - 1)\n     \
    \   root.update(self.op, self.e)\n        return root\n\n    proc insert*[T](self:\
    \ RangeReverseArrayMonoid[T], index: int, value: T) =\n        ## index \u306E\
    \u76F4\u524D\u306B\u633F\u5165\u3059\u308B\u3002index = len \u306A\u3089\u672B\
    \u5C3E\u3002\n        assert 0 <= index and index <= self.len\n        let node\
    \ = newNode(value, rand(uint64))\n        self.root = self.insertNode(self.root,\
    \ node, index)\n        inc self.length\n\n    proc eraseNode[T](self: RangeReverseArrayMonoid[T],\
    \ node: RangeReverseArrayMonoidNode[T], k: int): RangeReverseArrayMonoidNode[T]\
    \ =\n        node.push\n        let leftSize = node.left.nodeLen\n        if k\
    \ == leftSize: return merge(node.left, node.right, self.op, self.e)\n        if\
    \ k < leftSize:\n            node.left = self.eraseNode(node.left, k)\n      \
    \  else:\n            node.right = self.eraseNode(node.right, k - leftSize - 1)\n\
    \        node.update(self.op, self.e)\n        return node\n\n    proc erase*[T](self:\
    \ RangeReverseArrayMonoid[T], index: int) =\n        assert 0 <= index and index\
    \ < self.len\n        self.root = self.eraseNode(self.root, index)\n        dec\
    \ self.length\n\n    proc erase*[T](self: RangeReverseArrayMonoid[T], l, r: int)\
    \ =\n        assert 0 <= l and l <= r and r <= self.len\n        if l == r: return\n\
    \        let (left, rest) = split(self.root, l, self.op, self.e)\n        let\
    \ (_, right) = split(rest, r - l, self.op, self.e)\n        self.root = merge(left,\
    \ right, self.op, self.e)\n        self.length -= r - l\n\n    proc erase*[T](self:\
    \ RangeReverseArrayMonoid[T], segment: HSlice[int, int]) =\n        self.erase(segment.a,\
    \ segment.b + 1)\n\n    proc reverse*[T](self: RangeReverseArrayMonoid[T], l,\
    \ r: int) =\n        ## \u534A\u958B\u533A\u9593[l, r)\u3092\u53CD\u8EE2\u3057\
    \u307E\u3059\u3002\n        assert 0 <= l and l <= r and r <= self.length\n  \
    \      var (left, middleRight) = split(self.root, l, self.op, self.e)\n      \
    \  var (middle, right) = split(middleRight, r - l, self.op, self.e)\n        middle.toggle\n\
    \        self.root = merge(left, merge(middle, right, self.op, self.e), self.op,\
    \ self.e)\n\n    proc reverse*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int,\
    \ int]) =\n        ## \u9589\u533A\u9593segment\u3092\u53CD\u8EE2\u3057\u307E\u3059\
    \u3002\n        self.reverse(segment.a, segment.b + 1)\n\n    proc get*[T](self:\
    \ RangeReverseArrayMonoid[T], index: int): T =\n        ## index\u756A\u76EE\u306E\
    \u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert 0 <= index and index\
    \ < self.length\n        var node = self.root\n        var k = index\n       \
    \ while true:\n            node.push\n            let leftSize = node.left.nodeLen\n\
    \            if k < leftSize:\n                node = node.left\n            elif\
    \ k == leftSize:\n                return node.value\n            else:\n     \
    \           k -= leftSize + 1\n                node = node.right\n\n    proc getNode[T](self:\
    \ RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T], l, r: int):\
    \ T =\n        if l == 0 and r == node.size: return node.prod\n        node.push\n\
    \        let mid = node.left.nodeLen\n        if r <= mid: return self.getNode(node.left,\
    \ l, r)\n        if l > mid: return self.getNode(node.right, l - mid - 1, r -\
    \ mid - 1)\n        result = node.value\n        if l < mid: result = self.op(self.getNode(node.left,\
    \ l, mid), result)\n        if r > mid + 1: result = self.op(result, self.getNode(node.right,\
    \ 0, r - mid - 1))\n\n    proc get*[T](self: RangeReverseArrayMonoid[T], l, r:\
    \ int): T =\n        ## \u534A\u958B\u533A\u9593 [l, r) \u306E\u7DCF\u7A4D\u3092\
    \u8FD4\u3059\u3002\n        assert 0 <= l and l <= r and r <= self.len\n     \
    \   if l == r: return self.e\n        self.getNode(self.root, l, r)\n\n    proc\
    \ get*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]): T =\n\
    \        ## \u9589\u533A\u9593segment\u306E\u7DCF\u7A4D\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        assert segment.a <= segment.b + 1 and 0 <= segment.a and\
    \ segment.b + 1 <= self.length\n        self.get(segment.a, segment.b + 1)\n\n\
    \    proc fold*[T](self: RangeReverseArrayMonoid[T], l, r: int): T =\n       \
    \ self.get(l, r)\n\n    proc fold*[T](self: RangeReverseArrayMonoid[T], segment:\
    \ HSlice[int, int]): T =\n        self.get(segment)\n\n    proc fold*[T](self:\
    \ RangeReverseArrayMonoid[T]): T =\n        self.root.nodeProd(self.e)\n\n   \
    \ proc get_all*[T](self: RangeReverseArrayMonoid[T]): T =\n        ## [0,len(self))\u533A\
    \u9593\u306E\u7DCF\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n     \
    \   self.root.nodeProd(self.e)\n\n    proc updateNode[T](self: RangeReverseArrayMonoid[T],\
    \ node: RangeReverseArrayMonoidNode[T], k: int, value: T) =\n        node.push\n\
    \        let leftSize = node.left.nodeLen\n        if k == leftSize:\n       \
    \     node.value = value\n        elif k < leftSize:\n            self.updateNode(node.left,\
    \ k, value)\n        else:\n            self.updateNode(node.right, k - leftSize\
    \ - 1, value)\n        node.update(self.op, self.e)\n\n    proc update*[T](self:\
    \ RangeReverseArrayMonoid[T], index: Natural, value: T) =\n        ## index \u756A\
    \u76EE\u306E\u5024\u3092 value \u306B\u5909\u66F4\u3059\u308B\u3002\n        assert\
    \ index < self.len\n        self.updateNode(self.root, index, value)\n\n    proc\
    \ searchRight[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T],\
    \ start, l: int, acc: var T, f: proc(x: T): bool): int =\n        let finish =\
    \ start + node.nodeLen\n        if node.isNil or finish <= l: return finish\n\
    \        if l <= start:\n            let next = self.op(acc, node.prod)\n    \
    \        if f(next):\n                acc = next\n                return finish\n\
    \        node.push\n        let mid = start + node.left.nodeLen\n        result\
    \ = self.searchRight(node.left, start, l, acc, f)\n        if result < mid: return\n\
    \        if l <= mid:\n            let next = self.op(acc, node.value)\n     \
    \       if not f(next): return mid\n            acc = next\n        result = self.searchRight(node.right,\
    \ mid + 1, l, acc, f)\n\n    proc max_right*[T](self: RangeReverseArrayMonoid[T],\
    \ l: int, f: proc(x: T): bool): int =\n        ## f(get(l, r)) \u304C\u771F\u3068\
    \u306A\u308B\u6700\u5927\u306E r \u3092\u8FD4\u3059\u3002\n        ## f(e) = true\
    \ \u3067\u3001\u533A\u9593\u3092\u4F38\u3070\u3057\u305F\u3068\u304D\u771F\u304B\
    \u3089\u507D\u3078\u306E\u5909\u5316\u304C\u5358\u8ABF\u3067\u3042\u308B\u3053\
    \u3068\u3002\n        assert 0 <= l and l <= self.len\n        assert f(self.e)\n\
    \        var acc = self.e\n        self.searchRight(self.root, 0, l, acc, f)\n\
    \n    proc searchLeft[T](self: RangeReverseArrayMonoid[T], node: RangeReverseArrayMonoidNode[T],\
    \ start, r: int, acc: var T, f: proc(x: T): bool): int =\n        if node.isNil\
    \ or r <= start: return start\n        if start + node.size <= r:\n          \
    \  let next = self.op(node.prod, acc)\n            if f(next):\n             \
    \   acc = next\n                return start\n        node.push\n        let mid\
    \ = start + node.left.nodeLen\n        result = self.searchLeft(node.right, mid\
    \ + 1, r, acc, f)\n        if result > mid + 1: return\n        if mid < r:\n\
    \            let next = self.op(node.value, acc)\n            if not f(next):\
    \ return mid + 1\n            acc = next\n        result = self.searchLeft(node.left,\
    \ start, r, acc, f)\n\n    proc min_left*[T](self: RangeReverseArrayMonoid[T],\
    \ r: int, f: proc(x: T): bool): int =\n        ## f(get(l, r)) \u304C\u771F\u3068\
    \u306A\u308B\u6700\u5C0F\u306E l \u3092\u8FD4\u3059\u3002\n        ## f(e) = true\
    \ \u3067\u3001\u533A\u9593\u3092\u4F38\u3070\u3057\u305F\u3068\u304D\u771F\u304B\
    \u3089\u507D\u3078\u306E\u5909\u5316\u304C\u5358\u8ABF\u3067\u3042\u308B\u3053\
    \u3068\u3002\n        assert 0 <= r and r <= self.len\n        assert f(self.e)\n\
    \        var acc = self.e\n        self.searchLeft(self.root, 0, r, acc, f)\n\n\
    \    proc `[]`*[T](self: RangeReverseArrayMonoid[T], index: int): T =\n      \
    \  self.get(index)\n\n    proc `[]`*[T](self: RangeReverseArrayMonoid[T], index:\
    \ BackwardsIndex): T =\n        self.get(self.length - int(index))\n\n    proc\
    \ `[]`*[T](self: RangeReverseArrayMonoid[T], segment: HSlice[int, int]): T =\n\
    \        self.get(segment)\n\n    proc `[]=`*[T](self: RangeReverseArrayMonoid[T],\
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
  timestamp: '2026-09-06 11:23:37+09:00'
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
