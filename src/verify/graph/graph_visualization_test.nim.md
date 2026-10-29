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
    path: cplib/graph/graph_visualization.nim
    title: cplib/graph/graph_visualization.nim
  - icon: ':heavy_check_mark:'
    path: cplib/graph/graph_visualization.nim
    title: cplib/graph/graph_visualization.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/tree/prufer.nim
    title: cplib/tree/prufer.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
  - icon: ':heavy_check_mark:'
    path: cplib/utils/itertools.nim
    title: cplib/utils/itertools.nim
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
    import math, os, strutils, xmlparser, xmltree\nimport cplib/graph/graph\nimport\
    \ cplib/graph/graph_visualization\nimport cplib/utils/itertools\n\nlet directory\
    \ = getTempDir() / (\"cplib-graph-visualization-\" & $getCurrentProcessId())\n\
    createDir(directory)\nlet path = directory / \"graphs.html\"\n\nvar called = 0\n\
    let required = 2\nlet matches = visualize_graphs(simple_graphs(3), proc(g: UnWeightedUnDirectedGraph):\
    \ bool =\n    inc called\n    g.edge_count == required,\n    output = path, max_results\
    \ = 0, indexed = 1)\ndoAssert called == 8\ndoAssert matches == 3\nvar html = readFile(path)\n\
    doAssert html.count(\"<article \") == 3\ndoAssert html.count(\"<circle \") ==\
    \ 9\ndoAssert html.count(\"<line \") == 6\ndoAssert html.count(\"data-edge-count=\\\
    \"2\\\"\") == 3\ndoAssert html.contains(\"3 2\\n1 2\\n1 3\\n\")\ndoAssert not\
    \ html.contains(\"marker-end=\")\ndoAssert html.endsWith(\"</footer></html>\\\
    n\")\n\ncalled = 0\ndoAssert visualize_graphs(simple_graphs(5), proc(g: UnWeightedUnDirectedGraph):\
    \ bool =\n    inc called\n    g.edge_count == 5,\n    output = path) == 252\n\
    doAssert called == 1024\nhtml = readFile(path)\ndoAssert html.count(\"<article\
    \ \") == 252\ndoAssert html.count(\"data-edge-count=\\\"5\\\"\") == 252\ndoAssert\
    \ not html.contains(\"\u5168\u4EF6\u6570\u306F\u672A\u96C6\u8A08\")\n\ncalled\
    \ = 0\nvar generated = 0\niterator source(): UnWeightedUnDirectedGraph =\n   \
    \ for g in simple_graphs(4):\n        inc generated\n        yield g\ndoAssert\
    \ visualize_graphs(source(), proc(g: UnWeightedUnDirectedGraph): bool =\n    inc\
    \ called\n    true,\n    output = path, max_results = 2) == 2\ndoAssert called\
    \ == 2\ndoAssert generated == 2\nhtml = readFile(path)\ndoAssert html.count(\"\
    <article \") == 2\ndoAssert html.contains(\"\u5168\u4EF6\u6570\u306F\u672A\u96C6\
    \u8A08\")\n\ncalled = 0\niterator directedGraphs(): UnWeightedDirectedGraph =\n\
    \    let edges = @[(0, 1), (0, 2), (1, 0), (1, 2), (2, 0), (2, 1)]\n    for selected\
    \ in combinations(edges, 2):\n        var g = initUnWeightedDirectedGraph(3)\n\
    \        for (u, v) in selected: g.add_edge(u, v)\n        yield g\ndoAssert visualize_graphs(directedGraphs(),\
    \ proc(g: UnWeightedDirectedGraph): bool =\n    inc called\n    true,\n    output\
    \ = path, max_results = 0) == 15\ndoAssert called == 15\nhtml = readFile(path)\n\
    doAssert html.contains(\"\u6709\u5411\u30B0\u30E9\u30D5\")\ndoAssert html.count(\"\
    marker-end=\") == 30\ndoAssert html.count(\"<marker \") == 15\ndoAssert html.contains(\"\
    id=\\\"arrow15\\\"\")\ndoAssert html.contains(\"3 2\\n0 1\\n1 0\\n\")\ndoAssert\
    \ not html.contains(\"nan\")\n\ndoAssert visualize_graphs(simple_graphs(0), proc(g:\
    \ UnWeightedUnDirectedGraph): bool = true,\n    output = path) == 1\nhtml = readFile(path)\n\
    doAssert html.count(\"<svg \") == 1\ndoAssert html.count(\"<circle \") == 0\n\
    doAssert visualize_graphs(@[initUnWeightedDirectedGraph(1)], proc(g: UnWeightedDirectedGraph):\
    \ bool = true,\n    output = path) == 1\nhtml = readFile(path)\ndoAssert html.contains(\"\
    cx=\\\"160.000\\\" cy=\\\"160.000\\\"\")\ndoAssert visualize_graphs(simple_graphs(3),\
    \ proc(g: UnWeightedUnDirectedGraph): bool = false,\n    output = path) == 0\n\
    html = readFile(path)\ndoAssert html.count(\"<article \") == 0\ndoAssert html.contains(\"\
    \u6761\u4EF6\u3092\u6E80\u305F\u3059\u30B0\u30E9\u30D5\u306F\u3042\u308A\u307E\
    \u305B\u3093\")\n\nproc isPath(g: UnWeightedUnDirectedGraph): bool =\n    for\
    \ adjacent in g.edges:\n        if adjacent.len > 2: return false\n    true\n\
    doAssert visualize_graphs(unlabeled_trees(5), isPath, output = path) == 1\nvar\
    \ trees = iterator(): UnWeightedUnDirectedGraph {.closure.} =\n    for g in labeled_trees(3):\
    \ yield g\ndoAssert visualize_graphs(trees(), isPath, output = path) == 3\nvar\
    \ raised = false\ntry:\n    discard visualize_graphs(simple_graphs(3), isPath,\
    \ output = path, max_results = -1)\nexcept ValueError:\n    raised = true\ndoAssert\
    \ raised\nvar nilPredicate: proc(g: UnWeightedUnDirectedGraph): bool\nraised =\
    \ false\ntry:\n    discard visualize_graphs(simple_graphs(3), nilPredicate, output\
    \ = path)\nexcept ValueError:\n    raised = true\ndoAssert raised\n\nproc coordinates(html:\
    \ string): seq[tuple[x, y: float]] =\n    let start = html.find(\"<svg \")\n \
    \   let stop = html.find(\"</svg>\", start) + \"</svg>\".len\n    let svg = parseXml(html[start..<stop])\n\
    \    for node in svg.findAll(\"circle\"):\n        result.add((parseFloat(node.attr(\"\
    cx\")), parseFloat(node.attr(\"cy\"))))\n\nproc orientation(a, b, c: tuple[x,\
    \ y: float]): float =\n    (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)\n\
    \nproc checkLayout(g: UnWeightedUnDirectedGraph): seq[tuple[x, y: float]] =\n\
    \    doAssert visualize_graphs(@[g], proc(g: UnWeightedUnDirectedGraph): bool\
    \ = true,\n        output = path) == 1\n    let html = readFile(path)\n    result\
    \ = coordinates(html)\n    doAssert result.len == g.len\n    for i, p in result:\n\
    \        doAssert p.x in 37.0..283.0 and p.y in 37.0..283.0\n        for j in\
    \ i + 1..<result.len:\n            let dx = p.x - result[j].x\n            let\
    \ dy = p.y - result[j].y\n            doAssert sqrt(dx * dx + dy * dy) > 34.0\n\
    \    for i, e in g.edge_info:\n        let a = result[e.src]\n        let b =\
    \ result[e.dst]\n        for j in i + 1..<g.edge_info.len:\n            let f\
    \ = g.edge_info[j]\n            if e.src == f.src or e.src == f.dst or e.dst ==\
    \ f.src or e.dst == f.dst: continue\n            let c = result[f.src]\n     \
    \       let d = result[f.dst]\n            doAssert not (orientation(a, b, c)\
    \ * orientation(a, b, d) < -0.001 and\n                orientation(c, d, a) *\
    \ orientation(c, d, b) < -0.001)\n    doAssert visualize_graphs(@[g], proc(g:\
    \ UnWeightedUnDirectedGraph): bool = true,\n        output = path) == 1\n    doAssert\
    \ readFile(path) == html\n\nvar crossedCycle = initUnWeightedUnDirectedGraph(4)\n\
    for (u, v) in [(0, 2), (2, 1), (1, 3), (3, 0)]: crossedCycle.add_edge(u, v)\n\
    discard checkLayout(crossedCycle)\n\nvar star = initUnWeightedUnDirectedGraph(6)\n\
    for v in 1..<6: star.add_edge(0, v)\nlet starPositions = checkLayout(star)\nvar\
    \ center = (x: 0.0, y: 0.0)\nfor p in starPositions:\n    center.x += p.x / 6.0\n\
    \    center.y += p.y / 6.0\ndoAssert abs(starPositions[0].x - center.x) < 25.0\n\
    doAssert abs(starPositions[0].y - center.y) < 25.0\n\nvar chain = initUnWeightedUnDirectedGraph(6)\n\
    for v in 1..<6: chain.add_edge(v - 1, v)\ndiscard checkLayout(chain)\nvar disconnected\
    \ = initUnWeightedUnDirectedGraph(7)\nfor (u, v) in [(0, 1), (1, 2), (2, 3), (4,\
    \ 5)]: disconnected.add_edge(u, v)\ndiscard checkLayout(disconnected)\n\nremoveFile(path)\n\
    removeDir(directory)\necho \"Hello World\"\n"
  dependsOn:
  - cplib/graph/graph.nim
  - cplib/tree/prufer.nim
  - cplib/graph/graph.nim
  - cplib/utils/itertools.nim
  - cplib/graph/graph_visualization.nim
  - cplib/graph/graph_visualization.nim
  - cplib/utils/itertools.nim
  - cplib/tree/prufer.nim
  isVerificationFile: true
  path: verify/graph/graph_visualization_test.nim
  requiredBy: []
  timestamp: '2026-10-27 08:51:05+09:00'
  verificationStatus: TEST_ACCEPTED
  verifiedWith: []
documentation_of: verify/graph/graph_visualization_test.nim
layout: document
redirect_from:
- /verify/verify/graph/graph_visualization_test.nim
- /verify/verify/graph/graph_visualization_test.nim.html
title: verify/graph/graph_visualization_test.nim
---
