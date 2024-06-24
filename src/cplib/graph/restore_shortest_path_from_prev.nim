when not declared CPLIB_GRAPH_RESTORE_SHORTESTPATH_FROM_PREV:
    const CPLIB_GRAPH_RESTORE_SHORTESTPATH_FROM_PREV* = 1
    import algorithm
    proc restore_shortest_path_from_prev*(prev: seq[int], goal: int): seq[int] =
        var i = goal
        while i != -1:
            result.add(i)
            i = prev[i]
        result = result.reversed()
