# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils
import cplib/graph/graph
import cplib/graph/range_edge_graph
import cplib/graph/dijkstra

template checkMixed(init: untyped, weighted: static bool) =
    block:
        var g = init
        var expected = newSeq[seq[(int, int, int)]](7)
        for id in 0..<80:
            let u = (id * 13 + 2) mod 7
            let v = (id * 17) mod 7
            let directed = id < 15 or id mod 3 == 0
            when weighted:
                doAssert g.add_edge_static_impl(u, v, id + 1, directed) == id
            else:
                doAssert g.add_edge_static_impl(u, v, directed) == id
            let cost = when weighted: id + 1 else: 1
            expected[u].add((v, cost, id))
            if not directed: expected[v].add((u, cost, id))
            if id mod 9 == 0 or id == 79:
                g.build()
                for x in 0..<7:
                    doAssert toSeq(g.to_and_cost_and_id(x)) == expected[x]
                g.build()
                for x in 0..<7:
                    doAssert toSeq(g.to_and_cost_and_id(x)) == expected[x]

checkMixed(initWeightedDirectedStaticGraph(7), true)
checkMixed(initUnWeightedUnDirectedStaticGraph(7), false)

block:
    var g = initUnWeightedDirectedStaticGraph(2)
    g.add_edge_static_impl(0, 1, false)
    g.build()
    g.add_edge_static_impl(0, 0, true)
    g.add_edge_static_impl(1, 1, false)
    g.build()
    doAssert toSeq(g.to_and_id(0)) == @[(1, 0), (0, 1)]
    doAssert toSeq(g.to_and_id(1)) == @[(0, 0), (1, 2), (1, 2)]

template checkReserve(init: untyped, weighted, undirected: static bool) =
    block:
        var g = init
        g.reserve(20, [8, 8, 8])
        when weighted:
            g.add_edge(0, 0, 7)
            g.add_edge(0, 1, 9)
        else:
            g.add_edge(0, 0)
            g.add_edge(0, 1)
        let before = toSeq(g.to_and_cost_and_id(0))
        g.reserve(30, [12, 12, 12])
        g.reserve(0, [0, 0, 0])
        doAssert toSeq(g.to_and_cost_and_id(0)) == before
        when weighted: doAssert g.add_edge(1, 2, 11) == 2
        else: doAssert g.add_edge(1, 2) == 2
        doAssert toSeq(g.to_and_id(1)) == (when undirected: @[(0, 1), (2, 2)] else: @[(2, 2)])
        doAssert g.get_edge(0).src == 0
        doAssert g.get_edge(2).dst == 2
        doAssert g.edge_count == 3
        g.reserve(40)
        doAssert toSeq(g.to_and_cost_and_id(0)) == before

checkReserve(initWeightedDirectedGraph(3, capacity = 4), true, false)
checkReserve(initWeightedUnDirectedGraph(3, capacity = 4), true, true)
checkReserve(initUnWeightedDirectedGraph(3, capacity = 4), false, false)
checkReserve(initUnWeightedUnDirectedGraph(3, capacity = 4), false, true)

block:
    var dynamic = initWeightedUnDirectedGraph(2, seq[int], capacity = 3)
    dynamic.add_edge(0, 1, @[3, 5])
    dynamic.reserve(10, [10, 10])
    dynamic.add_edge(0, 0, @[7])
    doAssert toSeq(dynamic.to_and_cost_and_id(0)) == @[(1, @[3, 5], 0), (0, @[7], 1), (0, @[7], 1)]
    var fixed = initWeightedDirectedStaticGraph(2, seq[int])
    fixed.add_edge_static_impl(0, 1, @[3, 5], false)
    fixed.add_edge_static_impl(1, 1, @[7], true)
    fixed.build()
    fixed.build()
    doAssert toSeq(fixed.to_and_cost_and_id(1)) == @[(0, @[3, 5], 0), (1, @[7], 1)]

block:
    var g = initWeightedRangeGraph(4)
    g.add_range_to_range_edge(0, 2, 2, 4, 7)
    g.add_point_to_point_edge(0, 1, 3)
    doAssert g.graph.dijkstra(0)[0..<4] == @[0, 3, 7, 7]
    for u in 0..<g.len:
        for (v, cost, id) in g.graph.to_and_cost_and_id(u):
            doAssert g.graph.get_edge(id) == EdgeInfo[int](src: u, dst: v, cost: cost)

echo "Hello World"
