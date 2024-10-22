when not declared CPLIB_GRAPH_DAGMINIMUMPATHCOVER:
    const CPLIB_GRAPH_DAGMINIMUMPATHCOVER* = 1
    import cplib/graph/graph
    import atcoder/maxflow
    when defined(debug):
        import cplib/graph/topologicalsort

    proc dag_minimum_path_cover*(G:UnWeightedDirectedGraph):int=
        when defined(debug):
            assert G.isDAG()
        var MFG = init_mf_graph[int](len(G)*2+2)
        for i in 0..<len(G):
            for j in G[i]:
                MFG.add_edge(i,len(G)+j,1)
        for i in 0..<len(G):
            MFG.add_edge(2*len(G),i,1)
            MFG.add_edge(len(G)+i,2*len(G)+1,1)
        return len(G)-MFG.flow(2*len(G),2*len(G)+1)