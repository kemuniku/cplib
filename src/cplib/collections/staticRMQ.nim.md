---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':warning:'
    path: verify/str/static_string/static_string_count_test_.nim
    title: verify/str/static_string/static_string_count_test_.nim
  - icon: ':warning:'
    path: verify/str/static_string/static_string_count_test_.nim
    title: verify/str/static_string/static_string_count_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/collections/staticRMQ_test.nim
    title: verify/collections/staticRMQ_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/collections/staticRMQ_test.nim
    title: verify/collections/staticRMQ_test.nim
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
  code: "when not declared CPLIB_COLLECTIONS_STATICRMQ:\n    const CPLIB_COLLECTIONS_STATICRMQ*\
    \ = 1\n    import sequtils,bitops\n    type StaticRMQ*[T] = object\n        table\
    \ : seq[seq[T]]\n        size : int\n    proc initRMQ*[T](V:seq[T]):StaticRMQ[T]=\n\
    \        if len(V) == 0:\n            return StaticRMQ[T](size:0)\n        result.size\
    \ = len(V)\n        var b = fastLog2(len(V))\n        result.table = newSeqwith(fastLog2(len(V))+1,newseq[int](len(V)))\n\
    \        for i in 0..<len(V):\n            result.table[0][i] = V[i]\n       \
    \ for i in 1..b:\n            var j = 0\n            while j+(1 shl i) <= len(V):\n\
    \                if result.table[i-1][j] > result.table[i-1][j+(1 shl (i-1))]:\n\
    \                    result.table[i][j] = result.table[i-1][j+(1 shl (i-1))]\n\
    \                else:\n                    result.table[i][j] = result.table[i-1][j]\
    \ \n                j += 1\n    proc query*[T](RMQ:StaticRMQ[T],l,r:int):T=\n\
    \        assert l in 0..<RMQ.size \n        assert r in 1..RMQ.size\n        assert\
    \ l < r\n        var k = fastLog2(r-l)\n        if RMQ.table[k][l] > RMQ.table[k][r-(1\
    \ shl k)]:\n            return RMQ.table[k][r-(1 shl k)]\n        else:\n    \
    \        return RMQ.table[k][l]\n"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/staticRMQ.nim
  requiredBy:
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  - verify/str/static_string/static_string_count_test_.nim
  - verify/str/static_string/static_string_count_test_.nim
  timestamp: '2024-07-19 08:04:11+09:00'
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
  - verify/collections/staticRMQ_test.nim
  - verify/collections/staticRMQ_test.nim
documentation_of: cplib/collections/staticRMQ.nim
layout: document
redirect_from:
- /library/cplib/collections/staticRMQ.nim
- /library/cplib/collections/staticRMQ.nim.html
title: cplib/collections/staticRMQ.nim
---
