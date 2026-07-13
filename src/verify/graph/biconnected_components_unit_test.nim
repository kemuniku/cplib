# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/lowlink
import cplib/graph/two_edge_connected_components
import cplib/graph/biconnected_components
import cplib/graph/block_cut_tree
import algorithm, strutils

proc normalize(a: seq[seq[int]]): seq[string] =
    for item in a:
        var x = item
        x.sort()
        result.add(x.join(","))
    result.sort()

proc normalize(a: seq[(int, int)]): seq[string] =
    for (u, v) in a:
        result.add(@[u, v].sorted.join(","))
    result.sort()

block dynamicGraph:
    # triangle - bridge - triangle, plus an isolated vertex
    var g = initUnWeightedUnDirectedGraph(8)
    for (u, v) in @[(0, 1), (1, 2), (2, 0), (2, 3),
                    (3, 4), (4, 5), (5, 3), (3, 6)]:
        g.add_edge(u, v)

    let ll = initLowLink(g)
    assert ll.bridges.normalize == @[@[2, 3], @[3, 6]].normalize
    assert ll.articulationPoints.sorted == @[2, 3]
    assert twoEdgeConnectedComponents(g).normalize ==
        @[@[0, 1, 2], @[3, 4, 5], @[6], @[7]].normalize
    assert biconnectedComponents(g).normalize ==
        @[@[0, 1, 2], @[2, 3], @[3, 4, 5], @[3, 6], @[7]].normalize

    let bct = initBlockCutTree(g)
    assert bct.tree.len == 7
    assert bct.articulationNode[2] != -1
    assert bct.articulationNode[3] != -1
    assert bct.vertexNode[7] != -1

block staticMultigraph:
    var g = initUnWeightedUnDirectedStaticGraph(3)
    g.add_edge(0, 1)
    g.add_edge(0, 1)
    g.add_edge(1, 2)
    g.build()
    assert initLowLink(g).bridges.normalize == @[@[1, 2]].normalize
    assert twoEdgeConnectedComponents(g).normalize == @[@[0, 1], @[2]].normalize
    assert biconnectedComponents(g).normalize == @[@[0, 1], @[1, 2]].normalize

echo "Hello World"
