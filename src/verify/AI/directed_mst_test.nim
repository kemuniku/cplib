# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/directed_mst
import options, random, algorithm

proc valid(n, root: int, edges: seq[EdgeInfo[int64]], ids: seq[int]): bool =
    if ids.len != n or ids[root] != -1: return false
    var children = newSeq[seq[int]](n)
    for v in 0..<n:
        if v == root: continue
        let id = ids[v]
        if id < 0 or id >= edges.len or edges[id].dst != v: return false
        children[edges[id].src].add(v)
    var visited = newSeq[bool](n)
    visited[root] = true
    var stack = @[root]
    var count = 0
    while stack.len > 0:
        let v = stack.pop()
        inc count
        for u in children[v]:
            if visited[u]: return false
            visited[u] = true
            stack.add(u)
    count == n

proc brute(n, root: int, edges: seq[EdgeInfo[int64]]): Option[int64] =
    var incoming = newSeq[seq[int]](n)
    for id, e in edges:
        if e.dst != root and e.src != e.dst: incoming[e.dst].add(id)
    var ids = newSeq[int](n)
    ids[root] = -1
    var best = none(int64)
    proc enumerate(v: int, cost: int64) =
        if v == n:
            if valid(n, root, edges, ids) and (best.isNone or cost < best.get()):
                best = some(cost)
        elif v == root: enumerate(v + 1, cost)
        else:
            for id in incoming[v]:
                ids[v] = id
                enumerate(v + 1, cost + edges[id].cost)
    enumerate(0, 0)
    best

var checked = 0
proc check(n, root: int, edges: seq[EdgeInfo[int64]], allTypes = false) =
    let expected = brute(n, root, edges)
    var g = initWeightedDirectedGraph(n, int64)
    var s = initWeightedDirectedStaticGraph(n, int64)
    for e in edges:
        g.add_edge(e.src, e.dst, e.cost)
        s.add_edge(e.src, e.dst, e.cost)
    let before = g.edge_info
    for actual in [g.directedMST(root), s.directedMST(root)]:
        doAssert actual.isSome == expected.isSome
        if actual.isSome:
            let tree = actual.get()
            doAssert valid(n, root, edges, tree.inEdge)
            var sum = 0'i64
            for id in tree.inEdge:
                if id >= 0: sum += edges[id].cost
            doAssert sum == tree.cost and tree.cost == expected.get()
    s.build()
    doAssert s.directedMST(root) == g.directedMST(root)
    doAssert g.edge_info == before
    if allTypes:
        var small = initWeightedDirectedGraph(n, int32)
        var native = initWeightedDirectedStaticGraph(n, int)
        for e in edges:
            small.add_edge(e.src, e.dst, e.cost.int32)
            native.add_edge(e.src, e.dst, e.cost.int)
        doAssert small.directedMST(root) == g.directedMST(root)
        doAssert native.directedMST(root) == g.directedMST(root)
    inc checked

for n in 1..4:
    for mask in 0..<(1 shl (n * (n - 1))):
        var edges: seq[EdgeInfo[int64]]
        var bit = 0
        for u in 0..<n:
            for v in 0..<n:
                if u == v: continue
                if (mask and (1 shl bit)) != 0:
                    edges.add(EdgeInfo[int64](src: u, dst: v, cost: int64((bit * 7) mod 5 - 2)))
                inc bit
        for root in 0..<n: check(n, root, edges, mask mod 499 == 0)

var rng = initRand(928371)
for trial in 0..<1200:
    let n = rng.rand(1..6)
    var edges: seq[EdgeInfo[int64]]
    for id in 0..<rng.rand(0..16):
        edges.add(EdgeInfo[int64](src: rng.rand(n - 1), dst: rng.rand(n - 1), cost: rng.rand(-7..7).int64))
    let root = rng.rand(n - 1)
    check(n, root, edges, trial mod 23 == 0)
    edges.reverse()
    check(n, root, edges)
    if edges.len > 0: edges.add(edges[0])
    check(n, root, edges)

block:
    var g = initWeightedDirectedGraph(3, int64)
    g.add_edge(0, 1, low(int64))
    g.add_edge(1, 2, high(int64))
    g.add_edge(2, 1, high(int64))
    doAssert g.directedMST(0).get().cost == -1
block:
    var g = initWeightedDirectedGraph(3, int64)
    g.add_edge(0, 1, high(int64))
    g.add_edge(1, 2, low(int64))
    g.add_edge(2, 1, low(int64))
    let a = g.directedMST(0).get()
    doAssert a.cost == -1 and a.inEdge == @[-1, 0, 1]
for weight in [high(int64), low(int64)]:
    var g = initWeightedDirectedGraph(3, int64)
    g.add_edge(0, 1, weight)
    g.add_edge(0, 2, weight)
    var rejected = false
    try: discard g.directedMST(0)
    except OverflowDefect: rejected = true
    doAssert rejected
for n in [0, 1, 3]:
    for root in [-1, n]:
        var rejected = false
        try: discard initWeightedDirectedGraph(n, int64).directedMST(root)
        except ValueError: rejected = true
        doAssert rejected
for weight in [-3, 0, 127]:
    var g8 = initWeightedDirectedGraph(2, int8)
    var g16 = initWeightedDirectedStaticGraph(2, int16)
    g8.add_edge(0, 1, weight.int8)
    g16.add_edge(0, 1, weight.int16)
    doAssert g8.directedMST(0).get().cost == weight.int64
    doAssert g16.directedMST(0) == g8.directedMST(0)
block:
    var huge = WeightedDirectedGraph[int64](len: high(int32).int)
    var rejected = false
    try: discard huge.directedMST(0)
    except ValueError: rejected = true
    doAssert rejected
block:
    var g = initWeightedDirectedGraph(2, int64)
    g.edge_info.add(EdgeInfo[int64](src: 2, dst: 1, cost: 0))
    var rejected = false
    try: discard g.directedMST(0)
    except ValueError: rejected = true
    doAssert rejected

block:
    # 二頂点の閉路を、残る頂点と一つずつ入れ子に縮約する。
    const n = 200000
    var g = initWeightedDirectedStaticGraph(n, int64)
    g.add_edge(1, 2, 0)
    g.add_edge(2, 1, 0)
    for v in 3..<n:
        g.add_edge(1, v, 0)
        g.add_edge(v, 1, int64(v - 2))
    g.add_edge(0, 1, int64(n))
    let answer = g.directedMST(0).get()
    doAssert answer.cost == n.int64
    doAssert valid(n, 0, g.edge_info, answer.inEdge)
    doAssert answer.inEdge[1] == g.edge_info.len - 1
    for v in 2..<n: doAssert g.edge_info[answer.inEdge[v]].src == 1
    doAssert g.directedMST(n - 1).isNone

stderr.writeLine("directed MST regression: ", checked, " small graphs and boundary/nested cases passed")
echo "Hello World"
