# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import algorithm, random, sequtils
import cplib/graph/graph
import cplib/graph/lowlink
import cplib/graph/two_edge_connected_components
import cplib/graph/biconnected_components
import cplib/graph/block_cut_tree

type Edge = (int, int)

proc labels(n: int, edges: seq[Edge], removedVertex = -1, removedEdge = -1,
            mask = -1): seq[int] =
    result = newSeqWith(n, -1)
    for s in 0..<n:
        if s == removedVertex or (mask and (1 shl s)) == 0 or result[s] != -1: continue
        result[s] = s
        var stack = @[s]
        while stack.len > 0:
            let v = stack.pop()
            for i, e in edges:
                if i == removedEdge: continue
                var to = -1
                if e[0] == v: to = e[1]
                elif e[1] == v: to = e[0]
                if to < 0 or to == removedVertex or (mask and (1 shl to)) == 0: continue
                if result[to] == -1:
                    result[to] = s
                    stack.add(to)

proc countComponents(a: seq[int]): int =
    for v, c in a:
        if v == c: inc result

proc check(n: int, edges: seq[Edge]) =
    var g = initUnWeightedUnDirectedGraph(n)
    var sg = initUnWeightedUnDirectedStaticGraph(n)
    var wg = initWeightedUnDirectedGraph(n, float)
    var swg = initWeightedUnDirectedStaticGraph(n, float)
    for e in edges:
        g.add_edge(e[0], e[1])
        sg.add_edge(e[0], e[1])
        wg.add_edge(e[0], e[1], 2.5)
        swg.add_edge(e[0], e[1], -1.5)
    sg.build()
    swg.build()
    let ll = initLowLink(g)
    doAssert ll == initLowLink(sg)
    doAssert ll == initLowLink(wg)
    doAssert ll == initLowLink(swg)
    let base = labels(n, edges)
    let components = countComponents(base)
    for v in 0..<n:
        doAssert ll.is_articulation[v] == (countComponents(labels(n, edges, v)) > components)
    var bridges: seq[Edge]
    var cutLabels: seq[seq[int]]
    for i, e in edges:
        let after = labels(n, edges, removedEdge = i)
        cutLabels.add(after)
        if countComponents(after) > components:
            bridges.add((min(e[0], e[1]), max(e[0], e[1])))
    var actualBridges: seq[Edge]
    for e in ll.bridges: actualBridges.add((min(e[0], e[1]), max(e[0], e[1])))
    bridges.sort()
    actualBridges.sort()
    doAssert actualBridges == bridges
    let te = initTwoEdgeConnectedComponents(ll)
    doAssert te.groups == initTwoEdgeConnectedComponents(swg).groups
    for u in 0..<n:
        doAssert u in te.groups[te.component[u]]
        for v in 0..<n:
            var same = base[u] == base[v]
            for a in cutLabels: same = same and a[u] == a[v]
            doAssert (te.component[u] == te.component[v]) == same
    var forestEdges = 0
    for v in 0..<te.forest.len:
        for to in te.forest[v]: inc forestEdges
    doAssert forestEdges == 2 * bridges.len
    doAssert te.forest.len - forestEdges div 2 == components
    let bc = initBiconnectedComponents(ll)
    doAssert bc.groups == initBiconnectedComponents(wg).groups
    var valid: seq[int]
    for mask in 1..<(1 shl n):
        if countComponents(labels(n, edges, mask = mask)) != 1: continue
        var ok = true
        for v in 0..<n:
            if (mask and (1 shl v)) != 0:
                if countComponents(labels(n, edges, v, mask = mask)) > 1: ok = false
        if ok: valid.add(mask)
    var expected: seq[int]
    for mask in valid:
        var maximal = true
        for other in valid:
            if mask != other and (mask and other) == mask: maximal = false
        if maximal: expected.add(mask)
    var actual: seq[int]
    for id, group in bc.groups:
        var mask = 0
        for v in group:
            doAssert (mask and (1 shl v)) == 0
            mask = mask or (1 shl v)
            doAssert id in bc.belong[v]
        actual.add(mask)
    actual.sort()
    expected.sort()
    doAssert actual == expected
    let tree = initBlockCutTree(bc)
    doAssert tree.id == initBlockCutTree(sg).id
    var treeEdges: seq[Edge]
    for u in 0..<tree.forest.len:
        for v in tree.forest[u]:
            if u < v: treeEdges.add((u, v))
    doAssert countComponents(labels(tree.forest.len, treeEdges)) == components
    doAssert treeEdges.len == tree.forest.len - components
    for v in 0..<n:
        if ll.is_articulation[v]:
            doAssert tree.id[v] >= bc.groups.len
            doAssert tree.articulation[tree.id[v] - bc.groups.len] == v
            var adj = toSeq(tree.forest[tree.id[v]])
            adj.sort()
            var belong = bc.belong[v]
            belong.sort()
            doAssert adj == belong
        else:
            doAssert bc.belong[v].len == 1
            doAssert tree.id[v] == bc.belong[v][0]

check(0, @[])
for n in 1..5:
    var possible: seq[Edge]
    for u in 0..<n:
        for v in u+1..<n: possible.add((u, v))
    for mask in 0..<(1 shl possible.len):
        var edges: seq[Edge]
        for i, e in possible:
            if (mask and (1 shl i)) != 0: edges.add(e)
        check(n, edges)
var rng = initRand(20260912)
for trial in 0..<300:
    let n = rng.rand(1..7)
    var edges: seq[Edge]
    for i in 0..<rng.rand(0..20): edges.add((rng.rand(n-1), rng.rand(n-1)))
    check(n, edges)

block:
    const n = 200000
    var g = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n: g.add_edge(v-1, v)
    let ll = initLowLink(g)
    doAssert ll.bridges.len == n-1
    doAssert ll.articulation.len == n-2
    doAssert initTwoEdgeConnectedComponents(ll).groups.len == n
    let bc = initBiconnectedComponents(ll)
    doAssert bc.groups.len == n-1
    doAssert initBlockCutTree(bc).forest.len == 2*n-3

echo "Hello World"
