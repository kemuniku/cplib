when not declared CPLIB_GRAPH_TOPOLOGICALSORT:
    const CPLIB_GRAPH_TOPOLOGICALSORT* = 1
    import cplib/graph/graph
    proc topologicalsort*(G: DirectedGraph): seq[int] =
        var gin = newseq[int](len(G))
        for i in 0..<len(G):
            for j in G[i]:
                gin[j] += 1
        var stack: seq[int]
        for i in 0..<len(G):
            if gin[i] == 0:
                stack.add(i)
        while len(stack) != 0:
            var i = stack.pop()
            result.add(i)
            for j in G[i]:
                gin[j] -= 1
                if gin[j] == 0:
                    stack.add(j)
    proc isDAG*(G: DirectedGraph): bool = G.topologicalsort.len == G.len
