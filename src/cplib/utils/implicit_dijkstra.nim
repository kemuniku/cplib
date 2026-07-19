when not declared CPLIB_UTILS_IMPLICIT_DIJKSTRA:
    const CPLIB_UTILS_IMPLICIT_DIJKSTRA* = 1

    import std/[algorithm, heapqueue, tables]
    import cplib/utils/constants

    type
        ImplicitDijkstraAdjacent*[T] = proc(v: T): seq[(T, int)] {.closure.}
        ImplicitDijkstraFinish*[T] = proc(v: T): bool {.closure.}

    proc restore_implicit_dijkstra*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T]): tuple[costs: Table[T, int], prev: Table[T, T]] =
        ## `adjacent(v)` で辺を列挙する、頂点集合を明示しないグラフ上の
        ## Dijkstra 法。非負辺を仮定し、到達可能な頂点をすべて探索する。
        var
            queue = initHeapQueue[(int, int)]()
            vertices = @[start]
            vertexIds = initTable[T, int]()
        result.costs = initTable[T, int]()
        result.prev = initTable[T, T]()
        vertexIds[start] = 0
        result.costs[start] = 0
        queue.push((0, 0))

        while queue.len > 0:
            let (cost, vertexId) = queue.pop()
            let vertex = vertices[vertexId]
            if cost != result.costs[vertex]:
                continue
            for (next, edgeCost) in adjacent(vertex):
                let nextCost = cost + edgeCost
                if not result.costs.hasKey(next) or nextCost < result.costs[next]:
                    if not vertexIds.hasKey(next):
                        vertexIds[next] = vertices.len
                        vertices.add(next)
                    result.costs[next] = nextCost
                    result.prev[next] = vertex
                    queue.push((nextCost, vertexIds[next]))

    proc implicit_dijkstra*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T]): Table[T, int] =
        ## 始点から到達可能な各頂点までの最短距離を返す。
        ## 到達不能な頂点は返り値の Table に含まれない。
        restore_implicit_dijkstra(start, adjacent).costs

    proc implicit_dijkstra_until*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T], finish: ImplicitDijkstraFinish[T], INF: int = INF64): int =
        ## 非負辺を仮定し、最短距離が確定した頂点が初めて `finish` を
        ## 満たしたとき、その頂点までのコストを返す。
        var
            queue = initHeapQueue[(int, int)]()
            vertices = @[start]
            vertexIds = initTable[T, int]()
            costs = initTable[T, int]()
        vertexIds[start] = 0
        costs[start] = 0
        queue.push((0, 0))

        while queue.len > 0:
            let (cost, vertexId) = queue.pop()
            let vertex = vertices[vertexId]
            if cost != costs[vertex]:
                continue
            if finish(vertex):
                return cost
            for (next, edgeCost) in adjacent(vertex):
                let nextCost = cost + edgeCost
                if not costs.hasKey(next) or nextCost < costs[next]:
                    if not vertexIds.hasKey(next):
                        vertexIds[next] = vertices.len
                        vertices.add(next)
                    costs[next] = nextCost
                    queue.push((nextCost, vertexIds[next]))

        return INF

    proc shortest_path_implicit_dijkstra*[T](start, goal: T, adjacent: ImplicitDijkstraAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 非負辺を仮定し、`goal` の最短距離が確定した時点で探索を終了する。
        var
            queue = initHeapQueue[(int, int)]()
            vertices = @[start]
            vertexIds = initTable[T, int]()
            costs = initTable[T, int]()
            prev = initTable[T, T]()
        vertexIds[start] = 0
        costs[start] = 0
        queue.push((0, 0))

        while queue.len > 0:
            let (cost, vertexId) = queue.pop()
            let vertex = vertices[vertexId]
            if cost != costs[vertex]:
                continue
            if vertex == goal:
                result.cost = cost
                var current = goal
                result.path.add(current)
                while current != start:
                    current = prev[current]
                    result.path.add(current)
                result.path.reverse()
                return
            for (next, edgeCost) in adjacent(vertex):
                let nextCost = cost + edgeCost
                if not costs.hasKey(next) or nextCost < costs[next]:
                    if not vertexIds.hasKey(next):
                        vertexIds[next] = vertices.len
                        vertices.add(next)
                    costs[next] = nextCost
                    prev[next] = vertex
                    queue.push((nextCost, vertexIds[next]))

        result.cost = INF
        result.path = @[]
