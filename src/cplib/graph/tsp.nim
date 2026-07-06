when not declared CPLIB_GRAPH_TSP:
    const CPLIB_GRAPH_TSP* = 1
    import sequtils
    import cplib/utils/constants
    import cplib/graph/graph
    import cplib/graph/dijkstra
    import cplib/graph/maxk_dijkstra

    proc solveTSP[T](dist: seq[seq[T]], start: seq[T], inf: T): seq[seq[T]] =
        var N = len(dist)
        var DP = newSeqWith(N, newSeqWith(1 shl N, inf))
        for i in 0..<(N):
            DP[i][(1 shl i)] = start[i]
        for bit in 0..<(1 shl N):
            for i in 0..<N:
                if ((bit and (1 shl i)) != 0):
                    if DP[i][bit] == inf: continue
                    for j in 0..<N:
                        if (bit and (1 shl j)) == 0:
                            DP[j][bit or (1 shl j)] = min(DP[j][bit or (1 shl j)],DP[i][bit] + dist[i][j])
        return DP

    proc tspPathCostFrom_impl[T](dist: openArray[seq[T]], start_v: int, zero, inf: T, floydwarshall: bool): T =
        ## start_vからすべての頂点を訪問して、終点はどこでもいいときのコストの最小値
        var dist = @dist
        if floydwarshall:
            for k in 0..<len(dist):
                for i in 0..<len(dist):
                    for j in 0..<len(dist):
                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])
        var start = newSeqWith(len(dist), inf)
        start[start_v] = zero
        var res = solveTSP(dist, start, inf)
        result = inf
        for i in 0..<len(dist):
            result = min(result,res[i][^1])
        return result

    proc tspPathCostFrom*(dist: openArray[seq[int]], start_v: int, floydwarshall: bool = true): int =
        tspPathCostFrom_impl(dist, start_v, 0, INF64, floydwarshall)
    proc tspPathCostFrom*(dist: openArray[seq[int32]], start_v: int, floydwarshall: bool = true): int32 =
        tspPathCostFrom_impl(dist, start_v, 0.int32, INF32, floydwarshall)
    proc tspPathCostFrom*(dist: openArray[seq[float]], start_v: int, floydwarshall: bool = true): float =
        tspPathCostFrom_impl(dist, start_v, 0.0, 1e100, floydwarshall)
    proc tspPathCostFrom*(dist: openArray[seq[float32]], start_v: int, floydwarshall: bool = true): float32 =
        tspPathCostFrom_impl(dist, start_v, 0.0'f32, 1e30'f32, floydwarshall)
    proc tspPathCostFrom*[T](dist: openArray[seq[T]], start_v: int, zero, inf: T, floydwarshall: bool = true): T =
        tspPathCostFrom_impl(dist, start_v, zero, inf, floydwarshall)

    proc tspPathCostFromTo_impl[T](dist: openArray[seq[T]], start_v, goal_v: int, zero, inf: T, floydwarshall: bool): T =
        ## start_vからすべての頂点を訪問して、終点も指定するパターン
        var dist = @dist
        if floydwarshall:
            for k in 0..<len(dist):
                for i in 0..<len(dist):
                    for j in 0..<len(dist):
                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])
        var start = newSeqWith(len(dist), inf)
        start[start_v] = zero
        var res = solveTSP(dist, start, inf)
        result = inf
        for i in 0..<len(dist):
            result = min(result,res[i][^1] + dist[i][goal_v])
        return result

    proc tspPathCostFromTo*(dist: openArray[seq[int]], start_v, goal_v: int, floydwarshall: bool = true): int =
        tspPathCostFromTo_impl(dist, start_v, goal_v, 0, INF64, floydwarshall)
    proc tspPathCostFromTo*(dist: openArray[seq[int32]], start_v, goal_v: int, floydwarshall: bool = true): int32 =
        tspPathCostFromTo_impl(dist, start_v, goal_v, 0.int32, INF32, floydwarshall)
    proc tspPathCostFromTo*(dist: openArray[seq[float]], start_v, goal_v: int, floydwarshall: bool = true): float =
        tspPathCostFromTo_impl(dist, start_v, goal_v, 0.0, 1e100, floydwarshall)
    proc tspPathCostFromTo*(dist: openArray[seq[float32]], start_v, goal_v: int, floydwarshall: bool = true): float32 =
        tspPathCostFromTo_impl(dist, start_v, goal_v, 0.0'f32, 1e30'f32, floydwarshall)
    proc tspPathCostFromTo*[T](dist: openArray[seq[T]], start_v, goal_v: int, zero, inf: T, floydwarshall: bool = true): T =
        tspPathCostFromTo_impl(dist, start_v, goal_v, zero, inf, floydwarshall)

    proc tspPathAnyStart_impl[T](dist: openArray[seq[T]], zero, inf: T, floydwarshall: bool): T =
        ## グラフの何処かからスタートし、すべての頂点を通るまでのコスト
        var dist = @dist
        if floydwarshall:
            for k in 0..<len(dist):
                for i in 0..<len(dist):
                    for j in 0..<len(dist):
                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])
        var start = newSeqWith(len(dist), zero)
        var res = solveTSP(dist, start, inf)
        result = inf
        for i in 0..<len(dist):
            result = min(result,res[i][^1])
        return result

    proc tspPathAnyStart*(dist: openArray[seq[int]], floydwarshall: bool = true): int =
        tspPathAnyStart_impl(dist, 0, INF64, floydwarshall)
    proc tspPathAnyStart*(dist: openArray[seq[int32]], floydwarshall: bool = true): int32 =
        tspPathAnyStart_impl(dist, 0.int32, INF32, floydwarshall)
    proc tspPathAnyStart*(dist: openArray[seq[float]], floydwarshall: bool = true): float =
        tspPathAnyStart_impl(dist, 0.0, 1e100, floydwarshall)
    proc tspPathAnyStart*(dist: openArray[seq[float32]], floydwarshall: bool = true): float32 =
        tspPathAnyStart_impl(dist, 0.0'f32, 1e30'f32, floydwarshall)
    proc tspPathAnyStart*[T](dist: openArray[seq[T]], zero, inf: T, floydwarshall: bool = true): T =
        tspPathAnyStart_impl(dist, zero, inf, floydwarshall)

    proc toContractionGraph_impl[T](G: WeightedGraph[T], v: openArray[int], ZERO, INF: T): WeightedDirectedGraph[T] =
        result = initWeightedDirectedGraph(len(v), T)
        for i in 0..<len(v):
            var res = G.dijkstra(v[i], ZERO, INF)
            for j in 0..<len(v):
                result.add_edge(i,j,res[v[j]])

    proc toContractionGraph*(G: WeightedGraph[int], v: openArray[int]): WeightedDirectedGraph[int] =
        toContractionGraph_impl(G, v, 0, INF64)
    proc toContractionGraph*(G: WeightedGraph[int32], v: openArray[int]): WeightedDirectedGraph[int32] =
        toContractionGraph_impl(G, v, 0.int32, INF32)
    proc toContractionGraph*(G: WeightedGraph[float], v: openArray[int]): WeightedDirectedGraph[float] =
        toContractionGraph_impl(G, v, 0.0, 1e100)
    proc toContractionGraph*(G: WeightedGraph[float32], v: openArray[int]): WeightedDirectedGraph[float32] =
        toContractionGraph_impl(G, v, 0.0'f32, 1e30'f32)
    proc toContractionGraph*[T](G: WeightedGraph[T], v: openArray[int], ZERO, INF: T): WeightedDirectedGraph[T] =
        toContractionGraph_impl(G, v, ZERO, INF)
    
    proc toContractionGraph*(G:UnWeightedGraph,v:openArray[int]):WeightedDirectedGraph[int]=
        result = initWeightedDirectedGraph(len(v))
        for i in 0..<len(v):
            var res = G.maxk_dijkstra(v[i],1)
            for j in 0..<len(v):
                result.add_edge(i,j,res[v[j]])

    proc to_adjacency_matrix_impl[T](G: WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T], none: T): seq[seq[T]] =
        var N = len(G)
        result = newSeqWith(N, newSeqWith(N, none))

        for i in 0..<N:
            for (j,c) in G.to_and_cost(i):
                result[i][j] = min(result[i][j],c)

    proc to_adjacency_matrix*(G: WeightedDirectedGraph[int] or WeightedDirectedStaticGraph[int], none: int = INF64): seq[seq[int]] =
        to_adjacency_matrix_impl(G, none)
    proc to_adjacency_matrix*(G: WeightedDirectedGraph[int32] or WeightedDirectedStaticGraph[int32], none: int32 = INF32): seq[seq[int32]] =
        to_adjacency_matrix_impl(G, none)
    proc to_adjacency_matrix*(G: WeightedDirectedGraph[float] or WeightedDirectedStaticGraph[float], none: float = 1e100): seq[seq[float]] =
        to_adjacency_matrix_impl(G, none)
    proc to_adjacency_matrix*(G: WeightedDirectedGraph[float32] or WeightedDirectedStaticGraph[float32], none: float32 = 1e30'f32): seq[seq[float32]] =
        to_adjacency_matrix_impl(G, none)
    proc to_adjacency_matrix*[T](G: WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T], none: T): seq[seq[T]] =
        to_adjacency_matrix_impl(G, none)
