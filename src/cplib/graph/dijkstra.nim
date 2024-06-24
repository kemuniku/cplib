when not declared CPLIB_GRAPH_DIJKSTRA:
    const CPLIB_GRAPH_DIJKSTRA* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import cplib/graph/restore_shortest_path_from_prev
    import std/heapqueue, macros
    proc restore_dijkstra_impl[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =
        var
            queue = initHeapQueue[(T, int)]()
            costs = newSeq[T](len(G))
            prev = newseq[int](len(G))
        costs.fill(INF)
        prev.fill(-1)
        when start is int:
            queue.push((ZERO, start))
            costs[start] = ZERO
        else:
            for s in start:
                queue.push((ZERO, s))
                costs[s] = ZERO
        while len(queue) != 0:
            var (cost, i) = queue.pop()
            if cost > costs[i]:
                continue
            for (j, c) in G.to_and_cost(i):
                var temp = costs[i] + c
                if temp < costs[j]:
                    prev[j] = i
                    costs[j] = temp
                    queue.push((temp, j))
        return (costs, prev)
    macro declareDijkstra(name, t, zero, inf) =
        let impl_name = ident($`name` & "_impl")
        quote do:
            proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                `impl_name`(G, start, ZERO, INF)
    declareDijkstra(restore_dijkstra, int, 0, INF64)
    declareDijkstra(restore_dijkstra, int32, 0i32, INF32)
    declareDijkstra(restore_dijkstra, float, 0.0, 1e100)
    proc restore_dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        restore_dijkstra_impl(G, start, ZERO, INF)
    proc dijkstra_impl[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): seq[T] =
        var (costs, _) = restore_dijkstra(G, start, ZERO, INF)
        return costs
    declareDijkstra(dijkstra, int, 0, INF64)
    declareDijkstra(dijkstra, int32, 0i32, INF32)
    declareDijkstra(dijkstra, float, 0.0, 1e100)
    proc dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        dijkstra_impl(G, start, ZERO, INF)
    proc shortest_path_dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =
        var (costs, prev) = restore_dijkstra(G, start, ZERO, INF)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]
    proc shortest_path_dijkstra*(G: DynamicGraph[int] or StaticGraph[int], start: int, goal: int, ZERO: int = 0, INF: int = INF64): tuple[path: seq[int], cost: int] =
        shortest_path_dijkstra(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[int32] or StaticGraph[int32], start: int, goal: int, ZERO: int32 = 0.int32, INF: int32 = INF32): tuple[path: seq[int], cost: int32] =
        shortest_path_dijkstra(G, start, goal, ZERO, INF)
