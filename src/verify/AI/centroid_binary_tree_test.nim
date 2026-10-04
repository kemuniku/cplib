# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/tree/centroid_binary_tree
import cplib/graph/graph
import random, algorithm

type Edge = tuple[u, v: int]

proc distances(n: int, edges: seq[Edge]): seq[seq[int]] =
    var adjacency = newSeq[seq[int]](n)
    for (u, v) in edges:
        adjacency[u].add(v)
        adjacency[v].add(u)
    result = newSeq[seq[int]](n)
    for start in 0..<n:
        result[start] = newSeq[int](n)
        for v in 0..<n: result[start][v] = -1
        var queue = @[start]
        result[start][start] = 0
        var i = 0
        while i < queue.len:
            let v = queue[i]
            inc i
            for u in adjacency[v]:
                if result[start][u] == -1:
                    result[start][u] = result[start][v] + 1
                    queue.add(u)

proc checkRange(t: CentroidBinaryTree, d: seq[seq[int]], v, l, r: int) =
    var count = newSeq[int](t.len)
    let ranges = t.distance_ranges(v, l, r)
    doAssert ranges.len <= t.point_path(v).len
    for interval in ranges:
        doAssert interval.first >= 0
        doAssert interval.first < interval.past
        doAssert interval.past <= t.node_info(interval.node).size
        for i in interval.first..<interval.past:
            inc count[t.entry_at(interval.node, i).vertex]
    for u in 0..<t.len:
        doAssert count[u] == int(l <= d[v][u] and d[v][u] < r)

proc check(t: CentroidBinaryTree, d: seq[seq[int]], exhaustive: bool) =
    let n = t.len
    doAssert t.node_count == max(0, 2 * n - 1)
    if n == 0:
        doAssert t.root == -1
        return
    doAssert t.root == t.node_count - 1
    doAssert t.node_info(t.root).parent == -1
    var occurrences = newSeq[int](n)
    for node in 0..<t.node_count:
        let info = t.node_info(node)
        let a = t.distance_order(node)
        doAssert a.len == info.size
        if node < n:
            doAssert info.left == -1 and info.right == -1
            doAssert a.len == 1 and a[0].vertex == node
        else:
            doAssert info.left < node and info.right < node
            doAssert t.node_info(info.left).parent == node
            doAssert t.node_info(info.right).parent == node
            var expected: seq[int]
            for child in [info.left, info.right]:
                for entry in t.distance_order(child): expected.add(entry.vertex)
            var actual: seq[int]
            for entry in a: actual.add(entry.vertex)
            expected.sort()
            actual.sort()
            doAssert actual == expected
            for i in 1..<actual.len: doAssert actual[i - 1] != actual[i]
        let center = if info.parent == -1: info.center else: t.node_info(info.parent).center
        for i, entry in a:
            doAssert entry == t.entry_at(node, i)
            doAssert entry.distance == d[center][entry.vertex]
            if i > 0: doAssert a[i - 1].distance <= entry.distance
            inc occurrences[entry.vertex]
    for v in 0..<n:
        let path = t.point_path(v)
        doAssert path.len == occurrences[v]
        doAssert path[0] == (v, 0)
        doAssert path[^1].node == t.root
        for i, point in path:
            doAssert t.entry_at(point.node, point.index).vertex == v
            if i > 0: doAssert t.node_info(path[i - 1].node).parent == point.node
        for (l, r) in [(low(int), high(int)), (low(int), 0), (0, 1),
                (n, high(int)), (high(int), low(int)), (1, high(int)), (2, 2)]:
            checkRange(t, d, v, l, r)
        if exhaustive:
            for l in -1..n:
                for r in -1..n + 1: checkRange(t, d, v, l, r)

