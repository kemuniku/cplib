when not declared CPLIB_GRAPH_DOMINATOR_TREE:
    const CPLIB_GRAPH_DOMINATOR_TREE* = 1
    import cplib/graph/graph
    import sequtils

    proc dominator_tree*(g: DirectedGraph or seq[seq[int]], root: int): seq[int] =
        ## 各頂点の直近支配頂点を返す。根は自身、根から到達不能な頂点は-1。根は有効な頂点とする。
        ## Lengauer-Tarjan法でO((V+E)log V)時間、O(V+E)領域。DFS・経路圧縮ともに非再帰。
        ## 自己ループ・多重辺に対応する。重みは無視し、静的グラフはbuild済みとする。
        let n = g.len
        assert root in 0..<n, "根の頂点番号が範囲外です"
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        var order = newSeqWith(n, -1)
        var vertex = newSeqOfCap[int](n)
        var parent = newSeq[int](n)
        var next = newSeq[int](n)
        var pred = newSeq[seq[int]](n)
        var stack = newSeqOfCap[int](n)
        order[root] = 0
        vertex.add(root)
        stack.add(root)
        while stack.len > 0:
            let v = stack[^1]
            when g is StaticGraphTypes:
                let degree = int(g.start[v + 1] - g.start[v])
            elif g is DirectedGraph:
                let degree = g.edges[v].len
            else:
                let degree = g[v].len
            if next[v] == degree:
                discard stack.pop()
                continue
            when g is StaticGraphTypes:
                let to = g.elist[int(g.start[v]) + next[v]].dst.int
            elif g is DirectedGraph:
                let to = g.edges[v][next[v]].dst.int
            else:
                let to = g[v][next[v]]
            inc next[v]
            assert to in 0..<n, "辺の端点が範囲外です"
            pred[to].add(v)
            if order[to] == -1:
                order[to] = vertex.len
                parent[vertex.len] = order[v]
                vertex.add(to)
                stack.add(to)

        # 以降の配列は到達可能な頂点のDFS順で添字を付ける。
        let reachable = vertex.len
        var semi = newSeq[int](reachable)
        var label = newSeq[int](reachable)
        var ancestor = newSeqWith(reachable, -1)
        var idom = newSeq[int](reachable)
        var bucketHead = newSeqWith(reachable, -1)
        var bucketNext = newSeq[int](reachable)
        for i in 0..<reachable:
            semi[i] = i
            label[i] = i

        proc eval(v: int): int =
            ## 連結済み祖先への経路上でsemiが最小の頂点を、経路圧縮しながら返す。
            var x = v
            while ancestor[x] != -1 and ancestor[ancestor[x]] != -1:
                stack.add(x)
                x = ancestor[x]
            while stack.len > 0:
                let u = stack.pop()
                let p = ancestor[u]
                if semi[label[p]] < semi[label[u]]:
                    label[u] = label[p]
                ancestor[u] = ancestor[p]
            return label[v]

        for w in countdown(reachable - 1, 1):
            for v in pred[vertex[w]]:
                semi[w] = min(semi[w], semi[eval(order[v])])
            bucketNext[w] = bucketHead[semi[w]]
            bucketHead[semi[w]] = w
            let p = parent[w]
            ancestor[w] = p
            var v = bucketHead[p]
            while v != -1:
                let u = eval(v)
                idom[v] = if semi[u] < semi[v]: u else: p
                v = bucketNext[v]
            bucketHead[p] = -1
        for w in 1..<reachable:
            if idom[w] != semi[w]:
                idom[w] = idom[idom[w]]

        result = newSeqWith(n, -1)
        result[root] = root
        for w in 1..<reachable:
            result[vertex[w]] = vertex[idom[w]]
