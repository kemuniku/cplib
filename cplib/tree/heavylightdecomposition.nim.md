---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  _extendedRequiredBy:
  - icon: ':warning:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':warning:'
    path: cplib/graph/functional_graph.nim
    title: cplib/graph/functional_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/namori_graph.nim
    title: cplib/graph/namori_graph.nim
  - icon: ':warning:'
    path: verify/graph/functional_graph_test_.nim
    title: verify/graph/functional_graph_test_.nim
  - icon: ':warning:'
    path: verify/graph/functional_graph_test_.nim
    title: verify/graph/functional_graph_test_.nim
  - icon: ':warning:'
    path: verify/graph/namori_graph_test_.nim
    title: verify/graph/namori_graph_test_.nim
  - icon: ':warning:'
    path: verify/graph/namori_graph_test_.nim
    title: verify/graph/namori_graph_test_.nim
  - icon: ':warning:'
    path: verify/tree/auxiliarytree_test_.nim
    title: verify/tree/auxiliarytree_test_.nim
  - icon: ':warning:'
    path: verify/tree/auxiliarytree_test_.nim
    title: verify/tree/auxiliarytree_test_.nim
  - icon: ':warning:'
    path: verify/tree/hld/hld_past202004o_test_.nim
    title: verify/tree/hld/hld_past202004o_test_.nim
  - icon: ':warning:'
    path: verify/tree/hld/hld_past202004o_test_.nim
    title: verify/tree/hld/hld_past202004o_test_.nim
  _extendedVerifiedWith:
  - icon: ':heavy_check_mark:'
    path: verify/graph/namori_incycle_test.nim
    title: verify/graph/namori_incycle_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/graph/namori_incycle_test.nim
    title: verify/graph/namori_incycle_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/auxiliaryweightedtree_test.nim
    title: verify/tree/auxiliaryweightedtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/auxiliaryweightedtree_test.nim
    title: verify/tree/auxiliaryweightedtree_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_la_yosupo_test.nim
    title: verify/tree/hld/hld_la_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_la_yosupo_test.nim
    title: verify/tree/hld/hld_la_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_lca_yosupo_test.nim
    title: verify/tree/hld/hld_lca_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_lca_yosupo_test.nim
    title: verify/tree/hld/hld_lca_yosupo_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_vertex_add_path_sum_test.nim
    title: verify/tree/hld/hld_vertex_add_path_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_vertex_add_path_sum_test.nim
    title: verify/tree/hld/hld_vertex_add_path_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
    title: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
    title: verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_vertex_set_path_composite_test.nim
    title: verify/tree/hld/hld_vertex_set_path_composite_test.nim
  - icon: ':heavy_check_mark:'
    path: verify/tree/hld/hld_vertex_set_path_composite_test.nim
    title: verify/tree/hld/hld_vertex_set_path_composite_test.nim
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    links:
    - https://atcoder.jp/contests/abc337/submissions/50216964
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "when not declared CPLIB_TREE_HLD:\n    const CPLIB_TREE_HLD* = 1\n    import\
    \ sequtils, algorithm, sets\n    import cplib/graph/graph\n    # https://atcoder.jp/contests/abc337/submissions/50216964\n\
    \    # \u2191\u4E0A\u8A18\u306E\u63D0\u51FA\u3088\u308A\u5F15\u7528\n    type\
    \ HeavyLightDecomposition* = ref object \n        N*: int\n        P*, PP*, PD*,\
    \ D*, I*, rangeL*, rangeR*: seq[int]\n    proc initHld*(g: UnDirectedGraph, root:\
    \ int): HeavyLightDecomposition =\n        var hld = HeavyLightDecomposition()\n\
    \        var n: int = g.len\n        hld.N = n\n        hld.P = newSeqWith(n,\
    \ -1)\n        hld.I = newSeqWith(n, 0)\n        hld.I[0] = root\n        var\
    \ iI = 1\n        for i in 0..<n:\n            var p = hld.I[i]\n            for\
    \ e in g[p]:\n                if hld.P[p] != e:\n                    hld.I[iI]\
    \ = e\n                    hld.P[e] = p\n                    iI += 1\n       \
    \ var Z = newSeqWith(n, 1)\n        var nx = newSeqWith(n, -1)\n        hld.PP\
    \ = newSeqWith(n, 0)\n        for i in 0..<n:\n            hld.PP[i] = i\n   \
    \     for i in 1..<n:\n            var p = hld.I[n-i]\n            Z[hld.P[p]]\
    \ += Z[p]\n            if nx[hld.P[p]] == -1 or Z[nx[hld.P[p]]] < Z[p]:\n    \
    \            nx[hld.P[p]] = p\n        for p in hld.I:\n            if nx[p] !=\
    \ -1:\n                hld.PP[nx[p]] = p\n        hld.PD = newSeqWith(n, n)\n\
    \        hld.PD[root] = 0\n        hld.D = newSeqWith(n, 0)\n        for p in\
    \ hld.I:\n            if p != root:\n                hld.PP[p] = hld.PP[hld.PP[p]]\n\
    \                hld.PD[p] = min(hld.PD[hld.PP[p]], hld.PD[hld.P[p]]+1)\n    \
    \            hld.D[p] = hld.D[hld.P[p]]+1\n        hld.rangeL = newSeqWith(n,\
    \ 0)\n        hld.rangeR = newSeqWith(n, 0)\n        for p in hld.I:\n       \
    \     hld.rangeR[p] = hld.rangeL[p] + Z[p]\n            var ir = hld.rangeR[p]\n\
    \            for e in g[p]:\n                if hld.P[p] != e and e != nx[p]:\n\
    \                    ir -= Z[e]\n                    hld.rangeL[e] = ir\n    \
    \        if nx[p] != -1:\n                hld.rangeL[nx[p]] = hld.rangeL[p] +\
    \ 1\n        for i in 0..<n:\n            hld.I[hld.rangeL[i]] = i\n        return\
    \ hld\n    proc initHld*(g: DirectedGraph, root: int): HeavyLightDecomposition\
    \ =\n        var n = g.len\n        var gn = initUnWeightedUnDirectedStaticGraph(n)\n\
    \        var seen = initHashSet[(int, int)]()\n        for i in 0..<n:\n     \
    \       for (j, _) in g[i]:\n                if (i, j) notin seen:\n         \
    \           gn.add_edge(i, j)\n                    seen.incl((i, j))\n       \
    \             seen.incl((j, i))\n        gn.build\n        return initHld(gn,\
    \ root)\n    proc initHld*(adj: seq[seq[int]], root: int): HeavyLightDecomposition\
    \ =\n        var n = adj.len\n        var gn = initUnWeightedUnDirectedStaticGraph(n)\n\
    \        var seen = initHashSet[(int, int)]()\n        for i in 0..<n:\n     \
    \       for j in adj[i]:\n                if (i, j) notin seen:\n            \
    \        gn.add_edge(i, j)\n                    seen.incl((i, j))\n          \
    \          seen.incl((j, i))\n        gn.build\n        return initHld(gn, root)\n\
    \    proc numVertices*(hld: HeavyLightDecomposition): int = hld.N\n    proc depth*(hld:\
    \ HeavyLightDecomposition, p: int): int = hld.D[p]\n    proc toSeq*(hld: HeavyLightDecomposition,\
    \ vtx: int): int = hld.rangeL[vtx]\n    proc toVtx*(hld: HeavyLightDecomposition,\
    \ seqidx: int): int = hld.I[seqidx]\n    proc toSeq2In*(hld: HeavyLightDecomposition,\
    \ vtx: int): int = hld.rangeL[vtx] * 2 - hld.D[vtx]\n    proc toSeq2Out*(hld:\
    \ HeavyLightDecomposition, vtx: int): int = hld.rangeR[vtx] * 2 - hld.D[vtx] -\
    \ 1\n    proc parentOf*(hld: HeavyLightDecomposition, v: int): int = hld.P[v]\n\
    \    proc heavyRootOf*(hld: HeavyLightDecomposition, v: int): int = hld.PP[v]\n\
    \    proc heavyChildOf*(hld: HeavyLightDecomposition, v: int): int =\n       \
    \ if hld.toSeq(v) == hld.N-1:\n            return -1\n        var cand = hld.toVtx(hld.toSeq(v)\
    \ + 1)\n        if hld.PP[v] == hld.PP[cand]:\n            return cand\n     \
    \   -1\n    proc lca*(hld: HeavyLightDecomposition, u: int, v: int): int =\n \
    \       var (u, v) = (u, v)\n        if hld.PD[u] < hld.PD[v]:\n            swap(u,\
    \ v)\n        while hld.PD[u] > hld.PD[v]:\n            u = hld.P[hld.PP[u]]\n\
    \        while hld.PP[u] != hld.PP[v]:\n            u = hld.P[hld.PP[u]]\n   \
    \         v = hld.P[hld.PP[v]]\n        if hld.D[u] > hld.D[v]:\n            return\
    \ v\n        u\n    proc dist*(hld: HeavyLightDecomposition, u: int, v: int):\
    \ int =\n        hld.depth(u) + hld.depth(v) - hld.depth(hld.lca(u, v)) * 2\n\
    \    proc path*(hld: HeavyLightDecomposition, r: int, c: int, include_root: bool,\
    \ reverse_path: bool): seq[(int, int)] =\n        var (r, c) = (r, c)\n      \
    \  var k = hld.PD[c] - hld.PD[r] + 1\n        if k <= 0:\n            return @[]\n\
    \        var res = newSeqWith(k, (0, 0))\n        for i in 0..<k-1:\n        \
    \    res[i] = (hld.rangeL[hld.PP[c]], hld.rangeL[c] + 1)\n            c = hld.P[hld.PP[c]]\n\
    \        if hld.PP[r] != hld.PP[c] or hld.D[r] > hld.D[c]:\n            return\
    \ @[]\n        var root_off = int(not include_root)\n        res[^1] = (hld.rangeL[r]+root_off,\
    \ hld.rangeL[c]+1)\n        if res[^1][0] == res[^1][1]:\n            discard\
    \ res.pop()\n            k -= 1\n        if reverse_path:\n            for i in\
    \ 0..<k:\n                res[i] = (hld.N - res[i][1], hld.N - res[i][0])\n  \
    \      else:\n            res.reverse()\n        res\n    proc subtree*(hld: HeavyLightDecomposition,\
    \ p: int): (int, int) = (hld.rangeL[p], hld.rangeR[p])\n    iterator subtreeV*(hld:\
    \ HeavyLightDecomposition, p: int):int=\n        ## \u90E8\u5206\u6728\u306B\u3064\
    \u3044\u3066\u3001\u305D\u306E\u9802\u70B9\u756A\u53F7\u306E\u30A4\u30C6\u30EC\
    \u30FC\u30BF\n        for i in hld.rangeL[p]..<hld.rangeR[p]:\n            yield\
    \ hld.toVtx(i)\n    proc median*(hld: HeavyLightDecomposition, x: int, y: int,\
    \ z: int): int =\n        hld.lca(x, y) xor hld.lca(y, z) xor hld.lca(x, z)\n\
    \    proc la*(hld: HeavyLightDecomposition, starting: int, goal: int, d: int):\
    \ int =\n        var (u, v, d) = (starting, goal, d)\n        if d < 0:\n    \
    \        return -1\n        var g = hld.lca(u, v)\n        var dist0 = hld.D[u]\
    \ - hld.D[g] * 2 + hld.D[v]\n        if dist0 < d:\n            return -1\n  \
    \      var p = u\n        if hld.D[u] - hld.D[g] < d:\n            p = v\n   \
    \         d = dist0 - d\n        while hld.D[p] - hld.D[hld.PP[p]] < d:\n    \
    \        d -= hld.D[p] - hld.D[hld.PP[p]] + 1\n            p = hld.P[hld.PP[p]]\n\
    \        hld.I[hld.rangeL[p] - d]\n    iterator children*(hld: HeavyLightDecomposition,\
    \ v: int): int =\n        var s = hld.rangeL[v] + 1\n        while s < hld.rangeR[v]:\n\
    \            var w = hld.toVtx(s)\n            yield w\n            s += hld.rangeR[w]\
    \ - hld.rangeL[w]\n    \n\n    proc initAuxiliaryTree*(hld:HeavyLightDecomposition,v:seq[int]):UnWeightedUnDirectedTableGraph[int]=\n\
    \        ## \u6839\u304C\u6B32\u3057\u304B\u3063\u305F\u3089G.v[0]\u3092\u4F7F\
    \u3063\u3066\u304F\u3060\u3055\u3044\u3000\u3051\u3080\u306B\u304F\n        var\
    \ v = v.sortedByit(hld.toseq(it))\n        for i in 0..<(len(v)-1):\n        \
    \    v.add(hld.lca(v[i],v[i+1]))\n        v = v.sortedByIt(hld.toseq(it)).deduplicate(true)\n\
    \        var stack :seq[int]\n        result = initUnWeightedUnDirectedTableGraph[int](v)\n\
    \        stack.add(v[0])\n        \n        for i in 1..<len(v):\n           \
    \ while len(stack) > 0 and hld.toSeq2Out(stack[^1]) < hld.toseq2In(v[i]):\n  \
    \              discard stack.pop()\n            if len(stack) != 0:\n        \
    \        result.add_edge(stack[^1],v[i])\n            stack.add(v[i])\n    \n\
    \    proc initAuxiliaryWeightedTree*(hld:HeavyLightDecomposition,v:seq[int]):WeightedUnDirectedTableGraph[int,int]=\n\
    \        ## \u6839\u304C\u6B32\u3057\u304B\u3063\u305F\u3089G.v[0]\u3092\u4F7F\
    \u3063\u3066\u304F\u3060\u3055\u3044\u3000\u3051\u3080\u306B\u304F\n        var\
    \ v = v.sortedByit(hld.toseq(it))\n        for i in 0..<(len(v)-1):\n        \
    \    v.add(hld.lca(v[i],v[i+1]))\n        v = v.sortedByIt(hld.toseq(it)).deduplicate(true)\n\
    \        var stack :seq[int]\n        result = initWeightedUnDirectedTableGraph(v,int)\n\
    \        stack.add(v[0])\n        for i in 1..<len(v):\n            while len(stack)\
    \ > 0 and hld.toSeq2Out(stack[^1]) < hld.toseq2In(v[i]):\n                discard\
    \ stack.pop()\n            if len(stack) != 0:\n                result.add_edge(stack[^1],v[i],hld.depth(v[i])-hld.depth(stack[^1]))\n\
    \            stack.add(v[i])\n\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: false
  path: cplib/tree/heavylightdecomposition.nim
  requiredBy:
  - verify/tree/auxiliarytree_test_.nim
  - verify/tree/auxiliarytree_test_.nim
  - verify/tree/hld/hld_past202004o_test_.nim
  - verify/tree/hld/hld_past202004o_test_.nim
  - verify/graph/namori_graph_test_.nim
  - verify/graph/namori_graph_test_.nim
  - verify/graph/functional_graph_test_.nim
  - verify/graph/functional_graph_test_.nim
  - cplib/graph/namori_graph.nim
  - cplib/graph/namori_graph.nim
  - cplib/graph/functional_graph.nim
  - cplib/graph/functional_graph.nim
  timestamp: '2025-01-30 13:56:50+09:00'
  verificationStatus: LIBRARY_ALL_AC
  verifiedWith:
  - verify/tree/auxiliaryweightedtree_test.nim
  - verify/tree/auxiliaryweightedtree_test.nim
  - verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
  - verify/tree/hld/hld_vertex_add_subtree_sum_test.nim
  - verify/tree/hld/hld_vertex_add_path_sum_test.nim
  - verify/tree/hld/hld_vertex_add_path_sum_test.nim
  - verify/tree/hld/hld_vertex_set_path_composite_test.nim
  - verify/tree/hld/hld_vertex_set_path_composite_test.nim
  - verify/tree/hld/hld_la_yosupo_test.nim
  - verify/tree/hld/hld_la_yosupo_test.nim
  - verify/tree/hld/hld_lca_yosupo_test.nim
  - verify/tree/hld/hld_lca_yosupo_test.nim
  - verify/graph/namori_incycle_test.nim
  - verify/graph/namori_incycle_test.nim
documentation_of: cplib/tree/heavylightdecomposition.nim
layout: document
redirect_from:
- /library/cplib/tree/heavylightdecomposition.nim
- /library/cplib/tree/heavylightdecomposition.nim.html
title: cplib/tree/heavylightdecomposition.nim
---
