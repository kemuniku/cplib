---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/AI/functional_graph_lazy_op_test.nim
    title: verify/AI/functional_graph_lazy_op_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/AI/functional_graph_lazy_op_test.nim
    title: verify/AI/functional_graph_lazy_op_test.nim
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
  code: "when not declared CPLIB_GRAPH_FUNCTIONALGRAPH_WITH_LAZY_OP:\n    const CPLIB_GRAPH_FUNCTIONALGRAPH_WITH_LAZY_OP*\
    \ = 1\n    import sequtils\n    import cplib/graph/graph\n    import cplib/graph/functional_graph\n\
    \    import cplib/tree/heavylightdecomposition\n    import atcoder/lazysegtree\n\
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
  - cplib/graph/functional_graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/functional_graph.nim
  isVerificationFile: false
  path: cplib/graph/functional_graph_with_lazy_op.nim
  requiredBy: []
  timestamp: '2026-07-17 07:16:29+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/functional_graph_lazy_op_test.nim
  - verify/AI/functional_graph_lazy_op_test.nim
documentation_of: cplib/graph/functional_graph_with_lazy_op.nim
layout: document
redirect_from:
- /library/cplib/graph/functional_graph_with_lazy_op.nim
- /library/cplib/graph/functional_graph_with_lazy_op.nim.html
title: cplib/graph/functional_graph_with_lazy_op.nim
---
