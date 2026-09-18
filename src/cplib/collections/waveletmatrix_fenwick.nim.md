---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/fenwick_avx2.nim
    title: cplib/collections/fenwick_avx2.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/backwards_index.nim
    title: cplib/utils/backwards_index.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/waveletmatrix_fenwick_test.nim
    title: verify/AI/waveletmatrix_fenwick_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/waveletmatrix_fenwick_test.nim
    title: verify/AI/waveletmatrix_fenwick_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_simd_test.nim
    title: verify/utils/backwards_index_simd_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/backwards_index_simd_test.nim
    title: verify/utils/backwards_index_simd_test.nim
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
  code: "## a_i\u3092\u56FA\u5B9A\u3057\u3001b_i\u3092\u66F4\u65B0\u3067\u304D\u308B\
    \u91CD\u307F\u4ED8\u304DWavelet Matrix\u3067\u3059\u3002\n## \u5024\u3092\u5EA7\
    \u6A19\u5727\u7E2E\u3057\u3001\u5404\u6BB5\u306E\u4E26\u3079\u66FF\u3048\u5F8C\
    \u306E\u91CD\u307F\u3092\u5408\u8A08H\u672C\u306EAVX2\u7248BIT\u3067\u7BA1\u7406\
    \u3057\u307E\u3059\u3002\n## H = ceil(log2(max(2, \u7570\u306A\u308B\u5024\u306E\
    \u6570)))\u3068\u3057\u3066\u3001\u66F4\u65B0\u30FB\u533A\u9593\u548C\u306FO(H\
    \ log N)\u3067\u3059\u3002\nwhen not declared CPLIB_COLLECTIONS_WAVELETMATRIX_FENWICK:\n\
    \    const CPLIB_COLLECTIONS_WAVELETMATRIX_FENWICK* = 1\n    import cplib/utils/backwards_index\n\
    \    import algorithm, bitops, sequtils\n    import cplib/collections/waveletmatrix\n\
    \    import cplib/collections/fenwick_avx2\n\n    type WaveletMatrixFenwick* =\
    \ ref object\n        matrix: WaveletMatrix\n        keys: seq[int]\n        weights:\
    \ seq[int]\n        bits: seq[FenwickTreeAvx2]\n\n    proc initWaveletMatrixFenwick*(values:\
    \ openArray[(int, int)]): WaveletMatrixFenwick =\n        ## (a_i, b_i)\u304B\u3089\
    O(N log N + NH)\u6642\u9593\u30FBO(NH)\u9818\u57DF\u3067\u69CB\u7BC9\u3057\u307E\
    \u3059\u3002\n        result = WaveletMatrixFenwick(weights: newSeq[int](values.len))\n\
    \        for i, value in values:\n            result.keys.add(value[0])\n    \
    \        result.weights[i] = value[1]\n        result.keys.sort()\n        result.keys\
    \ = result.keys.deduplicate(true)\n        let height = if result.keys.len <=\
    \ 1: 1 else: fastLog2(result.keys.len - 1) + 1\n        var codes = newSeq[int](values.len)\n\
    \        for i, value in values:\n            codes[i] = result.keys.lowerBound(value[0])\n\
    \        result.matrix = initWaveletMatrix(codes, height)\n        result.bits\
    \ = newSeq[FenwickTreeAvx2](height)\n        var weights = result.weights\n  \
    \      var next = newSeq[int](values.len)\n        for h in countdown(height -\
    \ 1, 0):\n            for i in 0..<values.len:\n                let (l0, r0, l1,\
    \ _) = result.matrix.get_child(h, i, i + 1)\n                let p = if l0 < r0:\
    \ l0 else: l1\n                next[p] = weights[i]\n            result.bits[h]\
    \ = initFenwickTreeAvx2(next)\n            swap(weights, next)\n\n    proc len*(self:\
    \ WaveletMatrixFenwick): int =\n        ## \u8981\u7D20\u6570\u3092O(1)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        self.weights.len\n\n    proc `[]`*(self: WaveletMatrixFenwick,\
    \ i: int): int {.backwardsIndex.} =\n        ## \u73FE\u5728\u306Eb_i\u3092O(1)\u3067\
    \u8FD4\u3057\u307E\u3059\u3002\n        assert 0 <= i and i < self.len, \"\u6307\
    \u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= i and i < self.len\"\n\
    \        self.weights[i]\n\n    proc add*(self: WaveletMatrixFenwick, i, delta:\
    \ int) =\n        ## b_i\u306Bdelta\u3092\u52A0\u3048\u307E\u3059\u3002O(H log\
    \ N)\u3067\u3059\u3002\n        assert 0 <= i and i < self.len, \"\u6307\u5B9A\
    \u3057\u305F\u5024\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\
    \u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= i and i < self.len\"\n      \
    \  self.weights[i] += delta\n        var p = i\n        for h in countdown(self.bits.len\
    \ - 1, 0):\n            let (l0, r0, l1, _) = self.matrix.get_child(h, p, p +\
    \ 1)\n            p = if l0 < r0: l0 else: l1\n            self.bits[h].add(p,\
    \ delta)\n\n    proc `[]=`*(self: WaveletMatrixFenwick, i: int, value: int) {.backwardsIndex.}\
    \ =\n        ## b_i\u3092value\u306B\u5909\u66F4\u3057\u307E\u3059\u3002O(H log\
    \ N)\u3067\u3059\u3002\n        self.add(i, value - self[i])\n\n    proc range_sum*(self:\
    \ WaveletMatrixFenwick, l, r: int): int =\n        ## l <= i < r\u3092\u6E80\u305F\
    \u3059b_i\u306E\u7DCF\u548C\u3092O(log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n\
    \        assert 0 <= l and l <= r and r <= self.len, \"\u6307\u5B9A\u3057\u305F\
    \u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\
    \u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.len\"\n\
    \        let h = self.bits.len - 1\n        let (l0, r0, l1, r1) = self.matrix.get_child(h,\
    \ l, r)\n        self.bits[h].get(l0, r0) + self.bits[h].get(l1, r1)\n\n    proc\
    \ sum_less_rank(self: WaveletMatrixFenwick, l, r, k: int): int =\n        ## [l,\
    \ r)\u5185\u306E\u5727\u7E2E\u5024\u304Ck\u672A\u6E80\u306E\u91CD\u307F\u548C\u3092\
    O(H log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\n        assert 0 <= l and l <=\
    \ r and r <= self.len, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\u304C\u6709\u52B9\
    \u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\
    \u3059: 0 <= l and l <= r and r <= self.len\"\n        if k == 0 or l == r:\n\
    \            return 0\n        if k == self.keys.len:\n            return self.range_sum(l,\
    \ r)\n        var l = l\n        var r = r\n        for h in countdown(self.bits.len\
    \ - 1, 0):\n            let (l0, r0, l1, r1) = self.matrix.get_child(h, l, r)\n\
    \            if k.testBit(h):\n                result += self.bits[h].get(l0,\
    \ r0)\n                l = l1\n                r = r1\n            else:\n   \
    \             l = l0\n                r = r0\n\n    proc range_sum*(self: WaveletMatrixFenwick,\
    \ l, r, x: int): int =\n        ## l <= i < r\u304B\u3064a_i <= x\u3092\u6E80\u305F\
    \u3059b_i\u306E\u7DCF\u548C\u3092O(H log N)\u3067\u8FD4\u3057\u307E\u3059\u3002\
    \n        self.sum_less_rank(l, r, self.keys.upperBound(x))\n\n    proc range_sum*(self:\
    \ WaveletMatrixFenwick, l, r, lower, upper: int): int =\n        ## l <= i < r\u304B\
    \u3064lower <= a_i < upper\u306E\u91CD\u307F\u548C\u3092O(H log N)\u3067\u8FD4\
    \u3057\u307E\u3059\u3002\n        assert lower <= upper, \"\u7BC4\u56F2\u306E\u4E0B\
    \u9650\u306F\u4E0A\u9650\u4EE5\u4E0B\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\
    \u308A\u307E\u3059\"\n        self.sum_less_rank(l, r, self.keys.lowerBound(upper))\
    \ -\n            self.sum_less_rank(l, r, self.keys.lowerBound(lower))\n"
  dependsOn:
  - cplib/utils/backwards_index.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/bitvector.nim
  - cplib/collections/fenwick_avx2.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/utils/backwards_index.nim
  - cplib/collections/fenwick_avx2.nim
  isVerificationFile: false
  path: cplib/collections/waveletmatrix_fenwick.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/backwards_index_simd_test.nim
  - verify/utils/backwards_index_simd_test.nim
  - verify/AI/waveletmatrix_fenwick_test.nim
  - verify/AI/waveletmatrix_fenwick_test.nim
documentation_of: cplib/collections/waveletmatrix_fenwick.nim
layout: document
redirect_from:
- /library/cplib/collections/waveletmatrix_fenwick.nim
- /library/cplib/collections/waveletmatrix_fenwick.nim.html
title: cplib/collections/waveletmatrix_fenwick.nim
---
