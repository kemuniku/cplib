when not declared CPLIB_GRAPH_KRUSKAL:
    const CPLIB_GRAPH_KRUSKAL* = 1
    import cplib/graph/graph
    import algorithm
    import cplib/collections/unionfind
    import cplib/utils/constants

    proc get_MST_cost*(G:WeightedUnDirectedGraph[int]):int=
        ## 最小全域木のコストの総和を求める。
        var edges : seq[(int,int,int)]
        var uf = initUnionFind(len(G))
        for i in 0..<len(G):
            for (j,c) in G[i]:
                if i < j:
                    edges.add((c,i,j))
        edges.sort()
        for (c,i,j) in edges:
            if not uf.issame(i,j):
                result += c
                uf.unite(i,j)
        if uf.count != 1:
            return INF64

    proc to_MST_Graph*[T](G:WeightedUnDirectedGraph[T]):WeightedUnDirectedGraph[T]=
        ## 最小全域木を取ったときのグラフを返す
        var edges : seq[(T,int,int)]
        var uf = initUnionFind(len(G))
        for i in 0..<len(G):
            for (j,c) in G[i]:
                if i < j:
                    edges.add((c,i,j))
        edges.sort()
        result = initWeightedUnDirectedGraph(len(G))
        for (c,i,j) in edges:
            if not uf.issame(i,j):
                result.add_edge(i,j,c)
                uf.unite(i,j)
