when not declared CPLIB_GRAPH_DOMINATOR_TREE:
    const CPLIB_GRAPH_DOMINATOR_TREE* = 1

    import cplib/graph/graph

    proc dominator_tree*(G: DirectedGraph, root: int): seq[int] =
        ## `root` を始点とするグラフの各頂点の immediate dominator を返します。
        ## `root` 自身の値は `root`、`root` から到達不能な頂点の値は -1 です。
        ## 計算量は O((V + E) log V) です。
        let n = G.len
        assert root in 0..<n
        result = newSeq[int](n)
        for v in 0..<n:
            result[v] = -1

        # DFS 中に iterator の状態を保持できるよう、行き先だけを取り出す。
        var adj = newSeq[seq[int]](n)
        for v in 0..<n:
            for (to, _) in G.to_and_cost(v):
                adj[v].add(to)

        var dfn = newSeq[int](n)
        for v in 0..<n:
            dfn[v] = -1
        var vertex: seq[int]
        var parent: seq[int] = @[-1]
        dfn[root] = 0
        vertex.add(root)

        var stack = @[(root, 0)]
        while stack.len > 0:
            let v = stack[^1][0]
            let edgeIndex = stack[^1][1]
            if edgeIndex == adj[v].len:
                discard stack.pop()
                continue
            stack[^1][1] += 1
            let to = adj[v][edgeIndex]
            if dfn[to] == -1:
                dfn[to] = vertex.len
                vertex.add(to)
                parent.add(dfn[v])
                stack.add((to, 0))

        let reachable = vertex.len
        var pred = newSeq[seq[int]](reachable)
        for v in vertex:
            for to in adj[v]:
                if dfn[to] != -1:
                    pred[dfn[to]].add(dfn[v])

        var semi = newSeq[int](reachable)
        var label = newSeq[int](reachable)
        var ancestor = newSeq[int](reachable)
        var idom = newSeq[int](reachable)
        var bucket = newSeq[seq[int]](reachable)
        for i in 0..<reachable:
            semi[i] = i
            label[i] = i
            ancestor[i] = -1
            idom[i] = -1

        proc eval(v: int): int =
            if ancestor[v] == -1:
                return label[v]

            var path: seq[int]
            var x = v
            while ancestor[x] != -1 and ancestor[ancestor[x]] != -1:
                path.add(x)
                x = ancestor[x]
            for i in countdown(path.len - 1, 0):
                let y = path[i]
                if semi[label[ancestor[y]]] < semi[label[y]]:
                    label[y] = label[ancestor[y]]
                ancestor[y] = ancestor[ancestor[y]]
            return label[v]

        for w in countdown(reachable - 1, 1):
            for v in pred[w]:
                semi[w] = min(semi[w], semi[eval(v)])
            bucket[semi[w]].add(w)
            ancestor[w] = parent[w]
            for v in bucket[parent[w]]:
                let u = eval(v)
                if semi[u] < semi[v]:
                    idom[v] = u
                else:
                    idom[v] = parent[w]
            bucket[parent[w]].setLen(0)

        for w in 1..<reachable:
            if idom[w] != semi[w]:
                idom[w] = idom[idom[w]]

        result[root] = root
        for i in 1..<reachable:
            result[vertex[i]] = vertex[idom[i]]
