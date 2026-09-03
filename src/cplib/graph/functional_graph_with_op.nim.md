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
  code: "when not declared CPLIB_GRAPH_FUNCTIONALGRAPH_WITH_OP:\n    const CPLIB_GRAPH_FUNCTIONALGRAPH_WITH_OP*\
    \ = 1\n    import sequtils\n    import algorithm\n    import cplib/graph/graph\n\
    \    import cplib/graph/functional_graph\n    import cplib/tree/heavylightdecomposition\n\
    \    import cplib/collections/segtree\n\n    type FunctionalGraph_with_op*[T]\
    \ = ref object\n        F : Functional_Graph\n        op : proc(x,y:T):T\n   \
    \     e : T\n        st_hld : SegmentTree[T]\n        st_cycle : SegmentTree[T]\n\
    \        cum_cyclesize : seq[int]\n\n    proc initFunctionalGraph_with_op[T](F:Functional_Graph,values:seq[T],op:proc(l,r:T):T,e:T):FunctionalGraph_with_op[T]=\n\
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
    \           return used\n        return used-1\n"
  dependsOn:
  - cplib/graph/functional_graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/collections/segtree.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/collections/segtree.nim
  isVerificationFile: false
  path: cplib/graph/functional_graph_with_op.nim
  requiredBy: []
  timestamp: '2026-07-17 07:16:29+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/functional_graph_lazy_op_test.nim
  - verify/AI/functional_graph_lazy_op_test.nim
documentation_of: cplib/graph/functional_graph_with_op.nim
layout: document
redirect_from:
- /library/cplib/graph/functional_graph_with_op.nim
- /library/cplib/graph/functional_graph_with_op.nim.html
title: cplib/graph/functional_graph_with_op.nim
---
