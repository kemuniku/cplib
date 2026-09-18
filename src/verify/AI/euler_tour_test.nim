# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/graph
import cplib/graph/euler_tour

proc existsWalk(g: DirectedGraph or UnDirectedGraph, start: int, closed: bool): bool =
    var used = newSeq[bool](g.edge_count)
    proc dfs(v, root, count: int): bool =
        if count == g.edge_count: return not closed or v == root
        for (dst, id) in g.to_and_id(v):
            if used[id]: continue
            used[id] = true
            if dfs(dst, root, count + 1): return true
            used[id] = false
    if start != -1: return dfs(start, start, 0)
    for root in 0..<g.len:
        if dfs(root, root, 0): return true

proc validWalk(g: DirectedGraph or UnDirectedGraph, path: seq[int], start: int, closed: bool): bool =
    if path.len != g.edge_count: return false
    var used = newSeq[bool](g.edge_count)
    for id in path:
        if id < 0 or id >= g.edge_count or used[id]: return false
        used[id] = true
    for root in 0..<g.len:
        if start != -1 and root != start: continue
        var v = root
        var valid = true
        for id in path:
            let e = g.get_edge(id)
            if e.src == v:
                v = e.dst
            else:
                when g is UnDirectedGraph:
                    if e.dst == v: v = e.src
                    else: valid = false
                else:
                    valid = false
            if not valid: break
        if valid and (not closed or v == root): return true

proc check(g: DirectedGraph or UnDirectedGraph) =
    when g is StaticGraphTypes: g.build()
    let before = g.edge_info
    for start in -1..<g.len:
        for closed in [false, true]:
            let path = if closed: g.euler_tour(start) else: g.euler_trail(start)
            if g.edge_count == 0:
                doAssert path.len == 0
            else:
                let exists = existsWalk(g, start, closed)
                doAssert (path.len > 0) == exists
                if exists: doAssert validWalk(g, path, start, closed)
            doAssert g.edge_info == before
            doAssert path == (if closed: g.euler_tour(start) else: g.euler_trail(start))

template checkGraphs(init: untyped) =
    block:
        var rng = initRand(91725)
        for iteration in 0..<300:
            var g = init
            for i in 0..<rng.rand(0..7):
                let u = rng.rand(0..<g.len)
                let v = rng.rand(0..<g.len)
                when g is WeightedGraph: g.add_edge(u, v, -i)
                else: g.add_edge(u, v)
            check(g)

checkGraphs(initUnWeightedDirectedGraph(4))
checkGraphs(initUnWeightedUnDirectedGraph(4))
checkGraphs(initWeightedDirectedGraph(4))
checkGraphs(initWeightedUnDirectedGraph(4))
checkGraphs(initUnWeightedDirectedStaticGraph(4))
checkGraphs(initUnWeightedUnDirectedStaticGraph(4))
checkGraphs(initWeightedDirectedStaticGraph(4))
checkGraphs(initWeightedUnDirectedStaticGraph(4))
check(initUnWeightedDirectedGraph(0))
check(initUnWeightedUnDirectedStaticGraph(0))

block:
    var g = initUnWeightedUnDirectedGraph(5)
    g.add_edge(1, 2)
    g.add_edge(1, 2)
    g.add_edge(2, 2)
    check(g)
    g.add_edge(3, 4)
    g.add_edge(3, 4)
    check(g)

block:
    var g = initUnWeightedDirectedGraph(4)
    g.add_edge(0, 1)
    g.add_edge(1, 0)
    g.add_edge(2, 3)
    g.add_edge(3, 2)
    check(g)

block:
    const n = 100000
    var g = initUnWeightedDirectedGraph(n)
    for v in 0..<n - 1: g.add_edge(v, v + 1)
    let path = g.euler_trail()
    doAssert path.len == n - 1
    for id in 0..<path.len: doAssert path[id] == id
    doAssert g.euler_tour().len == 0
    g.add_edge(n - 1, 0)
    doAssert g.euler_tour().len == n

echo "Hello World"
