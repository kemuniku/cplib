when not declared CPLIB_GRAPH_BELLMANFORD:
    const CPLIB_GRAPH_BELLMANFORD* = 1
    import deques, sequtils, macros, algorithm
    import cplib/graph/graph
    import cplib/utils/infl
    proc restore_bellmanford_impl[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =
        let N = len(G)
        var
            costs = newSeqWith(N, INF)
            prev = newSeqWith(N, -1)
            changed: bool
        when start is int:
            costs[start] = ZERO
        else:
            for s in start:
                costs[s] = ZERO
        for _ in 0..<N:
            changed = false
            for i in 0..<N:
                if costs[i] == INF: continue
                for (j, c) in G[i]:
                    var temp = costs[i] + c
                    if temp < costs[j]:
                        prev[j] = i
                        costs[j] = temp
                        changed = true
            if not changed: break
        if changed:
            for _ in 0..<N:
                for i in 0..<N:
                    if costs[i] == INF: continue
                    for (j, c) in G[i]:
                        var temp = costs[i] + c
                        if temp < costs[j]:
                            costs[j] = -INF
                            prev[j] = -1
        return (costs, prev)
    macro declareBellmanFord(name, t, zero, inf) =
        let impl_name = ident($`name` & "_impl")
        quote do:
            proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                `impl_name`(G, start, ZERO, INF)
    declareBellmanFord(restore_bellmanford, int, 0, INFL)
    declareBellmanFord(restore_bellmanford, int32, 0, INFi32)
    declareBellmanFord(restore_bellmanford, float, 0.0, 1e100)
    proc restore_bellmanford*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        restore_bellmanford_impl(G, start, ZERO, INF)
    proc bellmanford_impl[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        var (costs, _) = restore_bellmanford(G, start, ZERO, INF)
        return costs
    declareBellmanFord(bellmanford, int, 0, INFL)
    declareBellmanFord(bellmanford, int32, 0, INFi32)
    declareBellmanFord(bellmanford, float, 0.0, 1e100)
    proc bellmanford*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        bellmanford_impl(G, start, ZERO, INF)
    proc restore_shortestpath_from_prev*(prev: seq[int], goal: int): seq[int] =
        var i = goal
        while i != -1:
            result.add(i)
            i = prev[i]
        result = result.reversed()
    proc shortest_path*[T](G: DynamicGraph[T] or StaticGraph[T], start: int, goal: int, ZERO: T = 0, INF: T = int(3300300300300300491)): tuple[path: seq[int], cost: T] =
        var (costs, prev) = restore_bellmanford(G, start, ZERO, INF)
        result.path = prev.restore_shortestpath_from_prev(goal)
        result.cost = costs[goal]
