# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/graph
import cplib/graph/dag_reachable
import cplib/graph/directed_reachable

var comparisons = 0

proc oracle(n: int, edges: seq[(int, int)], queries: seq[(int, int)]): seq[bool] =
    var adjacent = newSeq[seq[int]](n)
    for (a, b) in edges: adjacent[a].add(b)
    for (a, b) in queries:
        var seen = newSeq[bool](n)
        var queue = @[a]
        seen[a] = true
        var head = 0
        while head < queue.len:
            let v = queue[head]
            inc head
            for to in adjacent[v]:
                if not seen[to]:
                    seen[to] = true
                    queue.add(to)
        result.add(seen[b])

proc check(n: int, edges: seq[(int, int)], queries: seq[(int, int)], dag = true) =
    let expected = oracle(n, edges, queries)
    var dynamic = initUnWeightedDirectedGraph(n)
    var stat = initUnWeightedDirectedStaticGraph(n)
    var weighted = initWeightedDirectedGraph(n, int64)
    var weightedStat = initWeightedDirectedStaticGraph(n, int64)
    for i, e in edges:
        dynamic.add_edge(e[0], e[1])
        stat.add_edge(e[0], e[1])
        weighted.add_edge(e[0], e[1], if i mod 2 == 0: low(int64) else: high(int64))
        weightedStat.add_edge(e[0], e[1], -1'i64)
    stat.build()
    weightedStat.build()
    let oldEdges = dynamic.edge_info
    let oldStart = stat.start
    let oldList = stat.elist
    if dag:
        doAssert dynamic.dag_reachable(queries) == expected
        doAssert stat.dag_reachable(queries) == expected
        doAssert weighted.dag_reachable(queries) == expected
        doAssert weightedStat.dag_reachable(queries) == expected
        doAssert dynamic.dag_reachable(queries) == expected
        comparisons += 5 * queries.len
    doAssert dynamic.directed_reachable(queries) == expected
    doAssert stat.directed_reachable(queries) == expected
    comparisons += 2 * queries.len
    doAssert dynamic.edge_info == oldEdges
    doAssert stat.start == oldStart and stat.elist == oldList

check(0, @[], @[])
check(1, @[], @[(0, 0)])
for n in 1..5:
    var possible: seq[(int, int)]
    var queries: seq[(int, int)]
    for a in 0..<n:
        for b in 0..<n:
            queries.add((a, b))
            if a < b: possible.add((a, b))
    for mask in 0..<(1 shl possible.len):
        var edges: seq[(int, int)]
        for i, e in possible:
            if (mask and (1 shl i)) != 0: edges.add(e)
        check(n, edges, queries)

var rng = initRand(437)
for trial in 0..<250:
    let n = rng.rand(1..80)
    var order = newSeq[int](n)
    for i in 0..<n: order[i] = i
    rng.shuffle(order)
    var edges: seq[(int, int)]
    for a in 0..<n:
        for b in a+1..<n:
            if rng.rand(0..9) == 0:
                edges.add((order[a], order[b]))
                if rng.rand(0..3) == 0: edges.add((order[a], order[b]))
    var queries: seq[(int, int)]
    for i in 0..<(trial mod 150): queries.add((rng.rand(n-1), rng.rand(n-1)))
    check(n, edges, queries)

for count in [0, 1, 63, 64, 65, 127, 128, 129, 257]:
    var queries: seq[(int, int)]
    for i in 0..<count:
        queries.add([(0, 3), (3, 0), (2, 2), (4, 0), (1, 3), (0, 4)][i mod 6])
    check(5, @[(0, 2), (0, 1), (1, 3), (2, 3), (0, 2)], queries)

for mask in 0..<(1 shl 9):
    var edges: seq[(int, int)]
    var queries: seq[(int, int)]
    for a in 0..<3:
        for b in 0..<3:
            if (mask and (1 shl (a*3+b))) != 0: edges.add((a, b))
            queries.add((a, b))
    check(3, edges, queries, false)

template rejects(body: untyped) =
    block:
        var rejected = false
        try: body
        except ValueError: rejected = true
        doAssert rejected

for edges in [@[(0, 0)], @[(0, 1), (1, 0)], @[(0, 1), (2, 3), (3, 2)]]:
    var g = initUnWeightedDirectedGraph(4)
    var stat = initWeightedDirectedStaticGraph(4)
    for e in edges:
        g.add_edge(e[0], e[1])
        stat.add_edge(e[0], e[1], 1)
    stat.build()
    rejects: discard g.dag_reachable(newSeq[(int, int)]())
    rejects: discard g.dag_reachable(@[(0, 1)])
    rejects: discard stat.dag_reachable(newSeq[(int, int)]())

var g = initUnWeightedDirectedGraph(2)
for q in [(-1, 0), (0, -1), (2, 0), (0, 2), (low(int), high(int))]:
    rejects: discard g.dag_reachable(@[q])
    rejects: discard g.directed_reachable(@[q])
var empty = initUnWeightedDirectedGraph(0)
rejects: discard empty.dag_reachable(@[(0, 0)])
var unbuilt = initUnWeightedDirectedStaticGraph(0)
rejects: discard unbuilt.dag_reachable(newSeq[(int, int)]())
rejects: discard unbuilt.directed_reachable(newSeq[(int, int)]())
unbuilt.build()
doAssert unbuilt.dag_reachable(newSeq[(int, int)]()).len == 0
var stat = initUnWeightedDirectedStaticGraph(2)
stat.build()
stat.add_edge(0, 1)
rejects: discard stat.dag_reachable(@[(0, 1)])

var chain = initUnWeightedDirectedGraph(100000)
for i in 0..<chain.len-1: chain.add_edge(i, i+1)
var chainQueries: seq[(int, int)]
for i in 0..<1025:
    chainQueries.add(if i mod 2 == 0: (0, chain.len-1) else: (chain.len-1, 0))
let chainAnswer = chain.dag_reachable(chainQueries)
for i, answer in chainAnswer: doAssert answer == (i mod 2 == 0)

let sliced = [(1, 0), (0, 1), (1, 1)]
doAssert g.dag_reachable(sliced.toOpenArray(1, 2)) == @[false, true]
static:
    doAssert not compiles(initUnWeightedUnDirectedGraph(2).dag_reachable(@[(0, 1)]))
    doAssert not compiles(initWeightedUnDirectedGraph(2).dag_reachable(@[(0, 1)]))

stderr.writeLine("dag_reachable oracle comparisons: ", comparisons)
echo "Hello World"
