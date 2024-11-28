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
  _extendedRequiredBy: []
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/functional_graph_test.nim
    title: verify/graph/functional_graph_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/functional_graph_test.nim
    title: verify/graph/functional_graph_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n  File \"/home/runner/.local/lib/python3.10/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_FUNCTIONALGRAPH:\n    const CPLIB_GRAPH_FUNCTIONALGRAPH*\
    \ = 1\n    import sequtils\n    import cplib/graph/graph\n    import cplib/tree/heavylightdecomposition\n\
    \    type Functional_Graph* = ref object \n        tree* : HeavyLightDecomposition\n\
    \        cycle_number : seq[int]\n        cycle_idx : seq[int]\n        roots\
    \ : seq[int]\n        cycle* : seq[seq[int]]\n\n    proc initFunctionalGraph*(graph:UnWeightedDirectedGraph):Functional_Graph=\n\
    \        var stack : seq[int]\n        var sizes = newseqwith(len(graph),0)\n\
    \        var cycle_number = newseqwith(len(graph),-1)\n        var cycle_idx =\
    \ newseqwith(len(graph),-1)\n        var tree = initUnWeightedUnDirectedGraph(len(graph)+1)\n\
    \        var roots = newseqwith(len(graph),0)\n        var cycle : seq[seq[int]]\n\
    \        for i in 0..<len(graph):\n            for j in graph[i]:\n          \
    \      sizes[j] += 1\n        for i in 0..<len(graph):\n            if sizes[i]\
    \ == 0:\n                stack.add(i)\n        while len(stack) != 0:\n      \
    \      var i = stack.pop()\n            for j in graph[i]:\n                if\
    \ sizes[j] != 0:\n                    tree.add_edge(i,j)\n                   \
    \ sizes[j] -= 1\n                    if sizes[j] == 0:\n                     \
    \   stack.add(j)\n        var alr = newseqwith(len(graph),false)\n        var\
    \ cycle_n = 0\n        for i in 0..<len(graph):\n            if sizes[i] != 0\
    \ and not alr[i]:\n                var now = i\n                var bef = -1\n\
    \                var tmp = 1\n                cycle_idx[i] = 0\n             \
    \   cycle_number[i] = cycle_n\n                cycle.add(@[i])\n             \
    \   while true:\n                    alr[now] = true\n                    var\
    \ next = -1\n                    proc dfs(x,p:int)=\n                        roots[x]\
    \ = now\n                        for y in tree[x]:\n                         \
    \   if p != y:\n                                if sizes[y] == 0:\n          \
    \                          dfs(y,x)\n                    dfs(now,-1)\n       \
    \             tree.add_edge(now,len(graph))\n                    for j in graph[now]:\n\
    \                        next = j\n                    if next == -1 or next ==\
    \ i:\n                        break\n                    bef = now\n         \
    \           now = next\n                    cycle_number[now] = cycle_n\n    \
    \                cycle_idx[now] = tmp\n                    cycle[cycle_n].add(next)\n\
    \                    tmp += 1\n                    \n                cycle_n +=\
    \ 1\n        return Functional_Graph(tree:tree.initHld(len(graph)),cycle_number:cycle_number,roots:roots,cycle:cycle,cycle_idx:cycle_idx)\n\
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
    \n    proc depth*(functional_graph:Functional_Graph,x:int):int=\n        ## \u4F55\
    \u56DE\u306E\u79FB\u52D5\u3067cycle\u306B\u5165\u308B\u304B\n        return functional_graph.tree.depth(x)-1\n\
    \n    proc dist*(functional_graph:Functional_Graph,u,v:int):int=\n        ## u\u304B\
    \u3089v\u3078\u6700\u77ED\u4F55\u56DE\u306E\u79FB\u52D5\u3067\u5230\u9054\u304C\
    \u53EF\u80FD\u304B\n        ## \u305F\u3060\u3057\u3001\u5230\u9054\u3067\u304D\
    \u306A\u3044\u3068\u304D\u306F-1\u3092\u8FD4\u3059\u3002\n        if functional_graph.cycle_number[functional_graph.roots[u]]\
    \ != functional_graph.cycle_number[functional_graph.roots[v]]:\n            return\
    \ -1\n        var lca = functional_graph.tree.lca(u,v)\n        if lca == v:\n\
    \            return functional_graph.tree.depth(v)-functional_graph.tree.depth(u)\n\
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
    \u304D\u306E\u9802\u70B9\u3092\u8FD4\u3059\n        return functional_graph.roots[x]"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: false
  path: cplib/graph/functional_graph.nim
  requiredBy: []
  timestamp: '2024-10-27 03:06:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/functional_graph_test.nim
  - verify/graph/functional_graph_test.nim
documentation_of: cplib/graph/functional_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/functional_graph.nim
- /library/cplib/graph/functional_graph.nim.html
title: cplib/graph/functional_graph.nim
---
