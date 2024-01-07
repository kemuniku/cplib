when not declared CPLIB_GRAPH_TOPOLOGICALSORT:
    import cplib/graph/graph
    proc topologicalsort*(G: DirectedGraph): seq[int] =
        var gin = newseq[int](G.N)
        for i in 0..<G.N:
            for (j, _) in G.edges[i]:
                gin[j] += 1
        var stack: seq[int]
        for i in 0..<G.N:
            if gin[i] == 0:
                stack.add(i)
        while len(stack) != 0:
            var i = stack.pop()
            result.add(i)
            for (j, _) in G.edges[i]:
                gin[j] -= 1
                if gin[j] == 0:
                    stack.add(j)
    proc isDAG*(G:DirectedGraph):bool=G.topologicalsort.len == G.N