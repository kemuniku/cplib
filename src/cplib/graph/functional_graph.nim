when not declared CPLIB_GRAPH_FUNCTIONALGRAPH:
    const CPLIB_GRAPH_FUNCTIONALGRAPH* = 1
    import sequtils
    import cplib/graph/graph
    import cplib/tree/heavylightdecomposition
    type Functional_Graph* = ref object 
        tree* : HeavyLightDecomposition
        cycle_number* : seq[int]
        cycle_idx* : seq[int]
        roots* : seq[int]
        cycle* : seq[seq[int]]
        depth_tin : seq[seq[int]]
        cycle_depth : seq[seq[seq[int]]]
        component_size : seq[int]

    proc initFunctionalGraph*(v:openArray[int]):Functional_Graph=
        let n = len(v)
        var removed = newSeqOfCap[int](n)
        var sizes = newseqwith(n,0)
        var cycle_number = newseqwith(n,-1)
        var cycle_idx = newseqwith(n,-1)
        var parent = newSeqWith(n+1,-1)
        var roots = newseqwith(n,0)
        var cycle : seq[seq[int]]
        for i in 0..<n:
            assert 0 <= v[i] and v[i] < n
            sizes[v[i]] += 1
        for i in 0..<n:
            if sizes[i] == 0:
                removed.add(i)
        var removed_idx = 0
        while removed_idx < len(removed):
            let i = removed[removed_idx]
            removed_idx += 1
            let j = v[i]
            parent[i] = j
            sizes[j] -= 1
            if sizes[j] == 0:
                removed.add(j)

        var alr = newseqwith(n,false)
        for i in 0..<n:
            if sizes[i] != 0 and not alr[i]:
                let cycle_n = len(cycle)
                var now = i
                cycle.add(@[])
                while not alr[now]:
                    alr[now] = true
                    cycle_number[now] = cycle_n
                    cycle_idx[now] = len(cycle[cycle_n])
                    roots[now] = now
                    cycle[cycle_n].add(now)
                    parent[now] = n
                    now = v[now]
        # 削除順の逆から見れば、遷移先のrootは既に決まっている。
        var i = len(removed)
        while i > 0:
            i -= 1
            let x = removed[i]
            roots[x] = roots[v[x]]

        result = Functional_Graph(
            tree:initHldFromParent(parent,n),
            cycle_number:cycle_number,
            roots:roots,
            cycle:cycle,
            cycle_idx:cycle_idx
        )

        # depthごとにHLDのEuler Tour上の位置を昇順で持つ。
        result.depth_tin = newSeq[seq[int]](n)
        for tin in 0..<result.tree.N:
            let x = result.tree.toVtx(tin)
            if x < n:
                let d = result.tree.depth(x)-1
                result.depth_tin[d].add(tin)

        # cycleごとに (cycle_idx[root]-depth) mod cycle_size で分類し、
        # 各列にはdepthを昇順で持つ。
        result.cycle_depth = newSeq[seq[seq[int]]](len(cycle))
        result.component_size = newSeq[int](len(cycle))
        for cid in 0..<len(cycle):
            result.cycle_depth[cid] = newSeq[seq[int]](len(cycle[cid]))
        for d in 0..<len(result.depth_tin):
            for tin in result.depth_tin[d]:
                let v = result.tree.toVtx(tin)
                let root = roots[v]
                let cid = cycle_number[root]
                let csiz = len(cycle[cid])
                let residue = (cycle_idx[root]-(d mod csiz)+csiz) mod csiz
                result.cycle_depth[cid][residue].add(d)
                result.component_size[cid] += 1

    proc initFunctionalGraph*(graph:UnWeightedDirectedGraph):Functional_Graph=
        var v = newSeq[int](len(graph))
        for i in 0..<len(graph):
            for j in graph[i]:
                v[i] = j
        return initFunctionalGraph(v)

    proc incycle*(namori:Functional_Graph,x:int):bool=
        return namori.cycle_number[x] != -1

    proc movekth*(functional_graph:Functional_Graph,x,cnt:int):int=
        #xからcnt回動いたらどこに行くか
        if functional_graph.tree.depth(x)-1 >= cnt:
            return functional_graph.tree.la(x,len(functional_graph.cycle_number),cnt)
        else:
            var root = functional_graph.roots[x]
            var cnt = cnt-(functional_graph.tree.depth(x)-1)
            return functional_graph.cycle[functional_graph.cycle_number[root]][(functional_graph.cycle_idx[root]+cnt) mod len(functional_graph.cycle[functional_graph.cycle_number[root]])]

    proc cyclesize*(functional_graph:Functional_Graph,x:int):int=
        ## xから到達することができるサイクルのサイズ
        var root = functional_graph.roots[x]
        return functional_graph.cycle[functional_graph.cycle_number[root]].len()

    proc canmove_size*(functional_graph:Functional_Graph,x:int):int=
        ## xから到達することのできる頂点数(xも含む)
        return functional_graph.tree.depth(x)-1+functional_graph.cyclesize(x)

    proc reachable_to_size*(functional_graph:Functional_Graph,x:int):int=
        ## xに到達することのできる頂点数(xも含む)
        if functional_graph.incycle(x):
            return functional_graph.component_size[functional_graph.cycle_number[x]]
        let (l,r) = functional_graph.tree.subtree(x)
        return r-l

    proc depth*(functional_graph:Functional_Graph,x:int):int=
        ## 何回の移動でcycleに入るか
        return functional_graph.tree.depth(x)-1

    proc dist*(functional_graph:Functional_Graph,u,v:int):int=
        ## uからvへ最短何回の移動で到達が可能か
        ## ただし、到達できないときは-1を返す。
        if functional_graph.cycle_number[functional_graph.roots[u]] != functional_graph.cycle_number[functional_graph.roots[v]]:
            return -1
        var lca = functional_graph.tree.lca(u,v)
        if lca == v:
            return functional_graph.tree.depth(u)-functional_graph.tree.depth(v)
        if lca == len(functional_graph.cycle_number):
            if functional_graph.incycle(v):
                var x = functional_graph.cycle_idx[functional_graph.roots[u]]
                var y = functional_graph.cycle_idx[v]
                if x < y:
                    return y-x+functional_graph.depth(u)
                else:
                    return y+len(functional_graph.cycle[functional_graph.cycle_number[v]])-x+functional_graph.depth(u)
        return -1

    proc get_cycle*(functional_graph:Functional_Graph,x:int):seq[int]=
        ## xから到達できるサイクルを返す
        var root = functional_graph.roots[x]
        return functional_graph.cycle[functional_graph.cycle_number[root]]

    proc root*(functional_graph:Functional_Graph,x:int):int=
        ## xから進んでいったときに、初めてサイクルに入ったときの頂点を返す
        return functional_graph.roots[x]

    proc compressed_forest*(functional_graph:Functional_Graph):(UnWeightedUnDirectedGraph,seq[int],seq[int])=
        ## 各サイクルを1頂点に圧縮した根付き森を返す。O(N)
        ## 返り値は (森, 元の頂点から圧縮後の頂点への対応, 各木の根) 。
        ## 根は functional_graph.cycle と同じ順番で並ぶ。
        let n = len(functional_graph.cycle_number)
        var compressed = newSeqWith(n,-1)
        var roots = newSeq[int](len(functional_graph.cycle))
        var compressed_n = 0

        for cid,cycle in functional_graph.cycle:
            roots[cid] = compressed_n
            for v in cycle:
                compressed[v] = compressed_n
            compressed_n += 1

        for v in 0..<n:
            if compressed[v] == -1:
                compressed[v] = compressed_n
                compressed_n += 1

        var forest = initUnWeightedUnDirectedGraph(compressed_n)
        for v in 0..<n:
            if not functional_graph.incycle(v):
                forest.add_edge(compressed[v],compressed[functional_graph.tree.P[v]])

        return (forest,compressed,roots)

    proc walk*(functional_graph:Functional_Graph,x,k:int):seq[int]=
        ## xを始点としてk回移動するまでに訪れる頂点を、始点を含む長さk+1の配列で返す。O(k)
        let n = len(functional_graph.cycle_number)
        assert 0 <= x and x < n
        assert 0 <= k and k < high(int)
        result = newSeq[int](k+1)
        var now = x
        for i in 0..k:
            result[i] = now
            if i < k:
                if functional_graph.incycle(now):
                    let cid = functional_graph.cycle_number[now]
                    let next_idx = (functional_graph.cycle_idx[now]+1) mod len(functional_graph.cycle[cid])
                    now = functional_graph.cycle[cid][next_idx]
                else:
                    now = functional_graph.tree.P[now]

    import algorithm

    proc count_kth*(functional_graph:Functional_Graph,x,k:int):int=
        ## 各頂点にコマを1つずつ置いてk回移動したとき、頂点xにあるコマの数
        ## O(log N)
        assert 0 <= x and x < len(functional_graph.cycle_number)
        assert k >= 0
        if not functional_graph.incycle(x):
            let d = functional_graph.depth(x)
            if k > functional_graph.depth_tin.high-d:
                return 0
            let (l,r) = functional_graph.tree.subtree(x)
            let tins = functional_graph.depth_tin[d+k]
            return tins.lowerBound(r)-tins.lowerBound(l)

        let cid = functional_graph.cycle_number[x]
        let csiz = len(functional_graph.cycle[cid])
        let residue = (functional_graph.cycle_idx[x]-(k mod csiz)+csiz) mod csiz
        return functional_graph.cycle_depth[cid][residue].upperBound(k)
