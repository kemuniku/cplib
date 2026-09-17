---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/biconnected_components.nim
    title: cplib/graph/biconnected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/block_cut_tree.nim
    title: cplib/graph/block_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/block_cut_tree.nim
    title: cplib/graph/block_cut_tree.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/lowlink.nim
    title: cplib/graph/lowlink.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/two_edge_connected_components.nim
    title: cplib/graph/two_edge_connected_components.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/two_edge_connected_components.nim
    title: cplib/graph/two_edge_connected_components.nim
  _extendedRequiredBy: []
  _extendedVerifiedWith: []
  _isVerificationFailed: false
  _pathExtension: nim
  _verificationStatusIcon: ':heavy_check_mark:'
  attributes:
    PROBLEM: https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
    links:
    - https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
  bundledCode: "Traceback (most recent call last):\n  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/documentation/build.py\"\
    , line 71, in _render_source_code_stat\n    bundled_code = language.bundle(stat.path,\
    \ basedir=basedir, options={'include_paths': [basedir]}).decode()\n          \
    \         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^\n\
    \  File \"/home/runner/.local/lib/python3.12/site-packages/onlinejudge_verify/languages/nim.py\"\
    , line 86, in bundle\n    raise NotImplementedError\nNotImplementedError\n"
  code: "# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A\n\
    import algorithm, random, sequtils\nimport cplib/graph/graph\nimport cplib/graph/lowlink\n\
    import cplib/graph/two_edge_connected_components\nimport cplib/graph/biconnected_components\n\
    import cplib/graph/block_cut_tree\n\ntype Edge = (int, int)\n\nproc labels(n:\
    \ int, edges: seq[Edge], removedVertex = -1, removedEdge = -1,\n            mask\
    \ = -1): seq[int] =\n    result = newSeqWith(n, -1)\n    for s in 0..<n:\n   \
    \     if s == removedVertex or (mask and (1 shl s)) == 0 or result[s] != -1: continue\n\
    \        result[s] = s\n        var stack = @[s]\n        while stack.len > 0:\n\
    \            let v = stack.pop()\n            for i, e in edges:\n           \
    \     if i == removedEdge: continue\n                var to = -1\n           \
    \     if e[0] == v: to = e[1]\n                elif e[1] == v: to = e[0]\n   \
    \             if to < 0 or to == removedVertex or (mask and (1 shl to)) == 0:\
    \ continue\n                if result[to] == -1:\n                    result[to]\
    \ = s\n                    stack.add(to)\n\nproc countComponents(a: seq[int]):\
    \ int =\n    for v, c in a:\n        if v == c: inc result\n\nproc check(n: int,\
    \ edges: seq[Edge]) =\n    var g = initUnWeightedUnDirectedGraph(n)\n    var sg\
    \ = initUnWeightedUnDirectedStaticGraph(n)\n    var wg = initWeightedUnDirectedGraph(n,\
    \ float)\n    var swg = initWeightedUnDirectedStaticGraph(n, float)\n    for e\
    \ in edges:\n        g.add_edge(e[0], e[1])\n        sg.add_edge(e[0], e[1])\n\
    \        wg.add_edge(e[0], e[1], 2.5)\n        swg.add_edge(e[0], e[1], -1.5)\n\
    \    sg.build()\n    swg.build()\n    let ll = initLowLink(g)\n    doAssert ll\
    \ == initLowLink(sg)\n    doAssert ll == initLowLink(wg)\n    doAssert ll == initLowLink(swg)\n\
    \    let base = labels(n, edges)\n    let components = countComponents(base)\n\
    \    for v in 0..<n:\n        doAssert ll.is_articulation[v] == (countComponents(labels(n,\
    \ edges, v)) > components)\n    var bridges: seq[Edge]\n    var cutLabels: seq[seq[int]]\n\
    \    for i, e in edges:\n        let after = labels(n, edges, removedEdge = i)\n\
    \        cutLabels.add(after)\n        if countComponents(after) > components:\n\
    \            bridges.add((min(e[0], e[1]), max(e[0], e[1])))\n    var actualBridges:\
    \ seq[Edge]\n    for e in ll.bridges: actualBridges.add((min(e[0], e[1]), max(e[0],\
    \ e[1])))\n    bridges.sort()\n    actualBridges.sort()\n    doAssert actualBridges\
    \ == bridges\n    let te = initTwoEdgeConnectedComponents(ll)\n    doAssert te.groups\
    \ == initTwoEdgeConnectedComponents(swg).groups\n    for u in 0..<n:\n       \
    \ doAssert u in te.groups[te.component[u]]\n        for v in 0..<n:\n        \
    \    var same = base[u] == base[v]\n            for a in cutLabels: same = same\
    \ and a[u] == a[v]\n            doAssert (te.component[u] == te.component[v])\
    \ == same\n    var forestEdges = 0\n    for v in 0..<te.forest.len:\n        for\
    \ to in te.forest[v]: inc forestEdges\n    doAssert forestEdges == 2 * bridges.len\n\
    \    doAssert te.forest.len - forestEdges div 2 == components\n    let bc = initBiconnectedComponents(ll)\n\
    \    doAssert bc == initBiconnectedComponents(g)\n    doAssert bc == initBiconnectedComponents(sg)\n\
    \    doAssert bc == initBiconnectedComponents(wg)\n    doAssert bc == initBiconnectedComponents(swg)\n\
    \    for v in 0..<n:\n        doAssert bc.component_count_delta_after_removal(v)\
    \ ==\n            countComponents(labels(n, edges, removedVertex = v)) - components\n\
    \    var valid: seq[int]\n    for mask in 1..<(1 shl n):\n        if countComponents(labels(n,\
    \ edges, mask = mask)) != 1: continue\n        var ok = true\n        for v in\
    \ 0..<n:\n            if (mask and (1 shl v)) != 0:\n                if countComponents(labels(n,\
    \ edges, v, mask = mask)) > 1: ok = false\n        if ok: valid.add(mask)\n  \
    \  var expected: seq[int]\n    for mask in valid:\n        var maximal = true\n\
    \        for other in valid:\n            if mask != other and (mask and other)\
    \ == mask: maximal = false\n        if maximal: expected.add(mask)\n    var actual:\
    \ seq[int]\n    for id, group in bc.groups:\n        var mask = 0\n        for\
    \ v in group:\n            doAssert (mask and (1 shl v)) == 0\n            mask\
    \ = mask or (1 shl v)\n            doAssert id in bc.belong[v]\n        actual.add(mask)\n\
    \    actual.sort()\n    expected.sort()\n    doAssert actual == expected\n   \
    \ let tree = initBlockCutTree(bc)\n    doAssert tree.id == initBlockCutTree(sg).id\n\
    \    var treeEdges: seq[Edge]\n    for u in 0..<tree.forest.len:\n        for\
    \ v in tree.forest[u]:\n            if u < v: treeEdges.add((u, v))\n    doAssert\
    \ countComponents(labels(tree.forest.len, treeEdges)) == components\n    doAssert\
    \ treeEdges.len == tree.forest.len - components\n    for v in 0..<n:\n       \
    \ if ll.is_articulation[v]:\n            doAssert tree.id[v] >= bc.groups.len\n\
    \            doAssert tree.articulation[tree.id[v] - bc.groups.len] == v\n   \
    \         var adj = toSeq(tree.forest[tree.id[v]])\n            adj.sort()\n \
    \           var belong = bc.belong[v]\n            belong.sort()\n           \
    \ doAssert adj == belong\n        else:\n            doAssert bc.belong[v].len\
    \ == 1\n            doAssert tree.id[v] == bc.belong[v][0]\n\ncheck(0, @[])\n\
    for n in 1..5:\n    var possible: seq[Edge]\n    for u in 0..<n:\n        for\
    \ v in u+1..<n: possible.add((u, v))\n    for mask in 0..<(1 shl possible.len):\n\
    \        var edges: seq[Edge]\n        for i, e in possible:\n            if (mask\
    \ and (1 shl i)) != 0: edges.add(e)\n        check(n, edges)\nvar rng = initRand(20260912)\n\
    for trial in 0..<300:\n    let n = rng.rand(1..7)\n    var edges: seq[Edge]\n\
    \    for i in 0..<rng.rand(0..20): edges.add((rng.rand(n-1), rng.rand(n-1)))\n\
    \    check(n, edges)\n\nblock:\n    const n = 200000\n    var g = initUnWeightedUnDirectedGraph(n)\n\
    \    for v in 1..<n: g.add_edge(v-1, v)\n    let ll = initLowLink(g)\n    doAssert\
    \ ll.bridges.len == n-1\n    doAssert ll.articulation.len == n-2\n    doAssert\
    \ initTwoEdgeConnectedComponents(ll).groups.len == n\n    let bc = initBiconnectedComponents(ll)\n\
    \    doAssert bc.groups.len == n-1\n    doAssert bc == initBiconnectedComponents(g)\n\
    \    doAssert initBlockCutTree(bc).forest.len == 2*n-3\n\necho \"Hello World\"\
    \n"
  dependsOn:
  - cplib/graph/block_cut_tree.nim
  - cplib/graph/two_edge_connected_components.nim
  - cplib/graph/graph.nim
  - cplib/graph/lowlink.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/block_cut_tree.nim
  - cplib/graph/two_edge_connected_components.nim
  - cplib/graph/graph.nim
  - cplib/graph/biconnected_components.nim
  - cplib/graph/lowlink.nim
  isVerificationFile: true
  path: verify/AI/lowlink_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/lowlink_test.nim
layout: document
redirect_from:
- /verify/verify/AI/lowlink_test.nim
- /verify/verify/AI/lowlink_test.nim.html
title: verify/AI/lowlink_test.nim
---
