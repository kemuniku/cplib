when not declared CPLIB_GRAPH_DIJKSTRA:
    const CPLIB_GRAPH_DIJKSTRA* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import cplib/graph/restore_shortest_path_from_prev
    import std/heapqueue, macros, algorithm
    proc dijkstra_core_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T, keepPrev: static bool): auto =
        ## 距離を求め、経路復元時だけ直前の頂点を保存する。
        var
            queue = initHeapQueue[(T, int)]()
            costs = newSeq[T](len(G))
        costs.fill(INF)
        when keepPrev:
            var prev = newSeq[int](len(G))
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
                    when keepPrev: prev[j] = i
                    costs[j] = temp
                    queue.push((temp, j))
        when keepPrev:
            return (costs, prev)
        else:
            return costs
    proc restore_dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =
        ## 距離と経路復元用の直前頂点を返す。
        dijkstra_core_impl(G, start, ZERO, INF, true)
    macro declareDijkstra(name, t, zero, inf) =
        let impl_name = ident($`name` & "_impl")
        if $t == "int":
            quote do:
                proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`] or UnWeightedGraph, start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                    `impl_name`(G, start, ZERO, INF)
        else:
            quote do:
                proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                    `impl_name`(G, start, ZERO, INF)
    declareDijkstra(restore_dijkstra, int, 0, INF64)
    declareDijkstra(restore_dijkstra, int32, 0i32, INF32)
    declareDijkstra(restore_dijkstra, float, 0.0, 1e100)
    declareDijkstra(restore_dijkstra, float32, 0.0'f32, 1e30'f32)
    proc restore_dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): auto =
        restore_dijkstra_impl(G, start, ZERO, INF)
    proc dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): seq[T] =
        ## 経路復元用の配列を確保せずに距離を返す。
        dijkstra_core_impl(G, start, ZERO, INF, false)
    declareDijkstra(dijkstra, int, 0, INF64)
    declareDijkstra(dijkstra, int32, 0i32, INF32)
    declareDijkstra(dijkstra, float, 0.0, 1e100)
    declareDijkstra(dijkstra, float32, 0.0'f32, 1e30'f32)
    proc dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): auto =
        dijkstra_impl(G, start, ZERO, INF)
    proc shortest_path_dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =
        var (costs, prev) = restore_dijkstra(G, start, ZERO, INF)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]
    proc shortest_path_dijkstra*(G: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph, start: int, goal: int, ZERO: int = 0, INF: int = INF64): tuple[path: seq[int], cost: int] =
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[int32] or StaticGraph[int32], start: int, goal: int, ZERO: int32 = 0.int32, INF: int32 = INF32): tuple[path: seq[int], cost: int32] =
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[float] or StaticGraph[float], start: int, goal: int, ZERO: float = 0.0, INF: float = 1e100): tuple[path: seq[int], cost: float] =
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[float32] or StaticGraph[float32], start: int, goal: int, ZERO: float32 = 0.0'f32, INF: float32 = 1e30'f32): tuple[path: seq[int], cost: float32] =
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
