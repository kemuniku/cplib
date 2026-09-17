---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_segtree2d_test.nim
    title: verify/AI/compressed_segtree2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_segtree2d_test.nim
    title: verify/AI/compressed_segtree2d_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_COMPRESSED_SEGTREE2D:\n    const CPLIB_COLLECTIONS_COMPRESSED_SEGTREE2D*\
    \ = 1\n    import algorithm\n\n    type CompressedSegmentTree2D*[K, T] = ref object\n\
    \        xs, ys: seq[K]\n        offsets: seq[int]\n        data: seq[T]\n   \
    \     base, count: int\n        default: T\n        merge: proc(x, y: T): T\n\
    \        updateImpl: proc(self: CompressedSegmentTree2D[K, T], x, y: K, value:\
    \ T)\n        rangeImpl: proc(self: CompressedSegmentTree2D[K, T], xl, xr, yl,\
    \ yr: K): T\n\n    proc initCompressedSegmentTree2DImpl[K, T, P](points: openArray[P],\n\
    \            merge: proc(x, y: T): T, default: T): CompressedSegmentTree2D[K,\
    \ T] =\n        ## \u767B\u9332\u5EA7\u6A19\u306E\u5727\u7E2E\u3068\u5FC5\u8981\
    \u306B\u5FDC\u3058\u305F\u521D\u671F\u5024\u306E\u4E00\u62EC\u69CB\u7BC9\u3092\
    O(N log N)\u3067\u884C\u3044\u307E\u3059\u3002\n        var ps = @points\n   \
    \     ps.sort(proc(a, b: P): int =\n            if a[0] < b[0]: -1\n         \
    \   elif b[0] < a[0]: 1\n            elif a[1] < b[1]: -1\n            elif b[1]\
    \ < a[1]: 1\n            else: 0)\n        var n = 0\n        for i in 0..<ps.len:\n\
    \            if n == 0 or ps[n - 1][0] != ps[i][0] or ps[n - 1][1] != ps[i][1]:\n\
    \                ps[n] = ps[i]\n                inc n\n            else:\n   \
    \             when compiles(ps[i][2]): ps[n - 1][2] = merge(ps[n - 1][2], ps[i][2])\n\
    \        ps.setLen(n)\n        result = CompressedSegmentTree2D[K, T](default:\
    \ default, merge: merge, count: n, base: 1)\n        var ranked = newSeq[tuple[y:\
    \ K, x: int]](n)\n        for i, p in ps:\n            if result.xs.len == 0 or\
    \ result.xs[^1] != p[0]: result.xs.add(p[0])\n            ranked[i] = (p[1], result.xs.len\
    \ - 1)\n        while result.base < result.xs.len: result.base *= 2\n        ranked.sort(proc(a,\
    \ b: tuple[y: K, x: int]): int =\n            if a.y < b.y: -1\n            elif\
    \ b.y < a.y: 1\n            else: 0)\n        let nodes = result.base * 2\n  \
    \      result.offsets = newSeq[int](nodes + 1)\n        var cursor = newSeq[int](nodes)\n\
    \        cursor.fill(-1)\n        # \u5FC5\u8981\u306A\u5EA7\u6A19\u6570\u3092\
    \u5148\u306B\u6570\u3048\u3001\u5EA7\u6A19\u30FB\u96C6\u7D04\u5024\u306E\u914D\
    \u5217\u3092\u4E00\u5EA6\u3060\u3051\u78BA\u4FDD\u3057\u307E\u3059\u3002\n   \
    \     for i, p in ranked:\n            var node = result.base + p.x\n        \
    \    while node > 0:\n                if cursor[node] != -1 and ranked[cursor[node]].y\
    \ == p.y: break\n                inc result.offsets[node + 1]\n              \
    \  cursor[node] = i\n                node = node shr 1\n        for i in 1..nodes:\
    \ result.offsets[i] += result.offsets[i - 1]\n        result.ys = newSeq[K](result.offsets[nodes])\n\
    \        result.data = newSeq[T](2 * result.ys.len)\n        result.data.fill(default)\n\
    \        cursor.fill(0)\n        for p in ranked:\n            var node = result.base\
    \ + p.x\n            while node > 0:\n                let start = result.offsets[node]\n\
    \                if cursor[node] > 0 and result.ys[start + cursor[node] - 1] ==\
    \ p.y: break\n                result.ys[start + cursor[node]] = p.y\n        \
    \        inc cursor[node]\n                node = node shr 1\n\n        when compiles(ps[0][2]):\n\
    \            var xi = 0\n            var yi = 0\n            for p in ps:\n  \
    \              while result.xs[xi] < p[0]:\n                    inc xi\n     \
    \               yi = 0\n                let node = result.base + xi\n        \
    \        let start = result.offsets[node]\n                let size = result.offsets[node\
    \ + 1] - start\n                result.data[2 * start + size + yi] = p[2]\n  \
    \              inc yi\n            for node in countdown(result.base * 2 - 1,\
    \ 1):\n                let start = result.offsets[node]\n                let size\
    \ = result.offsets[node + 1] - start\n                if node < result.base:\n\
    \                    let ls = result.offsets[node * 2]\n                    let\
    \ rs = result.offsets[node * 2 + 1]\n                    let ln = rs - ls\n  \
    \                  let rn = result.offsets[node * 2 + 2] - rs\n              \
    \      var li = 0\n                    var ri = 0\n                    for i in\
    \ 0..<size:\n                        while li < ln and result.ys[ls + li] < result.ys[start\
    \ + i]: inc li\n                        while ri < rn and result.ys[rs + ri] <\
    \ result.ys[start + i]: inc ri\n                        var lv = default\n   \
    \                     var rv = default\n                        if li < ln and\
    \ result.ys[ls + li] == result.ys[start + i]:\n                            lv\
    \ = result.data[2 * ls + ln + li]\n                        if ri < rn and result.ys[rs\
    \ + ri] == result.ys[start + i]:\n                            rv = result.data[2\
    \ * rs + rn + ri]\n                        result.data[2 * start + size + i] =\
    \ merge(lv, rv)\n                for i in countdown(size - 1, 1):\n          \
    \          result.data[2 * start + i] = merge(result.data[2 * start + 2 * i],\n\
    \                        result.data[2 * start + 2 * i + 1])\n\n    proc initCompressedSegmentTree2D*[K,\
    \ T](points: openArray[(K, K)],\n            merge: proc(x, y: T): T, default:\
    \ T): CompressedSegmentTree2D[K, T] =\n        ## \u66F4\u65B0\u5EA7\u6A19\u3092\
    \u4E8B\u524D\u767B\u9332\u3057\u3001\u5168\u70B9\u3092\u5358\u4F4D\u5143\u3067\
    \u521D\u671F\u5316\u3057\u307E\u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593O(N log\
    \ N)\u3002\n        ## merge\u306B\u306F\u53EF\u63DB\u30E2\u30CE\u30A4\u30C9\u306E\
    \u6F14\u7B97\u3001default\u306B\u306F\u5358\u4F4D\u5143\u3092\u6307\u5B9A\u3057\
    \u3066\u304F\u3060\u3055\u3044\u3002\n        ## \u91CD\u8907\u70B9\u306F\u4E00\
    \u3064\u306B\u307E\u3068\u3081\u307E\u3059\u3002\u69CB\u7BC9\u5F8C\u306E\u5EA7\
    \u6A19\u8FFD\u52A0\u306F\u3067\u304D\u307E\u305B\u3093\u3002\n        ## K\u306B\
    \u306F\u4E00\u8CAB\u3057\u305F < \u3068 == \u304C\u5FC5\u8981\u3067\u3059\u3002\
    \u5185\u5074\u306E\u6728\u306F\u8449\u6570\u30922\u51AA\u306B\u4E38\u3081\u307E\
    \u305B\u3093\u3002\n        ## \u5404\u30CE\u30FC\u30C9\u306Ey\u5EA7\u6A19\u6570\
    \u306E\u7DCF\u548C\u3092M\u3068\u3059\u308B\u3068\u3001\u5EA7\u6A19M\u500B\u30FB\
    \u96C6\u7D04\u50242M\u500B\u3068O(N)\u306E\u7BA1\u7406\u9818\u57DF\u3092\u4FDD\
    \u6301\u3057\u307E\u3059\u3002\n        initCompressedSegmentTree2DImpl[K, T,\
    \ (K, K)](points, merge, default)\n\n    proc initCompressedSegmentTree2D*[K,\
    \ T](points: openArray[(K, K, T)],\n            merge: proc(x, y: T): T, default:\
    \ T): CompressedSegmentTree2D[K, T] =\n        ## \u521D\u671F\u5024\u4ED8\u304D\
    \u767B\u9332\u70B9\u304B\u3089O(N log N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    \u540C\u3058\u5EA7\u6A19\u306E\u5024\u306F\u30DE\u30FC\u30B8\u3057\u307E\u3059\
    \u3002\n        ## merge\u306B\u306F\u53EF\u63DB\u30E2\u30CE\u30A4\u30C9\u306E\
    \u6F14\u7B97\u3001default\u306B\u306F\u5358\u4F4D\u5143\u3092\u6307\u5B9A\u3057\
    \u3066\u304F\u3060\u3055\u3044\u3002\n        initCompressedSegmentTree2DImpl[K,\
    \ T, (K, K, T)](points, merge, default)\n\n    proc yIndex[K, T](self: CompressedSegmentTree2D[K,\
    \ T], node: int, y: K): int {.inline.} =\n        ## \u30CE\u30FC\u30C9\u5185\u306E\
    y\u306ElowerBound\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        let\
    \ start = self.offsets[node]\n        var l = start\n        var r = self.offsets[node\
    \ + 1]\n        while l < r:\n            let m = (l + r) shr 1\n            if\
    \ self.ys[m] < y: l = m + 1\n            else: r = m\n        l - start\n\n  \
    \  proc valueAt[K, T](self: CompressedSegmentTree2D[K, T], node: int, y: K): T\
    \ {.inline.} =\n        ## \u30CE\u30FC\u30C9\u5185\u306Ey\u306E\u5024\u3092O(log\
    \ N)\u3067\u8FD4\u3057\u307E\u3059\u3002\u672A\u767B\u9332\u306A\u3089\u5358\u4F4D\
    \u5143\u3067\u3059\u3002\n        let start = self.offsets[node]\n        let\
    \ size = self.offsets[node + 1] - start\n        let i = self.yIndex(node, y)\n\
    \        if i < size and self.ys[start + i] == y: self.data[2 * start + size +\
    \ i]\n        else: self.default\n\n    template updateBody(self, x, y, value,\
    \ mergeOp: untyped): untyped =\n        ## \u8449\u304B\u3089\u7956\u5148\u3078\
    \u540C\u3058y\u306E\u5024\u3092\u518D\u8A08\u7B97\u3057\u3001O(log\xB2 N)\u3067\
    \u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n        let xi = self.xs.lowerBound(x)\n\
    \        assert xi < self.xs.len and self.xs[xi] == x, \"\u66F4\u65B0\u3059\u308B\
    \u5EA7\u6A19\u306F\u4E8B\u524D\u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\
    \"\n        var node = self.base + xi\n        var yi = self.yIndex(node, y)\n\
    \        assert yi < self.offsets[node + 1] - self.offsets[node] and\n       \
    \     self.ys[self.offsets[node] + yi] == y, \"\u66F4\u65B0\u3059\u308B\u5EA7\u6A19\
    \u306F\u4E8B\u524D\u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\"\n       \
    \ var current = value\n        while true:\n            let start = self.offsets[node]\n\
    \            var pos = self.offsets[node + 1] - start + yi\n            self.data[2\
    \ * start + pos] = current\n            while pos > 1:\n                pos =\
    \ pos shr 1\n                self.data[2 * start + pos] = mergeOp(self.data[2\
    \ * start + 2 * pos],\n                    self.data[2 * start + 2 * pos + 1])\n\
    \            if node == 1: break\n            # \u66F4\u65B0\u3057\u305F\u5B50\
    \u306E\u5024\u306F\u65E2\u77E5\u306A\u306E\u3067\u3001\u5144\u5F1F\u5074\u3060\
    \u3051\u3092\u63A2\u7D22\u3057\u307E\u3059\u3002\n            current = mergeOp(current,\
    \ self.valueAt(node xor 1, y))\n            node = node shr 1\n            yi\
    \ = self.yIndex(node, y)\n\n    template rangeBody(self, xl, xr, yl, yr, mergeOp:\
    \ untyped): untyped =\n        ## \u534A\u958B\u9577\u65B9\u5F62\u5185\u306E\u767B\
    \u9332\u70B9\u306E\u7A4D\u3092O(log\xB2 N)\u3067\u6C42\u3081\u307E\u3059\u3002\
    \n        assert not (xr < xl) and not (yr < yl), \"\u533A\u9593\u306E\u5DE6\u7AEF\
    \u306F\u53F3\u7AEF\u4EE5\u4E0B\u306B\u3057\u3066\u304F\u3060\u3055\u3044\"\n \
    \       var acc = self.default\n        if xl < xr and yl < yr:\n            var\
    \ l = self.xs.lowerBound(xl) + self.base\n            var r = self.xs.lowerBound(xr)\
    \ + self.base\n            template consume(node: int) =\n                ## \u5185\
    \u5074\u306E\u6728\u304B\u3089y\u533A\u9593\u3092\u96C6\u7D04\u3057\u307E\u3059\
    \u3002\n                let start = self.offsets[node]\n                let size\
    \ = self.offsets[node + 1] - start\n                var a = self.yIndex(node,\
    \ yl) + size\n                var b = self.yIndex(node, yr) + size\n         \
    \       while a < b:\n                    if (a and 1) != 0:\n               \
    \         acc = mergeOp(acc, self.data[2 * start + a])\n                     \
    \   inc a\n                    if (b and 1) != 0:\n                        dec\
    \ b\n                        acc = mergeOp(acc, self.data[2 * start + b])\n  \
    \                  a = a shr 1\n                    b = b shr 1\n            while\
    \ l < r:\n                if (l and 1) != 0:\n                    consume(l)\n\
    \                    inc l\n                if (r and 1) != 0:\n             \
    \       dec r\n                    consume(r)\n                l = l shr 1\n \
    \               r = r shr 1\n        acc\n\n    proc update*[K, T](self: CompressedSegmentTree2D[K,\
    \ T], x, y: K, value: T) =\n        ## \u767B\u9332\u70B9(x,y)\u3092O(log\xB2\
    \ N)\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n        if self.updateImpl\
    \ == nil: self.updateBody(x, y, value, self.merge)\n        else: self.updateImpl(self,\
    \ x, y, value)\n\n    proc `[]=`*[K, T](self: CompressedSegmentTree2D[K, T], x,\
    \ y: K, value: T) =\n        ## \u767B\u9332\u70B9(x,y)\u3092O(log\xB2 N)\u3067\
    \u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n        self.update(x, y, value)\n\
    \n    proc `[]`*[K, T](self: CompressedSegmentTree2D[K, T], x, y: K): T =\n  \
    \      ## \u70B9\u306E\u5024\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \u672A\u767B\u9332\u306A\u3089\u5358\u4F4D\u5143\u3067\u3059\u3002\n        let\
    \ xi = self.xs.lowerBound(x)\n        if xi < self.xs.len and self.xs[xi] == x:\
    \ self.valueAt(self.base + xi, y)\n        else: self.default\n\n    proc get*[K,\
    \ T](self: CompressedSegmentTree2D[K, T], xl, xr, yl, yr: K): T =\n        ##\
    \ [xl,xr)\xD7[yl,yr)\u306E\u7A4D\u3092O(log\xB2 N)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\u5883\u754C\u306F\u672A\u767B\u9332\u3067\u3082\u69CB\u3044\u307E\u305B\
    \u3093\u3002\n        if self.rangeImpl == nil: self.rangeBody(xl, xr, yl, yr,\
    \ self.merge)\n        else: self.rangeImpl(self, xl, xr, yl, yr)\n\n    proc\
    \ get_all*[K, T](self: CompressedSegmentTree2D[K, T]): T =\n        ## \u5168\u767B\
    \u9332\u70B9\u306E\u7A4D\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\u7A7A\u306A\
    \u3089\u5358\u4F4D\u5143\u3067\u3059\u3002\n        if self.count == 0: self.default\n\
    \        else: self.data[2 * self.offsets[1] + 1]\n\n    proc len*[K, T](self:\
    \ CompressedSegmentTree2D[K, T]): int =\n        ## \u91CD\u8907\u9664\u53BB\u5F8C\
    \u306E\u767B\u9332\u70B9\u6570\u3092O(1)\u3067\u8FD4\u3057\u307E\u3059\u3002\n\
    \        self.count\n\n    template newCompressedSeg2DWith*(points, merge, default:\
    \ untyped): untyped =\n        ## \u5F0F\u4E2D\u306El,r\u3067\u53EF\u63DB\u306A\
    \u6F14\u7B97\u3092\u6307\u5B9A\u3057\u3001\u6642\u9593\u30FB\u7A7A\u9593O(N log\
    \ N)\u3067\u751F\u6210\u3057\u307E\u3059\u3002\n        ## \u66F4\u65B0\u30FB\u53D6\
    \u5F97\u3067\u306F\u30DE\u30FC\u30B8\u95A2\u6570\u3092\u76F4\u63A5\u547C\u3073\
    \u51FA\u3057\u307E\u3059\u3002\n        block:\n            proc directMerge(l\
    \ {.inject.}, r {.inject.}: typeof(default)): typeof(default) {.gensym.} =\n \
    \               ## \u6307\u5B9A\u3057\u305F\u5F0F\u3067\u4E8C\u3064\u306E\u5024\
    \u3092\u30DE\u30FC\u30B8\u3057\u307E\u3059\u3002\n                merge\n    \
    \        let tree = initCompressedSegmentTree2D(points,\n                proc(x,\
    \ y: typeof(default)): typeof(default) = directMerge(x, y), default)\n       \
    \     type Coord = typeof(points[0][0])\n            tree.updateImpl = proc(self:\
    \ typeof(tree), x, y: Coord, value: typeof(default)) =\n                ## \u30DE\
    \u30FC\u30B8\u3092\u76F4\u63A5\u547C\u3073\u51FA\u3057\u3066\u70B9\u3092\u66F4\
    \u65B0\u3057\u307E\u3059\u3002\n                self.updateBody(x, y, value, directMerge)\n\
    \            tree.rangeImpl = proc(self: typeof(tree), xl, xr, yl, yr: Coord):\
    \ typeof(default) =\n                ## \u30DE\u30FC\u30B8\u3092\u76F4\u63A5\u547C\
    \u3073\u51FA\u3057\u3066\u9577\u65B9\u5F62\u306E\u7A4D\u3092\u6C42\u3081\u307E\
    \u3059\u3002\n                self.rangeBody(xl, xr, yl, yr, directMerge)\n  \
    \          tree\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/compressed_segtree2d.nim
  requiredBy: []
  timestamp: '2026-09-18 00:52:17+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/compressed_segtree2d_test.nim
  - verify/AI/compressed_segtree2d_test.nim
documentation_of: cplib/collections/compressed_segtree2d.nim
layout: document
redirect_from:
- /library/cplib/collections/compressed_segtree2d.nim
- /library/cplib/collections/compressed_segtree2d.nim.html
title: cplib/collections/compressed_segtree2d.nim
---
