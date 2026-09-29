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
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/mo.nim
    title: cplib/utils/mo.nim
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
    import random, sequtils\nimport cplib/utils/mo\nimport cplib/graph/graph\n\nproc\
    \ edgeValue(u, v: int): int = (min(u, v) + 1) * 101 + max(u, v)\n\nproc naivePath(adj:\
    \ seq[seq[int]], u, v: int): seq[int] =\n    var parent = newSeqWith(adj.len,\
    \ -1)\n    var queue = @[u]\n    parent[u] = u\n    var head = 0\n    while head\
    \ < queue.len:\n        let x = queue[head]\n        inc head\n        for y in\
    \ adj[x]:\n            if parent[y] == -1:\n                parent[y] = x\n  \
    \              queue.add(y)\n    var x = v\n    while x != u:\n        result.add(x)\n\
    \        x = parent[x]\n    result.add(u)\n\nproc checkTree(adj: seq[seq[int]],\
    \ queries: seq[(int, int)], root, width, kind: int) =\n    let n = adj.len\n \
    \   var mo: TreeMo\n    case kind\n    of 0:\n        mo = initTreeMo(adj, queries.len,\
    \ root, width)\n    of 1:\n        var g = initUnWeightedUnDirectedGraph(n)\n\
    \        for u in 0..<n:\n            for v in adj[u]:\n                if u <\
    \ v: g.add_edge(u, v)\n        mo = initTreeMo(g, queries.len, root, width)\n\
    \    of 2:\n        var g = initUnWeightedUnDirectedStaticGraph(n)\n        for\
    \ u in 0..<n:\n            for v in adj[u]:\n                if u < v: g.add_edge(u,\
    \ v)\n        g.build()\n        mo = initTreeMo(g, queries.len, root, width)\n\
    \    of 3:\n        var g = initWeightedUnDirectedGraph(n)\n        for u in 0..<n:\n\
    \            for v in adj[u]:\n                if u < v: g.add_edge(u, v, edgeValue(u,\
    \ v))\n        mo = initTreeMo(g, queries.len, root, width)\n    else:\n     \
    \   var g = initWeightedUnDirectedStaticGraph(n)\n        for u in 0..<n:\n  \
    \          for v in adj[u]:\n                if u < v: g.add_edge(u, v, edgeValue(u,\
    \ v))\n        g.build()\n        mo = initTreeMo(g, queries.len, root, width)\n\
    \    for i, (u, v) in queries:\n        doAssert mo.insert(u, v) == i\n    var\
    \ active = newSeq[bool](n)\n    var degree = newSeq[int](n)\n    var edges = newSeqWith(n,\
    \ newSeq[bool](n))\n    active[root] = true\n    var vertexSum = root + 1\n  \
    \  var edgeSum, updates: int\n    var answers = newSeq[(int, int)](queries.len)\n\
    \    var seen = newSeq[int](queries.len)\n    proc checkPath() =\n        var\
    \ vertices, edgeEnds: int\n        for v in 0..<n:\n            if active[v]:\
    \ inc vertices\n            else: doAssert degree[v] == 0\n            doAssert\
    \ degree[v] in 0..2\n            edgeEnds += degree[v]\n        doAssert vertices\
    \ > 0 and edgeEnds == 2 * (vertices - 1)\n    proc addVertex(u, v: int) =\n  \
    \      doAssert v in adj[u]\n        doAssert active[u] and not active[v] and\
    \ degree[u] <= 1\n        doAssert not edges[u][v] and not edges[v][u]\n     \
    \   edges[u][v] = true\n        edges[v][u] = true\n        active[v] = true\n\
    \        inc degree[u]\n        inc degree[v]\n        vertexSum += v + 1\n  \
    \      edgeSum += edgeValue(u, v)\n        inc updates\n        checkPath()\n\
    \    proc deleteVertex(u, v: int) =\n        doAssert v in adj[u]\n        doAssert\
    \ active[u] and active[v] and degree[v] == 1\n        doAssert edges[u][v] and\
    \ edges[v][u]\n        edges[u][v] = false\n        edges[v][u] = false\n    \
    \    active[v] = false\n        dec degree[u]\n        dec degree[v]\n       \
    \ vertexSum -= v + 1\n        edgeSum -= edgeValue(u, v)\n        inc updates\n\
    \        checkPath()\n    proc remember(idx: int) =\n        let path = naivePath(adj,\
    \ queries[idx][0], queries[idx][1])\n        var expected = newSeq[bool](n)\n\
    \        var vs, es: int\n        for i, v in path:\n            expected[v] =\
    \ true\n            vs += v + 1\n            if i > 0:\n                doAssert\
    \ edges[path[i - 1]][v]\n                es += edgeValue(path[i - 1], v)\n   \
    \     doAssert active == expected\n        doAssert (vertexSum, edgeSum) == (vs,\
    \ es)\n        answers[idx] = (vertexSum, edgeSum)\n        inc seen[idx]\n  \
    \  for repeat in 0..<2:\n        updates = 0\n        mo.run(addVertex, deleteVertex,\
    \ remember = remember)\n        doAssert vertexSum == root + 1 and edgeSum ==\
    \ 0\n        for v in 0..<n: doAssert active[v] == (v == root) and degree[v] ==\
    \ 0\n        for count in seen: doAssert count == repeat + 1\n        let length\
    \ = 2 * n - 1\n        doAssert updates <= 4 * length * (length div mo.width +\
    \ 2) + queries.len * mo.width\n        if queries.len == 0: doAssert updates ==\
    \ 0\n\nvar rng = initRand(742819)\nfor n in 1..12:\n    for shape in 0..2:\n \
    \       var adj = newSeq[seq[int]](n)\n        for v in 1..<n:\n            let\
    \ p = if shape == 0: v - 1 elif shape == 1: 0 else: rng.rand(v - 1)\n        \
    \    adj[p].add(v)\n            adj[v].add(p)\n        var queries: seq[(int,\
    \ int)]\n        for u in 0..<n:\n            for v in 0..<n: queries.add((u,\
    \ v))\n        queries.add((0, n - 1))\n        rng.shuffle(queries)\n       \
    \ for width in [0, 1, 3, n, 2 * n + 10]:\n            checkTree(adj, queries,\
    \ rng.rand(n - 1), width, rng.rand(4))\n        checkTree(adj, @[], n - 1, 0,\
    \ shape)\n\nfor trial in 0..<50:\n    let n = rng.rand(30) + 1\n    var adj =\
    \ newSeq[seq[int]](n)\n    for v in 1..<n:\n        let p = rng.rand(v - 1)\n\
    \        adj[p].add(v)\n        adj[v].add(p)\n    var queries: seq[(int, int)]\n\
    \    for i in 0..<100: queries.add((rng.rand(n - 1), rng.rand(n - 1)))\n    checkTree(adj,\
    \ queries, rng.rand(n - 1), rng.rand(2 * n), trial mod 5)\n\nproc checkCallbackFactories()\
    \ =\n    var mo = initTreeMo(@[@[1], @[0, 2], @[1]], 3, root = 1)\n    mo.insert(0,\
    \ 2)\n    mo.insert(2, 2)\n    var state = 2\n    var factories, records: int\n\
    \    proc makeAdd(): proc(u, v: int) {.closure.} =\n        inc factories\n  \
    \      result = proc(u, v: int) = state += v + 1\n    proc makeDelete(): proc(u,\
    \ v: int) {.closure.} =\n        inc factories\n        result = proc(u, v: int)\
    \ = state -= v + 1\n    proc makeRemember(): proc(idx: int) {.closure.} =\n  \
    \      inc factories\n        result = proc(idx: int) =\n            doAssert\
    \ state == [6, 3, 3][idx]\n            inc records\n    mo.run(makeAdd(), makeDelete(),\
    \ makeRemember())\n    doAssert factories == 3 and records == 2 and state == 2\n\
    \    doAssert mo.insert(1, 0) == 2\n    mo.run(makeAdd(), makeDelete(), makeRemember())\n\
    \    doAssert factories == 6 and records == 5 and state == 2\n\ncheckCallbackFactories()\n\
    \nblock:\n    const n = 200000\n    var g = initUnWeightedUnDirectedStaticGraph(n)\n\
    \    for v in 1..<n: g.add_edge(v - 1, v)\n    g.build()\n    var mo = initTreeMo(g,\
    \ 4)\n    mo.insert(0, n - 1)\n    mo.insert(n - 1, 0)\n    mo.insert(n - 1, n\
    \ - 1)\n    mo.insert(n div 2, n - 1)\n    var state = 1\n    var answers: array[4,\
    \ int]\n    mo.run(\n        proc(u, v: int) = state += v + 1,\n        proc(u,\
    \ v: int) = state -= v + 1,\n        proc(idx: int) = answers[idx] = state\n \
    \   )\n    let total = n * (n + 1) div 2\n    doAssert answers == [total, total,\
    \ n, total - (n div 2) * (n div 2 + 1) div 2]\n    doAssert state == 1\n\necho\
    \ \"Hello World\"\n"
  dependsOn:
  - cplib/utils/mo.nim
  - cplib/utils/mo.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  isVerificationFile: true
  path: verify/AI/tree_mo_test.nim
  requiredBy: []
  timestamp: '2026-09-27 00:37:04+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/tree_mo_test.nim
layout: document
redirect_from:
- /verify/verify/AI/tree_mo_test.nim
- /verify/verify/AI/tree_mo_test.nim.html
title: verify/AI/tree_mo_test.nim
---
