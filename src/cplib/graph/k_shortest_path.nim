when not declared CPLIB_GRAPH_K_SHORTEST_PATH:
    const CPLIB_GRAPH_K_SHORTEST_PATH* = 1

    import cplib/graph/graph
    import std/[heapqueue, macros]

    proc k_shortest_path_impl[T](G: DynamicGraph[T] or StaticGraph[T], start, goal, k: int, ZERO: T): seq[T] =
        ## Returns the costs of the k shortest walks from `start` to `goal`.
        ##
        ## Edge costs must be non-negative. Walks are distinguished by their
        ## edge sequences, so parallel edges and walks containing cycles are
        ## counted separately. The returned costs are in ascending order; if
        ## fewer than k walks exist, the result is shorter than k.
        if k <= 0:
            return @[]

        var
            queue = initHeapQueue[(T, int)]()
            popped = newSeq[int](len(G))
        queue.push((ZERO, start))

        while queue.len > 0 and result.len < k:
            let (cost, v) = queue.pop()
            if popped[v] >= k:
                continue
            inc popped[v]

            if v == goal:
                result.add(cost)
                if result.len == k:
                    break

            for (to, edgeCost) in G.to_and_cost(v):
                if popped[to] < k:
                    queue.push((cost + edgeCost, to))

    macro declareKShortestPath(t, zero) =
        quote do:
            proc k_shortest_path*(G: DynamicGraph[`t`] or StaticGraph[`t`], start, goal, k: int, ZERO: `t` = `zero`): seq[`t`] =
                k_shortest_path_impl(G, start, goal, k, ZERO)

    declareKShortestPath(int, 0)
    declareKShortestPath(int32, 0i32)
    declareKShortestPath(float, 0.0)
    declareKShortestPath(float32, 0.0'f32)

    proc k_shortest_path*[T](G: DynamicGraph[T] or StaticGraph[T], start, goal, k: int, ZERO: T): seq[T] =
        k_shortest_path_impl(G, start, goal, k, ZERO)
