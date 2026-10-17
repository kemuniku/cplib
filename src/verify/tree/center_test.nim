# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/graph/graph
import cplib/tree/center
import cplib/tree/diameter

static:
    doAssert not compiles(initWeightedUnDirectedGraph(1).tree_center())
    doAssert not compiles(initWeightedUnDirectedStaticGraph(1).tree_center())
    doAssert not compiles(initUnWeightedDirectedGraph(1).tree_center())
    doAssert not compiles(initUnWeightedDirectedStaticGraph(1).tree_center())

type Edge = tuple[u, v: int]

proc oracle(n: int, edges: seq[Edge]): tuple[centers: seq[int], radius: int] =
    if n == 0: return (@[], 0)
    var adjacent = newSeq[seq[int]](n)
    for (u, v) in edges:
        adjacent[u].add(v)
        adjacent[v].add(u)
    result.radius = n
    for source in 0..<n:
        var dist = newSeqWith(n, -1)
        var queue = @[source]
        dist[source] = 0
        var front = 0
        var eccentricity = 0
        while front < queue.len:
            let u = queue[front]
            inc front
            for v in adjacent[u]:
                if dist[v] != -1: continue
                dist[v] = dist[u] + 1
                eccentricity = max(eccentricity, dist[v])
                queue.add(v)
        doAssert queue.len == n
        if eccentricity < result.radius:
            result = (@[source], eccentricity)
        elif eccentricity == result.radius:
            result.centers.add(source)

proc check(n: int, edges: seq[Edge]) =
    var dynamicGraph = initUnWeightedUnDirectedGraph(n)
    var staticGraph = initUnWeightedUnDirectedStaticGraph(n)
    for (u, v) in edges:
        dynamicGraph.add_edge(u, v)
        staticGraph.add_edge(u, v)
    staticGraph.build()
    let expected = oracle(n, edges)
    doAssert dynamicGraph.tree_center() == expected
    doAssert staticGraph.tree_center() == expected
    doAssert dynamicGraph.tree_center() == expected
    doAssert dynamicGraph.edge_count() == edges.len
    doAssert staticGraph.edge_count() == edges.len

check(0, @[])
check(1, @[])
check(2, @[(1, 0)])
check(5, @[(0, 1), (1, 2), (2, 3), (3, 4)])
check(6, @[(0, 1), (1, 2), (2, 3), (3, 4), (4, 5)])
check(8, @[(0, 1), (1, 2), (2, 3), (3, 4), (2, 5), (5, 6), (5, 7)])
for n in 2..6:
    var count = 1
    for i in 0..<n - 2: count *= n
    for code in 0..<count:
        var value = code
        var prufer = newSeq[int](n - 2)
        var degrees = newSeqWith(n, 1)
        for i in 0..<prufer.len:
            prufer[i] = value mod n
            value = value div n
            inc degrees[prufer[i]]
        var edges: seq[Edge]
        for parent in prufer:
            var leaf = 0
            while degrees[leaf] != 1: inc leaf
            edges.add((leaf, parent))
            dec degrees[leaf]
            dec degrees[parent]
        var leaves: seq[int]
        for u in 0..<n:
            if degrees[u] == 1: leaves.add(u)
        edges.add((leaves[0], leaves[1]))
        check(n, edges)

var rng = initRand(289)
for trial in 0..<300:
    let n = rng.rand(1..60)
    var labels = toSeq(0..<n)
    rng.shuffle(labels)
    var edges: seq[Edge]
    for u in 1..<n:
        var edge = (labels[u], labels[rng.rand(u - 1)])
        if rng.rand(1) == 0: swap(edge[0], edge[1])
        edges.add(edge)
    rng.shuffle(edges)
    check(n, edges)

for shape in 0..2:
    var edges: seq[Edge]
    for u in 1..<60:
        let parent = if shape == 0: 0 elif shape == 1: (u - 1) div 2 else: max(0, u - 10)
        edges.add((u, parent))
    check(60, edges)

for n in [200000, 200001]:
    block:
        var dynamicGraph = initUnWeightedUnDirectedGraph(n, n - 1)
        var staticGraph = initUnWeightedUnDirectedStaticGraph(n, n - 1)
        for u in 1..<n:
            dynamicGraph.add_edge(u - 1, u)
            staticGraph.add_edge(u - 1, u)
        staticGraph.build()
        let centers = if n mod 2 == 0: @[n div 2 - 1, n div 2] else: @[n div 2]
        doAssert dynamicGraph.tree_center() == (centers, n div 2)
        doAssert staticGraph.tree_center() == (centers, n div 2)
    block:
        var dynamicGraph = initUnWeightedUnDirectedGraph(n, n - 1)
        var staticGraph = initUnWeightedUnDirectedStaticGraph(n, n - 1)
        for u in 1..<n:
            dynamicGraph.add_edge(n - 1, u - 1)
            staticGraph.add_edge(n - 1, u - 1)
        staticGraph.build()
        doAssert dynamicGraph.tree_center() == (@[n - 1], 1)
        doAssert staticGraph.tree_center() == (@[n - 1], 1)

for n in [0, 1]:
    let unbuilt = initUnWeightedUnDirectedStaticGraph(n)
    var rejected = false
    try:
        discard unbuilt.tree_center()
    except AssertionDefect:
        rejected = true
    doAssert rejected

echo "Hello World"
