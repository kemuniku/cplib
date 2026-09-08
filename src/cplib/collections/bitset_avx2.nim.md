---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx2_impl.nim
    title: cplib/collections/private/bitset_avx2_impl.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/private/bitset_avx2_impl.nim
    title: cplib/collections/private/bitset_avx2_impl.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx2_test.nim
    title: verify/AI/bitset_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_avx2_test.nim
    title: verify/AI/bitset_avx2_test.nim
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
  code: "## AVX2\u3067\u8AD6\u7406\u6F14\u7B97\u30FB\u30B7\u30D5\u30C8\u30FB\u30D3\
    \u30C3\u30C8\u6570\u306E\u96C6\u8A08\u3092\u9AD8\u901F\u5316\u3057\u305F\u52D5\
    \u7684\u30D3\u30C3\u30C8\u96C6\u5408\u3067\u3059\u3002\n## amd64\u306EAVX2\u5BFE\
    \u5FDCCPU\u3068GCC/Clang\u304C\u5FC5\u8981\u3067\u3059\u3002C/C++\u30D0\u30C3\u30AF\
    \u30A8\u30F3\u30C9\u306B\u5BFE\u5FDC\u3057\u307E\u3059\u3002\n## import cplib/collections/bitset_avx2\
    \ \u3068\u3057\u3001initBitSet\u3067\u69CB\u7BC9\u3057\u307E\u3059\u3002\n## -d:release\u3067\
    \u306E\u30B3\u30F3\u30D1\u30A4\u30EB\u3092\u63A8\u5968\u3057\u307E\u3059\u3002\
    -mavx2\u306E\u6307\u5B9A\u306F\u4E0D\u8981\u3067\u3059\u3002\nwhen not declared\
    \ CPLIB_COLLECTIONS_BITSET_AVX2:\n    const CPLIB_COLLECTIONS_BITSET_AVX2* = 1\n\
    \    when not (defined(amd64) and (defined(gcc) or defined(clang))):\n       \
    \ {.error: \"BitSetAvx2 requires amd64 and GCC/Clang\".}\n    import bitops\n\n\
    \    type BitSetAvx2* {.byref.} = object\n        bits: seq[uint64]\n        size:\
    \ int\n\n    include cplib/collections/private/bitset_avx2_impl\n\n    proc initBitSet*(N:\
    \ int): BitSetAvx2 =\n        ## N\u30D3\u30C3\u30C8\u306E\u7A7A\u96C6\u5408\u3092\
    \u69CB\u7BC9\u3057\u307E\u3059\u3002\n        if N < 0:\n            raise newException(ValueError,\
    \ \"BitSet size must be non-negative\")\n        result.size = N\n        result.bits\
    \ = newSeq[uint64]((N shr 6) + ord((N and 63) != 0))\n\n    proc initBitSet*(v:\
    \ openArray[bool], N: int): BitSetAvx2 =\n        ## \u771F\u507D\u5024\u914D\u5217\
    \u304B\u3089N\u30D3\u30C3\u30C8\u306E\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u3001\
    \u6B8B\u308A\u30920\u3067\u57CB\u3081\u307E\u3059\u3002\n        if v.len > N:\n\
    \            raise newException(ValueError, \"initial value is longer than BitSet\
    \ size\")\n        result = initBitSet(N)\n        for i in 0..<v.len:\n     \
    \       if v[i]:\n                result.bits[i shr 6] = result.bits[i shr 6]\
    \ or (1'u64 shl (i and 63))\n\n    proc initBitSet*(v: openArray[bool]): BitSetAvx2\
    \ =\n        ## \u771F\u507D\u5024\u914D\u5217\u3068\u540C\u3058\u9577\u3055\u306E\
    \u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        initBitSet(v,\
    \ v.len)\n\n    proc initBitSetFromIndexes*(indexes: openArray[int], N: int):\
    \ BitSetAvx2 =\n        ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\u30D3\u30C3\
    \u30C8\u3092\u7ACB\u3066\u305FN\u30D3\u30C3\u30C8\u306E\u96C6\u5408\u3092\u69CB\
    \u7BC9\u3057\u307E\u3059\u3002\n        result = initBitSet(N)\n        for i\
    \ in indexes:\n            if i < 0 or i >= N:\n                raise newException(IndexDefect,\
    \ \"BitSet index out of bounds\")\n            result.bits[i shr 6] = result.bits[i\
    \ shr 6] or (1'u64 shl (i and 63))\n\n    proc len*(bitset: BitSetAvx2): int {.inline.}\
    \ =\n        ## \u30D3\u30C3\u30C8\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\n\
    \        bitset.size\n\n    proc checkSameSize(x, y: BitSetAvx2) {.inline.} =\n\
    \        ## \u4E8C\u3064\u306E\u96C6\u5408\u306E\u30D3\u30C3\u30C8\u6570\u304C\
    \u7B49\u3057\u3044\u3053\u3068\u3092\u78BA\u8A8D\u3057\u307E\u3059\u3002\n   \
    \     if x.size != y.size:\n            raise newException(ValueError, \"BitSet\
    \ sizes must match\")\n\n    proc checkIndex(bitset: BitSetAvx2, idx: Natural)\
    \ {.inline.} =\n        ## \u6DFB\u5B57\u304C\u96C6\u5408\u306E\u7BC4\u56F2\u5185\
    \u3067\u3042\u308B\u3053\u3068\u3092\u78BA\u8A8D\u3057\u307E\u3059\u3002\n   \
    \     if idx >= bitset.size:\n            raise newException(IndexDefect, \"BitSet\
    \ index out of bounds\")\n\n    proc trim(bitset: var BitSetAvx2) {.inline.} =\n\
    \        ## \u6700\u5F8C\u306E\u30EF\u30FC\u30C9\u306E\u7BC4\u56F2\u5916\u306E\
    \u30D3\u30C3\u30C8\u30920\u306B\u3057\u307E\u3059\u3002\n        let remainder\
    \ = bitset.size and 63\n        if remainder != 0:\n            bitset.bits[^1]\
    \ = bitset.bits[^1] and ((1'u64 shl remainder) - 1)\n\n    proc `&`*(x, y: BitSetAvx2):\
    \ BitSetAvx2 =\n        ## \u5171\u901A\u90E8\u5206\u3092\u8FD4\u3057\u307E\u3059\
    \u3002\n        checkSameSize(x, y)\n        result = initBitSet(x.size)\n   \
    \     if x.bits.len > 0:\n            avxAnd(addr result.bits[0], unsafeAddr x.bits[0],\
    \ unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc `&=`*(x: var BitSetAvx2,\
    \ y: BitSetAvx2) =\n        ## \u81EA\u8EAB\u3092\u5171\u901A\u90E8\u5206\u306B\
    \u66F4\u65B0\u3057\u307E\u3059\u3002\n        checkSameSize(x, y)\n        if\
    \ x.bits.len > 0:\n            avxAnd(addr x.bits[0], addr x.bits[0], unsafeAddr\
    \ y.bits[0], x.bits.len.csize_t)\n\n    proc `|`*(x, y: BitSetAvx2): BitSetAvx2\
    \ =\n        ## \u548C\u96C6\u5408\u3092\u8FD4\u3057\u307E\u3059\u3002\n     \
    \   checkSameSize(x, y)\n        result = initBitSet(x.size)\n        if x.bits.len\
    \ > 0:\n            avxOr(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr\
    \ y.bits[0], x.bits.len.csize_t)\n\n    proc `|=`*(x: var BitSetAvx2, y: BitSetAvx2)\
    \ =\n        ## \u81EA\u8EAB\u3092\u548C\u96C6\u5408\u306B\u66F4\u65B0\u3057\u307E\
    \u3059\u3002\n        checkSameSize(x, y)\n        if x.bits.len > 0:\n      \
    \      avxOr(addr x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\
    \n    proc `^`*(x, y: BitSetAvx2): BitSetAvx2 =\n        ## \u5BFE\u79F0\u5DEE\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\n        checkSameSize(x, y)\n        result\
    \ = initBitSet(x.size)\n        if x.bits.len > 0:\n            avxXor(addr result.bits[0],\
    \ unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc\
    \ `^=`*(x: var BitSetAvx2, y: BitSetAvx2) =\n        ## \u81EA\u8EAB\u3092\u5BFE\
    \u79F0\u5DEE\u306B\u66F4\u65B0\u3057\u307E\u3059\u3002\n        checkSameSize(x,\
    \ y)\n        if x.bits.len > 0:\n            avxXor(addr x.bits[0], addr x.bits[0],\
    \ unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc `<<`*(bitset: BitSetAvx2,\
    \ x: int): BitSetAvx2 =\n        ## \u6DFB\u5B57\u304C\u5927\u304D\u3044\u65B9\
    \u5411\u3078x\u30D3\u30C3\u30C8\u305A\u3089\u3057\u3001\u7BC4\u56F2\u5916\u3092\
    \u5207\u308A\u6368\u3066\u307E\u3059\u3002\n        if x < 0:\n            raise\
    \ newException(ValueError, \"shift count must be non-negative\")\n        result\
    \ = initBitSet(bitset.size)\n        if x < bitset.size:\n            avxShl(addr\
    \ result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)\n\
    \            result.trim()\n\n    proc `>>`*(bitset: BitSetAvx2, x: int): BitSetAvx2\
    \ =\n        ## \u6DFB\u5B57\u304C\u5C0F\u3055\u3044\u65B9\u5411\u3078x\u30D3\u30C3\
    \u30C8\u305A\u3089\u3057\u3001\u7BC4\u56F2\u5916\u3092\u5207\u308A\u6368\u3066\
    \u307E\u3059\u3002\n        if x < 0:\n            raise newException(ValueError,\
    \ \"shift count must be non-negative\")\n        result = initBitSet(bitset.size)\n\
    \        if x < bitset.size:\n            avxShr(addr result.bits[0], unsafeAddr\
    \ bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)\n\n    proc `~`*(x: BitSetAvx2):\
    \ BitSetAvx2 =\n        ## \u96C6\u5408\u306E\u30D3\u30C3\u30C8\u6570\u3092\u4FDD\
    \u3063\u305F\u307E\u307E\u5404\u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\u3057\u307E\
    \u3059\u3002\n        result = initBitSet(x.size)\n        if x.bits.len > 0:\n\
    \            avxNot(addr result.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t)\n\
    \            result.trim()\n\n    proc popcount*(x: BitSetAvx2): int =\n     \
    \   ## \u7ACB\u3063\u3066\u3044\u308B\u30D3\u30C3\u30C8\u306E\u500B\u6570\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\n        if x.bits.len > 0:\n            result\
    \ = avxPopcount(unsafeAddr x.bits[0], unsafeAddr x.bits[0], x.bits.len.csize_t).int\n\
    \n    proc andpopcount*(x, y: BitSetAvx2): int =\n        ## \u5171\u901A\u90E8\
    \u5206\u306E\u8981\u7D20\u6570\u3092\u3001\u4E00\u6642\u7684\u306A\u96C6\u5408\
    \u3092\u4F5C\u3089\u305A\u306B\u8FD4\u3057\u307E\u3059\u3002\n        checkSameSize(x,\
    \ y)\n        if x.bits.len > 0:\n            result = avxAndPopcount(unsafeAddr\
    \ x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int\n\n    proc orpopcount*(x,\
    \ y: BitSetAvx2): int =\n        ## \u548C\u96C6\u5408\u306E\u8981\u7D20\u6570\
    \u3092\u3001\u4E00\u6642\u7684\u306A\u96C6\u5408\u3092\u4F5C\u3089\u305A\u306B\
    \u8FD4\u3057\u307E\u3059\u3002\n        checkSameSize(x, y)\n        if x.bits.len\
    \ > 0:\n            result = avxOrPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0],\
    \ x.bits.len.csize_t).int\n\n    proc xorpopcount*(x, y: BitSetAvx2): int =\n\
    \        ## \u5BFE\u79F0\u5DEE\u306E\u8981\u7D20\u6570\u3092\u3001\u4E00\u6642\
    \u7684\u306A\u96C6\u5408\u3092\u4F5C\u3089\u305A\u306B\u8FD4\u3057\u307E\u3059\
    \u3002\n        checkSameSize(x, y)\n        if x.bits.len > 0:\n            result\
    \ = avxXorPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int\n\
    \n    iterator items*(bitset: BitSetAvx2): int =\n        ## \u7ACB\u3063\u3066\
    \u3044\u308B\u30D3\u30C3\u30C8\u306E\u6DFB\u5B57\u3092\u6607\u9806\u306B\u5217\
    \u6319\u3057\u307E\u3059\u3002\n        for wordIndex in 0..<bitset.bits.len:\n\
    \            var word = bitset.bits[wordIndex]\n            while word != 0:\n\
    \                yield wordIndex * 64 + word.countTrailingZeroBits()\n       \
    \         word = word and (word - 1)\n\n    proc lowestBit*(bitset: BitSetAvx2):\
    \ int =\n        ## \u6700\u5C0F\u306E\u8981\u7D20\u3092\u8FD4\u3057\u3001\u7A7A\
    \u96C6\u5408\u306A\u3089-1\u3092\u8FD4\u3057\u307E\u3059\u3002\n        for wordIndex\
    \ in 0..<bitset.bits.len:\n            if bitset.bits[wordIndex] != 0:\n     \
    \           return wordIndex * 64 + bitset.bits[wordIndex].countTrailingZeroBits()\n\
    \        -1\n\n    proc `[]`*(bitset: BitSetAvx2, idx: Natural): bool =\n    \
    \    ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u304C\u7ACB\
    \u3063\u3066\u3044\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\n        bitset.checkIndex(idx)\n\
    \        bitset.bits[idx shr 6].testBit(idx and 63)\n\n    proc `[]=`*(bitset:\
    \ var BitSetAvx2, idx: Natural, x: bool) =\n        ## \u6307\u5B9A\u3057\u305F\
    \u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u3092\u771F\u507D\u5024\u3067\u66F4\u65B0\
    \u3057\u307E\u3059\u3002\n        bitset.checkIndex(idx)\n        if x:\n    \
    \        bitset.bits[idx shr 6].setBit(idx and 63)\n        else:\n          \
    \  bitset.bits[idx shr 6].clearBit(idx and 63)\n\n    proc `[]=`*(bitset: var\
    \ BitSetAvx2, idx: Natural, x: int) =\n        ## 0\u306A\u3089\u30D3\u30C3\u30C8\
    \u3092\u843D\u3068\u3057\u30011\u306A\u3089\u7ACB\u3066\u307E\u3059\u3002\u305D\
    \u308C\u4EE5\u5916\u306F\u4F55\u3082\u3057\u307E\u305B\u3093\u3002\n        if\
    \ x == 1:\n            bitset[idx] = true\n        elif x == 0:\n            bitset[idx]\
    \ = false\n\n    proc `$`*(bitset: BitSetAvx2): string =\n        ## \u6DFB\u5B57\
    \u306E\u5927\u304D\u3044\u9806\u306B\u30D3\u30C3\u30C8\u3092\u4E26\u3079\u305F\
    \u6587\u5B57\u5217\u3092\u8FD4\u3057\u307E\u3059\u3002\n        result = newString(bitset.size)\n\
    \        for i in 0..<bitset.size:\n            result[bitset.size - i - 1] =\
    \ if bitset[i]: '1' else: '0'\n"
  dependsOn:
  - cplib/collections/private/bitset_avx2_impl.nim
  - cplib/collections/private/bitset_avx2_impl.nim
  isVerificationFile: false
  path: cplib/collections/bitset_avx2.nim
  requiredBy: []
  timestamp: '2026-09-08 11:45:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/bitset_avx2_test.nim
  - verify/AI/bitset_avx2_test.nim
documentation_of: cplib/collections/bitset_avx2.nim
layout: document
redirect_from:
- /library/cplib/collections/bitset_avx2.nim
- /library/cplib/collections/bitset_avx2.nim.html
title: cplib/collections/bitset_avx2.nim
---
