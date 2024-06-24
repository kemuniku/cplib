when not declared CPLIB_GRAPH_MAXK_DIJKSTRA:
    const CPLIB_GRAPH_MAXK_DIJKSTRA* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import cplib/graph/restore_shortest_path_from_prev
    import sequtils, algorithm, macros
    proc restore_maxk_dijkstra_impl[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], k, ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =
        var
            k = k+1
            queue = newSeqWith(k, newSeq[int32]())
            costs = newSeq[T](len(G))
            prev = newSeq[int](len(G))
            cnt, pos = 0
        costs.fill(INF)
        prev.fill(-1)
        when start is int:
            queue[0].add(start.int32)
            costs[start] = ZERO
        else:
            for s in start:
                queue[0].add(s.int32)
                costs[s] = ZERO
        while cnt < k:
            if queue[pos].len == 0:
                pos += 1
                if pos >= k: pos -= k
                cnt += 1
                continue
            while queue[pos].len > 0:
                var i = queue[pos].pop
                var cost = costs[i]
                if cost mod k != pos: continue
                for (j, c) in G.to_and_cost(i):
                    var temp = cost + c
                    if temp < costs[j]:
                        prev[j] = i
                        costs[j] = temp
                        var pn = pos + c
                        if pn >= k: pn -= k
                        queue[pn].add(j.int32)
            cnt = 0
            pos += 1
            if pos >= k: pos -= k
        return (costs, prev)
    macro declareMaxkDijkstra(name, t, zero, inf) =
        let impl_name = ident($`name` & "_impl")
        quote do:
            proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], k: `t`, ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                `impl_name`(G, start, k, ZERO, INF)
    declareMaxkDijkstra(restore_maxk_dijkstra, int, 0, INF64)
    declareMaxkDijkstra(restore_maxk_dijkstra, int32, 0i32, INF32)
    proc restore_maxk_dijkstra*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], k, ZERO, INF: T): auto =
        restore_maxk_dijkstra_impl(G, start, k, ZERO, INF)
    proc maxk_dijkstra_impl[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], k: T, ZERO, INF: T): seq[T] =
        var (costs, _) = restore_maxk_dijkstra(G, start, k, ZERO, INF)
        return costs
    declareMaxkDijkstra(maxk_dijkstra, int, 0, INF64)
    declareMaxkDijkstra(maxk_dijkstra, int32, 0i32, INF32)
    proc maxk_dijkstra*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], k, ZERO, INF: T): auto =
        maxk_dijkstra_impl(G, start, k, ZERO, INF)
    proc shortest_path_dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start, goal: int, k, ZERO, INF: T): tuple[path: seq[int], cost: T] =
        var (costs, prev) = restore_maxk_dijkstra(G, start, k, ZERO, INF)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]
    proc shortest_path_dijkstra*(G: DynamicGraph[int] or StaticGraph[int], start, goal: int, k: int, ZERO: int = 0, INF: int = INF64): tuple[path: seq[int], cost: int] =
        return shortest_path_dijkstra(G, start, goal, k, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[int32] or StaticGraph[int32], start, goal: int, k: int32, ZERO: int32 = 0.int32, INF: int = INF32): tuple[path: seq[int], cost: int] =
        return shortest_path_dijkstra(G, start, goal, k, ZERO, INF)
