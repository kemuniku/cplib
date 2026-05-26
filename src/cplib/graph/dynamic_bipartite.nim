when not declared CPLIB_GRAPH_DYNAMIC_BIPARTITE_GRAPH:
    const CPLIB_GRAPH_DYNAMIC_BIPARTITE_GRAPH* = 1
    import cplib/graph/graph
    import sequtils,sugar
    import cplib/collections/rootvalue_unionfind
    
    type DynamicBipartite = ref object
        N : int
        uf : RootValueUnionFind[int]
        is_bipartite : bool
        cnt_sum* : int

    proc var_add_x_to_y(x,y:var int)=
        x += y
    proc initDynamicBipartite*(N:int):DynamicBipartite= 
        return DynamicBipartite(N:N,uf:initRootValueUnionFind(2*N,var_add_x_to_y,newseqwith(N,0) & newseqwith(N,1)),is_bipartite:true,cnt_sum : N)
    
    proc can_unite*(self:DynamicBipartite,u,v:int):bool=
        ## 辺(u,v)を新たに追加したときにグラフが二部グラフかどうか判定する
        ## 既に二部グラフではない場合は常にfalseが返る
        return self.is_bipartite and (not self.uf.issame(u,v))

    proc unite*(self:DynamicBipartite,u,v:int)=
        ## 辺(u,v)の追加
        if self.uf.issame(u,v+self.N) or not self.is_bipartite:
            return
        if self.uf.issame(u,v):
            self.is_bipartite = false
            self.cnt_sum = -1
            return
        var u = self.uf.root(u)
        var v = self.uf.root(v)
        self.cnt_sum -= max(self.uf.get(u),self.uf.get(u+self.N)) + max(self.uf.get(v),self.uf.get(v+self.N))
        self.uf.unite(u,self.N+v)
        self.uf.unite(v,self.N+u)
        self.cnt_sum += max(self.uf.get(u),self.uf.get(u+self.N))
    
    proc is_bipartite*(self:DynamicBipartite):bool=
        return self.is_bipartite