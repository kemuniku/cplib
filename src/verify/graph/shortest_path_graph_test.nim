# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/shortest_path_graph
import algorithm, random, sequtils

type Arc = tuple[u, v, w, id: int]
const infinity = 1_000_000

proc oracle(n: int, arcs: seq[Arc]): tuple[distance: seq[seq[int]], used: seq[seq[seq[int]]]] =
    result.distance = newSeqWith(n, newSeqWith(n, infinity))
    for s in 0..<n: result.distance[s][s] = 0
    for e in arcs: result.distance[e.u][e.v] = min(result.distance[e.u][e.v], e.w)
    for k in 0..<n:
        for u in 0..<n:
            for v in 0..<n:
                result.distance[u][v] = min(result.distance[u][v], result.distance[u][k] + result.distance[k][v])
    result.used = newSeq[seq[seq[int]]](arcs.len)
    for forced in 0..<arcs.len:
        var d = newSeqWith(2 * n, newSeqWith(2 * n, infinity))
        for u in 0..<2 * n: d[u][u] = 0
        for i, e in arcs:
            for used in 0..1:
                let next = if used == 1 or i == forced: 1 else: 0
                let u = used * n + e.u
                let v = next * n + e.v
                d[u][v] = min(d[u][v], e.w)
        for k in 0..<2 * n:
            for u in 0..<2 * n:
                for v in 0..<2 * n:
                    d[u][v] = min(d[u][v], d[u][k] + d[k][v])
        result.used[forced] = newSeqWith(n, newSeq[int](n))
        for s in 0..<n:
            for t in 0..<n: result.used[forced][s][t] = d[s][n + t]

proc check[G](g: G, arcs: seq[Arc]) =
    let expected = oracle(g.len, arcs)
    let before = g.edge_info
    for s in 0..<g.len:
        for t in 0..<g.len:
            let answer = g.shortest_path_graph(s, t)
            let dist = expected.distance[s][t]
            doAssert answer.distance == (if dist == infinity: high(int) else: dist)
            doAssert answer.graph.len == g.len
            doAssert answer.original_edge_ids.len == answer.graph.edge_count
            var want, actual: seq[Arc]
            if dist != infinity:
                for i, e in arcs:
                    if expected.used[i][s][t] == dist: want.add(e)
            for id in 0..<answer.graph.edge_count:
                let e = answer.graph.get_edge(id)
                actual.add((e.src, e.dst, e.cost, answer.original_edge_ids[id]))
            want.sort()
            actual.sort()
            doAssert actual == want
            var adjacency: seq[Arc]
            for u in 0..<answer.graph.len:
                for (v, w, id) in answer.graph.to_and_cost_and_id(u):
                    adjacency.add((u, v, w, answer.original_edge_ids[id]))
            adjacency.sort()
            doAssert adjacency == want
            doAssert g.edge_info == before

template exercise(init: untyped, weighted, undirected, isStatic: static bool) =
    block:
        var rng = initRand(467)
        for trial in 0..<80:
            let n {.inject.} = rng.rand(1..5)
            var g = init
            var arcs: seq[Arc]
            for id in 0..<rng.rand(0..16):
                let u = rng.rand(n - 1)
                let v = rng.rand(n - 1)
                let w = when weighted: rng.rand(0..5)
                        else: 1
                when weighted: doAssert g.add_edge(u, v, w) == id
                else: doAssert g.add_edge(u, v) == id
                arcs.add((u, v, w, id))
                when undirected: arcs.add((v, u, w, id))
            when isStatic: g.build()
            check(g, arcs)

exercise(initWeightedDirectedGraph(n), true, false, false)
exercise(initWeightedUnDirectedGraph(n), true, true, false)
exercise(initWeightedDirectedStaticGraph(n), true, false, true)
exercise(initWeightedUnDirectedStaticGraph(n), true, true, true)
exercise(initUnWeightedDirectedGraph(n), false, false, false)
exercise(initUnWeightedUnDirectedGraph(n), false, true, false)
exercise(initUnWeightedDirectedStaticGraph(n), false, false, true)
exercise(initUnWeightedUnDirectedStaticGraph(n), false, true, true)

block:
    for encoding in 0..<256:
        var g = initWeightedDirectedGraph(2)
        var arcs: seq[Arc]
        var code = encoding
        for u in 0..1:
            for v in 0..1:
                let digit = code mod 4
                code = code div 4
                if digit > 0:
                    let id = g.add_edge(u, v, digit - 1)
                    arcs.add((u, v, digit - 1, id))
        check(g, arcs)

