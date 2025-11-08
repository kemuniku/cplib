---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
    title: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
    title: verify/collections/lazysegtree/rangeaffinerangesum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
    title: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
    title: verify/collections/lazysegtree/rangesetrangecomposite_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_LAZYSEGTREE:\n    const CPLIB_COLLECTIONS_LAZYSEGTREE*\
    \ = 1\n    import algorithm, sequtils, bitops, strutils\n    type LazySegmentTree*[S,\
    \ F] = ref object\n        default: S\n        merge: proc(x: S, y: S): S\n  \
    \      arr*: seq[S]\n        lazy*: seq[F]\n        mapping: proc(f: F, x: S):\
    \ S\n        composition: proc(f, g: F): F\n        id: F\n        lastnode: int\n\
    \        log: int\n        length: int\n    proc initLazySegmentTree*[S, F](v_or_n:\
    \ int or seq[S], merge: proc(x: S, y: S): S, default: S, mapping: proc(f: F, x:\
    \ S): S, composition: proc(f, g: F): F, id: F): LazySegmentTree[S, F] =\n    \
    \    var v: seq[S]\n        var n: int\n        when v_or_n is seq[S]:\n     \
    \       v = v_or_n\n            n = len(v)\n        else:\n            n = v_or_n\n\
    \        var lastnode = 1\n        while lastnode < n:\n            lastnode*=2\n\
    \        var log = countTrailingZeroBits(lastnode)\n        var arr = newSeqWith(2*lastnode,\
    \ default)\n        var lazy = newSeqWith(lastnode, id)\n        var self = LazySegmentTree[S,\
    \ F](default: default, merge: merge, arr: arr, lazy: lazy, mapping: mapping, composition:\
    \ composition, id: id, lastnode: lastnode, log: log, length: n)\n        when\
    \ v_or_n is seq[S]:\n            for i in 0..<len(v):\n                self.arr[self.lastnode+i]\
    \ = v[i]\n            for i in countdown(lastnode-1, 1):\n                self.arr[i]\
    \ = self.merge(self.arr[2*i], self.arr[2*i+1])\n        return self\n\n    template\
    \ all_apply(self, p, f: untyped) =\n        ## p\u306E\u8981\u7D20\u306Blz\u306E\
    \u5024\u3092\u4F5C\u7528\u3055\u305B\u308B\u3002\u5B50\u304C\u3042\u308B\u5834\
    \u5408\u306Flazy\u3092\u66F4\u65B0\u3059\u308B\u3002\n        self.arr[p] = self.mapping(f,\
    \ self.arr[p])\n        if p < self.lastnode: self.lazy[p] = self.composition(f,\
    \ self.lazy[p])\n\n    template push(self, p: untyped) =\n        ## p\u306E\u5B50\
    \u306B\u4F5C\u7528\u3092\u4F1D\u64AD\u3055\u305B\u308B\u3002\n        self.all_apply(2*p,\
    \ self.lazy[p])\n        self.all_apply(2*p + 1, self.lazy[p])\n        self.lazy[p]\
    \ = self.id\n\n    template all_push(self, p: untyped) =\n        for i in countdown(self.log,\
    \ 1): self.push(p shr i)\n\n    proc update*[S, F](self: var LazySegmentTree[S,\
    \ F], p: Natural, val: S) =\n        ## p\u306E\u8981\u7D20\u3092val\u306B\u5909\
    \u66F4\u3057\u307E\u3059\u3002\n        assert p < self.length\n        var p\
    \ = p + self.lastnode\n        self.all_push(p)\n        self.arr[p] = val\n \
    \       for i in 1..self.log:\n            self.arr[p shr i] = self.merge(self.arr[2*(p\
    \ shr i)], self.arr[2*(p shr i)+1])\n\n    proc `[]`*[S, F](self: var LazySegmentTree[S,\
    \ F], p: Natural): S =\n        assert p < self.length\n        self.all_push(p\
    \ + self.lastnode)\n        return self.arr[p + self.lastnode]\n\n    proc get*[S,\
    \ F](self: var LazySegmentTree[S, F], q_left, q_right: int): S =\n        ## \u534A\
    \u89E3\u533A\u9593[q_left,q_right)\u306B\u3064\u3044\u3066\u306E\u6F14\u7B97\u7D50\
    \u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert q_left <= q_right and\
    \ 0 <= q_left and q_right <= self.length\n        if q_left == q_right: return\
    \ self.default\n        var q_left = q_left + self.lastnode\n        var q_right\
    \ = q_right + self.lastnode\n        for i in countdown(self.log, 1):\n      \
    \      if i <= countTrailingZeroBits(q_left): break\n            self.push(q_left\
    \ shr i)\n        for i in countdown(self.log, 1):\n            if i <= countTrailingZeroBits(q_right):\
    \ break\n            self.push((q_right - 1) shr i)\n        var\n           \
    \ lres = self.default\n            rres = self.default\n        while q_left <\
    \ q_right:\n            if (q_left and 1) > 0:\n                lres = self.merge(lres,\
    \ self.arr[q_left])\n                q_left.inc\n            if (q_right and 1)\
    \ > 0:\n                q_right.dec\n                rres = self.merge(self.arr[q_right],\
    \ rres)\n            q_left = q_left shr 1\n            q_right = q_right shr\
    \ 1\n        return self.merge(lres, rres)\n    proc get*[S, F](self: var LazySegmentTree[S,\
    \ F], segment: HSlice[int, int]): S =\n        return self.get(segment.a, segment.b+1)\n\
    \    proc `[]`*[S, F](self: var LazySegmentTree[S, F], segment: HSlice[int, int]):\
    \ S = self.get(segment)\n    proc `[]=`*[S, F](self: var LazySegmentTree[S, F],\
    \ p: Natural, val: S) = self.update(p, val)\n    proc len*[S, F](self: var LazySegmentTree[S,\
    \ F]): int =\n        return self.length\n    proc `$`*[S, F](self: var LazySegmentTree[S,\
    \ F]): string =\n        # var self = self\n        return (0..<self.len).toSeq.mapIt(self[it]).join(\"\
    \ \")\n    template newLazySegWith*(v_or_n, merge, default, mapping, composition,\
    \ id: untyped): untyped =\n        type S = typeof(default)\n        type F =\
    \ typeof(id)\n        initLazySegmentTree[S, F](\n            v_or_n,\n      \
    \      proc (l{.inject.}, r{.inject.}: S): S = merge,\n            default, proc\
    \ (f{.inject.}: F, x{.inject.}: S): S = mapping,\n            proc (f{.inject.},\
    \ g{.inject.}: F): F = composition,\n            id\n        )\n    proc apply*[S,\
    \ F](self: var LazySegmentTree[S, F], q_left, q_right: int, f: F) =\n        ##\
    \ \u534A\u89E3\u533A\u9593[q_left,q_right)\u306B\u3064\u3044\u3066\u306E\u6F14\
    \u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert q_left\
    \ <= q_right and 0 <= q_left and q_right <= self.length\n        if q_left ==\
    \ q_right: return\n        var q_left = q_left + self.lastnode\n        var q_right\
    \ = q_right + self.lastnode\n        var mx = countTrailingZeroBits(q_left) +\
    \ 1\n        for i in countdown(self.log, mx):\n            self.push(q_left shr\
    \ i)\n        mx = countTrailingZeroBits(q_right) + 1\n        for i in countdown(self.log,\
    \ mx):\n            self.push((q_right - 1) shr i)\n        block:\n         \
    \   var q_left = q_left\n            var q_right = q_right\n            while\
    \ q_left < q_right:\n                if (q_left and 1) > 0:\n                \
    \    self.all_apply(q_left, f)\n                    q_left.inc\n             \
    \   if (q_right and 1) > 0:\n                    q_right.dec\n               \
    \     self.all_apply(q_right, f)\n                q_left = q_left shr 1\n    \
    \            q_right = q_right shr 1\n        var mn = countTrailingZeroBits(q_left)\
    \ + 1\n        for i in mn..self.log:\n            var p = q_left shr i\n    \
    \        self.arr[p] = self.merge(self.arr[2*p], self.arr[2*p+1])\n        mn\
    \ = countTrailingZeroBits(q_right) + 1\n        for i in mn..self.log:\n     \
    \       var p = ((q_right - 1) shr i)\n            self.arr[p] = self.merge(self.arr[2*p],\
    \ self.arr[2*p+1])\n    proc apply*[S, F](self: var LazySegmentTree[S, F], segment:\
    \ HSlice[int, int], f: F) =\n        self.apply(segment.a, segment.b+1, f)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/lazysegtree.nim
  requiredBy: []
  timestamp: '2025-04-27 16:37:14+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/lazysegtree/rangesetrangecomposite_test.nim
  - verify/collections/lazysegtree/rangesetrangecomposite_test.nim
  - verify/collections/lazysegtree/rangeaffinerangesum_test.nim
  - verify/collections/lazysegtree/rangeaffinerangesum_test.nim
documentation_of: cplib/collections/lazysegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/lazysegtree.nim
- /library/cplib/collections/lazysegtree.nim.html
title: cplib/collections/lazysegtree.nim
---
