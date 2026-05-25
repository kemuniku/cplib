---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/dijkstra.nim
    title: cplib/graph/dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':warning:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':warning:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/restore_shortest_path_from_prev.nim
    title: cplib/graph/restore_shortest_path_from_prev.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy: []
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
  code: "when not declared CPLIB_GRAPH_TSP:\n    const CPLIB_GRAPH_TSP* = 1\n    import\
    \ sequtils\n    import cplib/utils/constants\n    import cplib/graph/graph\n \
    \   import cplib/graph/dijkstra\n    import cplib/graph/maxk_dijkstra\n\n    proc\
    \ solveTSP(dist:seq[seq[int]],start:seq[int]):seq[seq[int]]=\n        var N =\
    \ len(dist)\n        var DP = newseqwith(N,newseqwith(1 shl N,INF64))\n      \
    \  for i in 0..<(N):\n            DP[i][(1 shl i)] = start[i]\n        for bit\
    \ in 0..<(1 shl N):\n            for i in 0..<N:\n                if ((bit and\
    \ (1 shl i)) != 0):\n                    if DP[i][bit] == INF64: continue\n  \
    \                  for j in 0..<N:\n                        if (bit and (1 shl\
    \ j)) == 0:\n                            DP[j][bit or (1 shl j)] = min(DP[j][bit\
    \ or (1 shl j)],DP[i][bit] + dist[i][j])\n        return DP\n\n    proc tspPathCostFrom*(dist:seq[seq[int]],start_v:int,floydwarshall:bool=true):int=\n\
    \        ## start_v\u304B\u3089\u3059\u3079\u3066\u306E\u9802\u70B9\u3092\u8A2A\
    \u554F\u3057\u3066\u3001\u7D42\u70B9\u306F\u3069\u3053\u3067\u3082\u3044\u3044\
    \u3068\u304D\u306E\u30B3\u30B9\u30C8\u306E\u6700\u5C0F\u5024\n        var dist\
    \ = dist\n        if floydwarshall:\n            for k in 0..<len(dist):\n   \
    \             for i in 0..<len(dist):\n                    for j in 0..<len(dist):\n\
    \                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])\n\
    \        var start = newseqwith(len(dist),INF64)\n        start[start_v] = 0\n\
    \        var res = solveTSP(dist,start)\n        result = INF64\n        for i\
    \ in 0..<len(dist):\n            result = min(result,res[i][^1])\n        return\
    \ result\n\n    proc tspPathCostFromTo*(dist:seq[seq[int]],start_v:int,goal_v:int,floydwarshall:bool=true):int=\n\
    \        ## start_v\u304B\u3089\u3059\u3079\u3066\u306E\u9802\u70B9\u3092\u8A2A\
    \u554F\u3057\u3066\u3001\u7D42\u70B9\u3082\u6307\u5B9A\u3059\u308B\u30D1\u30BF\
    \u30FC\u30F3\n        var dist = dist\n        if floydwarshall:\n           \
    \ for k in 0..<len(dist):\n                for i in 0..<len(dist):\n         \
    \           for j in 0..<len(dist):\n                        dist[i][j] = min(dist[i][j],dist[i][k]\
    \ + dist[k][j])\n        var start = newseqwith(len(dist),INF64)\n        start[start_v]\
    \ = 0\n        var res = solveTSP(dist,start)\n        result = INF64\n      \
    \  for i in 0..<len(dist):\n            result = min(result,res[i][^1] + dist[i][goal_v])\n\
    \        return result\n\n    proc tspPathAnyStart*(dist:seq[seq[int]],floydwarshall:bool=true):int=\n\
    \        ## \u30B0\u30E9\u30D5\u306E\u4F55\u51E6\u304B\u304B\u3089\u30B9\u30BF\
    \u30FC\u30C8\u3057\u3001\u3059\u3079\u3066\u306E\u9802\u70B9\u3092\u901A\u308B\
    \u307E\u3067\u306E\u30B3\u30B9\u30C8\n        var dist = dist\n        if floydwarshall:\n\
    \            for k in 0..<len(dist):\n                for i in 0..<len(dist):\n\
    \                    for j in 0..<len(dist):\n                        dist[i][j]\
    \ = min(dist[i][j],dist[i][k] + dist[k][j])\n        var start = newseqwith(len(dist),0)\n\
    \        var res = solveTSP(dist,start)\n        result = INF64\n        for i\
    \ in 0..<len(dist):\n            result = min(result,res[i][^1])\n        return\
    \ result\n\n\n    proc toContractionGraph*(G:WeightedGraph[int],v:seq[int]):WeightedDirectedGraph[int]=\n\
    \        result = initWeightedDirectedGraph(len(v))\n        for i in 0..<len(v):\n\
    \            var res = G.dijkstra(v[i])\n            for j in 0..<len(v):\n  \
    \              result.add_edge(i,j,res[v[j]])\n    \n    proc toContractionGraph*(G:UnWeightedGraph,v:seq[int]):WeightedDirectedGraph[int]=\n\
    \        result = initWeightedDirectedGraph(len(v))\n        for i in 0..<len(v):\n\
    \            var res = G.maxk_dijkstra(v[i],1)\n            for j in 0..<len(v):\n\
    \                result.add_edge(i,j,res[v[j]])\n\n    proc to_adjacency_matrix*(G:WeightedDirectedGraph[int],none:int=INF64):seq[seq[int]]=\n\
    \        var N = len(G)\n        result = newseqwith(N,newseqwith(N,none))\n\n\
    \        for i in 0..<N:\n            for (j,c) in G.to_and_cost(i):\n       \
    \         result[i][j] = min(result[i][j],c)\n"
  dependsOn:
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/utils/constants.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  isVerificationFile: false
  path: cplib/graph/tsp.nim
  requiredBy: []
  timestamp: '2026-05-24 07:19:32+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/tsp.nim
layout: document
redirect_from:
- /library/cplib/graph/tsp.nim
- /library/cplib/graph/tsp.nim.html
title: cplib/graph/tsp.nim
---
