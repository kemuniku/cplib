when not declared CPLIB_GRAPH_GRAPHDEBUG:
    const CPLIB_GRAPH_GRAPHDEBUG* = 1
    import streams
    import strformat
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
    
    proc to_graph_graph*(G: WeightedDirectedGraph or WeightedDirectedStaticGraph,indexed:bool=false):string=
        var M = 0
        for x in 0..<len(G):
            for (y,c) in G[x]:
                M += 1
        result = fmt"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=true&directed=true&data={len(G)}+{M}"
        var add = 0
        if indexed:
            add += 1
        for x in 0..<len(G):
            for (y,c) in G[x]:
                result &= fmt"%0A{x+add}+{y+add}+{c}"

    proc to_graph_graph*(G: WeightedUnDirectedGraph or WeightedUnDirectedStaticGraph,indexed:bool=false):string=
        var M = 0
        for x in 0..<len(G):
            for (y,c) in G[x]:
                if y >= x:
                    M += 1
        result = fmt"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=true&directed=false&data={len(G)}+{M}"
        var add = 0
        if indexed:
            add += 1
        for x in 0..<len(G):
            for (y,c) in G[x]:
                if y >= x:
                    result &= fmt"%0A{x+add}+{y+add}+{c}"

    proc to_graph_graph*(G: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph,indexed:bool=false):string=
        var M = 0
        for x in 0..<len(G):
            for y in G[x]:
                M += 1
        result = fmt"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=false&directed=true&data={len(G)}+{M}"
        var add = 0
        if indexed:
            add += 1
        for x in 0..<len(G):
            for y in G[x]:
                result &= fmt"%0A{x+add}+{y+add}"

    proc to_graph_graph*(G: UnWeightedUnDirectedGraph or UnWeightedUnDirectedStaticGraph,indexed:bool=false):string=
        var M = 0
        for x in 0..<len(G):
            for y in G[x]:
                if y >= x:
                    M += 1
        result = fmt"https://hello-world-494ec.firebaseapp.com/?format=normal&indexed={indexed}&weighted=false&directed=false&data={len(G)}+{M}"
        var add = 0
        if indexed:
            add += 1
        for x in 0..<len(G):
            for y in G[x]:
                if y >= x:
                    result &= fmt"%0A{x+add}+{y+add}"
