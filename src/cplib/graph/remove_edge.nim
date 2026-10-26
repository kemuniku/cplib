when not declared CPLIB_GRAPH_REMOVE_EDGE:
    const CPLIB_GRAPH_REMOVE_EDGE* = 1
    import cplib/graph/graph

    proc remove_edge*[G: DynamicGraphTypes or StaticGraphTypes](g: G, id: int): G =
        ## 辺番号 id の一辺を除いた新しいグラフを返す。時間・空間 O(V + E)。
        ## 元は変更せず、残る辺は追加順に 0 から採番する。静的グラフは構築済みで返す。
        if id < 0 or id >= g.edge_count:
            raise newException(ValueError, "辺番号は 0 以上、辺数未満で指定してください")
        new(result)
        result.len = g.len
        when G is DynamicGraphTypes:
            result.edges.setLen(g.len)
        for edgeId, e in g.edge_info:
            if edgeId == id: continue
            when G is UnWeightedGraph:
                result.add_edge(e.src, e.dst)
            else:
                result.add_edge(e.src, e.dst, e.cost)
        when G is StaticGraphTypes:
            result.build()

    iterator remove_each_edge*[G: DynamicGraphTypes or StaticGraphTypes](g: G): G =
        ## 各辺を一本ずつ除いた新しいグラフを辺番号順に列挙する。一件 O(V + E)、同型の重複は除かない。
        for id in 0..<g.edge_count:
            yield g.remove_edge(id)
