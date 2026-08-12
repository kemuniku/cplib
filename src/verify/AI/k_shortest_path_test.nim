# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/[graph, k_shortest_path]

block dynamicGraph:
    var g = initWeightedDirectedGraph(4)
    g.add_edge(0, 1, 1)
    g.add_edge(0, 1, 2) # A parallel edge is a different walk.
    g.add_edge(1, 3, 2)
    g.add_edge(0, 2, 2)
    g.add_edge(2, 3, 2)
    g.add_edge(1, 1, 2) # Cyclic walks are included.

    assert g.k_shortest_path(0, 3, 6) == @[3, 4, 4, 5, 6, 7]
    assert g.k_shortest_path(0, 3, 0) == @[]
    assert g.k_shortest_path(3, 0, 3) == @[]
    assert g.k_shortest_path(0, 0, 2) == @[0]

block staticGraph:
    var g = initWeightedDirectedStaticGraph(3, float)
    g.add_edge(0, 1, 0.5)
    g.add_edge(1, 2, 1.25)
    g.add_edge(0, 2, 2.0)
    g.add_edge(1, 1, 1.0)
    g.build()

    assert g.k_shortest_path(0, 2, 4) == @[1.75, 2.0, 2.75, 3.75]

block int32Graph:
    var g = initWeightedDirectedGraph(2, int32)
    g.add_edge(0, 1, 3i32)
    assert g.k_shortest_path(0, 1, 2) == @[3i32]
