when not declared CPLIB_GRAPH_SHORTEST_PATH_GRAPH:
    const CPLIB_GRAPH_SHORTEST_PATH_GRAPH* = 1
    import heapqueue, algorithm
    import cplib/graph/graph

    type ShortestPathGraphResult*[T] = object
        graph*: WeightedDirectedGraph[T]
        original_edge_ids*: seq[int]
        distance*: T

    proc bounded_distances[T: SomeSignedInt](adj: seq[seq[tuple[dst: int, cost: T]]], source: int, INF: T): seq[T] =
        ## INF 以上を到達不能として、非負整数重みの最短距離を求める。
        result = newSeq[T](adj.len)
        result.fill(INF)
        result[source] = T(0)
        var queue = initHeapQueue[tuple[cost: T, vertex: int]]()
        queue.push((T(0), source))
        while queue.len > 0:
            let (cost, u) = queue.pop()
            if cost != result[u]: continue
            for (v, w) in adj[u]:
                if w >= INF - cost: continue
                let candidate = cost + w
                if candidate < result[v]:
                    result[v] = candidate
                    queue.push((candidate, v))

    proc shortest_path_graph_impl[G; T: SomeSignedInt](g: G, s, t: int, INF: T): ShortestPathGraphResult[T] =
        ## 最短 walk の各有向辺を抽出する。時間 O(V + A log(A+2))、追加領域 O(V+A)。
        if s < 0 or s >= g.len or t < 0 or t >= g.len:
            raise newException(ValueError, "s,t はグラフ内の頂点である必要があります")
        if INF <= T(0):
            raise newException(ValueError, "INF は正である必要があります")
        when G is StaticGraphTypes:
            if g.start.len != g.len + 1:
                raise newException(ValueError, "静的グラフは build が必要です")
        var forward, reverse: seq[seq[tuple[dst: int, cost: T]]]
        forward = newSeq[seq[tuple[dst: int, cost: T]]](g.len)
        reverse = newSeq[seq[tuple[dst: int, cost: T]]](g.len)
        for u in 0..<g.len:
            for (v, cost) in g.to_and_cost(u):
                let w = T(cost)
                if w < T(0):
                    raise newException(ValueError, "負辺には対応していません")
                forward[u].add((v, w))
                reverse[v].add((u, w))
        let fromS = bounded_distances(forward, s, INF)
        result.distance = fromS[t]
        result.graph = initWeightedDirectedGraph(g.len, T)
        if result.distance == INF: return
        let toT = bounded_distances(reverse, t, INF)
        for u in 0..<g.len:
            if fromS[u] == INF or fromS[u] > result.distance: continue
            let remaining = result.distance - fromS[u]
            for (v, cost, id) in g.to_and_cost_and_id(u):
                let w = T(cost)
                if toT[v] != INF and w <= remaining and toT[v] == remaining - w:
                    result.graph.add_edge(u, v, w)
                    result.original_edge_ids.add(id)

    proc shortest_path_graph*[T: SomeSignedInt](g: WeightedGraph[T], s, t: int, INF: T = high(T)): ShortestPathGraphResult[T] =
        ## 指定 s,t 間の最短 walk に含まれる向きだけを残した有向グラフを返す。
        ## 非負の符号付き整数専用。浮動小数点の近似比較・負辺には対応しない。
        ## 頂点番号・重みを維持し、返り値の辺 id の元辺番号は original_edge_ids[id]。
        ## 無向辺は両方向を別々に判定する。ゼロ重みなら同じ元 id が複数回現れ得る。
        ## ゼロ閉路も含むため一般の単純最短路の辺集合とは限らない。正重みなら一致する。
        ## 距離 INF 以上は到達不能とし、distance=INF と辺のないグラフを返す。
        ## 有限距離は INF 未満が前提。差による判定・緩和で整数加算の overflow を避ける。
        ## 入力は変更せず、静的グラフは build 済みが必要。s=t は距離0の walk を扱う。
        ## A は隣接辺数。時間 O(V + A log(A+2))、返り値を含む追加領域 O(V+A)。
        shortest_path_graph_impl(g, s, t, INF)

    proc shortest_path_graph*(g: UnWeightedGraph, s, t: int, INF: int = high(int)): ShortestPathGraphResult[int] =
        ## 重みなしの各辺を重み1として抽出する。契約・計算量は整数重み版と同じ。
        shortest_path_graph_impl(g, s, t, INF)
