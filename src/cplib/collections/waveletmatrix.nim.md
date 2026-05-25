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
    \ bitops\n\n    type WaveletMatrix* = ref object\n        dat : seq[BitVector]\n\
    \        H : int\n        N : int\n    \n    proc initWaveletMatrix*(v:seq[int],H:int\
    \ = -1):WaveletMatrix=\n        var v = v\n        var N = len(v)\n        var\
    \ H = H\n        if H == -1:\n            if N == 0:\n                H = 0\n\
    \            elif max(v) == 0:\n                H = 1\n            else:\n   \
    \             H = fastLog2(max(v))+1\n        result = WaveletMatrix(dat:newSeqWith(H,newBitVector(N)),N:N,H:H)\n\
    \        var zero = newSeqWith(N,-1)\n        var one = newSeqWith(N,-1)\n   \
    \     var a = 0\n        var b = 0\n        for h in countdown(H-1,0,1):\n   \
    \         for i in 0..<N:\n                if v[i].testBit(h):\n             \
    \       one[b] = v[i]\n                    b += 1\n                    result.dat[h].set(i)\n\
    \                else:\n                    zero[a] = v[i]\n                 \
    \   a += 1\n            for i in 0..<a:\n                v[i] = zero[i]\n    \
    \        for i in 0..<b:\n                v[a+i] = one[i]\n            a = 0\n\
    \            b = 0\n            result.dat[h].build()\n    \n    proc get_child*(self:WaveletMatrix,h,l,r:int):tuple[l0,r0,l1,r1:int]=\n\
    \        # \u9AD8\u3055h+1\u306B\u304A\u3051\u308B[l,r)\u306B\u8A72\u5F53\u3059\
    \u308B\u90E8\u5206\u3092\u898B\u3066\u3044\u308B\u3068\u3059\u308B\u3002\n   \
    \     # \u305D\u306E\u5B50\u306B\u8A72\u5F53\u3059\u308B\u90E8\u5206\u3092[l0,r0),[l1,r1)\u3068\
    \u3057\u305F\u3068\u304D\u3001(l0,r0,l1,r1)\u3092\u8FD4\u3059\u3002\n        var\
    \ c0  = self.N - self.dat[h].rank(self.N)\n        result.l0 = l - self.dat[h].rank(l)\n\
    \        result.r0 = r - self.dat[h].rank(r)\n        result.l1 = self.dat[h].rank(l)\
    \ + c0\n        result.r1 = self.dat[h].rank(r) + c0\n\n    \n    proc kth_smallest*(self:WaveletMatrix,l,r,k:int):int=\n\
    \        # [l,r) \u5185\u3067\u3001k\u756A\u76EE\u306B\u5C0F\u3055\u3044\u3082\
    \u306E\u3092\u51FA\u529B\n        var k = k\n        var l = l\n        var r\
    \ = r\n        for h in countdown(self.H-1,0,1):\n            var (l0,r0,l1,r1)\
    \ = self.get_child(h,l,r)\n            if k < r0-l0:\n                l = l0\n\
    \                r = r0\n            else:\n                l = l1\n         \
    \       r = r1\n                k -= r0-l0\n                result += 1 shl h\n\
    \    \n    proc range_lowerbound*(self:WaveletMatrix,l,r,x:int):int=\n       \
    \ var x = x\n        var l = l\n        var r = r\n        var now = 0\n     \
    \   for h in countdown(self.H-1,0,1):\n            var (l0,r0,l1,r1) = self.get_child(h,l,r)\n\
    \            if (now + 1 shl h) > x:\n                l = l0\n               \
    \ r = r0\n            else:\n                l = l1\n                r = r1\n\
    \                now += 1 shl h\n                result += r0-l0\n    \n    proc\
    \ range_upperbound*(self:WaveletMatrix,l,r,x:int):int=\n        var x = x\n  \
    \      var l = l\n        var r = r\n        var now = 0\n        for h in countdown(self.H-1,0,1):\n\
    \            var (l0,r0,l1,r1) = self.get_child(h,l,r)\n            if (now +\
    \ 1 shl h) > x:\n                l = l0\n                r = r0\n            else:\n\
    \                l = l1\n                r = r1\n                now += 1 shl\
    \ h\n                result += r0-l0\n        result += r-l\n"
  dependsOn:
  - cplib/collections/bitvector.nim
  - cplib/collections/bitvector.nim
  isVerificationFile: false
  path: cplib/collections/waveletmatrix.nim
  requiredBy: []
  timestamp: '2026-05-26 04:52:54+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/waveletmatrix_test.nim
  - verify/collections/waveletmatrix_test.nim
documentation_of: cplib/collections/waveletmatrix.nim
layout: document
redirect_from:
- /library/cplib/collections/waveletmatrix.nim
- /library/cplib/collections/waveletmatrix.nim.html
title: cplib/collections/waveletmatrix.nim
---
