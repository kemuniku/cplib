# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/utils/mo
import cplib/graph/graph

proc edgeValue(u, v: int): int = (min(u, v) + 1) * 101 + max(u, v)

proc naivePath(adj: seq[seq[int]], u, v: int): seq[int] =
    var parent = newSeqWith(adj.len, -1)
    var queue = @[u]
    parent[u] = u
    var head = 0
    while head < queue.len:
        let x = queue[head]
        inc head
        for y in adj[x]:
            if parent[y] == -1:
                parent[y] = x
                queue.add(y)
    var x = v
    while x != u:
        result.add(x)
        x = parent[x]
    result.add(u)

proc checkTree(adj: seq[seq[int]], queries: seq[(int, int)], root, width, kind: int) =
    let n = adj.len
    var mo: TreeMo
    case kind
    of 0:
        mo = initTreeMo(adj, queries.len, root, width)
    of 1:
        var g = initUnWeightedUnDirectedGraph(n)
        for u in 0..<n:
            for v in adj[u]:
                if u < v: g.add_edge(u, v)
        mo = initTreeMo(g, queries.len, root, width)
    of 2:
        var g = initUnWeightedUnDirectedStaticGraph(n)
        for u in 0..<n:
            for v in adj[u]:
                if u < v: g.add_edge(u, v)
        g.build()
        mo = initTreeMo(g, queries.len, root, width)
    of 3:
        var g = initWeightedUnDirectedGraph(n)
        for u in 0..<n:
            for v in adj[u]:
                if u < v: g.add_edge(u, v, edgeValue(u, v))
        mo = initTreeMo(g, queries.len, root, width)
    else:
        var g = initWeightedUnDirectedStaticGraph(n)
        for u in 0..<n:
            for v in adj[u]:
                if u < v: g.add_edge(u, v, edgeValue(u, v))
        g.build()
        mo = initTreeMo(g, queries.len, root, width)
    for i, (u, v) in queries:
        doAssert mo.insert(u, v) == i
    var active = newSeq[bool](n)
    var degree = newSeq[int](n)
    var edges = newSeqWith(n, newSeq[bool](n))
    active[root] = true
    var vertexSum = root + 1
    var edgeSum, updates: int
    var answers = newSeq[(int, int)](queries.len)
    var seen = newSeq[int](queries.len)
    proc checkPath() =
        var vertices, edgeEnds: int
        for v in 0..<n:
            if active[v]: inc vertices
            else: doAssert degree[v] == 0
            doAssert degree[v] in 0..2
            edgeEnds += degree[v]
        doAssert vertices > 0 and edgeEnds == 2 * (vertices - 1)
    proc addVertex(u, v: int) =
        doAssert v in adj[u]
        doAssert active[u] and not active[v] and degree[u] <= 1
        doAssert not edges[u][v] and not edges[v][u]
        edges[u][v] = true
        edges[v][u] = true
        active[v] = true
        inc degree[u]
        inc degree[v]
        vertexSum += v + 1
        edgeSum += edgeValue(u, v)
        inc updates
        checkPath()
    proc deleteVertex(u, v: int) =
        doAssert v in adj[u]
        doAssert active[u] and active[v] and degree[v] == 1
        doAssert edges[u][v] and edges[v][u]
        edges[u][v] = false
        edges[v][u] = false
        active[v] = false
        dec degree[u]
        dec degree[v]
        vertexSum -= v + 1
        edgeSum -= edgeValue(u, v)
        inc updates
        checkPath()
    proc remember(idx: int) =
        let path = naivePath(adj, queries[idx][0], queries[idx][1])
        var expected = newSeq[bool](n)
        var vs, es: int
        for i, v in path:
            expected[v] = true
            vs += v + 1
            if i > 0:
                doAssert edges[path[i - 1]][v]
                es += edgeValue(path[i - 1], v)
        doAssert active == expected
        doAssert (vertexSum, edgeSum) == (vs, es)
        answers[idx] = (vertexSum, edgeSum)
        inc seen[idx]
    for repeat in 0..<2:
        updates = 0
        mo.run(addVertex, deleteVertex, remember = remember)
        doAssert vertexSum == root + 1 and edgeSum == 0
        for v in 0..<n: doAssert active[v] == (v == root) and degree[v] == 0
        for count in seen: doAssert count == repeat + 1
        let length = 2 * n - 1
        doAssert updates <= 4 * length * (length div mo.width + 2) + queries.len * mo.width
        if queries.len == 0: doAssert updates == 0

var rng = initRand(742819)
for n in 1..12:
    for shape in 0..2:
        var adj = newSeq[seq[int]](n)
        for v in 1..<n:
            let p = if shape == 0: v - 1 elif shape == 1: 0 else: rng.rand(v - 1)
            adj[p].add(v)
            adj[v].add(p)
        var queries: seq[(int, int)]
        for u in 0..<n:
            for v in 0..<n: queries.add((u, v))
        queries.add((0, n - 1))
        rng.shuffle(queries)
        for width in [0, 1, 3, n, 2 * n + 10]:
            checkTree(adj, queries, rng.rand(n - 1), width, rng.rand(4))
        checkTree(adj, @[], n - 1, 0, shape)

for trial in 0..<50:
    let n = rng.rand(30) + 1
    var adj = newSeq[seq[int]](n)
    for v in 1..<n:
        let p = rng.rand(v - 1)
        adj[p].add(v)
        adj[v].add(p)
    var queries: seq[(int, int)]
    for i in 0..<100: queries.add((rng.rand(n - 1), rng.rand(n - 1)))
    checkTree(adj, queries, rng.rand(n - 1), rng.rand(2 * n), trial mod 5)

proc checkCallbackFactories() =
    var mo = initTreeMo(@[@[1], @[0, 2], @[1]], 3, root = 1)
    mo.insert(0, 2)
    mo.insert(2, 2)
    var state = 2
    var factories, records: int
    proc makeAdd(): proc(u, v: int) {.closure.} =
        inc factories
        result = proc(u, v: int) = state += v + 1
    proc makeDelete(): proc(u, v: int) {.closure.} =
        inc factories
        result = proc(u, v: int) = state -= v + 1
    proc makeRemember(): proc(idx: int) {.closure.} =
        inc factories
        result = proc(idx: int) =
            doAssert state == [6, 3, 3][idx]
            inc records
    mo.run(makeAdd(), makeDelete(), makeRemember())
    doAssert factories == 3 and records == 2 and state == 2
    doAssert mo.insert(1, 0) == 2
    mo.run(makeAdd(), makeDelete(), makeRemember())
    doAssert factories == 6 and records == 5 and state == 2

checkCallbackFactories()

block:
    const n = 200000
    var g = initUnWeightedUnDirectedStaticGraph(n)
    for v in 1..<n: g.add_edge(v - 1, v)
    g.build()
    var mo = initTreeMo(g, 4)
    mo.insert(0, n - 1)
    mo.insert(n - 1, 0)
    mo.insert(n - 1, n - 1)
    mo.insert(n div 2, n - 1)
    var state = 1
    var answers: array[4, int]
    mo.run(
        proc(u, v: int) = state += v + 1,
        proc(u, v: int) = state -= v + 1,
        proc(idx: int) = answers[idx] = state
    )
    let total = n * (n + 1) div 2
    doAssert answers == [total, total, n, total - (n div 2) * (n div 2 + 1) div 2]
    doAssert state == 1

echo "Hello World"