proc build(n: int, edges: seq[Edge], useStatic = false): CentroidBinaryTree =
    if useStatic:
        var g = initUnWeightedUnDirectedStaticGraph(n)
        for (u, v) in edges: g.add_edge(u, v)
        g.build()
        let before = g.elist
        result = initCentroidBinaryTree(g)
        doAssert g.elist == before
        if n > 1: g.add_edge(0, n - 1)
    else:
        var g = initUnWeightedUnDirectedGraph(n)
        for (u, v) in edges: g.add_edge(u, v)
        let before = g.edges
        result = initCentroidBinaryTree(g)
        doAssert g.edges == before
        if n > 1:
            g.edges[0].setLen(0)
            g.add_edge(0, n - 1)

check(build(0, @[]), @[], true)
check(build(0, @[], true), @[], true)
check(build(1, @[]), distances(1, @[]), true)

for n in 2..6:
    var total = 1
    for i in 0..<n - 2: total *= n
    for code in 0..<total:
        var sequence = newSeq[int](n - 2)
        var degree = newSeq[int](n)
        for v in 0..<n: degree[v] = 1
        var number = code
        for i in 0..<sequence.len:
            sequence[i] = number mod n
            number = number div n
            inc degree[sequence[i]]
        var edges: seq[Edge]
        for v in sequence:
            var u = 0
            while degree[u] != 1: inc u
            edges.add((u, v))
            dec degree[u]
            dec degree[v]
        var last: seq[int]
        for v in 0..<n:
            if degree[v] == 1: last.add(v)
        edges.add((last[0], last[1]))
        let d = distances(n, edges)
        check(build(n, edges), d, true)
        edges.reverse()
        for edge in edges.mitems: swap(edge.u, edge.v)
        check(build(n, edges, true), d, true)

var rng = initRand(378)
for trial in 0..<140:
    let n = rng.rand(1..65)
    var labels = newSeq[int](n)
    for i in 0..<n: labels[i] = i
    rng.shuffle(labels)
    var edges: seq[Edge]
    for v in 1..<n: edges.add((labels[v], labels[rng.rand(v - 1)]))
    let d = distances(n, edges)
    let t = build(n, edges, trial mod 2 == 0)
    check(t, d, false)
    var values = newSeq[int](n)
    var arrays = newSeq[seq[int]](t.node_count)
    var rangeUpdates = newSeq[seq[int]](t.node_count)
    for node in 0..<t.node_count:
        arrays[node] = newSeq[int](t.node_info(node).size)
        rangeUpdates[node] = newSeq[int](arrays[node].len)
    var expectedUpdates = newSeq[int](n)
    for operation in 0..<130:
        let v = rng.rand(n - 1)
        let delta = rng.rand(-100..100)
        values[v] += delta
        for point in t.point_path(v): arrays[point.node][point.index] += delta
        let l = rng.rand(-2..n)
        let r = rng.rand(-2..n + 1)
        checkRange(t, d, v, l, r)
        var actual, expected = 0
        for interval in t.distance_ranges(v, l, r):
            for i in interval.first..<interval.past:
                actual += arrays[interval.node][i]
                rangeUpdates[interval.node][i] += delta
        for u in 0..<n:
            if l <= d[v][u] and d[v][u] < r:
                expected += values[u]
                expectedUpdates[u] += delta
        doAssert actual == expected
        for u in 0..<n:
            var pointValue = 0
            for point in t.point_path(u): pointValue += rangeUpdates[point.node][point.index]
            doAssert pointValue == expectedUpdates[u]
    var returned = t.distance_order(t.root)
    let original = returned[0]
    returned[0] = (vertex: -1, distance: -1)
    returned.setLen(0)
    doAssert t.entry_at(t.root, 0) == original
    var path = t.point_path(0)
    path[0] = (-1, -1)
    doAssert t.point_path(0)[0] == (0, 0)
    var info = t.node_info(t.root)
    info.size = -1
    doAssert t.node_info(t.root).size == n

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

