---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCP_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCP_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCP_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCP_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_rolling_hash_yosupo_suffix_array_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_rolling_hash_yosupo_suffix_array_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/can_reverse_hash_string/can_reverse_hash_string_rolling_hash_yosupo_suffix_array_test.nim
    title: verify/str/can_reverse_hash_string/can_reverse_hash_string_rolling_hash_yosupo_suffix_array_test.nim
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
  code: "when not declared CPLIB_STR_HASHSTRING:\n    const CPLIB_STR_HASHSTRING*\
    \ = 1\n    # hash_string\u3068\u3044\u3063\u3057\u3087\u306B\u4F7F\u308F\u308C\
    \u308B\u306E\u306F\u60F3\u5B9A\u3057\u3066\u3044\u306A\u3044\u306E\u3067\u3042\
    \u3048\u3066const\u3092\u885D\u7A81\u3055\u305B\u3066\u3044\u307E\u3059\n    import\
    \ random\n    type HashString* =object\n        hash* :uint\n        rhash* :uint\n\
    \        bpow  :uint\n        size: int\n    const MASK30 = (1u shl 30) - 1\n\
    \    const MASK31 = (1u shl 31) - 1\n    const RH_MOD = (1u shl 61) - 1\n    const\
    \ POW_CALC = 500000\n\n    randomize()\n\n    proc calc_mod(x: uint): uint =\n\
    \        result = (x shr 61) + (x and RH_MOD)\n        if result >= RH_MOD:\n\
    \            result -= RH_MOD\n\n    proc mul(a, b: uint): uint =\n        let\n\
    \            a_upper = a shr 31\n            a_lower = a and MASK31\n        \
    \    b_upper = b shr 31\n            b_lower = b and MASK31\n            mid =\
    \ a_lower * b_upper + a_upper * b_lower\n            mid_upper = mid shr 30\n\
    \            mid_lower = mid and MASK30\n        result = a_upper * b_upper *\
    \ 2 + mid_upper + (mid_lower shl 31) + a_lower * b_lower\n\n\n    proc inner_pow(a:uint,\
    \ n: int): uint =\n        var a = a\n        var n = n\n        result = 1\n\
    \        while n > 0:\n            if (n and 1) != 0:\n                result\
    \ = mul(result, a).calc_mod\n            a = mul(a, a).calc_mod\n            n\
    \ = n shr 1\n\n    let hashstring_base:uint = rand(129u..(1u shl 30))\n    let\
    \ inv_hashstring_base:uint = inner_pow(hashstring_base,int(RH_MOD)-2)\n    var\
    \ pows : seq[uint] = newseq[uint](POW_CALC+1)\n    var invpows : seq[uint] = newseq[uint](POW_CALC+1)\n\
    \    pows[0] = 1\n    invpows[0] = 1\n    for i in 1..POW_CALC:\n        pows[i]\
    \ = (mul(pows[i-1],hashstring_base).calc_mod)\n        invpows[i] = (mul(invpows[i-1],inv_hashstring_base).calc_mod)\n\
    \n    proc base_pow(n:int):uint=\n        if n >= len(pows):\n            return\
    \ inner_pow(hashstring_base,n)\n        else:\n            return pows[n]\n  \
    \  \n    proc base_inv_pow(n:int):uint=\n        if n >= len(invpows):\n     \
    \       return inner_pow(inv_hashstring_base,n)\n        else:\n            return\
    \ invpows[n]\n\n    proc tohash*(S:string):HashString=\n        var hash = 0u\n\
    \        var rhash = 0u\n        var tmp = 1u\n        for i in countdown(len(S)-1,0,1):\n\
    \            hash = (hash+mul(uint(int(S[i])),tmp)).calc_mod\n            rhash\
    \ = (rhash+mul(uint(int(S[len(S)-1-i])),tmp)).calc_mod\n            tmp = mul(tmp,hashstring_base).calc_mod\
    \ \n        result = HashString(hash:hash,rhash:rhash,bpow:base_pow(len(S)),size:len(S))\n\
    \n    proc tohash*(S:char):HashString=\n        result = HashString(hash:uint(int(S)),rhash:uint(int(S)),bpow:hashstring_base,size:1)\n\
    \n    proc `&`*(L,R:HashString):HashString=\n        result = HashString(hash:(mul(L.hash,R.bpow).calc_mod+R.hash).calc_mod,\n\
    \                            rhash:(mul(R.rhash,L.bpow).calc_mod+L.rhash).calc_mod,\n\
    \                            bpow:mul(L.bpow,R.bpow).calc_mod,size:L.size+R.size)\n\
    \n    proc `==`*(L,R:HashString):bool=\n        return (L.size == R.size) and\
    \ (L.hash == R.hash)\n\n    proc len*(H:HashString):int=int(H.size)\n\n    proc\
    \ `*`*(H:HashString,x:int):HashString=\n        var\n            size = H.size\
    \ * x\n            bpow = uint(1)\n            tmp_hash = H.hash\n           \
    \ tmp_rhash = H.rhash\n            tmp_b = H.bpow\n            hash = uint(0)\n\
    \            rhash = uint(0)\n            x = x\n        while x > 0:\n      \
    \      if x mod 2 != 0:\n                hash = (mul(hash,tmp_b).calc_mod+tmp_hash).calc_mod\n\
    \                rhash = (mul(tmp_rhash,bpow).calc_mod+rhash).calc_mod\n     \
    \           bpow = mul(bpow,tmp_b).calc_mod\n            if x > 1:\n         \
    \       tmp_hash = (mul(tmp_hash,tmp_b).calc_mod+tmp_hash).calc_mod\n        \
    \        tmp_rhash = (mul(tmp_rhash,tmp_b).calc_mod+tmp_rhash).calc_mod\n    \
    \            tmp_b = mul(tmp_b,tmp_b).calc_mod\n            x = x shr 1\n    \
    \    return HashString(hash:hash,rhash:rhash,bpow:bpow,size:size)\n    \n    proc\
    \ isPalindrome*(H:HashString):bool=\n        H.hash == H.rhash\n\n    proc reversed*(H:HashString):HashString=\n\
    \        return HashString(hash:H.rhash,rhash:H.hash,bpow:H.bpow,size:H.size)\n\
    \n    # proc removePrefix*(H,prefix:HashString):HashString=\n    #     var hash\
    \ = (H.hash + (RH_MOD - mul(prefix.hash,base_pow(len(H)-len(prefix))).calc_mod)).calc_mod\n\
    \    #     var l = len(H)-len(prefix)\n    #     return HashString(hash:hash,bpow:base_pow(l),size:l)\n\
    \n    type RollingHashBase = ref object\n        S : string\n        prefixs :\
    \ seq[uint]\n        rprefixs : seq[uint]\n        size : int \n\n    type RollingHash*\
    \ = object\n        R* : RollingHashBase\n        l* : int\n        r* : int\n\
    \n    proc len*(S:RollingHashBase):int=\n        return int(S.size)\n\n    proc\
    \ len*(S:RollingHash):int=\n        return int(S.r-S.l)\n\n    proc get_substring(R:RollingHashBase,l,r:int):RollingHash=\n\
    \        # \u534A\u958B\u533A\u9593\u3068\u3059\u308B\u3002\n        # \u7A7A\u6587\
    \u5B57\u5217\u7528\u306Br=0\u3082\u8A31\u5BB9\u3057\u3066\u3044\u308B\u3053\u3068\
    \u306B\u6CE8\u610F\u3002\n        # \u7A7A\u6587\u5B57\u5217\u306Fl=0,r=0\u306E\
    \u307F\u8A31\u5BB9\u3057\u3066\u3044\u308B\u3002\n        assert l in 0..<R.size\
    \ and r in 0..R.size and (l < r or (l == 0 and r == 0))\n        result.R = R\n\
    \        result.l = l\n        result.r = r\n\n    proc `[]`*(R:RollingHashBase,slice:HSlice[int,int]):RollingHash=\n\
    \        assert slice.a >= 0 and slice.b >= 0\n        return R.get_substring(slice.a,slice.b+1)\n\
    \n\n    proc `[]`*(S:RollingHash,slice:HSlice[int,int]):RollingHash=\n       \
    \ if len(slice) == 0:\n            return S.R.get_substring(0,0)\n        assert\
    \ slice.a in 0..<len(S) and slice.b in 0..<len(S)\n        return S.R.get_substring(S.l+slice.a,S.l+slice.b+1)\n\
    \n    proc gethash(S:RollingHash,slice:HSlice[int,int]):uint=\n        return\
    \ (S.R.prefixs[(S.l+slice.b+1)] + (RH_MOD - mul(S.R.prefixs[S.l+slice.a],base_pow(((S.l+slice.b+1)-(S.l+slice.a)))).calc_mod)).calc_mod\n\
    \n\n    proc `[]`*(S:RollingHash,idx:int):char=\n        return S.R.S[idx+int(S.l)]\n\
    \n    proc initRollingHash*(S:string):RollingHash=\n        var rolling = RollingHashBase()\n\
    \        rolling.S = S\n        rolling.prefixs = newSeq[uint](len(S)+1)\n   \
    \     rolling.rprefixs = newSeq[uint](len(S)+1)\n        rolling.rprefixs[0] =\
    \ 0\n        rolling.prefixs[0] = 0\n        var tmp = 1u\n        for i in 1..len(S):\n\
    \            rolling.prefixs[i] = (mul(rolling.prefixs[i-1],hashstring_base) +\
    \ uint(int(S[i-1]))).calc_mod()\n            rolling.rprefixs[i] = (mul(uint(int(S[i-1])),tmp)\
    \ + rolling.rprefixs[i-1]).calc_mod()\n            tmp = mul(tmp,hashstring_base).calc_mod\n\
    \        rolling.size = (len(S))\n        return rolling[0..<len(S)]\n\n\n\n \
    \   converter toHashString*(self:RollingHash):HashString=\n\n        return HashString(\
    \  hash:(self.R.prefixs[self.r] + (RH_MOD - mul(self.R.prefixs[self.l],base_pow(self.r-self.l)).calc_mod)).calc_mod,\n\
    \                            rhash:mul((self.R.rprefixs[self.r] + (RH_MOD - self.R.rprefixs[self.l])).calc_mod,base_inv_pow(self.l)).calc_mod,\n\
    \                            bpow:base_pow(self.r-self.l),\n                 \
    \           size:self.r-self.l)\n\n    proc`$`*(S:RollingHash):string=\n     \
    \   return S.R.S[S.l..<S.r]\n\n    proc `==`*(S,T:RollingHash):bool=\n       \
    \ return len(S) == len(T) and (S.R.prefixs[S.r] + (RH_MOD - mul(S.R.prefixs[S.l],base_pow(S.r-S.l)).calc_mod)).calc_mod\
    \ == \n                                    (T.R.prefixs[T.r] + (RH_MOD - mul(T.R.prefixs[T.l],base_pow(T.r-T.l)).calc_mod)).calc_mod\n\
    \n    proc LCP*(S,T:RollingHash):int=\n        var ok = 0\n        var ng = min(len(S),len(T))+1\n\
    \        while ng-ok > 1:\n            var mid = (ok + ng) div 2\n           \
    \ if S.gethash(0..<mid) == T.gethash(0..<mid): ok = mid\n            else: ng\
    \ = mid\n        return ok\n\n    proc cmp*(S,T:RollingHash):int=\n        var\
    \ S = S\n        var T = T\n        var flg = 1\n        if len(S) > len(T):\n\
    \            swap(S,T)\n            flg *= -1\n        var lcp = LCP(S,T)\n  \
    \      if len(S) == lcp:\n            if len(S) == len(T):\n                return\
    \ 0\n            else:\n                return -1*flg\n        else:\n       \
    \     if S[lcp] < T[lcp]:\n                return -1*flg\n            else:\n\
    \                return flg\n\n    proc `<`*(S,T:RollingHash):bool=\n        return\
    \ cmp(S,T) < 0\n\n    "
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/can_reverse_hash_string.nim
  requiredBy: []
  timestamp: '2024-08-31 11:41:07+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_Z_algo_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_LCS_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_LCP_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_LCP_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_mul_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_rolling_hash_yosupo_suffix_array_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_rolling_hash_yosupo_suffix_array_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
  - verify/str/can_reverse_hash_string/can_reverse_hash_string_manacher_test.nim
documentation_of: cplib/str/can_reverse_hash_string.nim
layout: document
redirect_from:
- /library/cplib/str/can_reverse_hash_string.nim
- /library/cplib/str/can_reverse_hash_string.nim.html
title: cplib/str/can_reverse_hash_string.nim
---
