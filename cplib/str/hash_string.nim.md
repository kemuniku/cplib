---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_LCP_test.nim
    title: verify/str/hash_string/hash_string_LCP_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_LCP_test.nim
    title: verify/str/hash_string/hash_string_LCP_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_LCS_test.nim
    title: verify/str/hash_string/hash_string_LCS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_LCS_test.nim
    title: verify/str/hash_string/hash_string_LCS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_Z_algo_test.nim
    title: verify/str/hash_string/hash_string_Z_algo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_Z_algo_test.nim
    title: verify/str/hash_string/hash_string_Z_algo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
    title: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
    title: verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "import random\ntype HashString* =object\n    hash:uint\n    size:int\nconst\
    \ MASK30 = (1u shl 30) - 1\nconst MASK31 = (1u shl 31) - 1\nconst RH_MOD = (1u\
    \ shl 61) - 1\nconst POW_CALC = 500000\n\nrandomize()\n\nproc calc_mod(x: uint):\
    \ uint =\n    result = (x shr 61) + (x and RH_MOD)\n    if result > RH_MOD:\n\
    \        result -= RH_MOD\n\nproc mul(a, b: uint): uint =\n    let\n        a_upper\
    \ = a shr 31\n        a_lower = a and MASK31\n        b_upper = b shr 31\n   \
    \     b_lower = b and MASK31\n        mid = a_lower * b_upper + a_upper * b_lower\n\
    \        mid_upper = mid shr 30\n        mid_lower = mid and MASK30\n    result\
    \ = a_upper * b_upper * 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower\n\
    \n\nproc inner_pow(a:uint, n: int): uint =\n    var a = a\n    var n = n\n   \
    \ result = 1\n    while n > 0:\n        if (n and 1) != 0:\n            result\
    \ = mul(result, a).calc_mod\n        a = mul(a, a).calc_mod\n        n = n shr\
    \ 1\n\nlet hashstring_base:uint = rand(129u..(1u shl 30))\nlet inv_hashstring_base:uint\
    \ = inner_pow(hashstring_base,int(RH_MOD)-2)\nvar pows : seq[uint] = newseq[uint](POW_CALC+1)\n\
    var invpows : seq[uint] = newseq[uint](POW_CALC+1)\npows[0] = 1\ninvpows[0] =\
    \ 1\nfor i in 1..POW_CALC:\n    pows[i] = (mul(pows[i-1],hashstring_base).calc_mod)\n\
    \    invpows[i] = (mul(invpows[i-1],inv_hashstring_base).calc_mod)\n\nproc base_pow(n:int):uint=\n\
    \    if n >= len(pows):\n        return inner_pow(hashstring_base,n)\n    else:\n\
    \        return pows[n]\n\nproc tohash*(S:string):HashString=\n    var hash =\
    \ 0u\n    var tmp = 1u\n    for i in countdown(len(S)-1,0,1):\n        hash =\
    \ (hash+mul(uint(int(S[i])),tmp)).calc_mod\n        tmp = mul(tmp,hashstring_base).calc_mod\
    \ \n    result = HashString(hash:hash,size:len(S))\n\nproc tohash*(S:char):HashString=\n\
    \    result = HashString(hash:uint(int(S)),size:1)\n\nproc `&`*(L,R:HashString):HashString=\n\
    \    result = HashString(hash:(mul(L.hash,base_pow(R.size)).calc_mod+R.hash).calc_mod,size:L.size+R.size)\n\
    \nproc `==`*(L,R:HashString):bool=\n    return (L.size == R.size) and (L.hash\
    \ == R.hash)\n\nproc len*(H:HashString):int=int(H.size)\n\nproc `*`*(H:HashString,x:int):HashString=\n\
    \    result = \"\".toHash()\n    var\n        x = x\n        tmp = H\n    while\
    \ x > 0:\n        if x mod 2 != 0: result = result&tmp\n        if x > 1: tmp\
    \ = tmp & tmp\n        x = x shr 1\n\nproc removePrefix(H,suffix:HashString):HashString=\n\
    \    var hash = (H.hash + (RH_MOD - mul(suffix.hash,base_pow(len(H)-len(suffix))).calc_mod)).calc_mod\n\
    \    var l = len(H)-len(suffix)\n    return HashString(hash:hash,size:l)\n\ntype\
    \ RollingHashBase = ref object\n    S : string\n    prefixs : seq[uint]\n    size\
    \ : int \n\ntype RollingHash= object\n    R : RollingHashBase\n    l : int\n \
    \   r : int\n\nproc len*(S:RollingHashBase):int=\n    return int(S.size)\n\nproc\
    \ len*(S:RollingHash):int=\n    return int(S.r-S.l)\n\nproc get_substring(R:RollingHashBase,l,r:int):RollingHash=\n\
    \    #\u534A\u958B\u533A\u9593\u3068\u3059\u308B\u3002\n    assert l in 0..<R.size\
    \ and r in 1..R.size and l < r\n    result.R = R\n    result.l = l\n    result.r\
    \ = r\n\nproc `[]`*(R:RollingHashBase,slice:HSlice[int,int]):RollingHash=\n  \
    \  assert slice.a >= 0 and slice.b >= 0\n    return R.get_substring(slice.a,slice.b+1)\n\
    \n\nproc `[]`*(S:RollingHash,slice:HSlice[int,int]):RollingHash=\n    assert slice.a\
    \ in 0..<len(S) and slice.b in 0..<len(S)\n    return S.R.get_substring(S.l+slice.a,S.l+slice.b+1)\n\
    \nproc gethash(S:RollingHash,slice:HSlice[int,int]):uint=\n    return (S.R.prefixs[(S.l+slice.b+1)]\
    \ + (RH_MOD - mul(S.R.prefixs[S.l+slice.a],base_pow(((S.l+slice.b+1)-(S.l+slice.a)))).calc_mod)).calc_mod\n\
    \n\nproc `[]`*(S:RollingHash,idx:int):char=\n    return S.R.S[idx+int(S.l)]\n\n\
    proc initRollingHash*(S:string):RollingHash=\n    var rolling = RollingHashBase()\n\
    \    rolling.S = S\n    rolling.prefixs = newSeq[uint](len(S)+1)\n    rolling.prefixs[0]\
    \ = 0\n    for i in 1..len(S):\n        rolling.prefixs[i] = (mul(rolling.prefixs[i-1],hashstring_base)\
    \ + uint(int(S[i-1]))).calc_mod()\n    rolling.size = (len(S))\n    return rolling[0..<len(S)]\n\
    \n\n\nconverter toHashString*(self:RollingHash):HashString=\n    return HashString(hash:(self.R.prefixs[self.r]\
    \ + (RH_MOD - mul(self.R.prefixs[self.l],base_pow(self.r-self.l)).calc_mod)).calc_mod,size:self.r-self.l)\n\
    \nproc`$`*(S:RollingHash):string=\n    return S.R.S[S.l..<S.r]\n\nproc `==`*(S,T:RollingHash):bool=\n\
    \    return len(S) == len(T) and (S.R.prefixs[S.r] + (RH_MOD - mul(S.R.prefixs[S.l],base_pow(S.r-S.l)).calc_mod)).calc_mod\
    \ == \n           (T.R.prefixs[T.r] + (RH_MOD - mul(T.R.prefixs[T.l],base_pow(T.r-T.l)).calc_mod)).calc_mod\n\
    \nproc LCP*(S,T:RollingHash):int=\n    var ok = 0\n    var ng = min(len(S),len(T))+1\n\
    \    while ng-ok > 1:\n        var mid = (ok + ng) div 2\n        if S.gethash(0..<mid)\
    \ == T.gethash(0..<mid): ok = mid\n        else: ng = mid\n    return ok\n\nproc\
    \ cmp*(S,T:RollingHash):int=\n    var S = S\n    var T = T\n    var flg = 1\n\
    \    if len(S) > len(T):\n        swap(S,T)\n        flg *= -1\n    var lcp =\
    \ LCP(S,T)\n    if len(S) == lcp:\n        if len(S) == len(T):\n            return\
    \ 0\n        else:\n            return -1*flg\n    else:\n        if S[lcp] <\
    \ T[lcp]:\n            return -1*flg\n        else:\n            return flg\n\n\
    proc `<`*(S,T:RollingHash):bool=\n    return cmp(S,T) < 0"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/hash_string.nim
  requiredBy: []
  timestamp: '2024-07-18 19:32:42+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/hash_string/hash_string_LCS_test.nim
  - verify/str/hash_string/hash_string_LCS_test.nim
  - verify/str/hash_string/hash_string_Z_algo_test.nim
  - verify/str/hash_string/hash_string_Z_algo_test.nim
  - verify/str/hash_string/hash_string_LCP_test.nim
  - verify/str/hash_string/hash_string_LCP_test.nim
  - verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
  - verify/str/hash_string/hash_string_rolling_hash_yosupo_suffix_array_test.nim
documentation_of: cplib/str/hash_string.nim
layout: document
redirect_from:
- /library/cplib/str/hash_string.nim
- /library/cplib/str/hash_string.nim.html
title: cplib/str/hash_string.nim
---
