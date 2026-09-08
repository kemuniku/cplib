---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/dualsegtree_static_op_test.nim
    title: verify/AI/dualsegtree_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/dualsegtree_static_op_test.nim
    title: verify/AI/dualsegtree_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
    title: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
    title: verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_DUALSEGTREE_STATIC_OP:\n    const CPLIB_COLLECTIONS_DUALSEGTREE_STATIC_OP*\
    \ = 1\n    import bitops, sequtils, strutils\n\n    type DualSegmentTree*[S, F;\
    \ p: static[tuple]] = ref object\n        data: seq[S]\n        lazy: seq[F]\n\
    \        hasLazy: seq[bool]\n        lastnode: int\n        log: int\n       \
    \ length: int\n\n    template mappingOp[ST: DualSegmentTree](\n        self: ST\
    \ or typedesc[ST], f: ST.F, x: ST.S\n    ): auto =\n        block:\n         \
    \   let value = ST.p[0](f, x)\n            value\n\n    template compositionOp[ST:\
    \ DualSegmentTree](\n        self: ST or typedesc[ST], f, g: ST.F\n    ): auto\
    \ =\n        block:\n            let value = ST.p[1](f, g)\n            value\n\
    \n    template DualSegmentTreeType[S, F](\n        mapping0, composition0: untyped\n\
    \    ): typedesc[DualSegmentTree] =\n        proc staticMapping(f: F, x: S): S\
    \ {.gensym, inline.} = mapping0(f, x)\n        proc staticComposition(f, g: F):\
    \ F {.gensym, inline.} = composition0(f, g)\n        DualSegmentTree[S, F, (staticMapping,\
    \ staticComposition)]\n\n    when defined(release):\n        {.push checks: off.}\n\
    \    else:\n        {.push boundChecks: off, overflowChecks: off, rangeChecks:\
    \ off.}\n\n    proc initDualSegmentTreeImpl[ST: DualSegmentTree](\n        self:\
    \ typedesc[ST], v: openArray[ST.S]\n    ): ST =\n        ## v\u3092\u521D\u671F\
    \u5024\u3068\u3057\u3066\u9759\u7684\u306A\u4F5C\u7528\u95A2\u6570\u3092\u6301\
    \u3064\u53CC\u5BFE\u30BB\u30B0\u30E1\u30F3\u30C8\u6728\u3092\u751F\u6210\u3057\
    \u307E\u3059\u3002\n        let n = v.len\n        var lastnode = 1\n        while\
    \ lastnode < n:\n            lastnode *= 2\n        result = ST(\n           \
    \ data: @v,\n            lazy: newSeq[ST.F](lastnode),\n            hasLazy: newSeq[bool](lastnode),\n\
    \            lastnode: lastnode,\n            log: countTrailingZeroBits(lastnode),\n\
    \            length: n\n        )\n\n    proc initDualSegmentTreeImpl[ST: DualSegmentTree](\n\
    \        self: typedesc[ST], n: int, initValue: ST.S\n    ): ST =\n        ##\
    \ initValue\u3067\u521D\u671F\u5316\u3057\u305F\u9577\u3055n\u306E\u9759\u7684\
    \u306A\u4F5C\u7528\u95A2\u6570\u3092\u6301\u3064\u53CC\u5BFE\u30BB\u30B0\u30E1\
    \u30F3\u30C8\u6728\u3092\u751F\u6210\u3057\u307E\u3059\u3002\n        assert n\
    \ >= 0\n        self.initDualSegmentTreeImpl(newSeqWith(n, initValue))\n\n   \
    \ template initDualSegmentTree*[S, F](\n        v: openArray[S], mapping: untyped,\
    \ composition: untyped, id: F\n    ): untyped =\n        ## v\u3092\u521D\u671F\
    \u5024\u3068\u3057\u3066\u9759\u7684\u306A\u4F5C\u7528\u95A2\u6570\u3092\u6301\
    \u3064\u53CC\u5BFE\u30BB\u30B0\u30E1\u30F3\u30C8\u6728\u3092\u751F\u6210\u3057\
    \u307E\u3059\u3002\n        DualSegmentTreeType[S, F](mapping, composition)\n\
    \            .initDualSegmentTreeImpl(v)\n\n    template initDualSegmentTree*[S,\
    \ F](\n        n: int, initValue: S, mapping: untyped, composition: untyped, id:\
    \ F\n    ): untyped =\n        ## initValue\u3067\u521D\u671F\u5316\u3057\u305F\
    \u9577\u3055n\u306E\u9759\u7684\u306A\u4F5C\u7528\u95A2\u6570\u3092\u6301\u3064\
    \u53CC\u5BFE\u30BB\u30B0\u30E1\u30F3\u30C8\u6728\u3092\u751F\u6210\u3057\u307E\
    \u3059\u3002\n        DualSegmentTreeType[S, F](mapping, composition)\n      \
    \      .initDualSegmentTreeImpl(n, initValue)\n\n    template allApply(self, p,\
    \ f: untyped) =\n        ## p\u306E\u8981\u7D20\u307E\u305F\u306F\u9045\u5EF6\u5024\
    \u306Bf\u3092\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n        if p < self.lastnode:\n\
    \            if self.hasLazy[p]:\n                self.lazy[p] = self.compositionOp(f,\
    \ self.lazy[p])\n            else:\n                self.lazy[p] = f\n       \
    \         self.hasLazy[p] = true\n        else:\n            let index = p - self.lastnode\n\
    \            if index < self.length:\n                self.data[index] = self.mappingOp(f,\
    \ self.data[index])\n\n    proc pushNode[ST: DualSegmentTree](self: ST, p: int)\
    \ {.noinline.} =\n        ## p\u306E\u9045\u5EF6\u5024\u3092\u5B50\u3078\u4F1D\
    \u64AD\u3055\u305B\u307E\u3059\u3002\n        if self.hasLazy[p]:\n          \
    \  let\n                f = self.lazy[p]\n                left = 2 * p\n     \
    \           right = left + 1\n            self.allApply(left, f)\n           \
    \ self.allApply(right, f)\n            self.hasLazy[p] = false\n\n    template\
    \ push(self, p: untyped) =\n        ## p\u306E\u9045\u5EF6\u5024\u3092\u5B50\u3078\
    \u4F1D\u64AD\u3055\u305B\u307E\u3059\u3002\n        self.pushNode(p)\n\n    template\
    \ allPush(self, p: untyped) =\n        ## p\u304B\u3089\u8449\u307E\u3067\u9045\
    \u5EF6\u5024\u3092\u4F1D\u64AD\u3055\u305B\u307E\u3059\u3002\n        for i in\
    \ countdown(self.log, 1):\n            self.push(p shr i)\n\n    proc apply*[ST:\
    \ DualSegmentTree](self: ST, left, right: int, f: ST.F) =\n        ## \u534A\u958B\
    \u533A\u9593[left, right)\u306E\u5404\u8981\u7D20\u306Bf\u3092\u4F5C\u7528\u3055\
    \u305B\u307E\u3059\u3002\n        assert 0 <= left and left <= right and right\
    \ <= self.length\n        if left == right:\n            return\n        var l\
    \ = left + self.lastnode\n        var r = right + self.lastnode\n        for i\
    \ in countdown(self.log, 1):\n            if ((l shr i) shl i) != l:\n       \
    \         self.push(l shr i)\n            if ((r shr i) shl i) != r:\n       \
    \         self.push((r - 1) shr i)\n        while l < r:\n            if (l and\
    \ 1) != 0:\n                self.allApply(l, f)\n                l.inc\n     \
    \       if (r and 1) != 0:\n                r.dec\n                self.allApply(r,\
    \ f)\n            l = l shr 1\n            r = r shr 1\n\n    proc apply*[ST:\
    \ DualSegmentTree](\n        self: ST, segment: HSlice[int, int], f: ST.F\n  \
    \  ) =\n        ## \u9589\u533A\u9593segment\u306E\u5404\u8981\u7D20\u306Bf\u3092\
    \u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n        self.apply(segment.a, segment.b\
    \ + 1, f)\n\n    proc get*[ST: DualSegmentTree](self: ST, index: int): ST.S =\n\
    \        ## index\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n\
    \        assert 0 <= index and index < self.length\n        let p = index + self.lastnode\n\
    \        self.allPush(p)\n        self.data[index]\n\n    proc update*[ST: DualSegmentTree](self:\
    \ ST, index: Natural, value: ST.S) =\n        ## index\u306E\u5024\u3092value\u306B\
    \u7F6E\u304D\u63DB\u3048\u307E\u3059\u3002\n        assert index < self.length\n\
    \        let p = int(index) + self.lastnode\n        self.allPush(p)\n       \
    \ self.data[index] = value\n\n    proc len*[ST: DualSegmentTree](self: ST): int\
    \ =\n        ## \u8981\u7D20\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\n     \
    \   self.length\n\n    proc `[]`*[ST: DualSegmentTree](self: ST, index: int):\
    \ ST.S =\n        ## index\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        self.get(index)\n\n    proc `[]`*[ST: DualSegmentTree](self: ST,\
    \ index: BackwardsIndex): ST.S =\n        ## \u5F8C\u308D\u304B\u3089\u6570\u3048\
    \u305Findex\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3057\u307E\u3059\u3002\n    \
    \    self.get(self.length - int(index))\n\n    proc `[]=`*[ST: DualSegmentTree](self:\
    \ ST, index: Natural, value: ST.S) =\n        ## index\u306E\u5024\u3092value\u306B\
    \u7F6E\u304D\u63DB\u3048\u307E\u3059\u3002\n        self.update(index, value)\n\
    \n    iterator items*[ST: DualSegmentTree](self: ST): ST.S =\n        for i in\
    \ 0..<self.length:\n            yield self.get(i)\n\n    proc toSeq*[ST: DualSegmentTree](self:\
    \ ST): seq[ST.S] =\n        ## \u5168\u8981\u7D20\u3092seq\u3068\u3057\u3066\u8FD4\
    \u3057\u307E\u3059\u3002\n        for x in self:\n            result.add(x)\n\n\
    \    proc `$`*[ST: DualSegmentTree](self: ST): string =\n        ## \u5168\u8981\
    \u7D20\u3092\u7A7A\u767D\u533A\u5207\u308A\u306E\u6587\u5B57\u5217\u3068\u3057\
    \u3066\u8FD4\u3057\u307E\u3059\u3002\n        self.toSeq.join(\" \")\n\n    template\
    \ newDualSegWith*(v, mapping, composition, id: untyped): untyped =\n        block:\n\
    \            type S = typeof(v[0])\n            type F = typeof(id)\n        \
    \    proc staticMapping(\n                f {.inject.}: F, x {.inject.}: S\n \
    \           ): S {.gensym, inline.} = mapping\n            proc staticComposition(\n\
    \                f {.inject.}, g {.inject.}: F\n            ): F {.gensym, inline.}\
    \ = composition\n            DualSegmentTree[S, F, (staticMapping, staticComposition)]\n\
    \                .initDualSegmentTreeImpl(v)\n\n    template newDualSegWith*(n,\
    \ initValue, mapping, composition, id: untyped): untyped =\n        block:\n \
    \           type S = typeof(initValue)\n            type F = typeof(id)\n    \
    \        proc staticMapping(\n                f {.inject.}: F, x {.inject.}: S\n\
    \            ): S {.gensym, inline.} = mapping\n            proc staticComposition(\n\
    \                f {.inject.}, g {.inject.}: F\n            ): F {.gensym, inline.}\
    \ = composition\n            DualSegmentTree[S, F, (staticMapping, staticComposition)]\n\
    \                .initDualSegmentTreeImpl(n, initValue)\n\n    {.pop.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/dualsegtree_static_op.nim
  requiredBy: []
  timestamp: '2026-09-08 12:23:50+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
  - verify/collections/dualsegtree/rangeaffinepointget_static_op_test.nim
  - verify/AI/dualsegtree_static_op_test.nim
  - verify/AI/dualsegtree_static_op_test.nim
documentation_of: cplib/collections/dualsegtree_static_op.nim
layout: document
redirect_from:
- /library/cplib/collections/dualsegtree_static_op.nim
- /library/cplib/collections/dualsegtree_static_op.nim.html
title: cplib/collections/dualsegtree_static_op.nim
---
