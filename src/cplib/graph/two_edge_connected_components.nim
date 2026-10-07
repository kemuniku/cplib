when not declared CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS:
    const CPLIB_GRAPH_TWO_EDGE_CONNECTED_COMPONENTS* = 1
    import cplib/graph/graph
    import cplib/graph/lowlink

    type TwoEdgeConnectedComponents* = object
        groups*: seq[seq[int]]
        component*: seq[int]
        forest*: UnWeightedUnDirectedGraph

    proc initTwoEdgeConnectedComponents*(ll: LowLink): TwoEdgeConnectedComponents =
        ## 計算済みlowlinkから二重辺連結成分と橋で結ばれた縮約森をO(V)で構築します。
        result.component = newSeq[int](ll.ord.len)
        for v in ll.preorder:
            let p = ll.parent[v]
            if p == -1 or ll.low[v] > ll.ord[p]:
                result.component[v] = result.groups.len
                result.groups.add(@[v])
            else:
                result.component[v] = result.component[p]
                result.groups[result.component[v]].add(v)
        result.forest = initUnWeightedUnDirectedGraph(result.groups.len)
        for (u, v) in ll.bridges:
            result.forest.add_edge(result.component[u], result.component[v])

    proc initTwoEdgeConnectedComponents*(g: UnDirectedGraph): TwoEdgeConnectedComponents =
        ## 無向グラフをO(V+E)時間・領域で二重辺連結成分に分解します。DFSは非再帰です。
        let n = g.len
        when g is StaticGraphTypes: g.static_graph_initialized_check()
        var ord = newSeq[int](n)
        for i in 0..<n: ord[i] = -1
        var low = newSeq[int](n)
        var parent = newSeq[int](n)
        for i in 0..<n: parent[i] = -1
        var next = newSeq[int](n)
        var skippedParent = newSeq[bool](n)
        var preorder: seq[int]
        var bridges: seq[(int, int)]
        for root in 0..<n:
            if ord[root] != -1: continue
            var v = root
            ord[v] = preorder.len
            low[v] = ord[v]
            preorder.add(v)
            while v != -1:
                when g is StaticGraphTypes:
                    let degree = int(g.start[v+1] - g.start[v])
                else:
                    let degree = g.edges[v].len
                if next[v] < degree:
                    when g is StaticGraphTypes:
                        let to = g.elist[int(g.start[v]) + next[v]][0].int
                    else:
                        let to = g.edges[v][next[v]][0].int
                    inc next[v]
                    if to == parent[v] and not skippedParent[v]:
                        skippedParent[v] = true
                        continue
                    if ord[to] == -1:
                        parent[to] = v
                        ord[to] = preorder.len
                        low[to] = ord[to]
                        preorder.add(to)
                        v = to
                    else:
                        low[v] = min(low[v], ord[to])
                else:
                    let p = parent[v]
                    if p != -1:
                        low[p] = min(low[p], low[v])
                        if low[v] > ord[p]: bridges.add((p, v))
                    v = p
        result.component = newSeq[int](n)
        for v in preorder:
            let p = parent[v]
            if p == -1 or low[v] > ord[p]:
                result.component[v] = result.groups.len
                result.groups.add(@[v])
            else:
                result.component[v] = result.component[p]
                result.groups[result.component[v]].add(v)
        result.forest = initUnWeightedUnDirectedGraph(result.groups.len)
        for (u, v) in bridges:
            result.forest.add_edge(result.component[u], result.component[v])
