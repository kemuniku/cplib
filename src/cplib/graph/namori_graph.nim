when not declared CPLIB_GRAPH_NAMORI:
    const CPLIB_GRAPH_NAMORI* = 1
    import cplib/graph/graph
    import cplib/tree/heavylightdecomposition
    import cplib/utils/constants
    import sequtils
    type NamoriGraph = ref object 
        tree : HeavyLightDecomposition
        rootNo : seq[int]
        roots : seq[int]
        cyclesize : int


    proc initNamoriGraph*(graph:UnWeightedUnDirectedGraph):NamoriGraph=
        ## 注意！連結性を仮定しています
        var stack : seq[int]
        var sizes = newseqwith(len(graph),0)
        var rootNo = newseqwith(len(graph),-1)
        var tree = initUnWeightedUnDirectedGraph(len(graph)+1)
        var roots = newseqwith(len(graph),0)
        for i in 0..<len(graph):
            sizes[i] = len(graph.edges[i])
            if sizes[i] == 1:
                stack.add(i)
        while len(stack) != 0:
            var i = stack.pop()
            for j in graph[i]:
                if sizes[j] != 1:
                    tree.add_edge(i,j)
                    sizes[j] -= 1
                    if sizes[j] == 1:
                        stack.add(j)
        for i in 0..<len(graph):
            if sizes[i] != 1:
                var now = i
                var bef = -1
                var tmp = 1
                rootNo[i] = 0
                while true:
                    tree.add_edge(now,len(graph))
                    var next = -1
                    proc dfs(x,p:int)=
                        roots[x] = now
                        for y in graph[x]:
                            if p != y:
                                if sizes[y] == 1:
                                    dfs(y,x)
                                elif bef != y:
                                    next = y
                    dfs(now,-1)
                    if next == -1 or next == i:
                        break
                    bef = now
                    now = next
                    rootNo[now] = tmp
                    tmp += 1
                return NamoriGraph(tree:tree.initHld(len(graph)),rootNo:rootNo,roots:roots,cyclesize:tmp)

    proc dist*(namori:NamoriGraph,u,v:int):(int,int)=
        ## u,v間の距離を二通り返します
        ## (小さいほう,大きいほう)
        ## ただし、一通りしか存在しない場合二つ目のintはINF64を返します。
        var lca = namori.tree.lca(u,v) 
        if lca != len(namori.rootNo):
            return (namori.tree.dist(u,v),INF64)
        else:
            var x = namori.roots[u]
            var y = namori.roots[v]
            var a = abs(namori.rootNo[x]-namori.rootNo[y])
            var b = namori.cyclesize - a
            var tmp = namori.tree.depth(u) + namori.tree.depth(v) - 2
            return (min(a,b)+tmp,max(a,b)+tmp)