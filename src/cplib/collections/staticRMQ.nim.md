---
data:
  _extendedDependsOn: []
  _extendedRequiredBy:
  - icon: ':warning:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':warning:'
    path: cplib/str/merged_static_string.nim
    title: cplib/str/merged_static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
  - icon: ':heavy_check_mark:'
    path: cplib/str/static_string.nim
    title: cplib/str/static_string.nim
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
    links:
    - https://maspypy.com/library-checker-static-rmq
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_COLLECTIONS_STATICRMQ:\n    const CPLIB_COLLECTIONS_STATICRMQ*\
    \ = 1\n    import sequtils,bitops\n    # https://maspypy.com/library-checker-static-rmq\n\
    \    type StaticRMQ*[T] = object\n        table : seq[seq[T]]\n        size :\
    \ int\n        prefix_product : seq[T]\n        suffix_product : seq[T]\n    \
    \    V : seq[T]\n    proc initRMQ*[T](V:seq[T]):StaticRMQ[T]=\n        result.V\
    \ = V\n        if len(V) == 0:\n            return StaticRMQ[T](size:0)\n    \
    \    const B = 16\n        const sft = 4\n        const mask = 0b1111\n      \
    \  result.size = len(V)\n        result.prefix_product = newseq[T](len(V))\n \
    \       result.suffix_product = newseq[T](len(V))\n        for i in 0..<len(V):\n\
    \            if (i and mask) == 0:\n                result.prefix_product[i] =\
    \ V[i]\n            else:\n                result.prefix_product[i] = min(result.prefix_product[i-1],V[i])\n\
    \        result.suffix_product[^1] = V[^1]\n        for i in countdown(len(V)-2,0,1):\n\
    \            if (i and mask) == mask:\n                result.suffix_product[i]\
    \ = V[i]\n            else:\n                result.suffix_product[i] = min(result.suffix_product[i+1],V[i])\n\
    \        \n        var block_len = (len(V)+B-1) div B\n        var b = fastLog2(block_len)\n\
    \        result.table = newSeqwith(fastLog2(block_len)+1,newseq[T](block_len))\n\
    \        for i in 0..<(block_len-1):\n            result.table[0][i] = result.suffix_product[i\
    \ shl sft]\n        result.table[0][block_len-1] = result.suffix_product[^1]\n\
    \        for i in 1..b:\n            var j = 0\n            while j+(1 shl i)\
    \ <= block_len:\n                if result.table[i-1][j] > result.table[i-1][j+(1\
    \ shl (i-1))]:\n                    result.table[i][j] = result.table[i-1][j+(1\
    \ shl (i-1))]\n                else:\n                    result.table[i][j] =\
    \ result.table[i-1][j] \n                j += 1\n    proc query*[T](RMQ:StaticRMQ[T],l,r:int):T=\n\
    \        const sft = 4\n        assert l in 0..<RMQ.size \n        assert r in\
    \ 1..RMQ.size\n        assert l < r\n        var r = r-1\n        var a = l shr\
    \ sft\n        var b = r shr sft\n        if a < b:\n            if a+1 < b:\n\
    \                var k = fastLog2(b-a-1)\n                if RMQ.table[k][a+1]\
    \ > RMQ.table[k][b-(1 shl k)]:\n                    return min(RMQ.table[k][b-(1\
    \ shl k)],min(RMQ.suffix_product[l],RMQ.prefix_product[r]))\n                else:\n\
    \                    return min(RMQ.table[k][a+1],min(RMQ.suffix_product[l],RMQ.prefix_product[r]))\n\
    \            else:\n                return min(RMQ.suffix_product[l],RMQ.prefix_product[r])\n\
    \        \n        result = RMQ.V[l]\n        for i in (l+1)..r:\n           \
    \ if RMQ.V[i] < result:\n                result = RMQ.V[i]\n        return result"
  dependsOn: []
  isVerificationFile: false
  path: cplib/collections/staticRMQ.nim
  requiredBy:
  - cplib/str/static_string.nim
  - cplib/str/static_string.nim
  - cplib/str/merged_static_string.nim
  - cplib/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  - verify/str/merged_static_string.nim
  - verify/str/static_string/static_string_count_test_.nim
  - verify/str/static_string/static_string_count_test_.nim
  timestamp: '2026-02-11 05:00:27+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/collections/staticRMQ_test.nim
  - verify/collections/staticRMQ_test.nim
  - verify/str/static_string/static_string_lcp_test.nim
  - verify/str/static_string/static_string_lcp_test.nim
  - verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_initSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_test.nim
  - verify/str/static_string/static_string_LCS_test.nim
  - verify/str/static_string/static_string_initSA_test.nim
  - verify/str/static_string/static_string_initSA_test.nim
  - verify/str/static_string/static_string_zalgo_test.nim
  - verify/str/static_string/static_string_zalgo_test.nim
  - verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_useSA_fromstatic_string_test.nim
  - verify/str/static_string/static_string_LCS_useSA_test.nim
  - verify/str/static_string/static_string_LCS_useSA_test.nim
  - verify/str/static_string/static_string_SA_test.nim
  - verify/str/static_string/static_string_SA_test.nim
documentation_of: cplib/collections/staticRMQ.nim
layout: document
redirect_from:
- /library/cplib/collections/staticRMQ.nim
- /library/cplib/collections/staticRMQ.nim.html
title: cplib/collections/staticRMQ.nim
---
