when not declared CPLIB_GRAPH_DIRECTED_MST:
    const CPLIB_GRAPH_DIRECTED_MST* = 1

    import cplib/collections/skew_heap
    import cplib/collections/unionfind
    import cplib/graph/graph
    import cplib/utils/constants
    import sequtils

    type DirectedMstHeapKey[T] = object
        cost: T
        src: int

    proc `<`*[T](a, b: DirectedMstHeapKey[T]): bool =
        (a.cost, a.src) < (b.cost, b.src)

    proc `+`*[T](key: DirectedMstHeapKey[T], delta: T): DirectedMstHeapKey[T] =
        DirectedMstHeapKey[T](cost: key.cost + delta, src: key.src)

    proc directedMstCostImpl[T](g: WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T], root: int, zero, inf: T): T =
        ## `root` からの最小全域有向木 (minimum arborescence) のコスト。
        ## 存在しない場合は `inf` を返す。
        let n = len(g)
        assert root in 0..<n
        var heaps = newSeq[SkewHeap[DirectedMstHeapKey[T], T]](n)
        for src in 0..<n:
            for (dst, cost) in g[src]:
                if src != dst:
                    heaps[dst].push(DirectedMstHeapKey[T](cost: cost, src: src))

        var uf = initUnionFind(n)
        var used = newSeqWith(n, -1)
        result = zero
        for start in 0..<n:
            var path: seq[int]
            var u = uf.root(start)
            while used[u] < 0:
                used[u] = start
                if u == root: break
                while not heaps[u].isEmpty and uf.issame(u, heaps[u].top.src):
                    discard heaps[u].pop()
                if heaps[u].isEmpty: return inf

                let edge = heaps[u].top
                result += edge.cost
                heaps[u].addAll(-edge.cost)
                path.add(u)
                u = uf.root(edge.src)

                if used[u] == start:
                    var cycle = initSkewHeap[DirectedMstHeapKey[T], T]()
                    while true:
                        let v = path.pop()
                        cycle.meld(heaps[v])
                        if uf.issame(u, v): break
                        uf.unite(u, v)
                    u = uf.root(u)
                    heaps[u] = cycle
                    used[u] = -1

    proc directedMstCost*(g: WeightedDirectedGraph[int] or WeightedDirectedStaticGraph[int], root: int, zero: int = 0, inf: int = INF64): int =
        directedMstCostImpl(g, root, zero, inf)

    proc directedMstCost*(g: WeightedDirectedGraph[int32] or WeightedDirectedStaticGraph[int32], root: int, zero: int32 = 0'i32, inf: int32 = INF32): int32 =
        directedMstCostImpl(g, root, zero, inf)

    proc directedMstCost*(g: WeightedDirectedGraph[float] or WeightedDirectedStaticGraph[float], root: int, zero: float = 0.0, inf: float = 1e100): float =
        directedMstCostImpl(g, root, zero, inf)

    proc directedMstCost*(g: WeightedDirectedGraph[float32] or WeightedDirectedStaticGraph[float32], root: int, zero: float32 = 0.0'f32, inf: float32 = 1e30'f32): float32 =
        directedMstCostImpl(g, root, zero, inf)

    proc directedMstCost*[T](g: WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T], root: int, zero, inf: T): T =
        directedMstCostImpl(g, root, zero, inf)

    proc get_directed_MST_cost*(g: WeightedDirectedGraph[int] or WeightedDirectedStaticGraph[int], root: int, zero: int = 0, inf: int = INF64): int =
        directedMstCostImpl(g, root, zero, inf)

    proc get_directed_MST_cost*[T](g: WeightedDirectedGraph[T] or WeightedDirectedStaticGraph[T], root: int, zero, inf: T): T =
        directedMstCostImpl(g, root, zero, inf)
