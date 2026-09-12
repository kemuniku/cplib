# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/push_relabel
import random

proc cutCapacity(g: PushRelabel[int64], n, src, dst: int): int64 =
    result = high(int64)
    let edges = g.get_edges()
    for mask in 0..<(1 shl n):
        if (mask and (1 shl src)) == 0 or (mask and (1 shl dst)) != 0:
            continue
        var capacity = 0'i64
        for e in edges:
            if (mask and (1 shl e.src)) != 0 and (mask and (1 shl e.dst)) == 0:
                capacity += e.cap
        result = min(result, capacity)

proc checkFlow(g: PushRelabel[int64], n, src, dst: int, total: int64) =
    var balance = newSeq[int64](n)
    for e in g.get_edges():
        doAssert e.flow >= 0 and e.flow <= e.cap
        balance[e.src] -= e.flow
        balance[e.dst] += e.flow
    for v in 0..<n:
        if v == src:
            doAssert balance[v] == -total
        elif v == dst:
            doAssert balance[v] == total
        else:
            doAssert balance[v] == 0

block:
    var g = initPushRelabel(3)
    doAssert g is PushRelabel[int]
    doAssert g.add_edge(0, 0, 7) == 0
    g.add_edge(0, 1, 5)
    g.add_edge(0, 1, 2)
    g.add_edge(1, 2, 6)
    doAssert g.flow(0, 2, 0) == 0
    doAssert g.flow(0, 2, 2) == 2
    doAssert g.flow(0, 2) == 4
    doAssert g.flow(0, 2) == 0
    doAssert g.get_edge(0).cap == 7 and g.get_edge(0).flow == 0
    doAssert g.min_cut(0) == @[true, true, false]
    doAssert g.flow(2, 0) == 6
    for e in g.get_edges():
        doAssert e.flow == 0

block:
    var g = initPushRelabel[int32](5)
    g.add_edge(0, 1, 100)
    g.add_edge(1, 2, 100)
    g.add_edge(2, 1, 100)
    doAssert g.flow(0, 4) == 0
    for e in g.get_edges():
        doAssert e.flow == 0
    g.add_edge(2, 4, 3)
    doAssert g.flow(0, 4) == 3

block:
    var g = initPushRelabel[uint64](4)
    let capacity = high(uint64)
    g.add_edge(0, 1, capacity)
    g.add_edge(0, 2, capacity)
    g.add_edge(1, 3, 1)
    g.add_edge(2, 3, 2)
    doAssert g.flow(0, 3) == 3
    doAssert g.get_edge(0).flow == 1
    doAssert g.get_edge(1).flow == 2
    doAssert g.flow(0, 3) == 0

block:
    var g = initPushRelabel[uint64](4)
    let capacity = high(uint64)
    g.add_edge(0, 1, capacity)
    g.add_edge(1, 2, capacity)
    g.add_edge(2, 3, capacity)
    doAssert g.flow(0, 3, capacity - 1) == capacity - 1
    doAssert g.flow(0, 3) == 1

block:
    var g = initPushRelabel[int64](4)
    let capacity = high(int64)
    g.add_edge(0, 1, capacity)
    g.add_edge(0, 2, capacity)
    g.add_edge(1, 3, capacity)
    g.add_edge(2, 3, capacity)
    doAssert g.flow(0, 3) == capacity
    doAssert g.flow(0, 3) == capacity
    doAssert g.flow(0, 3) == 0

var rng = initRand(947125)
for trial in 0..<1000:
    let n = rng.rand(2..8)
    let src = rng.rand(n - 1)
    let dst = (src + rng.rand(1..<n)) mod n
    var g = initPushRelabel[int64](n)
    for i in 0..<rng.rand(0..50):
        g.add_edge(rng.rand(n - 1), rng.rand(n - 1), int64(rng.rand(0..100)))
    let original = g.get_edges()
    let maximum = g.cutCapacity(n, src, dst)
    var total = 0'i64
    while true:
        let limit = int64(rng.rand(1..150))
        let added = g.flow(src, dst, limit)
        doAssert added >= 0 and added <= limit
        total += added
        g.checkFlow(n, src, dst, total)
        if added < limit:
            break
    doAssert total == maximum
    let cut = g.min_cut(src)
    doAssert cut[src] and not cut[dst]
    var capacity = 0'i64
    for i, e in g.get_edges():
        doAssert e.cap == original[i].cap
        doAssert e.src == original[i].src and e.dst == original[i].dst
        if cut[e.src] and not cut[e.dst]:
            capacity += e.cap
    doAssert capacity == maximum
    for i in 0..<5:
        g.add_edge(rng.rand(n - 1), rng.rand(n - 1), int64(rng.rand(0..100)))
    total += g.flow(src, dst)
    doAssert total == g.cutCapacity(n, src, dst)
    g.checkFlow(n, src, dst, total)

block:
    const components = 1000
    const src = 3 * components
    const dst = src + 1
    var g = initPushRelabel[int64](dst + 1)
    for i in 0..<components:
        g.add_edge(src, 3 * i, 1)
        g.add_edge(src, 3 * i + 1, 1)
        g.add_edge(3 * i, 3 * i + 2, 1)
        g.add_edge(3 * i + 1, 3 * i + 2, 1)
        g.add_edge(3 * i + 2, dst, 1)
    doAssert g.flow(src, dst) == components
    g.checkFlow(dst + 1, src, dst, components)
    doAssert g.flow(src, dst) == 0

block:
    const n = 100000
    var g = initPushRelabel[int](n)
    for v in 0..<n - 1:
        g.add_edge(v, v + 1, 1)
    doAssert g.flow(0, n - 1) == 1
    doAssert g.get_edges().len == n - 1

echo "Hello World"
