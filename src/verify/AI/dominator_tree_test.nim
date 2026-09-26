# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/graph/graph
import cplib/graph/dominator_tree
import random, sequtils

proc reachableWithout(adj: seq[seq[int]], root, removed: int): seq[bool] =
    result = newSeq[bool](adj.len)
    if root == removed: return
    result[root] = true
    var stack = @[root]
    while stack.len > 0:
        let v = stack.pop()
        for u in adj[v]:
            if u != removed and not result[u]:
                result[u] = true
                stack.add(u)

proc brute(adj: seq[seq[int]], root: int): seq[int] =
    let n = adj.len
    let reachable = reachableWithout(adj, root, -1)
    var dominates = newSeqWith(n, newSeq[bool](n))
    for u in 0..<n:
        let without = reachableWithout(adj, root, u)
        for v in 0..<n:
            dominates[u][v] = reachable[v] and not without[v]
    result = newSeqWith(n, -1)
    result[root] = root
    for v in 0..<n:
        if not reachable[v] or v == root: continue
        for u in 0..<n:
            if u == v or not dominates[u][v]: continue
            var immediate = true
            for w in 0..<n:
                if w != v and w != u and dominates[w][v] and not dominates[w][u]:
                    immediate = false
            if immediate:
                doAssert result[v] == -1
                result[v] = u
        doAssert result[v] != -1

proc check(adj: seq[seq[int]], root: int, allTypes = false) =
    let expected = brute(adj, root)
    doAssert adj.dominator_tree(root) == expected
    if not allTypes: return
    var dynamicGraph = initUnWeightedDirectedGraph(adj.len)
    var staticGraph = initUnWeightedDirectedStaticGraph(adj.len)
    var weightedDynamic = initWeightedDirectedGraph(adj.len, int64)
    var weightedStatic = initWeightedDirectedStaticGraph(adj.len, float64)
    for v in 0..<adj.len:
        for u in adj[v]:
            dynamicGraph.add_edge(v, u)
            staticGraph.add_edge(v, u)
            weightedDynamic.add_edge(v, u, -123'i64)
            weightedStatic.add_edge(v, u, 0.5)
    staticGraph.build()
    weightedStatic.build()
    doAssert dynamicGraph.dominator_tree(root) == expected
    doAssert staticGraph.dominator_tree(root) == expected
    doAssert weightedDynamic.dominator_tree(root) == expected
    doAssert weightedStatic.dominator_tree(root) == expected
    doAssert dynamicGraph.dominator_tree(root) == expected

for adj in [
        newSeq[seq[int]](1),
        @[@[0, 0]],
        newSeq[seq[int]](3),
        @[@[1, 2], @[3], @[3], @[]],
        @[@[0, 1, 1], @[2], @[1, 3], @[3], @[1, 3, 5], @[4]],
        @[@[1, 2], @[3, 4], @[4], @[5], @[3, 5], @[1, 6], @[]]]:
    for root in 0..<adj.len:
        check(adj, root, true)

for n in 1..4:
    for mask in 0..<(1 shl (n * (n - 1))):
        var adj = newSeq[seq[int]](n)
        var bit = 0
        for v in 0..<n:
            for u in 0..<n:
                if v == u: continue
                if (mask and (1 shl bit)) != 0:
                    adj[v].add(u)
                inc bit
        for root in 0..<n:
            check(adj, root)

var rng = initRand(927461)
for trial in 0..<500:
    let n = rng.rand(1..12)
    var adj = newSeq[seq[int]](n)
    for i in 0..<rng.rand(0..n * n * 2):
        adj[rng.rand(n - 1)].add(rng.rand(n - 1))
    for root in 0..<n:
        check(adj, root, root == trial mod n)

block:
    const n = 200000
    var g = initUnWeightedDirectedStaticGraph(n)
    for v in 1..<n:
        g.add_edge(v, v - 1)
    g.add_edge(0, n - 2)
    g.build()
    let parent = g.dominator_tree(n - 1)
    doAssert parent[n - 1] == n - 1
    for v in 0..<n - 1:
        doAssert parent[v] == v + 1
    let fromZero = g.dominator_tree(0)
    doAssert fromZero[0] == 0
    doAssert fromZero[n - 1] == -1
    doAssert fromZero[n - 2] == 0
    for v in 1..<n - 2:
        doAssert fromZero[v] == v + 1

echo "Hello World"
