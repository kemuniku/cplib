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
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/constants.nim
    title: cplib/utils/constants.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: verify/graph/namori_graph_test_.nim
    title: verify/graph/namori_graph_test_.nim
  - icon: ':warning:'
    path: verify/graph/namori_graph_test_.nim
    title: verify/graph/namori_graph_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/namori_incycle_test.nim
    title: verify/graph/namori_incycle_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/namori_incycle_test.nim
    title: verify/graph/namori_incycle_test.nim
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
  code: "when not declared CPLIB_GRAPH_NAMORI:\n    const CPLIB_GRAPH_NAMORI* = 1\n\
    \    import cplib/graph/graph\n    import cplib/tree/heavylightdecomposition\n\
    \    import cplib/utils/constants\n    import sequtils\n    type NamoriGraph =\
    \ ref object \n        tree : HeavyLightDecomposition\n        rootNo : seq[int]\n\
    \        roots : seq[int]\n        cyclesize : int\n\n\n    proc initNamoriGraph*(graph:UnWeightedUnDirectedGraph):NamoriGraph=\n\
    \        var stack : seq[int]\n        var sizes = newseqwith(len(graph),0)\n\
    \        var rootNo = newseqwith(len(graph),-1)\n        var tree = initUnWeightedUnDirectedGraph(len(graph)+1)\n\
    \        var roots = newseqwith(len(graph),0)\n        for i in 0..<len(graph):\n\
    \            sizes[i] = len(graph.edges[i])\n            if sizes[i] == 1:\n \
    \               stack.add(i)\n        while len(stack) != 0:\n            var\
    \ i = stack.pop()\n            for j in graph[i]:\n                if sizes[j]\
    \ != 1:\n                    tree.add_edge(i,j)\n                    sizes[j]\
    \ -= 1\n                    if sizes[j] == 1:\n                        stack.add(j)\n\
    \        for i in 0..<len(graph):\n            if sizes[i] != 1:\n           \
    \     var now = i\n                var bef = -1\n                var tmp = 1\n\
    \                rootNo[i] = 0\n                while true:\n                \
    \    tree.add_edge(now,len(graph))\n                    var next = -1\n      \
    \              proc dfs(x,p:int)=\n                        roots[x] = now\n  \
    \                      for y in graph[x]:\n                            if p !=\
    \ y:\n                                if sizes[y] == 1:\n                    \
    \                dfs(y,x)\n                                elif bef != y:\n  \
    \                                  next = y\n                    dfs(now,-1)\n\
    \                    if next == -1 or next == i:\n                        break\n\
    \                    bef = now\n                    now = next\n             \
    \       rootNo[now] = tmp\n                    tmp += 1\n                return\
    \ NamoriGraph(tree:tree.initHld(len(graph)),rootNo:rootNo,roots:roots,cyclesize:tmp)\n\
    \n    proc dist*(namori:NamoriGraph,u,v:int):(int,int)=\n        ## u,v\u9593\u306E\
    \u8DDD\u96E2\u3092\u4E8C\u901A\u308A\u8FD4\u3057\u307E\u3059\n        ## (\u5C0F\
    \u3055\u3044\u307B\u3046,\u5927\u304D\u3044\u307B\u3046)\n        ## \u305F\u3060\
    \u3057\u3001\u4E00\u901A\u308A\u3057\u304B\u5B58\u5728\u3057\u306A\u3044\u5834\
    \u5408\u4E8C\u3064\u76EE\u306Eint\u306FINF64\u3092\u8FD4\u3057\u307E\u3059\u3002\
    \n        var lca = namori.tree.lca(u,v) \n        if lca != len(namori.rootNo):\n\
    \            return (namori.tree.dist(u,v),INF64)\n        else:\n           \
    \ var x = namori.roots[u]\n            var y = namori.roots[v]\n            var\
    \ a = abs(namori.rootNo[x]-namori.rootNo[y])\n            var b = namori.cyclesize\
    \ - a\n            var tmp = namori.tree.depth(u) + namori.tree.depth(v) - 2\n\
    \            return (min(a,b)+tmp,max(a,b)+tmp)\n    \n    proc incycle*(namori:NamoriGraph,x:int):bool=\n\
    \        return namori.roots[x] == x\n    \n    proc root*(namori:NamoriGraph,x:int):int=\n\
    \        return namori.roots[x]\n\n    proc same_tree*(namori:NamoriGraph,x,y:int):bool=\n\
    \        return namori.roots[x] == namori.roots[y]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/constants.nim
  - cplib/graph/graph.nim
  - cplib/utils/constants.nim
  - cplib/tree/heavylightdecomposition.nim
  isVerificationFile: false
  path: cplib/graph/namori_graph.nim
  requiredBy:
  - verify/graph/namori_graph_test_.nim
  - verify/graph/namori_graph_test_.nim
  timestamp: '2025-03-09 17:42:58+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/graph/namori_incycle_test.nim
  - verify/graph/namori_incycle_test.nim
documentation_of: cplib/graph/namori_graph.nim
layout: document
redirect_from:
- /library/cplib/graph/namori_graph.nim
- /library/cplib/graph/namori_graph.nim.html
title: cplib/graph/namori_graph.nim
---
