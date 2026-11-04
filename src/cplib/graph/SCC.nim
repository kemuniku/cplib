when not declared CPLIB_GRAPH_SCC:
    const CPLIB_GRAPH_SCC* = 1
    import cplib/graph/graph
    import sequtils, algorithm
    proc SCC*(G: UnweightedDirectedGraph or UnWeightedDirectedStaticGraph): seq[seq[int]] =
        ## 強連結成分をトポロジカル順にO(V+E)時間・O(V)補助領域で返します。DFSは非再帰です。
        ## 成分内の頂点順と、互いに到達できない成分間の順序は保証しません。
        let n = G.len
        when G is StaticGraphTypes: G.static_graph_initialized_check()
        var ord = newSeqWith(n, -1)
        var low = newSeq[int](n)
        var parent = newSeqWith(n, -1)
        var next = newSeq[int](n)
        var pending: seq[int]
        var timer = 0
        for root in 0..<n:
            if ord[root] != -1: continue
            var v = root
            ord[v] = timer
            low[v] = timer
            inc timer
            pending.add(v)
            while v != -1:
                when G is StaticGraphTypes:
                    let degree = int(G.start[v+1] - G.start[v])
                else:
                    let degree = G.edges[v].len
                if next[v] < degree:
                    when G is StaticGraphTypes:
                        let to = G.elist[int(G.start[v]) + next[v]][0].int
                    else:
                        let to = G.edges[v][next[v]][0].int
                    inc next[v]
                    if ord[to] == -1:
                        parent[to] = v
                        ord[to] = timer
                        low[to] = timer
                        inc timer
                        pending.add(to)
                        v = to
                    else:
                        low[v] = min(low[v], ord[to])
                else:
                    let p = parent[v]
                    if p != -1: low[p] = min(low[p], low[v])
                    if low[v] == ord[v]:
                        var first = pending.len - 1
                        while pending[first] != v: dec first
                        var group = newSeq[int](pending.len - first)
                        for i in 0..<group.len:
                            let u = pending[pending.len-1-i]
                            group[i] = u
                            ord[u] = n
                        pending.setLen(first)
                        result.add(move(group))
                    v = p
        reverse(result)
    proc SCCG*[UG](G: UG): (UG, seq[int], seq[seq[int]]) =
        ##強連結成分分解をします。
        ##結果を、(頂点をまとめたグラフ,元の頂点→新頂点への対応,新頂点に含まれる頂点一覧)で返します。
        when UG isnot UnWeightedDirectedGraph and UG isnot UnWeightedDirectedStaticGraph:
            raise newException(Exception, "Type must be UnweightedDirectedGraph or UnweightedDirectedStaticGraph")
        var group = SCC(G)
        var i_to_group = newSeqWith(len(G), -1)
        for i in 0..<len(group):
            for j in group[i]:
                i_to_group[j] = i
        proc initUG[UG](N: int): UG =
            when UG is UnWeightedDirectedGraph: result = initUnWeightedDirectedGraph(N)
            when UG is UnWeightedDirectedStaticGraph: result = initUnWeightedDirectedStaticGraph(N)
        var newG = initUG[UG](len(group))
        for i in 0..<len(G):
            for j in G[i]:
                if i_to_group[i] != i_to_group[j]:
                    newG.add_edge(i_to_group[i], i_to_group[j])
        when UG is UnWeightedDirectedStaticGraph: newG.build
        return (newG, i_to_group, group)
