when not declared CPLIB_GRAPH_NAMORI_FOREST:
    const CPLIB_GRAPH_NAMORI_FOREST* = 1
    import cplib/graph/graph
    import cplib/tree/heavylightdecomposition
    import cplib/utils/constants
    import sequtils

    type NamoriForest* = ref object
        tree: HeavyLightDecomposition
        rootNo: seq[int]      # cycle 上の頂点なら、その cycle 内での番号
        roots: seq[int]       # x がぶら下がっている cycle 頂点
        comp: seq[int]        # 連結成分番号
        cyclesize: seq[int]   # comp ごとの cycle 長
        superRoot: int

    proc initNamoriForest*(graph: UnWeightedUnDirectedGraph): NamoriForest =
        let n = len(graph)
        let superRoot = n

        var stack: seq[int]
        var sizes = newSeqWith(n, 0)
        var rootNo = newSeqWith(n, -1)
        var roots = newSeqWith(n, -1)
        var comp = newSeqWith(n, -1)
        var tree = initUnWeightedUnDirectedGraph(n + 1)

        for i in 0 ..< n:
            sizes[i] = len(graph.edges[i])
            if sizes[i] == 1:
                stack.add(i)

        # 葉を削って、木部分の辺だけ tree に入れる
        while stack.len != 0:
            let i = stack.pop()
            for j in graph[i]:
                if sizes[j] != 1:
                    tree.add_edge(i, j)
                    sizes[j] -= 1
                    if sizes[j] == 1:
                        stack.add(j)

        var usedCycle = newSeqWith(n, false)
        var cyclesize: seq[int]

        for s in 0 ..< n:
            if sizes[s] == 1 or usedCycle[s]:
                continue

            # s を含む cycle を一周する
            var cyc: seq[int]
            var now = s
            var prev = -1

            while true:
                cyc.add(now)
                usedCycle[now] = true

                var nxt = -1
                for to in graph[now]:
                    if sizes[to] != 1 and to != prev:
                        nxt = to
                        break

                if nxt == -1 or nxt == s:
                    break

                prev = now
                now = nxt

            let cid = cyclesize.len
            cyclesize.add(cyc.len)

            for idx, r in cyc:
                rootNo[r] = idx
                tree.add_edge(r, superRoot)

                proc dfs(x, p: int) =
                    roots[x] = r
                    comp[x] = cid

                    for y in graph[x]:
                        if y == p:
                            continue
                        if sizes[y] == 1:
                            dfs(y, x)

                dfs(r, -1)

        return NamoriForest(
            tree: tree.initHld(superRoot),
            rootNo: rootNo,
            roots: roots,
            comp: comp,
            cyclesize: cyclesize,
            superRoot: superRoot
        )

    proc dist*(namori: NamoriForest, u, v: int): (int, int) =
        ## u, v 間の距離を二通り返します。
        ## 同じ木部分にいるなら二通り目は INF64。
        ## 別連結成分なら (INF64, INF64)。

        if namori.comp[u] != namori.comp[v]:
            return (INF64, INF64)

        let lca = namori.tree.lca(u, v)

        if lca != namori.superRoot:
            return (namori.tree.dist(u, v), INF64)

        let x = namori.roots[u]
        let y = namori.roots[v]
        let cid = namori.comp[u]

        let a = abs(namori.rootNo[x] - namori.rootNo[y])
        let b = namori.cyclesize[cid] - a

        # cycle root は superRoot の子なので、
        # depth(u) + depth(v) - 2 が「木部分だけの距離」になる
        let base = namori.tree.depth(u) + namori.tree.depth(v) - 2

        return (min(a, b) + base, max(a, b) + base)

    proc incycle*(namori: NamoriForest, x: int): bool =
        return namori.roots[x] == x

    proc root*(namori: NamoriForest, x: int): int =
        return namori.roots[x]

    proc same_tree*(namori: NamoriForest, x, y: int): bool =
        return namori.roots[x] == namori.roots[y]

    proc same_component*(namori: NamoriForest, x, y: int): bool =
        return namori.comp[x] == namori.comp[y]

    proc component*(namori: NamoriForest, x: int): int =
        return namori.comp[x]