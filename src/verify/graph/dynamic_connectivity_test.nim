# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, sequtils
import cplib/graph/dynamic_connectivity

type NaiveGraph = seq[seq[int]]

proc componentIds(adj: NaiveGraph): seq[int] =
    result = newSeqWith(adj.len, -1)
    for start in 0..<adj.len:
        if result[start] >= 0: continue
        result[start] = start
        var queue = @[start]
        var head = 0
        while head < queue.len:
            let u = queue[head]
            inc head
            for v in 0..<adj.len:
                if adj[u][v] > 0 and result[v] < 0:
                    result[v] = start
                    queue.add(v)

proc check(dc: DynamicConnectivity, adj: NaiveGraph, allPairs = true) =
    let ids = adj.componentIds()
    var sizes = newSeq[int](adj.len)
    for id in ids: inc sizes[id]
    var count = 0
    for size in sizes:
        if size != 0: inc count
    doAssert dc.len == adj.len
    doAssert dc.count == count
    for u in 0..<adj.len:
        doAssert dc.size(u) == sizes[ids[u]]
        doAssert dc.siz(u) == sizes[ids[u]]
        doAssert dc.connected(u, u)
        if allPairs:
            for v in 0..<adj.len:
                doAssert dc.connected(u, v) == (ids[u] == ids[v])
                doAssert dc.issame(u, v) == (ids[u] == ids[v])
                doAssert dc.edgeCount(u, v) == adj[u][v]
                doAssert dc.contains(u, v) == (adj[u][v] != 0)

proc insert(dc: DynamicConnectivity, adj: var NaiveGraph, u, v: int) =
    let before = adj.componentIds()
    doAssert dc.link(u, v) == (before[u] != before[v])
    inc adj[u][v]
    if u != v: inc adj[v][u]

proc erase(dc: DynamicConnectivity, adj: var NaiveGraph, u, v: int) =
    let before = adj.componentIds()
    if adj[u][v] > 0:
        dec adj[u][v]
        if u != v: dec adj[v][u]
    let after = adj.componentIds()
    doAssert dc.cut(u, v) == (before[u] == before[v] and after[u] != after[v])

block:
    let dc = initDynamicConnectivity(0)
    dc.check(@[])

block:
    let dc = initDynamicConnectivity(4, 8)
    var adj = newSeqWith(4, newSeq[int](4))
    for (u, v) in [(0, 0), (0, 0), (0, 1), (1, 0), (1, 2), (2, 0), (2, 3)]:
        dc.insert(adj, u, v)
        dc.check(adj)
    for (u, v) in [(0, 1), (1, 0), (0, 2), (0, 0), (0, 0), (0, 0), (3, 2), (1, 2), (2, 1)]:
        dc.erase(adj, u, v)
        dc.check(adj)

var rng = initRand(20260926)
for n in [1, 2, 3, 8, 17, 32, 65]:
    for trial in 0..<3:
        let dc = initDynamicConnectivity(n)
        var adj = newSeqWith(n, newSeq[int](n))
        var present: seq[tuple[u, v: int]]
        for step in 0..<1400:
            let u = rng.rand(n - 1)
            let v = rng.rand(n - 1)
            if present.len == 0 or rng.rand(99) < (if trial == 0: 40 elif trial == 1: 50 else: 60):
                dc.insert(adj, u, v)
                present.add((u, v))
            elif step mod 5 == 0:
                dc.erase(adj, u, v)
                for i in 0..<present.len:
                    if present[i] == (u, v) or present[i] == (v, u):
                        present[i] = present[^1]
                        present.setLen(present.len - 1)
                        break
            else:
                let index = rng.rand(present.high)
                let edge = present[index]
                dc.erase(adj, edge.v, edge.u)
                present[index] = present[^1]
                present.setLen(present.len - 1)
            if step mod 31 == 0: dc.check(adj)
            else: dc.check(adj, false)
        rng.shuffle(present)
        for edge in present: dc.erase(adj, edge.u, edge.v)
        dc.check(adj)
        doAssert dc.count == n

block:
    const n = 40
    let dc = initDynamicConnectivity(n)
    var adj = newSeqWith(n, newSeq[int](n))
    for trial in 0..<8:
        var edges: seq[tuple[u, v: int]]
        for v in 1..<n:
            let u = if trial mod 2 == 0: v - 1 else: 0
            dc.insert(adj, u, v)
            edges.add((u, v))
        for u in 0..<n:
            for v in u + 1..<n:
                if adj[u][v] == 0:
                    dc.insert(adj, u, v)
                    edges.add((u, v))
        dc.check(adj)
        if trial mod 2 == 0: rng.shuffle(edges)
        for i, edge in edges:
            dc.erase(adj, edge.v, edge.u)
            if i mod 47 == 0: dc.check(adj)
        dc.check(adj)

block:
    const n = 256
    let dc = initDynamicConnectivity(n)
    for trial in 0..<12:
        for v in 1..<n: doAssert dc.link(v - 1, v)
        var width = n
        while width > 1:
            for left in countup(0, n - 1, width):
                let mid = left + width div 2
                doAssert dc.cut(mid - 1, mid)
                doAssert dc.size(mid - 1) == width div 2
                doAssert dc.size(mid) == width div 2
                doAssert not dc.connected(left, mid)
            width = width div 2
        doAssert dc.count == n
        for v in 0..<n: doAssert dc.size(v) == 1

block:
    const n = 20000
    let dc = initDynamicConnectivity(n, n)
    for v in 1..<n: doAssert dc.link(v - 1, v)
    doAssert not dc.link(0, n - 1)
    for v in 1..<n:
        doAssert not dc.cut(v - 1, v)
        doAssert dc.size(v) == n
        doAssert not dc.link(v - 1, v)
    doAssert not dc.cut(0, n - 1)
    for v in 1..<n: doAssert dc.cut(v - 1, v)
    doAssert dc.count == n

when compileOption("assertions"):
    block:
        var rejected = false
        try:
            discard initDynamicConnectivity(-1)
        except AssertionDefect:
            rejected = true
        doAssert rejected
    block:
        let dc = initDynamicConnectivity(2)
        for invalid in [-1, 2]:
            var rejected = false
            try:
                dc.link(0, invalid)
            except AssertionDefect:
                rejected = true
            doAssert rejected
        doAssert dc.count == 2

echo "Hello World"