block:
    var missing: CentroidBinaryTree
    rejects:
        discard missing.len
    let defaultConstructed = CentroidBinaryTree()
    rejects:
        discard defaultConstructed.root
    var missingGraph: UnWeightedUnDirectedGraph
    rejects:
        discard initCentroidBinaryTree(missingGraph)
    let empty = build(0, @[])
    rejects:
        discard empty.point_path(0)
    rejects:
        discard empty.distance_ranges(0, 0, 0)
    let one = build(1, @[])
    rejects:
        discard one.point_path(-1)
    rejects:
        discard one.point_path(1)
    rejects:
        discard one.distance_order(-1)
    rejects:
        discard one.node_info(1)
    rejects:
        discard one.entry_at(0, -1)
    rejects:
        discard one.entry_at(0, 1)
    rejects:
        discard one.distance_ranges(high(int), low(int), high(int))
    var unbuilt = initUnWeightedUnDirectedStaticGraph(2)
    unbuilt.add_edge(0, 1)
    rejects:
        discard initCentroidBinaryTree(unbuilt)
    for (n, edges) in [(1, @[(0, 0)]), (3, @[(0, 1), (0, 1)]),
            (4, @[(0, 1), (1, 2), (2, 0)]), (3, @[(0, 1)]),
            (2, @[(0, 0)])]:
        var g = initUnWeightedUnDirectedGraph(n)
        var s = initUnWeightedUnDirectedStaticGraph(n)
        for (u, v) in edges:
            g.add_edge(u, v)
            s.add_edge(u, v)
        s.build()
        rejects:
            discard initCentroidBinaryTree(g)
        rejects:
            discard initCentroidBinaryTree(s)

proc checkLarge(n, shape: int) =
    var g = initUnWeightedUnDirectedGraph(n)
    var adjacency = newSeq[seq[int]](n)
    for v in 1..<n:
        let p = case shape
            of 0: v - 1
            of 1: 0
            of 2: (v - 1) div 2
            else: (if v < n div 2: v - 1 else: n div 2 - 1)
        g.add_edge(p, v)
        adjacency[p].add(v)
        adjacency[v].add(p)
    let t = initCentroidBinaryTree(g)
    var bound = 1
    var power = 1
    while power < n:
        power *= 2
        bound += 2
    var total = 0
    for v in 0..<n:
        let path = t.point_path(v)
        doAssert path.len <= bound
        total += path.len
        doAssert path[0] == (v, 0) and path[^1].node == t.root
        for i in 1..<path.len: doAssert t.node_info(path[i - 1].node).parent == path[i].node
    doAssert total <= n * bound
    for v in [0, n div 3, n div 2, n - 1]:
        var d = newSeq[int](n)
        for u in 0..<n: d[u] = -1
        d[v] = 0
        var queue = @[v]
        var cursor = 0
        while cursor < queue.len:
            let u = queue[cursor]
            inc cursor
            for w in adjacency[u]:
                if d[w] == -1:
                    d[w] = d[u] + 1
                    queue.add(w)
        for (l, r) in [(1, 3), (n div 3, n div 2), (0, n div 2)]:
            var actual = newSeq[int](n)
            for interval in t.distance_ranges(v, l, r):
                for i in interval.first..<interval.past:
                    inc actual[t.entry_at(interval.node, i).vertex]
            for u in 0..<n: doAssert actual[u] == int(l <= d[u] and d[u] < r)
        let all = t.distance_ranges(v, low(int), high(int))
        var count = 0
        for interval in all: count += interval.past - interval.first
        doAssert count == n
        let self = t.distance_ranges(v, 0, 1)
        doAssert self == @[(node: v, first: 0, past: 1)]
        let far = t.distance_ranges(v, n - 1, n)
        var farCount = 0
        for interval in far:
            for i in interval.first..<interval.past:
                let u = t.entry_at(interval.node, i).vertex
                if shape == 0: doAssert abs(u - v) == n - 1
                inc farCount
        if shape == 0: doAssert farCount == int(v == 0 or v == n - 1)
        else: doAssert farCount == 0

for n in [31, 32, 33, 127, 128, 129, 100000]:
    for shape in 0..3: checkLarge(n, shape)

echo "Hello World"
