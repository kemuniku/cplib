# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import cplib/tree/centroid_decomposition
import cplib/graph/graph
import random, sequtils

proc check(g: UnWeightedUnDirectedGraph, cd: CentroidDecomposition) =
    let n = g.len
    doAssert cd.parent.len == n
    doAssert cd.depth.len == n
    doAssert cd.children.len == n
    if n == 0:
        doAssert cd.root == -1
        return
    doAssert cd.root in 0..<n
    doAssert cd.parent[cd.root] == -1
    doAssert cd.depth[cd.root] == 0
    var removed = newSeq[bool](n)
    var visited = newSeq[bool](n)

    proc checkComponent(c: int, vertices: seq[int]) =
        doAssert c in vertices
        doAssert not visited[c]
        visited[c] = true
        removed[c] = true
        var components: seq[seq[int]]
        var seen = newSeq[bool](n)
        for start in vertices:
            if removed[start] or seen[start]: continue
            var component = @[start]
            seen[start] = true
            var i = 0
            while i < component.len:
                let u = component[i]
                inc i
                for v in g[u]:
                    if not removed[v] and not seen[v]:
                        seen[v] = true
                        component.add(v)
            doAssert component.len <= vertices.len div 2
            components.add(component)
        doAssert cd.children[c].len == components.len
        for component in components:
            var child = -1
            for v in cd.children[c]:
                if v in component:
                    doAssert child == -1
                    child = v
            doAssert child != -1
            doAssert cd.parent[child] == c
            doAssert cd.depth[child] == cd.depth[c] + 1
            checkComponent(child, component)

    checkComponent(cd.root, toSeq(0..<n))
    for v in 0..<n: doAssert visited[v]

proc checkTree(treeData: tuple[tree: UnWeightedDirectedGraph, root: int, size, depth: seq[int]],
               cd: CentroidDecomposition) =
    let (tree, root, size, depth) = treeData
    doAssert root == cd.root
    doAssert tree.len == cd.parent.len
    doAssert size.len == tree.len
    doAssert depth == cd.depth
    if tree.len > 0:
        doAssert size[root] == tree.len
    for u in 0..<tree.len:
        doAssert toSeq(tree[u]) == cd.children[u]
        var subtreeSize = 1
        for v in tree[u]:
            subtreeSize += size[v]
        doAssert size[u] == subtreeSize

check(initUnWeightedUnDirectedGraph(0),
      initCentroidDecomposition(initUnWeightedUnDirectedGraph(0)))
checkTree(initCentroidDecompositionTree(initUnWeightedUnDirectedGraph(0)),
          initCentroidDecomposition(initUnWeightedUnDirectedGraph(0)))
var rng = initRand(20260908)
for n in 1..70:
    for trial in 0..<12:
        var g = initUnWeightedUnDirectedGraph(n)
        var staticG = initUnWeightedUnDirectedStaticGraph(n)
        var weighted = initWeightedUnDirectedGraph(n, float)
        var weightedStatic = initWeightedUnDirectedStaticGraph(n, int64)
        for v in 1..<n:
            let p = rng.rand(v - 1)
            g.add_edge(p, v)
            staticG.add_edge(p, v)
            weighted.add_edge(p, v, float(v - 35))
            weightedStatic.add_edge(p, v, int64(v))
        staticG.build()
        weightedStatic.build()
        let root = rng.rand(n - 1)
        let before = g.edges
        let cd = initCentroidDecomposition(g, root)
        check(g, cd)
        checkTree(initCentroidDecompositionTree(g, root), cd)
        doAssert g.edges == before
        check(g, initCentroidDecomposition(g))
        checkTree(initCentroidDecompositionTree(g),
                  initCentroidDecomposition(g))
        for treeData in [initCentroidDecompositionTree(staticG, root),
                         initCentroidDecompositionTree(weighted, root),
                         initCentroidDecompositionTree(weightedStatic, root)]:
            checkTree(treeData, cd)
        for other in [initCentroidDecomposition(staticG, root),
                      initCentroidDecomposition(weighted, root),
                      initCentroidDecomposition(weightedStatic, root)]:
            check(g, other)
            doAssert other.root == cd.root
            doAssert other.parent == cd.parent
            doAssert other.depth == cd.depth
            doAssert other.children == cd.children

block:
    const n = 200000
    var path = initUnWeightedUnDirectedGraph(n)
    var star = initUnWeightedUnDirectedGraph(n)
    for v in 1..<n:
        path.add_edge(v - 1, v)
        star.add_edge(0, v)
    let pathCd = initCentroidDecomposition(path)
    doAssert pathCd.root in [n div 2 - 1, n div 2]
    var maxDepth = 0
    for v in 0..<n:
        maxDepth = max(maxDepth, pathCd.depth[v])
        if v != pathCd.root:
            doAssert pathCd.depth[pathCd.parent[v]] + 1 == pathCd.depth[v]
    doAssert maxDepth <= 17
    checkTree(initCentroidDecompositionTree(path), pathCd)
    let starCd = initCentroidDecomposition(star, n - 1)
    checkTree(initCentroidDecompositionTree(star, n - 1), starCd)
    doAssert starCd.root == 0
    doAssert starCd.children[0].len == n - 1
    for v in 1..<n:
        doAssert starCd.parent[v] == 0
        doAssert starCd.depth[v] == 1
        doAssert starCd.children[v].len == 0

echo "Hello World"
