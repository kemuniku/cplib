# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/tsp
import cplib/utils/constants

for floydwarshall in [false, true]:
    block:
        var g = initWeightedDirectedGraph(2)
        g.add_edge(0, 1, 1)
        let dist = g.to_adjacency_matrix()
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == 1
        doAssert tspPathCostFromTo(dist, 1, 0, floydwarshall) == INF64
        doAssert tspPathCostFromTo(dist, 0, 0, floydwarshall) == INF64

    block:
        var g = initWeightedDirectedGraph(2)
        g.add_edge(0, 1, 1)
        g.add_edge(1, 0, 1)
        let dist = g.to_adjacency_matrix()
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == 1
        doAssert tspPathCostFromTo(dist, 0, 0, floydwarshall) == 2

    block:
        var g = initWeightedDirectedGraph(1)
        doAssert tspPathCostFromTo(g.to_adjacency_matrix(), 0, 0, floydwarshall) == 0
        g.add_edge(0, 0, 7)
        doAssert tspPathCostFromTo(g.to_adjacency_matrix(), 0, 0, floydwarshall) == 0

    block:
        let dist = @[@[0, 1, 4], @[1, 0, 2], @[4, 2, 0]]
        doAssert tspPathCostFromTo(dist, 0, 2, floydwarshall) == 3
        doAssert tspPathCostFromTo(dist, 0, 0, floydwarshall) ==
            (if floydwarshall: 6 else: 7)

    block:
        let dist = @[@[9, 1], @[1, 9]]
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == 1
        doAssert tspPathCostFromTo(dist, 0, 0, floydwarshall) == 2

    block:
        let dist = @[@[INF64, 1, INF64], @[INF64, INF64, INF64],
                     @[INF64, INF64, INF64]]
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == INF64

    block:
        let dist = @[@[INF32, 1'i32], @[INF32, INF32]]
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == 1'i32

    block:
        let dist = @[@[1e100, 1.0], @[1e100, 1e100]]
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == 1.0

    block:
        let dist = @[@[1e30'f32, 1.0'f32], @[1e30'f32, 1e30'f32]]
        doAssert tspPathCostFromTo(dist, 0, 1, floydwarshall) == 1.0'f32

    block:
        let dist = @[@[1000'i64, 1'i64], @[1000'i64, 1000'i64]]
        doAssert tspPathCostFromTo(dist, 0, 1, 0'i64, 1000'i64, floydwarshall) == 1'i64

echo "Hello World"
