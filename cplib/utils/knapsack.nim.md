---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_01knapsack_MIM_test.nim
    title: verify/utils/knapsack/solve_01knapsack_MIM_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_01knapsack_MIM_test.nim
    title: verify/utils/knapsack/solve_01knapsack_MIM_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_01knapsack_NV_test.nim
    title: verify/utils/knapsack/solve_01knapsack_NV_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_01knapsack_NV_test.nim
    title: verify/utils/knapsack/solve_01knapsack_NV_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_01knapsack_NW_test.nim
    title: verify/utils/knapsack/solve_01knapsack_NW_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_01knapsack_NW_test.nim
    title: verify/utils/knapsack/solve_01knapsack_NW_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_Bknapsack_test.nim
    title: verify/utils/knapsack/solve_Bknapsack_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_Bknapsack_test.nim
    title: verify/utils/knapsack/solve_Bknapsack_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_UBknapsack_NW_test.nim
    title: verify/utils/knapsack/solve_UBknapsack_NW_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/utils/knapsack/solve_UBknapsack_NW_test.nim
    title: verify/utils/knapsack/solve_UBknapsack_NW_test.nim
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
  code: "when not declared CPLIB_UTILS_KNAPSACK:\n    const CPLIB_UTILS_KNAPSACK*\
    \ = 1\n    import sequtils,math,bitops,algorithm\n    import cplib/utils/constants\n\
    \    proc solve_01knapsack_NW*(items:seq[tuple[v:int,w:int]],W:int):int=\n   \
    \     ## sum(w_i) <= W\u3068\u306A\u308B\u3088\u3046\u306Aitem\u306E\u53D6\u308A\
    \u65B9\u3067\u3001v\u304C\u6700\u5927\u306E\u3082\u306E\u3092\u9078\u3076\n  \
    \      ## O(NW)\n        var DP = newseqwith(W+1,-INF64)\n        DP[0] = 0\n\
    \        for i in 0..<len(items):\n            var (v,w) = items[i]\n        \
    \    for j in countdown(W-w,0,1):\n                DP[j+w] = max(DP[j+w],DP[j]+v)\n\
    \        return DP.max()\n\n    proc solve_01knapsack_NV*(items:seq[tuple[v:int,w:int]],W:int):int=\n\
    \        ## sum(w_i) <= W\u3068\u306A\u308B\u3088\u3046\u306Aitem\u306E\u53D6\u308A\
    \u65B9\u3067\u3001v\u304C\u6700\u5927\u306E\u3082\u306E\u3092\u9078\u3076\n  \
    \      ## O(N sum(v_i))\n        var V = items.mapit(it.v).sum()\n        var\
    \ DP = newseqwith(V+1,INF64)\n        DP[0] = 0\n        for i in 0..<len(items):\n\
    \            var (v,w) = items[i]\n            for j in countdown(V-v,0,1):\n\
    \                DP[j+v] = min(DP[j+v],DP[j]+w)\n        for i in countdown(V,0,1):\n\
    \            if DP[i] <= W:\n                return i\n\n    proc solve_01knapsack_meet_in_middle*(items:seq[tuple[v:int,w:int]],W:int):int=\n\
    \        ## sum(w_i) <= W\u3068\u306A\u308B\u3088\u3046\u306Aitem\u306E\u53D6\u308A\
    \u65B9\u3067\u3001v\u304C\u6700\u5927\u306E\u3082\u306E\u3092\u9078\u3076\n  \
    \      ## O(N 2^{N/2})\n        \n        proc naive_knapsack(items:seq[tuple[v:int,w:int]]):seq[tuple[v:int,w:int]]=\n\
    \            var X = len(items)\n            result = newseqwith(1 shl X,(0,0))\n\
    \            for bit in 1..<(1 shl X):\n                var i = fastLog2(bit)\n\
    \                var (v,w) = result[bit xor (1 shl i)]\n                result[bit]\
    \ = (v+items[i].v,w+items[i].w)\n        \n        var A = naive_knapsack(items[0..<(len(items)\
    \ div 2)])\n        var B = naive_knapsack(items[(len(items) div 2)..<(len(items))]).mapit((it[1],it[0])).sorted()\n\
    \        for i in 1..<len(B):\n            B[i][1] = max(B[i][1],B[i-1][1])\n\
    \        var ans = -INF64\n        for (v,w) in A:\n            if w > W:\n  \
    \              continue\n            var (a,b) = B[B.lowerBound((W-w,INF64))-1]\n\
    \            ans = max(ans,b+v)\n        return ans\n    \n    proc solve_UBknapsack_NW*(items:seq[tuple[v:int,w:int]],W:int):int=\n\
    \        ## \u5404\u30A2\u30A4\u30C6\u30E0\u3092\u4F55\u56DE\u3067\u3082\u9078\
    \u3093\u3067\u3044\u3044\u30CA\u30C3\u30D7\u30B5\u30C3\u30AF\u554F\u984C\n   \
    \     ## O(NW)\n        var DP = newseqwith(W+1,-INF64)\n        DP[0] = 0\n \
    \       for i in 0..<len(items):\n            var (v,w) = items[i]\n         \
    \   for j in 0..(W-w):\n                DP[j+w] = max(DP[j+w],DP[j]+v)\n     \
    \   return DP.max()\n    \n    proc solve_BoundedKnapsack*(items:seq[tuple[v:int,w:int,m:int]],\
    \ W:int):int =\n        var dp = newSeq[int](W + 1)\n        for (v, w, m0) in\
    \ items:\n            if w > W:\n                continue\n            if w ==\
    \ 0:\n                for i in 0..W:\n                    dp[i] += v*m0\n    \
    \            continue\n            let m = min(m0, W div w)\n            var buf\
    \ = dp\n            var s = 0\n            while s * w <= W:\n               \
    \ let l = s * w\n                let r = min(W + 1, (s + m) * w)\n           \
    \     for i in l ..< r - w:\n                    dp[i + w] = max(dp[i + w], dp[i]\
    \ + v)\n                for i in countdown(r - w - 1, l):\n                  \
    \  buf[i] = max(buf[i], buf[i + w] - v)\n                s += m\n            for\
    \ i in w * m .. W:\n                dp[i] = max(dp[i], buf[i - w * m] + v * m)\n\
    \        return dp[W]"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/utils/knapsack.nim
  requiredBy: []
  timestamp: '2026-05-26 07:40:48+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/utils/knapsack/solve_01knapsack_MIM_test.nim
  - verify/utils/knapsack/solve_01knapsack_MIM_test.nim
  - verify/utils/knapsack/solve_UBknapsack_NW_test.nim
  - verify/utils/knapsack/solve_UBknapsack_NW_test.nim
  - verify/utils/knapsack/solve_01knapsack_NV_test.nim
  - verify/utils/knapsack/solve_01knapsack_NV_test.nim
  - verify/utils/knapsack/solve_01knapsack_NW_test.nim
  - verify/utils/knapsack/solve_01knapsack_NW_test.nim
  - verify/utils/knapsack/solve_Bknapsack_test.nim
  - verify/utils/knapsack/solve_Bknapsack_test.nim
documentation_of: cplib/utils/knapsack.nim
layout: document
redirect_from:
- /library/cplib/utils/knapsack.nim
- /library/cplib/utils/knapsack.nim.html
title: cplib/utils/knapsack.nim
---
