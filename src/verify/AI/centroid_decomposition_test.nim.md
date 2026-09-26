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
    path: cplib/tree/centroid_decomposition.nim
    title: cplib/tree/centroid_decomposition.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/centroid_decomposition.nim
    title: cplib/tree/centroid_decomposition.nim
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
    import cplib/tree/centroid_decomposition\nimport cplib/graph/graph\nimport random,\
    \ sequtils\n\nproc check(g: UnWeightedUnDirectedGraph, cd: CentroidDecomposition)\
    \ =\n    let n = g.len\n    doAssert cd.parent.len == n\n    doAssert cd.depth.len\
    \ == n\n    doAssert cd.children.len == n\n    if n == 0:\n        doAssert cd.root\
    \ == -1\n        return\n    doAssert cd.root in 0..<n\n    doAssert cd.parent[cd.root]\
    \ == -1\n    doAssert cd.depth[cd.root] == 0\n    var removed = newSeq[bool](n)\n\
    \    var visited = newSeq[bool](n)\n\n    proc checkComponent(c: int, vertices:\
    \ seq[int]) =\n        doAssert c in vertices\n        doAssert not visited[c]\n\
    \        visited[c] = true\n        removed[c] = true\n        var components:\
    \ seq[seq[int]]\n        var seen = newSeq[bool](n)\n        for start in vertices:\n\
    \            if removed[start] or seen[start]: continue\n            var component\
    \ = @[start]\n            seen[start] = true\n            var i = 0\n        \
    \    while i < component.len:\n                let u = component[i]\n        \
    \        inc i\n                for v in g[u]:\n                    if not removed[v]\
    \ and not seen[v]:\n                        seen[v] = true\n                 \
    \       component.add(v)\n            doAssert component.len <= vertices.len div\
    \ 2\n            components.add(component)\n        doAssert cd.children[c].len\
    \ == components.len\n        for component in components:\n            var child\
    \ = -1\n            for v in cd.children[c]:\n                if v in component:\n\
    \                    doAssert child == -1\n                    child = v\n   \
    \         doAssert child != -1\n            doAssert cd.parent[child] == c\n \
    \           doAssert cd.depth[child] == cd.depth[c] + 1\n            checkComponent(child,\
    \ component)\n\n    checkComponent(cd.root, toSeq(0..<n))\n    for v in 0..<n:\
    \ doAssert visited[v]\n\nproc checkTree(treeData: tuple[tree: UnWeightedDirectedGraph,\
    \ root: int, size, depth: seq[int]],\n               cd: CentroidDecomposition)\
    \ =\n    let (tree, root, size, depth) = treeData\n    doAssert root == cd.root\n\
    \    doAssert tree.len == cd.parent.len\n    doAssert size.len == tree.len\n \
    \   doAssert depth == cd.depth\n    if tree.len > 0:\n        doAssert size[root]\
    \ == tree.len\n    for u in 0..<tree.len:\n        doAssert toSeq(tree[u]) ==\
    \ cd.children[u]\n        var subtreeSize = 1\n        for v in tree[u]:\n   \
    \         subtreeSize += size[v]\n        doAssert size[u] == subtreeSize\n\n\
    check(initUnWeightedUnDirectedGraph(0),\n      initCentroidDecomposition(initUnWeightedUnDirectedGraph(0)))\n\
    checkTree(initCentroidDecompositionTree(initUnWeightedUnDirectedGraph(0)),\n \
    \         initCentroidDecomposition(initUnWeightedUnDirectedGraph(0)))\nvar rng\
    \ = initRand(20260908)\nfor n in 1..70:\n    for trial in 0..<12:\n        var\
    \ g = initUnWeightedUnDirectedGraph(n)\n        var staticG = initUnWeightedUnDirectedStaticGraph(n)\n\
    \        var weighted = initWeightedUnDirectedGraph(n, float)\n        var weightedStatic\
    \ = initWeightedUnDirectedStaticGraph(n, int64)\n        for v in 1..<n:\n   \
    \         let p = rng.rand(v - 1)\n            g.add_edge(p, v)\n            staticG.add_edge(p,\
    \ v)\n            weighted.add_edge(p, v, float(v - 35))\n            weightedStatic.add_edge(p,\
    \ v, int64(v))\n        staticG.build()\n        weightedStatic.build()\n    \
    \    let root = rng.rand(n - 1)\n        let before = g.edges\n        let cd\
    \ = initCentroidDecomposition(g, root)\n        check(g, cd)\n        checkTree(initCentroidDecompositionTree(g,\
    \ root), cd)\n        doAssert g.edges == before\n        check(g, initCentroidDecomposition(g))\n\
    \        checkTree(initCentroidDecompositionTree(g),\n                  initCentroidDecomposition(g))\n\
    \        for treeData in [initCentroidDecompositionTree(staticG, root),\n    \
    \                     initCentroidDecompositionTree(weighted, root),\n       \
    \                  initCentroidDecompositionTree(weightedStatic, root)]:\n   \
    \         checkTree(treeData, cd)\n        for other in [initCentroidDecomposition(staticG,\
    \ root),\n                      initCentroidDecomposition(weighted, root),\n \
    \                     initCentroidDecomposition(weightedStatic, root)]:\n    \
    \        check(g, other)\n            doAssert other.root == cd.root\n       \
    \     doAssert other.parent == cd.parent\n            doAssert other.depth ==\
    \ cd.depth\n            doAssert other.children == cd.children\n\nblock:\n   \
    \ const n = 200000\n    var path = initUnWeightedUnDirectedGraph(n)\n    var star\
    \ = initUnWeightedUnDirectedGraph(n)\n    for v in 1..<n:\n        path.add_edge(v\
    \ - 1, v)\n        star.add_edge(0, v)\n    let pathCd = initCentroidDecomposition(path)\n\
    \    doAssert pathCd.root in [n div 2 - 1, n div 2]\n    var maxDepth = 0\n  \
    \  for v in 0..<n:\n        maxDepth = max(maxDepth, pathCd.depth[v])\n      \
    \  if v != pathCd.root:\n            doAssert pathCd.depth[pathCd.parent[v]] +\
    \ 1 == pathCd.depth[v]\n    doAssert maxDepth <= 17\n    checkTree(initCentroidDecompositionTree(path),\
    \ pathCd)\n    let starCd = initCentroidDecomposition(star, n - 1)\n    checkTree(initCentroidDecompositionTree(star,\
    \ n - 1), starCd)\n    doAssert starCd.root == 0\n    doAssert starCd.children[0].len\
    \ == n - 1\n    for v in 1..<n:\n        doAssert starCd.parent[v] == 0\n    \
    \    doAssert starCd.depth[v] == 1\n        doAssert starCd.children[v].len ==\
    \ 0\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/tree/centroid_decomposition.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/tree/centroid_decomposition.nim
  isVerificationFile: true
  path: verify/AI/centroid_decomposition_test.nim
  requiredBy: []
  timestamp: '2026-09-17 22:59:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/centroid_decomposition_test.nim
layout: document
redirect_from:
- /verify/verify/AI/centroid_decomposition_test.nim
- /verify/verify/AI/centroid_decomposition_test.nim.html
title: verify/AI/centroid_decomposition_test.nim
---
