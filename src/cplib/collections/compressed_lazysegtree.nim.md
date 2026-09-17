---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/compressed_coordinates_internal.nim
    title: cplib/collections/compressed_coordinates_internal.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazysegtree.nim
    title: cplib/collections/lazysegtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_lazysegtree_test.nim
    title: verify/AI/compressed_lazysegtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_lazysegtree_test.nim
    title: verify/AI/compressed_lazysegtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_COMPRESSED_LAZYSEGTREE:\n    const CPLIB_COLLECTIONS_COMPRESSED_LAZYSEGTREE*\
    \ = 1\n    import algorithm, bitops\n    import cplib/collections/lazysegtree\n\
    \    include cplib/collections/compressed_coordinates_internal\n\n    type CompressedLazySegmentTree*[K,\
    \ S, F] = ref object\n        coords: seq[K]\n        tree: LazySegmentTree[S,\
    \ F]\n        default: S\n        intervals: bool\n        indexSlots: seq[int]\n\
    \        actionIdentity: F\n        getImpl: proc(tree: LazySegmentTree[S, F],\
    \ l, r: int): S\n        applyImpl: proc(tree: LazySegmentTree[S, F], l, r: int,\
    \ f: F)\n        updateImpl: proc(tree: LazySegmentTree[S, F], i: int, value:\
    \ S)\n        pointImpl: proc(tree: LazySegmentTree[S, F], i: int): S\n\n    proc\
    \ compressedLazyCoordinates[K](coords: openArray[K]): seq[K] =\n        ## \u5EA7\
    \u6A19\u3092O(N log N)\u3067\u30BD\u30FC\u30C8\u30FB\u91CD\u8907\u9664\u53BB\u3057\
    \u307E\u3059\u3002\n        result = @coords\n        sortCompressedCoordinates(result)\n\
    \        var count = 0\n        for i in 0..<result.len:\n            if count\
    \ == 0 or result[count - 1] != result[i]:\n                if count != i: result[count]\
    \ = result[i]\n                inc count\n        result.setLen(count)\n\n   \
    \ proc initCompressedLazySegmentTree*[K, S, F](coords: openArray[K],\n       \
    \     merge: proc(x, y: S): S, default: S, mapping: proc(f: F, x: S): S,\n   \
    \         composition: proc(f, g: F): F, id: F,\n            initial: proc(x:\
    \ K): S = nil): CompressedLazySegmentTree[K, S, F] =\n        ## \u767B\u9332\u70B9\
    \u3060\u3051\u3092\u4FDD\u6301\u3059\u308B\u6728\u3092O(N log N)\u6642\u9593\u30FB\
    O(N)\u7A7A\u9593\u3067\u751F\u6210\u3057\u307E\u3059\u3002\n        ## \u6574\u6570\
    \u5EA7\u6A19\u306F\u57FA\u6570\u30BD\u30FC\u30C8\u3068O(N)\u7A7A\u9593\u306E\u6DFB\
    \u5B57\u7D22\u5F15\u3092\u7528\u3044\u307E\u3059\uFF08\u5C0F\u3055\u3044\u5165\
    \u529B\u3092\u9664\u304F\uFF09\u3002\n        ## \u5404\u70B9\u3092initial(x)\uFF08\
    \u7701\u7565\u6642\u306F\u5358\u4F4D\u5143\uFF09\u3067\u521D\u671F\u5316\u3057\
    \u307E\u3059\u3002\u69CB\u7BC9\u5F8C\u306E\u5EA7\u6A19\u8FFD\u52A0\u306F\u3067\
    \u304D\u307E\u305B\u3093\u3002\n        ## composition(f,g)\u306Fg\u306E\u5F8C\
    \u306Bf\u3092\u9069\u7528\u3057\u307E\u3059\u3002K\u306B\u306F\u4E00\u8CAB\u3057\
    \u305F < \u3068 == \u304C\u5FC5\u8981\u3067\u3059\u3002\n        let xs = compressedLazyCoordinates(coords)\n\
    \        var tree: LazySegmentTree[S, F]\n        if initial == nil:\n       \
    \     tree = initLazySegmentTree(xs.len, merge, default, mapping, composition,\
    \ id)\n        else:\n            var values = newSeq[S](xs.len)\n           \
    \ for i, x in xs: values[i] = initial(x)\n            tree = initLazySegmentTree(values,\
    \ merge, default, mapping, composition, id)\n        CompressedLazySegmentTree[K,\
    \ S, F](coords: xs, default: default, tree: tree,\n            actionIdentity:\
    \ id, indexSlots: initCompressedCoordinateIndex(xs))\n\n    proc initCompressedLazySegmentTree*[K,\
    \ S, F](coords: openArray[K],\n            merge: proc(x, y: S): S, default: S,\
    \ mapping: proc(f: F, x: S): S,\n            composition: proc(f, g: F): F, id:\
    \ F,\n            initial: proc(l, r: K): S): CompressedLazySegmentTree[K, S,\
    \ F] =\n        ## \u96A3\u63A5\u3059\u308B\u767B\u9332\u5EA7\u6A19\u9593\u3092\
    \u8449\u3068\u3059\u308B\u6728\u3092O(N log N)\u6642\u9593\u30FBO(N)\u7A7A\u9593\
    \u3067\u751F\u6210\u3057\u307E\u3059\u3002\n        ## \u5404\u8449[x[i],x[i+1])\u3092\
    initial(x[i],x[i+1])\u3067\u521D\u671F\u5316\u3057\u307E\u3059\u3002\u30B3\u30FC\
    \u30EB\u30D0\u30C3\u30AF\u306FO(1)\u3092\u60F3\u5B9A\u3057\u307E\u3059\u3002\n\
    \        ## \u533A\u9593\u64CD\u4F5C\u306E\u4E21\u7AEF\u306F\u4E8B\u524D\u767B\
    \u9332\u304C\u5FC5\u8981\u3067\u3059\u3002\u533A\u9593\u548C\u3067\u306FS\u306B\
    \u5727\u7E2E\u524D\u306E\u533A\u9593\u9577\u3092\u542B\u3081\u3066\u304F\u3060\
    \u3055\u3044\u3002\n        ## composition(f,g)\u306Fg\u306E\u5F8C\u306Bf\u3092\
    \u9069\u7528\u3057\u307E\u3059\u3002\u69CB\u7BC9\u5F8C\u306E\u5EA7\u6A19\u8FFD\
    \u52A0\u306F\u3067\u304D\u307E\u305B\u3093\u3002\n        assert initial != nil,\
    \ \"\u533A\u9593\u306E\u521D\u671F\u5024\u3092\u6307\u5B9A\u3057\u3066\u304F\u3060\
    \u3055\u3044\"\n        let xs = compressedLazyCoordinates(coords)\n        var\
    \ values = newSeq[S](max(0, xs.len - 1))\n        for i in 0..<values.len:\n \
    \           values[i] = initial(xs[i], xs[i + 1])\n        CompressedLazySegmentTree[K,\
    \ S, F](coords: xs, default: default, intervals: true,\n            actionIdentity:\
    \ id, indexSlots: initCompressedCoordinateIndex(xs),\n            tree: initLazySegmentTree(values,\
    \ merge, default, mapping, composition, id))\n\n    proc boundary[K, S, F](self:\
    \ CompressedLazySegmentTree[K, S, F], x: K): int =\n        ## \u533A\u9593\u7AEF\
    \u3092\u5727\u7E2E\u5F8C\u306E\u6DFB\u5B57\u306BO(log N)\u3067\u5909\u63DB\u3057\
    \u3001\u533A\u9593\u3092\u8449\u3068\u3059\u308B\u5834\u5408\u306F\u767B\u9332\
    \u3092\u78BA\u8A8D\u3057\u307E\u3059\u3002\n        if self.intervals:\n     \
    \       result = findCompressedCoordinate(self.coords, self.indexSlots, x)\n \
    \           assert result >= 0, \"\u533A\u9593\u306E\u4E21\u7AEF\u306F\u4E8B\u524D\
    \u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\"\n        else:\n          \
    \  result = self.coords.lowerBound(x)\n\n    proc get*[K, S, F](self: CompressedLazySegmentTree[K,\
    \ S, F], l, r: K): S =\n        ## \u534A\u958B\u533A\u9593[l,r)\u306E\u7A4D\u3092\
    O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\u767B\u9332\u70B9\u3092\u4FDD\u6301\
    \u3059\u308B\u5834\u5408\u306F\u4E21\u7AEF\u304C\u672A\u767B\u9332\u3067\u3082\
    \u69CB\u3044\u307E\u305B\u3093\u3002\n        assert not (r < l), \"l <= r\u3092\
    \u6E80\u305F\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let a\
    \ = self.boundary(l)\n        let b = self.boundary(r)\n        if self.getImpl\
    \ == nil: self.tree.get(a, b)\n        else: self.getImpl(self.tree, a, b)\n\n\
    \    proc apply*[K, S, F](self: CompressedLazySegmentTree[K, S, F], l, r: K, f:\
    \ F) =\n        ## \u534A\u958B\u533A\u9593[l,r)\u3078O(log N)\u3067\u4F5C\u7528\
    \u3055\u305B\u307E\u3059\u3002\u767B\u9332\u70B9\u3092\u4FDD\u6301\u3059\u308B\
    \u5834\u5408\u306F\u672A\u767B\u9332\u70B9\u306B\u306F\u4F5C\u7528\u3057\u307E\
    \u305B\u3093\u3002\n        assert not (r < l), \"l <= r\u3092\u6E80\u305F\u3059\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n        let a = self.boundary(l)\n\
    \        let b = self.boundary(r)\n        if self.applyImpl == nil: self.tree.apply(a,\
    \ b, f)\n        else: self.applyImpl(self.tree, a, b, f)\n\n    proc update*[K,\
    \ S, F](self: CompressedLazySegmentTree[K, S, F], x: K, value: S) =\n        ##\
    \ \u767B\u9332\u70B9x\u306E\u5024\u3092O(log N)\u3067\u4E0A\u66F8\u304D\u3057\u307E\
    \u3059\u3002\u533A\u9593\u3092\u8449\u3068\u3059\u308B\u5834\u5408\u306F[x,\u6B21\
    \u306E\u767B\u9332\u5EA7\u6A19)\u5168\u4F53\u3092\u4E0A\u66F8\u304D\u3057\u307E\
    \u3059\u3002\n        let i = findCompressedCoordinate(self.coords, self.indexSlots,\
    \ x)\n        assert i >= 0, \"\u66F4\u65B0\u3059\u308B\u5EA7\u6A19\u306F\u4E8B\
    \u524D\u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\"\n        assert not self.intervals\
    \ or i + 1 < self.coords.len, \"\u6700\u5F8C\u306E\u5883\u754C\u306B\u306F\u5BFE\
    \u5FDC\u3059\u308B\u8449\u304C\u3042\u308A\u307E\u305B\u3093\"\n        if self.updateImpl\
    \ == nil: self.tree.update(i, value)\n        else: self.updateImpl(self.tree,\
    \ i, value)\n\n    proc `[]`*[K, S, F](self: CompressedLazySegmentTree[K, S, F],\
    \ x: K): S =\n        ## \u767B\u9332\u70B9x\u306E\u5024\u3092O(log N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\u533A\u9593\u3092\u8449\u3068\u3059\u308B\u5834\u5408\
    \u306F[x,\u6B21\u306E\u767B\u9332\u5EA7\u6A19)\u306E\u7A4D\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        ## \u767B\u9332\u70B9\u3092\u4FDD\u6301\u3059\u308B\u5834\
    \u5408\u3001\u672A\u767B\u9332\u70B9\u306E\u5024\u306F\u5358\u4F4D\u5143\u3067\
    \u3059\u3002\u533A\u9593\u3092\u8449\u3068\u3059\u308B\u5834\u5408\u306F\u672A\
    \u767B\u9332\u5EA7\u6A19\u3092\u8A31\u3057\u307E\u305B\u3093\u3002\n        let\
    \ i = findCompressedCoordinate(self.coords, self.indexSlots, x)\n        if self.intervals:\n\
    \            assert i >= 0 and i + 1 < self.coords.len, \"\u8449\u306E\u5DE6\u7AEF\
    \u3068\u306A\u308B\u767B\u9332\u5EA7\u6A19\u3092\u6307\u5B9A\u3057\u3066\u304F\
    \u3060\u3055\u3044\"\n        elif i < 0:\n            return self.default\n \
    \       if self.pointImpl == nil: self.tree[i]\n        else: self.pointImpl(self.tree,\
    \ i)\n\n    proc `[]=`*[K, S, F](self: CompressedLazySegmentTree[K, S, F], x:\
    \ K, value: S) =\n        ## \u5EA7\u6A19x\u306B\u5BFE\u5FDC\u3059\u308B\u8449\
    \u3092O(log N)\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n        self.update(x,\
    \ value)\n\n    proc get_all*[K, S, F](self: CompressedLazySegmentTree[K, S, F]):\
    \ S =\n        ## \u5168\u4F53\u306E\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\u7A7A\u306E\u5834\u5408\u306F\u5358\u4F4D\u5143\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        self.tree.get_all()\n\n    proc len*[K, S, F](self: CompressedLazySegmentTree[K,\
    \ S, F]): int =\n        ## \u8449\u306E\u6570\uFF08\u767B\u9332\u70B9\u6570\u3001\
    \u307E\u305F\u306F\u767B\u9332\u5EA7\u6A19\u9593\u306E\u533A\u9593\u6570\uFF09\
    \u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        if self.intervals: max(0,\
    \ self.coords.len - 1) else: self.coords.len\n\n    proc sliceBounds[K, S, F](self:\
    \ CompressedLazySegmentTree[K, S, F],\n            segment: HSlice[K, K]): tuple[a,\
    \ b: int] =\n        ## \u9589\u533A\u9593\u3092O(log N)\u3067\u5909\u63DB\u3057\
    \u307E\u3059\u3002\u533A\u9593\u30E2\u30FC\u30C9\u3067\u306F\u9806\u5E8F\u578B\
    \u306E\u53F3\u7AEF\u306E\u6B21\u306E\u5EA7\u6A19\u3092\u767B\u9332\u3057\u3066\
    \u304F\u3060\u3055\u3044\u3002\n        if segment.b < segment.a: return (0, 0)\n\
    \        if self.intervals:\n            when K is Ordinal:\n                assert\
    \ segment.b < high(K), \"\u53F3\u7AEF\u306E\u6B21\u306E\u5EA7\u6A19\u304C\u5FC5\
    \u8981\u3067\u3059\"\n                return (self.boundary(segment.a), self.boundary(succ(segment.b)))\n\
    \            else:\n                assert false, \"\u533A\u9593\u30E2\u30FC\u30C9\
    \u306E\u30B9\u30E9\u30A4\u30B9\u306B\u306F\u9806\u5E8F\u578B\u306E\u5EA7\u6A19\
    \u304C\u5FC5\u8981\u3067\u3059\u3002get(l, r)\u307E\u305F\u306Fapply(l, r, f)\u3092\
    \u4F7F\u7528\u3057\u3066\u304F\u3060\u3055\u3044\"\n        (self.coords.lowerBound(segment.a),\
    \ self.coords.upperBound(segment.b))\n\n    proc get*[K, S, F](self: CompressedLazySegmentTree[K,\
    \ S, F],\n            segment: HSlice[K, K]): S =\n        ## \u9589\u533A\u9593\
    \u306E\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\u9006\u9806\u306E\
    \u533A\u9593\u3067\u306F\u5358\u4F4D\u5143\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        ## \u533A\u9593\u30E2\u30FC\u30C9\u3067\u306FK\u306F\u9806\u5E8F\u578B\
    \u3068\u3057\u3001\u5DE6\u7AEF\u3068\u53F3\u7AEF\u306E\u6B21\u306E\u5EA7\u6A19\
    \u3092\u4E8B\u524D\u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\u3002\n   \
    \     let (a, b) = self.sliceBounds(segment)\n        if self.getImpl == nil:\
    \ self.tree.get(a, b)\n        else: self.getImpl(self.tree, a, b)\n\n    proc\
    \ `[]`*[K, S, F](self: CompressedLazySegmentTree[K, S, F],\n            segment:\
    \ HSlice[K, K]): S =\n        ## \u30B9\u30E9\u30A4\u30B9\u5185\u306E\u7A4D\u3092\
    O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.get(segment)\n\n  \
    \  proc apply*[K, S, F](self: CompressedLazySegmentTree[K, S, F],\n          \
    \  segment: HSlice[K, K], f: F) =\n        ## \u9589\u533A\u9593\u3078O(log N)\u3067\
    \u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\u9006\u9806\u306E\u533A\u9593\u3067\
    \u306F\u4F55\u3082\u3057\u307E\u305B\u3093\u3002\n        ## \u533A\u9593\u30E2\
    \u30FC\u30C9\u3067\u306FK\u306F\u9806\u5E8F\u578B\u3068\u3057\u3001\u5DE6\u7AEF\
    \u3068\u53F3\u7AEF\u306E\u6B21\u306E\u5EA7\u6A19\u3092\u4E8B\u524D\u767B\u9332\
    \u3057\u3066\u304F\u3060\u3055\u3044\u3002\n        let (a, b) = self.sliceBounds(segment)\n\
    \        if self.applyImpl == nil: self.tree.apply(a, b, f)\n        else: self.applyImpl(self.tree,\
    \ a, b, f)\n\n    proc `$`*[K, S, F](self: CompressedLazySegmentTree[K, S, F]):\
    \ string =\n        ## \u5EA7\u6A19\u9806\u306E\u8449\u306E\u5024\u3092\u7A7A\u767D\
    \u533A\u5207\u308A\u3067O(N log N)\u6642\u9593\u3067\u6587\u5B57\u5217\u5316\u3057\
    \u307E\u3059\u3002\n        $self.tree\n\n    proc compressedLazyDefaults[K, S,\
    \ F](self: CompressedLazySegmentTree[K, S, F]):\n            tuple[value: S, action:\
    \ F] =\n        ## \u7279\u6B8A\u5316\u3057\u305F\u51E6\u7406\u304C\u4F7F\u7528\
    \u3059\u308B\u5358\u4F4D\u5143\u3092\u53D6\u5F97\u3057\u307E\u3059\u3002\n   \
    \     (self.default, self.actionIdentity)\n\n    proc setCompressedLazyOperations[K,\
    \ S, F](self: CompressedLazySegmentTree[K, S, F],\n            getOp: proc(tree:\
    \ LazySegmentTree[S, F], l, r: int): S,\n            applyOp: proc(tree: LazySegmentTree[S,\
    \ F], l, r: int, f: F),\n            updateOp: proc(tree: LazySegmentTree[S, F],\
    \ i: int, value: S),\n            pointOp: proc(tree: LazySegmentTree[S, F], i:\
    \ int): S) =\n        ## \u578B\u3092\u5909\u3048\u305A\u3001\u6F14\u7B97\u3092\
    \u76F4\u63A5\u547C\u3076\u53D6\u5F97\u30FB\u4F5C\u7528\u30FB\u66F4\u65B0\u51E6\
    \u7406\u3092\u767B\u9332\u3057\u307E\u3059\u3002\n        self.getImpl = getOp\n\
    \        self.applyImpl = applyOp\n        self.updateImpl = updateOp\n      \
    \  self.pointImpl = pointOp\n\n    template newCompressedLazySegWith*(coords,\
    \ merge, default, mapping,\n            composition, id, initial: untyped): untyped\
    \ =\n        ## l, r / f, x / f, g\u3092\u4F7F\u3063\u3066\u6F14\u7B97\u3092\u6307\
    \u5B9A\u3057\u3001O(N log N)\u3067\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    \n        block:\n            type Tree = LazySegmentTree[typeof(default), typeof(id)]\n\
    \            proc mergeOp(l {.inject.}, r {.inject.}: typeof(default)): typeof(default)\
    \ {.gensym.} =\n                ## \u6307\u5B9A\u3057\u305F\u5F0F\u3067\u4E8C\u3064\
    \u306E\u5024\u3092\u30DE\u30FC\u30B8\u3057\u307E\u3059\u3002\n               \
    \ merge\n            proc mappingOp(f {.inject.}: typeof(id), x {.inject.}: typeof(default)):\
    \ typeof(default) {.gensym.} =\n                ## \u6307\u5B9A\u3057\u305F\u5F0F\
    \u3067\u5024\u306B\u4F5C\u7528\u3055\u305B\u307E\u3059\u3002\n               \
    \ mapping\n            proc compositionOp(f {.inject.}, g {.inject.}: typeof(id)):\
    \ typeof(id) {.gensym.} =\n                ## \u6307\u5B9A\u3057\u305F\u5F0F\u3067\
    \u4F5C\u7528\u3092\u5408\u6210\u3057\u307E\u3059\u3002\n                composition\n\
    \            let compressedTree = initCompressedLazySegmentTree(coords, mergeOp,\
    \ default,\n                mappingOp, compositionOp, id, initial)\n         \
    \   let defaults = compressedLazyDefaults(compressedTree)\n            proc applyNode(tree:\
    \ Tree, node: int, action: typeof(id)) {.gensym.} =\n                ## \u4E00\
    \u3064\u306E\u90E8\u5206\u6728\u306B\u4F5C\u7528\u3092\u9069\u7528\u3057\u307E\
    \u3059\u3002\n                tree.arr[node] = mappingOp(action, tree.arr[node])\n\
    \                if node < tree.lazy.len:\n                    tree.lazy[node]\
    \ = compositionOp(action, tree.lazy[node])\n            proc pushNode(tree: Tree,\
    \ node: int) {.gensym.} =\n                ## \u9045\u5EF6\u4F5C\u7528\u3092\u5B50\
    \u306B\u4F1D\u64AD\u3057\u307E\u3059\u3002\n                applyNode(tree, node\
    \ shl 1, tree.lazy[node])\n                applyNode(tree, (node shl 1) or 1,\
    \ tree.lazy[node])\n                tree.lazy[node] = defaults.action\n      \
    \      proc pushBoundary(tree: Tree, left, right: int) {.gensym.} =\n        \
    \        ## \u533A\u9593\u306E\u4E21\u7AEF\u306B\u5FC5\u8981\u306A\u4F1D\u64AD\
    \u3092\u884C\u3044\u3001\u5171\u901A\u306E\u7956\u5148\u306F\u4E00\u5EA6\u3060\
    \u3051\u51E6\u7406\u3057\u307E\u3059\u3002\n                let leftZeros = countTrailingZeroBits(left)\n\
    \                let rightZeros = countTrailingZeroBits(right)\n             \
    \   for level in countdown(countTrailingZeroBits(tree.lazy.len), 1):\n       \
    \             let lp = left shr level\n                    let rp = (right - 1)\
    \ shr level\n                    if level > leftZeros: pushNode(tree, lp)\n  \
    \                  if level > rightZeros and (level <= leftZeros or lp != rp):\n\
    \                        pushNode(tree, rp)\n            let getOp = proc(tree:\
    \ Tree, a, b: int): typeof(default) =\n                ## \u6F14\u7B97\u3092\u76F4\
    \u63A5\u547C\u3073\u51FA\u3057\u3066O(log N)\u3067\u533A\u9593\u7A4D\u3092\u53D6\
    \u5F97\u3057\u307E\u3059\u3002\n                if a == b: return defaults.value\n\
    \                var left = a + tree.lazy.len\n                var right = b +\
    \ tree.lazy.len\n                pushBoundary(tree, left, right)\n           \
    \     var lres = defaults.value\n                var rres = defaults.value\n \
    \               while left < right:\n                    if (left and 1) != 0:\n\
    \                        lres = mergeOp(lres, tree.arr[left])\n              \
    \          inc left\n                    if (right and 1) != 0:\n            \
    \            dec right\n                        rres = mergeOp(tree.arr[right],\
    \ rres)\n                    left = left shr 1\n                    right = right\
    \ shr 1\n                mergeOp(lres, rres)\n            let applyOp = proc(tree:\
    \ Tree, a, b: int, action: typeof(id)) =\n                ## \u6F14\u7B97\u3092\
    \u76F4\u63A5\u547C\u3073\u51FA\u3057\u3066O(log N)\u3067\u533A\u9593\u3078\u4F5C\
    \u7528\u3055\u305B\u307E\u3059\u3002\n                if a == b: return\n    \
    \            let first = a + tree.lazy.len\n                let last = b + tree.lazy.len\n\
    \                pushBoundary(tree, first, last)\n                var left = first\n\
    \                var right = last\n                while left < right:\n     \
    \               if (left and 1) != 0:\n                        applyNode(tree,\
    \ left, action)\n                        inc left\n                    if (right\
    \ and 1) != 0:\n                        dec right\n                        applyNode(tree,\
    \ right, action)\n                    left = left shr 1\n                    right\
    \ = right shr 1\n                let leftZeros = countTrailingZeroBits(first)\n\
    \                let rightZeros = countTrailingZeroBits(last)\n              \
    \  for level in 1..countTrailingZeroBits(tree.lazy.len):\n                   \
    \ let lp = first shr level\n                    let rp = (last - 1) shr level\n\
    \                    if level > leftZeros:\n                        tree.arr[lp]\
    \ = mergeOp(tree.arr[lp shl 1], tree.arr[(lp shl 1) or 1])\n                 \
    \   if level > rightZeros and (level <= leftZeros or lp != rp):\n            \
    \            tree.arr[rp] = mergeOp(tree.arr[rp shl 1], tree.arr[(rp shl 1) or\
    \ 1])\n            let updateOp = proc(tree: Tree, i: int, value: typeof(default))\
    \ =\n                ## \u6F14\u7B97\u3092\u76F4\u63A5\u547C\u3073\u51FA\u3057\
    \u3066O(log N)\u3067\u4E00\u70B9\u3092\u66F4\u65B0\u3057\u307E\u3059\u3002\n \
    \               var node = i + tree.lazy.len\n                for level in countdown(countTrailingZeroBits(tree.lazy.len),\
    \ 1):\n                    pushNode(tree, node shr level)\n                tree.arr[node]\
    \ = value\n                while node > 1:\n                    node = node shr\
    \ 1\n                    tree.arr[node] = mergeOp(tree.arr[node shl 1], tree.arr[(node\
    \ shl 1) or 1])\n            let pointOp = proc(tree: Tree, i: int): typeof(default)\
    \ =\n                ## \u6F14\u7B97\u3092\u76F4\u63A5\u547C\u3073\u51FA\u3057\
    \u3066O(log N)\u3067\u4E00\u70B9\u3092\u53D6\u5F97\u3057\u307E\u3059\u3002\n \
    \               let node = i + tree.lazy.len\n                for level in countdown(countTrailingZeroBits(tree.lazy.len),\
    \ 1):\n                    pushNode(tree, node shr level)\n                tree.arr[node]\n\
    \            setCompressedLazyOperations(compressedTree, getOp, applyOp, updateOp,\
    \ pointOp)\n            compressedTree\n\n    template newCompressedLazySegWith*(coords,\
    \ merge, default, mapping,\n            composition, id: untyped): untyped =\n\
    \        ## \u521D\u671F\u5024\u3092\u5358\u4F4D\u5143\u3068\u3057\u3001\u5F0F\
    \u3067\u6F14\u7B97\u3092\u6307\u5B9A\u3057\u3066O(N log N)\u3067\u6728\u3092\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002\n        newCompressedLazySegWith(coords, merge,\
    \ default, mapping, composition, id,\n            (proc(x: typeof(coords[0])):\
    \ typeof(default))(nil))\n"
  dependsOn:
  - cplib/collections/lazysegtree.nim
  - cplib/collections/lazysegtree.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_coordinates_internal.nim
  isVerificationFile: false
  path: cplib/collections/compressed_lazysegtree.nim
  requiredBy: []
  timestamp: '2026-09-17 19:00:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/compressed_lazysegtree_test.nim
  - verify/AI/compressed_lazysegtree_test.nim
documentation_of: cplib/collections/compressed_lazysegtree.nim
layout: document
redirect_from:
- /library/cplib/collections/compressed_lazysegtree.nim
- /library/cplib/collections/compressed_lazysegtree.nim.html
title: cplib/collections/compressed_lazysegtree.nim
---
