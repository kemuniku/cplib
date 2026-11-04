# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/graph
import cplib/tree/to_degree3_tree

type InputEdge = tuple[u, v, w: int]

proc check(g: UnDirectedGraph, edges: seq[InputEdge], quarter: static bool = false) =
    when g is WeightedGraph:
        type Cost = g.T
    else:
        type Cost = int
    template weight(e: InputEdge): Cost =
        when g is UnWeightedGraph: 1
        elif quarter: Cost(e.w) / Cost(4)
        else: Cost(e.w)
    let n = g.len
    when g is StaticGraphTypes:
        let savedStart = g.start.mapIt(it.int)
    let r = g.to_degree3_tree()
    doAssert r.tree is WeightedUnDirectedGraph[Cost]
    doAssert r.representative == toSeq(0..<n)
    doAssert r.original_vertex.len == r.tree.len
    doAssert r.original_edge.len == r.tree.edge_count
    var original = newSeq[seq[tuple[v: int, w: Cost]]](n)
    for e in edges:
        original[e.u].add((e.v, weight(e)))
        original[e.v].add((e.u, weight(e)))
    var extra = 0
    for row in original: extra += max(0, row.len - 3)
    doAssert r.tree.len == n + extra
    doAssert r.tree.edge_count == max(0, r.tree.len - 1)
    var count = newSeq[int](n)
    for x, u in r.original_vertex:
        doAssert u in 0..<n
        inc count[u]
        if x < n: doAssert x == u
        doAssert toSeq(r.tree.to_and_id(x)).len <= 3
    for u in 0..<n: doAssert count[u] == 1 + max(0, original[u].len - 3)
    for id in 0..<r.tree.edge_count:
        let e = r.tree.get_edge(id)
        if id < edges.len:
            doAssert r.original_edge[id] == id
            doAssert r.original_vertex[e.src] == edges[id].u
            doAssert r.original_vertex[e.dst] == edges[id].v
            doAssert e.cost == weight(edges[id])
        else:
            doAssert r.original_edge[id] == -1
            doAssert e.cost == Cost(0)
            doAssert r.original_vertex[e.src] == r.original_vertex[e.dst]
    if n == 0: return
    var seen = newSeq[bool](r.tree.len)
    var stack = @[(0, -1)]
    var visited = 0
    while stack.len > 0:
        let (u, parent) = stack.pop()
        doAssert not seen[u]
        seen[u] = true
        inc visited
        for (v, id) in r.tree.to_and_id(u):
            if id != parent: stack.add((v, id))
    doAssert visited == r.tree.len
    for s in 0..<n:
        var expected = newSeq[Cost](n)
        var todo = @[(s, -1)]
        while todo.len > 0:
            let (u, p) = todo.pop()
            for (v, w) in original[u]:
                if v != p:
                    expected[v] = expected[u] + w
                    todo.add((v, u))
        var actual = newSeq[Cost](r.tree.len)
        todo = @[(r.representative[s], -1)]
        while todo.len > 0:
            let (u, p) = todo.pop()
            for (v, w) in r.tree.to_and_cost(u):
                if v != p:
                    actual[v] = actual[u] + w
                    todo.add((v, u))
        for t in 0..<n: doAssert actual[r.representative[t]] == expected[t]
        var depthBound = 0
        var capacity = 1
        let groupSize = (original[s].len + 2) div 3
        while capacity < groupSize:
            capacity *= 2
            inc depthBound
        var reached = 0
        var zeroTodo = @[(s, -1, 0)]
        while zeroTodo.len > 0:
            let (u, p, depth) = zeroTodo.pop()
            inc reached
            doAssert r.original_vertex[u] == s
            doAssert depth <= depthBound
            for (v, id) in r.tree.to_and_id(u):
                if v != p and r.original_edge[id] == -1:
                    zeroTodo.add((v, u, depth + 1))
        doAssert reached == count[s]
    doAssert g.edge_count == edges.len
    for id, e in edges:
        let before = g.get_edge(id)
        doAssert before.src == e.u and before.dst == e.v
        when g is WeightedGraph: doAssert before.cost == weight(e)
    when g is StaticGraphTypes:
        doAssert g.start.mapIt(it.int) == savedStart
    else:
        for u in 0..<n: doAssert toSeq(g.to_and_cost(u)) == original[u]
    let again = g.to_degree3_tree()
    doAssert again.representative == r.representative
    doAssert again.original_vertex == r.original_vertex
    doAssert again.original_edge == r.original_edge
    for id in 0..<r.tree.edge_count:
        doAssert again.tree.get_edge(id) == r.tree.get_edge(id)

proc checkVariants(n: int, edges: seq[InputEdge]) =
    var wd = initWeightedUnDirectedGraph(n, int64)
    var ws = initWeightedUnDirectedStaticGraph(n, int32)
    var fd = initWeightedUnDirectedGraph(n, float64)
    var fs = initWeightedUnDirectedStaticGraph(n, float32)
    var ud = initUnWeightedUnDirectedGraph(n)
    var us = initUnWeightedUnDirectedStaticGraph(n)
    for e in edges:
        wd.add_edge(e.u, e.v, e.w.int64)
        ws.add_edge(e.u, e.v, e.w.int32)
        fd.add_edge(e.u, e.v, e.w.float64 / 4)
        fs.add_edge(e.u, e.v, e.w.float32 / 4)
        ud.add_edge(e.u, e.v)
        us.add_edge(e.u, e.v)
    check(wd, edges)
    check(ws, edges)
    check(fd, edges, true)
    check(fs, edges, true)
    check(ud, edges)
    check(us, edges)
    doAssert ws.start.len == 0 and fs.start.len == 0 and us.start.len == 0
    ws.build()
    fs.build()
    us.build()
    let starts = (ws.start.len, fs.start.len, us.start.len)
    check(ws, edges)
    check(fs, edges, true)
    check(us, edges)
    doAssert starts == (ws.start.len, fs.start.len, us.start.len)

