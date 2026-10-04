---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/directed_mst.nim
    title: cplib/graph/directed_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/directed_mst.nim
    title: cplib/graph/directed_mst.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/directed_mst_test.nim
    title: verify/AI/directed_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/directed_mst_test.nim
    title: verify/AI/directed_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lazy_leftist_heap_int128_test.nim
    title: verify/AI/lazy_leftist_heap_int128_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lazy_leftist_heap_int128_test.nim
    title: verify/AI/lazy_leftist_heap_int128_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lazy_leftist_heap_test.nim
    title: verify/AI/lazy_leftist_heap_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/lazy_leftist_heap_test.nim
    title: verify/AI/lazy_leftist_heap_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/directed_mst_test.nim
    title: verify/graph/directed_mst_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/directed_mst_test.nim
    title: verify/graph/directed_mst_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_LAZY_LEFTIST_HEAP:\n    const CPLIB_COLLECTIONS_LAZY_LEFTIST_HEAP*\
    \ = 1\n\n    type LazyLeftistHeapNode[K, V] = object\n        key, lazy: K\n \
    \       left, right, rank: int\n        value: V\n\n    type LazyLeftistHeapPool*[K,\
    \ V] = object\n        nodes: seq[LazyLeftistHeapNode[K, V]]\n        zero: K\n\
    \n    proc initLazyLeftistHeapPool*[K, V](capacity: int = 0, zero: K = default(K)):\
    \ LazyLeftistHeapPool[K, V] {.inline.} =\n        ## \u8907\u6570\u306E\u6700\u5C0F\
    \u30D2\u30FC\u30D7\u3092\u4FDD\u6301\u3059\u308B\u30D7\u30FC\u30EB\u3092\u4F5C\
    \u308B\u3002\u7A7A\u306E\u6839\u306F -1\u3001zero \u306F\u52A0\u6CD5\u306E\u5358\
    \u4F4D\u5143\u3002O(capacity) \u9818\u57DF\u3002\n        result.zero = zero\n\
    \        result.nodes = newSeqOfCap[LazyLeftistHeapNode[K, V]](capacity)\n\n \
    \   proc singleton*[K, V](self: var LazyLeftistHeapPool[K, V], key: K, value:\
    \ V): int {.inline.} =\n        ## \u4E00\u8981\u7D20\u306E\u30D2\u30FC\u30D7\u306E\
    \u6839\u3092\u8FD4\u3059\u3002\u540C\u5024\u306F\u30D7\u30FC\u30EB\u3078\u306E\
    \u633F\u5165\u9806\u3002\u511F\u5374 O(1)\u3002\n        result = self.nodes.len\n\
    \        self.nodes.add(LazyLeftistHeapNode[K, V](key: key, lazy: self.zero,\n\
    \            left: -1, right: -1, rank: 1, value: value))\n\n    proc addAll*[K,\
    \ V](self: var LazyLeftistHeapPool[K, V], root: int, delta: K) {.inline.} =\n\
    \        ## \u5168\u30AD\u30FC\u3078 delta \u3092\u52A0\u3048\u308B\u3002\u7A7A\
    \u306A\u3089\u4F55\u3082\u3057\u306A\u3044\u3002\u52A0\u7B97\u306F\u9806\u5E8F\
    \u3092\u4FDD\u3061\u3001\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u3057\u306A\
    \u3044\u3053\u3068\u3002O(1)\u3002\n        mixin `+=`\n        if root != -1:\n\
    \            self.nodes[root].key += delta\n            self.nodes[root].lazy\
    \ += delta\n\n    proc propagate[K, V](self: var LazyLeftistHeapPool[K, V], root:\
    \ int) {.inline.} =\n        ## \u6839\u306E\u9045\u5EF6\u52A0\u7B97\u3092\u5B50\
    \u3078\u4F1D\u3048\u308B\u3002O(1)\u3002\n        self.addAll(self.nodes[root].left,\
    \ self.nodes[root].lazy)\n        self.addAll(self.nodes[root].right, self.nodes[root].lazy)\n\
    \        self.nodes[root].lazy = self.zero\n\n    proc meld*[K, V](self: var LazyLeftistHeapPool[K,\
    \ V], a, b: int): int =\n        ## \u540C\u3058\u30D7\u30FC\u30EB\u306E\u4E92\
    \u3044\u306B\u7D20\u306A\u30D2\u30FC\u30D7\u3092\u7834\u58CA\u7684\u306B\u4F75\
    \u5408\u3057\u3001\u65B0\u3057\u3044\u6839\u3092\u8FD4\u3059\u3002O(log N)\u3001\
    \u518D\u5E30\u6DF1\u3055 O(log N)\u3002\n        mixin `<`, `==`\n        if a\
    \ == -1: return b\n        if b == -1: return a\n        var a = a\n        var\
    \ b = b\n        if self.nodes[b].key < self.nodes[a].key or\n               \
    \ (self.nodes[a].key == self.nodes[b].key and b < a):\n            swap(a, b)\n\
    \        self.propagate(a)\n        self.nodes[a].right = self.meld(self.nodes[a].right,\
    \ b)\n        let lrank = if self.nodes[a].left == -1: 0 else: self.nodes[self.nodes[a].left].rank\n\
    \        let rrank = if self.nodes[a].right == -1: 0 else: self.nodes[self.nodes[a].right].rank\n\
    \        if lrank < rrank: swap(self.nodes[a].left, self.nodes[a].right)\n   \
    \     self.nodes[a].rank = (if self.nodes[a].right == -1: 0 else: self.nodes[self.nodes[a].right].rank)\
    \ + 1\n        a\n\n    proc top*[K, V](self: LazyLeftistHeapPool[K, V], root:\
    \ int): tuple[key: K, value: V] {.inline.} =\n        ## \u7A7A\u3067\u306A\u3044\
    \u30D2\u30FC\u30D7\u306E\u6700\u5C0F\u8981\u7D20\u3092\u8FD4\u3059\u3002O(1)\u3002\
    \n        assert root != -1, \"\u7A7A\u306ELazyLeftistHeap\u306F\u53C2\u7167\u3067\
    \u304D\u307E\u305B\u3093\"\n        (self.nodes[root].key, self.nodes[root].value)\n\
    \n    proc pop*[K, V](self: var LazyLeftistHeapPool[K, V], root: int): int {.inline.}\
    \ =\n        ## \u7A7A\u3067\u306A\u3044\u30D2\u30FC\u30D7\u306E\u6700\u5C0F\u8981\
    \u7D20\u3092\u524A\u9664\u3057\u3001\u65B0\u3057\u3044\u6839\u3092\u8FD4\u3059\
    \u3002\u53E4\u3044\u6839\u306F\u518D\u5229\u7528\u4E0D\u53EF\u3002O(log N)\u3002\
    \n        assert root != -1, \"\u7A7A\u306ELazyLeftistHeap\u306F\u524A\u9664\u3067\
    \u304D\u307E\u305B\u3093\"\n        self.propagate(root)\n        self.meld(self.nodes[root].left,\
    \ self.nodes[root].right)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/lazy_leftist_heap.nim
  requiredBy:
  - cplib/graph/directed_mst.nim
  - cplib/graph/directed_mst.nim
  timestamp: '2026-10-04 00:13:01+00:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/directed_mst_test.nim
  - verify/graph/directed_mst_test.nim
  - verify/AI/lazy_leftist_heap_int128_test.nim
  - verify/AI/lazy_leftist_heap_int128_test.nim
  - verify/AI/directed_mst_test.nim
  - verify/AI/directed_mst_test.nim
  - verify/AI/lazy_leftist_heap_test.nim
  - verify/AI/lazy_leftist_heap_test.nim
documentation_of: cplib/collections/lazy_leftist_heap.nim
layout: document
redirect_from:
- /library/cplib/collections/lazy_leftist_heap.nim
- /library/cplib/collections/lazy_leftist_heap.nim.html
title: cplib/collections/lazy_leftist_heap.nim
---
