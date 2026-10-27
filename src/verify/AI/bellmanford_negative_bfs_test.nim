# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph, cplib/graph/bellmanford, cplib/utils/constants
import random, sequtils

var rng = initRand(518213)
for trial in 0..<260:
    let n = 1 + rng.rand(8)
    var g = initWeightedDirectedGraph(n)
    var sg = initWeightedDirectedStaticGraph(n)
    var fg = initWeightedDirectedGraph(n,float)
    var f32g = initWeightedDirectedStaticGraph(n,float32)
    var i32g = initWeightedDirectedStaticGraph(n,int32)
    var dist = newSeqWith(n,newSeqWith(n,INF64))
    for i in 0..<n: dist[i][i] = 0
    for _ in 0..<rng.rand(30):
        let u = rng.rand(n-1)
        let v = rng.rand(n-1)
        let cost = rng.rand(-6..9)
        g.add_edge(u,v,cost)
        sg.add_edge(u,v,cost)
        fg.add_edge(u,v,float(cost)/4)
        f32g.add_edge(u,v,float32(cost)/4)
        i32g.add_edge(u,v,int32(cost))
        dist[u][v] = min(dist[u][v],cost)
    sg.build()
    f32g.build()
    i32g.build()
    for k in 0..<n:
        for i in 0..<n:
            for j in 0..<n:
                if dist[i][k] != INF64 and dist[k][j] != INF64:
                    dist[i][j] = min(dist[i][j],dist[i][k]+dist[k][j])
    var starts: seq[int]
    for _ in 0..<rng.rand(4): starts.add(rng.rand(n-1))
    var expected = newSeqWith(n,INF64)
    var affected = newSeq[bool](n)
    for s in starts:
        for v in 0..<n:
            expected[v] = min(expected[v],dist[s][v])
            for k in 0..<n:
                if dist[s][k] != INF64 and dist[k][k] < 0 and dist[k][v] != INF64:
                    affected[v] = true
    for v in 0..<n:
        if affected[v]: expected[v] = -INF64
    let restored = g.restore_bellmanford(starts)
    doAssert restored.costs == expected
    doAssert g.bellmanford(starts) == expected
    doAssert sg.bellmanford(starts) == expected
    let floats = fg.restore_bellmanford(starts)
    let smalls = i32g.restore_bellmanford(starts)
    let f32s = f32g.restore_bellmanford(starts)
    for v in 0..<n:
        let floating = if expected[v] == INF64: 1e100 elif affected[v]: -1e100 else: float(expected[v])/4
        let small = if expected[v] == INF64: INF32 elif affected[v]: -INF32 else: int32(expected[v])
        let f32 = if expected[v] == INF64: 1e30'f32 elif affected[v]: -1e30'f32 else: float32(expected[v])/4
        doAssert floats.costs[v] == floating
        doAssert smalls.costs[v] == small
        doAssert f32s.costs[v] == f32
        if affected[v] or expected[v] == INF64:
            doAssert restored.prev[v] == -1
            doAssert floats.prev[v] == -1
            doAssert smalls.prev[v] == -1
            doAssert f32s.prev[v] == -1
    let source = rng.rand(n-1)
    doAssert g.bellmanford(source) == g.bellmanford(@[source])

block:
    var g = initWeightedDirectedGraph(8)
    g.add_edge(0,1,1)
    g.add_edge(1,1,-1)
    g.add_edge(1,2,2)
    g.add_edge(2,3,3)
    g.add_edge(0,4,-4)
    g.add_edge(5,6,-2)
    g.add_edge(6,5,1)
    g.add_edge(6,7,1)
    doAssert g.bellmanford(0) == @[0,-INF64,-INF64,-INF64,-4,INF64,INF64,INF64]
    doAssert g.shortest_path_bellmanford(0,4) == (@[0,4],-4)
    doAssert g.shortest_path_bellmanford(0,3) == (@[3],-INF64)
block:
    var g = initWeightedDirectedGraph(4)
    g.add_edge(0,0,-1)
    g.add_edge(0,1,99)
    g.add_edge(2,1,-90)
    doAssert g.bellmanford(@[0,2],0,100) == @[-100,-100,0,100]
block:
    var g = initWeightedDirectedStaticGraph(130)
    g.add_edge(0,0,-1)
    g.add_edge(0,129,1)
    for i in 1..<129: g.add_edge(i+1,i,1)
    g.build()
    let answer = g.restore_bellmanford(0)
    for v in 0..<130:
        doAssert answer.costs[v] == -INF64 and answer.prev[v] == -1
block:
    var empty = initWeightedDirectedStaticGraph(0)
    empty.build()
    doAssert empty.bellmanford(newSeq[int]()).len == 0
    var ug = initUnWeightedDirectedGraph(3)
    ug.add_edge(0,1)
    doAssert ug.bellmanford(0) == @[0,1,INF64]

type OrderedCost = object
    value, trace: int
proc `<`(a,b: OrderedCost): bool = (a.value,a.trace) < (b.value,b.trace)
proc `+`(a,b: OrderedCost): OrderedCost = OrderedCost(value:a.value+b.value,trace:(31*a.trace+b.trace)mod 100003)
proc `-`(a: OrderedCost): OrderedCost = OrderedCost(value: -a.value,trace: -a.trace)
proc orderedOracle(g: WeightedDirectedGraph[OrderedCost], zero, inf: OrderedCost): tuple[costs: seq[OrderedCost],prev:seq[int]] =
    result.costs = newSeqWith(g.len,inf)
    result.prev = newSeqWith(g.len,-1)
    result.costs[0] = zero
    var changed = false
    for _ in 0..<g.len:
        changed = false
        for u in 0..<g.len:
            if result.costs[u] == inf: continue
            for (v,c) in g.to_and_cost(u):
                let next = result.costs[u]+c
                if next < result.costs[v]:
                    result.costs[v] = next
                    result.prev[v] = u
                    changed = true
        if not changed: break
    if changed:
        for _ in 0..<g.len:
            for u in 0..<g.len:
                if result.costs[u] == inf: continue
                for (v,c) in g.to_and_cost(u):
                    if result.costs[u]+c < result.costs[v]:
                        result.costs[v] = -inf
                        result.prev[v] = -1
var custom = initWeightedDirectedGraph(4,OrderedCost)
custom.add_edge(0,1,OrderedCost(value:1,trace:7))
custom.add_edge(1,1,OrderedCost(value: -1,trace:2))
custom.add_edge(1,2,OrderedCost(value:3,trace:5))
let zero = OrderedCost(value:0,trace:0)
let inf = OrderedCost(value:1000000,trace:0)
doAssert custom.restore_bellmanford(0,zero,inf) == orderedOracle(custom,zero,inf)
echo "Hello World"
