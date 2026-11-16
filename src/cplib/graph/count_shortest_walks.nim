when not declared CPLIB_GRAPH_COUNT_SHORTEST_WALKS:
    ## 非負の符号付き整数重みに対する単一始点の最短 walk 数。
    ## r = g.count_shortest_walks(source, Mint.init(0), Mint.init(1)) のように個数型の0と1を渡す。
    ## distance[v] は重み型、status[v] は到達不能/有限/無限、count[v] は有限時だけ有効な個数型。
    ## 到達不能の距離は INF。到達不能/無限の count は zero とし、無限を modint に混ぜない。
    ## source の空 walk を1個と数える。隣接辺を区別するため多重辺は別の walk を作る。
    ## 無向辺は二方向を走査し、無向自己ループの二つの隣接要素も個別に数える。
    ## float の近似等式は扱わない。入力は通常の graph API で構築し、静的グラフは build 済みとする。
    ## 有限な最短距離は INF 未満で、各到達頂点の最短距離+各出辺重みは重み型に収まること。
    ## Dijkstra の不要な緩和候補にもこの前提が必要。加算を飽和させたり overflow を検出したりはしない。
    ## count の += は個数の加算、zero/one はその0/1であること。通常整数の個数 overflow も呼出側の責任。
    ## 個数型は値としてコピーでき、+= は右辺や他のコピーを変更しないこと。無限状態の確定後に有限個数だけを加算する。
    ## tight graph の閉路は重み0のみ。SCC のトポロジカル順で無限状態と有限個数を後続へ伝播する。
    ## 既存 SCC は再帰するため、ネイティブスタック容量にも依存する。辺ID/添字の容量は graph と同じ。
    const CPLIB_GRAPH_COUNT_SHORTEST_WALKS* = 1
    import cplib/graph/graph
    import cplib/graph/dijkstra
    import cplib/graph/SCC

    type ShortestWalkStatus* = enum
        shortestWalkUnreachable, shortestWalkFinite, shortestWalkInfinite
    type ShortestWalkCountResult*[T, C] = object
        distance*: seq[T]
        status*: seq[ShortestWalkStatus]
        count*: seq[C]

    proc count_shortest_walks_impl[T: SomeSignedInt, C](g: WeightedGraph[T] or UnWeightedGraph,
            source: int, zero, one: C, INF: T): ShortestWalkCountResult[T, C] =
        ## 非負整数重みの単一始点最短 walk 数を返す。時間 O(V+A log(A+2))、領域 O(V+A)。
        if source < 0 or source >= g.len:
            raise newException(ValueError, "sourceが頂点の範囲外です")
        if INF <= T(0):
            raise newException(ValueError, "INFは正である必要があります")
        when g is StaticGraphTypes:
            if g.start.len != g.len + 1:
                raise newException(ValueError, "静的グラフにはbuildが必要です")
        for u in 0..<g.len:
            for (_, w) in g.to_and_cost(u):
                if w < 0:
                    raise newException(ValueError, "辺重みは非負である必要があります")
        result.distance = g.dijkstra(source, T(0), INF)
        result.status = newSeq[ShortestWalkStatus](g.len)
        result.count = newSeq[C](g.len)
        var tight = initUnWeightedDirectedGraph(g.len)
        for u in 0..<g.len:
            result.count[u] = zero
            if result.distance[u] == INF: continue
            result.status[u] = shortestWalkFinite
            for (v, w) in g.to_and_cost(u):
                if result.distance[v] != INF and result.distance[u] + w == result.distance[v]:
                    tight.add_edge(u, v)
        let groups = tight.SCC()
        for group in groups:
            var infinite = group.len > 1
            for u in group:
                if result.status[u] == shortestWalkInfinite: infinite = true
                for v in tight[u]:
                    if u == v: infinite = true
            if infinite:
                for u in group:
                    result.status[u] = shortestWalkInfinite
            for u in group:
                if result.status[u] == shortestWalkInfinite:
                    for v in tight[u]:
                        result.status[v] = shortestWalkInfinite
        if result.status[source] == shortestWalkFinite: result.count[source] = one
        for group in groups:
            for u in group:
                if result.status[u] != shortestWalkFinite: continue
                for v in tight[u]:
                    if result.status[v] == shortestWalkFinite:
                        result.count[v] += result.count[u]

    proc count_shortest_walks*[T: SomeSignedInt, C](g: WeightedGraph[T], source: int,
            zero, one: C, INF: T = high(T)): ShortestWalkCountResult[T, C] =
        ## 距離と有限個数と状態を分離して返す。zero/one は個数型の加法単位元/1。
        ## 有限距離 < INF、到達頂点の距離+各出辺重みが T に収まることが前提。個数の overflow も呼出側の責任。
        count_shortest_walks_impl(g, source, zero, one, INF)

    proc count_shortest_walks*[C](g: UnWeightedGraph, source: int, zero, one: C,
            INF: int = high(int)): ShortestWalkCountResult[int, C] =
        ## 重みなしの各隣接辺を重み1として最短 walk 数を返す。算術の前提は重み付き版と同じ。
        count_shortest_walks_impl(g, source, zero, one, INF)
