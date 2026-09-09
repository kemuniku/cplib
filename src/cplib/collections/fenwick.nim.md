---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/fenwick_tree_test.nim
    title: verify/AI/fenwick_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/fenwick_tree_test.nim
    title: verify/AI/fenwick_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/fenwick_tree_test.nim
    title: verify/collections/fenwick_tree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/fenwick_tree_test.nim
    title: verify/collections/fenwick_tree_test.nim
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
  code: "## \u52A0\u7B97\u3068\u6E1B\u7B97\u3092\u4F7F\u3046Fenwick tree\u3067\u3059\
    \u3002\u6DFB\u5B57\u306F0\u59CB\u307E\u308A\u3001\u533A\u9593\u306F\u534A\u958B\
    \u533A\u9593\u3067\u3059\u3002\n## T\u306E\u521D\u671F\u5024\u3092\u52A0\u6CD5\
    \u5358\u4F4D\u5143\u3068\u3057\u3001\u52A0\u7B97\u306F\u53EF\u63DB\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\u3002\nwhen not declared CPLIB_COLLECTIONS_FENWICK:\n\
    \    const CPLIB_COLLECTIONS_FENWICK* = 1\n\n    type FenwickTree*[T] = object\n\
    \        size: int\n        data: seq[T]\n\n    template fenwickSlot(i: int):\
    \ int =\n        ## 1024\u8981\u7D20\u3054\u3068\u306E\u4F59\u767D\u3067\u3001\
    \u4E0A\u4F4D\u30CE\u30FC\u30C9\u306E\u30AD\u30E3\u30C3\u30B7\u30E5\u7AF6\u5408\
    \u3092\u6291\u3048\u307E\u3059\u3002\n        i + (i shr 10)\n\n    proc initFenwickTree*[T](n:\
    \ int): FenwickTree[T] =\n        ## \u9577\u3055n\u306E\u96F6\u914D\u5217\u304B\
    \u3089\u69CB\u7BC9\u3057\u307E\u3059\u3002O(n)\u6642\u9593\u30FB\u9818\u57DF\u3067\
    \u3059\u3002\n        assert n >= 0\n        result.size = n\n        result.data\
    \ = newSeq[T](fenwickSlot(n) + 1)\n\n    proc initFenwickTree*[T](values: openArray[T]):\
    \ FenwickTree[T] =\n        ## \u914D\u5217\u304B\u3089O(n)\u6642\u9593\u30FB\u9818\
    \u57DF\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        result = initFenwickTree[T](values.len)\n\
    \        for i in 1..values.len:\n            result.data[fenwickSlot(i)] = values[i\
    \ - 1]\n        for i in 1..values.len:\n            let parent = i + (i and -i)\n\
    \            if parent <= values.len:\n                result.data[fenwickSlot(parent)]\
    \ += result.data[fenwickSlot(i)]\n\n    proc len*[T](self: FenwickTree[T]): int\
    \ {.inline.} =\n        ## \u8981\u7D20\u6570\u3092O(1)\u3067\u8FD4\u3057\u307E\
    \u3059\u3002\n        self.size\n\n    proc add*[T](self: var FenwickTree[T],\
    \ p: int, delta: T) {.inline.} =\n        ## a[p]\u306Bdelta\u3092\u52A0\u3048\
    \u307E\u3059\u3002O(log n)\u3067\u3059\u3002\n        assert 0 <= p and p < self.size\n\
    \        var i = p + 1\n        while i <= self.size:\n            self.data[fenwickSlot(i)]\
    \ += delta\n            i += i and -i\n\n    proc prefix*[T](self: FenwickTree[T],\
    \ r: int): T {.inline.} =\n        ## [0, r)\u306E\u548C\u3092O(log n)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        assert 0 <= r and r <= self.size\n        var\
    \ r = r\n        while r > 0:\n            result += self.data[fenwickSlot(r)]\n\
    \            r = r and (r - 1)\n\n    proc get*[T](self: FenwickTree[T], l, r:\
    \ int): T {.inline.} =\n        ## [l, r)\u306E\u548C\u3092O(log n)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\u5171\u901A\u3059\u308B\u7956\u5148\u306F\u8D70\u67FB\
    \u3057\u307E\u305B\u3093\u3002\n        assert 0 <= l and l <= r and r <= self.size\n\
    \        var l = l\n        var r = r\n        var left: T\n        while r >\
    \ l:\n            result += self.data[fenwickSlot(r)]\n            r = r and (r\
    \ - 1)\n        while l > r:\n            left += self.data[fenwickSlot(l)]\n\
    \            l = l and (l - 1)\n        result = result - left\n\n    proc `[]`*[T](self:\
    \ FenwickTree[T], segment: HSlice[int, int]): T {.inline.} =\n        ## \u30B9\
    \u30E9\u30A4\u30B9\u306E\u548C\u3092O(log n)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        self.get(segment.a, segment.b + 1)\n\n    proc `[]`*[T](self: FenwickTree[T],\
    \ p: int): T {.inline.} =\n        ## a[p]\u3092O(log n)\u3067\u8FD4\u3057\u307E\
    \u3059\u3002\n        self.get(p, p + 1)\n\n    proc `[]=`*[T](self: var FenwickTree[T],\
    \ p: int, value: T) {.inline.} =\n        ## a[p]\u3092value\u306B\u5909\u66F4\
    \u3057\u307E\u3059\u3002O(log n)\u3067\u3059\u3002\n        self.add(p, value\
    \ - self[p])\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/fenwick.nim
  requiredBy: []
  timestamp: '2026-09-09 00:04:51+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/fenwick_tree_test.nim
  - verify/collections/fenwick_tree_test.nim
  - verify/AI/fenwick_tree_test.nim
  - verify/AI/fenwick_tree_test.nim
documentation_of: cplib/collections/fenwick.nim
layout: document
redirect_from:
- /library/cplib/collections/fenwick.nim
- /library/cplib/collections/fenwick.nim.html
title: cplib/collections/fenwick.nim
---
