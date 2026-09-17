---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_fenwick2d_test.nim
    title: verify/AI/compressed_fenwick2d_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/compressed_fenwick2d_test.nim
    title: verify/AI/compressed_fenwick2d_test.nim
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
  code: "## \u66F4\u65B0\u5EA7\u6A19\u3092\u4E8B\u524D\u767B\u9332\u3059\u308B2\u6B21\
    \u5143Fenwick tree\u3067\u3059\u3002\u53D6\u5F97\u7BC4\u56F2\u306F\u534A\u958B\
    \u533A\u9593\u3067\u3059\u3002\n## T\u306E\u521D\u671F\u5024\u3092\u52A0\u6CD5\
    \u5358\u4F4D\u5143\u3068\u3057\u3001+=\u3068\u6E1B\u7B97\u306B\u3088\u308B\u53EF\
    \u63DB\u7FA4\u3092\u6271\u3044\u307E\u3059\u3002\nwhen not declared CPLIB_COLLECTIONS_COMPRESSED_FENWICK2D:\n\
    \    const CPLIB_COLLECTIONS_COMPRESSED_FENWICK2D* = 1\n    import algorithm\n\
    \n    type CompressedFenwick2D*[K, T] = ref object\n        xs, ys, pointYs: seq[K]\n\
    \        offsets, pointOffsets: seq[int]\n        data, pointValues: seq[T]\n\n\
    \    proc initCompressedFenwick2DImpl[K, T, P](points: openArray[P]): CompressedFenwick2D[K,\
    \ T] =\n        ## \u5EA7\u6A19\u306E\u5727\u7E2E\u3068\u5FC5\u8981\u306B\u5FDC\
    \u3058\u305F\u521D\u671F\u5024\u306E\u4E00\u62EC\u69CB\u7BC9\u3092O(N log N)\u3067\
    \u884C\u3044\u307E\u3059\u3002\n        mixin `+=`\n        var ps = @points\n\
    \        ps.sort(proc(a, b: P): int =\n            if a[0] < b[0]: -1\n      \
    \      elif b[0] < a[0]: 1\n            elif a[1] < b[1]: -1\n            elif\
    \ b[1] < a[1]: 1\n            else: 0)\n        var count = 0\n        for i in\
    \ 0..<ps.len:\n            if count == 0 or ps[count - 1][0] != ps[i][0] or ps[count\
    \ - 1][1] != ps[i][1]:\n                ps[count] = ps[i]\n                inc\
    \ count\n            else:\n                when compiles(ps[i][2]): ps[count\
    \ - 1][2] += ps[i][2]\n        ps.setLen(count)\n        result = CompressedFenwick2D[K,\
    \ T](pointYs: newSeq[K](count), pointValues: newSeq[T](count))\n        var ranked\
    \ = newSeq[tuple[y: K, x: int]](count)\n        for i, p in ps:\n            if\
    \ result.xs.len == 0 or result.xs[^1] != p[0]:\n                result.xs.add(p[0])\n\
    \                result.pointOffsets.add(i)\n            result.pointYs[i] = p[1]\n\
    \            when compiles(p[2]): result.pointValues[i] = p[2]\n            ranked[i]\
    \ = (p[1], result.xs.len)\n        result.pointOffsets.add(count)\n        let\
    \ n = result.xs.len\n        ranked.sort(proc(a, b: tuple[y: K, x: int]): int\
    \ =\n            if a.y < b.y: -1\n            elif b.y < a.y: 1\n           \
    \ else: 0)\n        result.offsets = newSeq[int](n + 2)\n        var cursor =\
    \ newSeq[int](n + 1)\n        cursor.fill(-1)\n        # \u5FC5\u8981\u306A\u5EA7\
    \u6A19\u6570\u3092\u6570\u3048\u3066\u304B\u3089\u3001\u5185\u5074\u306E\u914D\
    \u5217\u3092\u4E00\u5EA6\u3060\u3051\u78BA\u4FDD\u3057\u307E\u3059\u3002\n   \
    \     for i, p in ranked:\n            var node = p.x\n            while node\
    \ <= n:\n                if cursor[node] != -1 and ranked[cursor[node]].y == p.y:\
    \ break\n                inc result.offsets[node + 1]\n                cursor[node]\
    \ = i\n                node += node and -node\n        for i in 1..n + 1: result.offsets[i]\
    \ += result.offsets[i - 1]\n        result.ys = newSeq[K](result.offsets[n + 1])\n\
    \        result.data = newSeq[T](result.ys.len)\n        cursor.fill(0)\n    \
    \    when compiles(ps[0][2]):\n            var pointCursor = newSeq[int](n)\n\
    \        for p in ranked:\n            var node = p.x\n            when compiles(ps[0][2]):\n\
    \                let xi = p.x - 1\n                let value = result.pointValues[result.pointOffsets[xi]\
    \ + pointCursor[xi]]\n                inc pointCursor[xi]\n            while node\
    \ <= n:\n                let start = result.offsets[node]\n                if\
    \ cursor[node] > 0 and result.ys[start + cursor[node] - 1] == p.y:\n         \
    \           when compiles(ps[0][2]): result.data[start + cursor[node] - 1] +=\
    \ value\n                    else: break\n                else:\n            \
    \        let index = start + cursor[node]\n                    result.ys[index]\
    \ = p.y\n                    when compiles(ps[0][2]): result.data[index] += value\n\
    \                    inc cursor[node]\n                node += node and -node\n\
    \        when compiles(ps[0][2]):\n            for node in 1..n:\n           \
    \     let start = result.offsets[node]\n                let size = result.offsets[node\
    \ + 1] - start\n                for i in 0..<size:\n                    let parent\
    \ = i or (i + 1)\n                    if parent < size: result.data[start + parent]\
    \ += result.data[start + i]\n\n    proc initCompressedFenwick2D*[K, T](points:\
    \ openArray[(K, K)]): CompressedFenwick2D[K, T] =\n        ## \u66F4\u65B0\u70B9\
    \u3092\u4E8B\u524D\u767B\u9332\u3057\u3001\u5168\u70B9\u3092\u96F6\u3067\u521D\
    \u671F\u5316\u3057\u307E\u3059\u3002\u6642\u9593\u30FB\u7A7A\u9593O(N log N)\u3002\
    \n        ## \u91CD\u8907\u70B9\u306F\u4E00\u3064\u306B\u307E\u3068\u3081\u307E\
    \u3059\u3002K\u306B\u306F\u4E00\u8CAB\u3057\u305F < \u3068 == \u304C\u5FC5\u8981\
    \u3067\u3059\u3002\n        ## \u5185\u5074\u306E\u5EA7\u6A19\u6570\u306E\u7DCF\
    \u548C\u3092M\u3068\u3059\u308B\u3068\u3001\u5EA7\u6A19\u30FB\u5024\u3092\u5404\
    M\u500B\u3068\u3001\u767B\u9332\u70B9\u306E\u7D22\u5F15\u30FB\u5024\u3092O(N)\u500B\
    \u4FDD\u6301\u3057\u307E\u3059\u3002\n        initCompressedFenwick2DImpl[K, T,\
    \ (K, K)](points)\n\n    proc initCompressedFenwick2D*[K](points: seq[(K, K)]):\
    \ CompressedFenwick2D[K, int] =\n        ## seq\u304B\u3089\u5EA7\u6A19\u578B\u3092\
    \u63A8\u8AD6\u3057\u3001\u548C\u3092int\u3067\u4FDD\u6301\u3059\u308B\u6728\u3092\
    \u6642\u9593\u30FB\u7A7A\u9593O(N log N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\
    \n        initCompressedFenwick2D[K, int](points.toOpenArray(0, points.len - 1))\n\
    \n    proc initCompressedFenwick2D*[K; N: static[int]](points: array[N, (K, K)]):\
    \ CompressedFenwick2D[K, int] =\n        ## array\u304B\u3089\u5EA7\u6A19\u578B\
    \u3092\u63A8\u8AD6\u3057\u3001\u548C\u3092int\u3067\u4FDD\u6301\u3059\u308B\u6728\
    \u3092\u6642\u9593\u30FB\u7A7A\u9593O(N log N)\u3067\u69CB\u7BC9\u3057\u307E\u3059\
    \u3002\n        initCompressedFenwick2D[K, int](points.toOpenArray(0, points.len\
    \ - 1))\n\n    proc initCompressedFenwick2D*[K, T](points: openArray[(K, K, T)]):\
    \ CompressedFenwick2D[K, T] =\n        ## (x,y,w)\u306E\u5217\u304B\u3089\u6642\
    \u9593\u30FB\u7A7A\u9593O(N log N)\u3067\u4E00\u62EC\u69CB\u7BC9\u3057\u307E\u3059\
    \u3002\u540C\u3058\u5EA7\u6A19\u306E\u91CD\u307F\u306F\u52A0\u7B97\u3057\u307E\
    \u3059\u3002\n        ## \u5EA7\u6A19\u578BK\u3068\u548C\u306E\u578BT\u306F\u5F15\
    \u6570\u304B\u3089\u63A8\u8AD6\u3057\u307E\u3059\u3002\u91CD\u307F\u304C\u96F6\
    \u306E\u70B9\u3082\u767B\u9332\u3057\u307E\u3059\u3002\n        initCompressedFenwick2DImpl[K,\
    \ T, (K, K, T)](points)\n\n    proc lowerIndex[K](coords: seq[K], start, finish:\
    \ int, y: K): int {.inline.} =\n        ## \u5EA7\u6A19\u5217\u306E\u6307\u5B9A\
    \u533A\u9593\u3067lowerBound\u3092\u6C42\u3081\u3001\u533A\u9593\u5185\u306E\u6DFB\
    \u5B57\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        var l = start\n\
    \        var r = finish\n        while l < r:\n            let m = (l + r) shr\
    \ 1\n            if coords[m] < y: l = m + 1\n            else: r = m\n      \
    \  l - start\n\n    proc yIndex[K, T](self: CompressedFenwick2D[K, T], node: int,\
    \ y: K): int {.inline.} =\n        ## \u30CE\u30FC\u30C9\u5185\u306Ey\u306ElowerBound\u3092\
    O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        lowerIndex(self.ys, self.offsets[node],\
    \ self.offsets[node + 1], y)\n\n    proc pointIndex[K, T](self: CompressedFenwick2D[K,\
    \ T], xi: int, y: K): int {.inline.} =\n        ## x\u306E\u6DFB\u5B57\u3068y\u306B\
    \u5BFE\u5FDC\u3059\u308B\u767B\u9332\u70B9\u306E\u6DFB\u5B57\u3092O(log N)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\u672A\u767B\u9332\u306A\u3089-1\u3067\u3059\u3002\
    \n        let start = self.pointOffsets[xi]\n        let finish = self.pointOffsets[xi\
    \ + 1]\n        let i = start + lowerIndex(self.pointYs, start, finish, y)\n \
    \       if i < finish and self.pointYs[i] == y: i\n        else: -1\n\n    proc\
    \ addImpl[K, T](self: CompressedFenwick2D[K, T], xi: int, y: K, delta: T) =\n\
    \        ## x\u306E\u6DFB\u5B57\u304C\u65E2\u77E5\u306E\u767B\u9332\u70B9\u3092\
    O(log\xB2 N)\u3067\u52A0\u7B97\u3057\u307E\u3059\u3002\n        mixin `+=`\n \
    \       var node = xi + 1\n        while node <= self.xs.len:\n            let\
    \ start = self.offsets[node]\n            let size = self.offsets[node + 1] -\
    \ start\n            var i = self.yIndex(node, y)\n            while i < size:\n\
    \                self.data[start + i] += delta\n                i = i or (i +\
    \ 1)\n            node += node and -node\n\n    proc add*[K, T](self: CompressedFenwick2D[K,\
    \ T], x, y: K, delta: T) =\n        ## \u767B\u9332\u70B9(x,y)\u306Bdelta\u3092\
    O(log\xB2 N)\u3067\u52A0\u7B97\u3057\u307E\u3059\u3002\u672A\u767B\u9332\u70B9\
    \u306F\u66F4\u65B0\u3067\u304D\u307E\u305B\u3093\u3002\n        mixin `+=`\n \
    \       let xi = self.xs.lowerBound(x)\n        assert xi < self.xs.len and self.xs[xi]\
    \ == x, \"\u66F4\u65B0\u3059\u308B\u5EA7\u6A19\u306F\u4E8B\u524D\u767B\u9332\u3057\
    \u3066\u304F\u3060\u3055\u3044\"\n        let pi = self.pointIndex(xi, y)\n  \
    \      assert pi >= 0, \"\u66F4\u65B0\u3059\u308B\u5EA7\u6A19\u306F\u4E8B\u524D\
    \u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\"\n        self.pointValues[pi]\
    \ += delta\n        self.addImpl(xi, y, delta)\n\n    proc innerSum[K, T](self:\
    \ CompressedFenwick2D[K, T], node, l, r: int): T {.inline.} =\n        ## \u5185\
    \u5074\u306E\u6DFB\u5B57\u533A\u9593[l,r)\u306E\u548C\u3092O(log N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\u5171\u901A\u306E\u7956\u5148\u306F\u8D70\u67FB\u3057\
    \u307E\u305B\u3093\u3002\n        mixin `+=`, `-`\n        let start = self.offsets[node]\n\
    \        var l = l\n        var r = r\n        var left: T\n        while r >\
    \ l:\n            result += self.data[start + r - 1]\n            r = r and (r\
    \ - 1)\n        while l > r:\n            left += self.data[start + l - 1]\n \
    \           l = l and (l - 1)\n        result = result - left\n\n    proc prefix*[K,\
    \ T](self: CompressedFenwick2D[K, T], xUpper, yUpper: K): T =\n        ## x<xUpper\u304B\
    \u3064y<yUpper\u3092\u6E80\u305F\u3059\u767B\u9332\u70B9\u306E\u548C\u3092O(log\xB2\
    \ N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        mixin `+=`\n        var node\
    \ = self.xs.lowerBound(xUpper)\n        while node > 0:\n            result +=\
    \ self.innerSum(node, 0, self.yIndex(node, yUpper))\n            node = node and\
    \ (node - 1)\n\n    proc getLess*[K, T](self: CompressedFenwick2D[K, T], xl, xr,\
    \ yUpper: K): T =\n        ## xl<=x<xr\u304B\u3064y<yUpper\u3092\u6E80\u305F\u3059\
    \u767B\u9332\u70B9\u306E\u548C\u3092O(log\xB2 N)\u3067\u8FD4\u3057\u307E\u3059\
    \u3002\n        mixin `+=`, `-`\n        assert not (xr < xl), \"\u533A\u9593\u306E\
    \u5DE6\u7AEF\u306F\u53F3\u7AEF\u4EE5\u4E0B\u306B\u3057\u3066\u304F\u3060\u3055\
    \u3044\"\n        var l = self.xs.lowerBound(xl)\n        var r = self.xs.lowerBound(xr)\n\
    \        var left: T\n        while r > l:\n            result += self.innerSum(r,\
    \ 0, self.yIndex(r, yUpper))\n            r = r and (r - 1)\n        while l >\
    \ r:\n            left += self.innerSum(l, 0, self.yIndex(l, yUpper))\n      \
    \      l = l and (l - 1)\n        result = result - left\n\n    proc get*[K, T](self:\
    \ CompressedFenwick2D[K, T], xl, xr, yl, yr: K): T =\n        ## [xl,xr)\xD7[yl,yr)\u306E\
    \u548C\u3092O(log\xB2 N)\u3067\u8FD4\u3057\u307E\u3059\u3002\u5883\u754C\u306F\
    \u672A\u767B\u9332\u3067\u3082\u69CB\u3044\u307E\u305B\u3093\u3002\n        ##\
    \ x\u65B9\u5411\u30FBy\u65B9\u5411\u3068\u3082\u5171\u901A\u306E\u7956\u5148\u306E\
    \u8D70\u67FB\u3092\u7701\u304D\u307E\u3059\u3002\n        mixin `+=`, `-`\n  \
    \      assert not (xr < xl) and not (yr < yl), \"\u533A\u9593\u306E\u5DE6\u7AEF\
    \u306F\u53F3\u7AEF\u4EE5\u4E0B\u306B\u3057\u3066\u304F\u3060\u3055\u3044\"\n \
    \       if not (yl < yr): return\n        var l = self.xs.lowerBound(xl)\n   \
    \     var r = self.xs.lowerBound(xr)\n        var left: T\n        while r > l:\n\
    \            result += self.innerSum(r, self.yIndex(r, yl), self.yIndex(r, yr))\n\
    \            r = r and (r - 1)\n        while l > r:\n            left += self.innerSum(l,\
    \ self.yIndex(l, yl), self.yIndex(l, yr))\n            l = l and (l - 1)\n   \
    \     result = result - left\n\n    proc `[]`*[K, T](self: CompressedFenwick2D[K,\
    \ T], x, y: K): T =\n        ## \u70B9\u306E\u5024\u3092O(log N)\u3067\u8FD4\u3057\
    \u307E\u3059\u3002\u672A\u767B\u9332\u306A\u3089\u96F6\u3067\u3059\u3002\n   \
    \     let xi = self.xs.lowerBound(x)\n        if xi == self.xs.len or self.xs[xi]\
    \ != x: return\n        let pi = self.pointIndex(xi, y)\n        if pi >= 0: result\
    \ = self.pointValues[pi]\n\n    proc `[]=`*[K, T](self: CompressedFenwick2D[K,\
    \ T], x, y: K, value: T) =\n        ## \u767B\u9332\u70B9(x,y)\u3092O(log\xB2\
    \ N)\u3067\u4E0A\u66F8\u304D\u3057\u307E\u3059\u3002\n        mixin `-`\n    \
    \    let xi = self.xs.lowerBound(x)\n        assert xi < self.xs.len and self.xs[xi]\
    \ == x, \"\u66F4\u65B0\u3059\u308B\u5EA7\u6A19\u306F\u4E8B\u524D\u767B\u9332\u3057\
    \u3066\u304F\u3060\u3055\u3044\"\n        let pi = self.pointIndex(xi, y)\n  \
    \      assert pi >= 0, \"\u66F4\u65B0\u3059\u308B\u5EA7\u6A19\u306F\u4E8B\u524D\
    \u767B\u9332\u3057\u3066\u304F\u3060\u3055\u3044\"\n        let delta = value\
    \ - self.pointValues[pi]\n        self.pointValues[pi] = value\n        self.addImpl(xi,\
    \ y, delta)\n\n    proc get_all*[K, T](self: CompressedFenwick2D[K, T]): T =\n\
    \        ## \u5168\u767B\u9332\u70B9\u306E\u548C\u3092O(log\xB2 N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        mixin `+=`\n        var node = self.xs.len\n\
    \        while node > 0:\n            result += self.innerSum(node, 0, self.offsets[node\
    \ + 1] - self.offsets[node])\n            node = node and (node - 1)\n\n    proc\
    \ len*[K, T](self: CompressedFenwick2D[K, T]): int {.inline.} =\n        ## \u91CD\
    \u8907\u9664\u53BB\u5F8C\u306E\u767B\u9332\u70B9\u6570\u3092O(1)\u3067\u8FD4\u3057\
    \u307E\u3059\u3002\n        self.pointYs.len\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/compressed_fenwick2d.nim
  requiredBy: []
  timestamp: '2026-09-18 00:52:17+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/compressed_fenwick2d_test.nim
  - verify/AI/compressed_fenwick2d_test.nim
documentation_of: cplib/collections/compressed_fenwick2d.nim
layout: document
redirect_from:
- /library/cplib/collections/compressed_fenwick2d.nim
- /library/cplib/collections/compressed_fenwick2d.nim.html
title: cplib/collections/compressed_fenwick2d.nim
---
