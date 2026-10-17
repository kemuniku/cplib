when not declared CPLIB_GRAPH_MONGE_SHORTEST_PATH:
    const CPLIB_GRAPH_MONGE_SHORTEST_PATH* = 1
    import cplib/utils/larsch
    import cplib/utils/smawk
    import algorithm

    ## 頂点 0..<n、全ての i<j に辺がある完全 DAG を cost(i,j) で与える。
    ## Monge の向き: a<b<c<d で cost(a,c)+cost(b,d)<=cost(a,d)+cost(b,c)。
    ## 逆向きの不等式や疎なグラフは対象外。cost は有限の不変な重みで、負辺も許す。
    ## T は厳密な順序と加算を持ち、zero は加法単位元、inf は全有限候補より大きい値。
    ## 全ての評価される有限和が T で表現可能であること。飽和加算や丸め補正は行わない。
    ## NaN は不可。浮動小数点では丸め後の比較にも全単調性が必要。Monge は自動検査しない。
    ## cost を呼ぶのは start<=i<j<n だけ。inf は到達不能頂点の出力専用で加算しない。
    ## 引数 n,k は非負。n=0 では start=0、その他は 0<=start<n。同値は最小の直前頂点。
    ## 根拠: Larmore–Schieber (1991)、Wan (2024) §2 の SMAWK による層 DP。
    ## https://web.cs.unlv.edu/larmore/Research/ltol.02.pdf
    ## https://arxiv.org/html/2408.00227v1

    type
        MongeShortestPathsResult*[T] = object
            costs*: seq[T]
            prev*: seq[int]
            start*: int
        MongeExactEdgesResult*[T] = object
            costs*: seq[T]
            prev*: seq[seq[int]]
            start*, edges*: int

    proc checkMongeArguments(n, start: int) =
        ## 頂点数と始点を検査する。時間 O(1)。
        assert n >= 0, "頂点数は非負である必要があります"
        assert (n == 0 and start == 0) or (0 <= start and start < n), "始点が範囲外です"

    proc mongeShortestPaths*[T, F](n: int, cost: F, zero, inf: T,
            start: int = 0):
            MongeShortestPathsResult[T] =
        ## start から全頂点への最短距離と直前頂点を LARSCH で求める。時間・空間 O(n)。
        ## cost が O(1) の場合の計算量。start より前は inf、prev=-1。空入力は空列。
        checkMongeArguments(n, start)
        result.start = start
        result.costs = newSeq[T](n)
        result.prev = newSeq[int](n)
        result.costs.fill(inf)
        result.prev.fill(-1)
        if n == 0: return
        proc transition(to, source: int, finalized: T): T =
            ## 確定した source の距離だけを使って緩和する。
            finalized + cost(start + source, start + to)
        let dp = onlineTotallyMonotoneDP(n - start, zero, transition)
        for i in 0..<dp.costs.len:
            result.costs[start + i] = dp.costs[i]
            if dp.prev[i] >= 0: result.prev[start + i] = start + dp.prev[i]

    proc pathTo*[T](paths: MongeShortestPathsResult[T], goal: int): seq[int] =
        ## 最短経路の頂点列を O(経路長) で復元する。到達不能なら空列、始点なら @[start]。
        assert 0 <= goal and goal < paths.costs.len, "終点が範囲外です"
        if goal < paths.start: return @[]
        var at = goal
        while at != paths.start:
            result.add(at)
            at = paths.prev[at]
        result.add(paths.start)
        result.reverse()

    proc exactEdges[T, F](n, k: int, cost: F, zero, inf: T, start: int,
                          restore: static[bool]): MongeExactEdgesResult[T] =
        ## 各層を三角 SMAWK で処理する。時間 O(n*(min(k,n)+1))。
        checkMongeArguments(n, start)
        assert k >= 0, "辺数は非負である必要があります"
        result.start = start
        result.edges = k
        var costs = newSeq[T](n)
        costs.fill(inf)
        if n == 0 or k >= n - start:
            result.costs = costs
            return
        costs[start] = zero
        when restore:
            result.prev = newSeq[seq[int]](k + 1)
            for layer in 0..k:
                result.prev[layer] = newSeq[int](n)
                result.prev[layer].fill(-1)
        if k > 0:
            costs[start] = inf
            for j in start + 1..<n:
                costs[j] = zero + cost(start, j)
                when restore: result.prev[1][j] = start
        for layer in 2..k:
            let first = start + layer - 1
            let size = n - start - layer
            proc better(row, oldCol, newCol: int): bool =
                ## 未定義な col>row を有限候補より後に置き、oracle と inf 加算を避ける。
                if newCol > row: return false
                if oldCol > row: return true
                let to = first + 1 + row
                return costs[first + newCol] + cost(first + newCol, to) <
                    costs[first + oldCol] + cost(first + oldCol, to)
            # 前層の有限な列 first..<n-1 のみに制限するので、inf 列を探索しない。
            let indices = smawk(size, size, better)
            var nextCosts = newSeq[T](n)
            nextCosts.fill(inf)
            for row in 0..<size:
                let to = first + 1 + row
                let source = first + indices[row]
                nextCosts[to] = costs[source] + cost(source, to)
                when restore: result.prev[layer][to] = source
            swap(costs, nextCosts)
        result.costs = costs

    proc mongeShortestPathsExactEdges*[T, F](n, k: int, cost: F, zero, inf: T,
                                            start: int = 0): seq[T] =
        ## start から各頂点へ「ちょうど k 辺」の最短距離。k=0 は始点だけ zero、他は inf。
        ## 時間 O(n*(min(k,n)+1))、空間 O(n)。一般 Monge で SMAWK により各層 O(n)。
        ## 汎用 DAG の O(kn²) 層 DP を高速化したもの。層数を減らす Aliens 法は使わない。
        exactEdges(n, k, cost, zero, inf, start, false).costs

    proc restoreMongeShortestPathsExactEdges*[T, F](n, k: int, cost: F, zero, inf: T,
                                                   start: int = 0): MongeExactEdgesResult[T] =
        ## ちょうど k 辺の距離と各層の直前頂点を返す。時間・空間 O(n*(min(k,n)+1))。
        ## prev[layer][v] が直前頂点。同値は最小の直前頂点。k>=n-start は全て inf、prev は空。
        exactEdges(n, k, cost, zero, inf, start, true)

    proc pathTo*[T](paths: MongeExactEdgesResult[T], goal: int): seq[int] =
        ## ちょうど paths.edges 辺の最短経路を O(k+1) で復元する。到達不能なら空列。
        assert 0 <= goal and goal < paths.costs.len, "終点が範囲外です"
        if paths.edges == 0:
            if goal == paths.start: return @[goal]
            return @[]
        if paths.edges > goal - paths.start: return @[]
        var at = goal
        result = newSeq[int](paths.edges + 1)
        result[paths.edges] = goal
        for layer in countdown(paths.edges, 1):
            at = paths.prev[layer][at]
            result[layer - 1] = at

    runnableExamples:
        proc cost(i, j: int): int = (j - i) * (j - i) - 3
        let paths = mongeShortestPaths(5, cost, 0, high(int))
        assert paths.costs[4] == -8
        assert paths.pathTo(4) == @[0, 1, 2, 3, 4]
        let exact = restoreMongeShortestPathsExactEdges(5, 2, cost, 0, high(int))
        assert exact.costs[4] == 2
        assert exact.pathTo(4) == @[0, 2, 4]
