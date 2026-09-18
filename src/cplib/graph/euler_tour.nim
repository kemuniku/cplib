when not declared CPLIB_GRAPH_EULER_TOUR:
    const CPLIB_GRAPH_EULER_TOUR* = 1
    import cplib/graph/graph
    import algorithm

    proc euler_walk(g: DirectedGraph or UnDirectedGraph, start: int, closed: bool): seq[int] =
        ## 次数条件を確認し、非再帰の Hierholzer 法で全辺を一度ずつ通る。O(V+E) 時間・領域。
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        assert start >= -1 and (start == -1 or start < g.len), "始点が範囲外です"
        if g.edge_count == 0: return
        var degree = newSeq[int](g.len)
        for e in g.edge_info:
            inc degree[e.src]
            when g is DirectedGraph:
                dec degree[e.dst]
            else:
                inc degree[e.dst]
        var requiredStart = -1
        var endpoints = 0
        for v in 0..<g.len:
            when g is DirectedGraph:
                if degree[v] == 1:
                    if requiredStart != -1: return
                    requiredStart = v
                elif degree[v] == -1:
                    inc endpoints
                elif degree[v] != 0:
                    return
            else:
                if degree[v] mod 2 != 0:
                    if requiredStart == -1: requiredStart = v
                    inc endpoints
        when g is DirectedGraph:
            if endpoints != ord(requiredStart != -1): return
        else:
            if endpoints != 0 and endpoints != 2: return
        if closed and requiredStart != -1: return
        var root = start
        if root == -1:
            root = if requiredStart != -1: requiredStart else: g.edge_info[0].src
        elif requiredStart != -1:
            when g is DirectedGraph:
                if root != requiredStart: return
            else:
                if degree[root] mod 2 == 0: return
        var next = newSeq[int](g.len)
        var used = newSeq[bool](g.edge_count)
        var vertices = @[root]
        var incoming = @[-1]
        result = newSeqOfCap[int](g.edge_count)
        while vertices.len > 0:
            let v = vertices[^1]
            when g is StaticGraphTypes:
                let count = int(g.start[v + 1] - g.start[v])
            else:
                let count = g.edges[v].len
            if next[v] == count:
                discard vertices.pop()
                let id = incoming.pop()
                if id != -1: result.add(id)
                continue
            when g is StaticGraphTypes:
                let e = g.elist[int(g.start[v]) + next[v]]
            else:
                let e = g.edges[v][next[v]]
            inc next[v]
            if used[e.id]: continue
            used[e.id] = true
            vertices.add(e.dst.int)
            incoming.add(e.id.int)
        if result.len != g.edge_count:
            result.setLen(0)
        else:
            result.reverse()

    proc euler_tour*(g: DirectedGraph or UnDirectedGraph, start: int = -1): seq[int] =
        ## 全辺を一度ずつ通り始点に戻る閉路を、通過順の辺番号列で返す。O(V+E) 時間・領域。
        ## start = -1 なら始点を自動選択する。指定した始点から存在しなければ空列。辺がない場合も空列。
        ## 辺番号は add_edge の戻り値。無向辺はどちら向きにも通れる。孤立点は無視する。
        ## 自己ループ・多重辺に対応し、重みは無視する。静的グラフは build 済みとする。グラフは変更しない。
        euler_walk(g, start, true)

    proc euler_trail*(g: DirectedGraph or UnDirectedGraph, start: int = -1): seq[int] =
        ## 全辺を一度ずつ通る経路を、通過順の辺番号列で返す。始点と終点は異なってもよい。O(V+E) 時間・領域。
        ## start = -1 なら始点を自動選択する。指定した始点から存在しなければ空列。辺がない場合も空列。
        ## 辺番号・対応グラフ・非破壊性は euler_tour と同じ。
        euler_walk(g, start, false)
