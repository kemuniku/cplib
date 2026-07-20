---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/segtree.nim
    title: cplib/collections/segtree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/heavylightdecomposition.nim
    title: cplib/tree/heavylightdecomposition.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/graph/functional_graph_test_.nim
    title: verify/graph/functional_graph_test_.nim
  - icon: ':warning:'
    path: verify/graph/functional_graph_test_.nim
    title: verify/graph/functional_graph_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/functional_graph_lazy_op_test.nim
    title: verify/AI/functional_graph_lazy_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/functional_graph_lazy_op_test.nim
    title: verify/AI/functional_graph_lazy_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/functional_graph_test.nim
    title: verify/AI/functional_graph_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/functional_graph_test.nim
    title: verify/AI/functional_graph_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_FUNCTIONALGRAPH:\n    const CPLIB_GRAPH_FUNCTIONALGRAPH*\
    \ = 1\n    import sequtils\n    import cplib/graph/graph\n    import cplib/tree/heavylightdecomposition\n\
    \    type Functional_Graph* = ref object \n        tree* : HeavyLightDecomposition\n\
    \        cycle_number* : seq[int]\n        cycle_idx* : seq[int]\n        roots*\
    \ : seq[int]\n        cycle* : seq[seq[int]]\n        depth_tin : seq[seq[int]]\n\
    \        cycle_depth : seq[seq[seq[int]]]\n        component_size : seq[int]\n\
    \n    proc initFunctionalGraph*(v:openArray[int]):Functional_Graph=\n        let\
    \ n = len(v)\n        var removed = newSeqOfCap[int](n)\n        var sizes = newseqwith(n,0)\n\
    \        var cycle_number = newseqwith(n,-1)\n        var cycle_idx = newseqwith(n,-1)\n\
    \        var parent = newSeqWith(n+1,-1)\n        var roots = newseqwith(n,0)\n\
    \        var cycle : seq[seq[int]]\n        for i in 0..<n:\n            assert\
    \ 0 <= v[i] and v[i] < n\n            sizes[v[i]] += 1\n        for i in 0..<n:\n\
    \            if sizes[i] == 0:\n                removed.add(i)\n        var removed_idx\
    \ = 0\n        while removed_idx < len(removed):\n            let i = removed[removed_idx]\n\
    \            removed_idx += 1\n            let j = v[i]\n            parent[i]\
    \ = j\n            sizes[j] -= 1\n            if sizes[j] == 0:\n            \
    \    removed.add(j)\n\n        var alr = newseqwith(n,false)\n        for i in\
    \ 0..<n:\n            if sizes[i] != 0 and not alr[i]:\n                let cycle_n\
    \ = len(cycle)\n                var now = i\n                cycle.add(@[])\n\
    \                while not alr[now]:\n                    alr[now] = true\n  \
    \                  cycle_number[now] = cycle_n\n                    cycle_idx[now]\
    \ = len(cycle[cycle_n])\n                    roots[now] = now\n              \
    \      cycle[cycle_n].add(now)\n                    parent[now] = n\n        \
    \            now = v[now]\n        # \u524A\u9664\u9806\u306E\u9006\u304B\u3089\
    \u898B\u308C\u3070\u3001\u9077\u79FB\u5148\u306Eroot\u306F\u65E2\u306B\u6C7A\u307E\
    \u3063\u3066\u3044\u308B\u3002\n        var i = len(removed)\n        while i\
    \ > 0:\n            i -= 1\n            let x = removed[i]\n            roots[x]\
    \ = roots[v[x]]\n\n        result = Functional_Graph(\n            tree:initHldFromParent(parent,n),\n\
    \            cycle_number:cycle_number,\n            roots:roots,\n          \
    \  cycle:cycle,\n            cycle_idx:cycle_idx\n        )\n\n        # depth\u3054\
    \u3068\u306BHLD\u306EEuler Tour\u4E0A\u306E\u4F4D\u7F6E\u3092\u6607\u9806\u3067\
    \u6301\u3064\u3002\n        result.depth_tin = newSeq[seq[int]](n)\n        for\
    \ tin in 0..<result.tree.N:\n            let x = result.tree.toVtx(tin)\n    \
    \        if x < n:\n                let d = result.tree.depth(x)-1\n         \
    \       result.depth_tin[d].add(tin)\n\n        # cycle\u3054\u3068\u306B (cycle_idx[root]-depth)\
    \ mod cycle_size \u3067\u5206\u985E\u3057\u3001\n        # \u5404\u5217\u306B\u306F\
    depth\u3092\u6607\u9806\u3067\u6301\u3064\u3002\n        result.cycle_depth =\
    \ newSeq[seq[seq[int]]](len(cycle))\n        result.component_size = newSeq[int](len(cycle))\n\
    \        for cid in 0..<len(cycle):\n            result.cycle_depth[cid] = newSeq[seq[int]](len(cycle[cid]))\n\
    \        for d in 0..<len(result.depth_tin):\n            for tin in result.depth_tin[d]:\n\
    \                let v = result.tree.toVtx(tin)\n                let root = roots[v]\n\
    \                let cid = cycle_number[root]\n                let csiz = len(cycle[cid])\n\
    \                let residue = (cycle_idx[root]-(d mod csiz)+csiz) mod csiz\n\
    \                result.cycle_depth[cid][residue].add(d)\n                result.component_size[cid]\
    \ += 1\n\n    proc initFunctionalGraph*(graph:UnWeightedDirectedGraph):Functional_Graph=\n\
    \        var v = newSeq[int](len(graph))\n        for i in 0..<len(graph):\n \
    \           for j in graph[i]:\n                v[i] = j\n        return initFunctionalGraph(v)\n\
    \n    proc incycle*(namori:Functional_Graph,x:int):bool=\n        return namori.cycle_number[x]\
    \ != -1\n\n    proc movekth*(functional_graph:Functional_Graph,x,cnt:int):int=\n\
    \        #x\u304B\u3089cnt\u56DE\u52D5\u3044\u305F\u3089\u3069\u3053\u306B\u884C\
    \u304F\u304B\n        if functional_graph.tree.depth(x)-1 >= cnt:\n          \
    \  return functional_graph.tree.la(x,len(functional_graph.cycle_number),cnt)\n\
    \        else:\n            var root = functional_graph.roots[x]\n           \
    \ var cnt = cnt-(functional_graph.tree.depth(x)-1)\n            return functional_graph.cycle[functional_graph.cycle_number[root]][(functional_graph.cycle_idx[root]+cnt)\
    \ mod len(functional_graph.cycle[functional_graph.cycle_number[root]])]\n\n  \
    \  proc cyclesize*(functional_graph:Functional_Graph,x:int):int=\n        ## x\u304B\
    \u3089\u5230\u9054\u3059\u308B\u3053\u3068\u304C\u3067\u304D\u308B\u30B5\u30A4\
    \u30AF\u30EB\u306E\u30B5\u30A4\u30BA\n        var root = functional_graph.roots[x]\n\
    \        return functional_graph.cycle[functional_graph.cycle_number[root]].len()\n\
    \n    proc canmove_size*(functional_graph:Functional_Graph,x:int):int=\n     \
    \   ## x\u304B\u3089\u5230\u9054\u3059\u308B\u3053\u3068\u306E\u3067\u304D\u308B\
    \u9802\u70B9\u6570(x\u3082\u542B\u3080)\n        return functional_graph.tree.depth(x)-1+functional_graph.cyclesize(x)\n\
    \n    proc reachable_to_size*(functional_graph:Functional_Graph,x:int):int=\n\
    \        ## x\u306B\u5230\u9054\u3059\u308B\u3053\u3068\u306E\u3067\u304D\u308B\
    \u9802\u70B9\u6570(x\u3082\u542B\u3080)\n        if functional_graph.incycle(x):\n\
    \            return functional_graph.component_size[functional_graph.cycle_number[x]]\n\
    \        let (l,r) = functional_graph.tree.subtree(x)\n        return r-l\n\n\
    \    proc depth*(functional_graph:Functional_Graph,x:int):int=\n        ## \u4F55\
    \u56DE\u306E\u79FB\u52D5\u3067cycle\u306B\u5165\u308B\u304B\n        return functional_graph.tree.depth(x)-1\n\
    \n    proc dist*(functional_graph:Functional_Graph,u,v:int):int=\n        ## u\u304B\
    \u3089v\u3078\u6700\u77ED\u4F55\u56DE\u306E\u79FB\u52D5\u3067\u5230\u9054\u304C\
    \u53EF\u80FD\u304B\n        ## \u305F\u3060\u3057\u3001\u5230\u9054\u3067\u304D\
    \u306A\u3044\u3068\u304D\u306F-1\u3092\u8FD4\u3059\u3002\n        if functional_graph.cycle_number[functional_graph.roots[u]]\
    \ != functional_graph.cycle_number[functional_graph.roots[v]]:\n            return\
    \ -1\n        var lca = functional_graph.tree.lca(u,v)\n        if lca == v:\n\
    \            return functional_graph.tree.depth(u)-functional_graph.tree.depth(v)\n\
    \        if lca == len(functional_graph.cycle_number):\n            if functional_graph.incycle(v):\n\
    \                var x = functional_graph.cycle_idx[functional_graph.roots[u]]\n\
    \                var y = functional_graph.cycle_idx[v]\n                if x <\
    \ y:\n                    return y-x+functional_graph.depth(u)\n             \
    \   else:\n                    return y+len(functional_graph.cycle[functional_graph.cycle_number[v]])-x+functional_graph.depth(u)\n\
    \        return -1\n\n    proc get_cycle*(functional_graph:Functional_Graph,x:int):seq[int]=\n\
    \        ## x\u304B\u3089\u5230\u9054\u3067\u304D\u308B\u30B5\u30A4\u30AF\u30EB\
    \u3092\u8FD4\u3059\n        var root = functional_graph.roots[x]\n        return\
    \ functional_graph.cycle[functional_graph.cycle_number[root]]\n\n    proc root*(functional_graph:Functional_Graph,x:int):int=\n\
    \        ## x\u304B\u3089\u9032\u3093\u3067\u3044\u3063\u305F\u3068\u304D\u306B\
    \u3001\u521D\u3081\u3066\u30B5\u30A4\u30AF\u30EB\u306B\u5165\u3063\u305F\u3068\
    \u304D\u306E\u9802\u70B9\u3092\u8FD4\u3059\n        return functional_graph.roots[x]\n\
    \n    proc compressed_forest*(functional_graph:Functional_Graph):(UnWeightedUnDirectedGraph,seq[int],seq[int])=\n\
    \        ## \u5404\u30B5\u30A4\u30AF\u30EB\u30921\u9802\u70B9\u306B\u5727\u7E2E\
    \u3057\u305F\u6839\u4ED8\u304D\u68EE\u3092\u8FD4\u3059\u3002O(N)\n        ## \u8FD4\
    \u308A\u5024\u306F (\u68EE, \u5143\u306E\u9802\u70B9\u304B\u3089\u5727\u7E2E\u5F8C\
    \u306E\u9802\u70B9\u3078\u306E\u5BFE\u5FDC, \u5404\u6728\u306E\u6839) \u3002\n\
    \        ## \u6839\u306F functional_graph.cycle \u3068\u540C\u3058\u9806\u756A\
    \u3067\u4E26\u3076\u3002\n        let n = len(functional_graph.cycle_number)\n\
    \        var compressed = newSeqWith(n,-1)\n        var roots = newSeq[int](len(functional_graph.cycle))\n\
    \        var compressed_n = 0\n\n        for cid,cycle in functional_graph.cycle:\n\
    \            roots[cid] = compressed_n\n            for v in cycle:\n        \
    \        compressed[v] = compressed_n\n            compressed_n += 1\n\n     \
    \   for v in 0..<n:\n            if compressed[v] == -1:\n                compressed[v]\
    \ = compressed_n\n                compressed_n += 1\n\n        var forest = initUnWeightedUnDirectedGraph(compressed_n)\n\
    \        for v in 0..<n:\n            if not functional_graph.incycle(v):\n  \
    \              forest.add_edge(compressed[v],compressed[functional_graph.tree.P[v]])\n\
    \n        return (forest,compressed,roots)\n\n    proc walk*(functional_graph:Functional_Graph,x,k:int):seq[int]=\n\
    \        ## x\u3092\u59CB\u70B9\u3068\u3057\u3066k\u56DE\u79FB\u52D5\u3059\u308B\
    \u307E\u3067\u306B\u8A2A\u308C\u308B\u9802\u70B9\u3092\u3001\u59CB\u70B9\u3092\
    \u542B\u3080\u9577\u3055k+1\u306E\u914D\u5217\u3067\u8FD4\u3059\u3002O(k)\n  \
    \      let n = len(functional_graph.cycle_number)\n        assert 0 <= x and x\
    \ < n\n        assert 0 <= k and k < high(int)\n        result = newSeq[int](k+1)\n\
    \        var now = x\n        for i in 0..k:\n            result[i] = now\n  \
    \          if i < k:\n                if functional_graph.incycle(now):\n    \
    \                let cid = functional_graph.cycle_number[now]\n              \
    \      let next_idx = (functional_graph.cycle_idx[now]+1) mod len(functional_graph.cycle[cid])\n\
    \                    now = functional_graph.cycle[cid][next_idx]\n           \
    \     else:\n                    now = functional_graph.tree.P[now]\n\n    import\
    \ cplib/collections/segtree\n    import algorithm\n\n    proc count_kth*(functional_graph:Functional_Graph,x,k:int):int=\n\
    \        ## \u5404\u9802\u70B9\u306B\u30B3\u30DE\u30921\u3064\u305A\u3064\u7F6E\
    \u3044\u3066k\u56DE\u79FB\u52D5\u3057\u305F\u3068\u304D\u3001\u9802\u70B9x\u306B\
    \u3042\u308B\u30B3\u30DE\u306E\u6570\n        ## O(log N)\n        assert 0 <=\
    \ x and x < len(functional_graph.cycle_number)\n        assert k >= 0\n      \
    \  if not functional_graph.incycle(x):\n            let d = functional_graph.depth(x)\n\
    \            if k > functional_graph.depth_tin.high-d:\n                return\
    \ 0\n            let (l,r) = functional_graph.tree.subtree(x)\n            let\
    \ tins = functional_graph.depth_tin[d+k]\n            return tins.lowerBound(r)-tins.lowerBound(l)\n\
    \n        let cid = functional_graph.cycle_number[x]\n        let csiz = len(functional_graph.cycle[cid])\n\
    \        let residue = (functional_graph.cycle_idx[x]-(k mod csiz)+csiz) mod csiz\n\
    \        return functional_graph.cycle_depth[cid][residue].upperBound(k)\n\n \
    \   type FunctionalGraph_with_op*[T] = ref object\n        F : Functional_Graph\n\
    \        op : proc(x,y:T):T\n        e : T\n        st_hld : SegmentTree[T]\n\
    \        st_cycle : SegmentTree[T]\n        cum_cyclesize : seq[int]\n\n    proc\
    \ initFunctionalGraph_with_op[T](F:Functional_Graph,values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=\n\
    \        assert len(values) == len(F.cycle_number)\n        result = FunctionalGraph_with_op[T](\n\
    \            F : F,\n            op : op,\n            e : e\n        )\n    \
    \    result.cum_cyclesize = newSeq[int](len(result.F.cycle))\n        var vec\
    \ = (0..<(len(values)+1)).toseq().mapit(result.F.tree.toVtx(it)).mapit(if it <\
    \ len(values) : values[it] else: e).reversed()\n        result.st_hld = initSegmentTree(vec,op,e)\n\
    \        var tmp = newSeqOfCap[T](len(values))\n        for i in 0..<(len(result.F.cycle)):\n\
    \            result.cum_cyclesize[i] = if i == 0 : 0 else: result.cum_cyclesize[i-1]\
    \ + len(result.F.cycle[i-1])\n            for j in 0..<(len(result.F.cycle[i])):\n\
    \                tmp.add(values[result.F.cycle[i][j]])\n        result.st_cycle\
    \ = initSegmentTree(tmp,op,e)\n\n    proc initFunctionalGraph_with_op*[T](G:UnWeightedDirectedGraph,values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=\n\
    \        return initFunctionalGraph_with_op(initFunctionalGraph(G),values,op,e)\n\
    \    \n    proc initFunctionalGraph_with_op*[T](A:openArray[int],values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=\n\
    \        return initFunctionalGraph_with_op(initFunctionalGraph(A),values,op,e)\n\
    \n    proc incycle*[T](self:FunctionalGraph_with_op[T],x:int):bool=\n        return\
    \ self.F.incycle(x)\n\n    proc movekth*[T](self:FunctionalGraph_with_op[T],x,cnt:int):int=\n\
    \        return self.F.movekth(x,cnt)\n\n    proc cyclesize*[T](self:FunctionalGraph_with_op[T],x:int):int=\n\
    \        return self.F.cyclesize(x)\n\n    proc canmove_size*[T](self:FunctionalGraph_with_op[T],x:int):int=\n\
    \        return self.F.canmove_size(x)\n\n    proc reachable_to_size*[T](self:FunctionalGraph_with_op[T],x:int):int=\n\
    \        return self.F.reachable_to_size(x)\n\n    proc depth*[T](self:FunctionalGraph_with_op[T],x:int):int=\n\
    \        return self.F.depth(x)\n\n    proc dist*[T](self:FunctionalGraph_with_op[T],u,v:int):int=\n\
    \        return self.F.dist(u,v)\n\n    proc get_cycle*[T](self:FunctionalGraph_with_op[T],x:int):seq[int]=\n\
    \        return self.F.get_cycle(x)\n\n    proc root*[T](self:FunctionalGraph_with_op[T],x:int):int=\n\
    \        return self.F.root(x)\n\n    proc walk*[T](self:FunctionalGraph_with_op[T],x,k:int):seq[int]=\n\
    \        return self.F.walk(x,k)\n\n    proc count_kth*[T](self:FunctionalGraph_with_op[T],x,k:int):int=\n\
    \        return self.F.count_kth(x,k)\n    \n    proc set*[T](self:FunctionalGraph_with_op[T],x:int,value:T)=\n\
    \        self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(x)] = value\n        if\
    \ self.F.incycle(x):\n            self.st_cycle[self.cum_cyclesize[self.F.cycle_number[x]]\
    \ + self.F.cycle_idx[x]] = value\n    proc `[]=`*[T](self:FunctionalGraph_with_op[T],x:int,value:T)=\n\
    \        self.set(x,value)\n\n    proc prod_reachable_idempotent_all*[T](self:FunctionalGraph_with_op[T]):seq[T]=\n\
    \        ## \u5404\u9802\u70B9\u304B\u3089\u5230\u9054\u53EF\u80FD\u306A\u76F8\
    \u7570\u306A\u308B\u9802\u70B9\u306E\u5024\u306E\u7A4D\u3092\u5168\u9802\u70B9\
    \u306B\u3064\u3044\u3066\u8FD4\u3059\u3002\n        ## op\u306F\u7D50\u5408\u7684\
    \u30FB\u53EF\u63DB\u30FB\u51AA\u7B49\u3067\u306A\u3051\u308C\u3070\u306A\u3089\
    \u306A\u3044\u3002O(N)\n        let n = len(self.F.cycle_number)\n        result\
    \ = newSeqWith(n,self.e)\n\n        template value(v:int):T = self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(v)]\n\
    \n        # \u30B5\u30A4\u30AF\u30EB\u4E0A\u3067\u306F\u958B\u59CB\u4F4D\u7F6E\
    \u306B\u3088\u3089\u305A\u3001\u30B5\u30A4\u30AF\u30EB\u5168\u4F53\u306E\u7A4D\
    \u306B\u306A\u308B\u3002\n        for cycle in self.F.cycle:\n            var\
    \ cycle_prod = self.e\n            for v in cycle:\n                cycle_prod\
    \ = self.op(cycle_prod,value(v))\n            for v in cycle:\n              \
    \  result[v] = cycle_prod\n\n        # HLD\u306E\u69CB\u7BC9\u9806\u3067\u306F\
    \u89AA\uFF08\u9077\u79FB\u5148\uFF09\u304C\u5B50\u3088\u308A\u5148\u306B\u73FE\
    \u308C\u308B\u3002\n        for v in self.F.tree.I:\n            if v < n and\
    \ not self.F.incycle(v):\n                result[v] = self.op(value(v),result[self.F.tree.P[v]])\n\
    \n    proc prod*[T](self:FunctionalGraph_with_op[T],start:int,k:int,include_start:bool=true):T=\n\
    \        ## start\u304B\u3089k\u56DE\u79FB\u52D5\u3059\u308B\u307E\u3067\u306E\
    \u7A4D\u3002include_start=false\u306A\u3089\u59CB\u70B9\u3092\u7A4D\u306B\u542B\
    \u3081\u306A\u3044\u3002\n        assert k >= 0\n        if not include_start:\n\
    \            if k == 0:\n                return self.e\n            return self.prod(self.F.movekth(start,1),k-1)\n\
    \        result = self.e\n        var root = self.F.roots[start]\n        var\
    \ tmp = root\n        var flag = false\n        if self.F.depth(start) > k:\n\
    \            tmp = self.F.movekth(start,k)\n            flag = true\n        for\
    \ (l,r) in self.F.tree.path(tmp,start,flag,true):\n            result = self.op(result,self.st_hld.get(l,r))\n\
    \        if not flag:\n            var cid = self.F.cycle_number[root]\n     \
    \       var csiz = self.F.cyclesize(start)\n            var k = k - self.F.depth(start)\
    \ + 1\n            \n            # csiz\u3054\u3068\u9032\u3080\u51E6\u7406\n\
    \            var x = k div csiz\n            var v : T\n            var root_idx\
    \ = self.F.cycle_idx[root]\n            if root_idx == 0:\n                v =\
    \ self.st_cycle[self.cum_cyclesize[cid]..<(csiz+self.cum_cyclesize[cid])]\n  \
    \          else:\n                v = self.op(self.st_cycle[(root_idx + self.cum_cyclesize[cid])..<(csiz+self.cum_cyclesize[cid])],\n\
    \                            self.st_cycle[self.cum_cyclesize[cid]..<(root_idx+self.cum_cyclesize[cid])]\n\
    \                )\n            \n            \n            while x > 0:\n   \
    \             if (x and 1) == 1:\n                    result = self.op(result,v)\n\
    \                v = self.op(v,v)\n                x = x shr 1\n            \n\
    \n            # \u4F59\u308A\u3092\u51E6\u7406\n            var l = self.F.cycle_idx[root]\n\
    \            var m = k mod csiz\n            var r = l + m\n            if r <=\
    \ csiz:\n                result = self.op(result,self.st_cycle[(l+self.cum_cyclesize[cid])..<(r+self.cum_cyclesize[cid])])\n\
    \            else:\n                result = self.op(result,self.st_cycle[(l+self.cum_cyclesize[cid])..<(csiz+self.cum_cyclesize[cid])])\n\
    \                result = self.op(result,self.st_cycle[(self.cum_cyclesize[cid])..<(r-csiz+self.cum_cyclesize[cid])])\n\
    \n    proc prod_range*[T](self:FunctionalGraph_with_op[T],start,l,r:int,include_start:bool=true):seq[T]=\n\
    \        ## @[prod(start,l), ..., prod(start,r-1)]\u3092\u8FD4\u3059\u3002O(log^2\
    \ N + log l + (r-l))\n        assert 0 <= start and start < len(self.F.cycle_number)\n\
    \        assert 0 <= l and l <= r\n        result = newSeq[T](r-l)\n        if\
    \ len(result) == 0:\n            return\n\n        result[0] = self.prod(start,l,include_start)\n\
    \        if len(result) == 1:\n            return\n\n        var now = self.F.movekth(start,l+1)\n\
    \        for i in 1..<len(result):\n            let value = self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(now)]\n\
    \            result[i] = self.op(result[i-1],value)\n            if i+1 < len(result):\n\
    \                if self.F.incycle(now):\n                    let cid = self.F.cycle_number[now]\n\
    \                    let next_idx = (self.F.cycle_idx[now]+1) mod len(self.F.cycle[cid])\n\
    \                    now = self.F.cycle[cid][next_idx]\n                else:\n\
    \                    now = self.F.tree.P[now]\n\n    proc prod_range_fold*[T](self:FunctionalGraph_with_op[T],start,l,r:int,f:proc(l,r:T):T,e:T,include_start:bool=true):T=\n\
    \        ## prod(start,l), ..., prod(start,r-1)\u3092\u9806\u306Bf\u3067\u7573\
    \u307F\u8FBC\u3080\u3002O(log^2 N + log l + (r-l))\n        assert 0 <= start\
    \ and start < len(self.F.cycle_number)\n        assert 0 <= l and l <= r\n   \
    \     if l == r:\n            return e\n\n        var prefix_prod = self.prod(start,l,include_start)\n\
    \        result = f(e,prefix_prod)\n        if l+1 == r:\n            return\n\
    \n        var now = self.F.movekth(start,l+1)\n        for k in (l+1)..<r:\n \
    \           let value = self.st_hld[self.F.tree.N-1-self.F.tree.toSeq(now)]\n\
    \            prefix_prod = self.op(prefix_prod,value)\n            result = f(result,prefix_prod)\n\
    \            if k+1 < r:\n                if self.F.incycle(now):\n          \
    \          let cid = self.F.cycle_number[now]\n                    let next_idx\
    \ = (self.F.cycle_idx[now]+1) mod len(self.F.cycle[cid])\n                   \
    \ now = self.F.cycle[cid][next_idx]\n                else:\n                 \
    \   now = self.F.tree.P[now]\n    \n    proc move_while*[T](self:FunctionalGraph_with_op[T],f:proc(x:T):bool,x,L:int):int=\n\
    \        # \u6570\u5217\u3092 @[x] \u304B\u3089\u30B9\u30BF\u30FC\u30C8\u3057\u3001\
    f(\u6570\u5217\u306Eprod)\u304C\u521D\u3081\u3066false\u306B\u306A\u308B\u307E\
    \u3067\u306E\u79FB\u52D5\u8DDD\u96E2\u3092\u8FD4\u3059\u3002\n        # \u305F\
    \u3060\u3057\u3001\u79FB\u52D5\u8DDD\u96E2\u306E\u4E0A\u9650\u306FL\u3068\u3059\
    \u308B\uFF08L\u56DE\u79FB\u52D5\u3057\u3066\u3082true\u306A\u3089L\u3092\u8FD4\
    \u3059\uFF09\u3002\n        assert L >= 0\n        let limit = L+1 # \u79FB\u52D5\
    \u8DDD\u96E2L\u306F\u3001\u59CB\u70B9\u3092\u542B\u3081\u3066L+1\u9802\u70B9\n\
    \        var value = self.e\n        var used = 0\n\n        # x\u304B\u3089\u30B5\
    \u30A4\u30AF\u30EB\u5165\u53E3\u307E\u3067\u3002st_hld\u306FHLD\u9806\u3092\u53CD\
    \u8EE2\u3057\u3066\u69CB\u7BC9\u3055\u308C\u3066\u3044\u308B\u305F\u3081\u3001\
    \n        # path(...,true)\u306E\u5404\u533A\u9593\u3092\u5DE6\u304B\u3089\u898B\
    \u308B\u3068functional graph\u4E0A\u306E\u79FB\u52D5\u9806\u306B\u306A\u308B\u3002\
    \n        let root = self.F.roots[x]\n        let tree_path = self.F.tree.path(root,x,true,true)\n\
    \n        # max_right\u306B\u306Ff(\u5358\u4F4D\u5143)=true\u304C\u5FC5\u8981\u306A\
    \u306E\u3067\u3001\u59CB\u70B9\u3060\u3051\u5148\u306B\u51E6\u7406\u3059\u308B\
    \u3002\n        value = self.st_hld[tree_path[0][0]]\n        if not f(value):\n\
    \            return 0\n        used = 1\n        if used == limit:\n         \
    \   return L\n\n        var first_segment = true\n        for (l,r) in tree_path:\n\
    \            let nl = l+int(first_segment) # \u59CB\u70B9\u306F\u51E6\u7406\u6E08\
    \u307F\n            first_segment = false\n            let nr = min(r,nl+limit-used)\n\
    \            if nl < nr:\n                let max_right = self.st_hld.max_right(nl,proc(v:T):bool=\n\
    \                    f(self.op(value,v))\n                )\n                if\
    \ max_right < nr:\n                    used += max_right-nl\n                \
    \    return used\n                value = self.op(value,self.st_hld.get(nl,nr))\n\
    \                used += nr-nl\n            if used == limit:\n              \
    \  return L\n\n        let cid = self.F.cycle_number[root]\n        let csiz =\
    \ self.F.cyclesize(x)\n        let offset = self.cum_cyclesize[cid]\n        let\
    \ cycle_start = (self.F.cycle_idx[root]+1) mod csiz\n\n        proc cycle_prod(l,r:int):T=\n\
    \            return self.st_cycle.get(offset+l,offset+r)\n\n        # cycle_start\u304B\
    \u3089\u3061\u3087\u3046\u30691\u5468\u3059\u308B\u7A4D\u3002\u975E\u53EF\u63DB\
    \u306Aop\u3067\u3082\u9806\u5E8F\u3092\u4FDD\u3064\u3002\n        let one_cycle\
    \ = self.op(\n            cycle_prod(cycle_start,csiz),\n            cycle_prod(0,cycle_start)\n\
    \        )\n\n        # \u5165\u308C\u3089\u308C\u308B\u5B8C\u5168\u306A\u5468\
    \u56DE\u6570\u3092\u3001\u5468\u56DE\u7A4D\u306E\u30C0\u30D6\u30EA\u30F3\u30B0\
    \u3067\u6C42\u3081\u308B\u3002\n        let max_cycles = (limit-used) div csiz\n\
    \        if max_cycles > 0:\n            var powers = @[one_cycle]\n         \
    \   var block_size = 1\n            while block_size <= max_cycles div 2:\n  \
    \              powers.add(self.op(powers[^1],powers[^1]))\n                block_size\
    \ *= 2\n\n            var accepted = 0\n            for i in countdown(powers.high,0):\n\
    \                let cnt = 1 shl i\n                if cnt <= max_cycles-accepted:\n\
    \                    let next_value = self.op(value,powers[i])\n             \
    \       if f(next_value):\n                        value = next_value\n      \
    \                  accepted += cnt\n            used += accepted*csiz\n      \
    \      if used == limit:\n                return L\n\n        # \u6700\u5927\u5468\
    \u56DE\u6570\u306E\u6B21\u306E1\u5468\u5185\u3067\u6B62\u307E\u308B\u3002\u9AD8\
    \u30052\u533A\u9593\u3092max_right\u3059\u308C\u3070\u3088\u3044\u3002\n     \
    \   var rest = min(limit-used,csiz)\n        proc consume_cycle(l,r:int):bool=\n\
    \            if l == r:\n                return true\n            let nr = self.st_cycle.max_right(offset+l,proc(v:T):bool=\n\
    \                f(self.op(value,v))\n            )\n            if nr < offset+r:\n\
    \                used += nr-(offset+l)\n                return false\n       \
    \     value = self.op(value,cycle_prod(l,r))\n            used += r-l\n      \
    \      return true\n\n        let first = min(rest,csiz-cycle_start)\n       \
    \ if not consume_cycle(cycle_start,cycle_start+first):\n            return used\n\
    \        rest -= first\n        if rest > 0 and not consume_cycle(0,rest):\n \
    \           return used\n        return used-1\n\n    import atcoder/lazysegtree\n\
    \n    type FunctionalGraph_with_lazy_op*[ST] = ref object\n        ## ACL\u306E\
    \u9045\u5EF6\u30BB\u30B0\u30E1\u30F3\u30C8\u6728\u3092\u7528\u3044\u3066\u3001\
    functional graph\u4E0A\u306E\u7A4D\u3068\u7D4C\u8DEF\u4F5C\u7528\u3092\u6271\u3046\
    \u3002\n        ## \u975E\u30B5\u30A4\u30AF\u30EB\u9802\u70B9\u306Fst_hld\u3001\
    \u30B5\u30A4\u30AF\u30EB\u9802\u70B9\u306Fst_cycle\u3060\u3051\u306B\u4FDD\u6301\
    \u3059\u308B\u3002\n        graph : Functional_Graph\n        st_hld : ST\n  \
    \      st_cycle : ST\n        cum_cyclesize : seq[int]\n\n    proc initFunctionalGraph_with_lazy_op_impl[S,ST](\n\
    \        graph:Functional_Graph,\n        values:seq[S],\n        st_type:typedesc[ST]\n\
    \    ):FunctionalGraph_with_lazy_op[ST]=\n        assert len(values) == len(graph.cycle_number)\n\
    \        result = FunctionalGraph_with_lazy_op[ST](graph:graph)\n\n        # HLD\u5074\
    \u3067\u306F\u30B5\u30A4\u30AF\u30EB\u9802\u70B9\u3092\u5358\u4F4D\u5143\u306B\
    \u3059\u308B\u3002\u30B5\u30A4\u30AF\u30EB\u9802\u70B9\u307E\u3067\u91CD\u8907\
    \u4FDD\u6301\u3059\u308B\u3068\u3001\n        # \u30B5\u30A4\u30AF\u30EB\u533A\
    \u9593\u3078\u306E\u9045\u5EF6\u4F5C\u7528\u3092HLD\u5074\u3078\u9AD8\u901F\u306B\
    \u540C\u671F\u3067\u304D\u306A\u3044\u305F\u3081\u3002\n        var hld_values\
    \ = newSeqWith(graph.tree.N,ST.calc_e())\n        for v in 0..<len(values):\n\
    \            if not graph.incycle(v):\n                hld_values[graph.tree.N-1-graph.tree.toSeq(v)]\
    \ = values[v]\n        result.st_hld = ST.init(hld_values)\n\n        result.cum_cyclesize\
    \ = newSeq[int](len(graph.cycle))\n        var cycle_values = newSeqOfCap[S](len(values))\n\
    \        for cid,cycle in graph.cycle:\n            if cid > 0:\n            \
    \    result.cum_cyclesize[cid] = result.cum_cyclesize[cid-1] + len(graph.cycle[cid-1])\n\
    \            for v in cycle:\n                cycle_values.add(values[v])\n  \
    \      result.st_cycle = ST.init(cycle_values)\n\n    proc initFunctionalGraph_with_lazy_op*[S,ST](\n\
    \        source:Functional_Graph,\n        values:seq[S],\n        st_type:typedesc[ST]\n\
    \    ):FunctionalGraph_with_lazy_op[ST]=\n        ## \u660E\u793A\u3057\u305F\
    ACL LazySegTree\u578BST\u3092\u4F7F\u3063\u3066\u69CB\u7BC9\u3059\u308B\u3002\
    O(N)\n        ## \u8907\u6570\u306Efunctional graph\u3092\u540C\u3058\u578B\u3068\
    \u3057\u3066\u4FDD\u6301\u3057\u305F\u3044\u5834\u5408\u306B\u7528\u3044\u308B\
    \u3002\n        return initFunctionalGraph_with_lazy_op_impl(source,values,st_type)\n\
    \n    proc initFunctionalGraph_with_lazy_op*[S,ST](\n        source:UnWeightedDirectedGraph,\n\
    \        values:seq[S],\n        st_type:typedesc[ST]\n    ):FunctionalGraph_with_lazy_op[ST]=\n\
    \        return initFunctionalGraph_with_lazy_op_impl(initFunctionalGraph(source),values,st_type)\n\
    \n    proc initFunctionalGraph_with_lazy_op*[S,ST](\n        source:openArray[int],\n\
    \        values:seq[S],\n        st_type:typedesc[ST]\n    ):FunctionalGraph_with_lazy_op[ST]=\n\
    \        return initFunctionalGraph_with_lazy_op_impl(initFunctionalGraph(source),values,st_type)\n\
    \n    template initFunctionalGraph_with_lazy_op*(source,values,op,e,mapping,composition,id:untyped):untyped=\n\
    \        ## ACL\u306Elazysegtree\u3068\u540C\u3058op/e/mapping/composition/id\u304B\
    \u3089\u69CB\u7BC9\u3059\u308B\u3002O(N)\n        block:\n            type S =\
    \ typeof(values[0])\n            type Action = typeof(id())\n            type\
    \ ST = typeof(initLazySegTree[S,Action](values,op,e,mapping,composition,id))\n\
    \            initFunctionalGraph_with_lazy_op(source,values,ST)\n\n    template\
    \ initFunctionalGraph_with_op*(source,values,op,e,mapping,composition,id:untyped):untyped=\n\
    \        ## \u9045\u5EF6\u4F5C\u7528\u3092\u4F7F\u3046\u5834\u5408\u306EinitFunctionalGraph_with_op\u30AA\
    \u30FC\u30D0\u30FC\u30ED\u30FC\u30C9\u3002\n        initFunctionalGraph_with_lazy_op(source,values,op,e,mapping,composition,id)\n\
    \n    proc incycle*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):bool=\n \
    \       return self.graph.incycle(x)\n\n    proc movekth*[ST](self:FunctionalGraph_with_lazy_op[ST],x,cnt:int):int=\n\
    \        return self.graph.movekth(x,cnt)\n\n    proc cyclesize*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=\n\
    \        return self.graph.cyclesize(x)\n\n    proc canmove_size*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=\n\
    \        return self.graph.canmove_size(x)\n\n    proc reachable_to_size*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=\n\
    \        return self.graph.reachable_to_size(x)\n\n    proc depth*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=\n\
    \        return self.graph.depth(x)\n\n    proc dist*[ST](self:FunctionalGraph_with_lazy_op[ST],u,v:int):int=\n\
    \        return self.graph.dist(u,v)\n\n    proc get_cycle*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):seq[int]=\n\
    \        return self.graph.get_cycle(x)\n\n    proc root*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):int=\n\
    \        return self.graph.root(x)\n\n    proc walk*[ST](self:FunctionalGraph_with_lazy_op[ST],x,k:int):seq[int]=\n\
    \        return self.graph.walk(x,k)\n\n    proc count_kth*[ST](self:FunctionalGraph_with_lazy_op[ST],x,k:int):int=\n\
    \        return self.graph.count_kth(x,k)\n\n    proc lazyHldIndex[ST](self:FunctionalGraph_with_lazy_op[ST],v:int):int=\n\
    \        return self.graph.tree.N-1-self.graph.tree.toSeq(v)\n\n    proc lazyCycleIndex[ST](self:FunctionalGraph_with_lazy_op[ST],v:int):int=\n\
    \        return self.cum_cyclesize[self.graph.cycle_number[v]] + self.graph.cycle_idx[v]\n\
    \n    proc get*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):ST.S=\n     \
    \   ## \u9802\u70B9x\u306E\u73FE\u5728\u5024\u3092\u8FD4\u3059\u3002O(log N)\n\
    \        assert 0 <= x and x < len(self.graph.cycle_number)\n        if self.graph.incycle(x):\n\
    \            return self.st_cycle[self.lazyCycleIndex(x)]\n        return self.st_hld[self.lazyHldIndex(x)]\n\
    \n    proc `[]`*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int):ST.S=\n    \
    \    return self.get(x)\n\n    proc set*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int,value:ST.S)=\n\
    \        ## \u9802\u70B9x\u306E\u5024\u3092value\u306B\u5909\u66F4\u3059\u308B\
    \u3002O(log N)\n        assert 0 <= x and x < len(self.graph.cycle_number)\n \
    \       if self.graph.incycle(x):\n            self.st_cycle[self.lazyCycleIndex(x)]\
    \ = value\n        else:\n            self.st_hld[self.lazyHldIndex(x)] = value\n\
    \n    proc `[]=`*[ST](self:FunctionalGraph_with_lazy_op[ST],x:int,value:ST.S)=\n\
    \        self.set(x,value)\n\n    proc lazyActionPower[ST](self:FunctionalGraph_with_lazy_op[ST],f:ST.F,n:int):ST.F=\n\
    \        assert n >= 0\n        result = self.st_hld.calc_id()\n        var base\
    \ = f\n        var n = n\n        while n > 0:\n            if (n and 1) == 1:\n\
    \                result = self.st_hld.calc_composition(base,result)\n        \
    \    n = n shr 1\n            if n > 0:\n                base = self.st_hld.calc_composition(base,base)\n\
    \n    proc applyCyclePrefix[ST](\n        self:FunctionalGraph_with_lazy_op[ST],\n\
    \        cid,start,count:int,\n        f:ST.F\n    )=\n        ## cycle[cid]\u306E\
    start\u304B\u3089\u9077\u79FB\u9806\u306Bcount\u9802\u70B9\u3078\u4F5C\u7528\u3059\
    \u308B\u3002count\u306F1\u5468\u4EE5\u4E0B\u3002\n        let csiz = len(self.graph.cycle[cid])\n\
    \        assert 0 <= start and start < csiz\n        assert 0 <= count and count\
    \ <= csiz\n        if count == 0:\n            return\n        let offset = self.cum_cyclesize[cid]\n\
    \        let first = min(count,csiz-start)\n        self.st_cycle.apply((offset+start)..<(offset+start+first),f)\n\
    \        if first < count:\n            self.st_cycle.apply(offset..<(offset+count-first),f)\n\
    \n    proc apply*[ST](self:FunctionalGraph_with_lazy_op[ST],start,k:int,f:ST.F,include_start:bool=true)=\n\
    \        ## start\u304B\u3089k\u56DE\u79FB\u52D5\u3059\u308B\u307E\u3067\u306B\
    \u8A2A\u308C\u308B\u5404\u9802\u70B9\u3078f\u3092\u4F5C\u7528\u3055\u305B\u308B\
    \u3002\n        ## \u540C\u3058\u9802\u70B9\u3092\u8907\u6570\u56DE\u8A2A\u308C\
    \u305F\u5834\u5408\u306F\u3001\u305D\u306E\u56DE\u6570\u3060\u3051f\u3092\u4F5C\
    \u7528\u3055\u305B\u308B\u3002\n        ## include_start=false\u306A\u3089\u59CB\
    \u70B9\u306B\u306F\u4F5C\u7528\u3055\u305B\u306A\u3044\u3002O(log^2 N + log k)\n\
    \        assert 0 <= start and start < len(self.graph.cycle_number)\n        assert\
    \ 0 <= k and k < high(int)\n        if not include_start:\n            if k ==\
    \ 0:\n                return\n            self.apply(self.graph.movekth(start,1),k-1,f)\n\
    \            return\n\n        let d = self.graph.depth(start)\n        if k <\
    \ d:\n            let last = self.graph.movekth(start,k)\n            for (l,r)\
    \ in self.graph.tree.path(last,start,true,true):\n                self.st_hld.apply(l..<r,f)\n\
    \            return\n\n        let root = self.graph.roots[start]\n        for\
    \ (l,r) in self.graph.tree.path(root,start,false,true):\n            self.st_hld.apply(l..<r,f)\n\
    \n        let cid = self.graph.cycle_number[root]\n        let csiz = len(self.graph.cycle[cid])\n\
    \        let cycle_count = k-d+1\n        let full_cycles = cycle_count div csiz\n\
    \        let remainder = cycle_count mod csiz\n        let offset = self.cum_cyclesize[cid]\n\
    \        if full_cycles > 0:\n            let repeated_f = self.lazyActionPower(f,full_cycles)\n\
    \            self.st_cycle.apply(offset..<(offset+csiz),repeated_f)\n        self.applyCyclePrefix(cid,self.graph.cycle_idx[root],remainder,f)\n\
    \n    proc lazyPushAll[ST](st:var ST)=\n        ## \u89AA\u304B\u3089\u9806\u306B\
    \u9045\u5EF6\u5024\u3092\u4F1D\u64AD\u3057\u3001\u5168\u8449\u3092\u8AAD\u307F\
    \u51FA\u305B\u308B\u72B6\u614B\u306B\u3059\u308B\u3002O(len)\n        for p in\
    \ 1..<st.size:\n            st.push(p)\n\n    proc prod_reachable_idempotent_all*[ST](self:FunctionalGraph_with_lazy_op[ST]):seq[ST.S]=\n\
    \        ## \u5404\u9802\u70B9\u304B\u3089\u5230\u9054\u53EF\u80FD\u306A\u76F8\
    \u7570\u306A\u308B\u9802\u70B9\u306E\u5024\u306E\u7A4D\u3092\u5168\u9802\u70B9\
    \u306B\u3064\u3044\u3066\u8FD4\u3059\u3002\n        ## op\u306F\u7D50\u5408\u7684\
    \u30FB\u53EF\u63DB\u30FB\u51AA\u7B49\u3067\u306A\u3051\u308C\u3070\u306A\u3089\
    \u306A\u3044\u3002O(N)\n        let n = len(self.graph.cycle_number)\n       \
    \ result = newSeqWith(n,self.st_hld.calc_e())\n        self.st_hld.lazyPushAll()\n\
    \        self.st_cycle.lazyPushAll()\n\n        template value(v:int):ST.S =\n\
    \            (if self.graph.incycle(v):\n                self.st_cycle.d[self.st_cycle.size+self.lazyCycleIndex(v)]\n\
    \            else:\n                self.st_hld.d[self.st_hld.size+self.lazyHldIndex(v)])\n\
    \n        for cycle in self.graph.cycle:\n            var cycle_prod = self.st_hld.calc_e()\n\
    \            for v in cycle:\n                cycle_prod = self.st_hld.calc_op(cycle_prod,value(v))\n\
    \            for v in cycle:\n                result[v] = cycle_prod\n\n     \
    \   for v in self.graph.tree.I:\n            if v < n and not self.graph.incycle(v):\n\
    \                result[v] = self.st_hld.calc_op(value(v),result[self.graph.tree.P[v]])\n\
    \n    proc prod*[ST](self:FunctionalGraph_with_lazy_op[ST],start,k:int,include_start:bool=true):ST.S=\n\
    \        ## start\u304B\u3089k\u56DE\u79FB\u52D5\u3059\u308B\u307E\u3067\u306E\
    \u7A4D\u3002include_start=false\u306A\u3089\u59CB\u70B9\u3092\u7A4D\u306B\u542B\
    \u3081\u306A\u3044\u3002\n        ## O(log^2 N + log k)\n        assert 0 <= start\
    \ and start < len(self.graph.cycle_number)\n        assert 0 <= k and k < high(int)\n\
    \        if not include_start:\n            if k == 0:\n                return\
    \ self.st_hld.calc_e()\n            return self.prod(self.graph.movekth(start,1),k-1)\n\
    \n        result = self.st_hld.calc_e()\n        let root = self.graph.roots[start]\n\
    \        var tree_root = root\n        var ends_in_tree = false\n        if self.graph.depth(start)\
    \ > k:\n            tree_root = self.graph.movekth(start,k)\n            ends_in_tree\
    \ = true\n        for (l,r) in self.graph.tree.path(tree_root,start,ends_in_tree,true):\n\
    \            result = self.st_hld.calc_op(result,self.st_hld.prod(l..<r))\n  \
    \      if ends_in_tree:\n            return\n\n        let cid = self.graph.cycle_number[root]\n\
    \        let csiz = len(self.graph.cycle[cid])\n        let offset = self.cum_cyclesize[cid]\n\
    \        let cycle_count = k-self.graph.depth(start)+1\n        let full_cycles\
    \ = cycle_count div csiz\n        let remainder = cycle_count mod csiz\n     \
    \   let cycle_start = self.graph.cycle_idx[root]\n\n        if full_cycles > 0:\n\
    \            let one_cycle = self.st_hld.calc_op(\n                self.st_cycle.prod((offset+cycle_start)..<(offset+csiz)),\n\
    \                self.st_cycle.prod(offset..<(offset+cycle_start))\n         \
    \   )\n            var repeated = one_cycle\n            var count = full_cycles\n\
    \            while count > 0:\n                if (count and 1) == 1:\n      \
    \              result = self.st_hld.calc_op(result,repeated)\n               \
    \ count = count shr 1\n                if count > 0:\n                    repeated\
    \ = self.st_hld.calc_op(repeated,repeated)\n\n        let first = min(remainder,csiz-cycle_start)\n\
    \        if first > 0:\n            result = self.st_hld.calc_op(\n          \
    \      result,\n                self.st_cycle.prod((offset+cycle_start)..<(offset+cycle_start+first))\n\
    \            )\n        if first < remainder:\n            result = self.st_hld.calc_op(\n\
    \                result,\n                self.st_cycle.prod(offset..<(offset+remainder-first))\n\
    \            )\n\n    proc appendLazyRangeDfs[ST](\n        st:var ST,\n     \
    \   k,left,right,q_left,q_right:int,\n        values:var seq[ST.S]\n    )=\n \
    \       if right <= q_left or q_right <= left:\n            return\n        if\
    \ right-left == 1:\n            values.add(st.d[k])\n            return\n    \
    \    st.push(k)\n        let middle = (left+right) shr 1\n        st.appendLazyRangeDfs(k\
    \ shl 1,left,middle,q_left,q_right,values)\n        st.appendLazyRangeDfs((k shl\
    \ 1) or 1,middle,right,q_left,q_right,values)\n\n    proc appendLazyRange[ST](st:var\
    \ ST,q_left,q_right:int,values:var seq[ST.S])=\n        ## st[q_left..<q_right]\u306E\
    \u8449\u3092\u5DE6\u304B\u3089values\u3078\u8FFD\u52A0\u3059\u308B\u3002O(log\
    \ N + \u51FA\u529B\u9577)\n        assert 0 <= q_left and q_left <= q_right and\
    \ q_right <= st.len\n        if q_left < q_right:\n            st.appendLazyRangeDfs(1,0,st.size,q_left,q_right,values)\n\
    \n    proc walkValues[ST](self:FunctionalGraph_with_lazy_op[ST],start,count:int):seq[ST.S]=\n\
    \        ## start\u304B\u3089\u59CB\u307E\u308B\u8A2A\u554F\u5217\u306E\u5148\u982D\
    count\u9802\u70B9\u5206\u306E\u5024\u3092\u8FD4\u3059\u3002\n        ## O(log^2\
    \ N + count)\n        assert 0 <= start and start < len(self.graph.cycle_number)\n\
    \        assert count >= 0\n        result = newSeqOfCap[ST.S](count)\n      \
    \  if count == 0:\n            return\n\n        let tree_count = min(count,self.graph.depth(start))\n\
    \        if tree_count > 0:\n            let last = self.graph.movekth(start,tree_count-1)\n\
    \            for (l,r) in self.graph.tree.path(last,start,true,true):\n      \
    \          self.st_hld.appendLazyRange(l,r,result)\n\n        let cycle_count\
    \ = count-tree_count\n        if cycle_count == 0:\n            return\n     \
    \   let root = self.graph.roots[start]\n        let cid = self.graph.cycle_number[root]\n\
    \        let csiz = len(self.graph.cycle[cid])\n        let offset = self.cum_cyclesize[cid]\n\
    \        let cycle_start =\n            if self.graph.incycle(start): self.graph.cycle_idx[start]\n\
    \            else: self.graph.cycle_idx[root]\n\n        var one_cycle = newSeqOfCap[ST.S](min(cycle_count,csiz))\n\
    \        let materialize_count = min(cycle_count,csiz)\n        let first = min(materialize_count,csiz-cycle_start)\n\
    \        self.st_cycle.appendLazyRange(\n            offset+cycle_start,offset+cycle_start+first,one_cycle\n\
    \        )\n        if first < materialize_count:\n            self.st_cycle.appendLazyRange(\n\
    \                offset,offset+materialize_count-first,one_cycle\n           \
    \ )\n        for i in 0..<cycle_count:\n            result.add(one_cycle[i mod\
    \ len(one_cycle)])\n\n    proc prod_range*[ST](self:FunctionalGraph_with_lazy_op[ST],start,l,r:int,include_start:bool=true):seq[ST.S]=\n\
    \        ## @[prod(start,l), ..., prod(start,r-1)]\u3092\u8FD4\u3059\u3002\n \
    \       ## O(log^2 N + log l + (r-l))\n        assert 0 <= start and start < len(self.graph.cycle_number)\n\
    \        assert 0 <= l and l <= r and r < high(int)\n        result = newSeq[ST.S](r-l)\n\
    \        if len(result) == 0:\n            return\n\n        result[0] = self.prod(start,l,include_start)\n\
    \        if len(result) == 1:\n            return\n\n        let values = self.walkValues(self.graph.movekth(start,l+1),len(result)-1)\n\
    \        for i,value in values:\n            result[i+1] = self.st_hld.calc_op(result[i],value)\n\
    \n    proc prod_range_fold*[ST,U](self:FunctionalGraph_with_lazy_op[ST],start,l,r:int,f:proc(x:U,y:ST.S):U,e:U,include_start:bool=true):U=\n\
    \        ## prod(start,l), ..., prod(start,r-1)\u3092\u9806\u306Bf\u3067\u7573\
    \u307F\u8FBC\u3080\u3002\n        ## O(log^2 N + log l + (r-l))\n        assert\
    \ 0 <= start and start < len(self.graph.cycle_number)\n        assert 0 <= l and\
    \ l <= r and r < high(int)\n        if l == r:\n            return e\n\n     \
    \   var prefix_prod = self.prod(start,l,include_start)\n        result = f(e,prefix_prod)\n\
    \        if l+1 == r:\n            return\n\n        let values = self.walkValues(self.graph.movekth(start,l+1),r-l-1)\n\
    \        for value in values:\n            prefix_prod = self.st_hld.calc_op(prefix_prod,value)\n\
    \            result = f(result,prefix_prod)\n\n    proc move_while*[ST](\n   \
    \     self:FunctionalGraph_with_lazy_op[ST],\n        f:proc(x:ST.S):bool,\n \
    \       x,L:int\n    ):int=\n        ## @[x]\u304B\u3089\u59CB\u3081\u3001prefix\u306E\
    prod\u306B\u5BFE\u3059\u308Bf\u304C\u521D\u3081\u3066false\u306B\u306A\u308B\u79FB\
    \u52D5\u8DDD\u96E2\u3002\n        ## L\u56DE\u79FB\u52D5\u3057\u3066\u3082true\u306A\
    \u3089L\u3092\u8FD4\u3059\u3002O(log^2 N + log L)\n        ## f(e)=true\u3067\u3042\
    \u308A\u3001\u4E00\u5EA6false\u306B\u306A\u3063\u305F\u5F8C\u306F\u9802\u70B9\u3092\
    \u8FFD\u52A0\u3057\u3066\u3082false\u306E\u307E\u307E\u3001\n        ## \u3068\
    \u3044\u3046ACL max_right\u3068\u540C\u3058\u5358\u8ABF\u6027\u3092\u4EEE\u5B9A\
    \u3059\u308B\u3002\n        assert 0 <= x and x < len(self.graph.cycle_number)\n\
    \        assert 0 <= L and L < high(int)\n        let limit = L+1\n        var\
    \ value = self.get(x)\n        if not f(value):\n            return 0\n      \
    \  var used = 1\n        if used == limit:\n            return L\n\n        let\
    \ root = self.graph.roots[x]\n        # \u30B5\u30A4\u30AF\u30EB\u5165\u53E3\u306F\
    cycle\u5074\u306E\u6B63\u672C\u3067\u51E6\u7406\u3059\u308B\u305F\u3081\u3001\
    HLD path\u304B\u3089\u9664\u5916\u3059\u308B\u3002\n        let tree_path = self.graph.tree.path(root,x,false,true)\n\
    \        var first_segment = true\n        for (l,r) in tree_path:\n         \
    \   let nl = l+int(first_segment) # x\u306F\u51E6\u7406\u6E08\u307F\n        \
    \    first_segment = false\n            let nr = nl+min(r-nl,limit-used)\n   \
    \         if nl < nr:\n                let max_right = self.st_hld.max_right(nl,proc(v:ST.S):bool=\n\
    \                    f(self.st_hld.calc_op(value,v))\n                )\n    \
    \            if max_right < nr:\n                    used += max_right-nl\n  \
    \                  return used\n                value = self.st_hld.calc_op(value,self.st_hld.prod(nl..<nr))\n\
    \                used += nr-nl\n            if used == limit:\n              \
    \  return L\n\n        let cid = self.graph.cycle_number[root]\n        let csiz\
    \ = len(self.graph.cycle[cid])\n        let offset = self.cum_cyclesize[cid]\n\
    \        let cycle_start =\n            if self.graph.incycle(x):\n          \
    \      (self.graph.cycle_idx[x]+1) mod csiz\n            else:\n             \
    \   self.graph.cycle_idx[root]\n\n        proc cycleProd(l,r:int):ST.S=\n    \
    \        return self.st_cycle.prod((offset+l)..<(offset+r))\n\n        let one_cycle\
    \ = self.st_hld.calc_op(\n            cycleProd(cycle_start,csiz),\n         \
    \   cycleProd(0,cycle_start)\n        )\n        let max_cycles = (limit-used)\
    \ div csiz\n        if max_cycles > 0:\n            var powers = @[one_cycle]\n\
    \            var block_size = 1\n            while block_size <= max_cycles div\
    \ 2:\n                powers.add(self.st_hld.calc_op(powers[^1],powers[^1]))\n\
    \                block_size *= 2\n\n            var accepted = 0\n           \
    \ for i in countdown(powers.high,0):\n                let count = 1 shl i\n  \
    \              if count <= max_cycles-accepted:\n                    let next_value\
    \ = self.st_hld.calc_op(value,powers[i])\n                    if f(next_value):\n\
    \                        value = next_value\n                        accepted\
    \ += count\n            used += accepted*csiz\n            if used == limit:\n\
    \                return L\n\n        var rest = min(limit-used,csiz)\n       \
    \ proc consumeCycle(l,r:int):bool=\n            if l == r:\n                return\
    \ true\n            let max_right = self.st_cycle.max_right(offset+l,proc(v:ST.S):bool=\n\
    \                f(self.st_hld.calc_op(value,v))\n            )\n            if\
    \ max_right < offset+r:\n                used += max_right-(offset+l)\n      \
    \          return false\n            value = self.st_hld.calc_op(value,cycleProd(l,r))\n\
    \            used += r-l\n            return true\n\n        let first = min(rest,csiz-cycle_start)\n\
    \        if not consumeCycle(cycle_start,cycle_start+first):\n            return\
    \ used\n        rest -= first\n        if rest > 0 and not consumeCycle(0,rest):\n\
    \            return used\n        return used-1\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/collections/segtree.nim
  - cplib/collections/segtree.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: false
  path: cplib/graph/functional_graph.nim
  requiredBy:
  - verify/graph/functional_graph_test_.nim
  - verify/graph/functional_graph_test_.nim
  timestamp: '2026-07-16 11:31:11+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/functional_graph_lazy_op_test.nim
  - verify/AI/functional_graph_lazy_op_test.nim
  - verify/AI/functional_graph_test.nim
  - verify/AI/functional_graph_test.nim
documentation_of: cplib/graph/functional_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/functional_graph.nim
- /library/cplib/graph/functional_graph.nim.html
title: cplib/graph/functional_graph.nim
---
