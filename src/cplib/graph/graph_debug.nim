when not declared CPLIB_GRAPH_GRAPHDEBUG:
    const CPLIB_GRAPH_GRAPHDEBUG* = 1
    import strformat
    import cplib/graph/graph
    proc dump_graph*(G: WeightedDirectedGraph or WeightedDirectedStaticGraph,indexed:int=0,output:File=stdout)=
        ## 頂点番号に indexed を加えてグラフを出力する。O(V + E)。
        var M = 0
        for x in 0..<len(G):
            for (y,c) in G[x]:
                M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for (y,c) in G[x]:
                output.writeLine($(x + indexed) & " " & $(y + indexed) & " " & $c)
    
    proc dump_graph*(G: WeightedUnDirectedGraph or WeightedUnDirectedStaticGraph,indexed:int=0,output:File=stdout)=
        ## 頂点番号に indexed を加えてグラフを出力する。O(V + E)。
        var M = 0
        for x in 0..<len(G):
            for (y,c) in G[x]:
                if y >= x:
                    M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for (y,c) in G[x]:
                if y >= x:
                    output.writeLine($(x + indexed) & " " & $(y + indexed) & " " & $c)
    
    proc dump_graph*(G: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph,indexed:int=0,output:File=stdout)=
        ## 頂点番号に indexed を加えてグラフを出力する。O(V + E)。
        var M = 0
        for x in 0..<len(G):
            for y in G[x]:
                M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for y in G[x]:
                output.writeLine($(x + indexed) & " " & $(y + indexed))
    
    proc dump_graph*(G: UnWeightedUnDirectedGraph or UnWeightedUnDirectedStaticGraph,indexed:int=0,output:File=stdout)=
        ## 頂点番号に indexed を加えてグラフを出力する。O(V + E)。
        var M = 0
        for x in 0..<len(G):
            for y in G[x]:
                if y >= x:
                    M += 1
        output.writeLine($len(G)&" " & $M)
        for x in 0..<len(G):
            for y in G[x]:
                if y >= x:
                    output.writeLine($(x + indexed) & " " & $(y + indexed))
    
    proc dump_graph*(G: DirectedGraph or UnDirectedGraph, file: File) =
        ## 出力先を第二引数に指定する従来の呼び出しに対応する。O(V + E)。
        G.dump_graph(0, file)

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
