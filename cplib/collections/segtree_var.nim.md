---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_PARS_test.nim
    title: verify/collections/segtree_var/segtree_PARS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_PARS_test.nim
    title: verify/collections/segtree_var/segtree_PARS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_PSRC_2_test.nim
    title: verify/collections/segtree_var/segtree_PSRC_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_PSRC_2_test.nim
    title: verify/collections/segtree_var/segtree_PSRC_2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_PSRC_test.nim
    title: verify/collections/segtree_var/segtree_PSRC_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_PSRC_test.nim
    title: verify/collections/segtree_var/segtree_PSRC_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_RMQ_test.nim
    title: verify/collections/segtree_var/segtree_RMQ_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_RMQ_test.nim
    title: verify/collections/segtree_var/segtree_RMQ_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_get1item_test.nim
    title: verify/collections/segtree_var/segtree_get1item_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_get1item_test.nim
    title: verify/collections/segtree_var/segtree_get1item_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_newsegwith_test.nim
    title: verify/collections/segtree_var/segtree_newsegwith_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_newsegwith_test.nim
    title: verify/collections/segtree_var/segtree_newsegwith_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_static_test.nim
    title: verify/collections/segtree_var/segtree_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_static_test.nim
    title: verify/collections/segtree_var/segtree_static_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_xor1_test.nim
    title: verify/collections/segtree_var/segtree_xor1_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_xor1_test.nim
    title: verify/collections/segtree_var/segtree_xor1_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_xor2_test.nim
    title: verify/collections/segtree_var/segtree_xor2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/segtree_var/segtree_xor2_test.nim
    title: verify/collections/segtree_var/segtree_xor2_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_SEGTREE_VAR:\n    const CPLIB_COLLECTIONS_SEGTREE_VAR*\
    \ = 1\n    import algorithm, strutils, sequtils, macros\n    type SegmentTree*[T,\
    \ Elem] = object\n        default: T\n        merge: proc(x: T, y: T): T\n   \
    \     arr*: seq[Elem]\n        lastnode: int\n        length: int\n    type SegmentTreeElem[T]\
    \ = object\n        st: ptr SegmentTree[T, SegmentTreeElem[T]]\n        v: T\n\
    \        index: int\n    proc initSegmentTreeElem[T](st: ptr SegmentTree[T, SegmentTreeElem[T]],\
    \ v: T, index: int): SegmentTreeElem[T] = SegmentTreeElem[T](st: st, v: v, index:\
    \ index)\n    converter convertTo*[T](self: SegmentTreeElem[T]): T = self.v\n\
    \    proc `$`*[T](self: SegmentTreeElem[T]): string = $(self.v)\n    proc get*[T](self:\
    \ var SegmentTree[T, SegmentTreeElem[T]], q_left: Natural, q_right: Natural):\
    \ T =\n        ## \u534A\u89E3\u533A\u9593[q_left,q_right)\u306B\u3064\u3044\u3066\
    \u306E\u6F14\u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\u3002\n        assert\
    \ q_left <= q_right and 0 <= q_left and q_right <= self.length\n        var q_left\
    \ = q_left\n        var q_right = q_right\n        q_left += self.lastnode\n \
    \       q_right += self.lastnode\n        var (lres, rres) = (self.default, self.default)\n\
    \        while q_left < q_right:\n            if (q_left and 1) > 0:\n       \
    \         lres = self.merge(lres, self.arr[q_left].v)\n                q_left\
    \ += 1\n            if (q_right and 1) > 0:\n                q_right -= 1\n  \
    \              rres = self.merge(self.arr[q_right].v, rres)\n            q_left\
    \ = q_left shr 1\n            q_right = q_right shr 1\n        return self.merge(lres,\
    \ rres)\n    proc get*[T](self: var SegmentTree[T, SegmentTreeElem[T]], segment:\
    \ HSlice[int, int]): T =\n        assert segment.a <= segment.b + 1 and 0 <= segment.a\
    \ and segment.b+1 <= self.length\n        return self.get(segment.a, segment.b+1)\n\
    \    proc `[]`*[T](self: var SegmentTree[T, SegmentTreeElem[T]], segment: HSlice[int,\
    \ int]): T = self.get(segment)\n    proc `[]`*[T](self: var SegmentTree[T, SegmentTreeElem[T]],\
    \ index: Natural): var SegmentTreeElem[T] =\n        assert index < self.length\n\
    \        return self.arr[index+self.lastnode]\n    proc propagete_update[T](self:\
    \ var SegmentTree[T, SegmentTreeElem[T]], x: Natural) =\n        var x = x\n \
    \       while x > 1:\n            x = x shr 1\n            self.arr[x].v = self.merge(self.arr[2*x].v,\
    \ self.arr[2*x+1].v)\n    proc update*[T](self: var SegmentTree[T, SegmentTreeElem[T]],\
    \ index: Natural, val: T) =\n        ## x\u306E\u8981\u7D20\u3092val\u306B\u5909\
    \u66F4\u3057\u307E\u3059\u3002\n        assert index < self.length\n        self.arr[self.lastnode+index].v\
    \ = val\n        self.propagete_update(index + self.lastnode)\n    proc `[]=`*[T](self:\
    \ var SegmentTree[T, SegmentTreeElem[T]], index: Natural, val: T) = self.update(index,\
    \ val)\n    proc get_all*[T](self: SegmentTree[T, SegmentTreeElem[T]]): T =\n\
    \        ## [0,len(self))\u533A\u9593\u306E\u6F14\u7B97\u7D50\u679C\u3092O(1)\u3067\
    \u8FD4\u3059\n        return self.arr[1].v\n    proc len*[T](self: SegmentTree[T,\
    \ SegmentTreeElem[T]]): int =\n        return self.length\n    proc `$`*[T](self:\
    \ SegmentTree[T, SegmentTreeElem[T]]): string =\n        var s = self.arr.len\
    \ div 2\n        return self.arr[s..<s+self.len].mapIt(it.v).join(\" \")\n   \
    \ macro declareOperation(op) =\n        quote do:\n            proc `op`*[T](self:\
    \ var SegmentTreeElem[T], v: T) =\n                `op`(self.v, v)\n         \
    \       self.st[].propagete_update(self.index)\n    declareOperation(`+=`)\n \
    \   declareOperation(`-=`)\n    declareOperation(`*=`)\n    declareOperation(`/=`)\n\
    \    declareOperation(`^=`)\n    declareOperation(`&=`)\n    declareOperation(`|=`)\n\
    \    declareOperation(`%=`)\n    declareOperation(`//=`)\n    declareOperation(`>>=`)\n\
    \    declareOperation(`<<=`)\n    declareOperation(`**=`)\n    proc initSegmentTree*[T](v:\
    \ seq[T], merge: proc(x, y: T): T, default: T): SegmentTree[T, SegmentTreeElem[T]]\
    \ =\n        ## \u30BB\u30B0\u30E1\u30F3\u30C8\u30C4\u30EA\u30FC\u3092\u751F\u6210\
    \u3057\u307E\u3059\u3002\n        ## v\u306B\u5143\u3068\u306A\u308B\u30EA\u30B9\
    \u30C8\u3001merge\u306B\u4E8C\u3064\u306E\u533A\u9593\u3092\u30DE\u30FC\u30B8\u3059\
    \u308B\u95A2\u6570\u3001\u30C7\u30D5\u30A9\u30EB\u30C8\u306B\u5358\u4F4D\u5143\
    \u3092\u4E0E\u3048\u3066\u304F\u3060\u3055\u3044\u3002\n        var lastnode =\
    \ 1\n        while lastnode < len(v):\n            lastnode*=2\n        var arr\
    \ = newSeq[SegmentTreeElem[T]](2*lastnode)\n        result = SegmentTree[T, SegmentTreeElem[T]](default:\
    \ default, merge: merge, arr: arr, lastnode: lastnode, length: len(v))\n     \
    \   #1-indexed\u3067\u4F5C\u6210\u3059\u308B\n        for i in 0..<len(v):\n \
    \           result.arr[lastnode+i] = initSegmentTreeElem(result.addr, v[i], lastnode+i)\n\
    \        for i in len(v)..<lastnode:\n            result.arr[lastnode+i] = initSegmentTreeElem(result.addr,\
    \ default, lastnode+i)\n        for i in countdown(lastnode-1, 1):\n         \
    \   result.arr[i] = initSegmentTreeElem(result.addr, merge(result.arr[2*i].v,\
    \ result.arr[2*i+1].v), i)\n    proc initSegmentTree*[T](n: int, merge: proc(x,\
    \ y: T): T, default: T): SegmentTree[T, SegmentTreeElem[T]] = initSegmentTree(newSeqWith(n,\
    \ default), merge, default)\n    template newSegWith*(V, merge, default: untyped):\
    \ untyped =\n        initSegmentTree(V, proc (l{.inject.}, r{.inject.}: typeof(default)):\
    \ typeof(default) = merge, default)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/segtree_var.nim
  requiredBy: []
  timestamp: '2024-06-11 06:34:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/segtree_var/segtree_RMQ_test.nim
  - verify/collections/segtree_var/segtree_RMQ_test.nim
  - verify/collections/segtree_var/segtree_newsegwith_test.nim
  - verify/collections/segtree_var/segtree_newsegwith_test.nim
  - verify/collections/segtree_var/segtree_PSRC_2_test.nim
  - verify/collections/segtree_var/segtree_PSRC_2_test.nim
  - verify/collections/segtree_var/segtree_xor1_test.nim
  - verify/collections/segtree_var/segtree_xor1_test.nim
  - verify/collections/segtree_var/segtree_get1item_test.nim
  - verify/collections/segtree_var/segtree_get1item_test.nim
  - verify/collections/segtree_var/segtree_PSRC_test.nim
  - verify/collections/segtree_var/segtree_PSRC_test.nim
  - verify/collections/segtree_var/segtree_xor2_test.nim
  - verify/collections/segtree_var/segtree_xor2_test.nim
  - verify/collections/segtree_var/segtree_static_test.nim
  - verify/collections/segtree_var/segtree_static_test.nim
  - verify/collections/segtree_var/segtree_PARS_test.nim
  - verify/collections/segtree_var/segtree_PARS_test.nim
documentation_of: cplib/collections/segtree_var.nim
layout: document
redirect_from:
- /library/cplib/collections/segtree_var.nim
- /library/cplib/collections/segtree_var.nim.html
title: cplib/collections/segtree_var.nim
---
