# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import math, os, strutils, xmlparser, xmltree
import cplib/graph/graph
import cplib/graph/graph_visualization
import cplib/utils/itertools

let directory = getTempDir() / ("cplib-graph-visualization-" & $getCurrentProcessId())
createDir(directory)
let path = directory / "graphs.html"

var called = 0
let required = 2
let matches = visualize_graphs(simple_graphs(3), proc(g: UnWeightedUnDirectedGraph): bool =
    inc called
    g.edge_count == required,
    output = path, max_results = 0, indexed = 1)
doAssert called == 8
doAssert matches == 3
var html = readFile(path)
doAssert html.count("<article ") == 3
doAssert html.count("<circle ") == 9
doAssert html.count("<line ") == 6
doAssert html.count("data-edge-count=\"2\"") == 3
doAssert html.contains("3 2\n1 2\n1 3\n")
doAssert not html.contains("marker-end=")
doAssert html.endsWith("</footer></html>\n")

called = 0
doAssert visualize_graphs(simple_graphs(5), proc(g: UnWeightedUnDirectedGraph): bool =
    inc called
    g.edge_count == 5,
    output = path) == 252
doAssert called == 1024
html = readFile(path)
doAssert html.count("<article ") == 252
doAssert html.count("data-edge-count=\"5\"") == 252
doAssert not html.contains("全件数は未集計")

called = 0
var generated = 0
iterator source(): UnWeightedUnDirectedGraph =
    for g in simple_graphs(4):
        inc generated
        yield g
doAssert visualize_graphs(source(), proc(g: UnWeightedUnDirectedGraph): bool =
    inc called
    true,
    output = path, max_results = 2) == 2
doAssert called == 2
doAssert generated == 2
html = readFile(path)
doAssert html.count("<article ") == 2
doAssert html.contains("全件数は未集計")

called = 0
iterator directedGraphs(): UnWeightedDirectedGraph =
    let edges = @[(0, 1), (0, 2), (1, 0), (1, 2), (2, 0), (2, 1)]
    for selected in combinations(edges, 2):
        var g = initUnWeightedDirectedGraph(3)
        for (u, v) in selected: g.add_edge(u, v)
        yield g
doAssert visualize_graphs(directedGraphs(), proc(g: UnWeightedDirectedGraph): bool =
    inc called
    true,
    output = path, max_results = 0) == 15
doAssert called == 15
html = readFile(path)
doAssert html.contains("有向グラフ")
doAssert html.count("marker-end=") == 30
doAssert html.count("<marker ") == 15
doAssert html.contains("id=\"arrow15\"")
doAssert html.contains("3 2\n0 1\n1 0\n")
doAssert not html.contains("nan")

doAssert visualize_graphs(simple_graphs(0), proc(g: UnWeightedUnDirectedGraph): bool = true,
    output = path) == 1
html = readFile(path)
doAssert html.count("<svg ") == 1
doAssert html.count("<circle ") == 0
doAssert visualize_graphs(@[initUnWeightedDirectedGraph(1)], proc(g: UnWeightedDirectedGraph): bool = true,
    output = path) == 1
html = readFile(path)
doAssert html.contains("cx=\"160.000\" cy=\"160.000\"")
doAssert visualize_graphs(simple_graphs(3), proc(g: UnWeightedUnDirectedGraph): bool = false,
    output = path) == 0
html = readFile(path)
doAssert html.count("<article ") == 0
doAssert html.contains("条件を満たすグラフはありません")

proc isPath(g: UnWeightedUnDirectedGraph): bool =
    for adjacent in g.edges:
        if adjacent.len > 2: return false
    true
doAssert visualize_graphs(unlabeled_trees(5), isPath, output = path) == 1
var trees = iterator(): UnWeightedUnDirectedGraph {.closure.} =
    for g in labeled_trees(3): yield g
doAssert visualize_graphs(trees(), isPath, output = path) == 3
var raised = false
try:
    discard visualize_graphs(simple_graphs(3), isPath, output = path, max_results = -1)
except ValueError:
    raised = true
doAssert raised
var nilPredicate: proc(g: UnWeightedUnDirectedGraph): bool
raised = false
try:
    discard visualize_graphs(simple_graphs(3), nilPredicate, output = path)
except ValueError:
    raised = true
doAssert raised

proc coordinates(html: string): seq[tuple[x, y: float]] =
    let start = html.find("<svg ")
    let stop = html.find("</svg>", start) + "</svg>".len
    let svg = parseXml(html[start..<stop])
    for node in svg.findAll("circle"):
        result.add((parseFloat(node.attr("cx")), parseFloat(node.attr("cy"))))

proc orientation(a, b, c: tuple[x, y: float]): float =
    (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)

proc checkLayout(g: UnWeightedUnDirectedGraph): seq[tuple[x, y: float]] =
    doAssert visualize_graphs(@[g], proc(g: UnWeightedUnDirectedGraph): bool = true,
        output = path) == 1
    let html = readFile(path)
    result = coordinates(html)
    doAssert result.len == g.len
    for i, p in result:
        doAssert p.x in 37.0..283.0 and p.y in 37.0..283.0
        for j in i + 1..<result.len:
            let dx = p.x - result[j].x
            let dy = p.y - result[j].y
            doAssert sqrt(dx * dx + dy * dy) > 34.0
    for i, e in g.edge_info:
        let a = result[e.src]
        let b = result[e.dst]
        for j in i + 1..<g.edge_info.len:
            let f = g.edge_info[j]
            if e.src == f.src or e.src == f.dst or e.dst == f.src or e.dst == f.dst: continue
            let c = result[f.src]
            let d = result[f.dst]
            doAssert not (orientation(a, b, c) * orientation(a, b, d) < -0.001 and
                orientation(c, d, a) * orientation(c, d, b) < -0.001)
    doAssert visualize_graphs(@[g], proc(g: UnWeightedUnDirectedGraph): bool = true,
        output = path) == 1
    doAssert readFile(path) == html

var crossedCycle = initUnWeightedUnDirectedGraph(4)
for (u, v) in [(0, 2), (2, 1), (1, 3), (3, 0)]: crossedCycle.add_edge(u, v)
discard checkLayout(crossedCycle)

var star = initUnWeightedUnDirectedGraph(6)
for v in 1..<6: star.add_edge(0, v)
let starPositions = checkLayout(star)
var center = (x: 0.0, y: 0.0)
for p in starPositions:
    center.x += p.x / 6.0
    center.y += p.y / 6.0
doAssert abs(starPositions[0].x - center.x) < 25.0
doAssert abs(starPositions[0].y - center.y) < 25.0

var chain = initUnWeightedUnDirectedGraph(6)
for v in 1..<6: chain.add_edge(v - 1, v)
discard checkLayout(chain)
var disconnected = initUnWeightedUnDirectedGraph(7)
for (u, v) in [(0, 1), (1, 2), (2, 3), (4, 5)]: disconnected.add_edge(u, v)
discard checkLayout(disconnected)

removeFile(path)
removeDir(directory)
echo "Hello World"
