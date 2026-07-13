when not declared CPLIB_GRAPH_K_SHORTEST_WALK:
    const CPLIB_GRAPH_K_SHORTEST_WALK* = 1

    import cplib/graph/graph
    import cplib/utils/constants
    import std/[heapqueue, sequtils]

    type
        KShortestWalkHeapNode[T] = object
            key: T
            to: int32
            left, right: int32
            rank: int32

    proc k_shortest_walk_impl[T](G: DynamicGraph[T] or StaticGraph[T],
            start, goal, k: int, ZERO, INF: T): seq[T] =
        ## Returns the costs of the first `k` walks from `start` to `goal`.
        ## Vertices and edges may be used more than once.  If fewer than `k`
        ## walks exist, the returned sequence is shorter than `k`.
        if k <= 0:
            return @[]

        let n = G.len
        var
            rev = newSeq[seq[(int32, T, int32)]](n)
            edges = newSeq[seq[(int32, T, int32)]](n)
            edgeId = 0'i32
        for u in 0..<n:
            for (v, w) in G.to_and_cost(u):
                edges[u].add((v.int32, w, edgeId))
                rev[v].add((u.int32, w, edgeId))
                inc edgeId

        # Shortest-path distances to goal and one shortest-path tree.
        var
            dist = newSeqWith(n, INF)
            treeEdge = newSeqWith(n, -1'i32)
            successor = newSeqWith(n, -1'i32)
            order = newSeqOfCap[int](n)
            dijkstraQueue = initHeapQueue[(T, int)]()
        dist[goal] = ZERO
        dijkstraQueue.push((ZERO, goal))
        while dijkstraQueue.len > 0:
            let (du, u) = dijkstraQueue.pop()
            if du != dist[u]:
                continue
            order.add(u)
            for (v32, w, id) in rev[u]:
                let v = v32.int
                let nd = du + w
                if nd < dist[v]:
                    dist[v] = nd
                    treeEdge[v] = id
                    successor[v] = u.int32
                    dijkstraQueue.push((nd, v))

        if dist[start] == INF:
            return @[]

        var heapNodes = @[KShortestWalkHeapNode[T](
            left: -1, right: -1, rank: 0)]

        proc rank(x: int32): int32 =
            if x < 0: 0 else: heapNodes[x].rank

        proc meld(a0, b0: int32): int32 =
            if a0 < 0: return b0
            if b0 < 0: return a0
            var (a, b) = (a0, b0)
            if heapNodes[b].key < heapNodes[a].key:
                swap(a, b)
            var node = heapNodes[a]
            node.right = meld(node.right, b)
            if rank(node.left) < rank(node.right):
                swap(node.left, node.right)
            node.rank = rank(node.right) + 1
            heapNodes.add(node)
            return (heapNodes.len - 1).int32

        proc singleton(key: T, to: int32): int32 =
            heapNodes.add(KShortestWalkHeapNode[T](
                key: key, to: to, left: -1, right: -1, rank: 1))
            return (heapNodes.len - 1).int32

        # sidetrackHeap[v] contains all sidetracks available while following
        # the shortest-path tree from v towards goal.
        var sidetrackHeap = newSeqWith(n, -1'i32)
        for u in order:
            var root = -1'i32
            for (v32, w, id) in edges[u]:
                let v = v32.int
                if dist[v] == INF or id == treeEdge[u]:
                    continue
                let delta = w + dist[v] - dist[u]
                root = meld(root, singleton(delta, v32))
            if successor[u] >= 0:
                root = meld(root, sidetrackHeap[successor[u]])
            sidetrackHeap[u] = root

        result = newSeqOfCap[T](k)
        result.add(dist[start])
        var candidates = initHeapQueue[(T, int32)]()
        if sidetrackHeap[start] >= 0:
            let h = sidetrackHeap[start]
            candidates.push((dist[start] + heapNodes[h].key, h))
        while result.len < k and candidates.len > 0:
            let (cost, h) = candidates.pop()
            result.add(cost)
            let node = heapNodes[h]
            for child in [node.left, node.right]:
                if child >= 0:
                    candidates.push((cost - node.key + heapNodes[child].key, child))
            let next = sidetrackHeap[node.to]
            if next >= 0:
                candidates.push((cost + heapNodes[next].key, next))

    proc k_shortest_walk*(G: DynamicGraph[int] or StaticGraph[int],
            start, goal, k: int, ZERO: int = 0, INF: int = INF64): seq[int] =
        k_shortest_walk_impl(G, start, goal, k, ZERO, INF)

    proc k_shortest_walk*(G: DynamicGraph[int32] or StaticGraph[int32],
            start, goal, k: int, ZERO: int32 = 0'i32,
            INF: int32 = INF32): seq[int32] =
        k_shortest_walk_impl(G, start, goal, k, ZERO, INF)

    proc k_shortest_walk*[T](G: DynamicGraph[T] or StaticGraph[T],
            start, goal, k: int, ZERO, INF: T): seq[T] =
        k_shortest_walk_impl(G, start, goal, k, ZERO, INF)
