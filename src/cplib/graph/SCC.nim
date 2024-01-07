when not declared CPLIB_GRAPH_SCC:
    const CPLIB_GRAPH_SCC* = 1
    import cplib/graph/graph
    import sequtils
    import cplib/graph/reverse_edge
    proc SCC*(G: UnweightedDirectedGraph):(UnweightedDirectedGraph,seq[int],seq[seq[int]])=
        ##強連結成分分解をします。
        ##結果を、(頂点をまとめたグラフ,元の頂点→新頂点への対応,新頂点に含まれる頂点一覧)で返します。
        var postorder = newseqwith(G.N,-1)
        var used = newSeqWith(G.N,false)
        var count = G.N-1
        
        proc fdfs(x:int)=
            for (i,_) in G.edges[x]:
                if not used[i]:
                    used[i] = true
                    fdfs(i)
            postorder[count] = x
            count -= 1
        
        
        
        for i in 0..<G.N:
            if not used[i]:
                used[i] = true
                fdfs(i)
        
        var RG = reverse_edge(G)
        var i_to_group = newSeqWith(G.N,-0)
        var group : seq[seq[int]]
        used = newSeqWith(G.N,false)
        count = 0
        
        proc sdfs(x:int)=
            i_to_group[x] = count
            group[count].add(x)
            for (i,_) in RG.edges[x]:
                if not used[i]:
                    used[i] = true
                    sdfs(i)
        for i in postorder:
            if not used[i]:
                used[i] = true
                group.add(@[])
                sdfs(i)
                count += 1
        var newG = initUnWeightedDirectedGraph(count)
        for i in 0..<G.N:
            for (j,_) in G.edges[i]:
                if i_to_group[i] != i_to_group[j]:
                    newG.add_edge(i_to_group[i],i_to_group[j])
        return (newG,i_to_group,group)