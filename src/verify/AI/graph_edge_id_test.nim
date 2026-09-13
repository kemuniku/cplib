# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import sequtils
import cplib/graph/graph
import cplib/graph/reverse_edge
import cplib/graph/dijkstra
import cplib/graph/bellmanford
import cplib/graph/maxk_dijkstra
import cplib/graph/warshall_floyd
import cplib/graph/steiner_tree
import cplib/graph/k_shortest_walk
import cplib/utils/constants

template checkGraph(init: untyped, weighted, undirected, isStatic: static bool) =
    block:
        var g = init
        template add(u, v, c: int): int =
            when weighted: g.add_edge(u, v, c)
            else: g.add_edge(u, v)
        assert add(2, 0, 5) == 0
        assert add(0, 1, 7) == 1
        assert add(0, 1, 9) == 2
        assert add(0, 0, 11) == 3
        assert g.edge_count == 4
        assert g.get_edge(0).src == 2
        assert g.get_edge(0).dst == 0
        when weighted:
            assert g.get_edge(0).cost == 5
        else:
            static: doAssert not compiles(g.edge_info[0].cost)
            static: doAssert sizeof(EdgeInfo[void]) == 2 * sizeof(int)
        when isStatic: g.build()
        let expected = when undirected: @[(2, 0), (1, 1), (1, 2), (0, 3), (0, 3)]
                       else: @[(1, 1), (1, 2), (0, 3)]
        assert toSeq(g.to_and_id(0)) == expected
        for (dst, cost, id) in g.to_and_cost_and_id(0):
            assert (dst, id) in expected
            when weighted: assert cost == g.get_edge(id).cost
            else: assert cost == 1
        when isStatic:
            g.build()
            assert toSeq(g.to_and_id(0)) == expected
        assert add(1, 2, 13) == 4
        when isStatic:
            var rejected = false
            try: discard toSeq(g.to_and_id(0))
            except AssertionDefect: rejected = true
            assert rejected
            g.build()
        assert toSeq(g.to_and_id(0)) == expected
        when not undirected:
            let reversed = g.reverse_edge()
            for id in 0..<g.edge_count:
                assert reversed.get_edge(id).src == g.get_edge(id).dst
                assert reversed.get_edge(id).dst == g.get_edge(id).src
            assert toSeq(reversed.to_and_id(0)) == @[(2, 0), (0, 3)]

checkGraph(initWeightedDirectedGraph(3), true, false, false)
checkGraph(initWeightedUnDirectedGraph(3), true, true, false)
checkGraph(initUnWeightedDirectedGraph(3), false, false, false)
checkGraph(initUnWeightedUnDirectedGraph(3), false, true, false)
checkGraph(initWeightedDirectedStaticGraph(3, capacity = 1), true, false, true)
checkGraph(initWeightedUnDirectedStaticGraph(3), true, true, true)
checkGraph(initUnWeightedDirectedStaticGraph(3), false, false, true)
checkGraph(initUnWeightedUnDirectedStaticGraph(3), false, true, true)

template checkAlgorithms(init: untyped, isStatic: static bool) =
    block:
        var g = init
        g.add_edge(0, 1)
        g.add_edge(1, 2)
        when isStatic: g.build()
        assert g.dijkstra(0) == @[0, 1, 2]
        assert g.bellmanford(0) == @[0, 1, 2]
        assert g.maxk_dijkstra(0, 2) == @[0, 1, 2]
        assert g.shortest_path_dijkstra(0, 2).cost == 2
        assert g.shortest_path_bellmanford(0, 2).cost == 2
        assert g.shortest_path_maxk_dijkstra(0, 2, 2).cost == 2
        assert g.warshall_floyd().d[0][2] == 2
        assert g.k_shortest_walk(0, 2, 2) == @[2, INF64]

checkAlgorithms(initUnWeightedDirectedGraph(3), false)
checkAlgorithms(initUnWeightedDirectedStaticGraph(3), true)

var empty = initUnWeightedUnDirectedStaticGraph(0)
empty.build()
empty.build()
assert empty.edge_count == 0
assert empty.len == 0
var isolated = initUnWeightedDirectedStaticGraph(2)
isolated.build()
assert toSeq(isolated[0]).len == 0

var tableGraph = initWeightedUnDirectedTableGraph(@["a", "b"], float)
assert tableGraph.add_edge("a", "b", 1.5) == 0
assert toSeq(tableGraph.to_and_id("b")) == @[("a", 0)]
assert toSeq(tableGraph.to_and_cost_and_id("a")) == @[("b", 1.5, 0)]
var unweightedTableGraph = initUnWeightedDirectedTableGraph(@["a", "b"])
assert unweightedTableGraph.add_edge("a", "b") == 0
assert toSeq(unweightedTableGraph.to_and_id("a")) == @[("b", 0)]
echo "Hello World"

var tree = initUnWeightedUnDirectedGraph(3)
tree.add_edge(0, 1)
tree.add_edge(1, 2)
assert tree.steiner_tree_mincost(@[0, 2]) == 2
