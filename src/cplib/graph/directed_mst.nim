when not declared CPLIB_GRAPH_DIRECTED_MST:
    const CPLIB_GRAPH_DIRECTED_MST* = 1
    import cplib/graph/graph
    import cplib/math/int128
    import options

    when sizeof(int) != 8:
        {.error: "directedMSTは64ビット環境が必要です".}

    type DirectedMSTResult* = object
        cost*: int64
        inEdge*: seq[int]

    type DirectedMSTHeapNode = object
        key, lazy: Int128
        left, right, rank, edge: int

    proc directedMSTHeapAdd(nodes: var seq[DirectedMSTHeapNode], h: int, delta: Int128) =
        ## ヒープ全体へ重み差を加える。O(1)。
        if h >= 0:
            nodes[h].key += delta
            nodes[h].lazy += delta

    proc directedMSTHeapMeld(nodes: var seq[DirectedMSTHeapNode], a, b: int): int =
        ## 遅延加算付き左偏ヒープを併合する。O(log E)。
        if a < 0: return b
        if b < 0: return a
        var a = a
        var b = b
        if nodes[a].key > nodes[b].key or
                (nodes[a].key == nodes[b].key and nodes[a].edge > nodes[b].edge):
            swap(a, b)
        directedMSTHeapAdd(nodes, nodes[a].left, nodes[a].lazy)
        directedMSTHeapAdd(nodes, nodes[a].right, nodes[a].lazy)
        nodes[a].lazy = 0
        nodes[a].right = directedMSTHeapMeld(nodes, nodes[a].right, b)
        let lrank = if nodes[a].left < 0: 0 else: nodes[nodes[a].left].rank
        let rrank = if nodes[a].right < 0: 0 else: nodes[nodes[a].right].rank
        if lrank < rrank: swap(nodes[a].left, nodes[a].right)
        nodes[a].rank = (if nodes[a].right < 0: 0 else: nodes[nodes[a].right].rank) + 1
        return a

    proc directedMSTHeapPop(nodes: var seq[DirectedMSTHeapNode], h: int): int =
        ## 最小要素を除去する。O(log E)。
        directedMSTHeapAdd(nodes, nodes[h].left, nodes[h].lazy)
        directedMSTHeapAdd(nodes, nodes[h].right, nodes[h].lazy)
        directedMSTHeapMeld(nodes, nodes[h].left, nodes[h].right)

    proc directedMSTFind(parent: var seq[int], v: int): int =
        ## 縮約後の代表を反復的に求め、経路圧縮する。
        result = v
        while parent[result] >= 0: result = parent[result]
        var v = v
        while parent[v] >= 0:
            let next = parent[v]
            parent[v] = result
            v = next

    proc directedMST*[T: SomeSignedInt](g: WeightedDirectedGraph[T] or
            WeightedDirectedStaticGraph[T], root: int): Option[DirectedMSTResult] =
        ## 根から全頂点へ届く最小有向全域木のコストと各頂点への辺IDを返す。O((V+E) log(V+E))。
        let n = g.len
        if n <= 0 or root < 0 or root >= n:
            raise newException(ValueError, "非空グラフと有効な根が必要です")
        if n > high(int32).int div 2:
            raise newException(ValueError, "頂点数が対応範囲を超えています")
        var nodes = newSeqOfCap[DirectedMSTHeapNode](g.edge_info.len)
        var heap: seq[int] = newSeq[int](2 * n)
        var parent = newSeq[int](2 * n)
        var contractionParent = newSeq[int](2 * n)
        var chosen = newSeq[int](2 * n)
        var seen = newSeq[int](2 * n)
        for v in 0..<2 * n:
            heap[v] = -1
            parent[v] = -1
            contractionParent[v] = -1
            chosen[v] = -1
        for id, e in g.edge_info:
            if e.src < 0 or e.src >= n or e.dst < 0 or e.dst >= n:
                raise newException(ValueError, "辺の端点が範囲外です")
            if e.dst == root or e.src == e.dst: continue
            let h = nodes.len
            nodes.add(DirectedMSTHeapNode(key: to_Int128(e.cost), lazy: to_Int128(0),
                left: -1, right: -1, rank: 1, edge: id))
            heap[e.dst] = directedMSTHeapMeld(nodes, heap[e.dst], h)
        seen[root] = -1
        var count = n
        for start in 0..<n:
            var v = directedMSTFind(parent, start)
            let stamp = start + 1
            while seen[v] == 0 or seen[v] == stamp:
                if seen[v] == stamp:
                    var cycle: seq[int]
                    var u = v
                    while true:
                        cycle.add(u)
                        u = directedMSTFind(parent, g.edge_info[chosen[u]].src)
                        if u == v: break
                    let contracted = count
                    inc count
                    for u in cycle:
                        heap[contracted] = directedMSTHeapMeld(nodes, heap[contracted], heap[u])
                        parent[u] = contracted
                        contractionParent[u] = contracted
                    v = contracted
                seen[v] = stamp
                while heap[v] != -1:
                    let id = nodes[heap[v]].edge
                    if directedMSTFind(parent, g.edge_info[id].src) != v: break
                    heap[v] = directedMSTHeapPop(nodes, heap[v])
                if heap[v] == -1: return none(DirectedMSTResult)
                let h = heap[v]
                chosen[v] = nodes[h].edge
                let weight = nodes[h].key
                heap[v] = directedMSTHeapPop(nodes, h)
                directedMSTHeapAdd(nodes, heap[v], -weight)
                v = directedMSTFind(parent, g.edge_info[chosen[v]].src)
        var answer = DirectedMSTResult(inEdge: newSeq[int](n))
        for v in 0..<n: answer.inEdge[v] = -1
        var expanded = newSeq[bool](count)
        var total = to_Int128(0)
        for v in countdown(count - 1, 0):
            if v == root or expanded[v]: continue
            let id = chosen[v]
            let e = g.edge_info[id]
            answer.inEdge[e.dst] = id
            total += to_Int128(e.cost)
            var u = e.dst
            while u >= 0 and not expanded[u]:
                expanded[u] = true
                u = contractionParent[u]
        if total < to_Int128(low(int64)) or total > to_Int128(high(int64)):
            raise newException(OverflowDefect, "最小有向全域木のコストがint64の範囲を超えています")
        answer.cost = int64(total.to_int())
        some(answer)
