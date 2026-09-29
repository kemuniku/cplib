when not declared CPLIB_TREE_DIAMETER:
    const CPLIB_TREE_DIAMETER* = 1
    import algorithm
    import cplib/graph/graph

    proc diameter_impl(g: UnDirectedGraph, restorePath: static bool): auto =
        ## 非負重みの木の直径を、隣接辺の走査1回と逆順の木DPで求める。時間・空間 O(V)。
        assert g.len > 0, "木は1頂点以上である必要があります"
        when g is WeightedGraph:
            type Cost = g.T
        else:
            type Cost = int
        # 頂点ごとの情報をまとめ、木DPで参照する配列を減らす。
        var nodes = newSeq[tuple[parent: int, cost, down: Cost, endpoint: int]](g.len)
        var order = newSeq[int](g.len)
        nodes[0].parent = -1
        var tail = 1
        for i in 0..<g.len:
            let x = order[i]
            nodes[x].endpoint = x
            for (y, cost) in g.to_and_cost(x):
                if y == nodes[x].parent: continue
                nodes[y].parent = x
                nodes[y].cost = cost
                order[tail] = y
                inc tail

        var best = Cost(0)
        var u, v: int
        when restorePath:
            var center = 0
        for i in countdown(g.len - 1, 1):
            let x = order[i]
            let p = nodes[x].parent
            let d = nodes[x].down + nodes[x].cost
            if nodes[p].down + d > best:
                best = nodes[p].down + d
                u = nodes[p].endpoint
                v = nodes[x].endpoint
                when restorePath:
                    center = p
            if d > nodes[p].down:
                nodes[p].down = d
                nodes[p].endpoint = nodes[x].endpoint

        when restorePath:
            var path = newSeq[int]()
            var x = u
            while x != center:
                path.add(x)
                x = nodes[x].parent
            path.add(center)
            let split = path.len
            x = v
            while x != center:
                path.add(x)
                x = nodes[x].parent
            path.reverse(split, path.high)
            return (best, path)
        else:
            return (best, u, v)

    proc diameter_and_edge*(g: UnDirectedGraph): auto =
        ## 非負重みの木の直径長と両端点を返す。同長の直径の選択は任意。時間・空間 O(V)。
        g.diameter_impl(false)

    proc diameter*(g: UnDirectedGraph): auto =
        ## 非負重みの木の直径長を返す。時間・空間 O(V)。
        let (d, _, _) = g.diameter_and_edge()
        return d

    proc diameter_path*(g: UnDirectedGraph): auto =
        ## 非負重みの木の直径長と経路を返す。同長の直径の選択は任意。時間・空間 O(V)。
        g.diameter_impl(true)
