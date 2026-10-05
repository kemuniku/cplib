# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/mincostflow
import random, tables

block:
    var g = initMinCostFlow[int,int](4)
    g.add_edge(0,0,4,3)
    g.add_edge(0,1,2,5)
    g.add_edge(1,2,2,1)
    g.add_edge(2,3,2,2)
    g.add_edge(3,0,0,-100)
    for _ in 0..<5:
        doAssert g.flow(0,3,1) == (1,8)
        doAssert g.flow(3,0,1) == (1,-8)
        for e in g.get_edges(): doAssert e.flow == 0
    doAssert g.flow(0,3) == (2,16)
    doAssert g.flow(0,3) == (0,0)
    doAssert g.flow(3,0) == (2,-16)
    g.add_edge(0,3,1,-2)
    doAssert g.flow(0,3,1) == (1,-2)
    doAssert g.flow(3,0,1) == (1,2)
block:
    var g = initMinCostFlow[int32,int64](4)
    g.add_edge(0,1,2,4)
    g.add_edge(0,1,1,1)
    g.add_edge(1,3,3,2)
    g.add_edge(2,2,1,-1)
    doAssert g.slope(0,3) == @[(0'i32,0'i64),(1'i32,3'i64),(3'i32,15'i64)]
    doAssert g.flow(3,0,2) == (2'i32,-12'i64)
    doAssert g.flow(0,3,2) == (2'i32,12'i64)
block:
    var g = initMinCostFlow[uint64,int32](2)
    g.add_edge(0,1,high(uint64),0)
    doAssert g.flow(0,1) == (high(uint64),0'i32)
    doAssert g.flow(1,0) == (high(uint64),0'i32)
    doAssert g.flow(0,1,3) == (3'u64,0'i32)
block:
    var g = initMinCostFlow[int,int](3)
    g.add_edge(0,1,1,1)
    g.add_edge(1,2,1,1)
    let before = g.get_edges()
    doAssert g.flow(0,2,0) == (0,0)
    doAssert g.get_edges() == before
    g.add_edge(2,0,1,-3)
    let cyclic = g.get_edges()
    var caught = false
    try: discard g.flow(0,2)
    except ValueError: caught = true
    doAssert caught and g.get_edges() == cyclic
    doAssert g.flow(0,2,0) == (0,0)
block:
    var original = initMinCostFlow[int,int](3)
    original.add_edge(0,1,2,3)
    original.add_edge(1,2,2,4)
    var copied = original
    doAssert copied.flow(0,2,1) == (1,7)
    doAssert original.get_edge(0).flow == 0
    doAssert original.flow(0,2,2) == (2,14)
    doAssert copied.flow(2,0,1) == (1,-7)

var rng = initRand(18319)
for trial in 0..<160:
    let n = rng.rand(2..5)
    var es: seq[tuple[src,dst,cap,cost:int]]
    var g = initMinCostFlow[int,int](n)
    var repeated = initMinCostFlow[int,int](n)
    for _ in 0..<7:
        var u = rng.rand(n-1)
        var v = rng.rand(n-1)
        var cost = rng.rand(0..7)
        if trial mod 2 == 0:
            if u == v: continue
            if u > v: swap(u,v)
            cost -= 4
        let cap = rng.rand(0..2)
        es.add((u,v,cap,cost))
        g.add_edge(u,v,cap,cost)
        repeated.add_edge(u,v,cap,cost)
    var best = initTable[int,int]()
    var balance = newSeq[int](n)
    proc enumerate(i,cost:int) =
        if i == es.len:
            for v in 1..<n-1:
                if balance[v] != 0:return
            if balance[0] > 0 or balance[^1] != -balance[0]:return
            let flow = -balance[0]
            if flow notin best or cost < best[flow]:best[flow] = cost
            return
        let e = es[i]
        for f in 0..e.cap:
            balance[e.src] -= f
            balance[e.dst] += f
            enumerate(i+1,cost+f*e.cost)
            balance[e.src] += f
            balance[e.dst] -= f
    enumerate(0,0)
    var maximum = 0
    for f in best.keys: maximum = max(maximum,f)
    let points = g.slope(0,n-1)
    doAssert points[0] == (0,0)
    doAssert points[^1] == (maximum,best[maximum])
    for i in 1..<points.len:
        let a = points[i-1]
        let b = points[i]
        let unit = (b.cost-a.cost) div (b.flow-a.flow)
        for f in a.flow..b.flow:doAssert best[f] == a.cost+(f-a.flow)*unit
    var total = 0
    for f in 1..maximum:
        let answer = repeated.flow(0,n-1,1)
        doAssert answer.flow == 1
        total += answer.cost
        doAssert total == best[f]
    doAssert repeated.flow(0,n-1) == (0,0)
    var returned = 0
    for f in countdown(maximum-1,0):
        let answer = repeated.flow(n-1,0,1)
        doAssert answer.flow == 1
        returned += answer.cost
        doAssert total+returned == best[f]
    doAssert repeated.flow(0,n-1) == (maximum,best[maximum])
echo "Hello World"
