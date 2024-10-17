---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/bititers.nim
    title: cplib/utils/bititers.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/steiner_tree_abc364g_test.nim
    title: verify/graph/steiner_tree_abc364g_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/steiner_tree_abc364g_test.nim
    title: verify/graph/steiner_tree_abc364g_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_STEINER_TREE:\n    const CPLIB_GRAPH_RESTORE_STEINER_TREE*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/utils/constants\n    import\
    \ cplib/utils/bititers\n    import sequtils, heapqueue\n    proc steiner_tree_dp*[T](g:\
    \ StaticGraph[T] or DynamicGraph[T], terminal: seq[int], inf: T): seq[seq[T]]\
    \ =\n        ## terminal \u306B\u542B\u307E\u308C\u308B\u9802\u70B9\u3092\u5168\
    \u3066\u9023\u7D50\u306B\u3059\u308B\u305F\u3081\u306B\u5FC5\u8981\u306A\u6700\
    \u5C0F\u306E\u30B3\u30B9\u30C8\u3092\u51FA\u529B\u3059\u308B\u3002\n        ##\
    \ \u8A08\u7B97\u91CF O(n3^t + (n+m)2^tlogn)\n        var k = terminal.len\n  \
    \      var n = g.len\n\n        var dp = newSeqWith((1 shl k), newSeqWith(n, inf))\n\
    \        for i in 0..<k:\n            dp[(1 shl i)][terminal[i]] = 0\n\n     \
    \   for bit in 1..<(1 shl k):\n            for u in 0..<n:\n                for\
    \ bn in bitsubset(bit):\n                    dp[bit][u] = min(dp[bit][u], dp[bn][u]\
    \ + dp[bit xor bn][u])\n            var q = initHeapQueue[(int, int)]()\n    \
    \        for u in 0..<n:\n                q.push((dp[bit][u], u))\n          \
    \  while q.len > 0:\n                var (d, u) = q.pop\n                if dp[bit][u]\
    \ != d: continue\n                for (v, cost) in g.to_and_cost(u):\n       \
    \             if dp[bit][v] > d + cost:\n                        dp[bit][v] =\
    \ d + cost\n                        q.push((dp[bit][v], v))\n        return dp\n\
    \n    proc steiner_tree_mincost_impl[T](g: StaticGraph[T] or DynamicGraph[T],\
    \ terminal: seq[int], inf: T): T =\n        var dp = steiner_tree_dp(g, terminal,\
    \ inf)\n        var k = terminal.len\n        return dp[(1 shl k) - 1][terminal[0]]\n\
    \n    proc steiner_tree_mincost*(g: StaticGraph[int] or DynamicGraph[int], terminal:\
    \ seq[int], inf: int = INF64): int = steiner_tree_mincost_impl(g, terminal, inf)\n\
    \    proc steiner_tree_mincost*(g: StaticGraph[int32] or DynamicGraph[int32],\
    \ terminal: seq[int], inf: int32 = INF32): int32 = steiner_tree_mincost_impl(g,\
    \ terminal, inf)\n    proc steiner_tree_mincost*(g: StaticGraph[float] or DynamicGraph[float],\
    \ terminal: seq[int], inf: float = 1e100): float = steiner_tree_mincost_impl(g,\
    \ terminal, inf)\n    proc steiner_tree_mincost*[T](g: StaticGraph[T] or DynamicGraph[T],\
    \ terminal: seq[int], inf: T): T = steiner_tree_mincost_impl(g, terminal, inf)\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/utils/bititers.nim
  - cplib/utils/bititers.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/steiner_tree.nim
  requiredBy: []
  timestamp: '2024-09-21 03:52:16+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/steiner_tree_abc364g_test.nim
  - verify/graph/steiner_tree_abc364g_test.nim
documentation_of: cplib/graph/steiner_tree.nim
layout: document
redirect_from:
- /library/cplib/graph/steiner_tree.nim
- /library/cplib/graph/steiner_tree.nim.html
title: cplib/graph/steiner_tree.nim
---
