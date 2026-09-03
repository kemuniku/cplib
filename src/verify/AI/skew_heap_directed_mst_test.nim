import cplib/collections/skew_heap
import cplib/graph/[directed_mst, graph]
import cplib/utils/constants

block skewHeap:
    var a = initSkewHeap[int, int]()
    var b = initSkewHeap[int, int]()
    for x in [5, 1, 8]: a.push(x)
    for x in [4, 2]: b.push(x)
    b.addAll(-3)
    a.meld(b)
    assert b.isEmpty
    var got: seq[int]
    while not a.isEmpty: got.add(a.pop())
    assert got == @[-1, 1, 1, 5, 8]

block directedMst:
    var g = initWeightedDirectedGraph(4)
    g.add_edge(0, 1, 10)
    g.add_edge(0, 2, 10)
    g.add_edge(1, 2, 1)
    g.add_edge(2, 1, 1)
    g.add_edge(1, 3, 2)
    g.add_edge(2, 3, 3)
    let mstCost = g.directedMstCost(0)
    assert mstCost == 13

    var disconnected = initWeightedDirectedGraph(2)
    assert disconnected.directedMstCost(0) == INF64

block staticGraph:
    var g = initWeightedDirectedStaticGraph(3)
    g.add_edge(0, 1, 4)
    g.add_edge(1, 2, -2)
    g.add_edge(0, 2, 5)
    g.build()
    assert g.directedMstCost(0) == 2

block genericWeights:
    var g = initWeightedDirectedGraph(2, float)
    g.add_edge(0, 1, 1.5)
    assert g.directedMstCost(0) == 1.5
