---
data:
  _extendedDependsOn:
  - icon: ':heavy_check_mark:'
    path: cplib/graph/euler_tour.nim
    title: cplib/graph/euler_tour.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/euler_tour.nim
    title: cplib/graph/euler_tour.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph.nim
    title: cplib/graph/graph.nim
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
    import random\nimport cplib/graph/graph\nimport cplib/graph/euler_tour\n\nproc\
    \ existsWalk(g: DirectedGraph or UnDirectedGraph, start: int, closed: bool): bool\
    \ =\n    var used = newSeq[bool](g.edge_count)\n    proc dfs(v, root, count: int):\
    \ bool =\n        if count == g.edge_count: return not closed or v == root\n \
    \       for (dst, id) in g.to_and_id(v):\n            if used[id]: continue\n\
    \            used[id] = true\n            if dfs(dst, root, count + 1): return\
    \ true\n            used[id] = false\n    if start != -1: return dfs(start, start,\
    \ 0)\n    for root in 0..<g.len:\n        if dfs(root, root, 0): return true\n\
    \nproc validWalk(g: DirectedGraph or UnDirectedGraph, path: seq[int], start: int,\
    \ closed: bool): bool =\n    if path.len != g.edge_count: return false\n    var\
    \ used = newSeq[bool](g.edge_count)\n    for id in path:\n        if id < 0 or\
    \ id >= g.edge_count or used[id]: return false\n        used[id] = true\n    for\
    \ root in 0..<g.len:\n        if start != -1 and root != start: continue\n   \
    \     var v = root\n        var valid = true\n        for id in path:\n      \
    \      let e = g.get_edge(id)\n            if e.src == v:\n                v =\
    \ e.dst\n            else:\n                when g is UnDirectedGraph:\n     \
    \               if e.dst == v: v = e.src\n                    else: valid = false\n\
    \                else:\n                    valid = false\n            if not\
    \ valid: break\n        if valid and (not closed or v == root): return true\n\n\
    proc check(g: DirectedGraph or UnDirectedGraph) =\n    when g is StaticGraphTypes:\
    \ g.build()\n    let before = g.edge_info\n    for start in -1..<g.len:\n    \
    \    for closed in [false, true]:\n            let path = if closed: g.euler_tour(start)\
    \ else: g.euler_trail(start)\n            if g.edge_count == 0:\n            \
    \    doAssert path.len == 0\n            else:\n                let exists = existsWalk(g,\
    \ start, closed)\n                doAssert (path.len > 0) == exists\n        \
    \        if exists: doAssert validWalk(g, path, start, closed)\n            doAssert\
    \ g.edge_info == before\n            doAssert path == (if closed: g.euler_tour(start)\
    \ else: g.euler_trail(start))\n\ntemplate checkGraphs(init: untyped) =\n    block:\n\
    \        var rng = initRand(91725)\n        for iteration in 0..<300:\n      \
    \      var g = init\n            for i in 0..<rng.rand(0..7):\n              \
    \  let u = rng.rand(0..<g.len)\n                let v = rng.rand(0..<g.len)\n\
    \                when g is WeightedGraph: g.add_edge(u, v, -i)\n             \
    \   else: g.add_edge(u, v)\n            check(g)\n\ncheckGraphs(initUnWeightedDirectedGraph(4))\n\
    checkGraphs(initUnWeightedUnDirectedGraph(4))\ncheckGraphs(initWeightedDirectedGraph(4))\n\
    checkGraphs(initWeightedUnDirectedGraph(4))\ncheckGraphs(initUnWeightedDirectedStaticGraph(4))\n\
    checkGraphs(initUnWeightedUnDirectedStaticGraph(4))\ncheckGraphs(initWeightedDirectedStaticGraph(4))\n\
    checkGraphs(initWeightedUnDirectedStaticGraph(4))\ncheck(initUnWeightedDirectedGraph(0))\n\
    check(initUnWeightedUnDirectedStaticGraph(0))\n\nblock:\n    var g = initUnWeightedUnDirectedGraph(5)\n\
    \    g.add_edge(1, 2)\n    g.add_edge(1, 2)\n    g.add_edge(2, 2)\n    check(g)\n\
    \    g.add_edge(3, 4)\n    g.add_edge(3, 4)\n    check(g)\n\nblock:\n    var g\
    \ = initUnWeightedDirectedGraph(4)\n    g.add_edge(0, 1)\n    g.add_edge(1, 0)\n\
    \    g.add_edge(2, 3)\n    g.add_edge(3, 2)\n    check(g)\n\nblock:\n    const\
    \ n = 100000\n    var g = initUnWeightedDirectedGraph(n)\n    for v in 0..<n -\
    \ 1: g.add_edge(v, v + 1)\n    let path = g.euler_trail()\n    doAssert path.len\
    \ == n - 1\n    for id in 0..<path.len: doAssert path[id] == id\n    doAssert\
    \ g.euler_tour().len == 0\n    g.add_edge(n - 1, 0)\n    doAssert g.euler_tour().len\
    \ == n\n\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/euler_tour.nim
  - cplib/graph/graph.nim
  - cplib/graph/graph.nim
  - cplib/graph/euler_tour.nim
  isVerificationFile: true
  path: verify/AI/euler_tour_test.nim
  requiredBy: []
  timestamp: '2026-09-18 12:10:16+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/AI/euler_tour_test.nim
layout: document
redirect_from:
- /verify/verify/AI/euler_tour_test.nim
- /verify/verify/AI/euler_tour_test.nim.html
title: verify/AI/euler_tour_test.nim
---
