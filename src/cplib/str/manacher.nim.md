---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/get_palindromes_test.nim
    title: verify/str/get_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/get_palindromes_test.nim
    title: verify/str/get_palindromes_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/manacher_test.nim
    title: verify/str/manacher_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/manacher_test.nim
    title: verify/str/manacher_test.nim
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
  code: "when not declared CPLIB_STR_MANACHER:\n    const CPLIB_STR_MANACHER* = 1\n\
    \    import sequtils\n    proc manacher*[T](s: seq[T]): seq[int] =\n        result\
    \ = newSeq[int](s.len)\n        result[0] = 0\n        var c = 0\n        for\
    \ i in 0..<s.len:\n            var l = 2*c - i\n            if l in 0..<s.len\
    \ and i + result[l] < c + result[c]:\n                result[i] = result[l]\n\
    \            else:\n                var j = c + result[c] - i\n              \
    \  while i-j >= 0 and i+j < s.len and s[i-j] == s[i+j]: j += 1\n             \
    \   result[i] = j\n                c = i\n    proc manacher*(s: string): seq[int]\
    \ = manacher(s.toSeq)\n\n    proc get_palindromes*[T](S:seq[T],partition:T): seq[(int,int)]=\n\
    \        if len(S) == 0:\n            return @[]\n        result = newseq[(int,int)](2*len(S)-1)\n\
    \        var tmp = newseqwith(2*len(S)-1,partition)\n        for i in 0..<len(S):\n\
    \            tmp[i*2] = S[i]\n        var mana = manacher(tmp)\n        for i\
    \ in 0..<(2*len(S)-1):\n            if i mod 2 == 0:\n                var x =\
    \ (mana[i]+1) div 2 - 1\n                var idx = i div 2\n                result[i]\
    \ = (idx-x,idx+x+1)\n            else:\n                var x = mana[i] div 2\n\
    \                if x == 0:\n                    result[i] = (-1,-1)\n       \
    \         else:\n                    var idx = i div 2 + 1\n                 \
    \   result[i] = (idx-x,idx+x)\n\n    proc get_palindromes*(s:string,partition:char\
    \ = '$') : seq[(int,int)]=\n        ## S\u306B\u542B\u307E\u308C\u308B\u56DE\u6587\
    \u306E\u4E2D\u5FC3\u3068\u3057\u3066\u8003\u3048\u3089\u308C\u308B\u4F4D\u7F6E\
    \u306F\u6587\u5B57\u3001\u6587\u5B57\u3068\u6587\u5B57\u306E\u9593\u306E2N-1\u901A\
    \u308A\n        ## \u3053\u308C\u3089\u306B\u3064\u3044\u3066\u3001\u305D\u306E\
    \u4F4D\u7F6E\u3092\u4E2D\u5FC3\u3068\u3059\u308B\u56DE\u6587\u3092[l,r)\u306E\
    tuple\u3067\u8FD4\u3059\u3002\n        ## \u305F\u3060\u3057\u3001\u5B58\u5728\
    \u3057\u306A\u3044\u5834\u5408\u306F(-1,-1)\u3092\u8FD4\u3059\u3002\n        ##\
    \ partition\u306Fs\u306B\u542B\u307E\u308C\u306A\u3044\n        return get_palindromes(s.toseq(),partition)\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/manacher.nim
  requiredBy: []
  timestamp: '2026-04-05 17:46:13+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/manacher_test.nim
  - verify/str/manacher_test.nim
  - verify/str/get_palindromes_test.nim
  - verify/str/get_palindromes_test.nim
documentation_of: cplib/str/manacher.nim
layout: document
redirect_from:
- /library/cplib/str/manacher.nim
- /library/cplib/str/manacher.nim.html
title: cplib/str/manacher.nim
---
