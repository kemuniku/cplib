when not declared CPLIB_GRAPH_DIJKSTRA:
    const CPLIB_GRAPH_DIJKSTRA* = 1
    import cplib/graph/graph
    import cplib/utils/infl
    import std/heapqueue, algorithm, macros
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
    declareDijkstra(restore_dijkstra, int, 0, INFL)
    declareDijkstra(restore_dijkstra, int32, 0i32, INFi32)
    declareDijkstra(restore_dijkstra, float, 0.0, 1e100)
    proc restore_dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        restore_dijkstra_impl(G, start, ZERO, INF)
    proc dijkstra_impl[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): seq[T] =
        var (costs, _) = restore_dijkstra(G, start, ZERO, INF)
        return costs
    declareDijkstra(dijkstra, int, 0, INFL)
    declareDijkstra(dijkstra, int32, 0i32, INFi32)
    declareDijkstra(dijkstra, float, 0.0, 1e100)
    proc dijkstra*[T](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int], ZERO, INF: T): auto =
        dijkstra_impl(G, start, ZERO, INF)
    proc restore_shortestpath_from_prev*(prev: seq[int], goal: int): seq[int] =
        var i = goal
        while i != -1:
            result.add(i)
            i = prev[i]
        result = result.reversed()
    proc shortest_path*[T](G: DynamicGraph[T] or StaticGraph[T], start: int, goal: int, ZERO: T = 0, INF: T = int(3300300300300300491)): tuple[path: seq[int], cost: T] =
        var (costs, prev) = restore_dijkstra(G, start, ZERO, INF)
        result.path = prev.restore_shortestpath_from_prev(goal)
        result.cost = costs[goal]