block:
    var rng = initRand(7467)
    for trial in 0..<40:
        let n = rng.rand(1..6)
        var g = initWeightedDirectedGraph(n)
        var arcs: seq[Arc]
        for id in 0..<rng.rand(0..16):
            let u = rng.rand(n - 1)
            let v = rng.rand(n - 1)
            let w = rng.rand(1..5)
            g.add_edge(u, v, w)
            arcs.add((u, v, w, id))
        for s in 0..<n:
            for t in 0..<n:
                var best = infinity
                var used = newSeq[bool](arcs.len)
                var path: seq[int]
                proc visit(u, seen, cost: int) =
                    if u == t:
                        if cost < best:
                            best = cost
                            used.fill(false)
                        if cost == best:
                            for id in path: used[id] = true
                        return
                    for e in arcs:
                        if e.u == u and (seen and (1 shl e.v)) == 0:
                            path.add(e.id)
                            visit(e.v, seen or (1 shl e.v), cost + e.w)
                            path.setLen(path.len - 1)
                visit(s, 1 shl s, 0)
                let answer = g.shortest_path_graph(s, t)
                var actual = newSeq[bool](arcs.len)
                for id in answer.original_edge_ids: actual[id] = true
                doAssert actual == used
                doAssert answer.distance == (if best == infinity: high(int) else: best)

block:
    var g = initWeightedDirectedGraph(3)
    g.add_edge(0, 1, 0)
    g.add_edge(1, 0, 0)
    g.add_edge(0, 2, 1)
    var answer = g.shortest_path_graph(0, 2)
    doAssert answer.original_edge_ids == @[0, 2, 1]
    doAssert g.shortest_path_graph(0, 0).original_edge_ids == @[0, 1]
    doAssert g.shortest_path_graph(2, 2).graph.edge_count == 0
    answer.graph.add_edge(2, 0, 10)
    doAssert g.edge_count == 3
    doAssert g.shortest_path_graph(0, 2).graph.edge_count == 3

template boundary(T: typedesc) =
    block:
        var g = initWeightedDirectedGraph(4, T)
        g.add_edge(0, 1, high(T) - T(2))
        g.add_edge(1, 2, T(1))
        g.add_edge(2, 1, high(T))
        g.add_edge(0, 2, high(T))
        g.add_edge(1, 3, T(2))
        g.add_edge(3, 2, high(T))
        let answer = g.shortest_path_graph(0, 2)
        doAssert answer.distance == high(T) - T(1)
        doAssert answer.original_edge_ids == @[0, 1]
        doAssert g.shortest_path_graph(0, 3).distance == high(T)
        doAssert g.shortest_path_graph(0, 3).graph.edge_count == 0
        doAssert g.shortest_path_graph(0, 2, high(T) - T(1)).graph.edge_count == 0
        g.add_edge(3, 3, low(T))
        var rejected = false
        try: discard g.shortest_path_graph(0, 0)
        except ValueError: rejected = true
        doAssert rejected

boundary(int)
boundary(int8)
boundary(int16)
boundary(int32)
boundary(int64)

template reject(expression: untyped) =
    block:
        var rejected = false
        try: discard expression
        except ValueError: rejected = true
        doAssert rejected

block:
    var empty = initWeightedDirectedGraph(0)
    reject(empty.shortest_path_graph(0, 0))
    var g = initWeightedDirectedStaticGraph(2)
    reject(g.shortest_path_graph(0, 1))
    g.build()
    doAssert g.shortest_path_graph(0, 1).graph.edge_count == 0
    reject(g.shortest_path_graph(-1, 1))
    reject(g.shortest_path_graph(0, 2))
    reject(g.shortest_path_graph(0, 1, 0))
    reject(g.shortest_path_graph(0, 1, low(int)))
    g.add_edge(0, 1, 1)
    reject(g.shortest_path_graph(0, 1))
    g.build()
    g.build()
    doAssert g.shortest_path_graph(0, 1).distance == 1
    var unweighted = initUnWeightedDirectedGraph(2)
    unweighted.add_edge(0, 1)
    doAssert unweighted.shortest_path_graph(0, 1, INF = 1).distance == 1
    doAssert unweighted.shortest_path_graph(0, 1, INF = 1).graph.edge_count == 0
    static:
        doAssert not compiles(initWeightedDirectedGraph(2, float).shortest_path_graph(0, 1))
        doAssert not compiles(initWeightedDirectedGraph(2, uint).shortest_path_graph(0, 1))

block:
    let n = 30_000
    var g = initWeightedDirectedGraph(n)
    for u in 0..<n - 1:
        g.add_edge(u, u + 1, 1)
        g.add_edge(u + 1, u, 1)
    let answer = g.shortest_path_graph(0, n - 1)
    doAssert answer.distance == n - 1
    doAssert answer.graph.edge_count == n - 1
    for id, original in answer.original_edge_ids: doAssert original == id * 2
    var parallel = initWeightedDirectedGraph(2)
    for w in countdown(20_000, 0): parallel.add_edge(0, 1, w)
    doAssert parallel.shortest_path_graph(0, 1).original_edge_ids == @[20_000]

echo "Hello World"
