when not declared CPLIB_GRAPH_SCC:
    const CPLIB_GRAPH_SCC* = 1
    import cplib/graph/graph
    import sequtils
    proc SCC*(G: UnweightedDirectedGraph or UnWeightedDirectedStaticGraph): seq[seq[int]] =
        ##強連結成分分解をして、強連結成分を返します。リストはトポロジカルソートされています。
        var postorder = newseqwith(len(G), -1)
        var used = newSeqWith(len(G), false)
        var count = len(G)-1

        proc fdfs(x: int) =
            for i in G[x]:
                if not used[i]:
                    used[i] = true
                    fdfs(i)
            postorder[count] = x
            count -= 1

        for i in 0..<len(G):
            if not used[i]:
                used[i] = true
                fdfs(i)

        var gout = newseq[seq[int]](len(G))
        for i in 0..<len(G):
            for j in G[i]:
                gout[j].add(i)
        var group: seq[seq[int]]
        used = newSeqWith(len(G), false)
        count = 0

        proc sdfs(x: int) =
            group[count].add(x)
            for i in gout[x]:
                if not used[i]:
                    used[i] = true
                    sdfs(i)
        for i in postorder:
            if not used[i]:
                used[i] = true
                group.add(@[])
                sdfs(i)
                count += 1
        return group
    proc SCCG*[UG](G: UG): (UG, seq[int], seq[seq[int]]) =
        ##強連結成分分解をします。
        ##結果を、(頂点をまとめたグラフ,元の頂点→新頂点への対応,新頂点に含まれる頂点一覧)で返します。
        when UG isnot UnWeightedDirectedGraph and UG isnot UnWeightedDirectedStaticGraph:
            raise newException(Exception, "Type must be UnweightedDirectedGraph or UnweightedDirectedStaticGraph")
        var group = SCC(G)
        var i_to_group = newSeqWith(len(G), -1)
        for i in 0..<len(group):
            for j in group[i]:
                i_to_group[j] = i
        proc initUG[UG](N: int): UG =
            when UG is UnWeightedDirectedGraph: result = initUnWeightedDirectedGraph(N)
            when UG is UnWeightedDirectedStaticGraph: result = initUnWeightedDirectedStaticGraph(N)
        var newG = initUG[UG](len(group))
        for i in 0..<len(G):
            for j in G[i]:
                if i_to_group[i] != i_to_group[j]:
                    newG.add_edge(i_to_group[i], i_to_group[j])
        when UG is UnWeightedDirectedStaticGraph: newG.build
        return (newG, i_to_group, group)
