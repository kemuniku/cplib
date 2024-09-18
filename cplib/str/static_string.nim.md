---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/str/static_string/static_string_count_test_.nim
    title: verify/str/static_string/static_string_count_test_.nim
  - icon: ':warning:'
    path: verify/str/static_string/static_string_count_test_.nim
    title: verify/str/static_string/static_string_count_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_LCS_test.nim
    title: verify/str/static_string/static_string_LCS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_LCS_test.nim
    title: verify/str/static_string/static_string_LCS_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
    title: verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
    title: verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_LCS_useSA_test.nim
    title: verify/str/static_string/static_string_LCS_useSA_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_LCS_useSA_test.nim
    title: verify/str/static_string/static_string_LCS_useSA_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_SA_test.nim
    title: verify/str/static_string/static_string_SA_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_SA_test.nim
    title: verify/str/static_string/static_string_SA_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
    title: verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
    title: verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_initSA_test.nim
    title: verify/str/static_string/static_string_initSA_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_initSA_test.nim
    title: verify/str/static_string/static_string_initSA_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_lcp_test.nim
    title: verify/str/static_string/static_string_lcp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_lcp_test.nim
    title: verify/str/static_string/static_string_lcp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_zalgo_test.nim
    title: verify/str/static_string/static_string_zalgo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/static_string/static_string_zalgo_test.nim
    title: verify/str/static_string/static_string_zalgo_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_STATIC_STRING:\n    const CPLIB_STR_STATIC_STRING*\
    \ = 1\n    import cplib/collections/staticRMQ\n    import atcoder/string\n   \
    \ import sequtils\n    import algorithm\n\n    type StaticStringBase* = ref object\n\
    \        S* : string\n        RMQ* : StaticRMQ[int]\n        SA* : seq[int]\n\
    \        RSA* : seq[int]\n        LCP* : seq[int]\n        size* : int\n    type\
    \ StaticString* = object\n        base* : StaticStringBase\n        l* : int\n\
    \        r* : int\n    proc initStaticStringBase*(S:string):StaticStringBase=\n\
    \        result = StaticStringBase()\n        result.S = S\n        result.SA\
    \ = suffix_array(S)\n        result.RSA = newseq[int](len(S))\n        for i in\
    \ 0..<len(S):\n            result.RSA[result.SA[i]] = i\n        result.LCP =\
    \ lcp_array(S,result.SA)\n        result.RMQ = initRMQ(result.LCP)\n        result.size\
    \ = len(S)\n    proc toStaticString*(S:string):StaticString=\n        var base\
    \ = initStaticStringBase(S)\n        return StaticString(base:base,l:0,r:len(S))\n\
    \n\n    proc `[]`*(S:StaticString,idx:Natural):char=\n        assert S.l+idx <\
    \ S.base.size\n        return S.base.S[S.l+idx]\n\n    proc `[]`*(S:StaticString,slice:HSlice[int,int]):StaticString=\n\
    \        assert slice.a <= slice.b and S.l + slice.b < S.r\n        return StaticString(base:S.base,l:S.l+slice.a,r:S.l+slice.b+1)\n\
    \n\n    proc `$`*(S:StaticString):string=S.base.S[S.l..<S.r]\n\n    proc len*(S:StaticString):int\
    \ = S.r-S.l\n\n    proc lcp*(S,T:StaticString):int=\n        assert S.base ==\
    \ T.base\n        var l = S.base.RSA[S.l]\n        var r = S.base.RSA[T.l]\n \
    \       if l > r:\n            swap(l,r)\n        elif l == r:\n            return\
    \ min(len(S),len(T))\n        return min(min(len(S),len(T)),S.base.RMQ.query(l,r))\n\
    \n    proc cmp*(S,T:StaticString):int=\n        var lcp = lcp(S,T)\n        if\
    \ min(len(S),len(T)) == lcp:\n            if len(S) == len(T):\n             \
    \   return 0\n            elif len(S) < len(T):\n                return -1\n \
    \           else:\n                return 1\n        else:\n            if S[lcp]\
    \ < T[lcp]:\n                return -1\n            else:\n                return\
    \ 1\n\n    proc `<`*(S,T:StaticString):bool=\n        return cmp(S,T) < 0\n\n\
    \    proc `>`*(S,T:StaticString):bool=\n        return cmp(S,T) > 0\n\n    proc\
    \ `<=`*(S,T:StaticString):bool=\n        return cmp(S,T) <= 0\n    \n    proc\
    \ `>=`*(S,T:StaticString):bool=\n        return cmp(S,T) >= 0\n\n    proc `==`*(S,T:StaticString):bool=\n\
    \        return len(S) == len(T) and lcp(S,T) == len(S)\n\n    proc initSuffixArray*(base:StaticStringBase):seq[StaticSTring]=\n\
    \        result = newseq[StaticString](base.size)\n        for i in 0..<base.size:\n\
    \            result[i].base = base\n            result[i].l = base.SA[i]\n   \
    \         result[i].r = base.size\n\n    proc initSuffixArray*(S:StaticString):seq[StaticString]=\n\
    \        var SA = suffix_array(S.base.S[S.l..<S.r])\n        result = newseq[StaticString](len(SA))\n\
    \        for i in 0..<len(SA):\n            result[i].base = S.base\n        \
    \    result[i].l = SA[i]+S.l\n            result[i].r = S.r\n    \n    proc toStaticStrings*(strings:seq[string]):seq[StaticString]=\n\
    \        var tmp = \"\"\n        for i in 0..<len(strings):\n            tmp &=\
    \ strings[i]\n            tmp &= '$'\n        var base = initStaticStringBase(tmp)\n\
    \        result = newseq[StaticString](len(strings))\n        var now = 0\n  \
    \      for i in 0..<len(strings):\n            result[i].base = base\n       \
    \     result[i].l = now\n            result[i].r = now+len(strings[i])\n     \
    \       now += len(strings[i]) + 1\n        \n    proc startsWith*(s,prefix:StaticString):bool=\n\
    \        return lcp(s,prefix) == len(prefix)\n    \n    \n    proc suffix_lowerbound*(base:StaticStringBase,S:string):int=\n\
    \        proc cmp(x:int,s:string):int=\n            for i in 0..<len(s):\n   \
    \             if i+x >= base.size:return -1\n                if base.S[i+x] <\
    \ s[i]:return -1\n                if base.S[i+x] > s[i]:return 1\n           \
    \ return 0\n        return base.SA.lowerBound(S,cmp)\n\n    proc suffix_upperbound*(base:StaticStringBase,S:string):int=\n\
    \        proc cmp(x:int,s:string):int=\n            for i in 0..<len(s):\n   \
    \             if i+x >= base.size:return -1\n                if base.S[i+x] <\
    \ s[i]:return -1\n                if base.S[i+x] > s[i]:return 1\n           \
    \ return 0\n        return base.SA.upperBound(S,cmp)\n\n    proc count*(base:StaticStringBase,S:string):int=\n\
    \        return base.suffix_upperbound(S) - base.suffix_lowerbound(S)\n    "
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: false
  path: cplib/str/static_string.nim
  requiredBy:
  - verify/str/static_string/static_string_count_test_.nim
  - verify/str/static_string/static_string_count_test_.nim
  timestamp: '2024-07-19 14:19:21+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/static_string/static_string_zalgo_test.nim
  - verify/str/static_string/static_string_zalgo_test.nim
  - verify/str/static_string/static_string_initSA_test.nim
  - verify/str/static_string/static_string_initSA_test.nim
  - verify/str/static_string/static_string_LCS_test.nim
  - verify/str/static_string/static_string_LCS_test.nim
  - verify/str/static_string/static_string_lcp_test.nim
  - verify/str/static_string/static_string_lcp_test.nim
  - verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_useSA_test.nim
  - verify/str/static_string/static_string_LCS_useSA_test.nim
  - verify/str/static_string/static_string_SA_test.nim
  - verify/str/static_string/static_string_SA_test.nim
  - verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
documentation_of: cplib/str/static_string.nim
layout: document
redirect_from:
- /library/cplib/str/static_string.nim
- /library/cplib/str/static_string.nim.html
title: cplib/str/static_string.nim
---
