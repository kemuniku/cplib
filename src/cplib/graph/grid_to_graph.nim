when not declared CPLIB_GRAPH_GRIDTOGRAPH:
    const CPLIB_GRAPH_GRIDTOGRAPH* = 1
    import sequtils
    import cplib/graph/graph
    proc grid_to_graph_impl*[T](a: seq[seq[T]], ok: T, return_static: static[bool] = false): auto =
        var h = a.len
        if h == 0:
            when return_static: result = initUnWeightedUnDirectedStaticGraph(0)
            else: result = initUnWeightedUnDirectedGraph(0)
        var w = a[0].len
        when return_static: result = initUnWeightedUnDirectedStaticGraph(h*w)
        else: result = initUnWeightedUnDirectedGraph(h*w)
        for i in 0..<h:
            for j in 0..<w:
                if a[i][j] == ok:
                    for (dx, dy) in [(1, 0), (0, 1)]:
                        if i+dx in 0..<h and j+dy in 0..<w and a[i+dx][j+dy] == ok:
                            result.add_edge(i*w+j, (i+dx)*w+j+dy)
    proc grid_to_graph*(a: seq[seq[char]], ok: char = '.', return_static: static[bool] = false): auto = grid_to_graph_impl(a, ok, return_static)
    proc grid_to_graph*[T](a: seq[seq[T]], ok: T, return_static: static[bool] = false): auto = grid_to_graph_impl(a, ok, return_static)
    proc grid_to_graph*(a: seq[string], ok: char = '.', return_static: static[bool] = false): auto = grid_to_graph(a.mapIt(it.toSeq), ok, return_static)
