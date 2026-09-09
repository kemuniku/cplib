when not declared CPLIB_TREE_HLD:
    const CPLIB_TREE_HLD* = 1
    import sequtils, algorithm, sets
    import cplib/graph/graph
    # https://atcoder.jp/contests/abc337/submissions/50216964
    # ↑上記の提出より引用
    type HeavyLightDecomposition* = ref object 
        N*: int
        P*, PP*, PD*, D*, I*, rangeL*, rangeR*: seq[int]

    proc initHldFromParent*(parent: openArray[int], root: int): HeavyLightDecomposition =
        ## 根付き木の親配列からHLDを構築する。parent[root]は参照しない。O(N)
        let n = len(parent)
        assert 0 <= root and root < n
        var hld = HeavyLightDecomposition(N:n)
        hld.P = @parent
        hld.P[root] = -1

        # 親から子を列挙するための連結リスト。
        var head = newSeqWith(n,-1)
        var next = newSeqWith(n,-1)
        for v in 0..<n:
            if v != root:
                assert 0 <= hld.P[v] and hld.P[v] < n
                next[v] = head[hld.P[v]]
                head[hld.P[v]] = v

        # 親が必ず子より先に現れる順序。
        hld.I = newSeq[int](n)
        hld.I[0] = root
        var iI = 1
        for i in 0..<n:
            var v = head[hld.I[i]]
            while v != -1:
                hld.I[iI] = v
                iI += 1
                v = next[v]
        assert iI == n

        var size = newSeqWith(n,1)
        var heavy = newSeqWith(n,-1)
        for i in countdown(n-1,1):
            let v = hld.I[i]
            let p = hld.P[v]
            size[p] += size[v]
            if heavy[p] == -1 or size[heavy[p]] < size[v]:
                heavy[p] = v

        hld.PP = newSeq[int](n)
        for v in 0..<n:
            hld.PP[v] = v
        for v in hld.I:
            if heavy[v] != -1:
                hld.PP[heavy[v]] = v

        hld.PD = newSeqWith(n,n)
        hld.PD[root] = 0
        hld.D = newSeq[int](n)
        for v in hld.I:
            if v != root:
                hld.PP[v] = hld.PP[hld.PP[v]]
                hld.PD[v] = min(hld.PD[hld.PP[v]],hld.PD[hld.P[v]]+1)
                hld.D[v] = hld.D[hld.P[v]]+1

        hld.rangeL = newSeq[int](n)
        hld.rangeR = newSeq[int](n)
        for p in hld.I:
            hld.rangeR[p] = hld.rangeL[p]+size[p]
            var ir = hld.rangeR[p]
            var v = head[p]
            while v != -1:
                if v != heavy[p]:
                    ir -= size[v]
                    hld.rangeL[v] = ir
                v = next[v]
            if heavy[p] != -1:
                hld.rangeL[heavy[p]] = hld.rangeL[p]+1

        for v in 0..<n:
            hld.I[hld.rangeL[v]] = v
        return hld

    proc initHld*(g: UnDirectedGraph, root: int): HeavyLightDecomposition =
        ## 無向木gをrootを根としてHLDに分解する。O(N)
        var hld = HeavyLightDecomposition()
        var n: int = g.len
        hld.N = n
        hld.P = newSeqWith(n, -1)
        hld.I = newSeqWith(n, 0)
        hld.I[0] = root
        var iI = 1
        for i in 0..<n:
            var p = hld.I[i]
            for (e, _) in g.to_and_cost(p):
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
            for (e, _) in g.to_and_cost(p):
                if hld.P[p] != e and e != nx[p]:
                    ir -= Z[e]
                    hld.rangeL[e] = ir
            if nx[p] != -1:
                hld.rangeL[nx[p]] = hld.rangeL[p] + 1
        for i in 0..<n:
            hld.I[hld.rangeL[i]] = i
        return hld
    proc initHld*(g: DirectedGraph, root: int): HeavyLightDecomposition =
        ## 辺の向きを無視すると木になるgから、rootを根とするHLDを構築する。期待O(N + M)、Mは入力の辺数
        var n = g.len
        var gn = initUnWeightedUnDirectedStaticGraph(n)
        var seen = initHashSet[(int, int)]()
        for i in 0..<n:
            for (j, _) in g.to_and_cost(i):
                if (i, j) notin seen:
                    gn.add_edge(i, j)
                    seen.incl((i, j))
                    seen.incl((j, i))
        gn.build
        return initHld(gn, root)
    proc initHld*(adj: openArray[seq[int]], root: int): HeavyLightDecomposition =
        ## 木の隣接リストから、辺の向きを無視してrootを根とするHLDを構築する。期待O(N + M)、Mは隣接リストの要素数の合計
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
    proc numVertices*(hld: HeavyLightDecomposition): int =
        ## 頂点数を返す。O(1)
        hld.N
    proc depth*(hld: HeavyLightDecomposition, p: int): int =
        ## 根から頂点pまでの辺数を返す。O(1)
        hld.D[p]
    proc toSeq*(hld: HeavyLightDecomposition, vtx: int): int =
        ## 頂点vtxをHLD順の配列添字（0始まり）に変換する。O(1)
        hld.rangeL[vtx]
    proc toSeq*[T](hld: HeavyLightDecomposition, values: openArray[T]): seq[T] =
        ## 頂点番号順の数列をHLD順に並べ替えて返す。時間・追加空間O(N)
        ## valuesの長さは頂点数と等しい必要があり、result[hld.toSeq(i)] = values[i]となる。
        assert values.len == hld.N
        result = newSeq[T](hld.N)
        for i, value in values:
            result[hld.toSeq(i)] = value
    proc toVtx*(hld: HeavyLightDecomposition, seqidx: int): int =
        ## HLD順の配列添字seqidxに対応する頂点番号を返す。O(1)
        hld.I[seqidx]
    proc toSeq2In*(hld: HeavyLightDecomposition, vtx: int): int =
        ## 各頂点の入場・退場を記録するEuler Tourで、vtxの入場位置（0始まり）を返す。O(1)
        hld.rangeL[vtx] * 2 - hld.D[vtx]
    proc toSeq2Out*(hld: HeavyLightDecomposition, vtx: int): int =
        ## 各頂点の入場・退場を記録するEuler Tourで、vtxの退場位置（0始まり）を返す。O(1)
        hld.rangeR[vtx] * 2 - hld.D[vtx] - 1
    proc parentOf*(hld: HeavyLightDecomposition, v: int): int =
        ## 頂点vの親を返す。根の場合は-1を返す。O(1)
        hld.P[v]
    proc heavyRootOf*(hld: HeavyLightDecomposition, v: int): int =
        ## 頂点vが属するheavy pathの最も浅い頂点を返す。O(1)
        hld.PP[v]
    proc heavyChildOf*(hld: HeavyLightDecomposition, v: int): int =
        ## 頂点vのheavy edgeでつながる子を返す。存在しない場合は-1を返す。O(1)
        if hld.toSeq(v) == hld.N-1:
            return -1
        var cand = hld.toVtx(hld.toSeq(v) + 1)
        if hld.PP[v] == hld.PP[cand]:
            return cand
        -1
    proc lca*(hld: HeavyLightDecomposition, u: int, v: int): int =
        ## 頂点uとvの最小共通祖先を返す。O(log N)
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
        ## 頂点uとvを結ぶパスの辺数を返す。O(log N)
        hld.depth(u) + hld.depth(v) - hld.depth(hld.lca(u, v)) * 2
    proc path*(hld: HeavyLightDecomposition, r: int, c: int, include_root: bool, reverse_path: bool): seq[(int, int)] =
        ## 祖先rから子孫cへのパスをHLD順の半開区間に分解する。rがcの祖先でなければ空列を返す。O(log N)
        ## include_rootでrを含めるか指定する。reverse_pathがfalseならrからcの順に区間を返す。
        ## reverse_pathがtrueならcからrの順に、HLD順の配列を反転した配列上の区間を返す。
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
    proc pathWithDirection*(hld: HeavyLightDecomposition, u: int, v: int): seq[(int, int, bool)] =
        ## 両端を含むuからvへのパスを、辿る順にHLD順の半開区間(l, r, upward)に分解する。O(log N)
        ## upwardがtrueなら上方向でHLD順の反転配列、falseなら下方向で通常の配列の添字を返す。
        ## どちらもlからr-1の順に読む。最小共通祖先は上方向の区間に一度だけ含める。
        let ancestor = hld.lca(u, v)
        for (l, r) in hld.path(ancestor, u, true, true):
            result.add((l, r, true))
        for (l, r) in hld.path(ancestor, v, false, false):
            result.add((l, r, false))

    proc path*(hld: HeavyLightDecomposition, u: int, v: int): seq[(int, int)] =
        ## 両端を含むuからvへのパスを、向きを持たないHLD順の半開区間(l, r)に分解する。O(log N)
        ## 各頂点を一度だけ含む。区間内の走査方向が不要な可換演算などに使用する。
        for (l, r, upward) in hld.pathWithDirection(u, v):
            if upward:
                result.add((hld.N - r, hld.N - l))
            else:
                result.add((l, r))

    proc subtree*(hld: HeavyLightDecomposition, p: int): (int, int) =
        ## 頂点p自身を含む部分木に対応するHLD順の半開区間を返す。O(1)
        (hld.rangeL[p], hld.rangeR[p])
    iterator subtreeV*(hld: HeavyLightDecomposition, p: int):int=
        ## 頂点p自身を含む部分木の頂点番号をHLD順に列挙する。O(部分木の頂点数)
        for i in hld.rangeL[p]..<hld.rangeR[p]:
            yield hld.toVtx(i)
    proc median*(hld: HeavyLightDecomposition, x: int, y: int, z: int): int =
        ## 頂点x、y、zの各2頂点を結ぶ3本のパスに共通する頂点を返す。O(log N)
        hld.lca(x, y) xor hld.lca(y, z) xor hld.lca(x, z)
    proc la*(hld: HeavyLightDecomposition, starting: int, goal: int, d: int): int =
        ## startingからgoalへd辺進んだ頂点を返す。dが負またはパスの辺数を超える場合は-1を返す。O(log N)
        var (u, v, d) = (starting, goal, d)
        if d < 0:
            return -1
        var g = hld.lca(u, v)
        var dist0 = hld.D[u] - hld.D[g] * 2 + hld.D[v]
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
        ## 頂点vの子をHLD順に列挙する。O(子の数 + 1)
        var s = hld.rangeL[v] + 1
        while s < hld.rangeR[v]:
            var w = hld.toVtx(s)
            yield w
            s += hld.rangeR[w] - hld.rangeL[w]
    

    proc initAuxiliaryTree*(hld:HeavyLightDecomposition,v:openArray[int]):UnWeightedUnDirectedTableGraph[int]=
        ## 指定頂点と必要な最小共通祖先から補助木を構築する。Kを入力頂点数として期待O(K log K + K log N)
        ## 頂点番号は元の木と共通で、各辺は元の木のパスを表す。空でなければ根は返り値のv[0]。
        var v = v.sortedByit(hld.toseq(it))
        for i in 0..<(len(v)-1):
            v.add(hld.lca(v[i],v[i+1]))
        v = v.sortedByIt(hld.toseq(it)).deduplicate(true)
        var stack :seq[int]
        result = initUnWeightedUnDirectedTableGraph[int](v)
        if v.len == 0:
            return
        stack.add(v[0])
        
        for i in 1..<len(v):
            while len(stack) > 0 and hld.toSeq2Out(stack[^1]) < hld.toseq2In(v[i]):
                discard stack.pop()
            if len(stack) != 0:
                result.add_edge(stack[^1],v[i])
            stack.add(v[i])
    
    proc initAuxiliaryWeightedTree*(hld: HeavyLightDecomposition, v: openArray[int], S: typedesc = int): WeightedUnDirectedTableGraph[int, S] =
        ## 指定頂点と必要な最小共通祖先から、元の木での辺数を重みとする補助木を構築する。Kを入力頂点数として期待O(K log K + K log N)
        ## 頂点番号は元の木と共通で、重みは型Sに変換する。空でなければ根は返り値のv[0]。
        var v = v.sortedByit(hld.toseq(it))
        for i in 0..<(len(v)-1):
            v.add(hld.lca(v[i],v[i+1]))
        v = v.sortedByIt(hld.toseq(it)).deduplicate(true)
        var stack :seq[int]
        result = initWeightedUnDirectedTableGraph(v, S)
        if v.len == 0:
            return
        stack.add(v[0])
        for i in 1..<len(v):
            while len(stack) > 0 and hld.toSeq2Out(stack[^1]) < hld.toseq2In(v[i]):
                discard stack.pop()
            if len(stack) != 0:
                result.add_edge(stack[^1], v[i], S(hld.depth(v[i]) - hld.depth(stack[^1])))
            stack.add(v[i])
