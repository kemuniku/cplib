# verification-helper: PROBLEM https://judge.yosupo.jp/problem/directedmst
import cplib/graph/graph
import cplib/graph/directed_mst
import options
include cplib/tmpl/fastio
let n = ii()
let m = ii()
let root = ii()
var g = initWeightedDirectedStaticGraph(n, int64, capacity = m)
for id in 0..<m:
    let u = ii()
    let v = ii()
    let w = int64(ii())
    g.add_edge(u, v, w)
let tree = g.directedMST(root).get()
var parents = newSeq[int](n)
parents[root] = root
for v in 0..<n:
    if v != root: parents[v] = g.edge_info[tree.inEdge[v]].src
echo tree.cost
echo parents.join(" ")
