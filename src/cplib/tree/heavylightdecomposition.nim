when not declared CPLIB_TREE_HLD:
    const CPLIB_TREE_HLD* = 1
    import sequtils, algorithm, sets
    import cplib/graph/graph
    # https://atcoder.jp/contests/abc337/submissions/50216964
    # ↑上記の提出より引用
    type HeavyLightDecomposition* = object
        N*: int
        P*, PP*, PD*, D*, I*, rangeL*, rangeR*: seq[int]
    proc initHld*(g: UnWeightedGraph, root: int): HeavyLightDecomposition =
        var hld = HeavyLightDecomposition()
        var n: int = g.len
        hld.N = n
        hld.P = newSeqWith(n, -1)
        hld.I = newSeqWith(n, 0)
        hld.I[0] = root
        var iI = 1
        for i in 0..<n:
            var p = hld.I[i]
            for e in g[p]:
                if hld.P[p] != e:
                    hld.I[iI] = e
                    hld.P[e] = p
                    iI += 1
        var Z = newSeqWith(n, 1)
        var nx = newSeqWith(n, -1)
        hld.PP = newSeqWith(n, 0)
        for i in 0..<n:
            hld.PP[i] = i
        for i in 1..<n:
            var p = hld.I[n-i]
            Z[hld.P[p]] += Z[p]
            if nx[hld.P[p]] == -1 or Z[nx[hld.P[p]]] < Z[p]:
                nx[hld.P[p]] = p
        for p in hld.I:
            if nx[p] != -1:
                hld.PP[nx[p]] = p
        hld.PD = newSeqWith(n, n)
        hld.PD[root] = 0
        hld.D = newSeqWith(n, 0)
        for p in hld.I:
            if p != root:
                hld.PP[p] = hld.PP[hld.PP[p]]
                hld.PD[p] = min(hld.PD[hld.PP[p]], hld.PD[hld.P[p]]+1)
                hld.D[p] = hld.D[hld.P[p]]+1
        hld.rangeL = newSeqWith(n, 0)
        hld.rangeR = newSeqWith(n, 0)
        for p in hld.I:
            hld.rangeR[p] = hld.rangeL[p] + Z[p]
            var ir = hld.rangeR[p]
            for e in g[p]:
                if hld.P[p] != e and e != nx[p]:
                    ir -= Z[e]
                    hld.rangeL[e] = ir
            if nx[p] != -1:
                hld.rangeL[nx[p]] = hld.rangeL[p] + 1
        for i in 0..<n:
            hld.I[hld.rangeL[i]] = i
        return hld
    proc initHld*[T](g: WeightedGraph[T], root: int): HeavyLightDecomposition =
        var n = g.len
        var gn = initUnWeightedUnDirectedStaticGraph(n)
        var seen = initHashSet[(int, int)]()
        for i in 0..<n:
            for (j, _) in g[i]:
                if (i, j) notin seen:
                    gn.add_edge(i, j)
                    seen.incl((i, j))
                    seen.incl((j, i))
        gn.build
        return initHld(gn, root)
    proc initHld*(adj: seq[seq[int]], root: int): HeavyLightDecomposition =
        var n = adj.len
        var gn = initUnWeightedUnDirectedStaticGraph(n)
        var seen = initHashSet[(int, int)]()
        for i in 0..<n:
            for j in adj[i]:
                if (i, j) notin seen:
                    gn.add_edge(i, j)
                    seen.incl((i, j))
                    seen.incl((j, i))
        gn.build
        return initHld(gn, root)
    proc numVertices*(hld: HeavyLightDecomposition): int = hld.N
    proc depth*(hld: HeavyLightDecomposition, p: int): int = hld.D[p]
    proc toSeq*(hld: HeavyLightDecomposition, vtx: int): int = hld.rangeL[vtx]
    proc toVtx*(hld: HeavyLightDecomposition, seqidx: int): int = hld.I[seqidx]
    proc toSeq2In*(hld: HeavyLightDecomposition, vtx: int): int = hld.rangeL[vtx] * 2 - hld.D[vtx]
    proc toSeq2Out*(hld: HeavyLightDecomposition, vtx: int): int = hld.rangeR[vtx] * 2 - hld.D[vtx] - 1
    proc parentOf*(hld: HeavyLightDecomposition, v: int): int = hld.P[v]
    proc heavyRootOf*(hld: HeavyLightDecomposition, v: int): int = hld.PP[v]
    proc heavyChildOf*(hld: HeavyLightDecomposition, v: int): int =
        if hld.toSeq(v) == hld.N-1:
            return -1
        var cand = hld.toVtx(hld.toSeq(v) + 1)
        if hld.PP[v] == hld.PP[cand]:
            return cand
        -1
    proc lca*(hld: HeavyLightDecomposition, u: int, v: int): int =
        var (u, v) = (u, v)
        if hld.PD[u] < hld.PD[v]:
            swap(u, v)
        while hld.PD[u] > hld.PD[v]:
            u = hld.P[hld.PP[u]]
        while hld.PP[u] != hld.PP[v]:
            u = hld.P[hld.PP[u]]
            v = hld.P[hld.PP[v]]
        if hld.D[u] > hld.D[v]:
            return v
        u
    proc dist*(hld: HeavyLightDecomposition, u: int, v: int): int =
        hld.depth(u) + hld.depth(v) - hld.depth(hld.lca(u, v)) * 2
    proc path*(hld: HeavyLightDecomposition, r: int, c: int, include_root: bool, reverse_path: bool): seq[(int, int)] =
        var (r, c) = (r, c)
        var k = hld.PD[c] - hld.PD[r] + 1
        if k <= 0:
            return @[]
        var res = newSeqWith(k, (0, 0))
        for i in 0..<k-1:
            res[i] = (hld.rangeL[hld.PP[c]], hld.rangeL[c] + 1)
            c = hld.P[hld.PP[c]]
        if hld.PP[r] != hld.PP[c] or hld.D[r] > hld.D[c]:
            return @[]
        var root_off = int(not include_root)
        res[^1] = (hld.rangeL[r]+root_off, hld.rangeL[c]+1)
        if res[^1][0] == res[^1][1]:
            discard res.pop()
            k -= 1
        if reverse_path:
            for i in 0..<k:
                res[i] = (hld.N - res[i][1], hld.N - res[i][0])
        else:
            res.reverse()
        res
    proc subtree*(hld: HeavyLightDecomposition, p: int): (int, int) = (hld.rangeL[p], hld.rangeR[p])
    proc median*(hld: HeavyLightDecomposition, x: int, y: int, z: int): int =
        hld.lca(x, y) xor hld.lca(y, z) xor hld.lca(x, z)
    proc la*(hld: HeavyLightDecomposition, starting: int, goal: int, d: int): int =
        var (u, v, d) = (starting, goal, d)
        if d < 0:
            return -1
        var g = hld.lca(u, v)
        var dist0 = hld.D[u] - hld.D[g]*2 + hld.D[v]
        if dist0 < d:
            return -1
        var p = u
        if hld.D[u] - hld.D[g] < d:
            p = v
            d = dist0 - d
        while hld.D[p] - hld.D[hld.PP[p]] < d:
            d -= hld.D[p] - hld.D[hld.PP[p]] + 1
            p = hld.P[hld.PP[p]]
        hld.I[hld.rangeL[p] - d]
    iterator children*(hld: HeavyLightDecomposition, v: int): int =
        var s = hld.rangeL[v] + 1
        while s < hld.rangeR[v]:
            var w = hld.toVtx(s)
            yield w
            s += hld.rangeR[w] - hld.rangeL[w]
