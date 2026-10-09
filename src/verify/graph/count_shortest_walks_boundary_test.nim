# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/count_shortest_walks
import cplib/modint/modint

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

proc boundaries[T: SomeSignedInt]() =
    var g = initWeightedDirectedGraph(4, T)
    g.add_edge(0, 1, high(T) - T(2))
    g.add_edge(1, 2, T(1))
    g.add_edge(2, 2, T(0))
    let r = g.count_shortest_walks(0, 0i64, 1i64)
    doAssert r.distance == @[T(0), high(T) - T(2), high(T) - T(1), high(T)]
    doAssert r.status == @[shortestWalkFinite, shortestWalkFinite, shortestWalkInfinite, shortestWalkUnreachable]
    doAssert r.count == @[1i64, 1i64, 0i64, 0i64]
    var bad = initWeightedDirectedGraph(3, T)
    bad.add_edge(2, 2, low(T))
    rejects: discard bad.count_shortest_walks(0, 0, 1)
    rejects: discard g.count_shortest_walks(-1, 0, 1)
    rejects: discard g.count_shortest_walks(4, 0, 1)
    rejects: discard g.count_shortest_walks(0, 0, 1, T(0))
    rejects: discard g.count_shortest_walks(0, 0, 1, T(-1))

boundaries[int]()
boundaries[int8]()
boundaries[int16]()
boundaries[int32]()
boundaries[int64]()

block:
    var g = initWeightedDirectedGraph(4)
    g.add_edge(0, 1, 4)
    g.add_edge(1, 2, 5)
    g.add_edge(0, 2, 12)
    doAssert g.count_shortest_walks(0, 0, 1, 10).distance == @[0, 4, 9, 10]
    let before = g.edge_info
    discard g.count_shortest_walks(0, 0, 1)
    doAssert before == g.edge_info
    var empty = initWeightedDirectedGraph(0)
    rejects: discard empty.count_shortest_walks(0, 0, 1)

block:
    var g = initWeightedDirectedStaticGraph(3)
    rejects: discard g.count_shortest_walks(0, 0, 1)
    g.add_edge(0, 1, 0)
    g.build()
    doAssert g.count_shortest_walks(0, 0, 1).count == @[1, 1, 0]
    g.add_edge(1, 1, 0)
    rejects: discard g.count_shortest_walks(0, 0, 1)
    g.build()
    doAssert g.count_shortest_walks(0, 0, 1).status[1] == shortestWalkInfinite
    var u = initUnWeightedUnDirectedStaticGraph(1)
    rejects: discard u.count_shortest_walks(0, 0, 1)
    u.build()
    doAssert u.count_shortest_walks(0, 0, 1).count == @[1]

block:
    var g = initWeightedDirectedGraph(4)
    g.add_edge(0, 1, 0)
    g.add_edge(1, 0, 0)
    g.add_edge(1, 2, 1)
    g.add_edge(3, 3, 0)
    let r = g.count_shortest_walks(0, modint998244353_barrett.init(0), modint998244353_barrett.init(1))
    doAssert r.status == @[shortestWalkInfinite, shortestWalkInfinite, shortestWalkInfinite, shortestWalkUnreachable]
    for value in r.count: doAssert value.val == 0

block:
    const n = when defined(release): 4000 else: 1500
    var g = initWeightedDirectedGraph(n)
    for u in 0..<n - 1: g.add_edge(u, u + 1, 0)
    let finite = g.count_shortest_walks(0, 0, 1)
    for u in 0..<n:
        doAssert finite.status[u] == shortestWalkFinite and finite.count[u] == 1
    g.add_edge(1, 1, 0)
    let infinite = g.count_shortest_walks(0, 0, 1)
    doAssert infinite.status[0] == shortestWalkFinite
    for u in 1..<n: doAssert infinite.status[u] == shortestWalkInfinite and infinite.count[u] == 0

block:
    var g = initWeightedDirectedGraph(2)
    for w in countdown(20000, 1): g.add_edge(0, 1, w)
    g.add_edge(0, 1, 1)
    let r = g.count_shortest_walks(0, 0, 1)
    doAssert r.distance == @[0, 1] and r.count == @[1, 2]

block:
    var g = initWeightedDirectedGraph(202)
    for u in 0..<200:
        g.add_edge(u, u + 1, 1)
        g.add_edge(u, u + 1, 1)
    let r = g.count_shortest_walks(0, modint998244353_montgomery.init(0), modint998244353_montgomery.init(1))
    for u in 0..200:
        doAssert r.status[u] == shortestWalkFinite
        doAssert r.count[u] == modint998244353_montgomery.init(2).pow(u)
    doAssert r.status[201] == shortestWalkUnreachable and r.count[201].val == 0

static:
    doAssert not compiles(initWeightedDirectedGraph(1, float).count_shortest_walks(0, 0, 1))
    doAssert not compiles(initWeightedDirectedGraph(1, uint).count_shortest_walks(0, 0, 1))

block:
    var g = initWeightedDirectedGraph(4)
    for v in 1..2:
        g.add_edge(0, v, 0)
        g.add_edge(0, v, 0)
        for e in 0..<40: g.add_edge(v, 3, 0)
    g.add_edge(3, 3, 0)
    let r = g.count_shortest_walks(0, 0i8, 1i8)
    doAssert r.count == @[1i8, 2i8, 2i8, 0i8]
    doAssert r.status[3] == shortestWalkInfinite

echo "Hello World"
