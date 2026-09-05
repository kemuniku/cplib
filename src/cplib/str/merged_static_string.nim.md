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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/merged_static_string_test.nim
    title: verify/AI/merged_static_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/merged_static_string_test.nim
    title: verify/AI/merged_static_string_test.nim
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
  code: "when not declared CPLIB_STR_MERGED_STATIC_STRING:\n    const CPLIB_STR_MERGED_STATIC_STRING*\
    \ = 1\n    import cplib/str/static_string\n    import cplib/collections/staticRMQ\n\
    \n    type MergedStaticString*[T] = object\n        base : StaticStringBase[T]\n\
    \        L : seq[int32]\n        R : seq[int32]\n\n    proc addRange[T](S:var\
    \ MergedStaticString[T],base:StaticStringBase[T],l,r:int32) {.inline.}=\n    \
    \    assert l <= r\n        if S.L.len == 0:\n            S.base = base\n    \
    \    else:\n            assert S.base == base\n        S.L.add(l)\n        S.R.add(r)\n\
    \n    proc lcpRange[T](base:StaticStringBase[T],sl,sr,tl,tr:int32):int {.inline.}=\n\
    \        result = min(int(sr-sl),int(tr-tl))\n        if result == 0:\n      \
    \      return\n        var l = base.RSA[sl]\n        var r = base.RSA[tl]\n  \
    \      if l > r:\n            swap(l,r)\n        elif l == r:\n            return\n\
    \        result = min(result,base.RMQ.query(l,r))\n    \n    proc `&`*[Element](S,T:StaticString[Element]):MergedStaticString[Element]=\n\
    \        assert S.base == T.base\n        result.base = S.base\n        result.L\
    \ = @[S.l,T.l]\n        result.R = @[S.r,T.r]\n    proc `&=`*[T](S:var MergedStaticString[T],value:StaticString[T])=\n\
    \        S.addRange(value.base,value.l,value.r)\n    proc `&`*[T](S:MergedStaticString[T],value:StaticString[T]):MergedStaticString[T]=\n\
    \        result = S\n        result &= value\n    \n\n\n    proc initMergedStaticString*[T](S:openArray[StaticString[T]]):MergedStaticString[T]=\n\
    \        if len(S) > 0:\n            result.base = S[0].base\n        result.L\
    \ = newSeq[int32](len(S))\n        result.R = newSeq[int32](len(S))\n        if\
    \ len(S) == 0:\n            return\n        result.L[0] = S[0].l\n        result.R[0]\
    \ = S[0].r\n        for i in 1..<len(S):\n            assert result.base == S[i].base\n\
    \            result.L[i] = S[i].l\n            result.R[i] = S[i].r\n\n    proc\
    \ initMergedStaticString*[T](S:StaticString[T],ranges:seq[(int,int)]):MergedStaticString[T]=\n\
    \        result.base = S.base\n        result.L = newSeq[int32](len(ranges))\n\
    \        result.R = newSeq[int32](len(ranges))\n        for i,(l,r) in ranges:\n\
    \            assert 0 <= l and l <= r and r <= len(S)\n            result.L[i]\
    \ = S.l+l.int32()\n            result.R[i] = S.l+r.int32()\n\n    proc len*[T](S:MergedStaticString[T]):int=\n\
    \        ## \u8A08\u7B97\u91CF\u304C O(\u7D50\u5408\u6570) \u3067\u3042\u308B\u70B9\
    \u306B\u6CE8\u610F\uFF01\n        for i in 0..<len(S.L):\n            result +=\
    \ int(S.R[i]-S.L[i])\n\n    proc `[]`*[T](S:MergedStaticString[T],idx:int):T=\n\
    \        ## \u8A08\u7B97\u91CF\u304C O(\u7D50\u5408\u6570) \u3067\u3042\u308B\u70B9\
    \u306B\u6CE8\u610F\uFF01\n        var offset = idx\n        for i in 0..<len(S.L):\n\
    \            let rangeLength = int(S.R[i]-S.L[i])\n            if offset < rangeLength:\n\
    \                return S.base.S[S.L[i]+offset.int32()]\n            offset -=\
    \ rangeLength\n        raise newException(IndexDefect, \"index out of bounds\"\
    )\n\n    proc `[]`*[T](S:MergedStaticString[T],slice:HSlice[int,int]):MergedStaticString[T]=\n\
    \        var tmp = 0\n        for i in 0..<len(S.L):\n            let next = tmp+int(S.R[i]-S.L[i])\n\
    \            if tmp < slice.a:\n                if slice.b < next:\n         \
    \           result.addRange(S.base,S.L[i]+(slice.a-tmp).int32(),S.L[i]+(slice.b-tmp+1).int32())\n\
    \                elif slice.a < next:\n                    result.addRange(S.base,S.L[i]+(slice.a-tmp).int32(),S.R[i])\n\
    \            elif next <= slice.b:\n                result.addRange(S.base,S.L[i],S.R[i])\n\
    \            elif tmp <= slice.b:\n                result.addRange(S.base,S.L[i],S.L[i]+(slice.b-tmp+1).int32())\n\
    \            tmp = next\n\n\n\n    proc lcp*[Element](S,T:MergedStaticString[Element]):int=\n\
    \        if S.L.len == 0 or T.L.len == 0:\n            return 0\n        assert\
    \ S.base == T.base\n        var si = 0\n        var ti = 0\n        var sl = S.L[0]\n\
    \        var sr = S.R[0]\n        var tl = T.L[0]\n        var tr = T.R[0]\n \
    \       while true:\n            let slen = int(sr-sl)\n            let tlen =\
    \ int(tr-tl)\n            let tmp = lcpRange(S.base,sl,sr,tl,tr)\n           \
    \ if tmp == slen and tmp == tlen:\n                si += 1\n                ti\
    \ += 1\n                result += tmp\n                if si == len(S.L) or ti\
    \ == len(T.L):\n                    return result\n                sl = S.L[si]\n\
    \                sr = S.R[si]\n                tl = T.L[ti]\n                tr\
    \ = T.R[ti]\n            elif tmp == slen:\n                si += 1\n        \
    \        result += tmp\n                if si == len(S.L):\n                 \
    \   return result\n                sl = S.L[si]\n                sr = S.R[si]\n\
    \                tl += tmp.int32()\n            elif tmp == tlen:\n          \
    \      ti += 1\n                result += tmp\n                if ti == len(T.L):\n\
    \                    return result\n                sl += tmp.int32()\n      \
    \          tl = T.L[ti]\n                tr = T.R[ti]\n            else:\n   \
    \             return result + tmp\n\n    proc cmp*[Element](S,T:MergedStaticString[Element]):int=\n\
    \        var si = 0\n        var ti = 0\n        var sl = if S.L.len > 0: S.L[0]\
    \ else: 0'i32\n        var tl = if T.L.len > 0: T.L[0] else: 0'i32\n        while\
    \ true:\n            while si < S.L.len and sl == S.R[si]:\n                si\
    \ += 1\n                if si < S.L.len:\n                    sl = S.L[si]\n \
    \           while ti < T.L.len and tl == T.R[ti]:\n                ti += 1\n \
    \               if ti < T.L.len:\n                    tl = T.L[ti]\n         \
    \   if si == S.L.len:\n                if ti == T.L.len:\n                   \
    \ return 0\n                return -1\n            if ti == T.L.len:\n       \
    \         return 1\n            assert S.base == T.base\n            let limit\
    \ = min(int(S.R[si]-sl),int(T.R[ti]-tl))\n            let commonPrefix = lcpRange(S.base,sl,S.R[si],tl,T.R[ti])\n\
    \            if commonPrefix < limit:\n                if S.base.S[sl+commonPrefix.int32()]\
    \ < T.base.S[tl+commonPrefix.int32()]:\n                    return -1\n      \
    \          return 1\n            sl += commonPrefix.int32()\n            tl +=\
    \ commonPrefix.int32()\n\n    proc `<`*[Element](S,T:MergedStaticString[Element]):bool=\n\
    \        return cmp(S,T) < 0\n\n    proc `>`*[Element](S,T:MergedStaticString[Element]):bool=\n\
    \        return cmp(S,T) > 0\n\n    proc `<=`*[Element](S,T:MergedStaticString[Element]):bool=\n\
    \        return cmp(S,T) <= 0\n\n    proc `>=`*[Element](S,T:MergedStaticString[Element]):bool=\n\
    \        return cmp(S,T) >= 0\n\n    proc `==`*[Element](S,T:MergedStaticString[Element]):bool=\n\
    \        return len(S) == len(T) and lcp(S,T) == len(S)\n\n    proc `$`*[T](S:MergedStaticString[T]):string=\n\
    \        when T is char:\n            for i in 0..<len(S.L):\n               \
    \ for j in S.L[i]..<S.R[i]:\n                    result.add(S.base.S[j])\n   \
    \     else:\n            var first = true\n            for i in 0..<len(S.L):\n\
    \                for j in S.L[i]..<S.R[i]:\n                    if not first:\n\
    \                        result &= \" \"\n                    first = false\n\
    \                    result &= $S.base.S[j]\n"
  dependsOn:
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/collections/staticRMQ.nim
  isVerificationFile: false
  path: cplib/str/merged_static_string.nim
  requiredBy:
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  timestamp: '2026-08-01 10:17:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/merged_static_string_test.nim
  - verify/AI/merged_static_string_test.nim
documentation_of: cplib/str/merged_static_string.nim
layout: document
redirect_from:
- /library/cplib/str/merged_static_string.nim
- /library/cplib/str/merged_static_string.nim.html
title: cplib/str/merged_static_string.nim
---
