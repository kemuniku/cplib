# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/lower_bound_maxflow
import std/[algorithm, random]

block feasible:
    var graph = init_lower_bound_maxflow[int](4)
    discard graph.add_edge(0, 1, 1, 3)
    discard graph.add_edge(0, 2, 0, 2)
    discard graph.add_edge(1, 2, 1, 2)
    discard graph.add_edge(1, 3, 0, 2)
    discard graph.add_edge(2, 3, 1, 4)
    let answer = graph.flow(0, 3)
    assert answer == (true, 5)
    var balance = newSeq[int](4)
    for edge in graph.edges():
        assert edge.flow in edge.lower..edge.upper
        balance[edge.src] -= edge.flow
        balance[edge.dst] += edge.flow
    assert balance == @[-5, 0, 0, 5]

block infeasible:
    var graph = init_lower_bound_maxflow[int](3)
    discard graph.add_edge(0, 1, 2, 2)
    discard graph.add_edge(1, 2, 0, 1)
    assert graph.flow(0, 2).feasible == false

block parallelAndSelfLoop:
    var graph = init_lower_bound_maxflow[int](2)
    let a = graph.add_edge(0, 0, 2, 4)
    discard graph.add_edge(0, 1, 1, 2)
    discard graph.add_edge(0, 1, 2, 5)
    assert graph.flow(0, 1) == (true, 7)
    assert graph.get_edge(a).flow == 2

block randomAgainstBruteForce:
    randomize(20260713)
    for _ in 0..<300:
        let n = rand(2..5)
        let m = rand(0..7)
        var input: seq[tuple[src, dst, lower, upper: int]]
        var graph = init_lower_bound_maxflow[int](n)
        for _ in 0..<m:
            let src = rand(0..<n)
            let dst = rand(0..<n)
            let lower = rand(0..2)
            let upper = rand(lower..3)
            input.add((src, dst, lower, upper))
            discard graph.add_edge(src, dst, lower, upper)

        var balance = newSeq[int](n)
        var bruteFeasible = false
        var bruteAnswer = 0
        proc dfs(i: int) =
            if i == m:
                for v in 1..<n - 1:
                    if balance[v] != 0:
                        return
                let value = -balance[0]
                if value >= 0 and balance[n - 1] == value:
                    if not bruteFeasible or value > bruteAnswer:
                        bruteFeasible = true
                        bruteAnswer = value
                return
            let edge = input[i]
            for flow in edge.lower..edge.upper:
                balance[edge.src] -= flow
                balance[edge.dst] += flow
                dfs(i + 1)
                balance[edge.src] += flow
                balance[edge.dst] -= flow
        dfs(0)

        let answer = graph.flow(0, n - 1)
        assert answer.feasible == bruteFeasible
        if answer.feasible:
            assert answer.value == bruteAnswer
            balance.fill(0)
            for edge in graph.edges():
                assert edge.flow in edge.lower..edge.upper
                balance[edge.src] -= edge.flow
                balance[edge.dst] += edge.flow
            for v in 1..<n - 1:
                assert balance[v] == 0
            assert -balance[0] == answer.value
            assert balance[n - 1] == answer.value
