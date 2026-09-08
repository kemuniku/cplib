---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dualsegtree_test.nim
    title: verify/AI/dualsegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dualsegtree_test.nim
    title: verify/AI/dualsegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dualsegtree/rangeaffinepointget_test.nim
    title: verify/collections/dualsegtree/rangeaffinepointget_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dualsegtree/rangeaffinepointget_test.nim
    title: verify/collections/dualsegtree/rangeaffinepointget_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_DUALSEGTREE:\n    const CPLIB_COLLECTIONS_DUALSEGTREE*\
    \ = 1\n    import bitops, sequtils, strutils\n\n    type DualSegmentTree*[S, F]\
    \ = ref object\n        data: seq[S]\n        lazy: seq[F]\n        mapping: proc(f:\
    \ F, x: S): S\n        composition: proc(f, g: F): F\n        id: F\n        lastnode:\
    \ int\n        log: int\n        length: int\n\n    proc initDualSegmentTree*[S,\
    \ F](\n        v: openArray[S],\n        mapping: proc(f: F, x: S): S,\n     \
    \   composition: proc(f, g: F): F,\n        id: F\n    ): DualSegmentTree[S, F]\
    \ =\n        ## v\u3092\u521D\u671F\u5024\u3068\u3057\u3066\u53CC\u5BFE\u30BB\u30B0\
    \u30E1\u30F3\u30C8\u6728\u3092\u751F\u6210\u3057\u307E\u3059\u3002\n        var\
    \ lastnode = 1\n        while lastnode < v.len:\n            lastnode *= 2\n \
    \       result = DualSegmentTree[S, F](\n            data: @v,\n            lazy:\
    \ newSeqWith(lastnode, id),\n            mapping: mapping,\n            composition:\
    \ composition,\n            id: id,\n            lastnode: lastnode,\n       \
    \     log: countTrailingZeroBits(lastnode),\n            length: v.len\n     \
    \   )\n\n    proc initDualSegmentTree*[S, F](\n        n: int,\n        initValue:\
    \ S,\n        mapping: proc(f: F, x: S): S,\n        composition: proc(f, g: F):\
    \ F,\n        id: F\n    ): DualSegmentTree[S, F] =\n        ## initValue\u3067\
    \u521D\u671F\u5316\u3057\u305F\u9577\u3055n\u306E\u53CC\u5BFE\u30BB\u30B0\u30E1\
    \u30F3\u30C8\u6728\u3092\u751F\u6210\u3057\u307E\u3059\u3002\n        assert n\
    \ >= 0\n        initDualSegmentTree(newSeqWith(n, initValue), mapping, composition,\
    \ id)\n\n    template newDualSegWith*(v, mapping, composition, id: untyped): untyped\
    \ =\n        type S = typeof(v[0])\n        type F = typeof(id)\n        initDualSegmentTree[S,\
    \ F](\n            v,\n            proc (f{.inject.}: F, x{.inject.}: S): S =\
    \ mapping,\n            proc (f{.inject.}, g{.inject.}: F): F = composition,\n\
    \            id\n        )\n\n    template newDualSegWith*(n, initValue, mapping,\
    \ composition, id: untyped): untyped =\n        type S = typeof(initValue)\n \
    \       type F = typeof(id)\n        initDualSegmentTree[S, F](\n            n,\n\
    \            initValue,\n            proc (f{.inject.}: F, x{.inject.}: S): S\
    \ = mapping,\n            proc (f{.inject.}, g{.inject.}: F): F = composition,\n\
    \            id\n        )\n\n    proc allApply[S, F](self: DualSegmentTree[S,\
    \ F], p: int, f: F) {.inline.} =\n        ## p\u306E\u8981\u7D20\u307E\u305F\u306F\
    \u9045\u5EF6\u5024\u306Bf\u3092\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n  \
    \      if p < self.lastnode:\n            self.lazy[p] = self.composition(f, self.lazy[p])\n\
    \        else:\n            let index = p - self.lastnode\n            if index\
    \ < self.length:\n                self.data[index] = self.mapping(f, self.data[index])\n\
    \n    proc push[S, F](self: DualSegmentTree[S, F], p: int) {.inline.} =\n    \
    \    ## p\u306E\u9045\u5EF6\u5024\u3092\u5B50\u3078\u4F1D\u64AD\u3055\u305B\u307E\
    \u3059\u3002\n        self.allApply(2 * p, self.lazy[p])\n        self.allApply(2\
    \ * p + 1, self.lazy[p])\n        self.lazy[p] = self.id\n\n    proc apply*[S,\
    \ F](self: DualSegmentTree[S, F], left, right: int, f: F) =\n        ## \u534A\
    \u958B\u533A\u9593[left, right)\u306E\u5404\u8981\u7D20\u306Bf\u3092\u4F5C\u7528\
    \u3055\u305B\u307E\u3059\u3002\n        assert 0 <= left and left <= right and\
    \ right <= self.length\n        if left == right: return\n        var l = left\
    \ + self.lastnode\n        var r = right + self.lastnode\n        for i in countdown(self.log,\
    \ 1):\n            if ((l shr i) shl i) != l:\n                self.push(l shr\
    \ i)\n            if ((r shr i) shl i) != r:\n                self.push((r - 1)\
    \ shr i)\n        while l < r:\n            if (l and 1) != 0:\n             \
    \   self.allApply(l, f)\n                l.inc\n            if (r and 1) != 0:\n\
    \                r.dec\n                self.allApply(r, f)\n            l = l\
    \ shr 1\n            r = r shr 1\n\n    proc apply*[S, F](self: DualSegmentTree[S,\
    \ F], segment: HSlice[int, int], f: F) =\n        ## \u9589\u533A\u9593segment\u306E\
    \u5404\u8981\u7D20\u306Bf\u3092\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n  \
    \      self.apply(segment.a, segment.b + 1, f)\n\n    proc get*[S, F](self: DualSegmentTree[S,\
    \ F], index: int): S =\n        ## index\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3057\
    \u307E\u3059\u3002\n        assert 0 <= index and index < self.length\n      \
    \  let p = index + self.lastnode\n        for i in countdown(self.log, 1):\n \
    \           self.push(p shr i)\n        self.data[index]\n\n    proc update*[S,\
    \ F](self: DualSegmentTree[S, F], index: Natural, value: S) =\n        ## index\u306E\
    \u5024\u3092value\u306B\u7F6E\u304D\u63DB\u3048\u307E\u3059\u3002\n        assert\
    \ index < self.length\n        let p = int(index) + self.lastnode\n        for\
    \ i in countdown(self.log, 1):\n            self.push(p shr i)\n        self.data[index]\
    \ = value\n\n    proc len*[S, F](self: DualSegmentTree[S, F]): int =\n       \
    \ ## \u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\n        self.length\n\
    \n    proc `[]`*[S, F](self: DualSegmentTree[S, F], index: int): S =\n       \
    \ ## index\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n     \
    \   self.get(index)\n\n    proc `[]`*[S, F](self: DualSegmentTree[S, F], index:\
    \ BackwardsIndex): S =\n        ## \u5F8C\u308D\u304B\u3089\u6570\u3048\u305F\
    index\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n        self.get(self.length\
    \ - int(index))\n\n    proc `[]=`*[S, F](self: DualSegmentTree[S, F], index: Natural,\
    \ value: S) =\n        ## index\u306E\u5024\u3092value\u306B\u7F6E\u304D\u63DB\
    \u3048\u307E\u3059\u3002\n        self.update(index, value)\n\n    iterator items*[S,\
    \ F](self: DualSegmentTree[S, F]): S =\n        for i in 0..<self.length:\n  \
    \          yield self.get(i)\n\n    proc toSeq*[S, F](self: DualSegmentTree[S,\
    \ F]): seq[S] =\n        ## \u5168\u8981\u7D20\u3092seq\u3068\u3057\u3066\u8FD4\
    \u3057\u307E\u3059\u3002\n        for x in self:\n            result.add(x)\n\n\
    \    proc `$`*[S, F](self: DualSegmentTree[S, F]): string =\n        ## \u5168\
    \u8981\u7D20\u3092\u7A7A\u767D\u533A\u5207\u308A\u306E\u6587\u5B57\u5217\u3068\
    \u3057\u3066\u8FD4\u3057\u307E\u3059\u3002\n        self.toSeq.join(\" \")\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/dualsegtree.nim
  requiredBy: []
  timestamp: '2026-09-08 11:59:51+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/dualsegtree/rangeaffinepointget_test.nim
  - verify/collections/dualsegtree/rangeaffinepointget_test.nim
  - verify/AI/dualsegtree_test.nim
  - verify/AI/dualsegtree_test.nim
documentation_of: cplib/collections/dualsegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/dualsegtree.nim
- /library/cplib/collections/dualsegtree.nim.html
title: cplib/collections/dualsegtree.nim
---
