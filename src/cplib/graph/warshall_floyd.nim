when not declared CPLIB_GRAPH_WARSHALLFLOYD:
    const CPLIB_GRAPH_WARSHALLFLOYD* = 1
    import cplib/graph/graph
    import cplib/utils/infl
    import sequtils
    proc warshall_floyd_impl[T](g: DynamicGraph[T] or StaticGraph[T], zero, inf: T): seq[seq[T]] =
        result = newSeqWith(g.len, newSeqWith(g.len, inf))
        for i in 0..<g.len: result[i][i] = zero
        for i in 0..<g.len:
            for (j, cost) in g.to_and_cost(i):
                result[i][j] = cost
        for k in 0..<g.len:
            for i in 0..<g.len:
                for j in 0..<g.len:
                    if result[i][k] != inf and result[k][j] != inf:
                        result[i][j] = min(result[i][j], result[i][k] + result[k][j])

    proc warshall_floyd*(g: DynamicGraph[SomeInteger] or StaticGraph[SomeInteger], zero: SomeInteger = 0, inf: SomeInteger = INFL): seq[seq[int]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*(g: DynamicGraph[SomeFloat] or StaticGraph[SomeFloat], zero: SomeFloat = 0.0, inf: SomeFloat = 1e100): seq[seq[int]] = warshall_floyd_impl(g, zero, inf)
    proc warshall_floyd*[T](g: DynamicGraph[T] or StaticGraph[T], zero, inf: T): seq[seq[T]] = warshall_floyd_impl(g, zero, inf)

    proc has_negative_cycle_impl[T](d: seq[seq[T]], zero: T): bool =
        for i in 0..<d.len:
            if d[i][i] < zero: return true
        return false
    proc has_negative_cycle*(d: seq[seq[SomeInteger]], zero: SomeInteger = 0): bool = has_negative_cycle_impl(d, zero)
    proc has_negative_cycle*(d: seq[seq[SomeFloat]], zero: SomeFloat = 0.0): bool = has_negative_cycle_impl(d, zero)
    proc has_negative_cycle*[T](d: seq[seq[SomeFloat]], zero: T): bool = has_negative_cycle_impl(d, zero)
