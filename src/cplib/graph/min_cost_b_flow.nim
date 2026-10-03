when not declared CPLIB_GRAPH_MIN_COST_B_FLOW:
    const CPLIB_GRAPH_MIN_COST_B_FLOW* = 1
    import heapqueue
    import cplib/math/int128

    type
        MinCostBFlowEdge* = object
            src*, dst*: int
            lower*, upper*, cost*, flow*: int64
        MinCostBFlowResult* = object
            feasible*: bool
            cost*: Int128
        MinCostBFlow* = object
            supply: seq[Int128]
            edges: seq[MinCostBFlowEdge]
            potential: seq[Int128]
            solved: bool
        BFlowArc = object
            dst: int
            cap, cost: Int128

    proc initMinCostBFlow*(n: int): MinCostBFlow =
        ## n頂点の最小費用b-flowを構築する。b > 0は供給（流出−流入=b）。O(n)。
        ## 入力・元辺流量はint64（-2^63..2^63-1）、中間値・総費用・potentialはInt128（-2^127..2^127-1）。
        ## C++ backend、__int128対応のGCC/Clangとlibstdc++が必要。表示・演算にはcplib/math/int128もimportする。
        assert n >= 0, "nは非負である必要があります"
        result.supply = newSeq[Int128](n)

    proc add_supply*(g: var MinCostBFlow, v: int, amount: int64) =
        ## 頂点vの供給にamountを加算する。負値は需要。解を無効化する。O(1)。
        assert v in 0..<g.supply.len, "頂点番号が範囲外です"
        g.supply[v] += to_Int128(amount)
        g.solved = false

    proc add_edge*(g: var MinCostBFlow, src, dst: int, lower, upper, cost: int64): int {.discardable.} =
        ## 上下限と単位費用を持つ辺を追加し、辺番号を返す。負の上下限・自己ループも許す。償却O(1)。
        assert src in 0..<g.supply.len and dst in 0..<g.supply.len, "頂点番号が範囲外です"
        assert lower <= upper, "lower <= upperが必要です"
        result = g.edges.len
        g.edges.add(MinCostBFlowEdge(src: src, dst: dst, lower: lower, upper: upper, cost: cost))
        g.solved = false

    proc bFlowInt64(x: Int128): int64 {.importcpp: "((long long)(#))", nodecl.}

    proc solve*(g: var MinCostBFlow): MinCostBFlowResult =
        ## 最小費用b-flowを毎回最初から求める。実行不能ならfeasible=false（cost=0）。
        ## 容量スケーリング。O((N+M)^2 log(N+M+2) log(U+2) + NM)、空間O(N+M)。
        ## Uは1、上下限の差、下限を流した後の各頂点収支の絶対値の最大値。
        ## 全ての収支・残余容量・距離・potential・費用の中間値は符号つき128ビットに収まること。
        g.solved = false
        let n = g.supply.len
        var balance = newSeq[Int128](n)
        var total: Int128 = 0
        for v in 0..<n:
            balance[v] = g.supply[v]
            total += balance[v]
        if total != 0:
            return
        var graph = newSeq[seq[int]](n)
        var arcs: seq[BFlowArc]
        var bound: Int128 = 1
        for e in g.edges:
            let width = to_Int128(e.upper) - to_Int128(e.lower)
            let cost = to_Int128(e.cost)
            graph[e.src].add(arcs.len)
            arcs.add(BFlowArc(dst: e.dst, cap: width, cost: cost))
            graph[e.dst].add(arcs.len)
            arcs.add(BFlowArc(dst: e.src, cap: 0, cost: -cost))
            if e.src != e.dst:
                balance[e.src] -= to_Int128(e.lower)
                balance[e.dst] += to_Int128(e.lower)
            bound = max(bound, width)
        for b in balance:
            bound = max(bound, abs(b))
        var delta: Int128 = 1
        while delta <= bound div 2:
            delta *= 2
        var potential = newSeq[Int128](n)
        var distance = newSeq[Int128](n)
        var reached = newSeq[bool](n)
        var parent = newSeq[int](n)
        while delta > 0:
            # delta以上の残余辺の被約費用を非負にする。
            for u in 0..<n:
                for i in graph[u]:
                    let v = arcs[i].dst
                    if arcs[i].cost + potential[u] - potential[v] < 0:
                        let amount = arcs[i].cap - arcs[i].cap mod delta
                        arcs[i].cap -= amount
                        arcs[i xor 1].cap += amount
                        if u != v:
                            balance[u] -= amount
                            balance[v] += amount
            while true:
                var queue = initHeapQueue[(Int128, int)]()
                for v in 0..<n:
                    reached[v] = balance[v] >= delta
                    parent[v] = -1
                    if reached[v]:
                        distance[v] = 0
                        queue.push((to_Int128(0), v))
                var target = -1
                while queue.len > 0:
                    let (d, u) = queue.pop()
                    if d != distance[u]:
                        continue
                    if balance[u] <= -delta:
                        target = u
                        break
                    for i in graph[u]:
                        if arcs[i].cap < delta:
                            continue
                        let v = arcs[i].dst
                        let nd = d + arcs[i].cost + potential[u] - potential[v]
                        if not reached[v] or nd < distance[v]:
                            reached[v] = true
                            distance[v] = nd
                            parent[v] = i
                            queue.push((nd, v))
                if target < 0:
                    break
                for v in 0..<n:
                    potential[v] += (if reached[v]: min(distance[v], distance[target]) else: distance[target])
                var amount = -balance[target]
                var root = target
                while parent[root] >= 0:
                    let i = parent[root]
                    amount = min(amount, arcs[i].cap)
                    root = arcs[i xor 1].dst
                amount = min(amount, balance[root])
                amount -= amount mod delta
                var v = target
                while v != root:
                    let i = parent[v]
                    arcs[i].cap -= amount
                    arcs[i xor 1].cap += amount
                    v = arcs[i xor 1].dst
                balance[root] -= amount
                balance[target] += amount
            delta = delta div 2
        for b in balance:
            if b != 0:
                return
        # 全頂点を始点にBellman-Fordを行い、絶対値が(N-1)*max|cost|以下の双対解を返す。
        g.potential = newSeq[Int128](n)
        for phase in 0..<n:
            var changed = false
            for u in 0..<n:
                for i in graph[u]:
                    let v = arcs[i].dst
                    if arcs[i].cap > 0 and g.potential[v] > g.potential[u] + arcs[i].cost:
                        g.potential[v] = g.potential[u] + arcs[i].cost
                        changed = true
            if not changed:
                break
        result.feasible = true
        result.cost = 0
        for i in 0..<g.edges.len:
            let f = to_Int128(g.edges[i].lower) + arcs[2 * i + 1].cap
            g.edges[i].flow = bFlowInt64(f)
            result.cost += f * to_Int128(g.edges[i].cost)
        g.solved = true

    proc get_edge*(g: MinCostBFlow, i: int): MinCostBFlowEdge =
        ## solve成功後のi番目の元辺とその流量を返す。供給・辺の追加後は再計算が必要。O(1)。
        assert g.solved, "先にsolveで実現可能な流れを求めてください"
        g.edges[i]

    proc get_edges*(g: MinCostBFlow): seq[MinCostBFlowEdge] =
        ## solve成功後の元辺と流量を追加順に返す。O(M)。
        assert g.solved, "先にsolveで実現可能な流れを求めてください"
        for e in g.edges:
            result.add(e)

    proc get_potential*(g: MinCostBFlow): seq[Int128] =
        ## solve成功後の双対解pを返す。残余辺のcost+p[src]-p[dst] >= 0を満たす。O(N)。
        assert g.solved, "先にsolveで実現可能な流れを求めてください"
        for p in g.potential:
            result.add(p)
