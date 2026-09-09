when not declared CPLIB_GRAPH_FUNCTIONALGRAPH_WITH_OP:
    const CPLIB_GRAPH_FUNCTIONALGRAPH_WITH_OP* = 1
    import sequtils
    import algorithm
    import cplib/graph/graph
    import cplib/graph/functional_graph
    import cplib/tree/heavylightdecomposition
    import cplib/collections/segtree

    type FunctionalGraph_with_op*[T] = ref object
        F : Functional_Graph
        op : proc(x,y:T):T
        e : T
        st_hld : SegmentTree[T]
        st_cycle : SegmentTree[T]
        cum_cyclesize : seq[int]

    proc initFunctionalGraph_with_op[T](F:Functional_Graph,values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=
        assert len(values) == len(F.cycle_number)
        result = FunctionalGraph_with_op[T](
            F : F,
            op : op,
            e : e
        )
        result.cum_cyclesize = newSeq[int](len(result.F.cycle))
        var vec = (0..<(len(values)+1)).toseq().mapit(result.F.tree.toVtx(it)).mapit(if it < len(values) : values[it] else: e).reversed()
        result.st_hld = initSegmentTree(vec,op,e)
        var tmp = newSeqOfCap[T](len(values))
        for i in 0..<(len(result.F.cycle)):
            result.cum_cyclesize[i] = if i == 0 : 0 else: result.cum_cyclesize[i-1] + len(result.F.cycle[i-1])
            for j in 0..<(len(result.F.cycle[i])):
                tmp.add(values[result.F.cycle[i][j]])
        result.st_cycle = initSegmentTree(tmp,op,e)

    proc initFunctionalGraph_with_op*[T](G:UnWeightedDirectedGraph,values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=
        return initFunctionalGraph_with_op(initFunctionalGraph(G),values,op,e)
    
    proc initFunctionalGraph_with_op*[T](A:openArray[int],values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=
        return initFunctionalGraph_with_op(initFunctionalGraph(A),values,op,e)

    proc incycle*[T](self:FunctionalGraph_with_op[T],x:int):bool=
        return self.F.incycle(x)

    proc movekth*[T](self:FunctionalGraph_with_op[T],x,cnt:int):int=
        return self.F.movekth(x,cnt)

    proc cyclesize*[T](self:FunctionalGraph_with_op[T],x:int):int=
        return self.F.cyclesize(x)

    proc canmove_size*[T](self:FunctionalGraph_with_op[T],x:int):int=
        return self.F.canmove_size(x)

    proc reachable_to_size*[T](self:FunctionalGraph_with_op[T],x:int):int=
        return self.F.reachable_to_size(x)

    proc depth*[T](self:FunctionalGraph_with_op[T],x:int):int=
        return self.F.depth(x)

    proc dist*[T](self:FunctionalGraph_with_op[T],u,v:int):int=
        return self.F.dist(u,v)

    proc get_cycle*[T](self:FunctionalGraph_with_op[T],x:int):seq[int]=
        return self.F.get_cycle(x)

    proc root*[T](self:FunctionalGraph_with_op[T],x:int):int=
        return self.F.root(x)

    proc walk*[T](self:FunctionalGraph_with_op[T],x,k:int):seq[int]=
        return self.F.walk(x,k)

    proc count_kth*[T](self:FunctionalGraph_with_op[T],x,k:int):int=
        return self.F.count_kth(x,k)
    
    proc set*[T](self:FunctionalGraph_with_op[T],x:int,value:T)=
        self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(x)] = value
        if self.F.incycle(x):
            self.st_cycle[self.cum_cyclesize[self.F.cycle_number[x]] + self.F.cycle_idx[x]] = value
    proc `[]=`*[T](self:FunctionalGraph_with_op[T],x:int,value:T)=
        self.set(x,value)

    proc prod_reachable_idempotent_all*[T](self:FunctionalGraph_with_op[T]):seq[T]=
        ## 各頂点から到達可能な相異なる頂点の値の積を全頂点について返す。
        ## opは結合的・可換・冪等でなければならない。O(N)
        let n = len(self.F.cycle_number)
        result = newSeqWith(n,self.e)

        template value(v:int):T = self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(v)]

        # サイクル上では開始位置によらず、サイクル全体の積になる。
        for cycle in self.F.cycle:
            var cycle_prod = self.e
            for v in cycle:
                cycle_prod = self.op(cycle_prod,value(v))
            for v in cycle:
                result[v] = cycle_prod

        # HLDの構築順では親（遷移先）が子より先に現れる。
        for v in self.F.tree.I:
            if v < n and not self.F.incycle(v):
                result[v] = self.op(value(v),result[self.F.tree.P[v]])

    proc prod*[T](self:FunctionalGraph_with_op[T],start:int,k:int,include_start:bool=true):T=
        ## startからk回移動するまでの積。include_start=falseなら始点を積に含めない。
        assert k >= 0
        if not include_start:
            if k == 0:
                return self.e
            return self.prod(self.F.movekth(start,1),k-1)
        result = self.e
        var root = self.F.roots[start]
        var tmp = root
        var flag = false
        if self.F.depth(start) > k:
            tmp = self.F.movekth(start,k)
            flag = true
        for (l,r) in self.F.tree.path(tmp,start,flag,true):
            result = self.op(result,self.st_hld.get(l,r))
        if not flag:
            var cid = self.F.cycle_number[root]
            var csiz = self.F.cyclesize(start)
            var k = k - self.F.depth(start) + 1
            
            # csizごと進む処理
            var x = k div csiz
            var v : T
            var root_idx = self.F.cycle_idx[root]
            if root_idx == 0:
                v = self.st_cycle[self.cum_cyclesize[cid]..<(csiz+self.cum_cyclesize[cid])]
            else:
                v = self.op(self.st_cycle[(root_idx + self.cum_cyclesize[cid])..<(csiz+self.cum_cyclesize[cid])],
                            self.st_cycle[self.cum_cyclesize[cid]..<(root_idx+self.cum_cyclesize[cid])]
                )
            
            
            while x > 0:
                if (x and 1) == 1:
                    result = self.op(result,v)
                v = self.op(v,v)
                x = x shr 1
            

            # 余りを処理
            var l = self.F.cycle_idx[root]
            var m = k mod csiz
            var r = l + m
            if r <= csiz:
                result = self.op(result,self.st_cycle[(l+self.cum_cyclesize[cid])..<(r+self.cum_cyclesize[cid])])
            else:
                result = self.op(result,self.st_cycle[(l+self.cum_cyclesize[cid])..<(csiz+self.cum_cyclesize[cid])])
                result = self.op(result,self.st_cycle[(self.cum_cyclesize[cid])..<(r-csiz+self.cum_cyclesize[cid])])

    proc prod_range*[T](self:FunctionalGraph_with_op[T],start,l,r:int,include_start:bool=true):seq[T]=
        ## @[prod(start,l), ..., prod(start,r-1)]を返す。O(log^2 N + log l + (r-l))
        assert 0 <= start and start < len(self.F.cycle_number)
        assert 0 <= l and l <= r
        result = newSeq[T](r-l)
        if len(result) == 0:
            return

        result[0] = self.prod(start,l,include_start)
        if len(result) == 1:
            return

        var now = self.F.movekth(start,l+1)
        for i in 1..<len(result):
            let value = self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(now)]
            result[i] = self.op(result[i-1],value)
            if i+1 < len(result):
                if self.F.incycle(now):
                    let cid = self.F.cycle_number[now]
                    let next_idx = (self.F.cycle_idx[now]+1) mod len(self.F.cycle[cid])
                    now = self.F.cycle[cid][next_idx]
                else:
                    now = self.F.tree.P[now]

    proc prod_range_fold*[T](self:FunctionalGraph_with_op[T],start,l,r:int,f:proc(l,r:T):T,e:T,include_start:bool=true):T=
        ## prod(start,l), ..., prod(start,r-1)を順にfで畳み込む。O(log^2 N + log l + (r-l))
        assert 0 <= start and start < len(self.F.cycle_number)
        assert 0 <= l and l <= r
        if l == r:
            return e

        var prefix_prod = self.prod(start,l,include_start)
        result = f(e,prefix_prod)
        if l+1 == r:
            return

        var now = self.F.movekth(start,l+1)
        for k in (l+1)..<r:
            let value = self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(now)]
            prefix_prod = self.op(prefix_prod,value)
            result = f(result,prefix_prod)
            if k+1 < r:
                if self.F.incycle(now):
                    let cid = self.F.cycle_number[now]
                    let next_idx = (self.F.cycle_idx[now]+1) mod len(self.F.cycle[cid])
                    now = self.F.cycle[cid][next_idx]
                else:
                    now = self.F.tree.P[now]
    
    proc move_while*[T](self:FunctionalGraph_with_op[T],f:proc(x:T):bool,x,L:int):int=
        # 数列を @[x] からスタートし、f(数列のprod)が初めてfalseになるまでの移動距離を返す。
        # ただし、移動距離の上限はLとする（L回移動してもtrueならLを返す）。
        assert L >= 0
        let limit = L+1 # 移動距離Lは、始点を含めてL+1頂点
        var value = self.e
        var used = 0

        # xからサイクル入口まで。st_hldはHLD順を反転して構築されているため、
        # path(...,true)の各区間を左から見るとfunctional graph上の移動順になる。
        let root = self.F.roots[x]
        let tree_path = self.F.tree.path(root,x,true,true)

        # max_rightにはf(単位元)=trueが必要なので、始点だけ先に処理する。
        value = self.st_hld[tree_path[0][0]]
        if not f(value):
            return 0
        used = 1
        if used == limit:
            return L

        var first_segment = true
        for (l,r) in tree_path:
            let nl = l+int(first_segment) # 始点は処理済み
            first_segment = false
            let nr = min(r,nl+limit-used)
            if nl < nr:
                let max_right = self.st_hld.max_right(nl,proc(v:T):bool=
                    f(self.op(value,v))
                )
                if max_right < nr:
                    used += max_right-nl
                    return used
                value = self.op(value,self.st_hld.get(nl,nr))
                used += nr-nl
            if used == limit:
                return L

        let cid = self.F.cycle_number[root]
        let csiz = self.F.cyclesize(x)
        let offset = self.cum_cyclesize[cid]
        let cycle_start = (self.F.cycle_idx[root]+1) mod csiz

        proc cycle_prod(l,r:int):T=
            return self.st_cycle.get(offset+l,offset+r)

        # cycle_startからちょうど1周する積。非可換なopでも順序を保つ。
        let one_cycle = self.op(
            cycle_prod(cycle_start,csiz),
            cycle_prod(0,cycle_start)
        )

        # 入れられる完全な周回数を、周回積のダブリングで求める。
        let max_cycles = (limit-used) div csiz
        if max_cycles > 0:
            var powers = @[one_cycle]
            var block_size = 1
            while block_size <= max_cycles div 2:
                powers.add(self.op(powers[^1],powers[^1]))
                block_size *= 2

            var accepted = 0
            for i in countdown(powers.high,0):
                let cnt = 1 shl i
                if cnt <= max_cycles-accepted:
                    let next_value = self.op(value,powers[i])
                    if f(next_value):
                        value = next_value
                        accepted += cnt
            used += accepted*csiz
            if used == limit:
                return L

        # 最大周回数の次の1周内で止まる。高々2区間をmax_rightすればよい。
        var rest = min(limit-used,csiz)
        proc consume_cycle(l,r:int):bool=
            if l == r:
                return true
            let nr = self.st_cycle.max_right(offset+l,proc(v:T):bool=
                f(self.op(value,v))
            )
            if nr < offset+r:
                used += nr-(offset+l)
                return false
            value = self.op(value,cycle_prod(l,r))
            used += r-l
            return true

        let first = min(rest,csiz-cycle_start)
        if not consume_cycle(cycle_start,cycle_start+first):
            return used
        rest -= first
        if rest > 0 and not consume_cycle(0,rest):
            return used
        return used-1
