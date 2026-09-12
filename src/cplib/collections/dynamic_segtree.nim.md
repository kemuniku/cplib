---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dynamic_segtree_test.nim
    title: verify/AI/dynamic_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dynamic_segtree_test.nim
    title: verify/AI/dynamic_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/dynamic_segtree_PARS_test.nim
    title: verify/collections/segtree/dynamic_segtree_PARS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/dynamic_segtree_PARS_test.nim
    title: verify/collections/segtree/dynamic_segtree_PARS_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_DYNAMIC_SEGTREE:\n    const CPLIB_COLLECTIONS_DYNAMIC_SEGTREE*\
    \ = 1\n\n    type\n        DynamicSegmentTreeNode[T] = ref object\n          \
    \  index: int\n            value, product: T\n            left, right: DynamicSegmentTreeNode[T]\n\
    \        DynamicSegmentTree*[T] = ref object\n            root: DynamicSegmentTreeNode[T]\n\
    \            length, nodes: int\n            merge: proc(x: T, y: T): T\n    \
    \        default: T\n\n    proc initDynamicSegmentTree*[T](n: int, merge: proc(x:\
    \ T, y: T): T,\n                                   default: T): DynamicSegmentTree[T]\
    \ =\n        ## [0,n)\u3092\u5358\u4F4D\u5143\u3067\u521D\u671F\u5316\u3057\u307E\
    \u3059\u3002O(1)\u6642\u9593\u30FB\u7A7A\u9593\u3002merge\u306B\u306F\u30E2\u30CE\
    \u30A4\u30C9\u306E\u6F14\u7B97\u3092\u6E21\u3057\u307E\u3059\u3002\n        assert\
    \ n >= 0\n        DynamicSegmentTree[T](length: n, merge: merge, default: default)\n\
    \n    proc len*[T](self: DynamicSegmentTree[T]): int =\n        ## \u5EA7\u6A19\
    \u7BC4\u56F2\u306E\u9577\u3055\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n\
    \        self.length\n\n    proc node_count*[T](self: DynamicSegmentTree[T]):\
    \ int =\n        ## \u4E00\u5EA6\u3067\u3082\u66F4\u65B0\u3057\u305F\u7570\u306A\
    \u308B\u5EA7\u6A19\u306E\u6570\uFF08\u78BA\u4FDD\u3057\u305F\u30CE\u30FC\u30C9\
    \u6570\uFF09\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.nodes\n\
    \n    proc product[T](self: DynamicSegmentTree[T], node: DynamicSegmentTreeNode[T]):\
    \ T =\n        ## \u7A7A\u306E\u90E8\u5206\u6728\u3092\u5358\u4F4D\u5143\u3068\
    \u3057\u3066\u3001\u90E8\u5206\u6728\u306E\u96C6\u7D04\u5024\u3092O(1)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        if node == nil: self.default else: node.product\n\
    \n    proc updateNode[T](self: DynamicSegmentTree[T], node: var DynamicSegmentTreeNode[T],\n\
    \                       l, r, index: int, value: T) =\n        ## \u5EA7\u6A19\
    \u9806\u3068\u4E8C\u5206\u533A\u9593\u3092\u4FDD\u3063\u3066\u633F\u5165\u30FB\
    \u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002O(log N)\u6642\u9593\u3001\u8FFD\u52A0\
    \u30CE\u30FC\u30C9\u306F\u9AD8\u30051\u500B\u3002\n        if node == nil:\n \
    \           node = DynamicSegmentTreeNode[T](index: index, value: value, product:\
    \ value)\n            inc self.nodes\n            return\n        if node.index\
    \ == index:\n            node.value = value\n        else:\n            let mid\
    \ = l + (r - l) div 2\n            var index = index\n            var value =\
    \ value\n            if index < mid:\n                if node.index < index:\n\
    \                    swap(node.index, index)\n                    swap(node.value,\
    \ value)\n                self.updateNode(node.left, l, mid, index, value)\n \
    \           else:\n                if index < node.index:\n                  \
    \  swap(node.index, index)\n                    swap(node.value, value)\n    \
    \            self.updateNode(node.right, mid, r, index, value)\n        node.product\
    \ = self.merge(self.merge(self.product(node.left), node.value),\n            \
    \                      self.product(node.right))\n\n    proc update*[T](self:\
    \ DynamicSegmentTree[T], index: Natural, value: T) =\n        ## 1\u70B9\u3092\
    O(log N)\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002Q\u56DE\u66F4\u65B0\u5F8C\
    \u306E\u7A7A\u9593\u306FO(Q)\u3001\u540C\u3058\u5EA7\u6A19\u306E\u518D\u66F4\u65B0\
    \u3067\u306F\u5897\u3048\u307E\u305B\u3093\u3002\n        assert index < self.length\n\
    \        self.updateNode(self.root, 0, self.length, index, value)\n\n    proc\
    \ getNode[T](self: DynamicSegmentTree[T], node: DynamicSegmentTreeNode[T],\n \
    \                   l, r, ql, qr: int): T =\n        ## \u4E8C\u5206\u533A\u9593\
    \u3067\u679D\u5208\u308A\u3057\u3001\u5EA7\u6A19\u9806\u306E\u533A\u9593\u7A4D\
    \u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        if node == nil or\
    \ qr <= l or r <= ql:\n            return self.default\n        if ql <= l and\
    \ r <= qr:\n            return node.product\n        let mid = l + (r - l) div\
    \ 2\n        result = self.getNode(node.left, l, mid, ql, qr)\n        if ql <=\
    \ node.index and node.index < qr:\n            result = self.merge(result, node.value)\n\
    \        result = self.merge(result, self.getNode(node.right, mid, r, ql, qr))\n\
    \n    proc get*[T](self: DynamicSegmentTree[T], q_left, q_right: Natural): T =\n\
    \        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u306E\u7A4D\u3092O(log N)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\u30CE\u30FC\u30C9\u306F\u78BA\u4FDD\u3057\u307E\
    \u305B\u3093\u3002\n        assert q_left <= q_right and q_right <= self.length\n\
    \        if q_left == q_right:\n            return self.default\n        self.getNode(self.root,\
    \ 0, self.length, q_left, q_right)\n\n    proc get*[T](self: DynamicSegmentTree[T],\
    \ segment: HSlice[int, int]): T =\n        ## \u30B9\u30E9\u30A4\u30B9\u3067\u6307\
    \u5B9A\u3057\u305F\u533A\u9593\u306E\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\
    \u3059\u3002\n        assert 0 <= segment.a and segment.b < self.length\n    \
    \    self.get(segment.a, segment.b + 1)\n\n    proc `[]`*[T](self: DynamicSegmentTree[T],\
    \ segment: HSlice[int, int]): T =\n        ## \u30B9\u30E9\u30A4\u30B9\u3067\u6307\
    \u5B9A\u3057\u305F\u533A\u9593\u306E\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\
    \u3059\u3002\n        self.get(segment)\n\n    proc `[]`*[T](self: DynamicSegmentTree[T],\
    \ index: Natural): T =\n        ## 1\u70B9\u306E\u5024\u3092O(log N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\u672A\u66F4\u65B0\u306E\u5EA7\u6A19\u3067\u306F\u5358\
    \u4F4D\u5143\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert index < self.length\n\
    \        var node = self.root\n        while node != nil:\n            if node.index\
    \ == index:\n                return node.value\n            if index < node.index:\n\
    \                node = node.left\n            else:\n                node = node.right\n\
    \        self.default\n\n    proc `[]=`*[T](self: DynamicSegmentTree[T], index:\
    \ Natural, value: T) =\n        ## 1\u70B9\u3092O(log N)\u3067\u4E0A\u66F8\u304D\
    \u3057\u307E\u3059\u3002\n        self.update(index, value)\n\n    proc get_all*[T](self:\
    \ DynamicSegmentTree[T]): T =\n        ## \u5168\u533A\u9593\u306E\u7A4D\u3092\
    O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.product(self.root)\n\n\
    \    template newDynamicSegWith*(n, merge, default: untyped): untyped =\n    \
    \    ## l\u3068r\u3092\u4F7F\u3063\u305F\u5F0F\u3092\u6F14\u7B97\u3068\u3057\u3066\
    \u3001\u52D5\u7684\u30BB\u30B0\u30E1\u30F3\u30C8\u6728\u3092O(1)\u3067\u751F\u6210\
    \u3057\u307E\u3059\u3002\n        initDynamicSegmentTree[typeof(default)](n,\n\
    \            proc(l {.inject.}, r {.inject.}: typeof(default)): typeof(default)\
    \ = merge,\n            default)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/dynamic_segtree.nim
  requiredBy: []
  timestamp: '2026-09-12 20:28:08+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/segtree/dynamic_segtree_PARS_test.nim
  - verify/collections/segtree/dynamic_segtree_PARS_test.nim
  - verify/AI/dynamic_segtree_test.nim
  - verify/AI/dynamic_segtree_test.nim
documentation_of: cplib/collections/dynamic_segtree.nim
layout: document
redirect_from:
- /library/cplib/collections/dynamic_segtree.nim
- /library/cplib/collections/dynamic_segtree.nim.html
title: cplib/collections/dynamic_segtree.nim
---
