when not declared CPLIB_GRAPH_WARSHALLFLOYD:
    const CPLIB_GRAPH_WARSHALLFLOYD* = 1
    import cplib/graph/graph
    import cplib/utils/infl
    import sequtils
    proc warshall_floyd_impl[T](g: DynamicGraph[T] or StaticGraph[T], zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] =
        var d = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len: d[i][i] = zero
        for i in 0..<g.len:
            for (j, cost) in g.to_and_cost(i):
                d[i][j] = cost
        for k in 0..<g.len:
            for i in 0..<g.len:
                for j in 0..<g.len:
                    if d[i][k] != inf and d[k][j] != inf:
                        d[i][j] = min(d[i][j], d[i][k] + d[k][j])
            for i in 0..<g.len:
                if d[i][i] < 0: return (negative_cycle: true, d: d)
        return (negative_cycle: false, d: d)

    proc warshall_floyd*(g: DynamicGraph[SomeInteger] or StaticGraph[SomeInteger], zero: SomeInteger = 0, inf: SomeInteger = INFL): tuple[negative_cycle: bool, d: seq[seq[int]]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[SomeFloat] or StaticGraph[SomeFloat], zero: SomeFloat = 0.0, inf: SomeFloat = 1e100): tuple[negative_cycle: bool, d: seq[seq[float]]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*[T](g: DynamicGraph[T] or StaticGraph[T], zero, inf: T): tuple[negative_cycle: bool, d: seq[seq[T]]] = warshall_floyd_impl(g, zero, inf)
