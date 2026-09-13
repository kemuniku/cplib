# verification-helper: PROBLEM https://judge.yosupo.jp/problem/point_set_tree_path_composite_sum_fixed_root
import sequtils, strutils
import atcoder/modint
import cplib/graph/graph
import cplib/tree/heavylightdecomposition
import cplib/tree/static_top_tree
import cplib/tree/static_top_tree_dp

proc scanf(formatstr: cstring) {.header: "<stdio.h>", varargs.}
proc ii(): int = scanf("%lld", addr result)

type
    mint = modint998244353
    Point = tuple[count, sum: mint]
    Data = object
        mul, add, count, sum: mint

proc compress(l, r: Data): Data =
    Data(mul: l.mul * r.mul, add: l.mul * r.add + l.add,
        count: l.count + r.count, sum: l.sum + l.mul * r.sum + l.add * r.count)

proc rake(l, r: Point): Point =
    (l.count + r.count, l.sum + r.sum)

proc addEdge(t: Data): Point =
    (t.count, t.sum)

let n = ii()
let q = ii()
var a = newSeqWith(n, mint(ii()))
var g = initUnWeightedUnDirectedStaticGraph(n)
var edges = newSeq[(int, int)](n - 1)
var b, c = newSeq[mint](n - 1)
for e in 0..<n-1:
    let u = ii()
    let v = ii()
    edges[e] = (u, v)
    b[e] = mint(ii())
    c[e] = mint(ii())
    g.add_edge(u, v)
g.build()
let hld = initHld(g, 0)
let tree = initStaticTopTree(hld)
var edgeChild = newSeq[int](n - 1)
var mul = newSeqWith(n, mint(1))
var add = newSeq[mint](n)
for e, edge in edges:
    let (u, v) = edge
    let child = if hld.parentOf(u) == v: u else: v
    edgeChild[e] = child
    mul[child] = b[e]
    add[child] = c[e]

proc leaf(v: int): Data =
    Data(mul: mul[v], add: add[v], count: mint(1), sum: mul[v] * a[v] + add[v])

proc addVertex(t: Point, v: int): Data =
    result = leaf(v)
    result.count += t.count
    result.sum += mul[v] * t.sum + add[v] * t.count

let dp = initStaticTopTreeDP(tree, leaf, compress, addVertex, rake, addEdge)
var answers = newSeqOfCap[int](q)
for query in 0..<q:
    let kind = ii()
    var v: int
    if kind == 0:
        v = ii()
        a[v] = mint(ii())
    else:
        v = edgeChild[ii()]
        mul[v] = mint(ii())
        add[v] = mint(ii())
    dp.update(v)
    answers.add(dp.getAll().sum.val)
echo answers.join("\n")
