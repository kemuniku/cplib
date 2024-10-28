---
data:
  _extendedDependsOn: []
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_test.nim
    title: verify/str/lcs_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/str/lcs_test.nim
    title: verify/str/lcs_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_STR_LCS:\n    const CPLIB_STR_LCS* = 1\n    import\
    \ sequtils,algorithm\n    proc LCS*[T](A,B:seq[T]):int=\n        var DP = newseqwith(len(B)+1,newSeqWith(len(A),0))\n\
    \        for i in 0..<(len(B)):\n            var t = B[i]\n            var now\
    \ = 0\n            for j in 0..<(len(A)):\n                if A[j] == t:\n   \
    \                 var tmp = DP[i][j]\n                    DP[i+1][j] = now+1\n\
    \                    if tmp > now:\n                        now = tmp\n      \
    \          else:\n                    DP[i+1][j] = DP[i][j]\n                \
    \    if DP[i][j] > now:\n                        now = DP[i][j]\n        return\
    \ DP[^1].max\n    \n    proc restoreLCS*[T](A,B:seq[T]):seq[T]=\n        var DP\
    \ = newseqwith(len(B)+1,newSeqWith(len(A),0))\n        for i in 0..<(len(B)):\n\
    \            var t = B[i]\n            var now = 0\n            for j in 0..<(len(A)):\n\
    \                if A[j] == t:\n                    var tmp = DP[i][j]\n     \
    \               DP[i+1][j] = now+1\n                    if tmp > now:\n      \
    \                  now = tmp\n                else:\n                    DP[i+1][j]\
    \ = DP[i][j]\n                    if DP[i][j] > now:\n                       \
    \ now = DP[i][j]\n        var ans : seq[T]\n        var now = DP[^1].maxindex()\n\
    \        for i in countdown(len(B),1):\n            if DP[i-1][now] == DP[i][now]:\n\
    \                continue\n            else:\n                for j in countdown(now-1,0):\n\
    \                    if DP[i-1][j] == DP[i][now]-1:\n                        now\
    \ = j\n                        break\n                ans.add(B[i-1])\n      \
    \  return ans.reversed()"
  dependsOn: []
  isVerificationFile: false
  path: cplib/str/lcs.nim
  requiredBy: []
  timestamp: '2024-10-29 00:24:54+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/str/lcs_test.nim
  - verify/str/lcs_test.nim
documentation_of: cplib/str/lcs.nim
layout: document
redirect_from:
- /library/cplib/str/lcs.nim
- /library/cplib/str/lcs.nim.html
title: cplib/str/lcs.nim
---
