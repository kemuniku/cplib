# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/hopcroft_karp
import cplib/graph/graph
import bitops, random, sets

type
    Edge = tuple[left, right: int]
    Sizes = tuple[vertex, independent, edge: int]

template expectValueError(body: untyped) =
    block:
        var raised = false
        try:
            body
        except ValueError:
            raised = true
        doAssert raised

proc brute(n: int, edges: seq[Edge]): Sizes =
    result.vertex = n
    for mask in 0..<(1 shl n):
        var covered = true
        for (u, v) in edges:
            if (mask and ((1 shl u) or (1 shl v))) == 0:
                covered = false
                break
        if covered: result.vertex = min(result.vertex, countSetBits(mask))
    result.independent = n - result.vertex
    var dp = newSeq[int](1 shl n)
    for mask in 1..<dp.len: dp[mask] = n + 1
    for (u, v) in edges:
        let endpoints = (1 shl u) or (1 shl v)
        for mask in 0..<dp.len:
            let target = mask or endpoints
            dp[target] = min(dp[target], dp[mask] + 1)
    result.edge = if dp[^1] > n: -1 else: dp[^1]

proc validateVertices(n: int, edges: seq[Edge], cover, independent: seq[int], sizes: Sizes) =
    doAssert cover.len == sizes.vertex
    doAssert independent.len == sizes.independent
    var inCover, inIndependent = newSeq[bool](n)
    for v in cover:
        doAssert v in 0..<n
        doAssert not inCover[v]
        inCover[v] = true
    for v in independent:
        doAssert v in 0..<n
        doAssert not inIndependent[v]
        inIndependent[v] = true
    for (u, v) in edges:
        doAssert inCover[u] or inCover[v]
        doAssert not (inIndependent[u] and inIndependent[v])

proc validateEdges(n: int, edges, answer: seq[Edge], size: int, matching: bool) =
    doAssert answer.len == size
    var available, used: HashSet[Edge]
    for (u, v) in edges: available.incl((min(u, v), max(u, v)))
    var covered = newSeq[bool](n)
    for (u, v) in answer:
        doAssert u in 0..<n and v in 0..<n
        let edge = (min(u, v), max(u, v))
        doAssert edge in available and edge notin used
        used.incl(edge)
        if matching: doAssert not covered[u] and not covered[v]
        covered[u] = true
        covered[v] = true
    if not matching:
        for value in covered: doAssert value

proc flatten(vertices: tuple[left, right: seq[int]], left: int): seq[int] =
    result = vertices.left
    for u in vertices.right: result.add(left + u)

proc flatten(edges: seq[Edge], left: int): seq[Edge] =
    for (v, u) in edges: result.add((v, left + u))

proc check(g: var HopcroftKarp, left, right: int, edges: seq[Edge], sizes: Sizes) =
    let n = left + right
    let originalEdges = edges.flatten(left)
    var coverFirst, independentFirst, edgeFirst = g
    let cover = coverFirst.get_minimum_vertex_cover()
    let independent = independentFirst.get_maximum_independent_set()
    validateVertices(n, originalEdges, cover.flatten(left), independent.flatten(left), sizes)
    if sizes.edge < 0:
        expectValueError:
            discard edgeFirst.get_minimum_edge_cover()
    else:
        validateEdges(n, originalEdges, edgeFirst.get_minimum_edge_cover().flatten(left), sizes.edge, false)
    doAssert g.minimum_vertex_cover() == sizes.vertex
    doAssert g.maximum_independent_set() == sizes.independent
    doAssert g.minimum_edge_cover() == sizes.edge
    doAssert g.minimum_vertex_cover() == sizes.vertex
    validateVertices(n, originalEdges, g.get_minimum_vertex_cover().flatten(left),
        g.get_maximum_independent_set().flatten(left), sizes)
    validateEdges(n, originalEdges, g.get_matching().flatten(left), sizes.vertex, true)

proc checkGraph(g: UnDirectedGraph, edges: seq[Edge], sizes: Sizes) =
    let originalEdges = g.edge_info
    validateVertices(g.len, edges, g.get_minimum_vertex_cover(), g.get_maximum_independent_set(), sizes)
    validateEdges(g.len, edges, g.get_matching(), sizes.vertex, true)
    validateEdges(g.len, edges, g.get_matching(useRelabel = false), sizes.vertex, true)
    doAssert g.matching() == sizes.vertex
    doAssert g.matching(useRelabel = false) == sizes.vertex
    doAssert g.minimum_vertex_cover() == sizes.vertex
    doAssert g.maximum_independent_set() == sizes.independent
    doAssert g.minimum_edge_cover() == sizes.edge
    if sizes.edge < 0:
        expectValueError:
            discard g.get_minimum_edge_cover()
    else:
        validateEdges(g.len, edges, g.get_minimum_edge_cover(), sizes.edge, false)
    doAssert originalEdges == g.edge_info

