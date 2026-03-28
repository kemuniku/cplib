when not declared CPLIB_GRAPH_HAMILTONIANCYCLE:
    const CPLIB_GRAPH_HAMILTONIANCYCLE* = 1
    import cplib/graph/graph
    import options
    import sequtils
    import algorithm

    proc hamiltoniancycle*(G:UnWeightedUnDirectedGraph,start:int):Option[seq[int]]=
        var N = len(G)
        var DP = newseqwith(N,newseqwith(1 shl N,-1))

        DP[start][0] = -2


        for bit in 0..<((1 shl N) - 1):
            for i in 0..<N:
                if DP[i][bit] != -1:
                    for j in G[i]:
                        if (bit and (1 shl j)) == 0:
                            DP[j][bit or (1 shl j)] = i
        
        if DP[start][(1 shl N) - 1] == -1:
            return none[seq[int]]()
        
        var ans : seq[int]
        var now = start
        var bit = (1 shl N) - 1

        while DP[now][bit] != -2:
            bit = bit xor (1 shl now)
            now = DP[now][bit]
            ans.add(now)
        
        return some(ans.reversed())


