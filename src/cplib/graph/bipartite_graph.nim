when not declared CPLIB_GRAPH_BIPATITE_GRAPH:
    const CPLIB_GRAPH_BIPATITE_GRAPH* = 1
    import cplib/graph/graph
    import sequtils
    proc is_bipartite_graph*(G:UnDirectedGraph):bool=
        var c = newseqwith(len(G),-1)
        for i in 0..<len(G):
            if c[i] == -1:
                proc dfs(x:int):bool=
                    for (y,_) in G.to_and_cost(x):
                        if c[y] == -1:
                            c[y] = c[x] xor 1
                            if not dfs(y):
                                return false
                        elif c[y] != (c[x] xor 1):
                            return false
                    return true
                c[i] = 0
                if not dfs(i):
                    return false
        return true