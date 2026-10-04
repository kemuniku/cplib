when not declared CPLIB_TREE_TREE_CENTROIDS:
    const CPLIB_TREE_TREE_CENTROIDS* = 1
    import cplib/graph/graph

    proc tree_centroids*(g: UnDirectedGraph): seq[int] =
        ## 無向連結木の全重心を頂点番号の昇順で返す。時間・追加領域 O(N)。
        ## 頂点を除いた各連結成分の頂点数が N div 2 以下なら重心で、非空木では 1 個または 2 個。
        ## 空木は空列、単点は @[0]。辺の重みは無視し、入力は変更しない。
        ## 非空の静的グラフは事前に build する。閉路・多重辺・非連結の入力は対象外。
        ## 反復走査の逆順で部分木サイズを求め、子の部分木と親側の N - size[u] を調べる。
        ## 各頂点・隣接辺を定数回だけ処理し、再帰や重心分解は使わない。
        let n = g.len
        if n == 0: return
        assert g.edge_info.len == n - 1, "入力は木である必要があります"
        var parent = newSeq[int](n)
        var size = newSeq[int](n)
        var order = newSeqOfCap[int](n)
        order.add(0)
        parent[0] = -1
        size[0] = 1
        var index = 0
        while index < order.len:
            let u = order[index]
            inc index
            for (v, _) in g.to_and_id(u):
                if v == parent[u]: continue
                assert size[v] == 0, "入力は木である必要があります"
                parent[v] = u
                size[v] = 1
                order.add(v)
        assert order.len == n, "入力は連結な木である必要があります"
        for i in countdown(order.len - 1, 1):
            let u = order[i]
            size[parent[u]] += size[u]
        for u in 0..<n:
            var largest = n - size[u]
            for (v, _) in g.to_and_id(u):
                if parent[v] == u:
                    largest = max(largest, size[v])
            if largest <= n div 2:
                result.add(u)
