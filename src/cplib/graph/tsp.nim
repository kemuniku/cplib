when not declared CPLIB_GRAPH_TSP:
    const CPLIB_GRAPH_TSP* = 1
    import sequtils
    import cplib/utils/constants
    import cplib/graph/graph
    import cplib/graph/dijkstra
    import cplib/graph/maxk_dijkstra

    proc solveTSP(dist:seq[seq[int]],start:seq[int]):seq[seq[int]]=
        var N = len(dist)
        var DP = newseqwith(N,newseqwith(1 shl N,INF64))
        for i in 0..<(N):
            DP[i][(1 shl i)] = start[i]
        for bit in 0..<(1 shl N):
            for i in 0..<N:
                if ((bit and (1 shl i)) != 0):
                    if DP[i][bit] == INF64: continue
                    for j in 0..<N:
                        if (bit and (1 shl j)) == 0:
                            DP[j][bit or (1 shl j)] = min(DP[j][bit or (1 shl j)],DP[i][bit] + dist[i][j])
        return DP

    proc tspPathCostFrom*(dist:openArray[seq[int]],start_v:int,floydwarshall:bool=true):int=
        ## start_vからすべての頂点を訪問して、終点はどこでもいいときのコストの最小値
        var dist = @dist
        if floydwarshall:
            for k in 0..<len(dist):
                for i in 0..<len(dist):
                    for j in 0..<len(dist):
                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])
        var start = newseqwith(len(dist),INF64)
        start[start_v] = 0
        var res = solveTSP(dist,start)
        result = INF64
        for i in 0..<len(dist):
            result = min(result,res[i][^1])
        return result

    proc tspPathCostFromTo*(dist:openArray[seq[int]],start_v:int,goal_v:int,floydwarshall:bool=true):int=
        ## start_vからすべての頂点を訪問して、終点も指定するパターン
        var dist = @dist
        if floydwarshall:
            for k in 0..<len(dist):
                for i in 0..<len(dist):
                    for j in 0..<len(dist):
                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])
        var start = newseqwith(len(dist),INF64)
        start[start_v] = 0
        var res = solveTSP(dist,start)
        result = INF64
        for i in 0..<len(dist):
            result = min(result,res[i][^1] + dist[i][goal_v])
        return result

    proc tspPathAnyStart*(dist:openArray[seq[int]],floydwarshall:bool=true):int=
        ## グラフの何処かからスタートし、すべての頂点を通るまでのコスト
        var dist = @dist
        if floydwarshall:
            for k in 0..<len(dist):
                for i in 0..<len(dist):
                    for j in 0..<len(dist):
                        dist[i][j] = min(dist[i][j],dist[i][k] + dist[k][j])
        var start = newseqwith(len(dist),0)
        var res = solveTSP(dist,start)
        result = INF64
        for i in 0..<len(dist):
            result = min(result,res[i][^1])
        return result


    proc toContractionGraph*(G:WeightedGraph[int],v:openArray[int]):WeightedDirectedGraph[int]=
        result = initWeightedDirectedGraph(len(v))
        for i in 0..<len(v):
            var res = G.dijkstra(v[i])
            for j in 0..<len(v):
                result.add_edge(i,j,res[v[j]])
    
    proc toContractionGraph*(G:UnWeightedGraph,v:openArray[int]):WeightedDirectedGraph[int]=
        result = initWeightedDirectedGraph(len(v))
        for i in 0..<len(v):
            var res = G.maxk_dijkstra(v[i],1)
            for j in 0..<len(v):
                result.add_edge(i,j,res[v[j]])

    proc to_adjacency_matrix*(G:WeightedDirectedGraph[int],none:int=INF64):seq[seq[int]]=
        var N = len(G)
        result = newseqwith(N,newseqwith(N,none))

        for i in 0..<N:
            for (j,c) in G.to_and_cost(i):
                result[i][j] = min(result[i][j],c)
