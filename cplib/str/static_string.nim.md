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
    path: cplib/str/compressed_trie.nim
    title: cplib/str/compressed_trie.nim
  - icon: ':warning:'
    path: cplib/str/compressed_trie.nim
    title: cplib/str/compressed_trie.nim
  - icon: ':warning:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':warning:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
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
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_STATIC_STRING:\n    const CPLIB_STR_STATIC_STRING*\
    \ = 1\n    import sequtils\n    import algorithm\n    import atcoder/string\n\
    \    import cplib/collections/staticRMQ\n\n    type StaticStringBase* = ref object\n\
    \        S* : string\n        RMQ* : StaticRMQ[int32]\n        SA* : seq[int32]\n\
    \        RSA* : seq[int32]\n        LCP* : seq[int32]\n        size* : int32\n\
    \    type StaticString* = object\n        base* : StaticStringBase\n        l*\
    \ : int32\n        r* : int32\n    proc initStaticStringBase*(S:string):StaticStringBase=\n\
    \        result = StaticStringBase()\n        result.S = S\n        result.SA\
    \ = suffix_array(S).mapit(int32(it))\n        result.RSA = newseq[int32](len(S))\n\
    \        for i in 0.int32()..<len(S).int32():\n            result.RSA[result.SA[i]]\
    \ = i\n        result.LCP = lcp_array(S,result.SA.mapIt(int(it))).mapit(int32(it))\n\
    \        result.RMQ = initRMQ(result.LCP)\n        result.size = len(S).int32()\n\
    \    proc toStaticString*(S:string):StaticString=\n        var base = initStaticStringBase(S)\n\
    \        return StaticString(base:base,l:0,r:len(S).int32())\n\n\n    proc `[]`*(S:StaticString,idx:Natural):char=\n\
    \        assert S.l+idx < S.base.size\n        return S.base.S[S.l+idx]\n\n  \
    \  proc `[]`*(S:StaticString,slice:HSlice[int,int]):StaticString=\n        assert\
    \ slice.a <= slice.b+1 and S.l + slice.b < S.r\n        return StaticString(base:S.base,l:S.l+slice.a.int32(),r:S.l+slice.b.int32()+1)\n\
    \n\n    proc `$`*(S:StaticString):string=S.base.S[S.l..<S.r]\n\n    proc len*(S:StaticString):\
    \ int {.inline.} = S.r - S.l\n\n    proc lcp*(S,T:StaticString):int {.inline.}=\n\
    \        assert S.base == T.base\n        var l = S.base.RSA[S.l]\n        var\
    \ r = S.base.RSA[T.l]\n        if l > r:\n            swap(l,r)\n        elif\
    \ l == r:\n            return min(len(S),len(T))\n        return min(min(len(S),len(T)),S.base.RMQ.query(l,r))\n\
    \n    proc cmp*(S,T:StaticString):int {.inline.}=\n        var lcp = lcp(S,T)\n\
    \        if min(len(S),len(T)) == lcp:\n            if len(S) == len(T):\n   \
    \             return 0\n            elif len(S) < len(T):\n                return\
    \ -1\n            else:\n                return 1\n        else:\n           \
    \ if S[lcp] < T[lcp]:\n                return -1\n            else:\n        \
    \        return 1\n\n    proc `<`*(S,T:StaticString):bool=\n        return cmp(S,T)\
    \ < 0\n\n    proc `>`*(S,T:StaticString):bool=\n        return cmp(S,T) > 0\n\n\
    \    proc `<=`*(S,T:StaticString):bool=\n        return cmp(S,T) <= 0\n    \n\
    \    proc `>=`*(S,T:StaticString):bool=\n        return cmp(S,T) >= 0\n\n    proc\
    \ `==`*(S,T:StaticString):bool=\n        return len(S) == len(T) and lcp(S,T)\
    \ == len(S)\n\n    proc initSuffixArray*(base:StaticStringBase):seq[StaticString]=\n\
    \        result = newseq[StaticString](base.size)\n        for i in 0..<base.size:\n\
    \            result[i].base = base\n            result[i].l = base.SA[i]\n   \
    \         result[i].r = base.size\n\n    proc initSuffixArray*(S:StaticString):seq[StaticString]=\n\
    \        var SA = suffix_array(S.base.S[S.l..<S.r]).mapit(int32(it))\n       \
    \ result = newseq[StaticString](len(SA))\n        for i in 0..<len(SA):\n    \
    \        result[i].base = S.base\n            result[i].l = SA[i]+S.l\n      \
    \      result[i].r = S.r\n    \n    proc toStaticStrings*(strings:seq[string]):seq[StaticString]=\n\
    \        var tmp = \"\"\n        for i in 0..<len(strings):\n            tmp &=\
    \ strings[i]\n            tmp &= '$'\n        var base = initStaticStringBase(tmp)\n\
    \        result = newseq[StaticString](len(strings))\n        var now = int32(0)\n\
    \        for i in 0..<len(strings):\n            result[i].base = base\n     \
    \       result[i].l = now\n            result[i].r = now+len(strings[i]).int32()\n\
    \            now += len(strings[i]).int32() + 1\n        \n    proc startsWith*(s,prefix:StaticString):bool=\n\
    \        return lcp(s,prefix) == len(prefix)\n    \n    \n    proc suffix_lowerbound*(base:StaticStringBase,S:string):int=\n\
    \        proc cmp(x:int32,s:string):int=\n            for i in 0..<len(s):\n \
    \               if i+x >= base.size:return -1\n                if base.S[i+x]\
    \ < s[i]:return -1\n                if base.S[i+x] > s[i]:return 1\n         \
    \   return 0\n        return base.SA.lowerBound(S,cmp)\n\n    proc suffix_upperbound*(base:StaticStringBase,S:string):int=\n\
    \        proc cmp(x:int32,s:string):int=\n            for i in 0..<len(s):\n \
    \               if i+x >= base.size:return -1\n                if base.S[i+x]\
    \ < s[i]:return -1\n                if base.S[i+x] > s[i]:return 1\n         \
    \   return 0\n        return base.SA.upperBound(S,cmp)\n\n    proc count*(base:StaticStringBase,S:string):int=\n\
    \        return base.suffix_upperbound(S) - base.suffix_lowerbound(S)"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: false
  path: cplib/str/static_string.nim
  requiredBy:
  - verify/str/static_string/static_string_count_test_.nim
  - verify/str/static_string/static_string_count_test_.nim
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  - cplib/str/compressed_trie.nim
  - cplib/str/compressed_trie.nim
  - cplib/str/merged_static_string.nim
  - cplib/str/merged_static_string.nim
  timestamp: '2026-04-15 04:05:21+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/static_string/static_string_LCS_test.nim
  - verify/str/static_string/static_string_LCS_test.nim
  - verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_useSA_test.nim
  - verify/str/static_string/static_string_LCS_useSA_test.nim
  - verify/str/static_string/static_string_zalgo_test.nim
  - verify/str/static_string/static_string_zalgo_test.nim
  - verify/str/static_string/static_string_lcp_test.nim
  - verify/str/static_string/static_string_lcp_test.nim
  - verify/str/static_string/static_string_initSA_test.nim
  - verify/str/static_string/static_string_initSA_test.nim
  - verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_SA_test.nim
  - verify/str/static_string/static_string_SA_test.nim
documentation_of: cplib/str/static_string.nim
layout: document
redirect_from:
- /library/cplib/str/static_string.nim
- /library/cplib/str/static_string.nim.html
title: cplib/str/static_string.nim
---
