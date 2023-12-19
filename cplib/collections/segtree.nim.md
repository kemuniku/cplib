---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_PARS_test.nim
    title: verify/collections/segtree/segtree_PARS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_PARS_test.nim
    title: verify/collections/segtree/segtree_PARS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_PSRC_2_test.nim
    title: verify/collections/segtree/segtree_PSRC_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_PSRC_2_test.nim
    title: verify/collections/segtree/segtree_PSRC_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_PSRC_test.nim
    title: verify/collections/segtree/segtree_PSRC_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_PSRC_test.nim
    title: verify/collections/segtree/segtree_PSRC_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_RMQ_test.nim
    title: verify/collections/segtree/segtree_RMQ_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_RMQ_test.nim
    title: verify/collections/segtree/segtree_RMQ_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_get1item_test.nim
    title: verify/collections/segtree/segtree_get1item_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_get1item_test.nim
    title: verify/collections/segtree/segtree_get1item_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_static_test.nim
    title: verify/collections/segtree/segtree_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_static_test.nim
    title: verify/collections/segtree/segtree_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_xor1_test.nim
    title: verify/collections/segtree/segtree_xor1_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_xor1_test.nim
    title: verify/collections/segtree/segtree_xor1_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_xor2_test.nim
    title: verify/collections/segtree/segtree_xor2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree/segtree_xor2_test.nim
    title: verify/collections/segtree/segtree_xor2_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_SEGTREE:\n    const CPLIB_COLLECTIONS_SEGTREE*\
    \ = 1\n    import algorithm\n    type SegmentTree[T] = ref object\n        default:\
    \ T\n        merge: proc(x: T, y: T): T\n        arr*: seq[T]\n        lastnode:\
    \ int\n        length: int\n    proc initSegmentTree*[T](v: seq[T], merge: proc(x:\
    \ T, y: T): T, default: T): SegmentTree[T] =\n        ## \u30BB\u30B0\u30E1\u30F3\
    \u30C8\u30C4\u30EA\u30FC\u3092\u751F\u6210\u3057\u307E\u3059\u3002\n        ##\
    \ v\u306B\u5143\u3068\u306A\u308B\u30EA\u30B9\u30C8\u3001merge\u306B\u4E8C\u3064\
    \u306E\u533A\u9593\u3092\u30DE\u30FC\u30B8\u3059\u308B\u95A2\u6570\u3001\u30C7\
    \u30D5\u30A9\u30EB\u30C8\u306B\u5358\u4F4D\u5143\u3092\u4E0E\u3048\u3066\u304F\
    \u3060\u3055\u3044\u3002\n        var lastnode = 1\n        while lastnode < len(v):\n\
    \            lastnode*=2\n        var arr = newSeq[T](2*lastnode)\n        arr.fill(default)\n\
    \        var self = SegmentTree[T](default: default, merge: merge, arr: arr, lastnode:\
    \ lastnode, length: len(v))\n        #1-indexed\u3067\u4F5C\u6210\u3059\u308B\n\
    \        for i in 0..<len(v):\n            self.arr[self.lastnode+i] = v[i]\n\
    \        for i in countdown(lastnode-1, 1):\n            self.arr[i] = self.merge(self.arr[2*i],\
    \ self.arr[2*i+1])\n        return self\n\n    proc update*[T](self: SegmentTree[T],\
    \ x: Natural, val: T) =\n        ## x\u306E\u8981\u7D20\u3092val\u306B\u5909\u66F4\
    \u3057\u307E\u3059\u3002\n        assert x < self.length\n        var x = x\n\
    \        x += self.lastnode\n        self.arr[x] = val\n        while x > 1:\n\
    \            x = x shr 1\n            self.arr[x] = self.merge(self.arr[2*x],\
    \ self.arr[2*x+1])\n    proc get*[T](self: SegmentTree[T], q_left: Natural, q_right:\
    \ Natural): T =\n        ## \u534A\u89E3\u533A\u9593[q_left,q_right)\u306B\u3064\
    \u3044\u3066\u306E\u6F14\u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        assert q_left <= q_right and 0 <= q_left and q_right <= self.length\n\
    \        var q_left = q_left\n        var q_right = q_right\n        q_left +=\
    \ self.lastnode\n        q_right += self.lastnode\n        var (lres, rres) =\
    \ (self.default, self.default)\n        while q_left < q_right:\n            if\
    \ (q_left and 1) > 0:\n                lres = self.merge(lres, self.arr[q_left])\n\
    \                q_left += 1\n            if (q_right and 1) > 0:\n          \
    \      q_right -= 1\n                rres = self.merge(self.arr[q_right], rres)\n\
    \            q_left = q_left shr 1\n            q_right = q_right shr 1\n    \
    \    return self.merge(lres, rres)\n    proc get*[T](self: SegmentTree[T], segment:\
    \ HSlice[int, int]): T =\n        assert segment.a <= segment.b + 1 and 0 <= segment.a\
    \ and segment.b+1 <= self.length\n        return self.get(segment.a, segment.b+1)\n\
    \    proc `[]`*[T](self: SegmentTree[T], index: Natural): T =\n        assert\
    \ index < self.length\n        return self.arr[index+self.lastnode]\n    proc\
    \ `[]=`*[T](self: SegmentTree[T], index: Natural, val: T) =\n        assert index\
    \ < self.length\n        self.update(index, val)\n    proc get_all*[T](self: SegmentTree[T]):\
    \ T =\n        ## [0,len(self))\u533A\u9593\u306E\u6F14\u7B97\u7D50\u679C\u3092\
    O(1)\u3067\u8FD4\u3059\n        return self.arr[1]\n    proc len*[T](self: SegmentTree[T]):\
    \ int =\n        return self.length\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/segtree.nim
  requiredBy: []
  timestamp: '2023-12-04 23:06:36+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/segtree/segtree_PSRC_2_test.nim
  - verify/collections/segtree/segtree_PSRC_2_test.nim
  - verify/collections/segtree/segtree_RMQ_test.nim
  - verify/collections/segtree/segtree_RMQ_test.nim
  - verify/collections/segtree/segtree_xor1_test.nim
  - verify/collections/segtree/segtree_xor1_test.nim
  - verify/collections/segtree/segtree_static_test.nim
  - verify/collections/segtree/segtree_static_test.nim
  - verify/collections/segtree/segtree_xor2_test.nim
  - verify/collections/segtree/segtree_xor2_test.nim
  - verify/collections/segtree/segtree_get1item_test.nim
  - verify/collections/segtree/segtree_get1item_test.nim
  - verify/collections/segtree/segtree_PARS_test.nim
  - verify/collections/segtree/segtree_PARS_test.nim
  - verify/collections/segtree/segtree_PSRC_test.nim
  - verify/collections/segtree/segtree_PSRC_test.nim
documentation_of: cplib/collections/segtree.nim
layout: document
redirect_from:
- /library/cplib/collections/segtree.nim
- /library/cplib/collections/segtree.nim.html
title: cplib/collections/segtree.nim
---
