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

    import cplib/collections/segtree
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

    import atcoder/lazysegtree

    type FunctionalGraph_with_lazy_op*[ST] = ref object
        ## ACLの遅延セグメント木を用いて、functional graph上の積と経路作用を扱う。
        ## 非サイクル頂点はst_hld、サイクル頂点はst_cycleだけに保持する。
        graph : Functional_Graph
        st_hld : ST
        st_cycle : ST
        cum_cyclesize : seq[int]

    proc initFunctionalGraph_with_lazy_op_impl[S,ST](
        graph:Functional_Graph,
        values:seq[S],
        st_type:typedesc[ST]
    ):FunctionalGraph_with_lazy_op[ST]=
        assert len(values) == len(graph.cycle_number)
        result = FunctionalGraph_with_lazy_op[ST](graph:graph)

        # HLD側ではサイクル頂点を単位元にする。サイクル頂点まで重複保持すると、
        # サイクル区間への遅延作用をHLD側へ高速に同期できないため。
        var hld_values = newSeqWith(graph.tree.N,ST.calc_e())
        for v in 0..<len(values):
            if not graph.incycle(v):
                hld_values[graph.tree.N-1-graph.tree.toSeq(v)] = values[v]
        result.st_hld = ST.init(hld_values)

        result.cum_cyclesize = newSeq[int](len(graph.cycle))
        var cycle_values = newSeqOfCap[S](len(values))
        for cid,cycle in graph.cycle:
            if cid > 0:
                result.cum_cyclesize[cid] = result.cum_cyclesize[cid-1] + len(graph.cycle[cid-1])
            for v in cycle:
                cycle_values.add(values[v])
        result.st_cycle = ST.init(cycle_values)

    proc initFunctionalGraph_with_lazy_op*[S,ST](
        source:Functional_Graph,
        values:seq[S],
        st_type:typedesc[ST]
    ):FunctionalGraph_with_lazy_op[ST]=
        ## 明示したACL LazySegTree型STを使って構築する。O(N)
        ## 複数のfunctional graphを同じ型として保持したい場合に用いる。
        return initFunctionalGraph_with_lazy_op_impl(source,values,st_type)

    proc initFunctionalGraph_with_lazy_op*[S,ST](
        source:UnWeightedDirectedGraph,
        values:seq[S],
        st_type:typedesc[ST]
    ):FunctionalGraph_with_lazy_op[ST]=
        return initFunctionalGraph_with_lazy_op_impl(initFunctionalGraph(source),values,st_type)

    proc initFunctionalGraph_with_lazy_op*[S,ST](
        source:openArray[int],
        values:seq[S],
        st_type:typedesc[ST]
    ):FunctionalGraph_with_lazy_op[ST]=
        return initFunctionalGraph_with_lazy_op_impl(initFunctionalGraph(source),values,st_type)

    template initFunctionalGraph_with_lazy_op*(source,values,op,e,mapping,composition,id:untyped):untyped=
        ## ACLのlazysegtreeと同じop/e/mapping/composition/idから構築する。O(N)
        block:
            type S = typeof(values[0])
            type Action = typeof(id())
            type ST = typeof(initLazySegTree[S,Action](values,op,e,mapping,composition,id))
            initFunctionalGraph_with_lazy_op(source,values,ST)

    template initFunctionalGraph_with_op*(source,values,op,e,mapping,composition,id:untyped):untyped=
        ## 遅延作用を使う場合のinitFunctionalGraph_with_opオーバーロード。
        initFunctionalGraph_with_lazy_op(source,values,op,e,mapping,composition,id)

    proc incycle*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):bool=
        return self.graph.incycle(x)

    proc movekth*[ST](self:FunctionalGraph_with_lazy_op[ST],x,cnt:int):int=
        return self.graph.movekth(x,cnt)

    proc cyclesize*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=
        return self.graph.cyclesize(x)

    proc canmove_size*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=
        return self.graph.canmove_size(x)

    proc reachable_to_size*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=
        return self.graph.reachable_to_size(x)

    proc depth*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=
        return self.graph.depth(x)

    proc dist*[ST](self:FunctionalGraph_with_lazy_op[ST],u,v:int):int=
        return self.graph.dist(u,v)

    proc get_cycle*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):seq[int]=
        return self.graph.get_cycle(x)

    proc root*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=
        return self.graph.root(x)

    proc walk*[ST](self:FunctionalGraph_with_lazy_op[ST],x,k:int):seq[int]=
        return self.graph.walk(x,k)

    proc count_kth*[ST](self:FunctionalGraph_with_lazy_op[ST],x,k:int):int=
        return self.graph.count_kth(x,k)

    proc lazyHldIndex[ST](self:FunctionalGraph_with_lazy_op[ST],v:int):int=
        return self.graph.tree.N-1-self.graph.tree.toSeq(v)

    proc lazyCycleIndex[ST](self:FunctionalGraph_with_lazy_op[ST],v:int):int=
        return self.cum_cyclesize[self.graph.cycle_number[v]] + self.graph.cycle_idx[v]

    proc get*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):ST.S=
        ## 頂点xの現在値を返す。O(log N)
        assert 0 <= x and x < len(self.graph.cycle_number)
        if self.graph.incycle(x):
            return self.st_cycle[self.lazyCycleIndex(x)]
        return self.st_hld[self.lazyHldIndex(x)]

    proc `[]`*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):ST.S=
        return self.get(x)

    proc set*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int,value:ST.S)=
        ## 頂点xの値をvalueに変更する。O(log N)
        assert 0 <= x and x < len(self.graph.cycle_number)
        if self.graph.incycle(x):
            self.st_cycle[self.lazyCycleIndex(x)] = value
        else:
            self.st_hld[self.lazyHldIndex(x)] = value

    proc `[]=`*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int,value:ST.S)=
        self.set(x,value)

    proc lazyActionPower[ST](self:FunctionalGraph_with_lazy_op[ST],f:ST.F,n:int):ST.F=
        assert n >= 0
        result = self.st_hld.calc_id()
        var base = f
        var n = n
        while n > 0:
            if (n and 1) == 1:
                result = self.st_hld.calc_composition(base,result)
            n = n shr 1
            if n > 0:
                base = self.st_hld.calc_composition(base,base)

    proc applyCyclePrefix[ST](
        self:FunctionalGraph_with_lazy_op[ST],
        cid,start,count:int,
        f:ST.F
    )=
        ## cycle[cid]のstartから遷移順にcount頂点へ作用する。countは1周以下。
        let csiz = len(self.graph.cycle[cid])
        assert 0 <= start and start < csiz
        assert 0 <= count and count <= csiz
        if count == 0:
            return
        let offset = self.cum_cyclesize[cid]
        let first = min(count,csiz-start)
        self.st_cycle.apply((offset+start)..<(offset+start+first),f)
        if first < count:
            self.st_cycle.apply(offset..<(offset+count-first),f)

    proc apply*[ST](self:FunctionalGraph_with_lazy_op[ST],start,k:int,f:ST.F,include_start:bool=true)=
        ## startからk回移動するまでに訪れる各頂点へfを作用させる。
        ## 同じ頂点を複数回訪れた場合は、その回数だけfを作用させる。
        ## include_start=falseなら始点には作用させない。O(log^2 N + log k)
        assert 0 <= start and start < len(self.graph.cycle_number)
        assert 0 <= k and k < high(int)
        if not include_start:
            if k == 0:
                return
            self.apply(self.graph.movekth(start,1),k-1,f)
            return

        let d = self.graph.depth(start)
        if k < d:
            let last = self.graph.movekth(start,k)
            for (l,r) in self.graph.tree.path(last,start,true,true):
                self.st_hld.apply(l..<r,f)
            return

        let root = self.graph.roots[start]
        for (l,r) in self.graph.tree.path(root,start,false,true):
            self.st_hld.apply(l..<r,f)

        let cid = self.graph.cycle_number[root]
        let csiz = len(self.graph.cycle[cid])
        let cycle_count = k-d+1
        let full_cycles = cycle_count div csiz
        let remainder = cycle_count mod csiz
        let offset = self.cum_cyclesize[cid]
        if full_cycles > 0:
            let repeated_f = self.lazyActionPower(f,full_cycles)
            self.st_cycle.apply(offset..<(offset+csiz),repeated_f)
        self.applyCyclePrefix(cid,self.graph.cycle_idx[root],remainder,f)

    proc lazyPushAll[ST](st:var ST)=
        ## 親から順に遅延値を伝播し、全葉を読み出せる状態にする。O(len)
        for p in 1..<st.size:
            st.push(p)

    proc prod_reachable_idempotent_all*[ST](self:FunctionalGraph_with_lazy_op[ST]):seq[ST.S]=
        ## 各頂点から到達可能な相異なる頂点の値の積を全頂点について返す。
        ## opは結合的・可換・冪等でなければならない。O(N)
        let n = len(self.graph.cycle_number)
        result = newSeqWith(n,self.st_hld.calc_e())
        self.st_hld.lazyPushAll()
        self.st_cycle.lazyPushAll()

        template value(v:int):ST.S =
            (if self.graph.incycle(v):
                self.st_cycle.d[self.st_cycle.size+self.lazyCycleIndex(v)]
            else:
                self.st_hld.d[self.st_hld.size+self.lazyHldIndex(v)])

        for cycle in self.graph.cycle:
            var cycle_prod = self.st_hld.calc_e()
            for v in cycle:
                cycle_prod = self.st_hld.calc_op(cycle_prod,value(v))
            for v in cycle:
                result[v] = cycle_prod

        for v in self.graph.tree.I:
            if v < n and not self.graph.incycle(v):
                result[v] = self.st_hld.calc_op(value(v),result[self.graph.tree.P[v]])

    proc prod*[ST](self:FunctionalGraph_with_lazy_op[ST],start,k:int,include_start:bool=true):ST.S=
        ## startからk回移動するまでの積。include_start=falseなら始点を積に含めない。
        ## O(log^2 N + log k)
        assert 0 <= start and start < len(self.graph.cycle_number)
        assert 0 <= k and k < high(int)
        if not include_start:
            if k == 0:
                return self.st_hld.calc_e()
            return self.prod(self.graph.movekth(start,1),k-1)

        result = self.st_hld.calc_e()
        let root = self.graph.roots[start]
        var tree_root = root
        var ends_in_tree = false
        if self.graph.depth(start) > k:
            tree_root = self.graph.movekth(start,k)
            ends_in_tree = true
        for (l,r) in self.graph.tree.path(tree_root,start,ends_in_tree,true):
            result = self.st_hld.calc_op(result,self.st_hld.prod(l..<r))
        if ends_in_tree:
            return

        let cid = self.graph.cycle_number[root]
        let csiz = len(self.graph.cycle[cid])
        let offset = self.cum_cyclesize[cid]
        let cycle_count = k-self.graph.depth(start)+1
        let full_cycles = cycle_count div csiz
        let remainder = cycle_count mod csiz
        let cycle_start = self.graph.cycle_idx[root]

        if full_cycles > 0:
            let one_cycle = self.st_hld.calc_op(
                self.st_cycle.prod((offset+cycle_start)..<(offset+csiz)),
                self.st_cycle.prod(offset..<(offset+cycle_start))
            )
            var repeated = one_cycle
            var count = full_cycles
            while count > 0:
                if (count and 1) == 1:
                    result = self.st_hld.calc_op(result,repeated)
                count = count shr 1
                if count > 0:
                    repeated = self.st_hld.calc_op(repeated,repeated)

        let first = min(remainder,csiz-cycle_start)
        if first > 0:
            result = self.st_hld.calc_op(
                result,
                self.st_cycle.prod((offset+cycle_start)..<(offset+cycle_start+first))
            )
        if first < remainder:
            result = self.st_hld.calc_op(
                result,
                self.st_cycle.prod(offset..<(offset+remainder-first))
            )

    proc appendLazyRangeDfs[ST](
        st:var ST,
        k,left,right,q_left,q_right:int,
        values:var seq[ST.S]
    )=
        if right <= q_left or q_right <= left:
            return
        if right-left == 1:
            values.add(st.d[k])
            return
        st.push(k)
        let middle = (left+right) shr 1
        st.appendLazyRangeDfs(k shl 1,left,middle,q_left,q_right,values)
        st.appendLazyRangeDfs((k shl 1) or 1,middle,right,q_left,q_right,values)

    proc appendLazyRange[ST](st:var ST,q_left,q_right:int,values:var seq[ST.S])=
        ## st[q_left..<q_right]の葉を左からvaluesへ追加する。O(log N + 出力長)
        assert 0 <= q_left and q_left <= q_right and q_right <= st.len
        if q_left < q_right:
            st.appendLazyRangeDfs(1,0,st.size,q_left,q_right,values)

    proc walkValues[ST](self:FunctionalGraph_with_lazy_op[ST],start,count:int):seq[ST.S]=
        ## startから始まる訪問列の先頭count頂点分の値を返す。
        ## O(log^2 N + count)
        assert 0 <= start and start < len(self.graph.cycle_number)
        assert count >= 0
        result = newSeqOfCap[ST.S](count)
        if count == 0:
            return

        let tree_count = min(count,self.graph.depth(start))
        if tree_count > 0:
            let last = self.graph.movekth(start,tree_count-1)
            for (l,r) in self.graph.tree.path(last,start,true,true):
                self.st_hld.appendLazyRange(l,r,result)

        let cycle_count = count-tree_count
        if cycle_count == 0:
            return
        let root = self.graph.roots[start]
        let cid = self.graph.cycle_number[root]
        let csiz = len(self.graph.cycle[cid])
        let offset = self.cum_cyclesize[cid]
        let cycle_start =
            if self.graph.incycle(start): self.graph.cycle_idx[start]
            else: self.graph.cycle_idx[root]

        var one_cycle = newSeqOfCap[ST.S](min(cycle_count,csiz))
        let materialize_count = min(cycle_count,csiz)
        let first = min(materialize_count,csiz-cycle_start)
        self.st_cycle.appendLazyRange(
            offset+cycle_start,offset+cycle_start+first,one_cycle
        )
        if first < materialize_count:
            self.st_cycle.appendLazyRange(
                offset,offset+materialize_count-first,one_cycle
            )
        for i in 0..<cycle_count:
            result.add(one_cycle[i mod len(one_cycle)])

    proc prod_range*[ST](self:FunctionalGraph_with_lazy_op[ST],start,l,r:int,include_start:bool=true):seq[ST.S]=
        ## @[prod(start,l), ..., prod(start,r-1)]を返す。
        ## O(log^2 N + log l + (r-l))
        assert 0 <= start and start < len(self.graph.cycle_number)
        assert 0 <= l and l <= r and r < high(int)
        result = newSeq[ST.S](r-l)
        if len(result) == 0:
            return

        result[0] = self.prod(start,l,include_start)
        if len(result) == 1:
            return

        let values = self.walkValues(self.graph.movekth(start,l+1),len(result)-1)
        for i,value in values:
            result[i+1] = self.st_hld.calc_op(result[i],value)

    proc prod_range_fold*[ST,U](self:FunctionalGraph_with_lazy_op[ST],start,l,r:int,f:proc(x:U,y:ST.S):U,e:U,include_start:bool=true):U=
        ## prod(start,l), ..., prod(start,r-1)を順にfで畳み込む。
        ## O(log^2 N + log l + (r-l))
        assert 0 <= start and start < len(self.graph.cycle_number)
        assert 0 <= l and l <= r and r < high(int)
        if l == r:
            return e

        var prefix_prod = self.prod(start,l,include_start)
        result = f(e,prefix_prod)
        if l+1 == r:
            return

        let values = self.walkValues(self.graph.movekth(start,l+1),r-l-1)
        for value in values:
            prefix_prod = self.st_hld.calc_op(prefix_prod,value)
            result = f(result,prefix_prod)

    proc move_while*[ST](
        self:FunctionalGraph_with_lazy_op[ST],
        f:proc(x:ST.S):bool,
        x,L:int
    ):int=
        ## @[x]から始め、prefixのprodに対するfが初めてfalseになる移動距離。
        ## L回移動してもtrueならLを返す。O(log^2 N + log L)
        ## f(e)=trueであり、一度falseになった後は頂点を追加してもfalseのまま、
        ## というACL max_rightと同じ単調性を仮定する。
        assert 0 <= x and x < len(self.graph.cycle_number)
        assert 0 <= L and L < high(int)
        let limit = L+1
        var value = self.get(x)
        if not f(value):
            return 0
        var used = 1
        if used == limit:
            return L

        let root = self.graph.roots[x]
        # サイクル入口はcycle側の正本で処理するため、HLD pathから除外する。
        let tree_path = self.graph.tree.path(root,x,false,true)
        var first_segment = true
        for (l,r) in tree_path:
            let nl = l+int(first_segment) # xは処理済み
            first_segment = false
            let nr = nl+min(r-nl,limit-used)
            if nl < nr:
                let max_right = self.st_hld.max_right(nl,proc(v:ST.S):bool=
                    f(self.st_hld.calc_op(value,v))
                )
                if max_right < nr:
                    used += max_right-nl
                    return used
                value = self.st_hld.calc_op(value,self.st_hld.prod(nl..<nr))
                used += nr-nl
            if used == limit:
                return L

        let cid = self.graph.cycle_number[root]
        let csiz = len(self.graph.cycle[cid])
        let offset = self.cum_cyclesize[cid]
        let cycle_start =
            if self.graph.incycle(x):
                (self.graph.cycle_idx[x]+1) mod csiz
            else:
                self.graph.cycle_idx[root]

        proc cycleProd(l,r:int):ST.S=
            return self.st_cycle.prod((offset+l)..<(offset+r))

        let one_cycle = self.st_hld.calc_op(
            cycleProd(cycle_start,csiz),
            cycleProd(0,cycle_start)
        )
        let max_cycles = (limit-used) div csiz
        if max_cycles > 0:
            var powers = @[one_cycle]
            var block_size = 1
            while block_size <= max_cycles div 2:
                powers.add(self.st_hld.calc_op(powers[^1],powers[^1]))
                block_size *= 2

            var accepted = 0
            for i in countdown(powers.high,0):
                let count = 1 shl i
                if count <= max_cycles-accepted:
                    let next_value = self.st_hld.calc_op(value,powers[i])
                    if f(next_value):
                        value = next_value
                        accepted += count
            used += accepted*csiz
            if used == limit:
                return L

        var rest = min(limit-used,csiz)
        proc consumeCycle(l,r:int):bool=
            if l == r:
                return true
            let max_right = self.st_cycle.max_right(offset+l,proc(v:ST.S):bool=
                f(self.st_hld.calc_op(value,v))
            )
            if max_right < offset+r:
                used += max_right-(offset+l)
                return false
            value = self.st_hld.calc_op(value,cycleProd(l,r))
            used += r-l
            return true

        let first = min(rest,csiz-cycle_start)
        if not consumeCycle(cycle_start,cycle_start+first):
            return used
        rest -= first
        if rest > 0 and not consumeCycle(0,rest):
            return used
        return used-1
