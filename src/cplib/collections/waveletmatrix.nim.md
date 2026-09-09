---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/waveletmatrix_test.nim
    title: verify/AI/waveletmatrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/waveletmatrix_test.nim
    title: verify/AI/waveletmatrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/waveletmatrix_test.nim
    title: verify/collections/waveletmatrix_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/waveletmatrix_test.nim
    title: verify/collections/waveletmatrix_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_WAVELETMATRIX:\n    const CPLIB_COLLECTIONS_WAVELETMATRIX*\
    \ = 1\n    import cplib/collections/bitvector\n    import sequtils\n    import\
    \ bitops\n    import options\n\n    type WaveletMatrix* = ref object\n       \
    \ dat : seq[BitVector]\n        H : int\n        N : int\n        with_sum : bool\n\
    \        zero_sum : seq[seq[int]]\n    \n    proc initWaveletMatrix*(v:openArray[int],H:int\
    \ = -1,with_sum:bool = false):WaveletMatrix=\n        ## \u975E\u8CA0\u6574\u6570\
    \u5217\u304B\u3089 O(NH) \u6642\u9593\u3067\u69CB\u7BC9\u3059\u308B\u3002H \u306F\
    \u5168\u8981\u7D20\u3092\u8868\u73FE\u3067\u304D\u308B\u30D3\u30C3\u30C8\u6570\
    \u3067\u3001-1 \u306A\u3089\u81EA\u52D5\u8A2D\u5B9A\u3059\u308B\u3002\n      \
    \  ## with_sum=true \u306A\u3089\u7DCF\u548C\u53D6\u5F97\u7528\u306B O(NH) \u500B\
    \u306E int \u3092\u8FFD\u52A0\u3059\u308B\u3002\u7DCF\u548C\u306F int \u306B\u53CE\
    \u307E\u308B\u5FC5\u8981\u304C\u3042\u308B\u3002\n        var v = @v\n       \
    \ var N = len(v)\n        var H = H\n        if H == -1:\n            if N ==\
    \ 0:\n                H = 0\n            elif max(v) == 0:\n                H\
    \ = 1\n            else:\n                H = fastLog2(max(v))+1\n        result\
    \ = WaveletMatrix(dat:newSeqWith(H,newBitVector(N)),N:N,H:H,with_sum:with_sum)\n\
    \        if with_sum:\n            result.zero_sum = newSeqWith(H,newSeq[int](N+1))\n\
    \        var zero = newSeqWith(N,-1)\n        var one = newSeqWith(N,-1)\n   \
    \     var a = 0\n        var b = 0\n        for h in countdown(H-1,0,1):\n   \
    \         for i in 0..<N:\n                if v[i].testBit(h):\n             \
    \       one[b] = v[i]\n                    b += 1\n                    result.dat[h].set(i)\n\
    \                else:\n                    zero[a] = v[i]\n                 \
    \   a += 1\n                if with_sum:\n                    result.zero_sum[h][i+1]\
    \ = result.zero_sum[h][i]\n                    if not v[i].testBit(h):\n     \
    \                   result.zero_sum[h][i+1] += v[i]\n            for i in 0..<a:\n\
    \                v[i] = zero[i]\n            for i in 0..<b:\n               \
    \ v[a+i] = one[i]\n            a = 0\n            b = 0\n            result.dat[h].build()\n\
    \    \n    proc get_child*(self:WaveletMatrix,h,l,r:int):tuple[l0,r0,l1,r1:int]=\n\
    \        ## \u9AD8\u3055 h+1 \u306E\u533A\u9593 [l,r) \u306B\u5BFE\u5FDC\u3059\
    \u308B\u5B50\u306E\u533A\u9593\u3092 O(1) \u3067\u8FD4\u3059\u3002\n        #\
    \ \u9AD8\u3055h+1\u306B\u304A\u3051\u308B[l,r)\u306B\u8A72\u5F53\u3059\u308B\u90E8\
    \u5206\u3092\u898B\u3066\u3044\u308B\u3068\u3059\u308B\u3002\n        # \u305D\
    \u306E\u5B50\u306B\u8A72\u5F53\u3059\u308B\u90E8\u5206\u3092[l0,r0),[l1,r1)\u3068\
    \u3057\u305F\u3068\u304D\u3001(l0,r0,l1,r1)\u3092\u8FD4\u3059\u3002\n        var\
    \ c0  = self.N - self.dat[h].rank(self.N)\n        result.l0 = l - self.dat[h].rank(l)\n\
    \        result.r0 = r - self.dat[h].rank(r)\n        result.l1 = self.dat[h].rank(l)\
    \ + c0\n        result.r1 = self.dat[h].rank(r) + c0\n\n    \n    proc kth_smallest*(self:WaveletMatrix,l,r,k:int):int=\n\
    \        ## [l,r) \u5185\u3067\u5C0F\u3055\u3044\u9806\u306B k \u756A\u76EE\u306E\
    \u5024\u3092 O(H) \u3067\u8FD4\u3059\u3002k \u306F 0-indexed\u3002\n        var\
    \ k = k\n        var l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n\
    \            var (l0,r0,l1,r1) = self.get_child(h,l,r)\n            if k < r0-l0:\n\
    \                l = l0\n                r = r0\n            else:\n         \
    \       l = l1\n                r = r1\n                k -= r0-l0\n         \
    \       result += 1 shl h\n    \n    proc range_lowerbound*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u672A\u6E80\u306E\u8981\u7D20\u6570\u3092 O(H)\
    \ \u3067\u8FD4\u3059\u3002\n        if x <= 0:\n            return 0\n       \
    \ if self.H < sizeof(int) * 8 and (x shr self.H) != 0:\n            return r-l\n\
    \        var l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n\
    \            var (l0,r0,l1,r1) = self.get_child(h,l,r)\n            if x.testBit(h):\n\
    \                l = l1\n                r = r1\n                result += r0-l0\n\
    \            else:\n                l = l0\n                r = r0\n    \n   \
    \ proc range_upperbound*(self:WaveletMatrix,l,r,x:int):int=\n        ## [l,r)\
    \ \u5185\u306E x \u4EE5\u4E0B\u306E\u8981\u7D20\u6570\u3092 O(H) \u3067\u8FD4\u3059\
    \u3002\n        if x < 0:\n            return 0\n        if self.H < sizeof(int)\
    \ * 8 and (x shr self.H) != 0:\n            return r-l\n        var l = l\n  \
    \      var r = r\n        for h in countdown(self.H-1,0,1):\n            var (l0,r0,l1,r1)\
    \ = self.get_child(h,l,r)\n            if x.testBit(h):\n                l = l1\n\
    \                r = r1\n                result += r0-l0\n            else:\n\
    \                l = l0\n                r = r0\n        result += r-l\n\n   \
    \ proc prev_value*(self:WaveletMatrix,l,r,x:int):Option[int]=\n        ## [l,r)\
    \ \u5185\u306E x \u672A\u6E80\u306E\u6700\u5927\u5024\u3092 O(H) \u3067\u8FD4\u3059\
    \u3002\u5B58\u5728\u3057\u306A\u3051\u308C\u3070 none(int)\u3002\n        let\
    \ c = self.range_lowerbound(l,r,x)\n        if c == 0:\n            return none(int)\n\
    \        return some(self.kth_smallest(l,r,c-1))\n\n    proc next_value*(self:WaveletMatrix,l,r,x:int):Option[int]=\n\
    \        ## [l,r) \u5185\u306E x \u4EE5\u4E0A\u306E\u6700\u5C0F\u5024\u3092 O(H)\
    \ \u3067\u8FD4\u3059\u3002\u5B58\u5728\u3057\u306A\u3051\u308C\u3070 none(int)\u3002\
    \n        let c = self.range_lowerbound(l,r,x)\n        if c == r-l:\n       \
    \     return none(int)\n        return some(self.kth_smallest(l,r,c))\n\n    proc\
    \ range_freq*(self:WaveletMatrix,l,r,low,high:int):int=\n        ## [l,r) \u5185\
    \u3067\u5024\u304C [low,high) \u306B\u5165\u308B\u8981\u7D20\u6570\u3092 O(H)\
    \ \u3067\u8FD4\u3059\u3002low >= high \u306A\u3089 0\u3002\n        if low >=\
    \ high:\n            return 0\n        return self.range_lowerbound(l,r,high)\
    \ - self.range_lowerbound(l,r,low)\n\n    proc count*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u306E\u51FA\u73FE\u56DE\u6570\u3092 O(H) \u3067\
    \u8FD4\u3059\u3002\n        if x < 0:\n            return 0\n        if self.H\
    \ < sizeof(int) * 8 and (x shr self.H) != 0:\n            return 0\n        var\
    \ l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n      \
    \      if l == r:\n                return 0\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if x.testBit(h):\n                l = l1\n                r = r1\n\
    \            else:\n                l = l0\n                r = r0\n        return\
    \ r-l\n\n    proc kth_largest*(self:WaveletMatrix,l,r,k:int):int=\n        ##\
    \ [l,r) \u5185\u3067\u5927\u304D\u3044\u9806\u306B k \u756A\u76EE\u306E\u5024\u3092\
    \ O(H) \u3067\u8FD4\u3059\u3002k \u306F 0-indexed\u3002\n        assert 0 <= k\
    \ and k < r-l\n        return self.kth_smallest(l,r,r-l-1-k)\n\n    proc sum_smallest*(self:WaveletMatrix,l,r,k:int):int=\n\
    \        ## [l,r) \u5185\u306E\u5C0F\u3055\u3044\u65B9\u304B\u3089 k \u500B\u306E\
    \u7DCF\u548C\u3092 O(H) \u3067\u8FD4\u3059\u30020 <= k <= r-l\u3001\u69CB\u7BC9\
    \u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum\n\
    \        assert 0 <= l and l <= r and r <= self.N\n        assert 0 <= k and k\
    \ <= r-l\n        var l = l\n        var r = r\n        var k = k\n        var\
    \ value = 0\n        for h in countdown(self.H-1,0,1):\n            if k == 0:\n\
    \                return\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if k < r0-l0:\n                l = l0\n                r = r0\n \
    \           else:\n                result += self.zero_sum[h][r] - self.zero_sum[h][l]\n\
    \                k -= r0-l0\n                value += 1 shl h\n              \
    \  l = l1\n                r = r1\n        result += k * value\n\n    proc sum_upperbound*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u4EE5\u4E0B\u306E\u8981\u7D20\u306E\u7DCF\u548C\
    \u3092 1 \u56DE\u306E\u8D70\u67FB\u3067 O(H) \u3067\u8FD4\u3059\u3002\u69CB\u7BC9\
    \u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum\n\
    \        assert 0 <= l and l <= r and r <= self.N\n        if x < 0:\n       \
    \     return 0\n        if self.H < sizeof(int) * 8 and (x shr self.H) != 0:\n\
    \            return self.sum_smallest(l,r,r-l)\n        var l = l\n        var\
    \ r = r\n        for h in countdown(self.H-1,0,1):\n            if l == r:\n \
    \               return\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if x.testBit(h):\n                result += self.zero_sum[h][r] -\
    \ self.zero_sum[h][l]\n                l = l1\n                r = r1\n      \
    \      else:\n                l = l0\n                r = r0\n        result +=\
    \ (r-l) * x\n\n    proc sum_lowerbound*(self:WaveletMatrix,l,r,x:int):int=\n \
    \       ## [l,r) \u5185\u306E x \u672A\u6E80\u306E\u8981\u7D20\u306E\u7DCF\u548C\
    \u3092 1 \u56DE\u306E\u8D70\u67FB\u3067 O(H) \u3067\u8FD4\u3059\u3002\u69CB\u7BC9\
    \u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum\n\
    \        assert 0 <= l and l <= r and r <= self.N\n        if x <= 0:\n      \
    \      return 0\n        return self.sum_upperbound(l,r,x-1)\n\n    proc range_sum*(self:WaveletMatrix,l,r,low,high:int):int=\n\
    \        ## [l,r) \u5185\u3067\u5024\u304C [low,high) \u306B\u5165\u308B\u8981\
    \u7D20\u306E\u7DCF\u548C\u3092 O(H) \u3067\u8FD4\u3059\u3002low >= high \u306A\
    \u3089 0\u3002\u69CB\u7BC9\u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n\
    \        assert self.with_sum\n        assert 0 <= l and l <= r and r <= self.N\n\
    \        if low >= high:\n            return 0\n        return self.sum_lowerbound(l,r,high)\
    \ - self.sum_lowerbound(l,r,low)\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  isVerificationFile: false
  path: cplib/collections/waveletmatrix.nim
  requiredBy: []
  timestamp: '2026-09-09 17:27:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/waveletmatrix_test.nim
  - verify/collections/waveletmatrix_test.nim
  - verify/AI/waveletmatrix_test.nim
  - verify/AI/waveletmatrix_test.nim
documentation_of: cplib/collections/waveletmatrix.nim
layout: document
redirect_from:
- /library/cplib/collections/waveletmatrix.nim
- /library/cplib/collections/waveletmatrix.nim.html
title: cplib/collections/waveletmatrix.nim
---
