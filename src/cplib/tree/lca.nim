when not declared CPLIB_TREE_LCA:
    const CPLIB_TREE_LCA* = 1
    import bitops, sequtils
    import cplib/graph/graph

    type LowestCommonAncestor* = ref object
        parent, depths: seq[int]
        first, order: seq[int32]
        blockShift: int
        values, prefix, suffix: seq[int32]
        masks: seq[uint32]
        table: seq[seq[int32]]

    # 入力をassertで検査し、構築中の配列アクセスでは重複した境界検査を省く。
    {.push boundChecks: off, overflowChecks: off.}
    proc initLCAFromParent*(parent: openArray[int], root: int): LowestCommonAncestor =
        ## 根付き木の親配列から構築する。parent[root]は参照しない。N < 2^31。時間・空間O(N)
        let n = parent.len
        assert n <= high(int32).int, "頂点数は2^31未満である必要があります"
        assert 0 <= root and root < n, "根の頂点番号が範囲外です"
        result = LowestCommonAncestor(parent: @parent, depths: newSeq[int](n),
            first: newSeq[int32](n), order: newSeq[int32](n), values: newSeq[int32](n))
        result.parent[root] = -1
        var ordered = root == 0
        for v in 0..<n:
            if v != root:
                let p = parent[v]
                assert 0 <= p and p < n, "親の頂点番号が範囲外です"
                if p >= v: ordered = false
        if ordered:
            # 親番号が子番号より小さければ、部分木サイズからDFS番号を順に割り当てる。
            var size = newSeqWith(n, 1'i32)
            for v in countdown(n - 1, 1):
                size[parent[v]] += size[v]
            # 割り当て済みの頂点では、sizeの領域を子の配置先の右端として再利用する。
            for v in 1..<n:
                let p = parent[v]
                let subtreeSize = size[v]
                size[p] -= subtreeSize
                let index = size[p]
                result.first[v] = index
                size[v] = index + subtreeSize
                result.order[index] = v.int32
                result.values[index] = result.first[p]
                result.depths[v] = result.depths[p] + 1
        else:
            var head = newSeqWith(n, -1)
            var next = newSeqWith(n, -1)
            for v in 0..<n:
                if v != root:
                    let p = parent[v]
                    next[v] = head[p]
                    head[p] = v
            var v = root
            var count = 0
            while v != -1:
                result.first[v] = count.int32
                result.order[count] = v.int32
                if v != root:
                    let p = parent[v]
                    result.depths[v] = result.depths[p] + 1
                    result.values[count] = result.first[p]
                inc count
                if head[v] != -1:
                    v = head[v]
                else:
                    while v != root and next[v] == -1:
                        v = parent[v]
                    if v == root: break
                    v = next[v]
            assert count == n, "指定した根から全頂点に到達できる必要があります"

        # DFS順でu < vなら、区間(u, v]の親のDFS番号の最小値がLCAのDFS番号になる。
        # ブロック長を2冪かつΘ(log N)にして、除算をなくし上位表をO(N)に抑える。
        result.blockShift = fastLog2(max(1, fastLog2(n))) + 1
        let size = 1 shl result.blockShift
        let blocks = ((n - 1) shr result.blockShift) + 1
        result.masks = newSeq[uint32](n)
        result.prefix = newSeq[int32](n)
        result.suffix = newSeq[int32](n)
        result.table = newSeq[seq[int32]](fastLog2(blocks) + 1)
        result.table[0] = newSeq[int32](blocks)
        # 単調スタックをビット列で保存する。各要素の追加・削除は高々1回で合計O(N)。
        for b in 0..<blocks:
            let start = b shl result.blockShift
            let stop = min(start + size, n)
            var mask = 0'u32
            var best = high(int32)
            for i in start..<stop:
                let value = result.values[i]
                while mask != 0:
                    let top = fastLog2(mask)
                    if result.values[start + top] < value: break
                    mask = mask xor (1'u32 shl top)
                mask = mask or (1'u32 shl (i - start))
                result.masks[i] = mask
                best = min(best, value)
                result.prefix[i] = best
            result.table[0][b] = best
            best = high(int32)
            for i in countdown(stop - 1, start):
                best = min(best, result.values[i])
                result.suffix[i] = best
        for k in 1..<result.table.len:
            result.table[k] = newSeq[int32](blocks - (1 shl k) + 1)
            for i in 0..<result.table[k].len:
                result.table[k][i] = min(result.table[k - 1][i],
                    result.table[k - 1][i + (1 shl (k - 1))])

    {.pop.}

    proc undirectedAdj(g: UnDirectedGraph or DirectedGraph): seq[seq[int]] =
        ## 辺の向きと重みを無視した隣接リストを作る。O(N + M)
        result = newSeq[seq[int]](g.len)
        for v in 0..<g.len:
            for (u, _) in g.to_and_cost(v):
                result[v].add(u)
                result[u].add(v)

    proc undirectedAdj(adj: openArray[seq[int]]): seq[seq[int]] =
        ## 隣接リストの辺の向きを無視した隣接リストを作る。O(N + M)
        result = newSeq[seq[int]](adj.len)
        for v in 0..<adj.len:
            for u in adj[v]:
                assert 0 <= u and u < adj.len, "頂点番号が範囲外です"
                result[v].add(u)
                result[u].add(v)

    proc fromAdj(adj: seq[seq[int]] or UnDirectedGraph, root: int, forest: bool): LowestCommonAncestor =
        ## 隣接リストを親配列へ変換して構築する。O(N + M)
        let n = adj.len
        var parent = newSeqWith(n + int(forest), -2)
        var stack: seq[int]
        if forest:
            parent[n] = -1
        else:
            assert 0 <= root and root < n, "根の頂点番号が範囲外です"
            parent[root] = -1
            stack.add(root)
        for start in 0..<max(1, n):
            if forest:
                if start == n or parent[start] != -2: continue
                parent[start] = n
                stack.add(start)
            elif start != 0:
                break
            while stack.len > 0:
                let v = stack.pop()
                template visit(u: int) =
                    ## 未訪問の頂点を探索候補に追加する。償却O(1)
                    if parent[u] == -2:
                        parent[u] = v
                        stack.add(u)
                when adj is UnDirectedGraph:
                    for (u, _) in adj.to_and_cost(v): visit(u)
                else:
                    for u in adj[v]: visit(u)
        result = initLCAFromParent(parent, if forest: n else: root)

    proc initLCA*(g: UnDirectedGraph or DirectedGraph, root: int): LowestCommonAncestor =
        ## 辺の向きと重みを無視すると木になるgから構築する。時間・空間O(N + M)、木ではO(N)
        when g is UnDirectedGraph:
            fromAdj(g, root, false)
        else:
            fromAdj(undirectedAdj(g), root, false)

    proc initLCA*(adj: openArray[seq[int]], root: int): LowestCommonAncestor =
        ## 木の隣接リストから辺の向きを無視して構築する。時間・空間O(N + M)、木ではO(N)
        fromAdj(undirectedAdj(adj), root, false)

    proc initLCAFromForest*(g: UnDirectedGraph or DirectedGraph): LowestCommonAncestor =
        ## 森に根Nを追加し、各成分の最小番号の頂点と結ぶ。辺の向きと重みは無視する。O(N + M)
        when g is UnDirectedGraph:
            fromAdj(g, g.len, true)
        else:
            fromAdj(undirectedAdj(g), g.len, true)

    proc initLCAFromForest*(adj: openArray[seq[int]]): LowestCommonAncestor =
        ## 森の隣接リストの向きを無視し、根Nを追加して各成分の最小頂点と結ぶ。O(N + M)
        fromAdj(undirectedAdj(adj), adj.len, true)

    proc numVertices*(tree: LowestCommonAncestor): int =
        ## 頂点数を返す。森の場合は追加した根を含む。O(1)
        tree.parent.len

    proc parentOf*(tree: LowestCommonAncestor, v: int): int =
        ## 頂点vの親を返す。根の場合は-1を返す。O(1)
        tree.parent[v]

    proc depth*(tree: LowestCommonAncestor, v: int): int =
        ## 根から頂点vまでの辺数を返す。O(1)
        tree.depths[v]

    {.push boundChecks: off, overflowChecks: off.}
    proc lca*(tree: LowestCommonAncestor, u, v: int): int {.inline.} =
        ## 頂点uとvの最小共通祖先を返す。O(1)
        assert 0 <= u and u < tree.parent.len and 0 <= v and v < tree.parent.len, "頂点番号が範囲外です"
        if u == v: return u
        let l = min(tree.first[u], tree.first[v]).int + 1
        let r = max(tree.first[u], tree.first[v]).int
        let shift = tree.blockShift
        let a = l shr shift
        let b = r shr shift
        var best: int32
        if a == b:
            let start = a shl shift
            let mask = tree.masks[r] and (high(uint32) shl (l - start))
            best = tree.values[start + countTrailingZeroBits(mask)]
        else:
            best = min(tree.suffix[l], tree.prefix[r])
            if a + 1 < b:
                let k = fastLog2(b - a - 1)
                best = min(best, min(tree.table[k][a + 1], tree.table[k][b - (1 shl k)]))
        tree.order[best].int
    {.pop.}

    proc dist*(tree: LowestCommonAncestor, u, v: int): int =
        ## 頂点uとvを結ぶパスの辺数を返す。O(1)
        tree.depth(u) + tree.depth(v) - 2 * tree.depth(tree.lca(u, v))

    proc median*(tree: LowestCommonAncestor, x, y, z: int): int =
        ## 根をxとしたときのyとzの最小共通祖先を返す。O(1)
        tree.lca(x, y) xor tree.lca(y, z) xor tree.lca(x, z)
