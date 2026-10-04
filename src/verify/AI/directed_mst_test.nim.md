---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/collections/lazy_leftist_heap.nim
    title: cplib/collections/lazy_leftist_heap.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/directed_mst.nim
    title: cplib/graph/directed_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/directed_mst.nim
    title: cplib/graph/directed_mst.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
  - icon: ':heavy_check_mark:'
    path: cplib/math/int128.nim
    title: cplib/math/int128.nim
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
    import cplib/graph/graph\nimport cplib/graph/directed_mst\nimport options, random,\
    \ algorithm\n\nproc valid(n, root: int, edges: seq[EdgeInfo[int64]], ids: seq[int]):\
    \ bool =\n    if ids.len != n or ids[root] != -1: return false\n    var children\
    \ = newSeq[seq[int]](n)\n    for v in 0..<n:\n        if v == root: continue\n\
    \        let id = ids[v]\n        if id < 0 or id >= edges.len or edges[id].dst\
    \ != v: return false\n        children[edges[id].src].add(v)\n    var visited\
    \ = newSeq[bool](n)\n    visited[root] = true\n    var stack = @[root]\n    var\
    \ count = 0\n    while stack.len > 0:\n        let v = stack.pop()\n        inc\
    \ count\n        for u in children[v]:\n            if visited[u]: return false\n\
    \            visited[u] = true\n            stack.add(u)\n    count == n\n\nproc\
    \ brute(n, root: int, edges: seq[EdgeInfo[int64]]): Option[int64] =\n    var incoming\
    \ = newSeq[seq[int]](n)\n    for id, e in edges:\n        if e.dst != root and\
    \ e.src != e.dst: incoming[e.dst].add(id)\n    var ids = newSeq[int](n)\n    ids[root]\
    \ = -1\n    var best = none(int64)\n    proc enumerate(v: int, cost: int64) =\n\
    \        if v == n:\n            if valid(n, root, edges, ids) and (best.isNone\
    \ or cost < best.get()):\n                best = some(cost)\n        elif v ==\
    \ root: enumerate(v + 1, cost)\n        else:\n            for id in incoming[v]:\n\
    \                ids[v] = id\n                enumerate(v + 1, cost + edges[id].cost)\n\
    \    enumerate(0, 0)\n    best\n\nvar checked = 0\nproc check(n, root: int, edges:\
    \ seq[EdgeInfo[int64]], allTypes = false) =\n    let expected = brute(n, root,\
    \ edges)\n    var g = initWeightedDirectedGraph(n, int64)\n    var s = initWeightedDirectedStaticGraph(n,\
    \ int64)\n    for e in edges:\n        g.add_edge(e.src, e.dst, e.cost)\n    \
    \    s.add_edge(e.src, e.dst, e.cost)\n    let before = g.edge_info\n    for actual\
    \ in [g.directedMST(root), s.directedMST(root)]:\n        doAssert actual.isSome\
    \ == expected.isSome\n        if actual.isSome:\n            let tree = actual.get()\n\
    \            doAssert valid(n, root, edges, tree.inEdge)\n            var sum\
    \ = 0'i64\n            for id in tree.inEdge:\n                if id >= 0: sum\
    \ += edges[id].cost\n            doAssert sum == tree.cost and tree.cost == expected.get()\n\
    \    s.build()\n    doAssert s.directedMST(root) == g.directedMST(root)\n    doAssert\
    \ g.edge_info == before\n    if allTypes:\n        var small = initWeightedDirectedGraph(n,\
    \ int32)\n        var native = initWeightedDirectedStaticGraph(n, int)\n     \
    \   for e in edges:\n            small.add_edge(e.src, e.dst, e.cost.int32)\n\
    \            native.add_edge(e.src, e.dst, e.cost.int)\n        doAssert small.directedMST(root)\
    \ == g.directedMST(root)\n        doAssert native.directedMST(root) == g.directedMST(root)\n\
    \    inc checked\n\nfor n in 1..4:\n    for mask in 0..<(1 shl (n * (n - 1))):\n\
    \        var edges: seq[EdgeInfo[int64]]\n        var bit = 0\n        for u in\
    \ 0..<n:\n            for v in 0..<n:\n                if u == v: continue\n \
    \               if (mask and (1 shl bit)) != 0:\n                    edges.add(EdgeInfo[int64](src:\
    \ u, dst: v, cost: int64((bit * 7) mod 5 - 2)))\n                inc bit\n   \
    \     for root in 0..<n: check(n, root, edges, mask mod 499 == 0)\n\nvar rng =\
    \ initRand(928371)\nfor trial in 0..<1200:\n    let n = rng.rand(1..6)\n    var\
    \ edges: seq[EdgeInfo[int64]]\n    for id in 0..<rng.rand(0..16):\n        edges.add(EdgeInfo[int64](src:\
    \ rng.rand(n - 1), dst: rng.rand(n - 1), cost: rng.rand(-7..7).int64))\n    let\
    \ root = rng.rand(n - 1)\n    check(n, root, edges, trial mod 23 == 0)\n    edges.reverse()\n\
    \    check(n, root, edges)\n    if edges.len > 0: edges.add(edges[0])\n    check(n,\
    \ root, edges)\n\nblock:\n    var g = initWeightedDirectedGraph(3, int64)\n  \
    \  g.add_edge(0, 1, low(int64))\n    g.add_edge(1, 2, high(int64))\n    g.add_edge(2,\
    \ 1, high(int64))\n    doAssert g.directedMST(0).get().cost == -1\nblock:\n  \
    \  var g = initWeightedDirectedGraph(3, int64)\n    g.add_edge(0, 1, high(int64))\n\
    \    g.add_edge(1, 2, low(int64))\n    g.add_edge(2, 1, low(int64))\n    let a\
    \ = g.directedMST(0).get()\n    doAssert a.cost == -1 and a.inEdge == @[-1, 0,\
    \ 1]\nfor weight in [high(int64), low(int64)]:\n    var g = initWeightedDirectedGraph(3,\
    \ int64)\n    g.add_edge(0, 1, weight)\n    g.add_edge(0, 2, weight)\n    var\
    \ rejected = false\n    try: discard g.directedMST(0)\n    except OverflowDefect:\
    \ rejected = true\n    doAssert rejected\nfor n in [0, 1, 3]:\n    for root in\
    \ [-1, n]:\n        var rejected = false\n        try: discard initWeightedDirectedGraph(n,\
    \ int64).directedMST(root)\n        except ValueError: rejected = true\n     \
    \   doAssert rejected\nfor weight in [-3, 0, 127]:\n    var g8 = initWeightedDirectedGraph(2,\
    \ int8)\n    var g16 = initWeightedDirectedStaticGraph(2, int16)\n    g8.add_edge(0,\
    \ 1, weight.int8)\n    g16.add_edge(0, 1, weight.int16)\n    doAssert g8.directedMST(0).get().cost\
    \ == weight.int64\n    doAssert g16.directedMST(0) == g8.directedMST(0)\nblock:\n\
    \    var huge = WeightedDirectedGraph[int64](len: high(int32).int)\n    var rejected\
    \ = false\n    try: discard huge.directedMST(0)\n    except ValueError: rejected\
    \ = true\n    doAssert rejected\nblock:\n    var g = initWeightedDirectedGraph(2,\
    \ int64)\n    g.edge_info.add(EdgeInfo[int64](src: 2, dst: 1, cost: 0))\n    var\
    \ rejected = false\n    try: discard g.directedMST(0)\n    except ValueError:\
    \ rejected = true\n    doAssert rejected\n\nblock:\n    # \u4E8C\u9802\u70B9\u306E\
    \u9589\u8DEF\u3092\u3001\u6B8B\u308B\u9802\u70B9\u3068\u4E00\u3064\u305A\u3064\
    \u5165\u308C\u5B50\u306B\u7E2E\u7D04\u3059\u308B\u3002\n    const n = 200000\n\
    \    var g = initWeightedDirectedStaticGraph(n, int64)\n    g.add_edge(1, 2, 0)\n\
    \    g.add_edge(2, 1, 0)\n    for v in 3..<n:\n        g.add_edge(1, v, 0)\n \
    \       g.add_edge(v, 1, int64(v - 2))\n    g.add_edge(0, 1, int64(n))\n    let\
    \ answer = g.directedMST(0).get()\n    doAssert answer.cost == n.int64\n    doAssert\
    \ valid(n, 0, g.edge_info, answer.inEdge)\n    doAssert answer.inEdge[1] == g.edge_info.len\
    \ - 1\n    for v in 2..<n: doAssert g.edge_info[answer.inEdge[v]].src == 1\n \
    \   doAssert g.directedMST(n - 1).isNone\n\nstderr.writeLine(\"directed MST regression:\
    \ \", checked, \" small graphs and boundary/nested cases passed\")\necho \"Hello\
    \ World\"\n"
  dependsOn:
  - cplib/collections/lazy_leftist_heap.nim
  - cplib/graph/directed_mst.nim
  - cplib/graph/directed_mst.nim
  - cplib/math/int128.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/math/int128.nim
  - cplib/collections/lazy_leftist_heap.nim
  isVerificationFile: true
  path: verify/AI/directed_mst_test.nim
  requiredBy: []
  timestamp: '2026-10-04 00:13:01+00:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/directed_mst_test.nim
layout: document
redirect_from:
- /verify/verify/AI/directed_mst_test.nim
- /verify/verify/AI/directed_mst_test.nim.html
title: verify/AI/directed_mst_test.nim
---
