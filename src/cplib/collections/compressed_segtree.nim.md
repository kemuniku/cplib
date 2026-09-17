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
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_segtree_test.nim
    title: verify/AI/compressed_segtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_segtree_test.nim
    title: verify/AI/compressed_segtree_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_COMPRESSED_SEGTREE:\n    const CPLIB_COLLECTIONS_COMPRESSED_SEGTREE*\
    \ = 1\n    import algorithm\n    import cplib/collections/segtree\n\n    include\
    \ cplib/collections/compressed_coordinates_internal\n\n    type CompressedSegmentTree*[K,\
    \ T] = ref object\n        coords: seq[K]\n        tree: SegmentTree[T]\n    \
    \    default: T\n        merge: proc(x, y: T): T\n        indexSlots: seq[int]\n\
    \        updateImpl: proc(self: CompressedSegmentTree[K, T], i: int, value: T)\n\
    \        rangeImpl: proc(self: CompressedSegmentTree[K, T], l, r: K, inclusive:\
    \ bool): T\n\n    proc initCompressedSegmentTree*[K, T](coords: openArray[K],\n\
    \            merge: proc(x, y: T): T, default: T,\n            initial: proc(x:\
    \ K): T = nil): CompressedSegmentTree[K, T] =\n        ## \u5EA7\u6A19\u3092\u30BD\
    \u30FC\u30C8\u30FB\u91CD\u8907\u9664\u53BB\u3057\u3066O(N log N)\u6642\u9593\u30FB\
    O(N)\u7A7A\u9593\u3067\u751F\u6210\u3057\u307E\u3059\u3002\n        ## \u6574\u6570\
    \u5EA7\u6A19\u306F\u57FA\u6570\u30BD\u30FC\u30C8\u3068O(N)\u7A7A\u9593\u306E\u6DFB\
    \u5B57\u7D22\u5F15\u3092\u7528\u3044\u307E\u3059\uFF08\u5C0F\u3055\u3044\u5165\
    \u529B\u3092\u9664\u304F\uFF09\u3002\n        ## \u767B\u9332\u3057\u305F\u70B9\
    \u3060\u3051\u3092\u4FDD\u6301\u3057\u3001\u5404\u70B9\u3092initial(x)\uFF08\u7701\
    \u7565\u6642\u306F\u5358\u4F4D\u5143\uFF09\u3067\u521D\u671F\u5316\u3057\u307E\
    \u3059\u3002\n        ## \u69CB\u7BC9\u5F8C\u306E\u5EA7\u6A19\u8FFD\u52A0\u306F\
    \u3067\u304D\u307E\u305B\u3093\u3002K\u306B\u306F\u4E00\u8CAB\u3057\u305F < \u3068\
    \ == \u304C\u5FC5\u8981\u3067\u3059\u3002\n        var xs = @coords\n        sortCompressedCoordinates(xs)\n\
    \        var count = 0\n        for i in 0..<xs.len:\n            if count ==\
    \ 0 or xs[count - 1] != xs[i]:\n                if count != i: xs[count] = xs[i]\n\
    \                inc count\n        xs.setLen(count)\n        var tree: SegmentTree[T]\n\
    \        if initial == nil:\n            tree = initSegmentTree(count, merge,\
    \ default)\n        else:\n            var values = newSeq[T](count)\n       \
    \     for i, x in xs: values[i] = initial(x)\n            tree = initSegmentTree(values,\
    \ merge, default)\n        result = CompressedSegmentTree[K, T](coords: xs, default:\
    \ default,\n            merge: merge, tree: tree)\n        result.indexSlots =\
    \ initCompressedCoordinateIndex(xs)\n\n    proc coordinateIndex[K, T](self: CompressedSegmentTree[K,\
    \ T], x: K): int =\n        ## \u767B\u9332\u6E08\u307F\u306E\u6DFB\u5B57\u3092\
    \u8FD4\u3057\u3001\u672A\u767B\u9332\u306A\u3089-1\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\u6700\u60AAO(log N)\u3002\n        findCompressedCoordinate(self.coords,\
    \ self.indexSlots, x)\n\n    proc update*[K, T](self: CompressedSegmentTree[K,\
    \ T], x: K, value: T) =\n        ## \u767B\u9332\u6E08\u307F\u306E\u5EA7\u6A19\
    x\u306E\u5024\u3092O(log N)\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n\
    \        let i = self.coordinateIndex(x)\n        assert i >= 0, \"\u66F4\u65B0\
    \u3059\u308B\u5EA7\u6A19\u306F\u4E8B\u524D\u767B\u9332\u3057\u3066\u304F\u3060\
    \u3055\u3044\"\n        if self.updateImpl == nil: self.tree.update(i, value)\n\
    \        else: self.updateImpl(self, i, value)\n\n    proc `[]`*[K, T](self: CompressedSegmentTree[K,\
    \ T], x: K): T =\n        ## \u5EA7\u6A19x\u306E\u5024\u3092O(log N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\u672A\u767B\u9332\u306E\u5EA7\u6A19\u3067\u306F\u5358\
    \u4F4D\u5143\u3092\u8FD4\u3057\u307E\u3059\u3002\n        let i = self.coordinateIndex(x)\n\
    \        if i >= 0: self.tree[i]\n        else: self.default\n\n    proc `[]=`*[K,\
    \ T](self: CompressedSegmentTree[K, T], x: K, value: T) =\n        ## \u767B\u9332\
    \u6E08\u307F\u306E\u5EA7\u6A19x\u306E\u5024\u3092O(log N)\u3067\u4E0A\u66F8\u304D\
    \u3057\u307E\u3059\u3002\n        self.update(x, value)\n\n    proc compressedData[K,\
    \ T](self: CompressedSegmentTree[K, T]): var seq[T] {.inline.} =\n        ## \u7279\
    \u6B8A\u5316\u3057\u305F\u51E6\u7406\u304B\u3089\u6728\u306E\u914D\u5217\u3092\
    \u53C2\u7167\u3057\u307E\u3059\u3002\n        self.tree.arr\n\n    proc compressedCoordinates[K,\
    \ T](self: CompressedSegmentTree[K, T]): lent seq[K] {.inline.} =\n        ##\
    \ \u7279\u6B8A\u5316\u3057\u305F\u51E6\u7406\u304B\u3089\u5EA7\u6A19\u3092\u30B3\
    \u30D4\u30FC\u305B\u305A\u53C2\u7167\u3057\u307E\u3059\u3002\n        self.coords\n\
    \n    proc compressedIdentity[K, T](self: CompressedSegmentTree[K, T]): T {.inline.}\
    \ =\n        ## \u7279\u6B8A\u5316\u3057\u305F\u51E6\u7406\u304B\u3089\u5358\u4F4D\
    \u5143\u3092\u53D6\u5F97\u3057\u307E\u3059\u3002\n        self.default\n\n   \
    \ proc setCompressedOperations[K, T](self: CompressedSegmentTree[K, T],\n    \
    \        updateOp: proc(self: CompressedSegmentTree[K, T], i: int, value: T),\n\
    \            rangeOp: proc(self: CompressedSegmentTree[K, T], l, r: K, inclusive:\
    \ bool): T) =\n        ## \u578B\u3092\u5909\u3048\u305A\u3001\u30DE\u30FC\u30B8\
    \u3092\u76F4\u63A5\u547C\u3076\u66F4\u65B0\u30FB\u53D6\u5F97\u51E6\u7406\u3092\
    \u767B\u9332\u3057\u307E\u3059\u3002\n        self.updateImpl = updateOp\n   \
    \     self.rangeImpl = rangeOp\n\n    template rangeProductBody[K, T](self: CompressedSegmentTree[K,\
    \ T], l, r: K,\n            inclusive: static[bool], mergeOp: untyped): untyped\
    \ =\n        ## \u5EA7\u6A19\u306E\u63A2\u7D22\u3068\u90E8\u5206\u6728\u306E\u7A4D\
    \u306E\u53D6\u5F97\u3092\u540C\u6642\u306B\u884C\u3044\u3001O(log N)\u3067\u533A\
    \u9593\u7A4D\u3092\u8FD4\u3057\u307E\u3059\u3002\n        template beforeEnd(x:\
    \ K): bool =\n            ## \u5EA7\u6A19\u304C\u533A\u9593\u306E\u53F3\u7AEF\u3088\
    \u308A\u624B\u524D\u306B\u3042\u308B\u304B\u3092\u5224\u5B9A\u3057\u307E\u3059\
    \u3002\n            when inclusive: not (r < x)\n            else: x < r\n   \
    \     let n = compressedCoordinates(self).len\n        if n == 0: return compressedIdentity(self)\n\
    \        if compressedCoordinates(self)[n - 1] < l or not beforeEnd(compressedCoordinates(self)[0]):\n\
    \            return compressedIdentity(self)\n        if not (compressedCoordinates(self)[0]\
    \ < l) and beforeEnd(compressedCoordinates(self)[n - 1]):\n            return\
    \ compressedData(self)[1]\n        var node = 1\n        var a = 0\n        var\
    \ b = compressedData(self).len div 2\n        while b - a > 1:\n            let\
    \ m = (a + b) shr 1\n            if m >= n or not beforeEnd(compressedCoordinates(self)[m]):\n\
    \                node = node shl 1\n                b = m\n            elif compressedCoordinates(self)[m]\
    \ < l:\n                node = (node shl 1) or 1\n                a = m\n    \
    \        else:\n                # \u5DE6\u7AEF\u3068\u53F3\u7AEF\u304C\u5225\u306E\
    \u5B50\u306B\u5206\u304B\u308C\u305F\u3089\u3001\u305D\u308C\u305E\u308C\u306E\
    \u5883\u754C\u3060\u3051\u3092\u305F\u3069\u308A\u307E\u3059\u3002\n         \
    \       var left = compressedIdentity(self)\n                var right = compressedIdentity(self)\n\
    \                var ln = node shl 1\n                var la = a\n           \
    \     var lb = m\n                # \u5DE6\u5074\u306F\u53F3\u306E\u90E8\u5206\
    \u6728\u3092\u524D\u306B\u8DB3\u3057\u3001\u5EA7\u6A19\u9806\u3092\u4FDD\u3061\
    \u307E\u3059\u3002\n                while lb - la > 1:\n                    let\
    \ mid = (la + lb) shr 1\n                    if compressedCoordinates(self)[mid]\
    \ < l:\n                        ln = (ln shl 1) or 1\n                       \
    \ la = mid\n                    else:\n                        left = mergeOp(compressedData(self)[(ln\
    \ shl 1) or 1], left)\n                        ln = ln shl 1\n               \
    \         lb = mid\n                if not (compressedCoordinates(self)[la] <\
    \ l):\n                    left = mergeOp(compressedData(self)[ln], left)\n  \
    \              var rn = (node shl 1) or 1\n                var ra = m\n      \
    \          var rb = b\n                # \u53F3\u5074\u306F\u5DE6\u306E\u90E8\u5206\
    \u6728\u3092\u5F8C\u308D\u306B\u8DB3\u3057\u3001\u672A\u4F7F\u7528\u306E\u8449\
    \u3092\u907F\u3051\u307E\u3059\u3002\n                while rb - ra > 1:\n   \
    \                 let mid = (ra + rb) shr 1\n                    if mid >= n or\
    \ not beforeEnd(compressedCoordinates(self)[mid]):\n                        rn\
    \ = rn shl 1\n                        rb = mid\n                    else:\n  \
    \                      right = mergeOp(right, compressedData(self)[rn shl 1])\n\
    \                        rn = (rn shl 1) or 1\n                        ra = mid\n\
    \                if beforeEnd(compressedCoordinates(self)[ra]):\n            \
    \        right = mergeOp(right, compressedData(self)[rn])\n                return\
    \ mergeOp(left, right)\n        if not (compressedCoordinates(self)[a] < l) and\
    \ beforeEnd(compressedCoordinates(self)[a]):\n            compressedData(self)[node]\n\
    \        else:\n            compressedIdentity(self)\n\n    proc rangeProduct[K,\
    \ T](self: CompressedSegmentTree[K, T], l, r: K,\n            inclusive: static[bool]):\
    \ T =\n        ## \u6307\u5B9A\u3055\u308C\u305F\u30DE\u30FC\u30B8\u95A2\u6570\
    \u3067O(log N)\u306E\u533A\u9593\u7A4D\u3092\u6C42\u3081\u307E\u3059\u3002\n \
    \       self.rangeProductBody(l, r, inclusive, self.merge)\n\n    proc get*[K,\
    \ T](self: CompressedSegmentTree[K, T], l, r: K): T =\n        ## \u534A\u958B\
    \u533A\u9593[l,r)\u5185\u306E\u767B\u9332\u70B9\u306E\u7A4D\u3092\u5EA7\u6A19\u9806\
    \u306BO(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\u4E21\u7AEF\u306F\u672A\u767B\
    \u9332\u3067\u3082\u69CB\u3044\u307E\u305B\u3093\u3002\n        assert not (r\
    \ < l), \"l <= r\u3092\u6E80\u305F\u3059\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    \"\n        if self.rangeImpl == nil: self.rangeProduct(l, r, false)\n       \
    \ else: self.rangeImpl(self, l, r, false)\n\n    proc get*[K, T](self: CompressedSegmentTree[K,\
    \ T], segment: HSlice[K, K]): T =\n        ## \u9589\u533A\u9593\u5185\u306E\u767B\
    \u9332\u70B9\u306E\u7A4D\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\u9006\
    \u9806\u306E\u533A\u9593\u3067\u306F\u5358\u4F4D\u5143\u3092\u8FD4\u3057\u307E\
    \u3059\u3002\n        if segment.b < segment.a: return self.default\n        if\
    \ self.rangeImpl == nil: self.rangeProduct(segment.a, segment.b, true)\n     \
    \   else: self.rangeImpl(self, segment.a, segment.b, true)\n\n    proc `[]`*[K,\
    \ T](self: CompressedSegmentTree[K, T], segment: HSlice[K, K]): T =\n        ##\
    \ \u30B9\u30E9\u30A4\u30B9\u5185\u306E\u767B\u9332\u70B9\u306E\u7A4D\u3092O(log\
    \ N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.get(segment)\n\n    proc\
    \ get_all*[K, T](self: CompressedSegmentTree[K, T]): T =\n        ## \u5168\u767B\
    \u9332\u70B9\u306E\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n     \
    \   self.tree.get_all()\n\n    proc len*[K, T](self: CompressedSegmentTree[K,\
    \ T]): int =\n        ## \u91CD\u8907\u9664\u53BB\u5F8C\u306E\u767B\u9332\u70B9\
    \u6570\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        self.coords.len\n\
    \n    proc `$`*[K, T](self: CompressedSegmentTree[K, T]): string =\n        ##\
    \ \u5EA7\u6A19\u9806\u306E\u8449\u306E\u5024\u3092\u7A7A\u767D\u533A\u5207\u308A\
    \u3067O(N)\u6642\u9593\u3067\u6587\u5B57\u5217\u5316\u3057\u307E\u3059\u3002\n\
    \        $self.tree\n\n    template newCompressedSegWith*(coords, merge, default:\
    \ untyped,\n            initial: untyped = nil): untyped =\n        ## \u5F0F\u4E2D\
    \u306El, r\u3092\u4F7F\u3063\u3066\u30DE\u30FC\u30B8\u3092\u6307\u5B9A\u3057\u3001\
    O(N log N)\u3067\u6728\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        block:\n\
    \            proc compressedMerge(l {.inject.}, r {.inject.}: typeof(default)):\n\
    \                    typeof(default) {.gensym.} =\n                ## \u6307\u5B9A\
    \u3057\u305F\u5F0F\u3067\u4E8C\u3064\u306E\u5024\u3092\u30DE\u30FC\u30B8\u3057\
    \u307E\u3059\u3002\n                merge\n            let compressedTree = initCompressedSegmentTree(coords,\n\
    \                proc(x, y: typeof(default)): typeof(default) = compressedMerge(x,\
    \ y),\n                default, initial)\n            let updateOp = proc(self:\
    \ typeof(compressedTree), i: int,\n                    value: typeof(default))\
    \ =\n                ## \u30DE\u30FC\u30B8\u3092\u76F4\u63A5\u547C\u3073\u51FA\
    \u3057\u3066O(log N)\u3067\u66F4\u65B0\u3057\u307E\u3059\u3002\n             \
    \   var node = i + compressedData(self).len div 2\n                compressedData(self)[node]\
    \ = value\n                while node > 1:\n                    node = node shr\
    \ 1\n                    compressedData(self)[node] = compressedMerge(compressedData(self)[node\
    \ shl 1],\n                        compressedData(self)[(node shl 1) or 1])\n\
    \            let rangeOp = proc(self: typeof(compressedTree), a, b: typeof(coords[0]),\n\
    \                    inclusive: bool): typeof(default) =\n                ## \u30DE\
    \u30FC\u30B8\u3092\u76F4\u63A5\u547C\u3073\u51FA\u3057\u3066O(log N)\u3067\u533A\
    \u9593\u7A4D\u3092\u6C42\u3081\u307E\u3059\u3002\n                if inclusive:\
    \ self.rangeProductBody(a, b, true, compressedMerge)\n                else: self.rangeProductBody(a,\
    \ b, false, compressedMerge)\n            setCompressedOperations(compressedTree,\
    \ updateOp, rangeOp)\n            compressedTree\n"
  dependsOn:
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/compressed_coordinates_internal.nim
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  isVerificationFile: false
  path: cplib/collections/compressed_segtree.nim
  requiredBy: []
  timestamp: '2026-09-17 19:00:20+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/compressed_segtree_test.nim
  - verify/AI/compressed_segtree_test.nim
documentation_of: cplib/collections/compressed_segtree.nim
layout: document
redirect_from:
- /library/cplib/collections/compressed_segtree.nim
- /library/cplib/collections/compressed_segtree.nim.html
title: cplib/collections/compressed_segtree.nim
---
