when not declared CPLIB_UTILS_IMPLICIT_BFS:
    const CPLIB_UTILS_IMPLICIT_BFS* = 1

    import algorithm, deques, tables, sets
    import cplib/utils/constants

    # 状態は hash と == が利用でき、探索中に値が変化しないことを仮定する。
    # 全探索では到達範囲が有限、途中終了では終了までの探索が有限である必要がある。
    # 距離は int の範囲内を仮定する。V は探索頂点数、E は列挙辺数、S は始点列の長さ。
    # hash/比較/各辺の生成が定数時間なら期待時間 O(S + V + E)、空間 O(V)（callback の生成領域を除く）。

    type
        ImplicitBfsAdjacent*[T] = proc(v: T): seq[T] {.closure.}
        ImplicitBfsFinish*[T] = proc(v: T): bool {.closure.}

    proc restore_implicit_bfs*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T]): tuple[costs: Table[T, int], prev: Table[T, T]] =
        ## 各始点の距離を 0 として BFS で到達範囲を探索し、辺数と親を返す。
        ## 重複始点は無視し、始点は prev に含めない。空始点なら両 Table は空。
        var queue = initDeque[T]()
        result.costs = initTable[T, int]()
        result.prev = initTable[T, T]()
        for s in start:
            if not result.costs.hasKey(s):
                result.costs[s] = 0
                queue.addLast(s)
        while queue.len > 0:
            let vertex = queue.popFirst()
            let cost = result.costs[vertex]
            for next in adjacent(vertex):
                if not result.costs.hasKey(next):
                    result.costs[next] = cost + 1
                    result.prev[next] = vertex
                    queue.addLast(next)

    proc implicit_bfs*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T]): Table[T, int] =
        ## 各始点からの最小辺数を返す。到達不能な頂点は Table に含まれない。
        restore_implicit_bfs(start, adjacent).costs

    proc implicit_bfs_until*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T], finish: ImplicitBfsFinish[T], INF: int = INF64): int =
        ## 初めて finish を満たす頂点までの最小辺数を返す。
        ## 始点も判定し、該当頂点がない場合（空始点を含む）は INF を返す。
        var
            queue = initDeque[T]()
            costs = initTable[T, int]()
        for s in start:
            if not costs.hasKey(s):
                costs[s] = 0
                queue.addLast(s)
        while queue.len > 0:
            let vertex = queue.popFirst()
            let cost = costs[vertex]
            if finish(vertex):
                return cost
            for next in adjacent(vertex):
                if not costs.hasKey(next):
                    costs[next] = cost + 1
                    queue.addLast(next)
        return INF

    proc shortest_path_implicit_bfs*[T](start: openArray[T], goal: openArray[T], adjacent: ImplicitBfsAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
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
            queue = initDeque[T]()
            costs = initTable[T, int]()
            prev = initTable[T, T]()
        for s in start:
            if not costs.hasKey(s):
                costs[s] = 0
                queue.addLast(s)
        while queue.len > 0:
            let vertex = queue.popFirst()
            let cost = costs[vertex]
            if vertex in goals:
                result.cost = cost
                var current = vertex
                result.path.add(current)
                while prev.hasKey(current):
                    current = prev[current]
                    result.path.add(current)
                result.path.reverse()
                return
            for next in adjacent(vertex):
                if not costs.hasKey(next):
                    costs[next] = cost + 1
                    prev[next] = vertex
                    queue.addLast(next)
        result.cost = INF
        result.path = @[]

    proc shortest_path_implicit_bfs*[T](start: openArray[T], goal: T, adjacent: ImplicitBfsAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 多始点・単一終点版。最も近い始点からの経路と距離を返す。
        shortest_path_implicit_bfs(start, [goal], adjacent, INF)

    proc shortest_path_implicit_bfs*[T](start: T, goal: openArray[T], adjacent: ImplicitBfsAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 単一始点・多終点版。最も近い終点までの経路と距離を返す。
        shortest_path_implicit_bfs([start], goal, adjacent, INF)

    proc restore_implicit_bfs*[T](start: T, adjacent: ImplicitBfsAdjacent[T]): tuple[costs: Table[T, int], prev: Table[T, T]] =
        ## 単一始点版。距離・復元は多始点版と同じ。
        restore_implicit_bfs([start], adjacent)

    proc implicit_bfs*[T](start: T, adjacent: ImplicitBfsAdjacent[T]): Table[T, int] =
        ## 単一始点から到達可能な各頂点までの最小辺数を返す。
        implicit_bfs([start], adjacent)

    proc implicit_bfs_until*[T](start: T, adjacent: ImplicitBfsAdjacent[T], finish: ImplicitBfsFinish[T], INF: int = INF64): int =
        ## 単一始点版。終了条件・返り値は多始点版と同じ。
        implicit_bfs_until([start], adjacent, finish, INF)

    proc shortest_path_implicit_bfs*[T](start, goal: T, adjacent: ImplicitBfsAdjacent[T], INF: int = INF64): tuple[path: seq[T], cost: int] =
        ## 単一始点から goal までの経路と辺数を返す。
        shortest_path_implicit_bfs([start], goal, adjacent, INF)

    proc implicit_bfs_until*[T](start: openArray[T], adjacent: ImplicitBfsAdjacent[T], finish: openArray[T], INF: int = INF64): int =
        ## いずれかの終点 finish への最短距離が確定した時点で終了し、その距離を返す。
        ## 終点数 G の集合化に期待時間・空間 O(G)、判定に期待 O(1) を追加する。
        ## 重複終点は無視し、空終点なら探索せず INF を返す。
        if finish.len == 0:
            return INF
        var goals = initHashSet[T]()
        for g in finish:
            goals.incl(g)
        let predicate: ImplicitBfsFinish[T] = proc(v: T): bool = v in goals
        implicit_bfs_until(start, adjacent, predicate, INF)

    proc implicit_bfs_until*[T](start: T, adjacent: ImplicitBfsAdjacent[T], finish: openArray[T], INF: int = INF64): int =
        ## 単一始点・多終点版。最も近い終点への距離を返す。
        implicit_bfs_until([start], adjacent, finish, INF)
