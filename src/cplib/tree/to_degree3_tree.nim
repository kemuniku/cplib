when not declared CPLIB_TREE_TO_DEGREE3_TREE:
    const CPLIB_TREE_TO_DEGREE3_TREE* = 1
    import cplib/graph/graph

    type Degree3Tree*[T] = object
        ## 元頂点 v の代表は representative[v]。original_vertex[x] は分解前の頂点。
        ## original_edge[id] は元辺番号で、追加した 0 重み辺では -1。
        tree*: WeightedUnDirectedGraph[T]
        representative*, original_vertex*, original_edge*: seq[int]

    proc to_degree3_tree*(g: UnDirectedGraph): auto =
        ## 無向木を距離を保存して最大次数 3 の重み付き木に変換する。時間・領域 O(N)。
        ## 重み付きは型・値を維持し、無重みは int の 1、補助辺は T(0) とする。
        ## 空木も受理する。nil・頂点範囲外・非連結・辺数不正は ValueError。
        ## 通常の add_edge で作った整数頂点グラフが対象。静的入力の build は不要。
        ## 元頂点番号と元辺番号を維持し、入力は変更しない。T は T(0) を構築できる型。
        ## 重みの加算はしないので負の重みも保存する（距離は一意な経路の重み和）。
        ## 次数 d の頂点に max(0,d-3) 個の補助頂点を加える。総頂点数は O(N)。
        ## d>3 の代表から各元辺の接続点までの補助辺数は ceil(log2(ceil(d/3))) 以下。
        ## 補助木の縮約で元の木に戻るため、元頂点間の経路和と木であることを保存する。
        ## 出力頂点数は high(int32) 以下。既存 graph の int32 頂点・辺番号制約に従う。
        ## N+1 と 2(N-1) が int に収まる必要がある。参照型の重みの内容は複製しない。
        when g is WeightedGraph:
            type Cost = g.T
        else:
            type Cost = int
        var converted: Degree3Tree[Cost]
        if g.isNil:
            raise newException(ValueError, "入力は無向木である必要があります")
        let n = g.len
        let m = g.edge_count
        if n < 0 or n == high(int) or n > high(int32).int or
                m != max(0, n - 1) or m > high(int) div 2:
            raise newException(ValueError, "木の頂点数・辺数が不正です")
        var start = newSeq[int](n + 1)
        for e in g.edge_info:
            if e.src notin 0..<n or e.dst notin 0..<n:
                raise newException(ValueError, "辺の頂点番号が範囲外です")
            inc start[e.src + 1]
            inc start[e.dst + 1]
        var total = n
        for u in 0..<n:
            let extra = max(0, start[u + 1] - 3)
            if extra > high(int32).int - total:
                raise newException(ValueError, "変換後の頂点数が int32 の範囲を超えます")
            total += extra
        for u in 0..<n: start[u + 1] += start[u]
        var cursor = newSeq[int](n)
        for u in 0..<n: cursor[u] = start[u]
        var incident = newSeq[int](2 * m)
        for id, e in g.edge_info:
            incident[cursor[e.src]] = 2 * id
            inc cursor[e.src]
            incident[cursor[e.dst]] = 2 * id + 1
            inc cursor[e.dst]
        if n > 0:
            var seen = newSeq[bool](n)
            var order = @[0]
            seen[0] = true
            var index = 0
            while index < order.len:
                let u = order[index]
                inc index
                for i in start[u]..<start[u + 1]:
                    let side = incident[i]
                    let e = g.edge_info[side div 2]
                    let v = if side mod 2 == 0: e.dst else: e.src
                    if not seen[v]:
                        seen[v] = true
                        order.add(v)
            if order.len != n:
                raise newException(ValueError, "入力は連結な木である必要があります")
        converted.representative = newSeq[int](n)
        converted.original_vertex = newSeq[int](total)
        var port = newSeq[int](2 * m)
        var zeroEdges = newSeqOfCap[tuple[u, v: int]](total - n)
        var tasks: seq[tuple[parent, left, right: int]]
        var next = n
        for u in 0..<n:
            converted.representative[u] = u
            converted.original_vertex[u] = u
            let d = start[u + 1] - start[u]
            if d <= 3:
                for i in start[u]..<start[u + 1]: port[incident[i]] = u
                continue
            var left = start[u]
            for group in 0..<3:
                let right = left + d div 3 + (if group < d mod 3: 1 else: 0)
                tasks.add((u, left, right))
                left = right
            while tasks.len > 0:
                let (parent, left, right) = tasks.pop()
                if right - left == 1:
                    port[incident[left]] = parent
                else:
                    let x = next
                    inc next
                    converted.original_vertex[x] = u
                    zeroEdges.add((parent, x))
                    let mid = left + (right - left) div 2
                    tasks.add((x, left, mid))
                    tasks.add((x, mid, right))
        converted.tree = initWeightedUnDirectedGraph(total, Cost, m + zeroEdges.len)
        converted.original_edge = newSeq[int](m + zeroEdges.len)
        for id, e in g.edge_info:
            let cost = when g is WeightedGraph: e.cost else: 1
            converted.tree.add_edge(port[2 * id], port[2 * id + 1], cost)
            converted.original_edge[id] = id
        for i, e in zeroEdges:
            converted.tree.add_edge(e.u, e.v, Cost(0))
            converted.original_edge[m + i] = -1
        return converted
