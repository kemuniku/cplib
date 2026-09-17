when not declared CPLIB_GRAPH_CYCLE_DETECTION:
    const CPLIB_GRAPH_CYCLE_DETECTION* = 1
    import cplib/graph/graph
    import sequtils

    proc restore_cycle_vertices*(g: DirectedGraph or UnDirectedGraph, edges: openArray[int]): seq[int] =
        ## 通過順の閉路の辺番号列から頂点列を復元する。O(L) 時間・領域。空列には空列を返す。
        ## 入力は cycle_detection の結果と同様に頂点・辺が重複しない閉路とする。
        ## edges[i] は結果の i 番目から (i+1) mod L 番目への辺。末尾に始点を重複させない。
        if edges.len == 0: return
        let first = g.get_edge(edges[0])
        var v = first.src
        when g is UnDirectedGraph:
            if edges.len > 1:
                let second = g.get_edge(edges[1])
                if first.dst != second.src and first.dst != second.dst:
                    v = first.dst
        result = newSeqOfCap[int](edges.len)
        for id in edges:
            result.add(v)
            let e = g.get_edge(id)
            when g is DirectedGraph:
                v = e.dst
            else:
                v = if e.src == v: e.dst else: e.src

    proc cycle_detection*(g: DirectedGraph or UnDirectedGraph): seq[int] =
        ## 閉路を一つ、通過順の辺番号列で返す。存在しなければ空列。O(V+E) 時間、O(V) 追加領域。
        ## 閉路内の頂点・辺は重複しない。各辺の端点は get_edge で取得できる。
        ## 自己ループ・多重辺に対応する非再帰 DFS。重みは無視し、静的グラフは build 済みとする。
        when g is StaticGraphTypes:
            g.static_graph_initialized_check()
        var state = newSeq[uint8](g.len)
        var next = newSeq[int](g.len)
        var parentEdge = newSeqWith(g.len, -1)
        var position = newSeq[int](g.len)
        var stack: seq[int]
        for root in 0..<g.len:
            if state[root] != 0: continue
            state[root] = 1
            stack.add(root)
            position[root] = 0
            while stack.len > 0:
                let v = stack[^1]
                when g is StaticGraphTypes:
                    let degree = int(g.start[v + 1] - g.start[v])
                else:
                    let degree = g.edges[v].len
                if next[v] == degree:
                    state[v] = 2
                    discard stack.pop()
                    continue
                when g is StaticGraphTypes:
                    let e = g.elist[int(g.start[v]) + next[v]]
                else:
                    let e = g.edges[v][next[v]]
                inc next[v]
                let to = e.dst.int
                let id = e.id.int
                when g is UnDirectedGraph:
                    if id == parentEdge[v]: continue
                if state[to] == 0:
                    parentEdge[to] = id
                    position[to] = stack.len
                    state[to] = 1
                    stack.add(to)
                elif state[to] == 1:
                    for i in position[to] + 1..<stack.len:
                        result.add(parentEdge[stack[i]])
                    result.add(id)
                    return
