when not declared CPLIB_GRAPH_DIJKSTRA_RADIX:
    const CPLIB_GRAPH_DIJKSTRA_RADIX* = 1
    import algorithm
    import cplib/collections/radix_heap
    import cplib/graph/graph
    import cplib/graph/restore_shortest_path_from_prev
    import cplib/utils/constants

    template radixDijkstraInf(T: typedesc): untyped =
        ## 既存のダイクストラと同じ既定値を使い、他の整数型では最大値を使う。
        when T is int: INF64
        elif T is int32: INF32
        else: high(T)

    proc dijkstraRadixImpl[T: SomeInteger](G: auto,
            start: int or seq[int], ZERO, INF: T, restore, stopAtGoal: static bool,
            goal: int = -1): auto =
        ## 非負整数重みの最短距離を求める。O(V + (E + S)B)、S は始点数、B は距離のビット数。
        var queue = initRadixHeap[T, int](ZERO)
        var costs = newSeq[T](len(G))
        costs.fill(INF)
        when restore:
            var prev = newSeq[int](len(G))
            prev.fill(-1)
        when start is int:
            costs[start] = ZERO
            queue.push(ZERO, start)
        else:
            for s in start:
                if costs[s] != ZERO:
                    costs[s] = ZERO
                    queue.push(ZERO, s)
        while queue.len != 0:
            let (cost, i) = queue.pop()
            if cost > costs[i]: continue
            when stopAtGoal:
                if i == goal: break
            for (j, c) in G.to_and_cost(i):
                assert c >= 0, "dijkstra_radixの辺重みは非負である必要があります"
                if cost > high(T) - c: continue
                let nextCost = cost + c
                if nextCost < costs[j]:
                    costs[j] = nextCost
                    when restore: prev[j] = i
                    queue.push(nextCost, j)
        when restore: return (costs: costs, prev: prev)
        else: return costs

    proc dijkstra_radix*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int],
            ZERO: T = T(0), INF: T = radixDijkstraInf(T)): seq[T] =
        ## 非負整数重みの最短距離を求める。INF 以上は未到達扱い。O(V + (E + S)B)。
        dijkstraRadixImpl(G, start, ZERO, INF, false, false)

    proc dijkstra_radix*(G: UnWeightedGraph, start: int or seq[int], ZERO: int = 0, INF: int = INF64): seq[int] =
        ## 重みを 1 として最短距離を求める。O(V + (E + S)B)。
        dijkstraRadixImpl(G, start, ZERO, INF, false, false)

    proc restore_dijkstra_radix*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start: int or seq[int],
            ZERO: T = T(0), INF: T = radixDijkstraInf(T)): tuple[costs: seq[T], prev: seq[int]] =
        ## 非負整数重みの最短距離と直前の頂点を返す。同距離の経路は不定。O(V + (E + S)B)。
        dijkstraRadixImpl(G, start, ZERO, INF, true, false)

    proc restore_dijkstra_radix*(G: UnWeightedGraph, start: int or seq[int], ZERO: int = 0,
            INF: int = INF64): tuple[costs: seq[int], prev: seq[int]] =
        ## 重みを 1 として最短距離と直前の頂点を返す。O(V + (E + S)B)。
        dijkstraRadixImpl(G, start, ZERO, INF, true, false)

    proc shortest_path_dijkstra_radix*[T: SomeInteger](G: DynamicGraph[T] or StaticGraph[T], start, goal: int,
            ZERO: T = T(0), INF: T = radixDijkstraInf(T)): tuple[path: seq[int], cost: T] =
        ## 目的地が確定するまで探索する。未到達時は (@[goal], INF)。O(V + EB)。
        let (costs, prev) = dijkstraRadixImpl(G, start, ZERO, INF, true, true, goal)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]

    proc shortest_path_dijkstra_radix*(G: UnWeightedGraph, start, goal: int, ZERO: int = 0,
            INF: int = INF64): tuple[path: seq[int], cost: int] =
        ## 重みを 1 として目的地まで探索する。未到達時は (@[goal], INF)。O(V + EB)。
        let (costs, prev) = dijkstraRadixImpl(G, start, ZERO, INF, true, true, goal)
        result.path = prev.restore_shortest_path_from_prev(goal)
        result.cost = costs[goal]
