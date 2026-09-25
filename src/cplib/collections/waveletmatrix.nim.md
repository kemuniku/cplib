---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/bitvector.nim
    title: cplib/collections/bitvector.nim
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix_fenwick.nim
    title: cplib/collections/waveletmatrix_fenwick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix_fenwick.nim
    title: cplib/collections/waveletmatrix_fenwick.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/waveletmatrix_fenwick_test.nim
    title: verify/AI/waveletmatrix_fenwick_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/waveletmatrix_fenwick_test.nim
    title: verify/AI/waveletmatrix_fenwick_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_WAVELETMATRIX:\n    const CPLIB_COLLECTIONS_WAVELETMATRIX*\
    \ = 1\n    import cplib/collections/bitvector\n    import sequtils\n    import\
    \ bitops\n    import options\n\n    # release\u3067\u3082debug\u6307\u5B9A\u6642\
    \u306F\u5883\u754C\u30FB\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u30C1\u30A7\
    \u30C3\u30AF\u3092\u6B8B\u3059\u3002\n    when defined(release) and not defined(debug):\n\
    \        {.push boundChecks: off, overflowChecks: off.}\n\n    const scanLimit\
    \ = 64\n\n    type\n        WaveletLevel = object\n            bits : BitVector\n\
    \            zero_count : int\n            zero_sum : seq[int]\n        WaveletMatrix*\
    \ = ref object\n            dat : seq[WaveletLevel]\n            H : int\n   \
    \         N : int\n            with_sum : bool\n            scan_h : int\n   \
    \         scan_values : seq[int]\n\n    proc initWaveletMatrix*(v:openArray[int],H:int\
    \ = -1,with_sum:bool = false):WaveletMatrix=\n        ## \u975E\u8CA0\u6574\u6570\
    \u5217\u304B\u3089 O(NH) \u6642\u9593\u3067\u69CB\u7BC9\u3059\u308B\u3002H \u306F\
    \u5168\u8981\u7D20\u3092\u8868\u73FE\u3067\u304D\u308B\u30D3\u30C3\u30C8\u6570\
    \u3067\u3001-1 \u306A\u3089\u81EA\u52D5\u8A2D\u5B9A\u3059\u308B\u3002\n      \
    \  ## \u4E0B\u4F4D\u5C64\u306E\u77ED\u7E2E\u7528\u306B\u6700\u5927 O(N) \u500B\
    \u306E int \u3092\u4FDD\u5B58\u3059\u308B\u3002\n        ## with_sum=true \u306A\
    \u3089\u7DCF\u548C\u53D6\u5F97\u7528\u306B O(NH) \u500B\u306E int \u3092\u8FFD\
    \u52A0\u3059\u308B\u3002\u7DCF\u548C\u306F int \u306B\u53CE\u307E\u308B\u5FC5\u8981\
    \u304C\u3042\u308B\u3002\n        var v = @v\n        var N = len(v)\n       \
    \ var H = H\n        if H == -1:\n            if N == 0:\n                H =\
    \ 0\n            elif max(v) == 0:\n                H = 1\n            else:\n\
    \                H = fastLog2(max(v))+1\n        assert 0 <= H and H <= sizeof(int)\
    \ * 8, \"H\u306Fint\u306E\u30D3\u30C3\u30C8\u6570\u4EE5\u4E0B\u306E\u975E\u8CA0\
    \u6574\u6570\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n \
    \       result = WaveletMatrix(dat:newSeq[WaveletLevel](H),N:N,H:H,with_sum:with_sum)\n\
    \        for level in result.dat.mitems:\n            level.bits = newBitVector(N)\n\
    \        var width = N\n        var depth = 0\n        while width > scanLimit:\n\
    \            width = (width shr 1) + (width and 1)\n            inc depth\n  \
    \      result.scan_h = H-depth-1\n        # \u5C0F\u533A\u9593\u306B\u306A\u3063\
    \u305F\u5C64\u306E\u4E26\u3073\u3092\u4FDD\u5B58\u3057\u3001\u4E0B\u4F4D\u306E\
    \u9577\u3044rank\u8D70\u67FB\u3092\u7701\u304F\u3002\n        if result.scan_h\
    \ < 6:\n            result.scan_h = -1\n        var zero = newSeq[int](N)\n  \
    \      var one = newSeq[int](N)\n        var a = 0\n        var b = 0\n      \
    \  for h in countdown(H-1,0,1):\n            if h == result.scan_h:\n        \
    \        result.scan_values = newSeq[int](N)\n                for i in 0..<N:\n\
    \                    result.scan_values[i] = v[i]\n            let bit_mask =\
    \ 1 shl h\n            var word = 0'u64\n            for i in 0..<N:\n       \
    \         let value = v[i]\n                let bit = int((value and bit_mask)\
    \ != 0)\n                # \u4E21\u5074\u306B\u66F8\u304D\u3001\u8A72\u5F53\u5074\
    \u306E\u4F4D\u7F6E\u3060\u3051\u9032\u3081\u3066\u5206\u5C90\u3092\u907F\u3051\
    \u308B\u3002\n                zero[a] = value\n                one[b] = value\n\
    \                a += 1-bit\n                b += bit\n                word =\
    \ word or (uint64(bit) shl (i and 63))\n                if (i and 63) == 63:\n\
    \                    result.dat[h].bits.setWord(i shr 6,word)\n              \
    \      word = 0\n            if (N and 63) != 0:\n                result.dat[h].bits.setWord(N\
    \ shr 6,word)\n            if with_sum:\n                result.dat[h].zero_sum\
    \ = newSeq[int](a+1)\n                var zero_total = 0\n                for\
    \ i in 0..<a:\n                    zero_total += zero[i]\n                   \
    \ result.dat[h].zero_sum[i+1] = zero_total\n            result.dat[h].zero_count\
    \ = a\n            for i in 0..<a:\n                v[i] = zero[i]\n         \
    \   for i in 0..<b:\n                v[a+i] = one[i]\n            a = 0\n    \
    \        b = 0\n            result.dat[h].bits.build()\n    \n    proc get_child*(self:WaveletMatrix,h,l,r:int):tuple[l0,r0,l1,r1:int]\
    \ {.inline.} =\n        ## \u9AD8\u3055 h+1 \u306E\u533A\u9593 [l,r) \u306B\u5BFE\
    \u5FDC\u3059\u308B\u5B50\u306E\u533A\u9593\u3092 O(1) \u3067\u8FD4\u3059\u3002\
    \n        # \u9AD8\u3055h+1\u306B\u304A\u3051\u308B[l,r)\u306B\u8A72\u5F53\u3059\
    \u308B\u90E8\u5206\u3092\u898B\u3066\u3044\u308B\u3068\u3059\u308B\u3002\n   \
    \     # \u305D\u306E\u5B50\u306B\u8A72\u5F53\u3059\u308B\u90E8\u5206\u3092[l0,r0),[l1,r1)\u3068\
    \u3057\u305F\u3068\u304D\u3001(l0,r0,l1,r1)\u3092\u8FD4\u3059\u3002\n        let\
    \ c0 = self.dat[h].zero_count\n        let l_rank = self.dat[h].bits.rank(l)\n\
    \        let r_rank = self.dat[h].bits.rank(r)\n        result.l0 = l - l_rank\n\
    \        result.r0 = r - r_rank\n        result.l1 = l_rank + c0\n        result.r1\
    \ = r_rank + c0\n\n    \n    proc kth_smallest*(self:WaveletMatrix,l,r,k:int):int=\n\
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
    \            if l == r:\n                return\n            if h == self.scan_h\
    \ and r-l <= scanLimit:\n                for i in l..<r:\n                   \
    \ let value = self.scan_values[i]\n                    if value < x: result +=\
    \ 1\n                return\n            var (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if ((x shr h) and 1) != 0:\n                l = l1\n            \
    \    r = r1\n                result += r0-l0\n            else:\n            \
    \    l = l0\n                r = r0\n    \n    proc range_upperbound*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u4EE5\u4E0B\u306E\u8981\u7D20\u6570\u3092 O(H)\
    \ \u3067\u8FD4\u3059\u3002\n        if x < 0:\n            return 0\n        if\
    \ self.H < sizeof(int) * 8 and (x shr self.H) != 0:\n            return r-l\n\
    \        var l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n\
    \            if l == r:\n                return\n            if h == self.scan_h\
    \ and r-l <= scanLimit:\n                for i in l..<r:\n                   \
    \ let value = self.scan_values[i]\n                    if value <= x: result +=\
    \ 1\n                return\n            var (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if ((x shr h) and 1) != 0:\n                l = l1\n            \
    \    r = r1\n                result += r0-l0\n            else:\n            \
    \    l = l0\n                r = r0\n        result += r-l\n\n    proc prev_value*(self:WaveletMatrix,l,r,x:int):Option[int]=\n\
    \        ## [l,r) \u5185\u306E x \u672A\u6E80\u306E\u6700\u5927\u5024\u3092 O(H)\
    \ \u3067\u8FD4\u3059\u3002\u5B58\u5728\u3057\u306A\u3051\u308C\u3070 none(int)\u3002\
    \n        let c = self.range_lowerbound(l,r,x)\n        if c == 0:\n         \
    \   return none(int)\n        return some(self.kth_smallest(l,r,c-1))\n\n    proc\
    \ next_value*(self:WaveletMatrix,l,r,x:int):Option[int]=\n        ## [l,r) \u5185\
    \u306E x \u4EE5\u4E0A\u306E\u6700\u5C0F\u5024\u3092 O(H) \u3067\u8FD4\u3059\u3002\
    \u5B58\u5728\u3057\u306A\u3051\u308C\u3070 none(int)\u3002\n        let c = self.range_lowerbound(l,r,x)\n\
    \        if c == r-l:\n            return none(int)\n        return some(self.kth_smallest(l,r,c))\n\
    \n    proc range_freq*(self:WaveletMatrix,l,r,low,high:int):int=\n        ## [l,r)\
    \ \u5185\u3067\u5024\u304C [low,high) \u306B\u5165\u308B\u8981\u7D20\u6570\u3092\
    \ O(H) \u3067\u8FD4\u3059\u3002low >= high \u306A\u3089 0\u3002\n        if low\
    \ >= high:\n            return 0\n        return self.range_lowerbound(l,r,high)\
    \ - self.range_lowerbound(l,r,low)\n\n    proc count*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u306E\u51FA\u73FE\u56DE\u6570\u3092 O(H) \u3067\
    \u8FD4\u3059\u3002\n        if x < 0:\n            return 0\n        if self.H\
    \ < sizeof(int) * 8 and (x shr self.H) != 0:\n            return 0\n        var\
    \ l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n      \
    \      if l == r:\n                return 0\n            if h == self.scan_h and\
    \ r-l <= scanLimit:\n                for i in l..<r:\n                    let\
    \ value = self.scan_values[i]\n                    if value == x: result += 1\n\
    \                return\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if ((x shr h) and 1) != 0:\n                l = l1\n            \
    \    r = r1\n            else:\n                l = l0\n                r = r0\n\
    \        return r-l\n\n    proc kth_largest*(self:WaveletMatrix,l,r,k:int):int=\n\
    \        ## [l,r) \u5185\u3067\u5927\u304D\u3044\u9806\u306B k \u756A\u76EE\u306E\
    \u5024\u3092 O(H) \u3067\u8FD4\u3059\u3002k \u306F 0-indexed\u3002\n        assert\
    \ 0 <= k and k < r-l, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : 0 <= k and k < r - l\"\n        return self.kth_smallest(l,r,r-l-1-k)\n\n  \
    \  proc sum_smallest*(self:WaveletMatrix,l,r,k:int):int=\n        ## [l,r) \u5185\
    \u306E\u5C0F\u3055\u3044\u65B9\u304B\u3089 k \u500B\u306E\u7DCF\u548C\u3092 O(H)\
    \ \u3067\u8FD4\u3059\u30020 <= k <= r-l\u3001\u69CB\u7BC9\u6642\u306B with_sum=true\
    \ \u304C\u5FC5\u8981\u3002\n        assert self.with_sum, \"\u548C\u3092\u53D6\
    \u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\u306B\u3057\u3066\u521D\
    \u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\
    \u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\n        assert\
    \ 0 <= k and k <= r-l, \"\u6307\u5B9A\u3057\u305F\u5024\u304C\u6709\u52B9\u306A\
    \u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\
    : 0 <= k and k <= r - l\"\n        var l = l\n        var r = r\n        var k\
    \ = k\n        var value = 0\n        for h in countdown(self.H-1,0,1):\n    \
    \        if k == 0:\n                return\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if k < r0-l0:\n                l = l0\n                r = r0\n \
    \           else:\n                result += self.dat[h].zero_sum[r0] - self.dat[h].zero_sum[l0]\n\
    \                k -= r0-l0\n                value += 1 shl h\n              \
    \  l = l1\n                r = r1\n        result += k * value\n\n    proc sum_upperbound*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u4EE5\u4E0B\u306E\u8981\u7D20\u306E\u7DCF\u548C\
    \u3092 1 \u56DE\u306E\u8D70\u67FB\u3067 O(H) \u3067\u8FD4\u3059\u3002\u69CB\u7BC9\
    \u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum,\
    \ \"\u548C\u3092\u53D6\u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\
    \u306B\u3057\u3066\u521D\u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\
    \u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\
    \n        if x < 0:\n            return 0\n        if self.H < sizeof(int) * 8\
    \ and (x shr self.H) != 0:\n            return self.sum_smallest(l,r,r-l)\n  \
    \      var l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n\
    \            if l == r:\n                return\n            if h == self.scan_h\
    \ and r-l <= scanLimit:\n                for i in l..<r:\n                   \
    \ let value = self.scan_values[i]\n                    if value <= x: result +=\
    \ value\n                return\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if ((x shr h) and 1) != 0:\n                result += self.dat[h].zero_sum[r0]\
    \ - self.dat[h].zero_sum[l0]\n                l = l1\n                r = r1\n\
    \            else:\n                l = l0\n                r = r0\n        result\
    \ += (r-l) * x\n\n    proc sum_lowerbound*(self:WaveletMatrix,l,r,x:int):int=\n\
    \        ## [l,r) \u5185\u306E x \u672A\u6E80\u306E\u8981\u7D20\u306E\u7DCF\u548C\
    \u3092 1 \u56DE\u306E\u8D70\u67FB\u3067 O(H) \u3067\u8FD4\u3059\u3002\u69CB\u7BC9\
    \u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum,\
    \ \"\u548C\u3092\u53D6\u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\
    \u306B\u3057\u3066\u521D\u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\
    \u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\
    \n        if x <= 0:\n            return 0\n        return self.sum_upperbound(l,r,x-1)\n\
    \n    proc range_sum*(self:WaveletMatrix,l,r,low,high:int):int=\n        ## [l,r)\
    \ \u5185\u3067\u5024\u304C [low,high) \u306B\u5165\u308B\u8981\u7D20\u306E\u7DCF\
    \u548C\u3092 O(H) \u3067\u8FD4\u3059\u3002low >= high \u306A\u3089 0\u3002\u69CB\
    \u7BC9\u6642\u306B with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum,\
    \ \"\u548C\u3092\u53D6\u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\
    \u306B\u3057\u3066\u521D\u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\
    \u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\
    \n        if low >= high:\n            return 0\n        return self.sum_lowerbound(l,r,high)\
    \ - self.sum_lowerbound(l,r,low)\n\n    proc sum_smallest_with_count*(self:WaveletMatrix,l,r,k:int):tuple[sum,count:int]=\n\
    \        ## [l,r) \u5185\u306E\u5C0F\u3055\u3044\u65B9\u304B\u3089 k \u500B\u306E\
    \u7DCF\u548C\u3068\u500B\u6570\u3092 O(H) \u3067\u8FD4\u3059\u3002with_sum=true\
    \ \u304C\u5FC5\u8981\u3002\n        return (sum:self.sum_smallest(l,r,k),count:k)\n\
    \n    proc sum_upperbound_with_count*(self:WaveletMatrix,l,r,x:int):tuple[sum,count:int]=\n\
    \        ## [l,r) \u5185\u306E x \u4EE5\u4E0B\u306E\u7DCF\u548C\u3068\u500B\u6570\
    \u3092\u540C\u3058\u63A2\u7D22\u3067 O(H) \u3067\u8FD4\u3059\u3002with_sum=true\
    \ \u304C\u5FC5\u8981\u3002\n        assert self.with_sum, \"\u548C\u3092\u53D6\
    \u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\u306B\u3057\u3066\u521D\
    \u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\
    \u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\n        if x <\
    \ 0:\n            return\n        if self.H < sizeof(int) * 8 and (x shr self.H)\
    \ != 0:\n            return self.sum_smallest_with_count(l,r,r-l)\n        var\
    \ l = l\n        var r = r\n        for h in countdown(self.H-1,0,1):\n      \
    \      if l == r:\n                return\n            if h == self.scan_h and\
    \ r-l <= scanLimit:\n                for i in l..<r:\n                    let\
    \ value = self.scan_values[i]\n                    if value <= x:\n          \
    \              result.sum += value\n                        inc result.count\n\
    \                return\n            let (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if ((x shr h) and 1) != 0:\n                result.sum += self.dat[h].zero_sum[r0]\
    \ - self.dat[h].zero_sum[l0]\n                result.count += r0-l0\n        \
    \        l = l1\n                r = r1\n            else:\n                l\
    \ = l0\n                r = r0\n        result.sum += (r-l) * x\n        result.count\
    \ += r-l\n\n    proc sum_lowerbound_with_count*(self:WaveletMatrix,l,r,x:int):tuple[sum,count:int]=\n\
    \        ## [l,r) \u5185\u306E x \u672A\u6E80\u306E\u7DCF\u548C\u3068\u500B\u6570\
    \u3092\u540C\u3058\u63A2\u7D22\u3067 O(H) \u3067\u8FD4\u3059\u3002with_sum=true\
    \ \u304C\u5FC5\u8981\u3002\n        assert self.with_sum, \"\u548C\u3092\u53D6\
    \u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\u306B\u3057\u3066\u521D\
    \u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059\"\n       \
    \ assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\u3057\u305F\u533A\u9593\
    \u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\u308B\u5FC5\u8981\u304C\
    \u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\n        if x <=\
    \ 0:\n            return\n        return self.sum_upperbound_with_count(l,r,x-1)\n\
    \n    proc range_sum_with_count*(self:WaveletMatrix,l,r,low,high:int):tuple[sum,count:int]=\n\
    \        ## [l,r) \u5185\u3067\u5024\u304C [low,high) \u306B\u5165\u308B\u7DCF\
    \u548C\u3068\u500B\u6570\u3092 O(H) \u3067\u8FD4\u3059\u3002low >= high \u306A\
    \u3089 (0,0)\u3002with_sum=true \u304C\u5FC5\u8981\u3002\n        assert self.with_sum,\
    \ \"\u548C\u3092\u53D6\u5F97\u3059\u308B\u306B\u306Fwith_sum\u3092\u6709\u52B9\
    \u306B\u3057\u3066\u521D\u671F\u5316\u3059\u308B\u5FC5\u8981\u304C\u3042\u308A\
    \u307E\u3059\"\n        assert 0 <= l and l <= r and r <= self.N, \"\u6307\u5B9A\
    \u3057\u305F\u533A\u9593\u304C\u6709\u52B9\u306A\u7BC4\u56F2\u5185\u3067\u3042\
    \u308B\u5FC5\u8981\u304C\u3042\u308A\u307E\u3059: 0 <= l and l <= r and r <= self.N\"\
    \n        if low >= high:\n            return\n        let upper = self.sum_lowerbound_with_count(l,r,high)\n\
    \        let lower = self.sum_lowerbound_with_count(l,r,low)\n        return (sum:upper.sum-lower.sum,count:upper.count-lower.count)\n\
    \n    when defined(release) and not defined(debug):\n        {.pop.}\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  isVerificationFile: false
  path: cplib/collections/waveletmatrix.nim
  requiredBy:
  - cplib/collections/waveletmatrix_fenwick.nim
  - cplib/collections/waveletmatrix_fenwick.nim
  timestamp: '2026-09-14 23:35:39+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/backwards_index_simd_test.nim
  - verify/utils/backwards_index_simd_test.nim
  - verify/collections/waveletmatrix_test.nim
  - verify/collections/waveletmatrix_test.nim
  - verify/AI/waveletmatrix_test.nim
  - verify/AI/waveletmatrix_test.nim
  - verify/AI/waveletmatrix_fenwick_test.nim
  - verify/AI/waveletmatrix_fenwick_test.nim
documentation_of: cplib/collections/waveletmatrix.nim
layout: document
redirect_from:
- /library/cplib/collections/waveletmatrix.nim
- /library/cplib/collections/waveletmatrix.nim.html
title: cplib/collections/waveletmatrix.nim
---
