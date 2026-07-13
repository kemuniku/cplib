# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/graph
import cplib/graph/eulerian_path

block directed_path:
    var g = initUnWeightedDirectedGraph(4)
    g.add_edge(0, 1)
    g.add_edge(1, 2)
    g.add_edge(2, 0)
    g.add_edge(0, 3)
    assert g.eulerian_path == @[0, 1, 2, 0, 3]
    assert g.eulerian_path(1).len == 0

block undirected_parallel_edges_and_loop:
    var g = initWeightedUnDirectedGraph(2, int)
    g.add_edge(0, 1, 10)
    g.add_edge(0, 1, 20)
    g.add_edge(0, 0, 30)
    let path = g.eulerian_path
    assert path.len == 4
    assert path[0] == path[^1]

block disconnected:
    var g = initUnWeightedUnDirectedGraph(4)
    g.add_edge(0, 1)
    g.add_edge(2, 3)
    assert g.eulerian_path.len == 0

block directed_static:
    var g = initWeightedDirectedStaticGraph(3, int)
    g.add_edge(0, 1, 4)
    g.add_edge(1, 2, 5)
    g.build()
    assert g.eulerian_trail == @[0, 1, 2]

block undirected_static_self_loop:
    var g = initUnWeightedUnDirectedStaticGraph(2)
    g.add_edge(0, 0)
    g.add_edge(0, 1)
    g.build()
    assert g.eulerian_path == @[0, 0, 1]

block no_edges:
    var g = initUnWeightedDirectedGraph(2)
    assert g.eulerian_path == @[0]
    assert g.eulerian_path(1) == @[1]
