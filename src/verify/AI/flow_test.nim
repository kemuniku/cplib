# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/maxflow
import cplib/graph/mincostflow
import random, tables

block:
    var g = initMaxFlow[int64](3)
    g.add_edge(0, 0, 7)
    g.add_edge(0, 1, 5)
    g.add_edge(0, 1, 2)
    g.add_edge(1, 2, 6)
    doAssert g.flow(0, 2, 0) == 0
    doAssert g.flow(0, 2, 2) == 2
    doAssert g.flow(0, 2) == 4
    doAssert g.flow(0, 2) == 0
    doAssert g.get_edge(0).cap == 7 and g.get_edge(0).flow == 0
    doAssert g.min_cut(0) == @[true, true, false]

block:
    var g = initMinCostFlow[int32, int64](3)
    g.add_edge(0, 0, 3, 1)
    g.add_edge(0, 1, 2, -3)
    g.add_edge(1, 2, 2, 5)
    doAssert g.flow(0, 2, 0) == (0'i32, 0'i64)
    doAssert g.flow(0, 2, 1) == (1'i32, 2'i64)
    doAssert g.flow(0, 2) == (1'i32, 2'i64)
    doAssert g.flow(0, 2) == (0'i32, 0'i64)
    doAssert g.get_edge(0).flow == 0
    doAssert g.get_edge(1).flow == 2

block:
    var g = initMinCostFlow[int, int](2)
    g.add_edge(0, 0, 1, -1)
    var caught = false
    try:
        discard g.flow(0, 1)
    except ValueError:
        caught = true
    doAssert caught

block:
    var g = initMaxFlow[int](100000)
    for i in 0..<99999:
        g.add_edge(i, i + 1, 1)
    doAssert g.flow(0, 99999) == 1

block:
    var g = initMaxFlow(2)
    doAssert g is MaxFlow[int]
    g.add_edge(0, 1, 3)
    doAssert g.flow(0, 1) == 3
    var h = initMinCostFlow(2)
    doAssert h is MinCostFlow[int, int]
    h.add_edge(0, 1, 3, 2)
    doAssert h.flow(0, 1) == (3, 6)

var rng = initRand(712367)
for trial in 0..<400:
    let n = rng.rand(2..5)
    var es: seq[tuple[src, dst, cap, cost: int]]
    var mf = initMaxFlow[int](n)
    var mcf = initMinCostFlow[int, int](n)
    var repeated = initMinCostFlow[int, int](n)
    for i in 0..<7:
        var src = rng.rand(n - 1)
        var dst = rng.rand(n - 1)
        var cost = rng.rand(0..5)
        if trial mod 2 == 0:
            if src == dst:
                continue
            if src > dst:
                swap(src, dst)
            cost -= 3
        let cap = rng.rand(0..2)
        es.add((src, dst, cap, cost))
        mf.add_edge(src, dst, cap)
        mcf.add_edge(src, dst, cap, cost)
        repeated.add_edge(src, dst, cap, cost)
    var best = initTable[int, int]()
    var balance = newSeq[int](n)
    proc enumerate(i, cost: int) =
        if i == es.len:
            for v in 1..<n - 1:
                if balance[v] != 0:
                    return
            if balance[0] > 0 or balance[n - 1] != -balance[0]:
                return
            let f = -balance[0]
            if f notin best or cost < best[f]:
                best[f] = cost
            return
        let e = es[i]
        for f in 0..e.cap:
            balance[e.src] -= f
            balance[e.dst] += f
            enumerate(i + 1, cost + f * e.cost)
            balance[e.src] += f
            balance[e.dst] -= f
    enumerate(0, 0)
    var maximum = 0
    for f in best.keys:
        maximum = max(maximum, f)
    doAssert mf.flow(0, n - 1) == maximum
    let cut = mf.min_cut(0)
    var cutCap = 0
    for e in es:
        if cut[e.src] and not cut[e.dst]:
            cutCap += e.cap
    doAssert cutCap == maximum
    let points = mcf.slope(0, n - 1)
    doAssert points[0] == (0, 0)
    doAssert points[^1] == (maximum, best[maximum])
    for i in 1..<points.len:
        let a = points[i - 1]
        let b = points[i]
        let unit = (b.cost - a.cost) div (b.flow - a.flow)
        for f in a.flow..b.flow:
            doAssert best[f] == a.cost + (f - a.flow) * unit
        if i > 1:
            let p = points[i - 2]
            doAssert unit > (a.cost - p.cost) div (a.flow - p.flow)
    var total = 0
    for f in 1..maximum:
        let answer = repeated.flow(0, n - 1, 1)
        doAssert answer.flow == 1
        total += answer.cost
        doAssert total == best[f]
    doAssert repeated.flow(0, n - 1) == (0, 0)
    var actualCost = 0
    for e in mcf.get_edges:
        doAssert e.flow >= 0 and e.flow <= e.cap
        actualCost += e.flow * e.cost
    doAssert actualCost == best[maximum]
block:
    var rng = initRand(901237)
    for trial in 0..<500:
        let n = rng.rand(2..8)
        var g = initMaxFlow[int64](n)
        for i in 0..<rng.rand(0..40):
            g.add_edge(rng.rand(n - 1), rng.rand(n - 1), int64(rng.rand(0..100)))
        let original = g.get_edges
        var minimum = high(int64)
        for mask in 0..<(1 shl n):
            if (mask and 1) == 0 or (mask and (1 shl (n - 1))) != 0:
                continue
            var capacity = 0'i64
            for e in original:
                if (mask and (1 shl e.src)) != 0 and (mask and (1 shl e.dst)) == 0:
                    capacity += e.cap
            minimum = min(minimum, capacity)
        var total = 0'i64
        while true:
            let limit = int64(rng.rand(1..50))
            let added = g.flow(0, n - 1, limit)
            doAssert added >= 0 and added <= limit
            total += added
            var balance = newSeq[int64](n)
            for i, e in g.get_edges:
                doAssert e.cap == original[i].cap
                doAssert e.src == original[i].src and e.dst == original[i].dst
                doAssert e.flow >= 0 and e.flow <= e.cap
                balance[e.src] -= e.flow
                balance[e.dst] += e.flow
            doAssert balance[0] == -total and balance[n - 1] == total
            for v in 1..<n - 1:
                doAssert balance[v] == 0
            if added < limit:
                break
        doAssert total == minimum
        let cut = g.min_cut(0)
        var capacity = 0'i64
        for e in original:
            if cut[e.src] and not cut[e.dst]:
                capacity += e.cap
        doAssert capacity == minimum
        g.add_edge(0, n - 1, 123)
        doAssert g.flow(0, n - 1) == 123

block:
    var g = initMaxFlow[uint64](4)
    let capacity = high(uint64)
    g.add_edge(0, 1, capacity)
    g.add_edge(1, 2, capacity)
    g.add_edge(2, 3, capacity)
    doAssert g.flow(0, 3, capacity - 1) == capacity - 1
    doAssert g.flow(0, 3) == 1

block:
    var g = initMaxFlow[int](5)
    g.add_edge(0, 1, 2)
    g.add_edge(0, 2, 3)
    g.add_edge(1, 3, 2)
    g.add_edge(2, 3, 3)
    g.add_edge(3, 4, 5)
    doAssert g.flow(0, 4, 4) == 4
    doAssert g.flow(0, 4) == 1

echo "Hello World"
