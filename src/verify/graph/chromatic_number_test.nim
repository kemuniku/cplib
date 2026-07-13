import cplib/graph/chromatic_number
import cplib/graph/graph

block:
    var G = initUnWeightedUnDirectedGraph(0)
    doAssert G.chromatic_number() == 0

block:
    var G = initUnWeightedUnDirectedGraph(5)
    doAssert G.chromatic_number() == 1

block:
    var G = initUnWeightedUnDirectedGraph(5)
    for i in 0..<5:
        G.add_edge(i, (i + 1) mod 5)
    doAssert G.chromatic_number() == 3

block:
    var G = initWeightedUnDirectedStaticGraph(4, int)
    for i in 0..<4:
        for j in i + 1..<4:
            G.add_edge(i, j, i + j)
    G.build()
    doAssert G.chromatic_number() == 4
