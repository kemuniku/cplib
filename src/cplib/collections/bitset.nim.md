---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/collections/bitset_andpopcnt_test_.nim
    title: verify/collections/bitset_andpopcnt_test_.nim
  - icon: ':warning:'
    path: verify/collections/bitset_andpopcnt_test_.nim
    title: verify/collections/bitset_andpopcnt_test_.nim
  - icon: ':warning:'
    path: verify/collections/bitset_test_.nim
    title: verify/collections/bitset_test_.nim
  - icon: ':warning:'
    path: verify/collections/bitset_test_.nim
    title: verify/collections/bitset_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_test.nim
    title: verify/AI/bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/bitset_test.nim
    title: verify/AI/bitset_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_BITSET:\n    const CPLIB_COLLECTIONS_BITSET*\
    \ = 1\n    import bitops\n\n    const WordBits = 64\n\n    type BitSet* {.byref.}\
    \ = object\n        bits: seq[uint]\n        size: int\n\n    proc varor(x: var\
    \ uint, y: uint) {.importcpp: \"# |= #\".}\n    proc varand(x: var uint, y: uint)\
    \ {.importcpp: \"# &= #\".}\n    proc varxor(x: var uint, y: uint) {.importcpp:\
    \ \"# ^= #\".}\n\n    proc initBitSet*(N: int): BitSet =\n        if N < 0:\n\
    \            raise newException(ValueError, \"BitSet size must be non-negative\"\
    )\n        result.size = N\n        result.bits = newSeq[uint]((N + WordBits -\
    \ 1) div WordBits)\n\n    proc initBitSet*(v: openArray[bool], N: int): BitSet\
    \ =\n        if len(v) > N:\n            raise newException(ValueError, \"initial\
    \ value is longer than BitSet size\")\n        result = initBitSet(N)\n      \
    \  for i in 0..<len(v):\n            if v[i]:\n                result.bits[i shr\
    \ 6].varor(1u shl (i and 63))\n\n    proc initBitSet*(v: openArray[bool]): BitSet\
    \ =\n        result = initBitSet(v, len(v))\n\n    proc initBitSetFromIndexes*(indexes:\
    \ openArray[int], N: int): BitSet =\n        result = initBitSet(N)\n        for\
    \ i in indexes:\n            if i < 0 or i >= N:\n                raise newException(IndexDefect,\
    \ \"BitSet index out of bounds\")\n            result.bits[i shr 6].varor(1u shl\
    \ (i and 63))\n\n    proc len*(bitset: BitSet): int {.inline.} =\n        bitset.size\n\
    \n    proc checkSameSize(x, y: BitSet) {.inline.} =\n        if x.size != y.size:\n\
    \            raise newException(ValueError, \"BitSet sizes must match\")\n\n \
    \   proc checkIndex(bitset: BitSet, idx: Natural) {.inline.} =\n        if idx\
    \ >= bitset.size:\n            raise newException(IndexDefect, \"BitSet index\
    \ out of bounds\")\n\n    proc trim(bitset: var BitSet) {.inline.} =\n       \
    \ let mod64 = bitset.size and 63\n        if mod64 != 0:\n            bitset.bits[^1].varand((1u\
    \ shl mod64) - 1)\n\n    proc `&`*(x, y: BitSet): BitSet =\n        checkSameSize(x,\
    \ y)\n        result = initBitSet(x.size)\n        for i in 0..<len(result.bits):\n\
    \            result.bits[i] = x.bits[i] and y.bits[i]\n\n    proc `&=`*(x: var\
    \ BitSet, y: BitSet) =\n        checkSameSize(x, y)\n        for i in 0..<len(x.bits):\n\
    \            x.bits[i].varand(y.bits[i])\n\n    proc `|`*(x, y: BitSet): BitSet\
    \ =\n        checkSameSize(x, y)\n        result = initBitSet(x.size)\n      \
    \  for i in 0..<len(result.bits):\n            result.bits[i] = x.bits[i] or y.bits[i]\n\
    \n    proc `|=`*(x: var BitSet, y: BitSet) =\n        checkSameSize(x, y)\n  \
    \      for i in 0..<len(x.bits):\n            x.bits[i].varor(y.bits[i])\n\n \
    \   proc `^`*(x, y: BitSet): BitSet =\n        checkSameSize(x, y)\n        result\
    \ = initBitSet(x.size)\n        for i in 0..<len(result.bits):\n            result.bits[i]\
    \ = x.bits[i] xor y.bits[i]\n\n    proc `^=`*(x: var BitSet, y: BitSet) =\n  \
    \      checkSameSize(x, y)\n        for i in 0..<len(x.bits):\n            x.bits[i].varxor(y.bits[i])\n\
    \n    proc `>>`*(bitset: BitSet, x: int): BitSet =\n        if x < 0:\n      \
    \      raise newException(ValueError, \"shift count must be non-negative\")\n\
    \        result = initBitSet(bitset.size)\n        if x >= bitset.size:\n    \
    \        return\n        let wordShift = x shr 6\n        let bitShift = x and\
    \ 63\n        for dst in 0..<(len(bitset.bits) - wordShift):\n            let\
    \ src = dst + wordShift\n            result.bits[dst] = bitset.bits[src] shr bitShift\n\
    \            if bitShift != 0 and src + 1 < len(bitset.bits):\n              \
    \  result.bits[dst].varor(bitset.bits[src + 1] shl (WordBits - bitShift))\n\n\
    \    proc `<<`*(bitset: BitSet, x: int): BitSet =\n        if x < 0:\n       \
    \     raise newException(ValueError, \"shift count must be non-negative\")\n \
    \       result = initBitSet(bitset.size)\n        if x >= bitset.size:\n     \
    \       return\n        let wordShift = x shr 6\n        let bitShift = x and\
    \ 63\n        for dst in countdown(len(bitset.bits) - 1, wordShift):\n       \
    \     let src = dst - wordShift\n            result.bits[dst] = bitset.bits[src]\
    \ shl bitShift\n            if bitShift != 0 and src > 0:\n                result.bits[dst].varor(bitset.bits[src\
    \ - 1] shr (WordBits - bitShift))\n        result.trim()\n\n    proc andpopcount*(x,\
    \ y: BitSet): int =\n        checkSameSize(x, y)\n        for i in 0..<len(x.bits):\n\
    \            result += (x.bits[i] and y.bits[i]).popcount()\n\n    proc orpopcount*(x,\
    \ y: BitSet): int =\n        checkSameSize(x, y)\n        for i in 0..<len(x.bits):\n\
    \            result += (x.bits[i] or y.bits[i]).popcount()\n\n    proc xorpopcount*(x,\
    \ y: BitSet): int =\n        checkSameSize(x, y)\n        for i in 0..<len(x.bits):\n\
    \            result += (x.bits[i] xor y.bits[i]).popcount()\n\n    proc `~`*(x:\
    \ BitSet): BitSet =\n        result = initBitSet(x.size)\n        for i in 0..<len(x.bits):\n\
    \            result.bits[i] = bitnot(x.bits[i])\n        result.trim()\n\n   \
    \ proc popcount*(x: BitSet): int =\n        for i in 0..<len(x.bits):\n      \
    \      result += x.bits[i].popcount()\n\n    iterator items*(bitset: BitSet):\
    \ int =\n        for wordIndex in 0..<len(bitset.bits):\n            var word\
    \ = bitset.bits[wordIndex]\n            while word != 0:\n                let\
    \ bitIndex = word.countTrailingZeroBits()\n                yield wordIndex * WordBits\
    \ + bitIndex\n                word = word and (word - 1)\n\n    proc lowestBit*(bitset:\
    \ BitSet): int =\n        for wordIndex in 0..<len(bitset.bits):\n           \
    \ if bitset.bits[wordIndex] != 0:\n                return wordIndex * WordBits\
    \ + bitset.bits[wordIndex].countTrailingZeroBits()\n        -1\n\n    proc `[]`*(bitset:\
    \ BitSet, idx: Natural): bool =\n        bitset.checkIndex(idx)\n        bitset.bits[idx\
    \ shr 6].testBit(idx and 63)\n\n    proc `[]=`*(bitset: var BitSet, idx: Natural,\
    \ x: bool) =\n        bitset.checkIndex(idx)\n        if x:\n            bitset.bits[idx\
    \ shr 6].setBit(idx and 63)\n        else:\n            bitset.bits[idx shr 6].clearBit(idx\
    \ and 63)\n\n    proc `[]=`*(bitset: var BitSet, idx: Natural, x: int) =\n   \
    \     if x == 1:\n            bitset[idx] = true\n        elif x == 0:\n     \
    \       bitset[idx] = false\n\n    proc `$`*(bitset: BitSet): string =\n     \
    \   result = newString(bitset.size)\n        for i in 0..<bitset.size:\n     \
    \       result[bitset.size - i - 1] = if bitset[i]: '1' else: '0'\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/bitset.nim
  requiredBy:
  - verify/collections/bitset_andpopcnt_test_.nim
  - verify/collections/bitset_andpopcnt_test_.nim
  - verify/collections/bitset_test_.nim
  - verify/collections/bitset_test_.nim
  timestamp: '2026-08-28 03:04:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/bitset_test.nim
  - verify/AI/bitset_test.nim
documentation_of: cplib/collections/bitset.nim
layout: document
redirect_from:
- /library/cplib/collections/bitset.nim
- /library/cplib/collections/bitset.nim.html
title: cplib/collections/bitset.nim
---
