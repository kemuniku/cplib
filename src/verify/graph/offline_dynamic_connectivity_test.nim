# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/offline_dynamic_connectivity

type OracleEdge = tuple[u, v: int, active: bool]
type Change = tuple[add: bool, a, b: int]

proc bfs(n: int, edges: seq[OracleEdge], u, v: int): bool =
    var seen = newSeq[bool](n)
    var queue = @[u]
    seen[u] = true
    var i = 0
    while i < queue.len:
        let x = queue[i]
        for edge in edges:
            if not edge.active: continue
            var y = -1
            if edge.u == x: y = edge.v
            elif edge.v == x: y = edge.u
            if y >= 0 and not seen[y]:
                seen[y] = true
                queue.add(y)
        inc i
    seen[v]

proc allPairs(dc: OfflineDynamicConnectivity, n: int,
              edges: seq[OracleEdge], expected: var seq[bool]) =
    for u in 0..<n:
        for v in 0..<n:
            doAssert dc.connected(u, v) == expected.len
            expected.add(bfs(n, edges, u, v))

template rejects(body: untyped) =
    block:
        var caught = false
        try: body
        except ValueError: caught = true
        doAssert caught

block:
    doAssert initOfflineDynamicConnectivity(0).run() == newSeq[bool]()
    rejects: discard initOfflineDynamicConnectivity(-1)
    rejects: discard initOfflineDynamicConnectivity(int.high)
    let tooLargeForEdge = initOfflineDynamicConnectivity(int.high - 1)
    rejects: discard tooLargeForEdge.add(0, 1)
    doAssert initOfflineDynamicConnectivity(7).run() == newSeq[bool]()
    let empty = initOfflineDynamicConnectivity(0)
    rejects: discard empty.add(0, 0)
    rejects: discard empty.connected(0, 0)
    rejects: empty.remove(0)
    var uninitialized: OfflineDynamicConnectivity
    rejects: discard uninitialized.run()
    rejects: discard uninitialized.add(0, 0)
    rejects: discard uninitialized.connected(0, 0)
    rejects: uninitialized.remove(0)
    let dc = initOfflineDynamicConnectivity(2)
    rejects: discard dc.add(-1, 0)
    rejects: discard dc.add(0, 2)
    rejects: discard dc.connected(2, 0)
    rejects: discard dc.connected(0, -1)
    rejects: dc.remove(-1)
    rejects: dc.remove(0)
    doAssert dc.add(0, 1) == 0
    dc.remove(0)
    rejects: dc.remove(0)
    doAssert dc.connected(0, 1) == 0
    doAssert dc.run() == @[false]

block:
    let dc = initOfflineDynamicConnectivity(4)
    var edges: seq[OracleEdge]
    var expected: seq[bool]
    template addEdge(u, v: int) =
        doAssert dc.add(u, v) == edges.len
        edges.add((u, v, true))
    template removeEdge(id: int) =
        dc.remove(id)
        edges[id].active = false
    allPairs(dc, 4, edges, expected)
    addEdge(0, 0)
    addEdge(0, 1)
    addEdge(1, 2)
    addEdge(2, 0)
    addEdge(1, 0)
    addEdge(2, 3)
    allPairs(dc, 4, edges, expected)
    removeEdge(1)
    allPairs(dc, 4, edges, expected)
    removeEdge(4)
    allPairs(dc, 4, edges, expected)
    removeEdge(3)
    allPairs(dc, 4, edges, expected)
    addEdge(0, 1)
    allPairs(dc, 4, edges, expected)
    removeEdge(0)
    removeEdge(2)
    removeEdge(5)
    removeEdge(6)
    allPairs(dc, 4, edges, expected)
    let immutable = dc
    doAssert immutable.run() == expected
    var answer = immutable.run()
    answer[0] = not answer[0]
    doAssert immutable.run() == expected
    addEdge(3, 0)
    allPairs(immutable, 4, edges, expected)
    doAssert immutable.run() == expected
    removeEdge(7)
    allPairs(dc, 4, edges, expected)
    doAssert dc.run() == expected

block:
    proc replay(history: seq[Change]) =
        let dc = initOfflineDynamicConnectivity(3)
        var edges: seq[OracleEdge]
        var expected: seq[bool]
        allPairs(dc, 3, edges, expected)
        for change in history:
            if change.add:
                doAssert dc.add(change.a, change.b) == edges.len
                edges.add((change.a, change.b, true))
            else:
                dc.remove(change.a)
                edges[change.a].active = false
            allPairs(dc, 3, edges, expected)
        doAssert dc.run() == expected
    proc enumerate(history: var seq[Change], active: var seq[bool], depth: int) =
        replay(history)
        if depth == 0: return
        for u in 0..<3:
            for v in u..<3:
                history.add((true, u, v))
                active.add(true)
                enumerate(history, active, depth - 1)
                active.setLen(active.len - 1)
                history.setLen(history.len - 1)
        for id in 0..<active.len:
            if active[id]:
                history.add((false, id, 0))
                active[id] = false
                enumerate(history, active, depth - 1)
                active[id] = true
                history.setLen(history.len - 1)
    var history: seq[Change]
    var active: seq[bool]
    enumerate(history, active, 4)

block:
    var rng = initRand(407)
    for trial in 0..<240:
        let n = 1 + rng.rand(8)
        let dc = initOfflineDynamicConnectivity(n)
        var edges: seq[OracleEdge]
        var expected: seq[bool]
        for step in 0..<140:
            case rng.rand(3)
            of 0, 1:
                let u = rng.rand(n - 1)
                let v = rng.rand(n - 1)
                doAssert dc.add(u, v) == edges.len
                edges.add((u, v, true))
            of 2:
                if edges.len > 0:
                    let id = rng.rand(edges.len - 1)
                    if edges[id].active:
                        dc.remove(id)
                        edges[id].active = false
            else: discard
            let u = rng.rand(n - 1)
            let v = rng.rand(n - 1)
            doAssert dc.connected(u, v) == expected.len
            expected.add(bfs(n, edges, u, v))
            if step mod 35 == 0:
                allPairs(dc, n, edges, expected)
                doAssert dc.run() == expected
        allPairs(dc, n, edges, expected)
        doAssert dc.run() == expected
        doAssert dc.run() == expected

block:
    const n = 3000
    let dc = initOfflineDynamicConnectivity(n)
    var chain, parallel: seq[int]
    var expected: seq[bool]
    for v in 1..<n: chain.add(dc.add(v - 1, v))
    for v in 1..<n: parallel.add(dc.add(v, v - 1))
    for v in 1..<n:
        dc.remove(chain[v - 1])
        discard dc.connected(0, n - 1)
        expected.add(true)
    for v in 1..<n:
        dc.remove(parallel[v - 1])
        discard dc.connected(0, n - 1)
        expected.add(false)
        discard dc.connected(v, n - 1)
        expected.add(true)
    for v in 1..<n: discard dc.add(0, v)
    discard dc.connected(0, n - 1)
    expected.add(true)
    doAssert dc.run() == expected
    doAssert dc.run() == expected

echo "Hello World"
