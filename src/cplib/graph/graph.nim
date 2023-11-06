when not declared CPLIB_GRAPH_GRAPH:
    const CPLIB_GRAPH_GRAPH* = 1 

    type Graph*[T] = ref object of RootObj
        edges:seq[seq[(int,T)]]
    
    type WeightedDirectedGraph*[T] =  ref object of Graph[T]
    type WeightedUnDirectedGraph*[T] =  ref object of Graph[T]
    type UnWeightedDirectedGraph* =  ref object of Graph[int]
    type UnWeightedUnDirectedGraph* =  ref object of Graph[int]
    
    #WeightedDirectedGraph
    proc initWeightedDirectedGraph*(N:int,edgetype:typedesc = int):WeightedDirectedGraph[edgetype]=
        result = WeightedDirectedGraph[edgetype](edges:newSeq[seq[(int,edgetype)]](N))
    proc add_edge*[T](g:var WeightedDirectedGraph[T],u,v:int,cost:T)=
        g.edges[u].add((v,cost))
    
    #WeightedUnDirectedGraph
    proc initWeightedUnDirectedGrapl*(N:int,edgetype:typedesc = int):WeightedUnDirectedGraph[edgetype]=
        result = WeightedUnDirectedGraph[edgetype](edges:newSeq[seq[(int,edgetype)]](N))
    proc add_edge*[T](g:var WeightedUnDirectedGraph[T],u,v:int,cost:T)=
        g.edges[u].add((v,cost))
        g.edges[v].add((u,cost))
    
    #UnWeightedDirectedGraph
    proc initUnWeightedDirectedGraph*(N:int):UnWeightedDirectedGraph=
        result = UnWeightedDirectedGraph(edges:newSeq[seq[(int,int)]](N))
    proc add_edge*[T](g:var UnWeightedDirectedGraph,u,v:int)=
        g.edges[u].add((v,1))
    
    #UnWeightedUnDirectedGraph
    proc initUnWeightedUnDirectedGraph*(N:int):UnWeightedUnDirectedGraph=
        result = UnWeightedUnDirectedGraph(edges:newSeq[seq[(int,int)]](N))
    proc add_edge*[T](g:var UnWeightedUnDirectedGraph,u,v:int)=
        g.edges[u].add((v,1))
        g.edges[v].add((u,1))