proc checkGraphs(n: int, edges: seq[Edge], sizes: Sizes) =
    var dynamic = initUnWeightedUnDirectedGraph(n)
    var staticGraph = initUnWeightedUnDirectedStaticGraph(n)
    var weighted = initWeightedUnDirectedGraph(n, int64)
    var weightedStatic = initWeightedUnDirectedStaticGraph(n, float)
    for i, (u, v) in edges:
        dynamic.add_edge(u, v)
        staticGraph.add_edge(v, u)
        weighted.add_edge(u, v, int64(i mod 7 - 3))
        weightedStatic.add_edge(v, u, float(i mod 5 - 2))
    staticGraph.build()
    weightedStatic.build()
    let originalAdjacent = dynamic.edges
    let originalStatic = staticGraph.elist
    dynamic.checkGraph(edges, sizes)
    staticGraph.checkGraph(edges, sizes)
    weighted.checkGraph(edges, sizes)
    weightedStatic.checkGraph(edges, sizes)
    doAssert dynamic.edges == originalAdjacent
    doAssert staticGraph.elist == originalStatic

for left in 0..3:
    for right in 0..3:
        for mask in 0..<(1 shl (left * right)):
            var edges: seq[Edge]
            var g = initHopcroftKarp(left, right)
            for v in 0..<left:
                for u in 0..<right:
                    if (mask and (1 shl (v * right + u))) != 0:
                        edges.add((v, u))
                        g.add_edge(v, u)
            let originalEdges = edges.flatten(left)
            let sizes = brute(left + right, originalEdges)
            g.check(left, right, edges, sizes)
            checkGraphs(left + right, originalEdges, sizes)

var rng = initRand(314159)
for trial in 0..<100:
    let left = rng.rand(1..4)
    let right = rng.rand(1..4)
    var g = initHopcroftKarp(left, right)
    var edges: seq[Edge]
    var permutation = newSeq[int](left + right)
    for v in 0..<permutation.len: permutation[v] = v
    rng.shuffle(permutation)
    for step in 0..<20:
        let v = rng.rand(left - 1)
        let u = rng.rand(right - 1)
        edges.add((v, u))
        g.add_edge(v, u)
        let sizes = brute(left + right, edges.flatten(left))
        g.check(left, right, edges, sizes)
        if step mod 5 == 0:
            var permuted: seq[Edge]
            for i, (a, b) in edges:
                if i mod 2 == 0: permuted.add((permutation[a], permutation[left + b]))
                else: permuted.add((permutation[left + b], permutation[a]))
            checkGraphs(left + right, permuted, sizes)

proc checkInvalid(g: UnDirectedGraph) =
    expectValueError: discard g.matching()
    expectValueError: discard g.get_matching()
    expectValueError: discard g.minimum_vertex_cover()
    expectValueError: discard g.get_minimum_vertex_cover()
    expectValueError: discard g.maximum_independent_set()
    expectValueError: discard g.get_maximum_independent_set()
    expectValueError: discard g.minimum_edge_cover()
    expectValueError: discard g.get_minimum_edge_cover()

for edges in [@[(0, 0)], @[(0, 1), (1, 2), (2, 0)], @[(0, 1), (3, 4), (4, 5), (5, 3)]]:
    var g = initUnWeightedUnDirectedGraph(6)
    var sg = initUnWeightedUnDirectedStaticGraph(6)
    var wg = initWeightedUnDirectedGraph(6)
    var wsg = initWeightedUnDirectedStaticGraph(6)
    for (u, v) in edges:
        g.add_edge(u, v)
        sg.add_edge(u, v)
        wg.add_edge(u, v, 1)
        wsg.add_edge(u, v, 1)
    sg.build()
    wsg.build()
    g.checkInvalid()
    sg.checkInvalid()
    wg.checkInvalid()
    wsg.checkInvalid()

static:
    doAssert not compiles(initUnWeightedDirectedGraph(2).matching())
    doAssert not compiles(initWeightedDirectedGraph(2).get_matching())
    doAssert not compiles(initUnWeightedDirectedStaticGraph(2).minimum_vertex_cover())
    doAssert not compiles(initWeightedDirectedStaticGraph(2).get_minimum_vertex_cover())
    doAssert not compiles(initUnWeightedDirectedGraph(2).maximum_independent_set())
    doAssert not compiles(initWeightedDirectedGraph(2).get_maximum_independent_set())
    doAssert not compiles(initUnWeightedDirectedStaticGraph(2).minimum_edge_cover())
    doAssert not compiles(initWeightedDirectedStaticGraph(2).get_minimum_edge_cover())

block:
    const n = 100000
    var edges: seq[Edge]
    for v in 1..<n: edges.add((v - 1, v))
    checkGraphs(n, edges, (n div 2, n div 2, n div 2))

block:
    const n = 100000
    var g = initHopcroftKarp(n + 1, n)
    for v in 0..<n:
        g.add_edge(v, v)
        g.add_edge(v + 1, v)
    let independent = g.get_maximum_independent_set()
    doAssert independent.left.len == n + 1 and independent.right.len == 0
    let cover = g.get_minimum_vertex_cover()
    doAssert cover.left.len == 0 and cover.right.len == n
    doAssert g.minimum_edge_cover() == n + 1
    doAssert g.get_minimum_edge_cover().len == n + 1

echo "Hello World"
