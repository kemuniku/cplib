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
  - icon: ':heavy_check_mark:'
    path: cplib/graph/maxk_dijkstra.nim
    title: cplib/graph/maxk_dijkstra.nim
  - icon: ':heavy_check_mark:'
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
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/graph_weight_type_test.nim
    title: verify/AI/graph_weight_type_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/tsp_test.nim
    title: verify/AI/tsp_test.nim
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
  code: "when not declared CPLIB_GRAPH_TSP:\n    const CPLIB_GRAPH_TSP* = 1\n    import\
    \ sequtils\n    import cplib/utils/constants\n    import cplib/graph/graph\n \
    \   import cplib/graph/dijkstra\n    import cplib/graph/maxk_dijkstra\n\n    proc\
    \ solveTSP[T](dist: seq[seq[T]], start: seq[T], inf: T): seq[seq[T]] =\n     \
    \   var N = len(dist)\n        var DP = newSeqWith(N, newSeqWith(1 shl N, inf))\n\
    \        for i in 0..<(N):\n            DP[i][(1 shl i)] = start[i]\n        for\
    \ bit in 0..<(1 shl N):\n            for i in 0..<N:\n                if ((bit\
    \ and (1 shl i)) != 0):\n                    if DP[i][bit] == inf: continue\n\
    \                    for j in 0..<N:\n                        if (bit and (1 shl\
    \ j)) == 0:\n                            DP[j][bit or (1 shl j)] = min(DP[j][bit\
    \ or (1 shl j)],DP[i][bit] + dist[i][j])\n        return DP\n\n    proc tspPathCostFrom_impl[T](dist:\
    \ openArray[seq[T]], start_v: int, zero, inf: T, floydwarshall: bool): T =\n \
    \       ## start_v\u304B\u3089\u3059\u3079\u3066\u306E\u9802\u70B9\u3092\u8A2A\
    \u554F\u3057\u3066\u3001\u7D42\u70B9\u306F\u3069\u3053\u3067\u3082\u3044\u3044\
    \u3068\u304D\u306E\u30B3\u30B9\u30C8\u306E\u6700\u5C0F\u5024\n        var dist\
    \ = @dist\n        if floydwarshall:\n            for k in 0..<len(dist):\n  \
    \              for i in 0..<len(dist):\n                    for j in 0..<len(dist):\n\
    \                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])\n\
    \        var start = newSeqWith(len(dist), inf)\n        start[start_v] = zero\n\
    \        var res = solveTSP(dist, start, inf)\n        result = inf\n        for\
    \ i in 0..<len(dist):\n            result = min(result,res[i][^1])\n        return\
    \ result\n\n    proc tspPathCostFrom*(dist: openArray[seq[int]], start_v: int,\
    \ floydwarshall: bool = true): int =\n        tspPathCostFrom_impl(dist, start_v,\
    \ 0, INF64, floydwarshall)\n    proc tspPathCostFrom*(dist: openArray[seq[int32]],\
    \ start_v: int, floydwarshall: bool = true): int32 =\n        tspPathCostFrom_impl(dist,\
    \ start_v, 0.int32, INF32, floydwarshall)\n    proc tspPathCostFrom*(dist: openArray[seq[float]],\
    \ start_v: int, floydwarshall: bool = true): float =\n        tspPathCostFrom_impl(dist,\
    \ start_v, 0.0, 1e100, floydwarshall)\n    proc tspPathCostFrom*(dist: openArray[seq[float32]],\
    \ start_v: int, floydwarshall: bool = true): float32 =\n        tspPathCostFrom_impl(dist,\
    \ start_v, 0.0'f32, 1e30'f32, floydwarshall)\n    proc tspPathCostFrom*[T](dist:\
    \ openArray[seq[T]], start_v: int, zero, inf: T, floydwarshall: bool = true):\
    \ T =\n        tspPathCostFrom_impl(dist, start_v, zero, inf, floydwarshall)\n\
    \n    proc tspPathCostFromTo_impl[T](dist: openArray[seq[T]], start_v, goal_v:\
    \ int, zero, inf: T, floydwarshall: bool): T =\n        ## start_v\u304B\u3089\
    \u3059\u3079\u3066\u306E\u9802\u70B9\u3092\u8A2A\u554F\u3057\u3066\u3001\u7D42\
    \u70B9\u3082\u6307\u5B9A\u3059\u308B\u30D1\u30BF\u30FC\u30F3\n        var dist\
    \ = @dist\n        if floydwarshall:\n            for k in 0..<len(dist):\n  \
    \              for i in 0..<len(dist):\n                    for j in 0..<len(dist):\n\
    \                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])\n\
    \        var start = newSeqWith(len(dist), inf)\n        start[start_v] = zero\n\
    \        var res = solveTSP(dist, start, inf)\n        result = inf\n        for\
    \ i in 0..<len(dist):\n            result = min(result,res[i][^1] + dist[i][goal_v])\n\
    \        return result\n\n    proc tspPathCostFromTo*(dist: openArray[seq[int]],\
    \ start_v, goal_v: int, floydwarshall: bool = true): int =\n        tspPathCostFromTo_impl(dist,\
    \ start_v, goal_v, 0, INF64, floydwarshall)\n    proc tspPathCostFromTo*(dist:\
    \ openArray[seq[int32]], start_v, goal_v: int, floydwarshall: bool = true): int32\
    \ =\n        tspPathCostFromTo_impl(dist, start_v, goal_v, 0.int32, INF32, floydwarshall)\n\
    \    proc tspPathCostFromTo*(dist: openArray[seq[float]], start_v, goal_v: int,\
    \ floydwarshall: bool = true): float =\n        tspPathCostFromTo_impl(dist, start_v,\
    \ goal_v, 0.0, 1e100, floydwarshall)\n    proc tspPathCostFromTo*(dist: openArray[seq[float32]],\
    \ start_v, goal_v: int, floydwarshall: bool = true): float32 =\n        tspPathCostFromTo_impl(dist,\
    \ start_v, goal_v, 0.0'f32, 1e30'f32, floydwarshall)\n    proc tspPathCostFromTo*[T](dist:\
    \ openArray[seq[T]], start_v, goal_v: int, zero, inf: T, floydwarshall: bool =\
    \ true): T =\n        tspPathCostFromTo_impl(dist, start_v, goal_v, zero, inf,\
    \ floydwarshall)\n\n    proc tspPathAnyStart_impl[T](dist: openArray[seq[T]],\
    \ zero, inf: T, floydwarshall: bool): T =\n        ## \u30B0\u30E9\u30D5\u306E\
    \u4F55\u51E6\u304B\u304B\u3089\u30B9\u30BF\u30FC\u30C8\u3057\u3001\u3059\u3079\
    \u3066\u306E\u9802\u70B9\u3092\u901A\u308B\u307E\u3067\u306E\u30B3\u30B9\u30C8\
    \n        var dist = @dist\n        if floydwarshall:\n            for k in 0..<len(dist):\n\
    \                for i in 0..<len(dist):\n                    for j in 0..<len(dist):\n\
    \                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])\n\
    \        var start = newSeqWith(len(dist), zero)\n        var res = solveTSP(dist,\
    \ start, inf)\n        result = inf\n        for i in 0..<len(dist):\n       \
    \     result = min(result,res[i][^1])\n        return result\n\n    proc tspPathAnyStart*(dist:\
    \ openArray[seq[int]], floydwarshall: bool = true): int =\n        tspPathAnyStart_impl(dist,\
    \ 0, INF64, floydwarshall)\n    proc tspPathAnyStart*(dist: openArray[seq[int32]],\
    \ floydwarshall: bool = true): int32 =\n        tspPathAnyStart_impl(dist, 0.int32,\
    \ INF32, floydwarshall)\n    proc tspPathAnyStart*(dist: openArray[seq[float]],\
    \ floydwarshall: bool = true): float =\n        tspPathAnyStart_impl(dist, 0.0,\
    \ 1e100, floydwarshall)\n    proc tspPathAnyStart*(dist: openArray[seq[float32]],\
    \ floydwarshall: bool = true): float32 =\n        tspPathAnyStart_impl(dist, 0.0'f32,\
    \ 1e30'f32, floydwarshall)\n    proc tspPathAnyStart*[T](dist: openArray[seq[T]],\
    \ zero, inf: T, floydwarshall: bool = true): T =\n        tspPathAnyStart_impl(dist,\
    \ zero, inf, floydwarshall)\n\n    proc toContractionGraph_impl[T](G: WeightedGraph[T],\
    \ v: openArray[int], ZERO, INF: T): WeightedDirectedGraph[T] =\n        result\
    \ = initWeightedDirectedGraph(len(v), T)\n        for i in 0..<len(v):\n     \
    \       var res = G.dijkstra(v[i], ZERO, INF)\n            for j in 0..<len(v):\n\
    \                result.add_edge(i,j,res[v[j]])\n\n    proc toContractionGraph*(G:\
    \ WeightedGraph[int], v: openArray[int]): WeightedDirectedGraph[int] =\n     \
    \   toContractionGraph_impl(G, v, 0, INF64)\n    proc toContractionGraph*(G: WeightedGraph[int32],\
    \ v: openArray[int]): WeightedDirectedGraph[int32] =\n        toContractionGraph_impl(G,\
    \ v, 0.int32, INF32)\n    proc toContractionGraph*(G: WeightedGraph[float], v:\
    \ openArray[int]): WeightedDirectedGraph[float] =\n        toContractionGraph_impl(G,\
    \ v, 0.0, 1e100)\n    proc toContractionGraph*(G: WeightedGraph[float32], v: openArray[int]):\
    \ WeightedDirectedGraph[float32] =\n        toContractionGraph_impl(G, v, 0.0'f32,\
    \ 1e30'f32)\n    proc toContractionGraph*[T](G: WeightedGraph[T], v: openArray[int],\
    \ ZERO, INF: T): WeightedDirectedGraph[T] =\n        toContractionGraph_impl(G,\
    \ v, ZERO, INF)\n    \n    proc toContractionGraph*(G:UnWeightedGraph,v:openArray[int]):WeightedDirectedGraph[int]=\n\
    \        result = initWeightedDirectedGraph(len(v))\n        for i in 0..<len(v):\n\
    \            var res = G.maxk_dijkstra(v[i],1)\n            for j in 0..<len(v):\n\
    \                result.add_edge(i,j,res[v[j]])\n\n    proc to_adjacency_matrix_impl[T](G:\
    \ WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T], none: T): seq[seq[T]]\
    \ =\n        var N = len(G)\n        result = newSeqWith(N, newSeqWith(N, none))\n\
    \n        for i in 0..<N:\n            for (j,c) in G.to_and_cost(i):\n      \
    \          result[i][j] = min(result[i][j],c)\n\n    proc to_adjacency_matrix*(G:\
    \ WeightedDirectedGraph[int] or WeightedDirectedStaticGraph[int], none: int =\
    \ INF64): seq[seq[int]] =\n        to_adjacency_matrix_impl(G, none)\n    proc\
    \ to_adjacency_matrix*(G: WeightedDirectedGraph[int32] or WeightedDirectedStaticGraph[int32],\
    \ none: int32 = INF32): seq[seq[int32]] =\n        to_adjacency_matrix_impl(G,\
    \ none)\n    proc to_adjacency_matrix*(G: WeightedDirectedGraph[float] or WeightedDirectedStaticGraph[float],\
    \ none: float = 1e100): seq[seq[float]] =\n        to_adjacency_matrix_impl(G,\
    \ none)\n    proc to_adjacency_matrix*(G: WeightedDirectedGraph[float32] or WeightedDirectedStaticGraph[float32],\
    \ none: float32 = 1e30'f32): seq[seq[float32]] =\n        to_adjacency_matrix_impl(G,\
    \ none)\n    proc to_adjacency_matrix*[T](G: WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T],\
    \ none: T): seq[seq[T]] =\n        to_adjacency_matrix_impl(G, none)\n"
  dependsOn:
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/maxk_dijkstra.nim
  - cplib/graph/dijkstra.nim
  - cplib/graph/dijkstra.nim
  - cplib/utils/constants.nim
  - cplib/graph/restore_shortest_path_from_prev.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/maxk_dijkstra.nim
  isVerificationFile: false
  path: cplib/graph/tsp.nim
  requiredBy: []
  timestamp: '2026-07-07 07:56:57+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/tsp_test.nim
  - verify/AI/tsp_test.nim
  - verify/AI/graph_weight_type_test.nim
  - verify/AI/graph_weight_type_test.nim
documentation_of: cplib/graph/tsp.nim
layout: document
redirect_from:
- /library/cplib/graph/tsp.nim
- /library/cplib/graph/tsp.nim.html
title: cplib/graph/tsp.nim
---
