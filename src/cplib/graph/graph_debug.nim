when not declared CPLIB_GRAPH_GRAPHDEBUG:
    const CPLIB_GRAPH_GRAPHDEBUG* = 1
    import streams
    import cplib/graph/graph
    proc dump_graph*(G: WeightedDirectedGraph or WeightedDirectedStaticGraph,output:File=stdout)=
        var M = 0
        for x in 0..<len(G):
            for (y,c) in G[x]:
                M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for (y,c) in G[x]:
                output.writeLine($x & " " & $y & " " & $c)
    
    proc dump_graph*(G: WeightedUnDirectedGraph or WeightedUnDirectedStaticGraph,output:File=stdout)=
        var M = 0
        for x in 0..<len(G):
            for (y,c) in G[x]:
                if y >= x:
                    M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for (y,c) in G[x]:
                if y >= x:
                    output.writeLine($x & " " & $y &" " & $c)
    
    proc dump_graph*(G: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph,output:File=stdout)=
        var M = 0
        for x in 0..<len(G):
            for y in G[x]:
                M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for y in G[x]:
                output.writeLine($x & " " & $y)
    
    proc dump_graph*(G: UnWeightedUnDirectedGraph or UnWeightedUnDirectedStaticGraph,output:File=stdout)=
        var M = 0
        for x in 0..<len(G):
            for y in G[x]:
                if y >= x:
                    M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for y in G[x]:
                if y >= x:
                    output.writeLine($x & " " & $y)