---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_array_test.nim
    title: verify/collections/range_reverse_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/range_reverse_array_test.nim
    title: verify/collections/range_reverse_array_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY:\n    const CPLIB_COLLECTIONS_RANGE_REVERSE_ARRAY*\
    \ = 1\n    import random, strutils\n\n    randomize()\n\n    type RangeReverseArrayNode[T]\
    \ {.acyclic.} = ref object\n        left, right: RangeReverseArrayNode[T]\n  \
    \      priority: uint64\n        size: int\n        rev: bool\n        value:\
    \ T\n\n    type RangeReverseArray*[T] = ref object\n        root: RangeReverseArrayNode[T]\n\
    \        length: int\n\n    proc nodeLen[T](node: RangeReverseArrayNode[T]): int\
    \ {.inline.} =\n        if node.isNil: 0 else: node.size\n\n    proc update[T](node:\
    \ RangeReverseArrayNode[T]) =\n        node.size = 1 + node.left.nodeLen + node.right.nodeLen\n\
    \n    proc toggle[T](node: RangeReverseArrayNode[T]) =\n        if not node.isNil:\n\
    \            node.rev = not node.rev\n\n    proc push[T](node: RangeReverseArrayNode[T])\
    \ =\n        if node.isNil or not node.rev: return\n        let tmp = node.left\n\
    \        node.left = node.right\n        node.right = tmp\n        node.left.toggle\n\
    \        node.right.toggle\n        node.rev = false\n\n    proc newNode[T](value:\
    \ T, priority: uint64): RangeReverseArrayNode[T] =\n        RangeReverseArrayNode[T](priority:\
    \ priority, size: 1, value: value)\n\n    proc updateAll[T](node: RangeReverseArrayNode[T])\
    \ =\n        if node.isNil: return\n        node.left.updateAll\n        node.right.updateAll\n\
    \        node.update\n\n    proc build[T](v: openArray[T]): RangeReverseArrayNode[T]\
    \ =\n        var stack: seq[RangeReverseArrayNode[T]]\n        for i in 0..<v.len:\n\
    \            let node = newNode(v[i], rand(uint64))\n            var last: RangeReverseArrayNode[T]\
    \ = nil\n            while stack.len > 0 and stack[^1].priority < node.priority:\n\
    \                last = stack.pop()\n            node.left = last\n          \
    \  if stack.len > 0:\n                stack[^1].right = node\n            stack.add(node)\n\
    \        if stack.len == 0:\n            return nil\n        result = stack[0]\n\
    \        result.updateAll\n\n    proc merge[T](left, right: RangeReverseArrayNode[T]):\
    \ RangeReverseArrayNode[T] =\n        if left.isNil: return right\n        if\
    \ right.isNil: return left\n        if left.priority > right.priority:\n     \
    \       left.push\n            left.right = merge(left.right, right)\n       \
    \     left.update\n            return left\n        else:\n            right.push\n\
    \            right.left = merge(left, right.left)\n            right.update\n\
    \            return right\n\n    proc split[T](node: RangeReverseArrayNode[T],\
    \ k: int): (RangeReverseArrayNode[T], RangeReverseArrayNode[T]) =\n        if\
    \ node.isNil:\n            return (nil, nil)\n        node.push\n        let leftSize\
    \ = node.left.nodeLen\n        if k <= leftSize:\n            var (left, right)\
    \ = split(node.left, k)\n            node.left = right\n            node.update\n\
    \            return (left, node)\n        else:\n            var (left, right)\
    \ = split(node.right, k - leftSize - 1)\n            node.right = left\n     \
    \       node.update\n            return (node, right)\n\n    proc initRangeReverseArray*[T](v:\
    \ openArray[T]): RangeReverseArray[T] =\n        ## v\u3067\u521D\u671F\u5316\u3057\
    \u307E\u3059\u3002\n        ## \u533A\u9593\u53CD\u8EE2\u3001\u4E00\u70B9\u53D6\
    \u5F97\u3001\u4E00\u70B9\u66F4\u65B0\u306F\u3059\u3079\u3066O(log N)\u3067\u3059\
    \u3002\n        RangeReverseArray[T](root: build(v), length: v.len)\n\n    proc\
    \ toRangeReverseArray*[T](v: openArray[T]): RangeReverseArray[T] =\n        initRangeReverseArray(v)\n\
    \n    proc len*[T](self: RangeReverseArray[T]): int =\n        self.length\n\n\
    \    proc split*[T](self: RangeReverseArray[T], k: int): (RangeReverseArray[T],\
    \ RangeReverseArray[T]) =\n        ## \u5148\u982D k \u8981\u7D20\u3067\u5206\u5272\
    \u3057\u3001\u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002\u671F\
    \u5F85 O(log N)\u3002\n        assert 0 <= k and k <= self.length, \"0 <= k <=\
    \ len \u304C\u5FC5\u8981\u3067\u3059\"\n        let n = self.length\n        var\
    \ root = move(self.root)\n        let (leftRoot, rightRoot) = split(root, k)\n\
    \        self.length = 0\n        result = (RangeReverseArray[T](root: leftRoot,\
    \ length: k), RangeReverseArray[T](root: rightRoot, length: n - k))\n\n    proc\
    \ merge*[T](left, right: RangeReverseArray[T]): RangeReverseArray[T] =\n     \
    \   ## \u5DE6\u53F3\u306E\u5217\u3092\u9023\u7D50\u3057\u3001\u4E21\u65B9\u306E\
    \u5143\u306E\u5217\u3092\u7A7A\u306B\u3057\u307E\u3059\u3002\u671F\u5F85 O(log\
    \ N)\u3002\n        assert left != right, \"\u540C\u3058\u5217\u3092\u9023\u7D50\
    \u3067\u304D\u307E\u305B\u3093\"\n        let n = left.length + right.length\n\
    \        var leftRoot = move(left.root)\n        var rightRoot = move(right.root)\n\
    \        result = RangeReverseArray[T](root: merge(leftRoot, rightRoot), length:\
    \ n)\n        left.length = 0\n        right.length = 0\n\n    proc insert*[T](self:\
    \ RangeReverseArray[T], index: int, value: T) =\n        ## index \u306E\u76F4\
    \u524D\u306B\u633F\u5165\u3057\u307E\u3059\u3002\u672B\u5C3E\u306B\u306F len \u3092\
    \u6307\u5B9A\u3057\u307E\u3059\u3002\u671F\u5F85 O(log N)\u3002\n        assert\
    \ 0 <= index and index <= self.length, \"0 <= index <= len \u304C\u5FC5\u8981\u3067\
    \u3059\"\n        let (left, right) = split(self.root, index)\n        self.root\
    \ = merge(left, merge(newNode(value, rand(uint64)), right))\n        inc self.length\n\
    \n    proc insort*[T](self: RangeReverseArray[T], value: T, less: proc(x, y: T):\
    \ bool): int {.discardable.} =\n        ## \u30BD\u30FC\u30C8\u6E08\u307F\u306E\
    \u5217\u3078\u540C\u5024\u306E\u672B\u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\
    \u633F\u5165\u3057\u3001\u305D\u306E\u4F4D\u7F6E\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\u671F\u5F85 O(log N)\u3002\n        var node = self.root\n        while\
    \ not node.isNil:\n            node.push\n            if less(value, node.value):\n\
    \                node = node.left\n            else:\n                result +=\
    \ node.left.nodeLen + 1\n                node = node.right\n        self.insert(result,\
    \ value)\n\n    proc insort*[T](self: RangeReverseArray[T], value: T): int {.discardable.}\
    \ =\n        ## < \u3067\u30BD\u30FC\u30C8\u6E08\u307F\u306E\u5217\u3078\u540C\
    \u5024\u306E\u672B\u5C3E\u3068\u306A\u308B\u4F4D\u7F6E\u306B\u633F\u5165\u3057\
    \u307E\u3059\u3002\u671F\u5F85 O(log N)\u3002\n        self.insort(value, proc(x,\
    \ y: T): bool = x < y)\n\n    proc reverse*[T](self: RangeReverseArray[T], l,\
    \ r: int) =\n        ## \u534A\u958B\u533A\u9593[l, r)\u3092\u53CD\u8EE2\u3057\
    \u307E\u3059\u3002\n        assert 0 <= l and l <= r and r <= self.length, \"\u6307\
    \u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and\
    \ r <= self.length\"\n        var (left, middleRight) = split(self.root, l)\n\
    \        var (middle, right) = split(middleRight, r - l)\n        middle.toggle\n\
    \        self.root = merge(left, merge(middle, right))\n\n    proc reverse*[T](self:\
    \ RangeReverseArray[T], segment: HSlice[int, int]) =\n        ## \u9589\u533A\u9593\
    segment\u3092\u53CD\u8EE2\u3057\u307E\u3059\u3002\n        self.reverse(segment.a,\
    \ segment.b + 1)\n\n    proc get*[T](self: RangeReverseArray[T], index: int):\
    \ T =\n        ## index\u756A\u76EE\u306E\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        assert 0 <= index and index < self.length, \"\u6307\u5B9A\u3057\u305F\
    \u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\
    \u304C\u3042\u308A\u307E\u3059: 0 <= index and index < self.length\"\n       \
    \ var node = self.root\n        var k = index\n        while true:\n         \
    \   node.push\n            let leftSize = node.left.nodeLen\n            if k\
    \ < leftSize:\n                node = node.left\n            elif k == leftSize:\n\
    \                return node.value\n            else:\n                k -= leftSize\
    \ + 1\n                node = node.right\n\n    proc update*[T](self: RangeReverseArray[T],\
    \ index: int, value: T) =\n        ## index\u756A\u76EE\u306E\u5024\u3092value\u306B\
    \u5909\u66F4\u3057\u307E\u3059\u3002\n        assert 0 <= index and index < self.length,\
    \ \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\
    \u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= index and index <\
    \ self.length\"\n        var node = self.root\n        var k = index\n       \
    \ while true:\n            node.push\n            let leftSize = node.left.nodeLen\n\
    \            if k < leftSize:\n                node = node.left\n            elif\
    \ k == leftSize:\n                node.value = value\n                return\n\
    \            else:\n                k -= leftSize + 1\n                node =\
    \ node.right\n\n    proc `[]`*[T](self: RangeReverseArray[T], index: int): T =\n\
    \        self.get(index)\n\n    proc `[]`*[T](self: RangeReverseArray[T], index:\
    \ BackwardsIndex): T =\n        self.get(self.length - int(index))\n\n    proc\
    \ `[]=`*[T](self: RangeReverseArray[T], index: int, value: T) =\n        self.update(index,\
    \ value)\n\n    proc `[]=`*[T](self: RangeReverseArray[T], index: BackwardsIndex,\
    \ value: T) =\n        self.update(self.length - int(index), value)\n\n    iterator\
    \ items*[T](self: RangeReverseArray[T]): T =\n        if not self.root.isNil:\n\
    \            var stack = @[(0, self.root)]\n            while stack.len > 0:\n\
    \                var (t, node) = stack.pop()\n                node.push\n    \
    \            if t == 0:\n                    if not node.right.isNil: stack.add((0,\
    \ node.right))\n                    stack.add((1, node))\n                   \
    \ if not node.left.isNil: stack.add((0, node.left))\n                else:\n \
    \                   yield node.value\n\n    proc toSeq*[T](self: RangeReverseArray[T]):\
    \ seq[T] =\n        for x in self:\n            result.add(x)\n\n    proc `$`*[T](self:\
    \ RangeReverseArray[T]): string =\n        var s: seq[string]\n        for x in\
    \ self:\n            s.add($x)\n        return s.join(\" \")\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/range_reverse_array.nim
  requiredBy: []
  timestamp: '2026-10-15 20:53:59+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/range_reverse_array_test.nim
  - verify/collections/range_reverse_array_test.nim
documentation_of: cplib/collections/range_reverse_array.nim
layout: document
redirect_from:
- /library/cplib/collections/range_reverse_array.nim
- /library/cplib/collections/range_reverse_array.nim.html
title: cplib/collections/range_reverse_array.nim
---
