when not declared CPLIB_GRAPH_BICONNECTED_COMPONENTS:
    const CPLIB_GRAPH_BICONNECTED_COMPONENTS* = 1
    import cplib/graph/graph
    import cplib/graph/lowlink

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
        result = initBiconnectedComponents(initLowLink(g))
