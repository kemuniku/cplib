# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching
import cplib/graph/hopcroft_karp
import cplib/graph/graph
import sets
include cplib/tmpl/fastio

let left = ii()
let right = ii()
let m = ii()
var g = initUnWeightedUnDirectedStaticGraph(left + right)
var edges = initHashSet[tuple[left, right: int]]()
var incident = newSeq[bool](left + right)
for i in 0..<m:
    let a = ii()
    let b = ii()
    g.add_edge(a, left + b)
    edges.incl((a, left + b))
    incident[a] = true
    incident[left + b] = true
g.build()
let cover = g.get_minimum_vertex_cover()
let independent = g.get_maximum_independent_set()
var inCover = newSeq[bool](g.len)
var inIndependent = newSeq[bool](g.len)
for v in cover:
    doAssert v in 0..<g.len and not inCover[v]
    inCover[v] = true
for v in independent:
    doAssert v in 0..<g.len and not inIndependent[v]
    inIndependent[v] = true
for v in 0..<g.len: doAssert inCover[v] != inIndependent[v]
for (a, b) in edges:
    doAssert inCover[a] or inCover[b]
    doAssert not (inIndependent[a] and inIndependent[b])
let matchedEdges = g.get_matching()
doAssert matchedEdges.len == cover.len
var used = newSeq[bool](g.len)
for edge in matchedEdges:
    let a = min(edge.left, edge.right)
    let b = max(edge.left, edge.right)
    doAssert (a, b) in edges and not used[a] and not used[b]
    used[a] = true
    used[b] = true
var isolated = false
for value in incident: isolated = isolated or not value
if isolated:
    doAssert g.minimum_edge_cover() == -1
    var rejected = false
    try:
        discard g.get_minimum_edge_cover()
    except ValueError:
        rejected = true
    doAssert rejected
else:
    let edgeCover = g.get_minimum_edge_cover()
    doAssert edgeCover.len == g.len - cover.len
    var covered = newSeq[bool](g.len)
    var usedEdges = initHashSet[tuple[left, right: int]]()
    for edge in edgeCover:
        let a = min(edge.left, edge.right)
        let b = max(edge.left, edge.right)
        doAssert (a, b) in edges and (a, b) notin usedEdges
        usedEdges.incl((a, b))
        covered[a] = true
        covered[b] = true
    for value in covered: doAssert value
echo cover.len
for edge in matchedEdges:
    echo min(edge.left, edge.right), " ", max(edge.left, edge.right) - left