checkVariants(0, @[])
checkVariants(1, @[])
checkVariants(2, @[(1, 0, -7)])
for n in [3, 4, 5, 6, 7, 8, 9, 10, 13, 25, 49, 50]:
    for shape in 0..2:
        var edges: seq[InputEdge]
        for x in 1..<n:
            let p = if shape == 0: n - 1 elif shape == 1: x - 1 else: (x - 1) div 2
            let v = if shape == 0: x - 1 else: x
            edges.add((p, v, x mod 5 - 2))
        checkVariants(n, edges)

for n in 2..6:
    var combinations = 1
    for i in 0..<n - 2: combinations *= n
    for code in 0..<combinations:
        var a = newSeq[int](n - 2)
        var d = newSeqWith(n, 1)
        var c = code
        for i in 0..<a.len:
            a[i] = c mod n
            c = c div n
            inc d[a[i]]
        var edges: seq[InputEdge]
        for v in a:
            var u = 0
            while d[u] != 1: inc u
            edges.add((u, v, edges.len mod 7 - 3))
            dec d[u]
            dec d[v]
        var leaves: seq[int]
        for u in 0..<n:
            if d[u] == 1: leaves.add(u)
        edges.add((leaves[1], leaves[0], 0))
        checkVariants(n, edges)

var rng = initRand(536)
for trial in 0..<100:
    let n = rng.rand(2..40)
    var labels = toSeq(0..<n)
    rng.shuffle(labels)
    var edges: seq[InputEdge]
    for x in 1..<n:
        var u = labels[x]
        var v = labels[rng.rand(x - 1)]
        if rng.rand(1) == 0: swap(u, v)
        edges.add((u, v, rng.rand(-100..100)))
    rng.shuffle(edges)
    checkVariants(n, edges)

template rejected(input: untyped) =
    block:
        var failed = false
        try: discard input.to_degree3_tree()
        except ValueError: failed = true
        doAssert failed

block:
    var nilGraph: UnWeightedUnDirectedGraph
    rejected(nilGraph)
    var disconnected = initUnWeightedUnDirectedGraph(4)
    disconnected.add_edge(0, 1)
    disconnected.add_edge(1, 2)
    rejected(disconnected)
    disconnected.add_edge(2, 0)
    rejected(disconnected)
    var loop = initUnWeightedUnDirectedGraph(2)
    loop.add_edge(0, 0)
    rejected(loop)
    var parallel = initUnWeightedUnDirectedStaticGraph(3)
    parallel.add_edge(0, 1)
    parallel.add_edge(1, 0)
    rejected(parallel)
    var outOfRange = initUnWeightedUnDirectedStaticGraph(2)
    outOfRange.edge_info.add(EdgeInfo[void](src: 0, dst: 2))
    rejected(outOfRange)
    outOfRange.edge_info[0].dst = -1
    rejected(outOfRange)
    var many = initWeightedUnDirectedGraph(2)
    many.add_edge(0, 1, 1)
    many.add_edge(0, 1, 2)
    rejected(many)

static:
    doAssert not compiles(initUnWeightedDirectedGraph(1).to_degree3_tree())
    doAssert not compiles(initWeightedDirectedGraph(1).to_degree3_tree())
    doAssert not compiles(initUnWeightedDirectedStaticGraph(1).to_degree3_tree())
    doAssert not compiles(initWeightedDirectedStaticGraph(1).to_degree3_tree())

block:
    for w in [low(int64), high(int64)]:
        var g = initWeightedUnDirectedStaticGraph(2, int64)
        g.add_edge(1, 0, w)
        let r = g.to_degree3_tree()
        doAssert r.tree.get_edge(0) == (1, 0, w)
        doAssert r.original_edge == @[0]
        r.tree.edge_info[0].cost = 0
        doAssert g.get_edge(0).cost == w
        doAssert g.to_degree3_tree().tree.get_edge(0).cost == w

block:
    const n = 200000
    for shape in 0..1:
        var g = initWeightedUnDirectedStaticGraph(n, int64)
        for x in 1..<n:
            g.add_edge((if shape == 0: 0 else: x - 1), x, x.int64)
        let r = g.to_degree3_tree()
        let extra = if shape == 0: n - 4 else: 0
        doAssert r.tree.len == n + extra
        doAssert r.tree.edge_count == n + extra - 1
        var depth = newSeq[int](r.tree.len)
        var distance = newSeq[int64](r.tree.len)
        var todo = @[(0, -1)]
        var visited = 0
        while todo.len > 0:
            let (u, parent) = todo.pop()
            inc visited
            doAssert toSeq(r.tree.to_and_id(u)).len <= 3
            for (v, w) in r.tree.to_and_cost(u):
                if v != parent:
                    depth[v] = depth[u] + 1
                    distance[v] = distance[u] + w
                    todo.add((v, u))
        doAssert visited == r.tree.len
        for u in 0..<n:
            doAssert r.representative[u] == u
            let expected = if shape == 0: u.int64 else: u.int64 * (u.int64 + 1) div 2
            doAssert distance[u] == expected
            if shape == 0: doAssert depth[u] <= 18
        for x in n..<r.tree.len:
            doAssert r.original_vertex[x] == 0
            doAssert distance[x] == 0
            doAssert depth[x] <= 17

echo "Hello World"
