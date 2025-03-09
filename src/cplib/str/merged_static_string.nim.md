---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/staticRMQ.nim
    title: cplib/collections/staticRMQ.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
  - icon: ':warning:'
    path: verify/str/merged_static_string.nim
    title: verify/str/merged_static_string.nim
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
  code: "when not declared CPLIB_STR_MERGED_STATIC_STRING:\n    const CPLIB_STR_MERGED_STATIC_STRING*\
    \ = 1\n    import cplib/str/static_string\n    import algorithm\n\n    type MergedStaticString*\
    \ = object\n        S : seq[StaticString]\n        lencum : seq[int]\n    \n \
    \   proc `&`*(S,T:StaticString):MergedStaticString=\n        result.S = @[S,T]\n\
    \        result.lencum = @[len(S),len(S)+len(T)]\n    proc `&=`*(S:var MergedStaticString,T:StaticString)=\n\
    \        if S.S.len == 0:\n            S.S = @[T]\n            S.lencum = @[len(T)]\n\
    \        else:\n            S.S.add(T)\n            S.lencum.add(S.lencum[^1]\
    \ + len(T))\n    proc `&`*(S:MergedStaticString,T:StaticString):MergedStaticString=\n\
    \        result = S\n        result &= T\n    \n\n\n    proc initMergedStaticString*(S:seq[StaticString]):MergedStaticString=\n\
    \        result.S = S\n        result.lencum = newSeq[int](len(S))\n        result.lencum[0]\
    \ = len(S[0])\n        for i in 1..<len(S):\n            result.lencum[i] = result.lencum[i-1]\
    \ + len(S[i])\n\n    proc len*(S:MergedStaticString):int=\n        if S.lencum.len\
    \ == 0:\n            return 0\n        else:\n            return S.lencum[^1]\n\
    \n    proc `[]`*(S:MergedStaticString,idx:int):char=\n        var tmp = S.lencum.upperBound(idx)\n\
    \        if tmp == 0:\n            return S.S[0][idx]\n        else:\n       \
    \     return S.S[tmp][idx-S.lencum[tmp-1]]\n\n    proc `[]`*(S:MergedStaticString,slice:HSlice[int,int]):MergedStaticString=\n\
    \        var tmp = 0\n        for i in 0..<len(S.S):\n            if tmp < slice.a:\n\
    \                if slice.b < S.lencum[i]:\n                    result &= S.S[i][(slice.a-tmp)..(slice.b-tmp)]\n\
    \                elif slice.a < S.lencum[i]:\n                    result &= S.S[i][(slice.a-tmp)..<len(S.S[i])]\n\
    \            elif S.lencum[i] <= slice.b:\n                result &= S.S[i]\n\
    \            elif tmp <= slice.b:\n                result &= S.S[i][0..(slice.b-tmp)]\n\
    \            tmp = S.lencum[i]\n\n\n\n    proc lcp*(S,T:MergedStaticString):int=\n\
    \        if S.S.len == 0 or T.S.len == 0:\n            return 0\n        var s\
    \ = S.S[0]\n        var t = T.S[0]\n        var si = 0\n        var ti = 0\n \
    \       while true:\n            var tmp = lcp(s,t)\n            if tmp == len(s)\
    \ and tmp == len(t):\n                si += 1\n                ti += 1\n     \
    \           result += tmp\n                if si == len(S.S) or ti == len(T.S):\n\
    \                    return result\n                s = S.S[si]\n            \
    \    t = T.S[ti]\n            elif tmp == len(s):\n                si += 1\n \
    \               result += tmp\n                if si == len(S.S):\n          \
    \          return result\n                s = S.S[si]\n                t = t[tmp..<len(t)]\n\
    \            elif tmp == len(t):\n                ti += 1\n                result\
    \ += tmp\n                if ti == len(T.S):\n                    return result\n\
    \                s = s[tmp..<len(s)]\n                t = T.S[ti]\n          \
    \  else:\n                return result + tmp\n\n    proc cmp*(S,T:MergedStaticString):int=\n\
    \        var lcp = lcp(S,T)\n        if min(len(S),len(T)) == lcp:\n         \
    \   if len(S) == len(T):\n                return 0\n            elif len(S) <\
    \ len(T):\n                return -1\n            else:\n                return\
    \ 1\n        else:\n            if S[lcp] < T[lcp]:\n                return -1\n\
    \            else:\n                return 1\n\n    proc `<`*(S,T:MergedStaticString):bool=\n\
    \        return cmp(S,T) < 0\n\n    proc `>`*(S,T:MergedStaticString):bool=\n\
    \        return cmp(S,T) > 0\n\n    proc `<=`*(S,T:MergedStaticString):bool=\n\
    \        return cmp(S,T) <= 0\n\n    proc `>=`*(S,T:MergedStaticString):bool=\n\
    \        return cmp(S,T) >= 0\n\n    proc `==`*(S,T:MergedStaticString):bool=\n\
    \        return len(S) == len(T) and lcp(S,T) == len(S)\n\n    proc `$`*(S:MergedStaticString):string=\n\
    \        result = \"\"\n        for i in 0..<len(S.S):\n            result &=\
    \ $(S.S[i])\n        return result"
  dependsOn:
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  isVerificationFile: false
  path: cplib/str/merged_static_string.nim
  requiredBy:
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  timestamp: '2024-11-28 13:16:15+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/str/merged_static_string.nim
layout: document
redirect_from:
- /library/cplib/str/merged_static_string.nim
- /library/cplib/str/merged_static_string.nim.html
title: cplib/str/merged_static_string.nim
---
