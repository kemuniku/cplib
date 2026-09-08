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
    path: verify/AI/staticbitset_avx2_test.nim
    title: verify/AI/staticbitset_avx2_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/staticbitset_avx2_test.nim
    title: verify/AI/staticbitset_avx2_test.nim
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
    \u30C3\u30C8\u6570\u306E\u96C6\u8A08\u3092\u9AD8\u901F\u5316\u3057\u305F\u56FA\
    \u5B9A\u9577\u30D3\u30C3\u30C8\u96C6\u5408\u3067\u3059\u3002\n## amd64\u306EAVX2\u5BFE\
    \u5FDCCPU\u3068GCC/Clang\u304C\u5FC5\u8981\u3067\u3059\u3002C/C++\u30D0\u30C3\u30AF\
    \u30A8\u30F3\u30C9\u306B\u5BFE\u5FDC\u3057\u307E\u3059\u3002\n## initBitSet(3000)\
    \ \u3084 BitSet[3000] \u3068\u3057\u3066\u4F7F\u3044\u307E\u3059\u3002-mavx2\u306E\
    \u6307\u5B9A\u306F\u4E0D\u8981\u3067\u3059\u3002\nwhen not declared CPLIB_COLLECTIONS_STATIC_BITSET_AVX2:\n\
    \    const CPLIB_COLLECTIONS_STATIC_BITSET_AVX2* = 1\n    when not (defined(amd64)\
    \ and (defined(gcc) or defined(clang))):\n        {.error: \"StaticBitSetAvx2\
    \ requires amd64 and GCC/Clang\".}\n    import bitops\n    include cplib/collections/private/bitset_avx2_impl\n\
    \n    func wordCount(size: int): int {.compileTime.} =\n        ## \u975E\u8CA0\
    \u306E\u30D3\u30C3\u30C8\u6570\u306B\u5FC5\u8981\u306A64\u30D3\u30C3\u30C8\u30EF\
    \u30FC\u30C9\u6570\u3092\u6C42\u3081\u307E\u3059\u3002\n        doAssert size\
    \ >= 0, \"BitSet size must be non-negative\"\n        (size shr 6) + ord((size\
    \ and 63) != 0)\n\n    type BitSet*[size: static int] {.byref.} = object\n   \
    \     bits: array[wordCount(size), uint64]\n\n    proc initBitSet*(size: static\
    \ int): BitSet[size] =\n        ## \u6307\u5B9A\u3057\u305F\u30D3\u30C3\u30C8\u6570\
    \u306E\u7A7A\u96C6\u5408\u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        discard\n\
    \n    proc initBitSet*(v: openArray[bool], size: static int): BitSet[size] {.noinit.}\
    \ =\n        ## \u771F\u507D\u5024\u914D\u5217\u304B\u3089\u96C6\u5408\u3092\u69CB\
    \u7BC9\u3057\u3001\u6B8B\u308A\u30920\u3067\u57CB\u3081\u307E\u3059\u3002\n  \
    \      if v.len > size:\n            raise newException(ValueError, \"initial\
    \ value is longer than BitSet size\")\n        static:\n            doAssert sizeof(bool)\
    \ == 1\n        when size > 0:\n            let source = if v.len == 0: nil else:\
    \ cast[pointer](unsafeAddr v[0])\n            avxFromBools(addr result.bits[0],\
    \ source, v.len.csize_t, result.bits.len.csize_t)\n\n    proc initBitSetFromIndexes*(indexes:\
    \ openArray[int], size: static int): BitSet[size] =\n        ## \u6307\u5B9A\u3057\
    \u305F\u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u3092\u7ACB\u3066\u305F\u96C6\u5408\
    \u3092\u69CB\u7BC9\u3057\u307E\u3059\u3002\n        for i in indexes:\n      \
    \      if i < 0 or i >= size:\n                raise newException(IndexDefect,\
    \ \"BitSet index out of bounds\")\n            result.bits[i shr 6] = result.bits[i\
    \ shr 6] or (1'u64 shl (i and 63))\n\n    proc len*[size](bitset: BitSet[size]):\
    \ int {.inline.} =\n        ## \u96C6\u5408\u306E\u30D3\u30C3\u30C8\u6570\u3092\
    \u8FD4\u3057\u307E\u3059\u3002\n        size\n\n    proc checkIndex[size](bitset:\
    \ BitSet[size], idx: Natural) {.inline.} =\n        ## \u6DFB\u5B57\u304C\u96C6\
    \u5408\u306E\u7BC4\u56F2\u5185\u3067\u3042\u308B\u3053\u3068\u3092\u78BA\u8A8D\
    \u3057\u307E\u3059\u3002\n        if idx >= size:\n            raise newException(IndexDefect,\
    \ \"BitSet index out of bounds\")\n\n    proc trim[size](bitset: var BitSet[size])\
    \ {.inline.} =\n        ## \u6700\u5F8C\u306E\u30EF\u30FC\u30C9\u306E\u7BC4\u56F2\
    \u5916\u306E\u30D3\u30C3\u30C8\u30920\u306B\u3057\u307E\u3059\u3002\n        const\
    \ remainder = size and 63\n        when remainder != 0:\n            bitset.bits[^1]\
    \ = bitset.bits[^1] and ((1'u64 shl remainder) - 1)\n\n    proc `&`*[size](x,\
    \ y: BitSet[size]): BitSet[size] {.noinit.} =\n        ## \u5171\u901A\u90E8\u5206\
    \u3092\u8FD4\u3057\u307E\u3059\u3002\n        when size > 0:\n            avxAnd(addr\
    \ result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\
    \n    proc `&=`*[size](x: var BitSet[size], y: BitSet[size]) =\n        ## \u81EA\
    \u8EAB\u3092\u5171\u901A\u90E8\u5206\u306B\u66F4\u65B0\u3057\u307E\u3059\u3002\
    \n        when size > 0:\n            avxAnd(addr x.bits[0], addr x.bits[0], unsafeAddr\
    \ y.bits[0], x.bits.len.csize_t)\n\n    proc `|`*[size](x, y: BitSet[size]): BitSet[size]\
    \ {.noinit.} =\n        ## \u548C\u96C6\u5408\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        when size > 0:\n            avxOr(addr result.bits[0], unsafeAddr x.bits[0],\
    \ unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc `|=`*[size](x: var BitSet[size],\
    \ y: BitSet[size]) =\n        ## \u81EA\u8EAB\u3092\u548C\u96C6\u5408\u306B\u66F4\
    \u65B0\u3057\u307E\u3059\u3002\n        when size > 0:\n            avxOr(addr\
    \ x.bits[0], addr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n   \
    \ proc `^`*[size](x, y: BitSet[size]): BitSet[size] {.noinit.} =\n        ## \u5BFE\
    \u79F0\u5DEE\u3092\u8FD4\u3057\u307E\u3059\u3002\n        when size > 0:\n   \
    \         avxXor(addr result.bits[0], unsafeAddr x.bits[0], unsafeAddr y.bits[0],\
    \ x.bits.len.csize_t)\n\n    proc `^=`*[size](x: var BitSet[size], y: BitSet[size])\
    \ =\n        ## \u81EA\u8EAB\u3092\u5BFE\u79F0\u5DEE\u306B\u66F4\u65B0\u3057\u307E\
    \u3059\u3002\n        when size > 0:\n            avxXor(addr x.bits[0], addr\
    \ x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t)\n\n    proc `<<`*[size](bitset:\
    \ BitSet[size], x: int): BitSet[size] =\n        ## \u6DFB\u5B57\u304C\u5927\u304D\
    \u3044\u65B9\u5411\u3078x\u30D3\u30C3\u30C8\u305A\u3089\u3057\u3001\u7BC4\u56F2\
    \u5916\u3092\u5207\u308A\u6368\u3066\u307E\u3059\u3002\n        if x < 0:\n  \
    \          raise newException(ValueError, \"shift count must be non-negative\"\
    )\n        when size > 0:\n            if x < size:\n                avxShl(addr\
    \ result.bits[0], unsafeAddr bitset.bits[0], bitset.bits.len.csize_t, x.csize_t)\n\
    \                result.trim()\n\n    proc `>>`*[size](bitset: BitSet[size], x:\
    \ int): BitSet[size] =\n        ## \u6DFB\u5B57\u304C\u5C0F\u3055\u3044\u65B9\u5411\
    \u3078x\u30D3\u30C3\u30C8\u305A\u3089\u3057\u3001\u7BC4\u56F2\u5916\u3092\u5207\
    \u308A\u6368\u3066\u307E\u3059\u3002\n        if x < 0:\n            raise newException(ValueError,\
    \ \"shift count must be non-negative\")\n        when size > 0:\n            if\
    \ x < size:\n                avxShr(addr result.bits[0], unsafeAddr bitset.bits[0],\
    \ bitset.bits.len.csize_t, x.csize_t)\n\n    proc `~`*[size](x: BitSet[size]):\
    \ BitSet[size] {.noinit.} =\n        ## \u96C6\u5408\u306E\u30D3\u30C3\u30C8\u6570\
    \u3092\u4FDD\u3063\u305F\u307E\u307E\u5404\u30D3\u30C3\u30C8\u3092\u53CD\u8EE2\
    \u3057\u307E\u3059\u3002\n        when size > 0:\n            avxNot(addr result.bits[0],\
    \ unsafeAddr x.bits[0], x.bits.len.csize_t)\n            result.trim()\n\n   \
    \ proc popcount*[size](x: BitSet[size]): int =\n        ## \u7ACB\u3063\u3066\u3044\
    \u308B\u30D3\u30C3\u30C8\u306E\u500B\u6570\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        when size > 0:\n            result = avxPopcount(unsafeAddr x.bits[0],\
    \ unsafeAddr x.bits[0], x.bits.len.csize_t).int\n\n    proc andpopcount*[size](x,\
    \ y: BitSet[size]): int =\n        ## \u5171\u901A\u90E8\u5206\u306E\u8981\u7D20\
    \u6570\u3092\u3001\u4E00\u6642\u7684\u306A\u96C6\u5408\u3092\u4F5C\u3089\u305A\
    \u306B\u8FD4\u3057\u307E\u3059\u3002\n        when size > 0:\n            result\
    \ = avxAndPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int\n\
    \n    proc orpopcount*[size](x, y: BitSet[size]): int =\n        ## \u548C\u96C6\
    \u5408\u306E\u8981\u7D20\u6570\u3092\u3001\u4E00\u6642\u7684\u306A\u96C6\u5408\
    \u3092\u4F5C\u3089\u305A\u306B\u8FD4\u3057\u307E\u3059\u3002\n        when size\
    \ > 0:\n            result = avxOrPopcount(unsafeAddr x.bits[0], unsafeAddr y.bits[0],\
    \ x.bits.len.csize_t).int\n\n    proc xorpopcount*[size](x, y: BitSet[size]):\
    \ int =\n        ## \u5BFE\u79F0\u5DEE\u306E\u8981\u7D20\u6570\u3092\u3001\u4E00\
    \u6642\u7684\u306A\u96C6\u5408\u3092\u4F5C\u3089\u305A\u306B\u8FD4\u3057\u307E\
    \u3059\u3002\n        when size > 0:\n            result = avxXorPopcount(unsafeAddr\
    \ x.bits[0], unsafeAddr y.bits[0], x.bits.len.csize_t).int\n\n    iterator items*[size](bitset:\
    \ BitSet[size]): int =\n        ## \u7ACB\u3063\u3066\u3044\u308B\u30D3\u30C3\u30C8\
    \u306E\u6DFB\u5B57\u3092\u6607\u9806\u306B\u5217\u6319\u3057\u307E\u3059\u3002\
    \n        for wordIndex in 0..<bitset.bits.len:\n            var word = bitset.bits[wordIndex]\n\
    \            while word != 0:\n                yield wordIndex * 64 + word.countTrailingZeroBits()\n\
    \                word = word and (word - 1)\n\n    proc lowestBit*[size](bitset:\
    \ BitSet[size]): int =\n        ## \u6700\u5C0F\u306E\u8981\u7D20\u3092\u8FD4\u3057\
    \u3001\u7A7A\u96C6\u5408\u306A\u3089-1\u3092\u8FD4\u3057\u307E\u3059\u3002\n \
    \       for wordIndex in 0..<bitset.bits.len:\n            if bitset.bits[wordIndex]\
    \ != 0:\n                return wordIndex * 64 + bitset.bits[wordIndex].countTrailingZeroBits()\n\
    \        -1\n\n    proc `[]`*[size](bitset: BitSet[size], idx: Natural): bool\
    \ =\n        ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u304C\
    \u7ACB\u3063\u3066\u3044\u308B\u304B\u3092\u8FD4\u3057\u307E\u3059\u3002\n   \
    \     bitset.checkIndex(idx)\n        bitset.bits[idx shr 6].testBit(idx and 63)\n\
    \n    proc `[]=`*[size](bitset: var BitSet[size], idx: Natural, x: bool) =\n \
    \       ## \u6307\u5B9A\u3057\u305F\u6DFB\u5B57\u306E\u30D3\u30C3\u30C8\u3092\u771F\
    \u507D\u5024\u3067\u66F4\u65B0\u3057\u307E\u3059\u3002\n        bitset.checkIndex(idx)\n\
    \        if x:\n            bitset.bits[idx shr 6].setBit(idx and 63)\n      \
    \  else:\n            bitset.bits[idx shr 6].clearBit(idx and 63)\n\n    proc\
    \ `[]=`*[size](bitset: var BitSet[size], idx: Natural, x: int) =\n        ## 0\u306A\
    \u3089\u30D3\u30C3\u30C8\u3092\u843D\u3068\u3057\u30011\u306A\u3089\u7ACB\u3066\
    \u307E\u3059\u3002\u305D\u308C\u4EE5\u5916\u306F\u4F55\u3082\u3057\u307E\u305B\
    \u3093\u3002\n        if x == 1:\n            bitset[idx] = true\n        elif\
    \ x == 0:\n            bitset[idx] = false\n\n    const ByteStrings = block:\n\
    \        var table: array[256, array[8, char]]\n        for value in 0..<256:\n\
    \            for bit in 0..<8:\n                table[value][bit] = char(ord('0')\
    \ + ((value shr (7 - bit)) and 1))\n        table\n\n    proc `$`*[size](bitset:\
    \ BitSet[size]): string =\n        ## \u6DFB\u5B57\u306E\u5927\u304D\u3044\u9806\
    \u306B\u30D3\u30C3\u30C8\u3092\u4E26\u3079\u305F\u6587\u5B57\u5217\u3092\u8FD4\
    \u3057\u307E\u3059\u3002\n        result = newString(size)\n        var finish\
    \ = size\n        for wordIndex in 0..<bitset.bits.len:\n            var word\
    \ = bitset.bits[wordIndex]\n            var remaining = min(64, size - wordIndex\
    \ * 64)\n            while remaining >= 8:\n                finish -= 8\n    \
    \            copyMem(addr result[finish], unsafeAddr ByteStrings[int(word and\
    \ 255)][0], 8)\n                word = word shr 8\n                remaining -=\
    \ 8\n            while remaining > 0:\n                dec finish\n          \
    \      result[finish] = char(ord('0') + int(word and 1))\n                word\
    \ = word shr 1\n                dec remaining\n"
  dependsOn:
  - cplib/collections/private/bitset_avx2_impl.nim
  - cplib/collections/private/bitset_avx2_impl.nim
  isVerificationFile: false
  path: cplib/collections/staticbitset_avx2.nim
  requiredBy: []
  timestamp: '2026-09-08 11:45:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/staticbitset_avx2_test.nim
  - verify/AI/staticbitset_avx2_test.nim
documentation_of: cplib/collections/staticbitset_avx2.nim
layout: document
redirect_from:
- /library/cplib/collections/staticbitset_avx2.nim
- /library/cplib/collections/staticbitset_avx2.nim.html
title: cplib/collections/staticbitset_avx2.nim
---
