# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, sequtils
import cplib/graph/graph
import cplib/graph/count_topologicalsort

proc bruteCount(g: UnWeightedDirectedGraph): int64 =
    var order = toSeq(0..<g.len)
    while true:
        var pos = newSeq[int](g.len)
        for i, v in order:
            pos[v] = i
        var valid = true
        for u in 0..<g.len:
            for v in g[u]:
                if pos[u] >= pos[v]:
                    valid = false
        if valid:
            inc result
        if not order.nextPermutation():
            break

proc checkTypes(n: int, edges: openArray[(int, int)], expected: int64) =
    var g = initUnWeightedDirectedGraph(n)
    var sg = initUnWeightedDirectedStaticGraph(n)
    var wg = initWeightedDirectedGraph(n, float)
    var swg = initWeightedDirectedStaticGraph(n, int64)
    for (u, v) in edges:
        g.add_edge(u, v)
        sg.add_edge(u, v)
        wg.add_edge(u, v, -0.5)
        swg.add_edge(u, v, -10'i64)
    sg.build()
    swg.build()
    doAssert g.count_topologicalsort() == expected
    doAssert sg.count_topologicalsort() == expected
    doAssert wg.count_topologicalsort() == expected
    doAssert swg.count_topologicalsort() == expected

checkTypes(0, [], 1)
checkTypes(1, [], 1)
checkTypes(5, [], 120)
checkTypes(4, [(0, 1), (1, 2), (2, 3)], 1)
checkTypes(4, [(0, 1), (0, 2), (1, 3), (2, 3)], 2)
checkTypes(4, [(0, 1), (2, 3)], 6)
checkTypes(3, [(0, 1), (0, 1)], 3)
checkTypes(1, [(0, 0)], 0)
checkTypes(4, [(0, 1), (1, 0)], 0)
checkTypes(3, [(0, 1), (1, 2), (2, 0)], 0)

for n in 0..4:
    var possible: seq[(int, int)]
    for u in 0..<n:
        for v in 0..<n:
            if u != v:
                possible.add((u, v))
    for mask in 0..<(1 shl possible.len):
        var g = initUnWeightedDirectedGraph(n)
        for i, edge in possible:
            if (mask and (1 shl i)) != 0:
                g.add_edge(edge[0], edge[1])
        doAssert g.count_topologicalsort() == bruteCount(g)

doAssert initUnWeightedDirectedGraph(20).count_topologicalsort() == 2432902008176640000'i64
echo "Hello World"
