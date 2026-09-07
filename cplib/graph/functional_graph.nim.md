---
data:
  _extendedDependsOn:
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
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph_with_lazy_op.nim
    title: cplib/graph/functional_graph_with_lazy_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph_with_lazy_op.nim
    title: cplib/graph/functional_graph_with_lazy_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph_with_op.nim
    title: cplib/graph/functional_graph_with_op.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/functional_graph_with_op.nim
    title: cplib/graph/functional_graph_with_op.nim
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
    \ algorithm\n\n    proc count_kth*(functional_graph:Functional_Graph,x,k:int):int=\n\
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
    \        return functional_graph.cycle_depth[cid][residue].upperBound(k)\n"
  dependsOn:
  - cplib/tree/heavylightdecomposition.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/functional_graph.nim
  requiredBy:
  - verify/graph/functional_graph_test_.nim
  - verify/graph/functional_graph_test_.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/graph/functional_graph_with_op.nim
  - cplib/graph/functional_graph_with_lazy_op.nim
  - cplib/graph/functional_graph_with_lazy_op.nim
  timestamp: '2026-07-17 07:16:29+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/AI/functional_graph_test.nim
  - verify/AI/functional_graph_test.nim
  - verify/AI/functional_graph_lazy_op_test.nim
  - verify/AI/functional_graph_lazy_op_test.nim
documentation_of: cplib/graph/functional_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/functional_graph.nim
- /library/cplib/graph/functional_graph.nim.html
title: cplib/graph/functional_graph.nim
---
