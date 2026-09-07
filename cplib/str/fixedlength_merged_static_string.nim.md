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
  - icon: ':heavy_check_mark:'
    path: cplib/str/repeated_static_string.nim
    title: cplib/str/repeated_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/repeated_static_string.nim
    title: cplib/str/repeated_static_string.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/fixedlength_merged_static_string_test.nim
    title: verify/AI/fixedlength_merged_static_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/fixedlength_merged_static_string_test.nim
    title: verify/AI/fixedlength_merged_static_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/repeated_static_string_test.nim
    title: verify/AI/repeated_static_string_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/repeated_static_string_test.nim
    title: verify/AI/repeated_static_string_test.nim
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
  code: "when not declared CPLIB_STR_FIXEDLENGTH_MERGED_STATIC_STRING:\n    const\
    \ CPLIB_STR_FIXEDLENGTH_MERGED_STATIC_STRING* = 1\n    import cplib/str/static_string\n\
    \    import cplib/collections/staticRMQ\n\n    type FixedLengthMergedStaticString*[T;N:static[int]]\
    \ = object\n        ## N is the number of concatenated ranges.\n        base :\
    \ StaticStringBase[T]\n        L : array[N,int32]\n        R : array[N,int32]\n\
    \n    proc setRange[T;N:static[int]](S:var FixedLengthMergedStaticString[T,N],i:int,base:StaticStringBase[T],l,r:int32)\
    \ {.inline.}=\n        assert l <= r\n        assert i in 0..<N\n        if i\
    \ == 0:\n            S.base = base\n        else:\n            assert S.base ==\
    \ base\n        S.L[i] = l\n        S.R[i] = r\n\n    proc lcpRange[T](base:StaticStringBase[T],sl,sr,tl,tr:int32):int\
    \ {.inline.}=\n        result = min(int(sr-sl),int(tr-tl))\n        if result\
    \ == 0:\n            return\n        var l = base.RSA[sl]\n        var r = base.RSA[tl]\n\
    \        if l > r:\n            swap(l,r)\n        elif l == r:\n            return\n\
    \        result = min(result,base.RMQ.query(l,r))\n\n    proc `&`*[T](S,U:StaticString[T]):FixedLengthMergedStaticString[T,2]=\n\
    \        assert S.base == U.base\n        result.setRange(0,S.base,S.l,S.r)\n\
    \        result.setRange(1,U.base,U.l,U.r)\n\n    template `&`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N],U:StaticString[T]):untyped=\n\
    \        block:\n            let left = S\n            let right = U\n       \
    \     var merged: FixedLengthMergedStaticString[T,N+1]\n            when N > 0:\n\
    \                assert left.base == right.base\n                merged.base =\
    \ left.base\n                for i in 0..<N:\n                    merged.L[i]\
    \ = left.L[i]\n                    merged.R[i] = left.R[i]\n            else:\n\
    \                merged.base = right.base\n            merged.L[N] = right.l\n\
    \            merged.R[N] = right.r\n            merged\n\n    proc initFixedLengthMergedStaticString*[T;N:static[int]](S:array[N,StaticString[T]]):FixedLengthMergedStaticString[T,N]=\n\
    \        for i,value in S:\n            result.setRange(i,value.base,value.l,value.r)\n\
    \n    proc initFixedLengthMergedStaticString*[T;N:static[int]](S:StaticString[T],ranges:array[N,(int,int)]):FixedLengthMergedStaticString[T,N]=\n\
    \        for i,interval in ranges:\n            let (l,r) = interval\n       \
    \     assert 0 <= l and l <= r and r <= len(S)\n            result.setRange(i,S.base,S.l+l.int32(),S.l+r.int32())\n\
    \n    template `&`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):untyped=\n\
    \        block:\n            let left = S\n            let right = U\n       \
    \     var merged: FixedLengthMergedStaticString[T,N+M]\n            when N > 0\
    \ and M > 0:\n                assert left.base == right.base\n            when\
    \ N > 0:\n                merged.base = left.base\n                for i in 0..<N:\n\
    \                    merged.L[i] = left.L[i]\n                    merged.R[i]\
    \ = left.R[i]\n            elif M > 0:\n                merged.base = right.base\n\
    \            for i in 0..<M:\n                merged.L[N+i] = right.L[i]\n   \
    \             merged.R[N+i] = right.R[i]\n            merged\n\n    proc len*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N]):int=\n\
    \        ## O(N), where N is the number of concatenated ranges.\n        for i\
    \ in 0..<N:\n            result += int(S.R[i]-S.L[i])\n\n    proc `[]`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N],idx:int):T=\n\
    \        assert idx in 0..<len(S)\n        var relativeIndex = idx\n        for\
    \ i in 0..<N:\n            let chunkLength = int(S.R[i]-S.L[i])\n            if\
    \ relativeIndex < chunkLength:\n                return S.base.S[S.L[i]+relativeIndex]\n\
    \            relativeIndex -= chunkLength\n        assert false\n        return\
    \ default(T)\n\n    proc `[]`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N],slice:HSlice[int,int]):FixedLengthMergedStaticString[T,N]=\n\
    \        assert 0 <= slice.a and slice.a <= slice.b+1 and slice.b < len(S)\n \
    \       result.base = S.base\n        var previousLength = 0\n        for i in\
    \ 0..<N:\n            let currentLength = previousLength+int(S.R[i]-S.L[i])\n\
    \            let left = max(previousLength,slice.a)\n            let right = min(currentLength,slice.b+1)\n\
    \            if left < right:\n                result.L[i] = S.L[i]+(left-previousLength).int32()\n\
    \                result.R[i] = S.L[i]+(right-previousLength).int32()\n       \
    \     else:\n                result.L[i] = S.L[i]\n                result.R[i]\
    \ = S.L[i]\n            previousLength = currentLength\n\n    proc lcp*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):int=\n\
    \        if N == 0 or M == 0:\n            return 0\n        assert S.base ==\
    \ U.base\n        var si = 0\n        var ui = 0\n        var sl = S.L[0]\n  \
    \      var sr = S.R[0]\n        var ul = U.L[0]\n        var ur = U.R[0]\n   \
    \     while true:\n            let slen = int(sr-sl)\n            let ulen = int(ur-ul)\n\
    \            let tmp = lcpRange(S.base,sl,sr,ul,ur)\n            if tmp == slen\
    \ and tmp == ulen:\n                si += 1\n                ui += 1\n       \
    \         result += tmp\n                if si == N or ui == M:\n            \
    \        return result\n                sl = S.L[si]\n                sr = S.R[si]\n\
    \                ul = U.L[ui]\n                ur = U.R[ui]\n            elif\
    \ tmp == slen:\n                si += 1\n                result += tmp\n     \
    \           if si == N:\n                    return result\n                sl\
    \ = S.L[si]\n                sr = S.R[si]\n                ul += tmp.int32()\n\
    \            elif tmp == ulen:\n                ui += 1\n                result\
    \ += tmp\n                if ui == M:\n                    return result\n   \
    \             sl += tmp.int32()\n                ul = U.L[ui]\n              \
    \  ur = U.R[ui]\n            else:\n                return result+tmp\n\n    proc\
    \ cmp*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):int=\n\
    \        var si = 0\n        var ui = 0\n        var sl = when N > 0: S.L[0] else:\
    \ 0'i32\n        var ul = when M > 0: U.L[0] else: 0'i32\n        while true:\n\
    \            while si < N and sl == S.R[si]:\n                si += 1\n      \
    \          if si < N:\n                    sl = S.L[si]\n            while ui\
    \ < M and ul == U.R[ui]:\n                ui += 1\n                if ui < M:\n\
    \                    ul = U.L[ui]\n            if si == N:\n                if\
    \ ui == M:\n                    return 0\n                return -1\n        \
    \    if ui == M:\n                return 1\n            assert S.base == U.base\n\
    \            let limit = min(int(S.R[si]-sl),int(U.R[ui]-ul))\n            let\
    \ commonPrefix = lcpRange(S.base,sl,S.R[si],ul,U.R[ui])\n            if commonPrefix\
    \ < limit:\n                if S.base.S[sl+commonPrefix.int32()] < U.base.S[ul+commonPrefix.int32()]:\n\
    \                    return -1\n                return 1\n            sl += commonPrefix.int32()\n\
    \            ul += commonPrefix.int32()\n\n    proc `<`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=\n\
    \        return cmp(S,U) < 0\n\n    proc `>`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=\n\
    \        return cmp(S,U) > 0\n\n    proc `<=`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=\n\
    \        return cmp(S,U) <= 0\n\n    proc `>=`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=\n\
    \        return cmp(S,U) >= 0\n\n    proc `==`*[T;N,M:static[int]](S:FixedLengthMergedStaticString[T,N],U:FixedLengthMergedStaticString[T,M]):bool=\n\
    \        return len(S) == len(U) and lcp(S,U) == len(S)\n\n    proc `$`*[T;N:static[int]](S:FixedLengthMergedStaticString[T,N]):string=\n\
    \        when T is char:\n            for i in 0..<N:\n                for j in\
    \ S.L[i]..<S.R[i]:\n                    result.add(S.base.S[j])\n        else:\n\
    \            var first = true\n            for i in 0..<N:\n                for\
    \ j in S.L[i]..<S.R[i]:\n                    if not first:\n                 \
    \       result &= \" \"\n                    first = false\n                 \
    \   result &= $S.base.S[j]\n"
  dependsOn:
  - cplib/collections/staticRMQ.nim
  - cplib/collections/staticRMQ.nim
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  isVerificationFile: false
  path: cplib/str/fixedlength_merged_static_string.nim
  requiredBy:
  - cplib/str/repeated_static_string.nim
  - cplib/str/repeated_static_string.nim
  timestamp: '2026-08-01 10:17:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/fixedlength_merged_static_string_test.nim
  - verify/AI/fixedlength_merged_static_string_test.nim
  - verify/AI/repeated_static_string_test.nim
  - verify/AI/repeated_static_string_test.nim
documentation_of: cplib/str/fixedlength_merged_static_string.nim
layout: document
redirect_from:
- /library/cplib/str/fixedlength_merged_static_string.nim
- /library/cplib/str/fixedlength_merged_static_string.nim.html
title: cplib/str/fixedlength_merged_static_string.nim
---
