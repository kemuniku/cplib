# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph, cplib/graph/steiner_tree, cplib/utils/constants
import random, sequtils, heapqueue

proc edgeOracle(n: int, edges: seq[(int, int, int)], terminals: seq[int], root: int): int =
    result = INF64
    for mask in 0..<(1 shl edges.len):
        var parent = toSeq(0..<n)
        proc find(v: int): int =
            var u = v
            while parent[u] != u: u = parent[u]
            u
        var total = 0
        for i, e in edges:
            if (mask and (1 shl i)) != 0:
                parent[find(e[0])] = find(e[1])
                total += e[2]
        var connected = true
        for t in terminals:
            if find(t) != find(root): connected = false
        if connected: result = min(result, total)

var rng = initRand(1729)
for trial in 0..<90:
    let n = 1 + rng.rand(5)
    var edges: seq[(int, int, int)]
    var g = initWeightedUnDirectedGraph(n)
    var sg = initWeightedUnDirectedStaticGraph(n)
    var fg = initWeightedUnDirectedGraph(n, float)
    var f32g = initWeightedUnDirectedStaticGraph(n, float32)
    var i32g = initWeightedUnDirectedGraph(n, int32)
    for i in 0..<rng.rand(9):
        let u = rng.rand(n-1)
        let v = rng.rand(n-1)
        let w = rng.rand(6)
        edges.add((u, v, w))
        g.add_edge(u, v, w)
        sg.add_edge(u, v, w)
        fg.add_edge(u, v, float(w) / 4)
        f32g.add_edge(u, v, float32(w) / 4)
        i32g.add_edge(u, v, int32(w))
    sg.build()
    f32g.build()
    var ts: seq[int]
    for i in 0..<rng.rand(4): ts.add(rng.rand(n-1))
    let dp = g.steiner_tree_dp(ts, INF64)
    doAssert sg.steiner_tree_dp(ts, INF64) == dp
    let fdp = fg.steiner_tree_dp(ts, 1e100)
    let f32dp = f32g.steiner_tree_dp(ts, 1e30'f32)
    let i32dp = i32g.steiner_tree_dp(ts, INF32)
    for mask in 0..<dp.len:
        var subset: seq[int]
        for i, t in ts:
            if (mask and (1 shl i)) != 0: subset.add(t)
        for root in 0..<n:
            let expected = edgeOracle(n, edges, subset, root)
            doAssert dp[mask][root] == expected
            if expected == INF64:
                doAssert fdp[mask][root] == 1e100
                doAssert f32dp[mask][root] == 1e30'f32
                doAssert i32dp[mask][root] == INF32
            else:
                doAssert fdp[mask][root] == float(expected) / 4
                doAssert f32dp[mask][root] == float32(expected) / 4
                doAssert i32dp[mask][root] == int32(expected)
    doAssert g.steiner_tree_mincost(ts) == (if ts.len == 0: 0 else: dp[^1][ts[0]])

var ug = initUnWeightedUnDirectedGraph(4)
ug.add_edge(0, 1)
ug.add_edge(1, 2)
doAssert ug.steiner_tree_mincost(@[0, 2, 2]) == 2
doAssert ug.steiner_tree_mincost(@[0, 3]) == INF64
var empty = initWeightedUnDirectedGraph(0)
doAssert empty.steiner_tree_dp(@[], INF64) == @[newSeq[int]()]
doAssert empty.steiner_tree_mincost(@[]) == 0

type OrderedCost = object
    value, trace: int
proc `<`(a, b: OrderedCost): bool = (a.value, a.trace) < (b.value, b.trace)
proc `<=`(a, b: OrderedCost): bool = not (b < a)
proc `+`(a, b: OrderedCost): OrderedCost =
    OrderedCost(value: a.value + b.value, trace: (31 * a.trace + b.trace) mod 100003)
proc `>`(a, b: OrderedCost): bool = b < a

proc orderedOracle(g: WeightedDirectedGraph[OrderedCost], ts: seq[int], zero, inf: OrderedCost): seq[seq[OrderedCost]] =
    result = newSeqWith(1 shl ts.len, newSeqWith(g.len, inf))
    for u in 0..<g.len: result[0][u] = zero
    for i, t in ts: result[1 shl i][t] = zero
    for mask in 1..<result.len:
        for u in 0..<g.len:
            for subset in 0..<mask:
                if (subset and mask) == subset:
                    result[mask][u] = min(result[mask][u], result[subset][u] + result[mask xor subset][u])
        var queue = initHeapQueue[(OrderedCost, int)]()
        for u in 0..<g.len: queue.push((result[mask][u], u))
        while queue.len > 0:
            let (d, u) = queue.pop()
            if result[mask][u] != d: continue
            for (v, w) in g.to_and_cost(u):
                if result[mask][v] > d + w:
                    result[mask][v] = d + w
                    queue.push((result[mask][v], v))
var custom = initWeightedDirectedGraph(5, OrderedCost)
custom.add_edge(0, 2, OrderedCost(value: 2, trace: 7))
custom.add_edge(1, 2, OrderedCost(value: 3, trace: 2))
custom.add_edge(2, 3, OrderedCost(value: 1, trace: 5))
custom.add_edge(3, 4, OrderedCost(value: 4, trace: 9))
let zero = OrderedCost(value: 0, trace: 0)
let inf = OrderedCost(value: 1000000, trace: 0)
doAssert custom.steiner_tree_dp(@[0, 1, 3], zero, inf) == orderedOracle(custom, @[0, 1, 3], zero, inf)
echo "Hello World"
