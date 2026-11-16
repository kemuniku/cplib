when not declared CPLIB_GRAPH_IS_DFS_PREORDER:
    const CPLIB_GRAPH_IS_DFS_PREORDER* = 1
    import cplib/graph/graph
    import algorithm

    proc is_dfs_preorder*(g: DirectedGraph or UnDirectedGraph,
                         order: openArray[int], forest: bool = false): bool =
        ## order が隣接辺の走査順を選んで実現できる DFS 発見順か判定する。時間 O(N+A+Σdeg log deg)、追加領域 O(N+A)。
        ## 単一 DFS の根は order[0]。forest=true では未訪問の頂点を order 順に次の根とする。空順列は空グラフでのみ true。
        ## order は全頂点の順列とし、欠落・重複・範囲外は false。重みは無視し、入力を変更しない。静的グラフは build が必要。
        let n = g.len
        if order.len != n: return false
        var rank = newSeq[int](n)
        var seen = newSeq[bool](n)
        for i, v in order:
            if v < 0 or v >= n or seen[v]: return false
            seen[v] = true
            rank[v] = i
        when g is StaticGraphTypes:
            if g.start.len == 0:
                raise newException(ValueError, "静的グラフは build が必要です")
        var adjacent = newSeq[seq[int]](n)
        for v in 0..<n:
            for (dst, _) in g.to_and_id(v):
                adjacent[rank[v]].add(rank[dst])
            adjacent[rank[v]].sort()
        var visited = newSeq[bool](n)
        var next = newSeq[int](n)
        var stack: seq[int]
        var discovered = 0
        for root in 0..<n:
            if visited[root]: continue
            if root != 0 and not forest: return false
            visited[root] = true
            inc discovered
            stack.add(root)
            while stack.len > 0:
                let v = stack[^1]
                if next[v] == adjacent[v].len:
                    discard stack.pop()
                    continue
                let dst = adjacent[v][next[v]]
                inc next[v]
                if visited[dst]: continue
                if dst != discovered: return false
                visited[dst] = true
                inc discovered
                stack.add(dst)
        return true
