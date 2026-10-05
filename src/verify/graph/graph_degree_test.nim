# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import random

template checkGraph(init: untyped, weighted, undirected, isStatic: static bool) =
    block:
        for vertexCount in 0..8:
            let n {.inject.} = vertexCount
            var g = init
            var counts = newSeq[seq[int]](n)
            for row in 0..<n: counts[row] = newSeq[int](n)
            when isStatic:
                when compileOption("assertions"):
                    var rejected = false
                    try:
                        when undirected: discard g.degree(0)
                        else: discard g.in_degrees()
                    except AssertionDefect: rejected = true
                    doAssert rejected
                g.build()
            when undirected:
                static:
                    doAssert not compiles(g.out_degree(0))
                    doAssert not compiles(g.in_degrees())
            else:
                static: doAssert not compiles(g.degree(0))

            template check() =
                block:
                    var total = 0
                    when not undirected:
                        var expectedIn = newSeq[int](n)
                        for dst in 0..<n:
                            for src in 0..<n: expectedIn[dst] += counts[src][dst]
                        let incoming = g.in_degrees()
                        doAssert incoming == expectedIn
                        var changed = g.in_degrees()
                        if n > 0: changed[0] = -1
                        doAssert g.in_degrees() == expectedIn
                    for v in 0..<n:
                        var expected = 0
                        for dst in 0..<n:
                            expected += counts[v][dst]
                            when undirected: expected += counts[dst][v]
                        let actual = when undirected: g.degree(v) else: g.out_degree(v)
                        doAssert actual == expected
                        total += actual
                    doAssert total == g.edge_count * (when undirected: 2 else: 1)
                    when isStatic:
                        g.build()
                        for v in 0..<n:
                            var expected = 0
                            for dst in 0..<n:
                                expected += counts[v][dst]
                                when undirected: expected += counts[dst][v]
                            when undirected: doAssert g.degree(v) == expected
                            else: doAssert g.out_degree(v) == expected
            check()
            for round in 0..<3:
                for u in 0..<n:
                    for v in 0..<n:
                        when weighted: g.add_edge(u, v, float(round - u + v))
                        else: g.add_edge(u, v)
                        inc counts[u][v]
                        when isStatic:
                            when compileOption("assertions"):
                                var rejected = false
                                try:
                                    when undirected: discard g.degree(u)
                                    else: discard g.out_degree(u)
                                except AssertionDefect: rejected = true
                                doAssert rejected
                                when not undirected:
                                    rejected = false
                                    try: discard g.in_degrees()
                                    except AssertionDefect: rejected = true
                                    doAssert rejected
                            g.build()
                        check()
            if n > 0:
                var rng = initRand(411 + n)
                for i in 0..<128:
                    let u = rng.rand(n - 1)
                    let v = rng.rand(n - 1)
                    when weighted: g.add_edge(u, v, float(i - 64))
                    else: g.add_edge(u, v)
                    inc counts[u][v]
                    when isStatic: g.build()
                    check()
            when not isStatic:
                g.reserve(g.edge_count + 100)
                check()

checkGraph(initWeightedDirectedGraph(n, float), true, false, false)
checkGraph(initWeightedUnDirectedGraph(n, float), true, true, false)
checkGraph(initUnWeightedDirectedGraph(n), false, false, false)
checkGraph(initUnWeightedUnDirectedGraph(n), false, true, false)
checkGraph(initWeightedDirectedStaticGraph(n, float), true, false, true)
checkGraph(initWeightedUnDirectedStaticGraph(n, float), true, true, true)
checkGraph(initUnWeightedDirectedStaticGraph(n), false, false, true)
checkGraph(initUnWeightedUnDirectedStaticGraph(n), false, true, true)

block:
    var g = initUnWeightedUnDirectedGraph(100001)
    for v in 1..<g.len: g.add_edge(0, v)
    g.add_edge(0, 0)
    doAssert g.degree(0) == 100002
    doAssert g.degree(100000) == 1
    var directed = initWeightedDirectedStaticGraph(100001, string)
    for v in 1..<directed.len: directed.add_edge(v, 0, "edge")
    directed.add_edge(0, 0, "loop")
    directed.build()
    doAssert directed.out_degree(0) == 1
    doAssert directed.out_degree(100000) == 1
    let incoming = directed.in_degrees()
    doAssert incoming[0] == 100001
    for v in 1..<directed.len: doAssert incoming[v] == 0

echo "Hello World"
