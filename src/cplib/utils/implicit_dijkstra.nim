when not declared CPLIB_UTILS_IMPLICIT_DIJKSTRA:
    const CPLIB_UTILS_IMPLICIT_DIJKSTRA* = 1

    import algorithm, heapqueue, tables, sets
    import cplib/utils/constants

    # 状態は hash と == が利用でき、探索中に値が変化しないことを仮定する。
    # 辺の重みは非負、加算する距離は int の範囲内であることを仮定する。
    # 全探索では到達範囲が有限、途中終了では終了までの探索が有限である必要がある。
    # V は探索頂点数、E は列挙辺数、S は始点列の長さとする。
    # hash/比較/各辺の生成が定数時間なら期待時間 O(S + (V + E) log(V + E + 2))、空間 O(V + E)。

    type
        ImplicitDijkstraAdjacent*[T] = proc(v: T): seq[(T, int)] {.closure.}
        ImplicitDijkstraFinish*[T] = proc(v: T): bool {.closure.}

    proc restore_implicit_dijkstra*[T](start: openArray[T], adjacent: ImplicitDijkstraAdjacent[T]): tuple[costs: Table[T, int], prev: Table[T, T]] =
        ## 各始点の距離を 0 として Dijkstra 法で到達範囲を探索し、距離と親を返す。
        ## 重複始点は無視し、始点は prev に含めない。空始点なら両 Table は空。
        var
            queue = initHeapQueue[(int, int)]()
            vertices: seq[T]
            vertexIds = initTable[T, int]()
        result.costs = initTable[T, int]()
        result.prev = initTable[T, T]()
        for s in start:
            if result.costs.hasKey(s):
                continue
            vertexIds[s] = vertices.len
            vertices.add(s)
            result.costs[s] = 0
            queue.push((0, vertexIds[s]))

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

    proc implicit_dijkstra*[T](start: openArray[T], adjacent: ImplicitDijkstraAdjacent[T]): Table[T, int] =
        ## 各始点から到達可能な各頂点までの最短距離の最小値を返す。
        ## 到達不能な頂点は返り値の Table に含まれない。
        restore_implicit_dijkstra(start, adjacent).costs

    proc implicit_dijkstra_until*[T](start: openArray[T], adjacent: ImplicitDijkstraAdjacent[T], finish: ImplicitDijkstraFinish[T], INF: int = INF64): int =
        ## 最短距離が確定した頂点が初めて finish を満たしたとき、その距離を返す。
        ## 始点も判定し、該当頂点がない場合（空始点を含む）は INF を返す。
        var
            queue = initHeapQueue[(int, int)]()
            vertices: seq[T]
            vertexIds = initTable[T, int]()
            costs = initTable[T, int]()
        for s in start:
            if costs.hasKey(s):
                continue
            vertexIds[s] = vertices.len
            vertices.add(s)
            costs[s] = 0
            queue.push((0, vertexIds[s]))

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

    proc shortest_path_implicit_dijkstra*[T](start: openArray[T], goal: openArray[T], adjacent: ImplicitDijkstraAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## いずれかの goal に最も近い始点からの経路と距離を返す。
        ## 最短距離確定時に終了する。到達不能は (空経路, INF)、空終点なら探索しない。
        ## 終点数 G の集合化に期待時間・空間 O(G)、終点判定に期待 O(1) を追加する。
        ## 重複終点は無視し、同距離の終点・経路の選択は保証しない。
        if goal.len == 0:
            return (@[], INF)
        var goals = initHashSet[T]()
        for g in goal:
            goals.incl(g)
        var
            queue = initHeapQueue[(int, int)]()
            vertices: seq[T]
            vertexIds = initTable[T, int]()
            costs = initTable[T, int]()
            prev = initTable[T, T]()
        for s in start:
            if costs.hasKey(s):
                continue
            vertexIds[s] = vertices.len
            vertices.add(s)
            costs[s] = 0
            queue.push((0, vertexIds[s]))

        while queue.len > 0:
            let (cost, vertexId) = queue.pop()
            let vertex = vertices[vertexId]
            if cost != costs[vertex]:
                continue
            if vertex in goals:
                result.cost = cost
                var current = vertex
                result.path.add(current)
                while prev.hasKey(current):
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

    proc shortest_path_implicit_dijkstra*[T](start: openArray[T], goal: T, adjacent: ImplicitDijkstraAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 多始点・単一終点版。最も近い始点からの経路と距離を返す。
        shortest_path_implicit_dijkstra(start, [goal], adjacent, INF)

    proc shortest_path_implicit_dijkstra*[T](start: T, goal: openArray[T], adjacent: ImplicitDijkstraAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 単一始点・多終点版。最も近い終点までの経路と距離を返す。
        shortest_path_implicit_dijkstra([start], goal, adjacent, INF)

    proc restore_implicit_dijkstra*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T]): tuple[costs: Table[T, int], prev: Table[T, T]] =
        ## 単一始点版。距離・復元・終了条件は多始点版と同じ。
        restore_implicit_dijkstra([start], adjacent)

    proc implicit_dijkstra*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T]): Table[T, int] =
        ## 単一始点版。距離・復元・終了条件は多始点版と同じ。
        implicit_dijkstra([start], adjacent)

    proc implicit_dijkstra_until*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T], finish: ImplicitDijkstraFinish[T], INF: int = INF64): int =
        ## 単一始点版。距離・復元・終了条件は多始点版と同じ。
        implicit_dijkstra_until([start], adjacent, finish, INF)

    proc shortest_path_implicit_dijkstra*[T](start, goal: T, adjacent: ImplicitDijkstraAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 単一始点版。距離・復元・終了条件は多始点版と同じ。
        shortest_path_implicit_dijkstra([start], goal, adjacent, INF)

    proc implicit_dijkstra_until*[T](start: openArray[T], adjacent: ImplicitDijkstraAdjacent[T], finish: openArray[T], INF: int = INF64): int =
        ## いずれかの終点 finish への最短距離が確定した時点で終了し、その距離を返す。
        ## 終点数 G の集合化に期待時間・空間 O(G)、判定に期待 O(1) を追加する。
        ## 重複終点は無視し、空終点なら探索せず INF を返す。
        if finish.len == 0:
            return INF
        var goals = initHashSet[T]()
        for g in finish:
            goals.incl(g)
        let predicate: ImplicitDijkstraFinish[T] = proc(v: T): bool = v in goals
        implicit_dijkstra_until(start, adjacent, predicate, INF)

    proc implicit_dijkstra_until*[T](start: T, adjacent: ImplicitDijkstraAdjacent[T], finish: openArray[T], INF: int = INF64): int =
        ## 単一始点・多終点版。最も近い終点への距離を返す。
        implicit_dijkstra_until([start], adjacent, finish, INF)
