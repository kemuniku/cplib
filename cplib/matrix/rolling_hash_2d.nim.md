---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_MATRIX_ROLLINGHASH2D:\n    const CPLIB_MATRIX_ROLLINGHASH2D*\
    \ = 1\n    import random\n    import sequtils\n    const MASK30 = (1u shl 30)\
    \ - 1\n    const MASK31 = (1u shl 31) - 1\n    const RH_MOD = (1u shl 61) - 1\n\
    \    const POW_CALC = 500000\n\n    randomize()\n\n    proc calc_mod(x: uint):\
    \ uint =\n        result = (x shr 61) + (x and RH_MOD)\n        if result >= RH_MOD:\n\
    \            result -= RH_MOD\n\n    proc mul(a, b: uint): uint =\n        let\n\
    \            a_upper = a shr 31\n            a_lower = a and MASK31\n        \
    \    b_upper = b shr 31\n            b_lower = b and MASK31\n            mid =\
    \ a_lower * b_upper + a_upper * b_lower\n            mid_upper = mid shr 30\n\
    \            mid_lower = mid and MASK30\n        result = a_upper * b_upper *\
    \ 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower\n\n\n    proc inner_pow(a:uint,\
    \ n: int): uint =\n        var a = a\n        var n = n\n        result = 1\n\
    \        while n > 0:\n            if (n and 1) != 0:\n                result\
    \ = mul(result, a).calc_mod\n            a = mul(a, a).calc_mod\n            n\
    \ = n shr 1\n\n    let hashmatrix_basei:uint = rand(129u..(1u shl 30))\n    let\
    \ inv_hashmatrix_basei:uint = inner_pow(hashmatrix_basei,int(RH_MOD)-2)\n    let\
    \ hashmatrix_basej:uint = rand(129u..(1u shl 30))\n    let inv_hashmatrix_basej:uint\
    \ = inner_pow(hashmatrix_basej,int(RH_MOD)-2)\n    var powsi : seq[uint] = newseq[uint](POW_CALC+1)\n\
    \    var invpowsi : seq[uint] = newseq[uint](POW_CALC+1)\n    var powsj : seq[uint]\
    \ = newseq[uint](POW_CALC+1)\n    var invpowsj : seq[uint] = newseq[uint](POW_CALC+1)\n\
    \    powsi[0] = 1\n    invpowsi[0] = 1\n    powsj[0] = 1\n    invpowsj[0] = 1\n\
    \    for i in 1..POW_CALC:\n        powsi[i] = (mul(powsi[i-1],hashmatrix_basei).calc_mod)\n\
    \        invpowsi[i] = (mul(invpowsi[i-1],inv_hashmatrix_basei).calc_mod)\n  \
    \      powsj[i] = (mul(powsj[i-1],hashmatrix_basej).calc_mod)\n        invpowsj[i]\
    \ = (mul(invpowsj[i-1],inv_hashmatrix_basej).calc_mod)\n\n    proc base_powi(n:int):uint=\n\
    \        if n >= len(powsi):\n            return inner_pow(hashmatrix_basei,n)\n\
    \        else:\n            return powsi[n]\n\n    proc base_powj(n:int):uint=\n\
    \        if n >= len(powsj):\n            return inner_pow(hashmatrix_basej,n)\n\
    \        else:\n            return powsj[n]\n\n    proc inv_base_powi(n:int):uint=\n\
    \        if n >= len(powsi):\n            return inner_pow(inv_hashmatrix_basei,n)\n\
    \        else:\n            return invpowsi[n]\n\n    proc inv_base_powj(n:int):uint=\n\
    \        if n >= len(powsj):\n            return inner_pow(inv_hashmatrix_basej,n)\n\
    \        else:\n            return invpowsj[n]\n\n    type HashMatrixBase[T] =\
    \ ref object\n        matrix : seq[seq[T]]\n        hash : seq[seq[uint]]\n  \
    \      H : int\n        W : int\n\n    type HashMatrix[T] = object\n        base\
    \ : HashMatrixBase[T]\n        i : int\n        j : int\n        H : int\n   \
    \     W : int\n\n    type HashMatrixRow[T] = object\n        HM : HashMatrix[T]\n\
    \        i : int\n\n    proc initHashMatrixBase[T](x:seq[seq[T]]):HashMatrixBase[T]=\n\
    \        var H = len(x)\n        var W : int\n        if H == 0:\n           \
    \ W = 0\n        else:\n            W = len(x[0])\n        var hash = newseqwith(H+1,newseqwith(W+1,0u))\n\
    \        \n        for i in 0..<H:\n            for j in 0..<W:\n            \
    \    hash[i+1][j+1] = mul(mul(uint(x[i][j]),base_powi(i)).calc_mod(),base_powj(j)).calc_mod()\n\
    \        for i in 0..<H:\n            for j in 0..<W:\n                hash[i+1][j+1]\
    \ = (hash[i+1][j+1]+((hash[i][j+1] + hash[i+1][j]).calc_mod() + RH_MOD - hash[i][j]).calc_mod()).calc_mod()\n\
    \        return HashMatrixBase[T](matrix:x,hash:hash,H:H,W:W)\n\n    proc initHashMartix*[T](x:seq[seq[T]]):HashMatrix[T]=\n\
    \        var base = initHashMatrixBase[T](x)\n        return HashMatrix[T](base:base,i:0,j:0,H:base.H,W:base.W)\n\
    \n    proc get*[T](HM:HashMatrix[T],islice:HSlice[int,int],jslice:HSlice[int,int]):HashMatrix[T]=\n\
    \        var i = HM.i + islice.a\n        var j = HM.j + jslice.a\n        var\
    \ H = islice.len\n        var W = jslice.len\n        return HashMatrix[T](base:HM.base,i:i,j:j,H:H,W:W)\n\
    \n    proc gethash*[T](HM:HashMatrix[T]):uint=\n        return mul((((HM.base.hash[HM.i+HM.H][HM.j+HM.W]\
    \ + RH_MOD - HM.base.hash[HM.i][HM.j+HM.W]).calc_mod() + RH_MOD - HM.base.hash[HM.i+HM.H][HM.j]).calc_mod()\
    \ + HM.base.hash[HM.i][HM.j]).calc_mod(),mul(inv_base_powi(HM.i),inv_base_powj(HM.j)).calc_mod()).calc_mod()\n\
    \n    proc `==`*[T](L,R:HashMatrix[T]):bool=\n        return gethash(L) == gethash(R)\n\
    \    \n    proc `[]`*[T](HM:HashMatrix[T],i:int,j:int):T=\n        return HM.base.matrix[HM.i+i][HM.j+j]\n\
    \    \n    proc `[]`*[T](HM:HashMatrix[T],i:int):HashMatrixRow[T]=\n        return\
    \ HashMatrixRow[T](HM:HM,i:i)\n    \n    proc `[]`*[T](HMR:HashMatrixRow[T],j:int):T=\n\
    \        return HMR.HM.base.matrix[HMR.i+HMR.HM.i][HMR.HM.j+j]\n\n    proc `[]`*[T](HM:HashMatrix[T],slicei,slicej:HSlice[int,int]):HashMatrix[T]=\n\
    \        return get(HM,slicei,slicej)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/matrix/rolling_hash_2d.nim
  requiredBy: []
  timestamp: '2025-02-07 19:33:27+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/matrix/rolling_hash_2d.nim
layout: document
redirect_from:
- /library/cplib/matrix/rolling_hash_2d.nim
- /library/cplib/matrix/rolling_hash_2d.nim.html
title: cplib/matrix/rolling_hash_2d.nim
---
