---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/bitset_andpopcnt_test.nim
    title: verify/collections/bitset_andpopcnt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/bitset_andpopcnt_test.nim
    title: verify/collections/bitset_andpopcnt_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/bitset_test.nim
    title: verify/collections/bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/bitset_test.nim
    title: verify/collections/bitset_test.nim
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
    \ = 1\n    import math,bitops\n    \n    type BitSet* {.byref.}= object\n    \
    \    bits : seq[uint]\n    \n    proc varor(x:var uint,y:uint) {.importcpp:\"\
    # |= #\".}\n    proc varand(x:var uint,y:uint) {.importcpp:\"# &= #\".}\n    proc\
    \ varxor(x:var uint,y:uint) {.importcpp:\"# ^= #\".}\n\n    proc initBitSet*(v:seq[bool]):Bitset=\n\
    \        result.bits = newseq[uint](ceilDiv(len(v),64))\n        const mask =\
    \ ((1 shl 6) - 1)\n        for i in 0..<len(v):\n            if v[i]:\n      \
    \          varor(result.bits[i shr 6],1u shl (i and mask))\n    \n    proc `&`*(x,y:BitSet):BitSet=\n\
    \        result.bits = newseq[uint](min(len(x.bits),len(y.bits)))\n        for\
    \ i in 0..<len(result.bits):\n            result.bits[i] = x.bits[i] and y.bits[i]\n\
    \    \n    proc `&=`*(x:var BitSet,y:BitSet)=\n        for i in 0..<len(y.bits):\n\
    \            varand(x.bits[i],y.bits[i])\n        for j in len(y.bits)..<len(x.bits):\n\
    \            discard x.bits.pop()\n    \n    proc `|`*(x,y:BitSet):BitSet=\n \
    \       result.bits = newseq[uint](max(len(x.bits),len(y.bits)))\n        if len(y.bits)\
    \ < len(x.bits):\n            for i in 0..<len(y.bits):\n                result.bits[i]\
    \ = x.bits[i] or y.bits[i]\n            for i in len(y.bits)..<len(x.bits):\n\
    \                result.bits[i] = x.bits[i]\n        else:\n            for i\
    \ in 0..<len(x.bits):\n                result.bits[i] = x.bits[i] or y.bits[i]\n\
    \            for i in len(x.bits)..<len(y.bits):\n                result.bits[i]\
    \ = y.bits[i]\n    \n    proc `|=`*(x:var BitSet,y:BitSet)=\n        if len(y.bits)\
    \ < len(x.bits):\n            for i in 0..<len(y.bits):\n                varor(x.bits[i],y.bits[i])\n\
    \        else:\n            for i in 0..<len(x.bits):\n                varor(x.bits[i],y.bits[i])\n\
    \            for i in len(x.bits)..<len(y.bits):\n                x.bits.add(y.bits[i])\n\
    \    \n    proc `^=`*(x:var BitSet,y:BitSet)=\n        if len(y.bits) < len(x.bits):\n\
    \            for i in 0..<len(y.bits):\n                varxor(x.bits[i],y.bits[i])\n\
    \        else:\n            for i in 0..<len(x.bits):\n                varxor(x.bits[i],y.bits[i])\n\
    \            for i in len(x.bits)..<len(y.bits):\n                x.bits.add(y.bits[i])\n\
    \    \n    proc andpopcount*(x,y:BitSet):int=\n        for i in 0..<min(len(x.bits),len(y.bits)):\n\
    \            result += (x.bits[i] and y.bits[i]).popcount()\n\n    proc popcount*(x:BitSet):int=\n\
    \        for i in 0..<len(x.bits):\n            result += x.bits[i].popcount()\n\
    \    \n    proc `[]`*(bitset:BitSet,idx:Natural):bool=\n        return bitset.bits[idx\
    \ shr 6].testBit(idx and 63)\n\n    proc `[]=`*(bitset:var BitSet,idx:Natural,x:bool)=\n\
    \        while len(bitset.bits)-1 < idx shr 6:\n            bitset.bits.add(0u)\n\
    \        if x:\n            bitset.bits[idx shr 6].setBit((idx and 63))\n    \
    \    else:\n            bitset.bits[idx shr 6].clearBit((idx and 63))"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/bitset.nim
  requiredBy: []
  timestamp: '2024-10-02 16:59:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/bitset_andpopcnt_test.nim
  - verify/collections/bitset_andpopcnt_test.nim
  - verify/collections/bitset_test.nim
  - verify/collections/bitset_test.nim
documentation_of: cplib/collections/bitset.nim
layout: document
redirect_from:
- /library/cplib/collections/bitset.nim
- /library/cplib/collections/bitset.nim.html
title: cplib/collections/bitset.nim
---
