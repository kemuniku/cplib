---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix.nim
    title: cplib/collections/waveletmatrix.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitvector_test.nim
    title: verify/AI/bitvector_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitvector_test.nim
    title: verify/AI/bitvector_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_BITVECTOR:\n    const CPLIB_COLLECTIONS_BITVECTOR*\
    \ = 1\n    import bitops,sequtils\n\n    type BitVector* = object\n        bits\
    \ : seq[uint64]\n        csum : seq[int]\n\n    proc newBitVector*(length:int):BitVector=\n\
    \        result.bits = newSeq[uint64]((length+63) div 64 + 1)\n        result.csum\
    \ = newSeq[int](((length+63) div 64)+1)\n\n    proc set*(self:var BitVector,idx:int)=\n\
    \        ## build\u3059\u308B\u524D\u306B\u3060\u3051\u547C\u3076\n        self.bits[idx\
    \ div 64].setBit(idx mod 64)\n\n    proc build*(self:var BitVector)=\n       \
    \ for i in 0..<(len(self.bits)-1):\n            self.csum[i+1] = self.csum[i]\
    \ + popcount(self.bits[i])\n\n    proc access*(self:var BitVector,idx:int):bool=\n\
    \        self.bits[idx div 64].testBit(idx mod 64)\n\n    proc `[]`*(self:var\
    \ BitVector,idx:int):bool=\n        self.bits[idx div 64].testBit(idx mod 64)\n\
    \    \n    proc rank*(self:var BitVector,idx:int):int=\n        return self.csum[idx\
    \ div 64] + popcount(self.bits[idx div 64] and ((1u shl (idx and 63)) - 1))\n\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/bitvector.nim
  requiredBy:
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/waveletmatrix.nim
  timestamp: '2026-05-01 08:04:33+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/waveletmatrix_test.nim
  - verify/AI/waveletmatrix_test.nim
  - verify/AI/bitvector_test.nim
  - verify/AI/bitvector_test.nim
  - verify/collections/waveletmatrix_test.nim
  - verify/collections/waveletmatrix_test.nim
documentation_of: cplib/collections/bitvector.nim
layout: document
redirect_from:
- /library/cplib/collections/bitvector.nim
- /library/cplib/collections/bitvector.nim.html
title: cplib/collections/bitvector.nim
---
