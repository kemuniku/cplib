---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/static_bitset_seqint_test.nim
    title: verify/collections/static_bitset_seqint_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/static_bitset_seqint_test.nim
    title: verify/collections/static_bitset_seqint_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/static_bitset_test.nim
    title: verify/collections/static_bitset_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/static_bitset_test.nim
    title: verify/collections/static_bitset_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_STATIC_BITSET:\n    const CPLIB_COLLECTIONS_STATIC_BITSET*\
    \ = 1\n    import math,bitops,algorithm,strutils\n    \n    type BitSet*[size:static\
    \ int] {.byref.}= object\n        bits : array[(size+63) div 64,uint]\n    \n\
    \    proc varor(x:var uint,y:uint) {.importcpp:\"# |= #\".}\n    proc varand(x:var\
    \ uint,y:uint) {.importcpp:\"# &= #\".}\n    proc varxor(x:var uint,y:uint) {.importcpp:\"\
    # ^= #\".}\n    proc varshr(x:var uint,y:int) {.importcpp:\"# >>= #\".}\n    proc\
    \ varshl(x:var uint,y:int) {.importcpp:\"# <<= #\".}\n\n    proc initBitSet*(x:static\
    \ int):BitSet[x]=\n        discard\n\n    proc initBitSet*(v:seq[bool],size:static\
    \ int):Bitset[size]=\n        const mask = ((1 shl 6) - 1)\n        for i in 0..<len(v):\n\
    \            if v[i]:\n                varor(result.bits[i shr 6],1u shl (i and\
    \ mask))\n\n    proc initBitSet*(v:seq[int],size:static int):Bitset[size]=\n \
    \       const mask = ((1 shl 6) - 1)\n        for i in v:\n            varor(result.bits[i\
    \ shr 6],1u shl (i and mask))\n    \n    proc `&`*[size](x,y:BitSet[size]):BitSet[size]=\n\
    \        for i in 0..<len(result.bits):\n            result.bits[i] = x.bits[i]\
    \ and y.bits[i]\n    \n    proc `&=`*[size](x:var BitSet[size],y:BitSet[size])=\n\
    \        for i in 0..<len(y.bits):\n            varand(x.bits[i],y.bits[i])\n\
    \    \n    proc `|`*[size](x,y:BitSet[size]):BitSet[size]=\n        for i in 0..<len(y.bits):\n\
    \            result.bits[i] = x.bits[i] or y.bits[i]\n    \n    proc `|=`*[size](x:var\
    \ BitSet[size],y:BitSet[size])=\n        for i in 0..<len(y.bits):\n         \
    \   varor(x.bits[i],y.bits[i])\n    \n    proc `^`*[size](x,y:BitSet[size]):BitSet[size]=\n\
    \        for i in 0..<len(y.bits):\n            result.bits[i] = x.bits[i] xor\
    \ y.bits[i]\n    \n    proc `^=`*[size](x:var BitSet[size],y:BitSet[size])=\n\
    \        for i in 0..<len(y.bits):\n            varxor(x.bits[i],y.bits[i])\n\
    \    \n    proc `>>`*[size](bitset:BitSet[size],x:int):BitSet[size]=\n       \
    \ if x >= size:\n            return\n        for i in 0..<len(bitset.bits):\n\
    \            if i+(x div 64) < len(result.bits):\n                result.bits[i]\
    \ = bitset.bits[i+(x div 64)]\n        var tmp = 0u\n        var mod64 = x mod\
    \ 64\n        if mod64 != 0:\n            for i in countdown(len(bitset.bits)-1,0,1):\n\
    \                var msk = result.bits[i] and ((1u shl mod64) - 1)\n         \
    \       result.bits[i].varshr(mod64)\n                result.bits[i].varor(tmp\
    \ shl (64-mod64))\n                tmp = msk\n    \n    proc `<<`*[size](bitset:BitSet[size],x:int):BitSet[size]=\n\
    \        if x >= size:\n            return\n        for i in 0..<len(bitset.bits):\n\
    \            if i-(x div 64) >= 0:\n                result.bits[i] = bitset.bits[i-(x\
    \ div 64)]\n        var tmp = 0u\n        var mod64 = x mod 64\n        if mod64\
    \ != 0:\n            for i in 0..<len(bitset.bits):\n                var msk =\
    \ result.bits[i] and bitnot((1u shl mod64) - 1)\n                result.bits[i].varshl(mod64)\n\
    \                result.bits[i].varor(tmp shr (64-mod64))\n                tmp\
    \ = msk\n    \n    proc andpopcount*[size](x,y:BitSet[size]):int=\n        for\
    \ i in 0..<min(len(x.bits),len(y.bits)):\n            result += (x.bits[i] and\
    \ y.bits[i]).popcount()\n    \n    proc orpopcount*[size](x,y:BitSet[size]):int=\n\
    \        for i in 0..<min(len(x.bits),len(y.bits)):\n            result += (x.bits[i]\
    \ or y.bits[i]).popcount()\n    \n    proc xorpopcount*[size](x,y:BitSet[size]):int=\n\
    \        for i in 0..<min(len(x.bits),len(y.bits)):\n            result += (x.bits[i]\
    \ xor y.bits[i]).popcount()\n    \n    proc `~`*[size](x:BitSet[size]):BitSet[size]=\n\
    \        for i in 0..<len(x.bits)-1:\n            result.bits[i] = bitnot(x.bits[i])\n\
    \        var mod64 = size mod 64\n        if mod64 == 0:\n            result.bits[^1]\
    \ = bitnot(x.bits[^1])\n        else:\n            result.bits[^1] = x.bits[^1]\
    \ xor ((1u shl mod64) - 1)\n    proc popcount*[size](x:BitSet[size]):int=\n  \
    \      for i in 0..<len(x.bits):\n            result += x.bits[i].popcount()\n\
    \    \n    proc `[]`*[size](bitset:BitSet[size],idx:Natural):bool=\n        return\
    \ bitset.bits[idx shr 6].testBit(idx and 63)\n\n    proc `[]=`*[size](bitset:var\
    \ BitSet[size],idx:Natural,x:bool)=\n        if x:\n            bitset.bits[idx\
    \ shr 6].setBit((idx and 63))\n        else:\n            bitset.bits[idx shr\
    \ 6].clearBit((idx and 63))\n    \n    proc `[]=`*[size](bitset:var BitSet[size],idx:Natural,x:int)=\n\
    \        if x == 1:\n            bitset.bits[idx shr 6].setBit((idx and 63))\n\
    \        elif x == 0:\n            bitset.bits[idx shr 6].clearBit((idx and 63))\n\
    \    \n    proc `$`*[size](bitset:BitSet[size]):string=\n        var tmp : seq[char]\n\
    \        for i in 0..<size:\n            if bitset[i]:\n                tmp.add\
    \ '1'\n            else:\n                tmp.add '0'\n        return tmp.reversed().join(\"\
    \")"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/staticbitset.nim
  requiredBy: []
  timestamp: '2024-10-02 16:59:06+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/static_bitset_seqint_test.nim
  - verify/collections/static_bitset_seqint_test.nim
  - verify/collections/static_bitset_test.nim
  - verify/collections/static_bitset_test.nim
documentation_of: cplib/collections/staticbitset.nim
layout: document
redirect_from:
- /library/cplib/collections/staticbitset.nim
- /library/cplib/collections/staticbitset.nim.html
title: cplib/collections/staticbitset.nim
---
