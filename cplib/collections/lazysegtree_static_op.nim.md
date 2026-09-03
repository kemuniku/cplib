---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangeaffinerangesum_static_op_test.nim
    title: verify/collections/lazysegtree/rangeaffinerangesum_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangeaffinerangesum_static_op_test.nim
    title: verify/collections/lazysegtree/rangeaffinerangesum_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangesetrangecomposite_static_op_test.nim
    title: verify/collections/lazysegtree/rangesetrangecomposite_static_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/lazysegtree/rangesetrangecomposite_static_op_test.nim
    title: verify/collections/lazysegtree/rangesetrangecomposite_static_op_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_LAZYSEGTREE_STATIC_OP:\n    const CPLIB_COLLECTIONS_LAZYSEGTREE_STATIC_OP*\
    \ = 1\n    import algorithm, sequtils, bitops, strutils\n\n    type LazySegmentTree*[S,\
    \ F; p: static[tuple]] = ref object\n        default: S\n        arr*: seq[S]\n\
    \        lazy*: seq[F]\n        hasLazy: seq[bool]\n        lastnode: int\n  \
    \      log: int\n        length: int\n\n    template mergeOp[ST: LazySegmentTree](\n\
    \        self: ST or typedesc[ST], x, y: ST.S\n    ): auto =\n        block:\n\
    \            let value = ST.p[0](x, y)\n            value\n\n    template mappingOp[ST:\
    \ LazySegmentTree](\n        self: ST or typedesc[ST], f: ST.F, x: ST.S\n    ):\
    \ auto =\n        block:\n            let value = ST.p[1](f, x)\n            value\n\
    \n    template compositionOp[ST: LazySegmentTree](\n        self: ST or typedesc[ST],\
    \ f, g: ST.F\n    ): auto =\n        block:\n            let value = ST.p[2](f,\
    \ g)\n            value\n\n    template LazySegmentTreeType[S, F](\n        op0,\
    \ mapping0, composition0: untyped\n    ): typedesc[LazySegmentTree] =\n      \
    \  proc staticMerge(x, y: S): S {.gensym, inline.} = op0(x, y)\n        proc staticMapping(f:\
    \ F, x: S): S {.gensym, inline.} = mapping0(f, x)\n        proc staticComposition(f,\
    \ g: F): F {.gensym, inline.} = composition0(f, g)\n        LazySegmentTree[S,\
    \ F, (staticMerge, staticMapping, staticComposition)]\n\n    when defined(release):\n\
    \        {.push checks: off.}\n    else:\n        {.push boundChecks: off, overflowChecks:\
    \ off, rangeChecks: off.}\n\n    proc initLazySegmentTreeImpl[ST: LazySegmentTree](\n\
    \        self: typedesc[ST], v: seq[ST.S], default: ST.S, id: ST.F\n    ): ST\
    \ =\n        let n = len(v)\n        var lastnode = 1\n        while lastnode\
    \ < n:\n            lastnode *= 2\n        let log = countTrailingZeroBits(lastnode)\n\
    \        var arr = newSeq[ST.S](2 * lastnode)\n        var zero: ST.S\n      \
    \  when compiles(default == zero):\n            if default != zero:\n        \
    \        for i in 0..<arr.len:\n                    arr[i] = default\n       \
    \ else:\n            for i in 0..<arr.len:\n                arr[i] = default\n\
    \        let lazy = newSeq[ST.F](lastnode)\n        let hasLazy = newSeq[bool](lastnode)\n\
    \        result = ST(\n            default: default,\n            arr: arr,\n\
    \            lazy: lazy,\n            hasLazy: hasLazy,\n            lastnode:\
    \ lastnode,\n            log: log,\n            length: n\n        )\n       \
    \ for i in 0..<len(v):\n            result.arr[result.lastnode + i] = v[i]\n \
    \       for i in countdown(lastnode - 1, 1):\n            result.arr[i] = result.mergeOp(result.arr[2\
    \ * i], result.arr[2 * i + 1])\n\n    proc initLazySegmentTreeImpl[ST: LazySegmentTree](\n\
    \        self: typedesc[ST], n: int, default: ST.S, id: ST.F\n    ): ST =\n  \
    \      var lastnode = 1\n        while lastnode < n:\n            lastnode *=\
    \ 2\n        let log = countTrailingZeroBits(lastnode)\n        var arr = newSeq[ST.S](2\
    \ * lastnode)\n        var zero: ST.S\n        when compiles(default == zero):\n\
    \            if default != zero:\n                for i in 0..<arr.len:\n    \
    \                arr[i] = default\n        else:\n            for i in 0..<arr.len:\n\
    \                arr[i] = default\n        let lazy = newSeq[ST.F](lastnode)\n\
    \        let hasLazy = newSeq[bool](lastnode)\n        result = ST(\n        \
    \    default: default,\n            arr: arr,\n            lazy: lazy,\n     \
    \       hasLazy: hasLazy,\n            lastnode: lastnode,\n            log: log,\n\
    \            length: n\n        )\n\n    template initLazySegmentTree*[S, F](\n\
    \        v_or_n: seq[S] or int,\n        merge: untyped,\n        default: S,\n\
    \        mapping: untyped,\n        composition: untyped,\n        id: F\n   \
    \ ): untyped =\n        LazySegmentTreeType[S, F](merge, mapping, composition)\n\
    \            .initLazySegmentTreeImpl(v_or_n, default, id)\n\n    template all_apply(self,\
    \ p, f: untyped) =\n        ## p\u306E\u8981\u7D20\u306Bf\u306E\u5024\u3092\u4F5C\
    \u7528\u3055\u305B\u308B\u3002\u5B50\u304C\u3042\u308B\u5834\u5408\u306Flazy\u3092\
    \u66F4\u65B0\u3059\u308B\u3002\n        self.arr[p] = self.mappingOp(f, self.arr[p])\n\
    \        if p < self.lastnode:\n            if self.hasLazy[p]:\n            \
    \    self.lazy[p] = self.compositionOp(f, self.lazy[p])\n            else:\n \
    \               self.lazy[p] = f\n                self.hasLazy[p] = true\n\n \
    \   proc pushNode[ST: LazySegmentTree](self: ST, p: int) {.noinline.} =\n    \
    \    ## p\u306E\u5B50\u306B\u4F5C\u7528\u3092\u4F1D\u64AD\u3055\u305B\u308B\u3002\
    \n        if self.hasLazy[p]:\n            let\n                f = self.lazy[p]\n\
    \                left = 2 * p\n                right = left + 1\n            self.arr[left]\
    \ = self.mappingOp(f, self.arr[left])\n            self.arr[right] = self.mappingOp(f,\
    \ self.arr[right])\n            if left < self.lastnode:\n                if self.hasLazy[left]:\n\
    \                    self.lazy[left] = self.compositionOp(f, self.lazy[left])\n\
    \                else:\n                    self.lazy[left] = f\n            \
    \        self.hasLazy[left] = true\n                if self.hasLazy[right]:\n\
    \                    self.lazy[right] = self.compositionOp(f, self.lazy[right])\n\
    \                else:\n                    self.lazy[right] = f\n           \
    \         self.hasLazy[right] = true\n            self.hasLazy[p] = false\n\n\
    \    template push(self, p: untyped) =\n        self.pushNode(p)\n\n    proc pushBoundaries[ST:\
    \ LazySegmentTree](\n        self: ST, q_left, q_right: int\n    ) {.noinline.}\
    \ =\n        let\n            leftZeros = countTrailingZeroBits(q_left)\n    \
    \        rightZeros = countTrailingZeroBits(q_right)\n        for i in countdown(self.log,\
    \ 1):\n            var leftNode = 0\n            if i > leftZeros:\n         \
    \       leftNode = q_left shr i\n                self.pushNode(leftNode)\n   \
    \         if i > rightZeros:\n                let rightNode = (q_right - 1) shr\
    \ i\n                if rightNode != leftNode:\n                    self.pushNode(rightNode)\n\
    \n    proc pullBoundaries[ST: LazySegmentTree](\n        self: ST, q_left, q_right:\
    \ int\n    ) {.noinline.} =\n        let\n            leftMin = countTrailingZeroBits(q_left)\
    \ + 1\n            rightMin = countTrailingZeroBits(q_right) + 1\n           \
    \ firstLevel = min(leftMin, rightMin)\n        for i in firstLevel..self.log:\n\
    \            var leftNode = 0\n            if i >= leftMin:\n                leftNode\
    \ = q_left shr i\n                self.arr[leftNode] = self.mergeOp(\n       \
    \             self.arr[2 * leftNode], self.arr[2 * leftNode + 1]\n           \
    \     )\n            if i >= rightMin:\n                let rightNode = (q_right\
    \ - 1) shr i\n                if rightNode != leftNode:\n                    self.arr[rightNode]\
    \ = self.mergeOp(\n                        self.arr[2 * rightNode], self.arr[2\
    \ * rightNode + 1]\n                    )\n\n    template all_push(self, p: untyped)\
    \ =\n        for i in countdown(self.log, 1):\n            self.push(p shr i)\n\
    \n    proc update*[ST: LazySegmentTree](self: var ST, p: Natural, val: ST.S) =\n\
    \        ## p\u306E\u8981\u7D20\u3092val\u306B\u5909\u66F4\u3057\u307E\u3059\u3002\
    \n        assert p < self.length\n        let p = p + self.lastnode\n        self.all_push(p)\n\
    \        self.arr[p] = val\n        for i in 1..self.log:\n            let node\
    \ = p shr i\n            self.arr[node] = self.mergeOp(self.arr[2 * node], self.arr[2\
    \ * node + 1])\n\n    proc `[]`*[ST: LazySegmentTree](self: var ST, p: Natural):\
    \ ST.S =\n        assert p < self.length\n        self.all_push(p + self.lastnode)\n\
    \        return self.arr[p + self.lastnode]\n\n    proc get*[ST: LazySegmentTree](self:\
    \ var ST, q_left, q_right: int): ST.S =\n        ## \u534A\u958B\u533A\u9593[q_left,q_right)\u306B\
    \u3064\u3044\u3066\u306E\u6F14\u7B97\u7D50\u679C\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        assert q_left <= q_right and 0 <= q_left and q_right <= self.length\n\
    \        if q_left == q_right:\n            return self.default\n        var q_left\
    \ = q_left + self.lastnode\n        var q_right = q_right + self.lastnode\n  \
    \      self.pushBoundaries(q_left, q_right)\n        var\n            lres = self.default\n\
    \            rres = self.default\n        while q_left < q_right:\n          \
    \  if (q_left and 1) > 0:\n                lres = self.mergeOp(lres, self.arr[q_left])\n\
    \                q_left.inc\n            if (q_right and 1) > 0:\n           \
    \     q_right.dec\n                rres = self.mergeOp(self.arr[q_right], rres)\n\
    \            q_left = q_left shr 1\n            q_right = q_right shr 1\n    \
    \    return self.mergeOp(lres, rres)\n\n    proc get*[ST: LazySegmentTree](\n\
    \        self: var ST, segment: HSlice[int, int]\n    ): ST.S =\n        return\
    \ self.get(segment.a, segment.b + 1)\n\n    proc `[]`*[ST: LazySegmentTree](\n\
    \        self: var ST, segment: HSlice[int, int]\n    ): ST.S =\n        self.get(segment)\n\
    \n    proc `[]=`*[ST: LazySegmentTree](self: var ST, p: Natural, val: ST.S) =\n\
    \        self.update(p, val)\n\n    proc len*[ST: LazySegmentTree](self: var ST):\
    \ int =\n        return self.length\n\n    proc `$`*[ST: LazySegmentTree](self:\
    \ var ST): string =\n        return (0..<self.len).toSeq.mapIt(self[it]).join(\"\
    \ \")\n\n    template newLazySegWith*(\n        v_or_n, merge, default, mapping,\
    \ composition, id: untyped\n    ): untyped =\n        block:\n            type\
    \ S = typeof(default)\n            type F = typeof(id)\n            proc staticMerge(\n\
    \                l {.inject.}, r {.inject.}: S\n            ): S {.gensym, inline.}\
    \ = merge\n            proc staticMapping(\n                f {.inject.}: F, x\
    \ {.inject.}: S\n            ): S {.gensym, inline.} = mapping\n            proc\
    \ staticComposition(\n                f {.inject.}, g {.inject.}: F\n        \
    \    ): F {.gensym, inline.} = composition\n            LazySegmentTree[S, F,\
    \ (staticMerge, staticMapping, staticComposition)]\n                .initLazySegmentTreeImpl(v_or_n,\
    \ default, id)\n\n    proc apply*[ST: LazySegmentTree](\n        self: var ST,\
    \ q_left, q_right: int, f: ST.F\n    ) =\n        ## \u534A\u958B\u533A\u9593\
    [q_left,q_right)\u306Bf\u3092\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n    \
    \    assert q_left <= q_right and 0 <= q_left and q_right <= self.length\n   \
    \     if q_left == q_right:\n            return\n        var q_left = q_left +\
    \ self.lastnode\n        var q_right = q_right + self.lastnode\n        self.pushBoundaries(q_left,\
    \ q_right)\n        block:\n            var q_left = q_left\n            var q_right\
    \ = q_right\n            while q_left < q_right:\n                if (q_left and\
    \ 1) > 0:\n                    self.all_apply(q_left, f)\n                   \
    \ q_left.inc\n                if (q_right and 1) > 0:\n                    q_right.dec\n\
    \                    self.all_apply(q_right, f)\n                q_left = q_left\
    \ shr 1\n                q_right = q_right shr 1\n        self.pullBoundaries(q_left,\
    \ q_right)\n\n    proc apply*[ST: LazySegmentTree](\n        self: var ST, segment:\
    \ HSlice[int, int], f: ST.F\n    ) =\n        self.apply(segment.a, segment.b\
    \ + 1, f)\n\n    {.pop.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/lazysegtree_static_op.nim
  requiredBy: []
  timestamp: '2026-09-02 04:31:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/lazysegtree/rangesetrangecomposite_static_op_test.nim
  - verify/collections/lazysegtree/rangesetrangecomposite_static_op_test.nim
  - verify/collections/lazysegtree/rangeaffinerangesum_static_op_test.nim
  - verify/collections/lazysegtree/rangeaffinerangesum_static_op_test.nim
documentation_of: cplib/collections/lazysegtree_static_op.nim
layout: document
redirect_from:
- /library/cplib/collections/lazysegtree_static_op.nim
- /library/cplib/collections/lazysegtree_static_op.nim.html
title: cplib/collections/lazysegtree_static_op.nim
---
