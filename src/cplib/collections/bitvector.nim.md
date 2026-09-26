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
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix_fenwick.nim
    title: cplib/collections/waveletmatrix_fenwick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/waveletmatrix_fenwick.nim
    title: cplib/collections/waveletmatrix_fenwick.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string_search.nim
    title: cplib/str/static_string_search.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string_search.nim
    title: cplib/str/static_string_search.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitvector_test.nim
    title: verify/AI/bitvector_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitvector_test.nim
    title: verify/AI/bitvector_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_string_search_test.nim
    title: verify/AI/static_string_search_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/static_string_search_test.nim
    title: verify/AI/static_string_search_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_BITVECTOR:\n    const CPLIB_COLLECTIONS_BITVECTOR*\
    \ = 1\n    import bitops\n\n    when (defined(amd64) or defined(i386)) and (defined(gcc)\
    \ or defined(clang)):\n        # x86\u3067\u306FPOPCNT\u5BFE\u5FDCCPU\u3092\u524D\
    \u63D0\u306B\u3001popcount\u3092CPU\u547D\u4EE4\u306B\u3059\u308B\u3002\n    \
    \    {.passC: \"-mpopcnt\".}\n\n    # release\u3067\u3082debug\u6307\u5B9A\u6642\
    \u306F\u5883\u754C\u30FB\u30AA\u30FC\u30D0\u30FC\u30D5\u30ED\u30FC\u30C1\u30A7\
    \u30C3\u30AF\u3092\u6B8B\u3059\u3002\n    when defined(release) and not defined(debug):\n\
    \        {.push boundChecks: off, overflowChecks: off.}\n\n    type BitVector*\
    \ = object\n        bits : seq[uint64]\n        csum : seq[int]\n\n    proc newBitVector*(length:int):BitVector=\n\
    \        result.bits = newSeq[uint64]((length+63) div 64 + 1)\n        result.csum\
    \ = newSeq[int](((length+63) div 64)+1)\n\n    proc set*(self:var BitVector,idx:int)\
    \ {.inline.} =\n        ## build\u3059\u308B\u524D\u306B\u3060\u3051\u547C\u3076\
    \n        self.bits[idx shr 6].setBit(idx and 63)\n\n    proc setWord*(self:var\
    \ BitVector,idx:int,value:uint64) {.inline.} =\n        ## idx\u756A\u76EE\u306E\
    64bit\u30EF\u30FC\u30C9\u3092 O(1) \u3067\u4E0A\u66F8\u304D\u3059\u308B\u3002\u9577\
    \u3055\u5916\u306E\u30D3\u30C3\u30C8\u306F0\u306B\u3057\u3001\u8A2D\u5B9A\u5F8C\
    \u306Bbuild\u3059\u308B\u3002\n        self.bits[idx] = value\n\n    proc build*(self:var\
    \ BitVector)=\n        for i in 0..<(len(self.bits)-1):\n            self.csum[i+1]\
    \ = self.csum[i] + popcount(self.bits[i])\n\n    proc access*(self:var BitVector,idx:int):bool=\n\
    \        self.bits[idx shr 6].testBit(idx and 63)\n\n    proc `[]`*(self:var BitVector,idx:int):bool=\n\
    \        self.bits[idx shr 6].testBit(idx and 63)\n    \n    proc rank*(self:var\
    \ BitVector,idx:int):int {.inline.} =\n        ## [0,idx) \u306E1\u306E\u500B\u6570\
    \u3092 O(1) \u3067\u8FD4\u3059\u3002build\u5F8C\u306B\u547C\u3076\u3002\n    \
    \    let block_index = idx shr 6\n        return self.csum[block_index] + popcount(self.bits[block_index]\
    \ and ((1'u64 shl (idx and 63)) - 1))\n\n    when defined(release) and not defined(debug):\n\
    \        {.pop.}\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/bitvector.nim
  requiredBy:
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/waveletmatrix.nim
  - cplib/collections/waveletmatrix_fenwick.nim
  - cplib/collections/waveletmatrix_fenwick.nim
  - cplib/str/static_string_search.nim
  - cplib/str/static_string_search.nim
  timestamp: '2026-09-27 01:00:48+09:00'
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
  - verify/AI/bitvector_test.nim
  - verify/AI/bitvector_test.nim
  - verify/AI/static_string_search_test.nim
  - verify/AI/static_string_search_test.nim
documentation_of: cplib/collections/bitvector.nim
layout: document
redirect_from:
- /library/cplib/collections/bitvector.nim
- /library/cplib/collections/bitvector.nim.html
title: cplib/collections/bitvector.nim
---
