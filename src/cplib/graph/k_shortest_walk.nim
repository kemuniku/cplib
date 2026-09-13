when not declared CPLIB_GRAPH_K_SHORTEST_WALK:
    const CPLIB_GRAPH_K_SHORTEST_WALK* = 1
    import cplib/graph/graph
    import cplib/utils/constants
    import heapqueue, algorithm

    type KShortestWalkHeapNode = object
        vertex, left, right, rank: int

    proc k_shortest_walk*[T: SomeSignedInt](G: DynamicGraph[T] or StaticGraph[T], s, t, k: int, INF: T): seq[T] =
        ## 非負整数重みのsからtへのウォーク長を昇順でk個返す。時間O((V+E)logV + k log k)、空間O(E+V logV+k)。
        ## 同長の別ウォークも数え、s == tでは空ウォークを含む。全ての中間計算がTに収まることを要求する。
        ## 不足分はINFで埋める。INFは返されるウォーク長より大きい値を指定する。StaticGraphは事前にbuildする。
        ## Eppstein法: https://www.ics.uci.edu/~eppstein/pubs/Epp-TR-94-26.pdf
        assert 0 <= s and s < G.len and 0 <= t and t < G.len
        assert k >= 0
        if k == 0: return @[]
        result = newSeq[T](k)
        result.fill(INF)
        let n = G.len
        var reverse = newSeq[seq[tuple[vertex: int, cost: T, edge: int]]](n)
        for u in 0..<n:
            var edge = 0
            for (v, cost) in G.to_and_cost(u):
                assert cost >= T(0)
                reverse[v].add((u, cost, edge))
                inc edge
        var
            dist = newSeq[T](n)
            reached = newSeq[bool](n)
            settled = newSeq[bool](n)
            parent = newSeq[int](n)
            treeEdge = newSeq[int](n)
            position = newSeq[int](n)
            heap: seq[int]
            order: seq[int]
        parent.fill(-1)
        treeEdge.fill(-1)
        position.fill(-1)

        proc siftUp(vertex: int) =
            ## 頂点を挿入またはdecrease-keyする。O(logV)。
            var i = position[vertex]
            if i == -1:
                i = heap.len
                heap.add(vertex)
            while i > 0:
                let p = (i - 1) div 2
                if dist[heap[p]] <= dist[vertex]: break
                heap[i] = heap[p]
                position[heap[i]] = i
                i = p
            heap[i] = vertex
            position[vertex] = i

        proc popVertex(): int =
            ## 最短距離の頂点を取り出す。O(logV)。
            result = heap[0]
            let last = heap.pop()
            position[result] = -1
            if heap.len == 0: return
            var i = 0
            while i * 2 + 1 < heap.len:
                var child = i * 2 + 1
                if child + 1 < heap.len and dist[heap[child + 1]] < dist[heap[child]]:
                    inc child
                if dist[last] <= dist[heap[child]]: break
                heap[i] = heap[child]
                position[heap[i]] = i
                i = child
            heap[i] = last
            position[last] = i

        reached[t] = true
        siftUp(t)
        while heap.len > 0:
            let v = popVertex()
            settled[v] = true
            order.add(v)
            for e in reverse[v]:
                let u = e.vertex
                if settled[u]: continue
                let candidate = dist[v] + e.cost
                if not reached[u] or candidate < dist[u]:
                    reached[u] = true
                    dist[u] = candidate
                    parent[u] = v
                    treeEdge[u] = e.edge
                    siftUp(u)
        if not reached[s]: return
        result[0] = dist[s]
        if k == 1: return

        var local = newSeq[seq[tuple[delta: T, dest: int]]](n)
        for u in order:
            var edge = 0
            for (v, cost) in G.to_and_cost(u):
                if reached[v] and edge != treeEdge[u]:
                    local[u].add((cost + dist[v] - dist[u], v))
                inc edge
            # 各頂点の非木辺を線形時間でヒープ化する。
            for start in countdown(local[u].len div 2 - 1, 0):
                var i = start
                let value = local[u][i]
                while i * 2 + 1 < local[u].len:
                    var child = i * 2 + 1
                    if child + 1 < local[u].len and local[u][child + 1].delta < local[u][child].delta:
                        inc child
                    if value.delta <= local[u][child].delta: break
                    local[u][i] = local[u][child]
                    i = child
                local[u][i] = value

        var nodes = @[KShortestWalkHeapNode()]
        var roots = newSeq[int](n)
        proc meld(a, b: int): int =
            ## 最小非木辺を持つ永続leftist heapを併合する。O(logV)。
            if a == 0: return b
            if b == 0: return a
            var x = a
            var y = b
            if local[nodes[y].vertex][0].delta < local[nodes[x].vertex][0].delta:
                swap(x, y)
            var node = nodes[x]
            node.right = meld(node.right, y)
            if nodes[node.left].rank < nodes[node.right].rank:
                swap(node.left, node.right)
            node.rank = nodes[node.right].rank + 1
            result = nodes.len
            nodes.add(node)

        # 確定順ならゼロ重み辺があっても親のヒープは構築済みになる。
        for u in order:
            if parent[u] != -1: roots[u] = roots[parent[u]]
            if local[u].len > 0:
                let node = nodes.len
                nodes.add(KShortestWalkHeapNode(vertex: u, rank: 1))
                roots[u] = meld(roots[u], node)

        var queue = initHeapQueue[tuple[cost: T, node, vertex, index: int]]()
        proc pushRoot(cost: T, root: int) =
            ## 次の非木辺を追加した候補を登録する。O(log k)。
            if root != 0:
                let u = nodes[root].vertex
                queue.push((cost + local[u][0].delta, root, u, 0))

        pushRoot(dist[s], roots[s])
        var count = 1
        while queue.len > 0 and count < k:
            let candidate = queue.pop()
            result[count] = candidate.cost
            inc count
            if count == k: break
            let u = candidate.vertex
            let i = candidate.index
            let edge = local[u][i]
            let base = candidate.cost - edge.delta
            if candidate.node != 0:
                pushRoot(base, nodes[candidate.node].left)
                pushRoot(base, nodes[candidate.node].right)
            for child in [i * 2 + 1, i * 2 + 2]:
                if child < local[u].len:
                    queue.push((base + local[u][child].delta, 0, u, child))
            pushRoot(candidate.cost, roots[edge.dest])

    proc k_shortest_walk*[T: SomeSignedInt](G: DynamicGraph[T] or StaticGraph[T], s, t, k: int): seq[T] =
        ## 不足分を64ビット型ではINF64、32ビット型ではINF32、それより小さい型ではhigh(T)で埋める。
        when sizeof(T) >= 8:
            G.k_shortest_walk(s, t, k, T(INF64))
        elif sizeof(T) >= 4:
            G.k_shortest_walk(s, t, k, T(INF32))
        else:
            G.k_shortest_walk(s, t, k, high(T))
