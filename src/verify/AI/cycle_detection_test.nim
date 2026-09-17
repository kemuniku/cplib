# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/graph/cycle_detection

proc check(g: DirectedGraph or UnDirectedGraph, expected: bool) =
    let cycle = g.cycle_detection()
    doAssert (cycle.len > 0) == expected
    let vertices = g.restore_cycle_vertices(cycle)
    doAssert vertices.len == cycle.len
    var seenVertices = newSeq[bool](g.len)
    var seenEdges = newSeq[bool](g.edge_count)
    for i, id in cycle:
        let v = vertices[i]
        let to = vertices[(i + 1) mod vertices.len]
        doAssert not seenVertices[v]
        doAssert not seenEdges[id]
        seenVertices[v] = true
        seenEdges[id] = true
        let e = g.get_edge(id)
        when g is DirectedGraph:
            doAssert e.src == v and e.dst == to
        else:
            doAssert (e.src == v and e.dst == to) or (e.dst == v and e.src == to)

proc hasCycle(n: int, edges: seq[(int, int)], undirected: bool): bool =
    var reach = newSeqWith(n, newSeq[bool](n))
    for (u, v) in edges:
        if undirected:
            if u == v or reach[u][v]: return true
            reach[v][u] = true
        reach[u][v] = true
        for k in 0..<n:
            for i in 0..<n:
                for j in 0..<n:
                    reach[i][j] = reach[i][j] or (reach[i][k] and reach[k][j])
    if not undirected:
        for v in 0..<n:
            if reach[v][v]: return true

template checkTypes(n: int, edges: seq[(int, int)]) =
    block:
        let directedCycle = hasCycle(n, edges, false)
        let undirectedCycle = hasCycle(n, edges, true)
        template run(init: untyped) =
            block:
                var g = init
                for (u, v) in edges:
                    when g is WeightedGraph: g.add_edge(u, v, -7)
                    else: g.add_edge(u, v)
                when g is StaticGraphTypes: g.build()
                when g is UnDirectedGraph: check(g, undirectedCycle)
                else: check(g, directedCycle)
        run(initUnWeightedDirectedGraph(n))
        run(initUnWeightedUnDirectedGraph(n))
        run(initWeightedDirectedGraph(n))
        run(initWeightedUnDirectedGraph(n))
        run(initUnWeightedDirectedStaticGraph(n))
        run(initUnWeightedUnDirectedStaticGraph(n))
        run(initWeightedDirectedStaticGraph(n))
        run(initWeightedUnDirectedStaticGraph(n))

checkTypes(0, newSeq[(int, int)]())
checkTypes(4, newSeq[(int, int)]())
checkTypes(1, @[(0, 0)])
checkTypes(2, @[(0, 1)])
checkTypes(2, @[(0, 1), (0, 1)])
checkTypes(2, @[(0, 1), (1, 0)])
checkTypes(3, @[(1, 0), (1, 2), (0, 2)])
checkTypes(4, @[(0, 1), (0, 2), (2, 1), (1, 3), (2, 3)])
checkTypes(6, @[(0, 1), (2, 3), (3, 4), (4, 2)])
var rng = initRand(20260917)
for trial in 0..<400:
    let n = rng.rand(1..8)
    var edges: seq[(int, int)]
    for i in 0..<rng.rand(0..20):
        edges.add((rng.rand(n - 1), rng.rand(n - 1)))
    checkTypes(n, edges)

template checkDeep(init: untyped) =
    block:
        var g = init
        for i in 1..<g.len: g.add_edge(i - 1, i)
        when g is StaticGraphTypes: g.build()
        check(g, false)
        g.add_edge(g.len - 1, 0)
        when g is StaticGraphTypes: g.build()
        check(g, true)
        doAssert g.cycle_detection().len == g.len
checkDeep(initUnWeightedDirectedGraph(200000))
checkDeep(initUnWeightedUnDirectedGraph(200000))
checkDeep(initUnWeightedDirectedStaticGraph(200000))
checkDeep(initUnWeightedUnDirectedStaticGraph(200000))
echo "Hello World"
