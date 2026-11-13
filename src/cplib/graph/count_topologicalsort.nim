when not declared CPLIB_GRAPH_COUNT_TOPOLOGICALSORT:
    const CPLIB_GRAPH_COUNT_TOPOLOGICALSORT* = 1
    import cplib/graph/graph
    import cplib/graph/topologicalsort
    import cplib/math/combination
    import cplib/modint/modint
    import cplib/convolution/semi_relaxed_convolution

    proc topologicalCountAdjacency(G: DirectedGraph): seq[seq[int]] =
        ## 重みを無視し、同じ向きの多重辺をまとめる。O(V + E)。静的グラフはbuildが必要。
        result = newSeq[seq[int]](G.len)
        var seen = newSeq[int](G.len)
        for u in 0..<G.len:
            for (v, _) in G.to_and_cost(u):
                if seen[v] != u + 1:
                    seen[v] = u + 1
                    result[u].add(v)

    proc topologicalCountOrder(adj: seq[seq[int]]): seq[int] =
        ## トポロジカル順序を返す。閉路があれば頂点数より短い列になる。O(V + E)。
        var indegree = newSeq[int](adj.len)
        for edges in adj:
            for v in edges: inc indegree[v]
        for v in 0..<adj.len:
            if indegree[v] == 0: result.add(v)
        var head = 0
        while head < result.len:
            let u = result[head]
            inc head
            for v in adj[u]:
                dec indegree[v]
                if indegree[v] == 0: result.add(v)

    proc topologicalCountCombination[T](n: int): auto =
        ## 素数modかつN < modを前提に、階乗・逆階乗・逆数を準備する。O(N)。
        assert n >= 0 and uint64(n) < uint64(T.umod()), "頂点数は素数mod未満である必要があります"
        initCombination[T](n)

    proc topologicalCountSubset[T](predecessors: openArray[int]): T =
        ## 先行頂点のビット集合から順序を数える。時間O(N 2^N)、空間O(2^N)。
        let n = predecessors.len
        assert n < sizeof(int) * 8 - 1, "頂点数はintのビット数から1を引いた値未満である必要があります"
        var dp = newSeq[T](1 shl n)
        dp[0] += 1
        for mask in 0..<dp.len:
            if dp[mask] == default(T): continue
            for v in 0..<n:
                let bit = 1 shl v
                if (mask and bit) == 0 and (mask and predecessors[v]) == predecessors[v]:
                    dp[mask or bit] += dp[mask]
        dp[^1]

    proc count_topologicalsort*(G: DirectedGraph): int64 =
        ## トポロジカル順序の個数を返す。時間 O(V * 2^V + E)、空間 O(2^V + V)。
        ## 空グラフは1、閉路を含む場合は0。多重辺は同じ制約として扱い、重みは無視する。
        ## 静的グラフは事前にbuildが必要。頂点数は20程度までを想定する。
        ## V < sizeof(int) * 8 - 1 かつ答えがint64に収まることが必要（V <= 20なら収まる）。
        let n = G.len
        assert n < sizeof(int) * 8 - 1, "頂点数はintのビット数から1を引いた値未満である必要があります"
        if not G.isDAG():
            return 0
        var predecessors = newSeq[int](n)
        for u in 0..<n:
            for (v, _) in G.to_and_cost(u):
                predecessors[v] = predecessors[v] or (1 shl u)
        let size = 1 shl n
        var dp = newSeq[int64](size)
        dp[0] = 1
        for mask in 0..<size:
            if dp[mask] == 0:
                continue
            for v in 0..<n:
                let bit = 1 shl v
                if (mask and bit) == 0 and (mask and predecessors[v]) == predecessors[v]:
                    dp[mask or bit] += dp[mask]
        return dp[^1]

    proc count_topologicalsort*[T: BarrettModint or MontgomeryModint](G: DirectedGraph, _: typedesc[T]): T =
        ## modint型Tでトポロジカル順序を数える。時間O(V 2^V + E)、空間O(2^V + V + E)。
        ## count_topologicalsort(G, Mint)のように数値型を渡す。
        ## 空グラフは1、閉路があれば0。多重辺と重みの扱いはint64版と同じ。Vは20程度までを想定する。
        ## 静的グラフはbuildが必要。この関数は除算を使わず、V < modや素数modを要求しない。
        let n = G.len
        assert n < sizeof(int) * 8 - 1, "頂点数はintのビット数から1を引いた値未満である必要があります"
        let adj = topologicalCountAdjacency(G)
        if topologicalCountOrder(adj).len != n: return
        var predecessors = newSeq[int](n)
        for u in 0..<n:
            for v in adj[u]:
                predecessors[v] = predecessors[v] or (1 shl u)
        topologicalCountSubset[T](predecessors)

    proc count_topologicalsort_components*[T](G: DirectedGraph): T =
        ## 弱連結成分ごとに部分集合DPで数える。時間O(V + E + sum(n_i 2^n_i))、空間O(V + E + 2^max(n_i))。
        ## Tは素数modのmodint、V < mod。各成分は20頂点程度までを想定する。空は1、閉路は0。
        ## 同向き多重辺はまとめ、重みは無視する。静的グラフはbuildが必要。
        let n = G.len
        let adj = topologicalCountAdjacency(G)
        if topologicalCountOrder(adj).len != n: return
        let comb = topologicalCountCombination[T](n)
        var undirected = newSeq[seq[int]](n)
        for u in 0..<n:
            for v in adj[u]:
                undirected[u].add(v)
                undirected[v].add(u)
        var seen = newSeq[bool](n)
        var index = newSeq[int](n)
        result = comb.fact[n]
        for root in 0..<n:
            if seen[root]: continue
            var vertices = @[root]
            seen[root] = true
            var head = 0
            while head < vertices.len:
                let u = vertices[head]
                index[u] = head
                inc head
                for v in undirected[u]:
                    if not seen[v]:
                        seen[v] = true
                        vertices.add(v)
            let size = vertices.len
            assert size < sizeof(int) * 8 - 1, "各成分の頂点数はintのビット数から1を引いた値未満である必要があります"
            var predecessors = newSeq[int](size)
            for i, u in vertices:
                for v in adj[u]:
                    predecessors[index[v]] = predecessors[index[v]] or (1 shl i)
            result *= topologicalCountSubset[T](predecessors) * comb.fact_inv[size]

    type TopologicalCountForestDirection = enum
        tcfAuto, tcfOutward, tcfInward

    proc topologicalCountRootedForest[T](G: DirectedGraph, direction: TopologicalCountForestDirection): T =
        ## 成分ごとの向きに合わせて部分木サイズを求め、フック長公式で数える。時間・空間O(V + E)。
        let n = G.len
        let adj = topologicalCountAdjacency(G)
        let order = topologicalCountOrder(adj)
        if order.len != n: return
        var incoming = newSeq[seq[int]](n)
        for u in 0..<n:
            for v in adj[u]: incoming[v].add(u)
        var inward = newSeq[bool](n)
        if direction == tcfAuto:
            var seen = newSeq[bool](n)
            for root in 0..<n:
                if seen[root]: continue
                var vertices = @[root]
                seen[root] = true
                var head = 0
                var canOutward = true
                var canInward = true
                while head < vertices.len:
                    let u = vertices[head]
                    inc head
                    canOutward = canOutward and incoming[u].len <= 1
                    canInward = canInward and adj[u].len <= 1
                    for v in adj[u]:
                        if not seen[v]:
                            seen[v] = true
                            vertices.add(v)
                    for v in incoming[u]:
                        if not seen[v]:
                            seen[v] = true
                            vertices.add(v)
                assert canOutward or canInward, "各成分は根から外向き、または根へ内向きの木である必要があります"
                for u in vertices: inward[u] = not canOutward
        else:
            for u in 0..<n:
                inward[u] = direction == tcfInward
                let degree = if inward[u]: adj[u].len else: incoming[u].len
                assert degree <= 1, "全辺が根から外向き、または全辺が根へ内向きの森である必要があります"
        let comb = topologicalCountCombination[T](n)
        var size = newSeq[int](n)
        for u in 0..<n: size[u] = 1
        for u in order:
            if inward[u]:
                for v in adj[u]: size[v] += size[u]
        for i in countdown(n - 1, 0):
            let u = order[i]
            if not inward[u]:
                for v in adj[u]: size[u] += size[v]
        result = comb.fact[n]
        for s in size: result *= comb.inv[s]

    proc count_topologicalsort_rooted_forest*[T](G: DirectedGraph): T =
        ## 外向きの木と内向きの木が混在する森を数える。各成分の向きを自動判定し、時間・空間O(V + E)。
        ## Tは素数modのmodint、V < mod。空は1、閉路は0。どちらの向きの木でもない成分はassert。
        ## 同向き多重辺はまとめ、重みは無視する。静的グラフはbuildが必要。
        topologicalCountRootedForest[T](G, tcfAuto)

    proc count_topologicalsort_rooted_forest*[T](G: DirectedGraph, inward: bool): T =
        ## 森全体の向きを指定して数える。falseは外向き、trueは内向き。時間・空間O(V + E)。
        ## 数値型などの条件は自動判定版と同じ。指定した向きの条件を満たさない場合はassert。
        topologicalCountRootedForest[T](G, if inward: tcfInward else: tcfOutward)

    proc count_topologicalsort_forest*[T](G: DirectedGraph): T =
        ## 辺の向きが任意の森を数える。時間O(V^2 + E)、空間O(V + E)。
        ## Tは素数modのmodint、V < mod。空は1、閉路は0。無向化して森にならない場合はassert。
        ## 同向き多重辺はまとめ、重みは無視する。静的グラフはbuildが必要。
        let n = G.len
        let adj = topologicalCountAdjacency(G)
        if topologicalCountOrder(adj).len != n: return
        var edges = newSeq[seq[tuple[vertex: int, outward: bool]]](n)
        for u in 0..<n:
            for v in adj[u]:
                edges[u].add((v, true))
                edges[v].add((u, false))
        var parent = newSeq[int](n)
        for u in 0..<n: parent[u] = -2
        var order: seq[int]
        for root in 0..<n:
            if parent[root] != -2: continue
            parent[root] = -1
            let first = order.len
            order.add(root)
            var head = first
            while head < order.len:
                let u = order[head]
                inc head
                for e in edges[u]:
                    let v = e.vertex
                    if v == parent[u]: continue
                    assert parent[v] == -2, "辺の向きを無視すると森である必要があります"
                    parent[v] = u
                    order.add(v)
        let comb = topologicalCountCombination[T](n)
        var dp = newSeq[seq[T]](n)
        result = comb.fact[n]
        for index in countdown(n - 1, 0):
            let u = order[index]
            dp[u] = @[T.init(1)]
            for e in edges[u]:
                let v = e.vertex
                if parent[v] != u: continue
                let a = dp[u].len
                let b = dp[v].len
                var prefix = newSeq[T](b + 1)
                for j in 0..<b: prefix[j + 1] = prefix[j] + dp[v][j]
                var merged = newSeq[T](a + b)
                for i in 0..<a:
                    for j in 0..b:
                        let child = if e.outward: prefix[b] - prefix[j] else: prefix[j]
                        merged[i + j] += dp[u][i] * child * comb.ncr(i + j, i) *
                            comb.ncr(a + b - 1 - i - j, a - 1 - i)
                dp[u] = move(merged)
                dp[v] = @[]
            if parent[u] == -1:
                var count: T
                for value in dp[u]: count += value
                result *= count * comb.fact_inv[dp[u].len]
                dp[u] = @[]

    proc count_topologicalsort_all_roots*[T](G: UnDirectedGraph): seq[T] =
        ## 無向木を各頂点で根付けて外向きにした場合の答えを全頂点分返す。時間・空間O(V)。
        ## Tは素数modのmodint、V < mod。空の木には空列を返す。非連結・自己ループ・多重辺は不可。
        ## 重みは無視する。静的グラフはbuildが必要。全辺を内向きにしても答えは同じ。
        let n = G.len
        if n == 0: return @[]
        assert G.edge_count == n - 1, "入力は無向木である必要があります"
        var parent = newSeq[int](n)
        var parentEdge = newSeq[int](n)
        for u in 0..<n:
            parent[u] = -2
            parentEdge[u] = -1
        parent[0] = -1
        var order = @[0]
        var head = 0
        while head < order.len:
            let u = order[head]
            inc head
            for (v, id) in G.to_and_id(u):
                if id == parentEdge[u]: continue
                assert parent[v] == -2, "入力は無向木である必要があります"
                parent[v] = u
                parentEdge[v] = id
                order.add(v)
        assert order.len == n, "入力は連結である必要があります"
        let comb = topologicalCountCombination[T](n)
        var size = newSeq[int](n)
        for u in 0..<n: size[u] = 1
        for i in countdown(n - 1, 1):
            let u = order[i]
            size[parent[u]] += size[u]
        result = newSeq[T](n)
        result[0] = comb.fact[n]
        for s in size: result[0] *= comb.inv[s]
        for i in 1..<n:
            let u = order[i]
            result[u] = result[parent[u]] * size[u] * comb.inv[n - size[u]]

    proc count_topologicalsort_path_directions*[T](forward: openArray[bool]): T =
        ## 任意向きのパスを数える。時間O(N log^2 N)、空間O(N)。N = forward.len + 1。
        ## forward[i]がtrueならi→i+1、falseならi+1→i。空列は1頂点のパスを表す。
        ## Tは素数modのmodint、N < mod。畳み込みの対応長・実行環境の制約に従う。
        ## 既存の畳み込みを用いるため、C++バックエンド・AVX2対応環境が必要。
        let n = forward.len + 1
        let comb = topologicalCountCombination[T](n)
        var convolution = initSemiRelaxedConvolution[T](comb.fact_inv[1..n])
        var value = T.init(1)
        var odd = false
        # 降下位置で区切った昇順区間について包除する。固定側は1/(i+1)!。
        for i in 1..n:
            let total = convolution.add(value)
            if i == n:
                result = total * comb.fact[n]
            elif not forward[i - 1]:
                value = -total
                odd = not odd
            else:
                value = T.init(0)
        if odd: result = -result

    proc count_topologicalsort_path*[T](G: DirectedGraph): T =
        ## 任意向きのパスをグラフから数える。時間O(V log^2 V + E)、空間O(V + E)。
        ## Tは素数modのmodint、V < mod。空は1、閉路は0。それ以外のパスでない入力はassert。
        ## 同向き多重辺はまとめ、重みは無視する。静的グラフはbuildが必要。
        let n = G.len
        let adj = topologicalCountAdjacency(G)
        if topologicalCountOrder(adj).len != n: return
        if n == 0: return T.init(1)
        var edges = newSeq[seq[tuple[vertex: int, forward: bool]]](n)
        var edgeCount = 0
        for u in 0..<n:
            for v in adj[u]:
                edges[u].add((v, true))
                edges[v].add((u, false))
                inc edgeCount
        assert edgeCount == n - 1, "入力はパスである必要があります"
        var root = 0
        for u in 0..<n:
            assert edges[u].len <= 2, "入力はパスである必要があります"
            if edges[u].len == 1: root = u
        var forward: seq[bool]
        var seen = newSeq[bool](n)
        var u = root
        var parent = -1
        while true:
            assert not seen[u], "入力はパスである必要があります"
            seen[u] = true
            var next = -1
            for e in edges[u]:
                if e.vertex != parent:
                    next = e.vertex
                    forward.add(e.forward)
            if next == -1: break
            parent = u
            u = next
        assert forward.len == n - 1, "入力は連結なパスである必要があります"
        count_topologicalsort_path_directions[T](forward)

    proc count_topologicalsort_chains*[T](G: DirectedGraph, chains: openArray[seq[int]]): T =
        ## k本の鎖に分割されたDAGを数える。S=prod(|chain|+1)として時間O(k(V+E)+k^2 S)、空間O(kV+E+S)。
        ## chainsは全頂点を重複なく含み、各鎖は到達可能性の順に並ぶこと。違反はassert。
        ## Tはmodint。除算を使わず、素数modやV < modを要求しない。空は1、閉路は0。
        ## 同向き多重辺はまとめ、重みは無視する。静的グラフはbuildが必要。
        let n = G.len
        let k = chains.len
        var owner = newSeq[int](n)
        var position = newSeq[int](n)
        for u in 0..<n: owner[u] = -1
        for c, chain in chains:
            for i, u in chain:
                assert u >= 0 and u < n, "鎖の頂点番号が範囲外です"
                assert owner[u] == -1, "各頂点はちょうど一つの鎖に含まれる必要があります"
                owner[u] = c
                position[u] = i
        for c in owner:
            assert c != -1, "鎖は全頂点を含む必要があります"
        let adj = topologicalCountAdjacency(G)
        let order = topologicalCountOrder(adj)
        if order.len != n: return
        var required = newSeq[seq[int]](n)
        for u in 0..<n: required[u] = newSeq[int](k)
        for u in order:
            for v in adj[u]:
                for c in 0..<k:
                    required[v][c] = max(required[v][c], required[u][c])
                required[v][owner[u]] = max(required[v][owner[u]], position[u] + 1)
        for u in 0..<n:
            assert required[u][owner[u]] == position[u], "鎖は到達可能性の順に並ぶ必要があります"
        var stride = newSeq[int](k)
        var states = 1
        for c in 0..<k:
            stride[c] = states
            assert states <= high(int) div (chains[c].len + 1), "DPの状態数がintの範囲を超えます"
            states *= chains[c].len + 1
        var dp = newSeq[T](states)
        var used = newSeq[int](k)
        dp[0] = T.init(1)
        for state in 0..<states:
            if dp[state] == T.init(0): continue
            for c in 0..<k:
                used[c] = state div stride[c] mod (chains[c].len + 1)
            for c in 0..<k:
                if used[c] == chains[c].len: continue
                let u = chains[c][used[c]]
                var valid = true
                for other in 0..<k:
                    if required[u][other] > used[other]:
                        valid = false
                        break
                if valid: dp[state + stride[c]] += dp[state]
        dp[^1]

    proc count_topologicalsort_two_chains*[T](G: DirectedGraph, first, second: openArray[int]): T =
        ## 2本の鎖に分割されたDAGを数える。時間O((a+1)(b+1)+V+E)、空間O((a+1)(b+1)+V+E)。
        ## 鎖の条件と数値型の条件はcount_topologicalsort_chainsと同じ。
        count_topologicalsort_chains[T](G, [@first, @second])

    type
        TopologicalSortSPKind* = enum
            tspVertex, tspSeries, tspParallel
        TopologicalSortSPNode* = object
            ## 葉は1頂点。直列はleftの全頂点がrightより前、並列は両者の間に制約なし。
            kind*: TopologicalSortSPKind
            left*, right*: int

    proc count_topologicalsort_series_parallel*[T](nodes: openArray[TopologicalSortSPNode]): T =
        ## 直並列半順序の二分分解木から数える。時間・空間O(N)、Nは分解木のノード数。
        ## 子は親より小さい添字、末尾が根、根以外は一度だけ参照されること。空列は空の半順序。
        ## Tは素数modのmodint、葉の数 < mod。グラフの直並列性の判定・分解は行わない。
        if nodes.len == 0: return T.init(1)
        var references = newSeq[int](nodes.len)
        for i, node in nodes:
            if node.kind == tspVertex: continue
            assert node.left >= 0 and node.left < i and node.right >= 0 and node.right < i,
                "分解木の子は親より小さい添字である必要があります"
            inc references[node.left]
            inc references[node.right]
        for i in 0..<nodes.len - 1:
            assert references[i] == 1, "分解木では根以外のノードを一度だけ参照する必要があります"
        var size = newSeq[int](nodes.len)
        for i, node in nodes:
            if node.kind == tspVertex: size[i] = 1
            else: size[i] = size[node.left] + size[node.right]
        let comb = topologicalCountCombination[T](size[^1])
        var count = newSeq[T](nodes.len)
        for i, node in nodes:
            case node.kind
            of tspVertex: count[i] = T.init(1)
            of tspSeries: count[i] = count[node.left] * count[node.right]
            of tspParallel:
                count[i] = count[node.left] * count[node.right] * comb.ncr(size[i], size[node.left])
        count[^1]

    proc count_topologicalsort_young*[T](rows: openArray[int]): T =
        ## Young図形の各マスから右・下へ辺を張ったDAGを数える。N=sum(rows)として時間・空間O(N+rows.len)。
        ## rowsは上から順の行長で、非負かつ広義単調減少。左詰めの図形とし、穴は扱わない。
        ## Tは素数modのmodint、N < mod。空の図形は1。フック長公式を用いる。
        var n = 0
        for i, length in rows:
            assert length >= 0, "行の長さは非負である必要があります"
            assert i == 0 or rows[i - 1] >= length, "行の長さは広義単調減少である必要があります"
            assert n <= high(int) - length, "マスの総数がintの範囲を超えます"
            n += length
        let comb = topologicalCountCombination[T](n)
        let width = if rows.len == 0: 0 else: rows[0]
        var height = newSeq[int](width)
        for length in rows:
            for j in 0..<length: inc height[j]
        result = comb.fact[n]
        for i, length in rows:
            for j in 0..<length:
                let hook = length - j + height[j] - i - 1
                result *= comb.inv[hook]
