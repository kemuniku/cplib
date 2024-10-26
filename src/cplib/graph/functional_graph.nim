when not declared CPLIB_GRAPH_FUNCTIONALGRAPH:
    const CPLIB_GRAPH_FUNCTIONALGRAPH* = 1
    import sequtils
    import cplib/graph/graph
    import cplib/tree/heavylightdecomposition
    type Functional_Graph* = ref object 
        tree* : HeavyLightDecomposition
        cycle_number : seq[int]
        cycle_idx : seq[int]
        roots : seq[int]
        cycle* : seq[seq[int]]

    proc initFunctionalGraph*(graph:UnWeightedDirectedGraph):Functional_Graph=
        var stack : seq[int]
        var sizes = newseqwith(len(graph),0)
        var cycle_number = newseqwith(len(graph),-1)
        var cycle_idx = newseqwith(len(graph),-1)
        var tree = initUnWeightedUnDirectedGraph(len(graph)+1)
        var roots = newseqwith(len(graph),0)
        var cycle : seq[seq[int]]
        for i in 0..<len(graph):
            for j in graph[i]:
                sizes[j] += 1
        for i in 0..<len(graph):
            if sizes[i] == 0:
                stack.add(i)
        while len(stack) != 0:
            var i = stack.pop()
            for j in graph[i]:
                if sizes[j] != 0:
                    tree.add_edge(i,j)
                    sizes[j] -= 1
                    if sizes[j] == 0:
                        stack.add(j)
        var alr = newseqwith(len(graph),false)
        var cycle_n = 0
        for i in 0..<len(graph):
            if sizes[i] != 0 and not alr[i]:
                var now = i
                var bef = -1
                var tmp = 1
                cycle_idx[i] = 0
                cycle_number[i] = cycle_n
                cycle.add(@[i])
                while true:
                    alr[now] = true
                    var next = -1
                    proc dfs(x,p:int)=
                        roots[x] = now
                        for y in tree[x]:
                            if p != y:
                                if sizes[y] == 0:
                                    dfs(y,x)
                    dfs(now,-1)
                    tree.add_edge(now,len(graph))
                    for j in graph[now]:
                        next = j
                    if next == -1 or next == i:
                        break
                    bef = now
                    now = next
                    cycle_number[now] = cycle_n
                    cycle_idx[now] = tmp
                    cycle[cycle_n].add(next)
                    tmp += 1
                    
                cycle_n += 1
        return Functional_Graph(tree:tree.initHld(len(graph)),cycle_number:cycle_number,roots:roots,cycle:cycle,cycle_idx:cycle_idx)

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
            return functional_graph.tree.depth(v)-functional_graph.tree.depth(u)
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