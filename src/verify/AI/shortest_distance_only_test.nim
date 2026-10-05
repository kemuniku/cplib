# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph, cplib/graph/dijkstra, cplib/graph/bellmanford, cplib/utils/constants
import random, sequtils

var rng = initRand(63183)
for trial in 0..<180:
    let n = 1 + rng.rand(8)
    var g = initWeightedDirectedGraph(n)
    var sg = initWeightedDirectedStaticGraph(n)
    var fg = initWeightedDirectedGraph(n, float)
    var i32g = initWeightedDirectedStaticGraph(n, int32)
    var f32g = initWeightedDirectedStaticGraph(n, float32)
    var dist = newSeqWith(n, newSeqWith(n, INF64))
    for i in 0..<n: dist[i][i] = 0
    for i in 0..<rng.rand(30):
        let u = rng.rand(n-1)
        let v = rng.rand(n-1)
        let w = rng.rand(12) - (if trial mod 2 == 0: 4 else: 0)
        if trial mod 2 == 0 and u >= v: continue
        g.add_edge(u,v,w)
        sg.add_edge(u,v,w)
        fg.add_edge(u,v,float(w)/4)
        i32g.add_edge(u,v,int32(w))
        f32g.add_edge(u,v,float32(w)/4)
        dist[u][v] = min(dist[u][v],w)
    sg.build()
    i32g.build()
    f32g.build()
    for k in 0..<n:
        for u in 0..<n:
            for v in 0..<n:
                if dist[u][k] != INF64 and dist[k][v] != INF64:
                    dist[u][v] = min(dist[u][v],dist[u][k]+dist[k][v])
    var starts: seq[int]
    for i in 0..<rng.rand(4): starts.add(rng.rand(n-1))
    var expected = newSeqWith(n,INF64)
    for s in starts:
        for v in 0..<n: expected[v] = min(expected[v],dist[s][v])
    doAssert g.bellmanford(starts) == expected
    doAssert sg.bellmanford(starts) == expected
    doAssert g.restore_bellmanford(starts).costs == expected
    let floats = fg.bellmanford(starts)
    let smalls = i32g.bellmanford(starts)
    let f32s = f32g.bellmanford(starts)
    for v in 0..<n:
        doAssert floats[v] == (if expected[v] == INF64: 1e100 else: float(expected[v])/4)
        doAssert smalls[v] == (if expected[v] == INF64: INF32 else: int32(expected[v]))
        doAssert f32s[v] == (if expected[v] == INF64: 1e30'f32 else: float32(expected[v])/4)
    if trial mod 2 == 1:
        doAssert g.dijkstra(starts) == expected
        doAssert sg.dijkstra(starts) == expected
        doAssert g.restore_dijkstra(starts).costs == expected
        doAssert fg.dijkstra(starts) == floats
        doAssert i32g.dijkstra(starts) == smalls
        doAssert f32g.dijkstra(starts) == f32s
    let source = rng.rand(n-1)
    doAssert g.bellmanford(source) == dist[source]
    if trial mod 2 == 1: doAssert g.dijkstra(source) == dist[source]

var neg = initWeightedDirectedGraph(7)
neg.add_edge(0,1,2)
neg.add_edge(1,2,-3)
neg.add_edge(2,1,1)
neg.add_edge(2,3,5)
neg.add_edge(0,4,1)
neg.add_edge(5,6,-2)
neg.add_edge(6,5,1)
doAssert neg.bellmanford(0) == neg.restore_bellmanford(0).costs
doAssert neg.bellmanford(@[0,5,5]) == neg.restore_bellmanford(@[0,5,5]).costs
var empty = initWeightedDirectedGraph(0)
doAssert empty.dijkstra(newSeq[int]()).len == 0
doAssert empty.bellmanford(newSeq[int]()).len == 0
var ug = initUnWeightedDirectedGraph(4)
ug.add_edge(0,1)
ug.add_edge(1,2)
doAssert ug.dijkstra(@[0,0]) == @[0,1,2,INF64]
doAssert ug.bellmanford(@[0,0]) == @[0,1,2,INF64]

type OrderedCost = object
    value, trace: int
proc `<`(a,b: OrderedCost): bool = (a.value,a.trace) < (b.value,b.trace)
proc `>`(a,b: OrderedCost): bool = b < a
proc `+`(a,b: OrderedCost): OrderedCost = OrderedCost(value:a.value+b.value,trace:(31*a.trace+b.trace)mod 100003)
proc `-`(a: OrderedCost): OrderedCost = OrderedCost(value: -a.value,trace: -a.trace)
var custom = initWeightedDirectedGraph(4,OrderedCost)
custom.add_edge(0,1,OrderedCost(value:2,trace:7))
custom.add_edge(1,2,OrderedCost(value:3,trace:5))
custom.add_edge(0,2,OrderedCost(value:6,trace:1))
let zero = OrderedCost(value:0,trace:0)
let inf = OrderedCost(value:1000000,trace:0)
let expected = @[zero,OrderedCost(value:2,trace:7),OrderedCost(value:5,trace:222),inf]
doAssert custom.dijkstra(0,zero,inf) == expected
doAssert custom.bellmanford(0,zero,inf) == expected
doAssert custom.restore_dijkstra(0,zero,inf).costs == expected
doAssert custom.restore_bellmanford(0,zero,inf).costs == expected
echo "Hello World"
