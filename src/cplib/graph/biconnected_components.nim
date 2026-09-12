when not declared CPLIB_GRAPH_BICONNECTED_COMPONENTS:
    const CPLIB_GRAPH_BICONNECTED_COMPONENTS* = 1
    import cplib/graph/graph
    import cplib/graph/lowlink
    import sequtils

    type BiconnectedComponents* = object
        groups*: seq[seq[int]]
        belong*: seq[seq[int]]
        articulation*: seq[int]

    proc initBiconnectedComponents*(ll: LowLink): BiconnectedComponents =
        ## 計算済みlowlinkから二重頂点連結成分の頂点集合をO(V)で求めます。
        ## 橋の両端も一成分とし、自己ループは無視します。孤立点は単独の成分です。
        result.articulation = ll.articulation
        result.belong = newSeq[seq[int]](ll.ord.len)
        # 未確定の頂点を帰りがけ順に積み、成分の境界で子孫をまとめて取り出します。
        var pending: seq[int]
        for v in ll.postorder:
            let p = ll.parent[v]
            var group: seq[int]
            if p == -1:
                if result.belong[v].len == 0: group.add(v)
            elif ll.low[v] >= ll.ord[p]:
                while pending.len > 0 and ll.ord[pending[^1]] > ll.ord[v]:
                    group.add(pending.pop())
                group.add(v)
                group.add(p)
            else:
                pending.add(v)
            if group.len > 0:
                let id = result.groups.len
                for u in group: result.belong[u].add(id)
                result.groups.add(group)

    proc initBiconnectedComponents*(g: UnDirectedGraph): BiconnectedComponents =
        ## 無向グラフをO(V+E)時間・領域で二重頂点連結成分に分解します。
        ## 静的グラフはbuild済みとします。自己ループは無視し、DFSは非再帰です。
        let n = g.len
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        result.belong = newSeq[seq[int]](n)
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
            while v != -1:
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
                    if ord[to] == -1:
                        parent[to] = v
                        ord[to] = timer
                        low[to] = timer
                        inc timer
                        v = to
                    else:
                        # 親への辺も含めてよい。成分境界の >= 判定には影響しません。
                        low[v] = min(low[v], ord[to])
                else:
                    let p = parent[v]
                    var group: seq[int]
                    if p == -1:
                        if result.belong[v].len == 0: group = @[v]
                    else:
                        low[p] = min(low[p], low[v])
                        if low[v] >= ord[p]:
                            var first = pending.len
                            while first > 0 and ord[pending[first-1]] > ord[v]: dec first
                            let size = pending.len - first
                            group = newSeq[int](size + 2)
                            for i in 0..<size: group[i] = pending[pending.len-1-i]
                            pending.setLen(first)
                            group[size] = v
                            group[size+1] = p
                        else:
                            pending.add(v)
                    if group.len > 0:
                        let id = result.groups.len
                        for u in group: result.belong[u].add(id)
                        result.groups.add(move(group))
                    v = p
        for v in 0..<n:
            if result.belong[v].len > 1: result.articulation.add(v)
