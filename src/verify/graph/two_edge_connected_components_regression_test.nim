# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/graph
import cplib/graph/lowlink
import cplib/graph/two_edge_connected_components

type Cost = object
    marker: string

proc labels(g: UnDirectedGraph, omitEdge = -1, omitVertex = -1): seq[int] =
    result = newSeq[int](g.len)
    for i in 0..<g.len: result[i] = -1
    var component = 0
    for root in 0..<g.len:
        if root == omitVertex or result[root] != -1: continue
        var queue = @[root]
        result[root] = component
        var head = 0
        while head < queue.len:
            let v = queue[head]
            inc head
            for id, e in g.edge_info:
                if id == omitEdge: continue
                let to = if e.src == v: e.dst elif e.dst == v: e.src else: -1
                if to != -1 and to != omitVertex and result[to] == -1:
                    result[to] = component
                    queue.add(to)
        inc component

proc componentCount(labels: seq[int]): int =
    for x in labels: result = max(result, x+1)

proc check(g: UnDirectedGraph) =
    let ll = initLowLink(g)
    let count = componentCount(labels(g))
    let t = initTwoEdgeConnectedComponents(g)
    let lt = initTwoEdgeConnectedComponents(ll)
    doAssert t.groups == lt.groups
    doAssert t.component == lt.component
    doAssert t.forest.edge_info == lt.forest.edge_info
    var bridges: seq[int]
    for id, e in g.edge_info:
        if componentCount(labels(g, omitEdge=id)) > count: bridges.add(id)
    var connected = newSeq[seq[bool]](g.len)
    for v in 0..<g.len: connected[v] = newSeq[bool](g.len)
    for v in 0..<g.len: connected[v][v] = true
    for id,e in g.edge_info:
        if id notin bridges:
            connected[e.src][e.dst] = true
            connected[e.dst][e.src] = true
    for k in 0..<g.len:
        for i in 0..<g.len:
            for j in 0..<g.len:
                connected[i][j] = connected[i][j] or (connected[i][k] and connected[k][j])
    for i in 0..<g.len:
        for j in 0..<g.len:
            doAssert (t.component[i] == t.component[j]) == connected[i][j]
    doAssert t.forest.edge_info.len == bridges.len

randomize(20261004)
for trial in 0..<200:
    let n = if trial == 0: 0 else: rand(12)
    var a = initUnWeightedUnDirectedGraph(n)
    var b = initUnWeightedUnDirectedStaticGraph(n)
    var c = initWeightedUnDirectedGraph(n,Cost)
    var d = initWeightedUnDirectedStaticGraph(n,Cost)
    if n > 0:
        for _ in 0..<rand(n*n):
            let u = rand(n-1)
            let v = rand(n-1)
            a.add_edge(u,v)
            b.add_edge(u,v)
            c.add_edge(u,v,Cost(marker: "opaque"))
            d.add_edge(u,v,Cost(marker: "opaque"))
    b.build()
    d.build()
    check(a)
    check(b)
    check(c)
    check(d)
echo "Hello World"
