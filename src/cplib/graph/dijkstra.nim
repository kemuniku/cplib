when not declared CPLIB_GRAPH_DIJKSTRA:
    const CPLIB_GRAPH_DIJKSTRA* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import cplib/graph/restore_shortest_path_from_prev
    import heapqueue, macros, algorithm

    type DijkstraQueueEntry[T] = object
        distance: T
        vertex: int
        cmp: proc(a, b: T): int

    proc `<`*[T](a, b: DijkstraQueueEntry[T]): bool =
        ## 距離の比較関数で優先度を比較し、同順位なら頂点番号で比較する。O(cmp)。
        let order = a.cmp(a.distance, b.distance)
        if order == 0: a.vertex < b.vertex
        else: order < 0

    # cmp(a, b) は a が優先なら負、同順位なら 0、それ以外は正を返す一貫した比較関数とする。
    # cmp を省略する場合は T の < と == を用いる。
    # add(d, e) は cmp の順序で d について単調非減少で、cmp(d, add(d, e)) <= 0 を満たすこと。
    # ZERO は始点の距離、INF は cmp の順序で到達可能な距離より大きい値を指定する。
    # add と比較が O(1) なら時間 O(V + (E + K) log(E + K + 2))、空間 O(V + E + K)。K は始点数。
    proc restore_dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start: int or seq[int], add: proc(distance: T, edge: S): T, ZERO, INF: T, cmp: proc(a, b: T): int): tuple[costs: seq[T], prev: seq[int]] =
        ## 更新関数 add と比較関数 cmp で最短距離と復元用の親を求める。重みなしの辺は int の 1。
        ## T と S はグラフ・add・ZERO・INF から推論される。
        var
            queue = initHeapQueue[DijkstraQueueEntry[T]]()
            costs = newSeq[T](len(G))
            prev = newseq[int](len(G))
        costs.fill(INF)
        prev.fill(-1)
        when start is int:
            queue.push(DijkstraQueueEntry[T](distance: ZERO, vertex: start, cmp: cmp))
            costs[start] = ZERO
        else:
            for s in start:
                if cmp(costs[s], ZERO) == 0:
                    continue
                queue.push(DijkstraQueueEntry[T](distance: ZERO, vertex: s, cmp: cmp))
                costs[s] = ZERO
        while len(queue) != 0:
            let entry = queue.pop()
            let i = entry.vertex
            if cmp(costs[i], entry.distance) < 0:
                continue
            for (j, c) in G.to_and_cost(i):
                var temp = add(costs[i], c)
                if cmp(temp, costs[j]) < 0:
                    prev[j] = i
                    costs[j] = temp
                    queue.push(DijkstraQueueEntry[T](distance: temp, vertex: j, cmp: cmp))
        return (costs, prev)
    proc dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start: int or seq[int], add: proc(distance: T, edge: S): T, ZERO, INF: T, cmp: proc(a, b: T): int): seq[T] =
        ## 更新関数 add と比較関数 cmp で各頂点への最短距離を返す。到達不能な頂点は INF。
        restore_dijkstra(G, start, add, ZERO, INF, cmp).costs
    proc shortest_path_dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start: int, goal: int, add: proc(distance: T, edge: S): T, ZERO, INF: T, cmp: proc(a, b: T): int): tuple[path: seq[int], cost: T] =
        ## add と cmp を用いて経路と距離を返す。到達不能時の経路は従来どおり @[goal]。
        let (costs, prev) = restore_dijkstra(G, start, add, ZERO, INF, cmp)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]
    proc restore_dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start: int or seq[int], add: proc(distance: T, edge: S): T, ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =
        ## T の通常の比較を用いて最短距離と復元用の親を返す。
        restore_dijkstra(G, start, add, ZERO, INF, system.cmp[T])
    proc dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start: int or seq[int], add: proc(distance: T, edge: S): T, ZERO, INF: T): seq[T] =
        ## T の通常の比較を用いて各頂点への最短距離を返す。
        dijkstra(G, start, add, ZERO, INF, system.cmp[T])
    proc shortest_path_dijkstra*[T, S](G: WeightedGraph[S] or UnWeightedGraph, start: int, goal: int, add: proc(distance: T, edge: S): T, ZERO, INF: T): tuple[path: seq[int], cost: T] =
        ## T の通常の比較を用いて経路と最短距離を返す。
        shortest_path_dijkstra(G, start, goal, add, ZERO, INF, system.cmp[T])
    proc restore_dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): tuple[costs: seq[T], prev: seq[int]] =
        ## 通常の加算を用いて最短距離と復元用の親を求める。
        when G is UnWeightedGraph:
            let add = proc(distance: T, edge: int): T = distance + edge
        else:
            let add = proc(distance: T, edge: T): T = distance + edge
        restore_dijkstra(G, start, add, ZERO, INF)
    macro declareDijkstra(name, t, zero, inf) =
        ## 数値型向けに ZERO と INF を省略できるオーバーロードを生成する。
        let impl_name = ident($`name` & "_impl")
        if $t == "int":
            quote do:
                proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`] or UnWeightedGraph, start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                    ## 通常の加算を用いて各始点から最短距離を求める。
                    `impl_name`(G, start, ZERO, INF)
        else:
            quote do:
                proc `name`*(G: DynamicGraph[`t`] or StaticGraph[`t`], start: int or seq[int], ZERO: `t` = `zero`, INF: `t` = `inf`): auto =
                    ## 通常の加算を用いて各始点から最短距離を求める。
                    `impl_name`(G, start, ZERO, INF)
    declareDijkstra(restore_dijkstra, int, 0, INF64)
    declareDijkstra(restore_dijkstra, int32, 0i32, INF32)
    declareDijkstra(restore_dijkstra, float, 0.0, 1e100)
    declareDijkstra(restore_dijkstra, float32, 0.0'f32, 1e30'f32)
    proc restore_dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): auto =
        ## 通常の加算を用いて最短距離と復元用の親を返す。
        restore_dijkstra_impl(G, start, ZERO, INF)
    proc dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): seq[T] =
        ## 通常の加算を用いて各頂点への最短距離を返す。
        var (costs, _) = restore_dijkstra(G, start, ZERO, INF)
        return costs
    declareDijkstra(dijkstra, int, 0, INF64)
    declareDijkstra(dijkstra, int32, 0i32, INF32)
    declareDijkstra(dijkstra, float, 0.0, 1e100)
    declareDijkstra(dijkstra, float32, 0.0'f32, 1e30'f32)
    proc dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int or seq[int], ZERO, INF: T): auto =
        ## 通常の加算を用いて各頂点への最短距離を返す。
        dijkstra_impl(G, start, ZERO, INF)
    proc shortest_path_dijkstra_impl[T](G: WeightedGraph[T] or UnWeightedGraph, start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =
        ## 通常の加算を用いて始点から終点への経路と最短距離を返す。
        var (costs, prev) = restore_dijkstra(G, start, ZERO, INF)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]
    proc shortest_path_dijkstra*(G: DynamicGraph[int] or StaticGraph[int] or UnWeightedGraph, start: int, goal: int, ZERO: int = 0, INF: int = INF64): tuple[path: seq[int], cost: int] =
        ## int の距離を用いて経路と最短距離を返す。
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[int32] or StaticGraph[int32], start: int, goal: int, ZERO: int32 = 0.int32, INF: int32 = INF32): tuple[path: seq[int], cost: int32] =
        ## int32 の距離を用いて経路と最短距離を返す。
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[float] or StaticGraph[float], start: int, goal: int, ZERO: float = 0.0, INF: float = 1e100): tuple[path: seq[int], cost: float] =
        ## float の距離を用いて経路と最短距離を返す。
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*(G: DynamicGraph[float32] or StaticGraph[float32], start: int, goal: int, ZERO: float32 = 0.0'f32, INF: float32 = 1e30'f32): tuple[path: seq[int], cost: float32] =
        ## float32 の距離を用いて経路と最短距離を返す。
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
    proc shortest_path_dijkstra*[T](G: WeightedGraph[T] or UnWeightedGraph, start: int, goal: int, ZERO: T, INF: T): tuple[path: seq[int], cost: T] =
        ## 通常の加算を用いて経路と最短距離を返す。
        shortest_path_dijkstra_impl(G, start, goal, ZERO, INF)
