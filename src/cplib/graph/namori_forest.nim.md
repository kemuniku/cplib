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
    path: verify/graph/namori_forest_test_.nim
    title: verify/graph/namori_forest_test_.nim
  - icon: ':warning:'
    path: verify/graph/namori_forest_test_.nim
    title: verify/graph/namori_forest_test_.nim
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':warning:'
  attributes:
    links: []
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_GRAPH_NAMORI_FOREST:\n    const CPLIB_GRAPH_NAMORI_FOREST*\
    \ = 1\n    import cplib/graph/graph\n    import cplib/tree/heavylightdecomposition\n\
    \    import cplib/utils/constants\n    import sequtils\n\n    type NamoriForest*\
    \ = ref object\n        tree: HeavyLightDecomposition\n        rootNo: seq[int]\
    \      # cycle \u4E0A\u306E\u9802\u70B9\u306A\u3089\u3001\u305D\u306E cycle \u5185\
    \u3067\u306E\u756A\u53F7\n        roots: seq[int]       # x \u304C\u3076\u3089\
    \u4E0B\u304C\u3063\u3066\u3044\u308B cycle \u9802\u70B9\n        comp: seq[int]\
    \        # \u9023\u7D50\u6210\u5206\u756A\u53F7\n        cyclesize: seq[int] \
    \  # comp \u3054\u3068\u306E cycle \u9577\n        superRoot: int\n\n    proc\
    \ initNamoriForest*(graph: UnWeightedUnDirectedGraph): NamoriForest =\n      \
    \  let n = len(graph)\n        let superRoot = n\n\n        var stack: seq[int]\n\
    \        var sizes = newSeqWith(n, 0)\n        var rootNo = newSeqWith(n, -1)\n\
    \        var roots = newSeqWith(n, -1)\n        var comp = newSeqWith(n, -1)\n\
    \        var tree = initUnWeightedUnDirectedGraph(n + 1)\n\n        for i in 0\
    \ ..< n:\n            sizes[i] = len(graph.edges[i])\n            if sizes[i]\
    \ == 1:\n                stack.add(i)\n\n        # \u8449\u3092\u524A\u3063\u3066\
    \u3001cycle \u4E0A\u306B\u6B8B\u308B\u9802\u70B9\u3092\u5224\u5B9A\u3059\u308B\
    \n        while stack.len != 0:\n            let i = stack.pop()\n           \
    \ for j in graph[i]:\n                if sizes[j] != 1:\n                    sizes[j]\
    \ -= 1\n                    if sizes[j] == 1:\n                        stack.add(j)\n\
    \n        var onCycle = newSeqWith(n, false)\n        for i in 0 ..< n:\n    \
    \        onCycle[i] = sizes[i] > 1\n\n        for i in 0 ..< n:\n            for\
    \ j in graph[i]:\n                if i < j and not (onCycle[i] and onCycle[j]):\n\
    \                    tree.add_edge(i, j)\n\n        var usedCycle = newSeqWith(n,\
    \ false)\n        var cyclesize: seq[int]\n\n        for s in 0 ..< n:\n     \
    \       if not onCycle[s] or usedCycle[s]:\n                continue\n\n     \
    \       # s \u3092\u542B\u3080 cycle \u3092\u4E00\u5468\u3059\u308B\n        \
    \    var cyc: seq[int]\n            var now = s\n            var prev = -1\n\n\
    \            while true:\n                cyc.add(now)\n                usedCycle[now]\
    \ = true\n\n                var nxt = -1\n                for to in graph[now]:\n\
    \                    if onCycle[to] and to != prev:\n                        nxt\
    \ = to\n                        break\n\n                if nxt == -1 or nxt ==\
    \ s:\n                    break\n\n                prev = now\n              \
    \  now = nxt\n\n            let cid = cyclesize.len\n            cyclesize.add(cyc.len)\n\
    \n            for idx, r in cyc:\n                rootNo[r] = idx\n          \
    \      tree.add_edge(r, superRoot)\n\n                proc dfs(x, p: int) =\n\
    \                    roots[x] = r\n                    comp[x] = cid\n\n     \
    \               for y in graph[x]:\n                        if y == p:\n     \
    \                       continue\n                        if not onCycle[y]:\n\
    \                            dfs(y, x)\n\n                dfs(r, -1)\n\n     \
    \   for s in 0 ..< n:\n            if comp[s] != -1:\n                continue\n\
    \n            let cid = cyclesize.len\n            cyclesize.add(0)\n        \
    \    roots[s] = s\n            comp[s] = cid\n            tree.add_edge(s, superRoot)\n\
    \n            var stack = @[s]\n            while stack.len != 0:\n          \
    \      let x = stack.pop()\n                for y in graph[x]:\n             \
    \       if comp[y] == -1:\n                        roots[y] = s\n            \
    \            comp[y] = cid\n                        stack.add(y)\n\n        return\
    \ NamoriForest(\n            tree: tree.initHld(superRoot),\n            rootNo:\
    \ rootNo,\n            roots: roots,\n            comp: comp,\n            cyclesize:\
    \ cyclesize,\n            superRoot: superRoot\n        )\n\n    proc dist*(namori:\
    \ NamoriForest, u, v: int): (int, int) =\n        ## u, v \u9593\u306E\u8DDD\u96E2\
    \u3092\u4E8C\u901A\u308A\u8FD4\u3057\u307E\u3059\u3002\n        ## (\u5C0F\u3055\
    \u3044\u307B\u3046,\u5927\u304D\u3044\u307B\u3046)\n        ## \u540C\u3058\u6728\
    \u90E8\u5206\u306B\u3044\u308B\u306A\u3089\u4E8C\u901A\u308A\u76EE\u306F INF64\u3002\
    \n        ## \u5225\u9023\u7D50\u6210\u5206\u306A\u3089 (INF64, INF64)\u3002\n\
    \n        if namori.comp[u] != namori.comp[v]:\n            return (INF64, INF64)\n\
    \n        let lca = namori.tree.lca(u, v)\n\n        if lca != namori.superRoot:\n\
    \            return (namori.tree.dist(u, v), INF64)\n\n        let x = namori.roots[u]\n\
    \        let y = namori.roots[v]\n        let cid = namori.comp[u]\n\n       \
    \ let a = abs(namori.rootNo[x] - namori.rootNo[y])\n        let b = namori.cyclesize[cid]\
    \ - a\n\n        # cycle root \u306F superRoot \u306E\u5B50\u306A\u306E\u3067\u3001\
    \n        # depth(u) + depth(v) - 2 \u304C\u300C\u6728\u90E8\u5206\u3060\u3051\
    \u306E\u8DDD\u96E2\u300D\u306B\u306A\u308B\n        let base = namori.tree.depth(u)\
    \ + namori.tree.depth(v) - 2\n\n        return (min(a, b) + base, max(a, b) +\
    \ base)\n\n    proc incycle*(namori: NamoriForest, x: int): bool =\n        return\
    \ namori.roots[x] == x and namori.rootNo[x] != -1\n\n    proc root*(namori: NamoriForest,\
    \ x: int): int =\n        return namori.roots[x]\n\n    proc same_tree*(namori:\
    \ NamoriForest, x, y: int): bool =\n        return namori.roots[x] == namori.roots[y]\n\
    \n    proc same_component*(namori: NamoriForest, x, y: int): bool =\n        return\
    \ namori.comp[x] == namori.comp[y]\n\n    proc component*(namori: NamoriForest,\
    \ x: int): int =\n        return namori.comp[x]\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/utils/constants.nim
  - cplib/utils/constants.nim
  - cplib/tree/heavylightdecomposition.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/graph/namori_forest.nim
  requiredBy:
  - verify/graph/namori_forest_test_.nim
  - verify/graph/namori_forest_test_.nim
  timestamp: '2026-05-26 06:23:12+09:00'
  verificationStatus: LIBRARY_NO_TESTS
  verifiedWith: []
documentation_of: cplib/graph/namori_forest.nim
layout: document
redirect_from:
- /library/cplib/graph/namori_forest.nim
- /library/cplib/graph/namori_forest.nim.html
title: cplib/graph/namori_forest.nim
---
