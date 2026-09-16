when not declared CPLIB_GRAPH_GRAPH:
    const CPLIB_GRAPH_GRAPH* = 1

    type EdgeInfo*[T] = object
        src*, dst*: int
        when T isnot void:
            cost*: T
    type AdjacentEdge* = tuple[dst: int32, id: int32]
    type WeightedAdjacentEdge*[T] = tuple[dst: int32, id: int32, cost: T]
    # 重みは走査を高速化するため隣接配列にも保存する。公開配列の重みは直接変更しないこと。
    type DynamicGraph*[T] = ref object of RootObj
        when T is void:
            edges*: seq[seq[AdjacentEdge]]
        else:
            edges*: seq[seq[WeightedAdjacentEdge[T]]]
        edge_info*: seq[EdgeInfo[T]]
        len*: int
    type StaticGraph*[T] = ref object of RootObj
        edge_info*: seq[EdgeInfo[T]]
        when T is void:
            elist*: seq[AdjacentEdge]
        else:
            elist*: seq[WeightedAdjacentEdge[T]]
        start*: seq[int32]
        direction: int # 0: 未追加、1: 有向、2: 無向、3: 混在
        directed: seq[bool]
        len*: int

    type WeightedDirectedGraph*[T] = ref object of DynamicGraph[T]
    type WeightedUnDirectedGraph*[T] = ref object of DynamicGraph[T]
    type UnWeightedDirectedGraph* = ref object of DynamicGraph[void]
    type UnWeightedUnDirectedGraph* = ref object of DynamicGraph[void]
    type WeightedDirectedStaticGraph*[T] = ref object of StaticGraph[T]
    type WeightedUnDirectedStaticGraph*[T] = ref object of StaticGraph[T]
    type UnWeightedDirectedStaticGraph* = ref object of StaticGraph[void]
    type UnWeightedUnDirectedStaticGraph* = ref object of StaticGraph[void]

    type GraphTypes*[T] = DynamicGraph[T] or StaticGraph[T]
    type DirectedGraph* = WeightedDirectedGraph or UnWeightedDirectedGraph or WeightedDirectedStaticGraph or UnWeightedDirectedStaticGraph
    type UnDirectedGraph* = WeightedUnDirectedGraph or UnWeightedUnDirectedGraph or WeightedUnDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type WeightedGraph*[T] = WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T] or WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T]
    type UnWeightedGraph* = UnWeightedDirectedGraph or UnWeightedUnDirectedGraph or UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph
    type DynamicGraphTypes* = WeightedDirectedGraph or UnWeightedDirectedGraph or WeightedUnDirectedGraph or UnWeightedUnDirectedGraph
    type StaticGraphTypes* = WeightedDirectedStaticGraph or UnWeightedDirectedStaticGraph or WeightedUnDirectedStaticGraph or UnWeightedUnDirectedStaticGraph

    proc add_edge_dynamic_impl*[T](g: DynamicGraph[T], u, v: int, cost: T, directed: bool): int {.discardable.} =
        ## 辺を追加し、追加順の辺番号を返す。償却 O(1)。
        result = g.edge_info.len
        g.edge_info.add(EdgeInfo[T](src: u, dst: v, cost: cost))
        g.edges[u].add((v.int32, result.int32, cost))
        if not directed: g.edges[v].add((u.int32, result.int32, cost))

    proc add_edge_dynamic_impl*(g: DynamicGraph[void], u, v: int, directed: bool): int {.discardable.} =
        ## 辺を追加し、追加順の辺番号を返す。償却 O(1)。
        result = g.edge_info.len
        g.edge_info.add(EdgeInfo[void](src: u, dst: v))
        g.edges[u].add((v.int32, result.int32))
        if not directed: g.edges[v].add((u.int32, result.int32))

    proc record_direction[T](g: StaticGraph[T], directed: bool) =
        ## 通常は向きを一つだけ保存し、混在時のみ辺ごとの配列を確保する。償却 O(1)。
        let direction = if directed: 1 else: 2
        if g.direction == 0:
            g.direction = direction
        elif g.direction != direction:
            if g.direction != 3:
                g.directed = newSeq[bool](g.edge_info.len - 1)
                if g.direction == 1:
                    for i in 0..<g.directed.len: g.directed[i] = true
                g.direction = 3
            g.directed.add(directed)

    proc add_edge_static_impl*[T](g: StaticGraph[T], u, v: int, cost: T, directed: bool): int {.discardable.} =
        ## 辺を追加し、追加順の辺番号を返す。償却 O(1)。追加後は build が必要。
        result = g.edge_info.len
        g.edge_info.add(EdgeInfo[T](src: u, dst: v, cost: cost))
        g.record_direction(directed)
        g.start.setLen(0)

    proc add_edge_static_impl*(g: StaticGraph[void], u, v: int, directed: bool): int {.discardable.} =
        ## 辺を追加し、追加順の辺番号を返す。償却 O(1)。追加後は build が必要。
        result = g.edge_info.len
        g.edge_info.add(EdgeInfo[void](src: u, dst: v))
        g.record_direction(directed)
        g.start.setLen(0)

    proc build_csr[T](g: StaticGraph[T], direction: static int) =
        ## 隣接辺の CSR 配列を構築する。O(V + E)。辺番号と走査順は維持する。
        template isUndirected(id: int): bool =
            when direction == 3: not g.directed[id]
            else: direction == 2
        g.start = newSeq[int32](g.len + 1)
        for id, e in g.edge_info:
            inc g.start[e.src + 1]
            if isUndirected(id): inc g.start[e.dst + 1]
        for i in 0..<g.len: g.start[i + 1] += g.start[i]
        when T is void:
            g.elist = newSeq[AdjacentEdge](g.start[^1])
        else:
            g.elist = newSeq[WeightedAdjacentEdge[T]](g.start[^1])
        var cursor = newSeq[int32](g.len)
        for i in 0..<g.len: cursor[i] = g.start[i]
        for id, e in g.edge_info:
            when T is void:
                g.elist[cursor[e.src]] = (e.dst.int32, id.int32)
            else:
                g.elist[cursor[e.src]] = (e.dst.int32, id.int32, e.cost)
            inc cursor[e.src]
            if isUndirected(id):
                when T is void:
                    g.elist[cursor[e.dst]] = (e.src.int32, id.int32)
                else:
                    g.elist[cursor[e.dst]] = (e.src.int32, id.int32, e.cost)
                inc cursor[e.dst]

    proc build_impl*[T](g: StaticGraph[T]) =
        ## 有向・無向に特殊化して CSR 配列を構築する。O(V + E)。
        case g.direction
        of 2: g.build_csr(2)
        of 3: g.build_csr(3)
        else: g.build_csr(1)

    proc build*(g: StaticGraphTypes) =
        ## 静的グラフを構築する。O(V + E)。
        g.build_impl()

    proc static_graph_initialized_check*[T](g: StaticGraph[T]) =
        ## 静的グラフが構築済みであることを確認する。O(1)。
        assert g.start.len > 0, "Static Graphは使用前に初期化する必要があります"

    proc reserve_seq[T](s: var seq[T], capacity: int) =
        ## 既存の要素を維持し、指定要素数を格納できる配列を確保する。
        if capacity <= s.len: return
        var reserved = newSeqOfCap[T](capacity)
        for e in s: reserved.add(e)
        s = move(reserved)

    proc reserve*[T](g: DynamicGraph[T], capacity: int, degrees: openArray[int] = []) =
        ## 総辺数と各頂点の隣接要素数を予約する。既存要素は維持し、必要な配列を再確保する。
        assert capacity >= 0, "capacityは非負である必要があります"
        assert degrees.len == 0 or degrees.len == g.len, "次数の配列は空か、頂点数と同じ長さである必要があります"
        g.edge_info.reserve_seq(capacity)
        for u, degree in degrees:
            assert degree >= 0, "degreeは非負である必要があります"
            g.edges[u].reserve_seq(degree)

    proc initWeightedDirectedGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedDirectedGraph[edgetype] =
        ## 頂点数 N のグラフを初期化する。O(N)。
        result = WeightedDirectedGraph[edgetype](edge_info: newSeqOfCap[EdgeInfo[edgetype]](capacity), edges: newSeq[seq[WeightedAdjacentEdge[edgetype]]](N), len: N)
    proc add_edge*[T](g: var WeightedDirectedGraph[T], u, v: int, cost: T): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_dynamic_impl(u, v, cost, true)

    proc initWeightedUnDirectedGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedUnDirectedGraph[edgetype] =
        ## 頂点数 N のグラフを初期化する。O(N)。
        result = WeightedUnDirectedGraph[edgetype](edge_info: newSeqOfCap[EdgeInfo[edgetype]](capacity), edges: newSeq[seq[WeightedAdjacentEdge[edgetype]]](N), len: N)
    proc add_edge*[T](g: var WeightedUnDirectedGraph[T], u, v: int, cost: T): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_dynamic_impl(u, v, cost, false)

    proc initUnWeightedDirectedGraph*(N: int, capacity: int = 0): UnWeightedDirectedGraph =
        ## 頂点数 N のグラフを初期化する。O(N)。
        result = UnWeightedDirectedGraph(edge_info: newSeqOfCap[EdgeInfo[void]](capacity), edges: newSeq[seq[AdjacentEdge]](N), len: N)
    proc add_edge*(g: var UnWeightedDirectedGraph, u, v: int): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_dynamic_impl(u, v, true)

    proc initUnWeightedUnDirectedGraph*(N: int, capacity: int = 0): UnWeightedUnDirectedGraph =
        ## 頂点数 N のグラフを初期化する。O(N)。
        result = UnWeightedUnDirectedGraph(edge_info: newSeqOfCap[EdgeInfo[void]](capacity), edges: newSeq[seq[AdjacentEdge]](N), len: N)
    proc add_edge*(g: var UnWeightedUnDirectedGraph, u, v: int): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_dynamic_impl(u, v, false)

    proc initWeightedDirectedStaticGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedDirectedStaticGraph[edgetype] =
        ## 頂点数 N のグラフを初期化し、capacity 辺分の領域を確保する。
        result = WeightedDirectedStaticGraph[edgetype](edge_info: newSeqOfCap[EdgeInfo[edgetype]](capacity), len: N)
    proc add_edge*[T](g: var WeightedDirectedStaticGraph[T], u, v: int, cost: T): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_static_impl(u, v, cost, true)

    proc initWeightedUnDirectedStaticGraph*(N: int, edgetype: typedesc = int, capacity: int = 0): WeightedUnDirectedStaticGraph[edgetype] =
        ## 頂点数 N のグラフを初期化し、capacity 辺分の領域を確保する。
        result = WeightedUnDirectedStaticGraph[edgetype](edge_info: newSeqOfCap[EdgeInfo[edgetype]](capacity), len: N)
    proc add_edge*[T](g: var WeightedUnDirectedStaticGraph[T], u, v: int, cost: T): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_static_impl(u, v, cost, false)

    proc initUnWeightedDirectedStaticGraph*(N: int, capacity: int = 0): UnWeightedDirectedStaticGraph =
        ## 頂点数 N のグラフを初期化し、capacity 辺分の領域を確保する。
        result = UnWeightedDirectedStaticGraph(edge_info: newSeqOfCap[EdgeInfo[void]](capacity), len: N)
    proc add_edge*(g: var UnWeightedDirectedStaticGraph, u, v: int): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_static_impl(u, v, true)

    proc initUnWeightedUnDirectedStaticGraph*(N: int, capacity: int = 0): UnWeightedUnDirectedStaticGraph =
        ## 頂点数 N のグラフを初期化し、capacity 辺分の領域を確保する。
        result = UnWeightedUnDirectedStaticGraph(edge_info: newSeqOfCap[EdgeInfo[void]](capacity), len: N)
    proc add_edge*(g: var UnWeightedUnDirectedStaticGraph, u, v: int): int {.discardable.} =
        ## 辺を追加し、0 始まりの辺番号を返す。償却 O(1)。
        g.add_edge_static_impl(u, v, false)

    proc len*[T](g: DynamicGraph[T] or StaticGraph[T]): int =
        ## 頂点数を返す。O(1)。
        g.len

    proc edge_count*[T](g: DynamicGraph[T] or StaticGraph[T]): int =
        ## 辺数を返す。無向辺も一辺として数える。O(1)。
        g.edge_info.len

    proc get_edge*[T](g: DynamicGraph[T] or StaticGraph[T], id: int): EdgeInfo[T] =
        ## 辺番号から追加時の向きの辺情報を取得する。O(1)。
        g.edge_info[id]

    iterator to_and_id*[T](g: DynamicGraph[T], x: int): tuple[dst: int, id: int] =
        ## 隣接頂点と辺番号を追加順に列挙する。O(deg(x))。
        for e in g.edges[x]: yield (e.dst.int, e.id.int)

    iterator to_and_id*[T](g: StaticGraph[T], x: int): tuple[dst: int, id: int] =
        ## 隣接頂点と辺番号を追加順に列挙する。O(deg(x))。
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x + 1]:
            let e = g.elist[i]
            yield (e.dst.int, e.id.int)

    iterator to_and_cost_and_id*[T](g: DynamicGraph[T], x: int): auto =
        ## 隣接頂点、重み、辺番号を列挙する。重みなしは重み 1 を返す。O(deg(x))。
        for e in g.edges[x]:
            when T is void: yield (e.dst.int, 1, e.id.int)
            else: yield (e.dst.int, e.cost, e.id.int)

    iterator to_and_cost_and_id*[T](g: StaticGraph[T], x: int): auto =
        ## 隣接頂点、重み、辺番号を列挙する。重みなしは重み 1 を返す。O(deg(x))。
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x + 1]:
            let e = g.elist[i]
            when T is void: yield (e.dst.int, 1, e.id.int)
            else: yield (e.dst.int, e.cost, e.id.int)

    iterator to_and_cost*[T](g: DynamicGraph[T], x: int): auto =
        ## 隣接頂点と重みを列挙する。重みなしは重み 1 を返す。O(deg(x))。
        for e in g.edges[x]:
            when T is void: yield (e.dst.int, 1)
            else: yield (e.dst.int, e.cost)

    iterator to_and_cost*[T](g: StaticGraph[T], x: int): auto =
        ## 隣接頂点と重みを列挙する。重みなしは重み 1 を返す。O(deg(x))。
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x + 1]:
            let e = g.elist[i]
            when T is void: yield (e.dst.int, 1)
            else: yield (e.dst.int, e.cost)

    iterator `[]`*[T](g: WeightedDirectedGraph[T] or WeightedUnDirectedGraph[T], x: int): (int, T) =
        ## 隣接頂点と重みを追加順に列挙する。O(deg(x))。
        for e in g.edges[x]: yield (e.dst.int, e.cost)

    iterator `[]`*[T](g: WeightedDirectedStaticGraph[T] or WeightedUnDirectedStaticGraph[T], x: int): (int, T) =
        ## 隣接頂点と重みを追加順に列挙する。O(deg(x))。
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x + 1]:
            let e = g.elist[i]
            yield (e.dst.int, e.cost)

    iterator `[]`*(g: UnWeightedDirectedGraph or UnWeightedUnDirectedGraph, x: int): int =
        ## 隣接頂点を追加順に列挙する。O(deg(x))。
        for e in g.edges[x]: yield e.dst.int

    iterator `[]`*(g: UnWeightedDirectedStaticGraph or UnWeightedUnDirectedStaticGraph, x: int): int =
        ## 隣接頂点を追加順に列挙する。O(deg(x))。
        g.static_graph_initialized_check()
        for i in g.start[x]..<g.start[x + 1]: yield g.elist[i].dst.int

    import tables

    type UnWeightedUnDirectedTableGraph*[T] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : UnWeightedUnDirectedGraph

    type UnWeightedDirectedTableGraph*[T] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : UnWeightedDirectedGraph

    type WeightedUnDirectedTableGraph*[T,S] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : WeightedUnDirectedGraph[S]

    type WeightedDirectedTableGraph*[T,S] = object 
        toi* : Table[T,int]
        v* : seq[T]
        graph* : WeightedDirectedGraph[S]

    type UnWeightedTableGraph*[T] = UnWeightedUnDirectedTableGraph[T] or UnWeightedDirectedTableGraph[T]
    type WeightedTableGraph*[T,S] = WeightedUnDirectedTableGraph[T,S] or WeightedDirectedTableGraph[T,S]

    proc initUnWeightedUnDirectedTableGraph*[T](V:openArray[T]):UnWeightedUnDirectedTableGraph[T]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initUnWeightedUnDirectedGraph(len(V))
        result.v = @V

    proc initUnWeightedDirectedTableGraph*[T](V:openArray[T]):UnWeightedDirectedTableGraph[T]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initUnWeightedDirectedGraph(len(V))
        result.v = @V

    proc initWeightedUnDirectedTableGraph*[T](V:openArray[T],S:typedesc = int):WeightedUnDirectedTableGraph[T,S]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initWeightedUnDirectedGraph(len(V),S)
        result.v = @V

    proc initWeightedDirectedTableGraph*[T](V:openArray[T],S:typedesc = int):WeightedDirectedTableGraph[T,S]=
        for i in 0..<len(V):
            result.toi[V[i]] = i
        result.graph = initWeightedDirectedGraph(len(V),S)
        result.v = @V

    proc add_edge*[T](g: var UnWeightedTableGraph[T],u,v:T): int {.discardable.} =
        ## ラベルで指定した辺を追加し、辺番号を返す。償却 O(1)。
        g.graph.add_edge(g.toi[u],g.toi[v])

    proc add_edge*[T,S](g: var WeightedTableGraph[T,S],u,v:T,cost:S): int {.discardable.} =
        ## ラベルで指定した辺を追加し、辺番号を返す。償却 O(1)。
        g.graph.add_edge(g.toi[u],g.toi[v],cost)

    iterator `[]`*[T,S](g: WeightedDirectedTableGraph[T,S] or WeightedUnDirectedTableGraph[T,S], x: T): (T, S) = 
        for (x,y) in g.graph[g.toi[x]]:
            yield (g.v[x],y)
    iterator `[]`*[T](g: UnWeightedDirectedTableGraph[T] or UnWeightedUnDirectedTableGraph[T], x: T): T = 
        for x in g.graph[g.toi[x]]:
            yield g.v[x]

    iterator to_and_id*[T](g: UnWeightedTableGraph[T], x: T): tuple[dst: T, id: int] =
        ## 隣接頂点のラベルと辺番号を列挙する。O(deg(x))。
        for (dst, id) in g.graph.to_and_id(g.toi[x]): yield (g.v[dst], id)

    iterator to_and_id*[T, S](g: WeightedTableGraph[T, S], x: T): tuple[dst: T, id: int] =
        ## 隣接頂点のラベルと辺番号を列挙する。O(deg(x))。
        for (dst, id) in g.graph.to_and_id(g.toi[x]): yield (g.v[dst], id)

    iterator to_and_cost_and_id*[T, S](g: WeightedTableGraph[T, S], x: T): tuple[dst: T, cost: S, id: int] =
        ## 隣接頂点のラベル、重み、辺番号を列挙する。O(deg(x))。
        for (dst, cost, id) in g.graph.to_and_cost_and_id(g.toi[x]): yield (g.v[dst], cost, id)
