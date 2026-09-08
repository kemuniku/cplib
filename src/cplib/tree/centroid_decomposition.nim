when not declared CPLIB_TREE_CENTROID_DECOMPOSITION:
    const CPLIB_TREE_CENTROID_DECOMPOSITION* = 1
    import cplib/graph/graph

    type CentroidDecomposition* = ref object
        ## 頂点番号は元の木と共通。parent[root] = -1、depth[root] = 0。
        root*: int
        parent*, depth*: seq[int]
        children*: seq[seq[int]]

    proc initCentroidDecomposition*(g: UnDirectedGraph,
                                   root: int = 0): CentroidDecomposition =
        ## 無向木の重心分解木を O(N log N) 時間・O(N) 領域で構築する。
        ## root は探索開始点で、分解木の根とは限らない。辺の重みは使わない。
        ## 空の木では root = -1、各配列は空。静的グラフは事前に build する。
        let n = g.len
        result = CentroidDecomposition(root: -1,
            parent: newSeq[int](n), depth: newSeq[int](n),
            children: newSeq[seq[int]](n))
        if n == 0: return
        assert root in 0..<n
        var removed = newSeq[bool](n)
        var parent = newSeq[int](n)
        var size = newSeq[int](n)
        var largest = newSeq[int](n)
        var seen = newSeq[int](n)
        var stamp = 0
        var order: seq[int]
        var tasks = @[(root, -1)]
        while tasks.len > 0:
            let (start, decompositionParent) = tasks.pop()
            inc stamp
            order.setLen(0)
            order.add(start)
            parent[start] = -1
            seen[start] = stamp
            var index = 0
            while index < order.len:
                let u = order[index]
                inc index
                size[u] = 1
                largest[u] = 0
                for (v, _) in g.to_and_cost(u):
                    if removed[v] or v == parent[u]: continue
                    assert seen[v] != stamp, "入力は木である必要があります"
                    seen[v] = stamp
                    parent[v] = u
                    order.add(v)
            if decompositionParent == -1:
                assert order.len == n, "入力は連結な木である必要があります"
            var centroid = -1
            for i in countdown(order.len - 1, 0):
                let u = order[i]
                if max(largest[u], order.len - size[u]) <= order.len div 2:
                    centroid = u
                let p = parent[u]
                if p != -1:
                    size[p] += size[u]
                    largest[p] = max(largest[p], size[u])
            result.parent[centroid] = decompositionParent
            if decompositionParent == -1:
                result.root = centroid
            else:
                result.depth[centroid] = result.depth[decompositionParent] + 1
                result.children[decompositionParent].add(centroid)
            removed[centroid] = true
            for (v, _) in g.to_and_cost(centroid):
                if not removed[v]: tasks.add((v, centroid))
