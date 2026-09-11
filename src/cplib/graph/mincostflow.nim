when not declared CPLIB_GRAPH_MINCOSTFLOW:
    const CPLIB_GRAPH_MINCOSTFLOW* = 1
    import heapqueue

    type
        MinCostFlowEdge*[Cap, Cost] = object
            src*, dst*: int
            cap*, flow*: Cap
            cost*: Cost
        MinCostFlowArc[Cap, Cost] = object
            dst, rev: int
            cap: Cap
            cost: Cost
        MinCostFlow*[Cap, Cost] = object
            graph: seq[seq[MinCostFlowArc[Cap, Cost]]]
            positions: seq[tuple[src, index: int]]

    proc initMinCostFlow*[Cap: SomeInteger, Cost: SomeSignedInt](n: int, capacityZero: Cap = 0, costZero: Cost = 0): MinCostFlow[Cap, Cost] =
        ## n頂点の最小費用流グラフを構築する。容量・費用型の省略時はint。O(n)。
        ## capacityZeroとcostZeroは型推論用。
        assert n >= 0
        result.graph = newSeq[seq[MinCostFlowArc[Cap, Cost]]](n)

    proc add_edge*[Cap, Cost](g: var MinCostFlow[Cap, Cost], src, dst: int, cap: Cap, cost: Cost): int {.discardable.} =
        ## 容量cap、単位費用costの有向辺を追加し、辺番号を返す。償却O(1)。
        assert src in 0..<g.graph.len and dst in 0..<g.graph.len
        assert cap >= Cap(0) and cost != low(Cost)
        result = g.positions.len
        let index = g.graph[src].len
        let rev = g.graph[dst].len + ord(src == dst)
        g.positions.add((src, index))
        g.graph[src].add(MinCostFlowArc[Cap, Cost](dst: dst, rev: rev, cap: cap, cost: cost))
        g.graph[dst].add(MinCostFlowArc[Cap, Cost](dst: src, rev: index, cap: Cap(0), cost: -cost))

    proc get_edge*[Cap, Cost](g: MinCostFlow[Cap, Cost], i: int): MinCostFlowEdge[Cap, Cost] =
        ## i番目の辺の容量、現在の流量、単位費用を返す。O(1)。
        let (src, index) = g.positions[i]
        let e = g.graph[src][index]
        let flow = g.graph[e.dst][e.rev].cap
        MinCostFlowEdge[Cap, Cost](src: src, dst: e.dst, cap: e.cap + flow, flow: flow, cost: e.cost)

    proc get_edges*[Cap, Cost](g: MinCostFlow[Cap, Cost]): seq[MinCostFlowEdge[Cap, Cost]] =
        ## 追加順に全辺の情報を返す。O(E)。
        for i in 0..<g.positions.len:
            result.add(g.get_edge(i))

    proc slope*[Cap, Cost](g: var MinCostFlow[Cap, Cost], src, dst: int, limit: Cap = high(Cap)): seq[tuple[flow: Cap, cost: Cost]] =
        ## 追加流量と最小費用の折れ点を返す。同じ傾きはまとめる。O(VE + A E log V)、Aは増加回数。
        ## 負費用辺に対応するが、始点から到達可能な負閉路はValueError。費用の中間値はCostに収まること。
        assert src in 0..<g.graph.len and dst in 0..<g.graph.len and src != dst
        assert limit >= Cap(0)
        result = @[(Cap(0), Cost(0))]
        if limit == Cap(0):
            return
        let n = g.graph.len
        var potential = newSeq[Cost](n)
        var reached = newSeq[bool](n)
        reached[src] = true
        for phase in 0..<n:
            var changed = false
            for v in 0..<n:
                if not reached[v]:
                    continue
                for e in g.graph[v]:
                    if e.cap > Cap(0) and (not reached[e.dst] or potential[e.dst] > potential[v] + e.cost):
                        potential[e.dst] = potential[v] + e.cost
                        reached[e.dst] = true
                        changed = true
            if not changed:
                break
            if phase == n - 1:
                raise newException(ValueError, "始点から到達可能な負閉路があります")
        var totalFlow = Cap(0)
        var totalCost = Cost(0)
        var previousCost = Cost(0)
        var hasPrevious = false
        var distance = newSeq[Cost](n)
        var prevVertex = newSeq[int](n)
        var prevEdge = newSeq[int](n)
        while totalFlow < limit:
            for v in 0..<n:
                reached[v] = false
            distance[src] = Cost(0)
            reached[src] = true
            var queue = initHeapQueue[(Cost, int)]()
            queue.push((Cost(0), src))
            while queue.len > 0:
                let (d, v) = queue.pop()
                if d != distance[v]:
                    continue
                for i, e in g.graph[v]:
                    if e.cap == Cap(0):
                        continue
                    let nd = d + (e.cost + potential[v] - potential[e.dst])
                    if not reached[e.dst] or nd < distance[e.dst]:
                        reached[e.dst] = true
                        distance[e.dst] = nd
                        prevVertex[e.dst] = v
                        prevEdge[e.dst] = i
                        queue.push((nd, e.dst))
            if not reached[dst]:
                break
            for v in 0..<n:
                if reached[v]:
                    potential[v] += distance[v]
            let unitCost = potential[dst] - potential[src]
            var pushed = limit - totalFlow
            var v = dst
            while v != src:
                let u = prevVertex[v]
                pushed = min(pushed, g.graph[u][prevEdge[v]].cap)
                v = u
            var nextCost = totalCost
            if unitCost != Cost(0):
                nextCost += Cost(pushed) * unitCost
            v = dst
            while v != src:
                let u = prevVertex[v]
                let i = prevEdge[v]
                let rev = g.graph[u][i].rev
                g.graph[u][i].cap -= pushed
                g.graph[v][rev].cap += pushed
                v = u
            totalFlow += pushed
            totalCost = nextCost
            if hasPrevious and previousCost == unitCost:
                result.setLen(result.len - 1)
            result.add((totalFlow, totalCost))
            previousCost = unitCost
            hasPrevious = true

    proc flow*[Cap, Cost](g: var MinCostFlow[Cap, Cost], src, dst: int, limit: Cap = high(Cap)): tuple[flow: Cap, cost: Cost] =
        ## limit以下の流量を追加し、追加流量と費用を返す。計算量と制約はslopeと同じ。
        g.slope(src, dst, limit)[^1]
