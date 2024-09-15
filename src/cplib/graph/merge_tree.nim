when not declared CPLIB_GRAPH_MERGE_TREE:
    const CPLIB_GRAPH_MERGE_TREE* = 1
    import cplib/graph/graph
    import cplib/collections/unionfind
    import sequtils
    type MergeTree* = object
        ein : seq[int]
        eout : seq[int]
        et : seq[int]
        ret : seq[int]
        tree : UnWeightedUnDirectedGraph
        uf : UnionFind
        now : seq[int]
        N : int
        alr_query : int
        v:seq[(int,int)]
    proc initMergeTree*(N:int,v:seq[(int,int)]):MergeTree=
        ## クエリを前読みする必要があるので、頂点数とマージを配列で与える
        var tree = initUnWeightedUnDirectedGraph(N+len(v)+1)
        var uf = initUnionFind(N)
        var now = newseqwith(N,0)
        for i in 0..<(N):
            now[i] = i
        for i in 0..<len(v):
            var (u,v) = v[i]
            var x = now[uf.root(u)]
            var y = now[uf.root(v)]
            
            tree.add_edge(x,N+i)
            if x != y:
                tree.add_edge(y,N+i)
            uf.unite(u,v)
            now[uf.root(u)] = N+i
        var alr = newSeqWith(N,false)
        for i in 0..<N:
            if not alr[uf.root(i)]:
                alr[uf.root(i)] = true
                tree.add_edge(N+len(v),now[uf.root(i)])
        var ein = newseqwith(N+len(v)+1,-1)
        var eout = newseqwith(N+len(v)+1,-1)
        var et : seq[int]
        proc dfs(x,p:int)=
            ein[x] = len(et)
            if x < N:
                et.add(x)
            for y in tree[x]:
                if y != p:
                    dfs(y,x)
            eout[x] = len(et)
        dfs(N+len(v),-1)
        result.tree = move(tree)
        result.ein = move(ein)
        result.eout = move(eout)
        result.et = move(et)
        result.ret = newseqwith(N,-1)
        result.uf = initUnionFind(N)
        result.now = newseqwith(N,0)
        result.v = v
        result.N = N
        for i in 0..<(N):
            result.now[i] = i
        for i in 0..<N:
            result.ret[result.et[i]] = i

    proc unite*(self:var MergeTree,u,v:int)=
        ## 頂点u,vをマージする
        ## 先読みで与えた順番にuniteしてください
        assert (self.v[self.alr_query][0] == u or self.v[self.alr_query][0] == v) and (self.v[self.alr_query][1] == v or self.v[self.alr_query][1] == u)
        self.uf.unite(u,v)
        self.now[self.uf.root(u)] = self.N+self.alr_query
        self.alr_query += 1

    proc get_id*(self:var MergeTree,x:int):int=
        ## xが現在の状態でどこの頂点で表される集合に属しているかを返す
        return self.now[self.uf.root(x)]

    proc get_range*(self:var MergeTree,x:int):HSlice[int,int]=
        ## ある集合について、それに属している頂点を区間で返す
        return (self.ein[self.now[self.uf.root(x)]]..<self.eout[self.now[self.uf.root(x)]])

    proc make_seq*[T](self:var MergeTree,v:seq[T]):seq[T]=
        ## オイラーツアー順に配列を並び替える
        assert len(v) == self.N
        result = newseq[T](len(v))
        for i in 0..<self.N:
            result[self.ret[i]] = v[i]

    proc restore_seq*[T](self:var MergeTree,v:seq[T]):seq[T]=
        ## オイラーツアー順になっている配列をもとに戻す
        assert len(v) == self.N
        result = newseq[T](len(v))
        for i in 0..<self.N:
            result[self.et[i]] = v[i]

    proc index*(self:var MergeTree,x:int):int=
        ## オイラーツアー順でxは何番目かを返す
        self.ret[x]