---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.14/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_MERGE_SORT_TREE:\n    const CPLIB_COLLECTIONS_MERGE_SORT_TREE*\
    \ = 1\n\n    type MergeSortTree*[T] = ref object\n        nodes: seq[T]\n    \
    \    length: int\n\n    proc build[T](self: MergeSortTree[T], leaves: openArray[T],\n\
    \            merge: proc(left, right: T): T, node, lo, hi: int) =\n        ##\
    \ [lo, hi) \u3092\u8868\u3059\u90E8\u5206\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\
    \u3002\n        if hi - lo == 1:\n            self.nodes[node] = leaves[lo]\n\
    \            return\n        let mid = lo + (hi - lo) div 2\n        let left\
    \ = node + 1\n        # \u30CE\u30FC\u30C9\u3092\u884C\u304D\u304C\u3051\u9806\
    \u306B\u683C\u7D0D\u3057\u3001\u5DE6\u90E8\u5206\u6728\u306E 2 * (mid - lo) -\
    \ 1 \u30CE\u30FC\u30C9\u306E\u76F4\u5F8C\u306B\u53F3\u90E8\u5206\u6728\u3092\u7F6E\
    \u304D\u307E\u3059\u3002\n        let right = node + 2 * (mid - lo)\n        self.build(leaves,\
    \ merge, left, lo, mid)\n        self.build(leaves, merge, right, mid, hi)\n \
    \       self.nodes[node] = merge(self.nodes[left], self.nodes[right])\n\n    proc\
    \ initMergeSortTree*[T](leaves: openArray[T],\n            merge: proc(left, right:\
    \ T): T): MergeSortTree[T] =\n        ## \u8449\u306E\u5024\u304B\u3089\u30DE\u30FC\
    \u30B8\u30BD\u30FC\u30C8\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n   \
    \     ## \u5404\u5185\u90E8\u30CE\u30FC\u30C9\u3067 merge \u306B\u5DE6\u306E\u5B50\
    \u3068\u53F3\u306E\u5B50\u306E\u5024\u3092\u3053\u306E\u9806\u3067\u6E21\u3057\
    \u307E\u3059\u3002\n        ## \u30DE\u30FC\u30B8\u304C\u533A\u9593\u9577\u306B\
    \u6BD4\u4F8B\u3059\u308B\u5834\u5408\u3001\u69CB\u7BC9\u6642\u9593\u306F O(N log\
    \ N) \u3067\u3059\u3002\n        result = MergeSortTree[T](length: leaves.len)\n\
    \        if leaves.len > 0:\n            result.nodes = newSeq[T](2 * leaves.len\
    \ - 1)\n            result.build(leaves, merge, 0, 0, leaves.len)\n\n    proc\
    \ len*[T](self: MergeSortTree[T]): int =\n        ## \u8449\u306E\u500B\u6570\u3092\
    \ O(1) \u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.length\n\n    proc visitRange[T](self:\
    \ MergeSortTree[T], node, lo, hi, l, r: int,\n            visit: proc(value: var\
    \ T)) =\n        ## [lo, hi) \u3068\u4EA4\u5DEE\u3059\u308B [l, r) \u306E\u90E8\
    \u5206\u3092\u51E6\u7406\u3057\u307E\u3059\u3002\n        if l <= lo and hi <=\
    \ r:\n            visit(self.nodes[node])\n            return\n        let mid\
    \ = lo + (hi - lo) div 2\n        if l < mid:\n            self.visitRange(node\
    \ + 1, lo, mid, l, r, visit)\n        if mid < r:\n            self.visitRange(node\
    \ + 2 * (mid - lo), mid, hi, l, r, visit)\n\n    proc forEachNode*[T](self: MergeSortTree[T],\
    \ l, r: int,\n            visit: proc(value: var T)) =\n        ## \u534A\u958B\
    \u533A\u9593 [l, r) \u3092\u69CB\u6210\u3059\u308B\u5404\u30CE\u30FC\u30C9\u306E\
    \u5024\u3092\u3001\u5DE6\u304B\u3089\u9806\u306B\u53C2\u7167\u6E21\u3057\u3067\
    \u51E6\u7406\u3057\u307E\u3059\u3002\n        ## \u533A\u9593\u5206\u89E3\u3068\
    \u547C\u3073\u51FA\u3057\u56DE\u6570\u306F O(log N) \u3067\u3059\u3002\u7A7A\u533A\
    \u9593\u3067\u306E\u547C\u3073\u51FA\u3057\u56DE\u6570\u306F 0 \u56DE\u3067\u3059\
    \u3002\n        ## \u5024\u3092\u66F8\u304D\u63DB\u3048\u308B\u5834\u5408\u3001\
    \u30CE\u30FC\u30C9\u9593\u306E\u6574\u5408\u6027\u306F\u547C\u3073\u51FA\u3057\
    \u5074\u3067\u7BA1\u7406\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        assert\
    \ 0 <= l and l <= r and r <= self.length, \"\u533A\u9593\u306F 0 <= l <= r <=\
    \ len \u3092\u6E80\u305F\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       if l < r:\n            self.visitRange(0, 0, self.length, l, r, visit)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/merge_sort_tree.nim
  requiredBy: []
  timestamp: '2026-11-18 06:34:04+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/collections/merge_sort_tree.nim
layout: document
redirect_from:
- /library/cplib/collections/merge_sort_tree.nim
- /library/cplib/collections/merge_sort_tree.nim.html
title: cplib/collections/merge_sort_tree.nim
---
