when not declared CPLIB_GRAPH_LOWLINK:
    const CPLIB_GRAPH_LOWLINK* = 1
    import cplib/graph/graph
    import sequtils

    type LowLink* = object
        ord*, low*, parent*: seq[int]
        preorder*, postorder*: seq[int]
        articulation*: seq[int]
        is_articulation*: seq[bool]
        bridges*: seq[(int, int)]

    proc initLowLink*(g: UnDirectedGraph): LowLink =
        ## 無向グラフのlowlink・関節点・橋をO(V+E)時間・領域で求めます。静的グラフはbuild済みとします。
        ## 多重辺・自己ループに対応し、橋は(親, 子)で返します。DFSは非再帰です。
        let n = g.len
        result.ord = newSeqWith(n, -1)
        result.low = newSeq[int](n)
        result.parent = newSeqWith(n, -1)
        result.is_articulation = newSeq[bool](n)
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        var next = newSeq[int](n)
        var children = newSeq[int](n)
        var skippedParent = newSeq[bool](n)
        var stack: seq[int]
        for root in 0..<n:
            if result.ord[root] != -1: continue
            result.ord[root] = result.preorder.len
            result.low[root] = result.ord[root]
            result.preorder.add(root)
            stack.add(root)
            while stack.len > 0:
                let v = stack[^1]
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
                    if to == result.parent[v] and not skippedParent[v]:
                        skippedParent[v] = true
                        continue
                    if result.ord[to] == -1:
                        result.parent[to] = v
                        inc children[v]
                        result.ord[to] = result.preorder.len
                        result.low[to] = result.ord[to]
                        result.preorder.add(to)
                        stack.add(to)
                    else:
                        result.low[v] = min(result.low[v], result.ord[to])
                else:
                    discard stack.pop()
                    result.postorder.add(v)
                    let p = result.parent[v]
                    if p == -1:
                        result.is_articulation[v] = children[v] > 1
                    else:
                        result.low[p] = min(result.low[p], result.low[v])
                        if result.low[v] > result.ord[p]:
                            result.bridges.add((p, v))
                        if result.parent[p] != -1 and result.low[v] >= result.ord[p]:
                            result.is_articulation[p] = true
        for v in 0..<n:
            if result.is_articulation[v]: result.articulation.add(v)
