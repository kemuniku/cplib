# verification-helper: PROBLEM https://judge.yosupo.jp/problem/bipartitematching
import cplib/graph/hopcroft_karp
import sets
include cplib/tmpl/fastio

let left = ii()
let right = ii()
let m = ii()
var g = initHopcroftKarp(left, right)
var edges = initHashSet[tuple[left, right: int]]()
var incidentLeft = newSeq[bool](left)
var incidentRight = newSeq[bool](right)
for i in 0..<m:
    let a = ii()
    let b = ii()
    g.add_edge(a, b)
    edges.incl((a, b))
    incidentLeft[a] = true
    incidentRight[b] = true
let cover = g.get_minimum_vertex_cover()
let independent = g.get_maximum_independent_set()
let size = cover.left.len + cover.right.len
var inCoverLeft = newSeq[bool](left)
var inCoverRight = newSeq[bool](right)
var inIndependentLeft = newSeq[bool](left)
var inIndependentRight = newSeq[bool](right)
for v in cover.left:
    doAssert v in 0..<left and not inCoverLeft[v]
    inCoverLeft[v] = true
for v in cover.right:
    doAssert v in 0..<right and not inCoverRight[v]
    inCoverRight[v] = true
for v in independent.left:
    doAssert v in 0..<left and not inIndependentLeft[v]
    inIndependentLeft[v] = true
for v in independent.right:
    doAssert v in 0..<right and not inIndependentRight[v]
    inIndependentRight[v] = true
for v in 0..<left: doAssert inCoverLeft[v] != inIndependentLeft[v]
for v in 0..<right: doAssert inCoverRight[v] != inIndependentRight[v]
for (a, b) in edges:
    doAssert inCoverLeft[a] or inCoverRight[b]
    doAssert not (inIndependentLeft[a] and inIndependentRight[b])
let matchedEdges = g.get_matching()
doAssert matchedEdges.len == size
doAssert g.minimum_vertex_cover() == size
doAssert g.maximum_independent_set() == left + right - size
var usedLeft = newSeq[bool](left)
var usedRight = newSeq[bool](right)
for (a, b) in matchedEdges:
    doAssert (a, b) in edges and not usedLeft[a] and not usedRight[b]
    usedLeft[a] = true
    usedRight[b] = true
var isolated = false
for value in incidentLeft: isolated = isolated or not value
for value in incidentRight: isolated = isolated or not value
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
    doAssert edgeCover.len == left + right - size
    doAssert g.minimum_edge_cover() == edgeCover.len
    var coveredLeft = newSeq[bool](left)
    var coveredRight = newSeq[bool](right)
    var used = initHashSet[tuple[left, right: int]]()
    for (a, b) in edgeCover:
        doAssert (a, b) in edges and (a, b) notin used
        used.incl((a, b))
        coveredLeft[a] = true
        coveredRight[b] = true
    for value in coveredLeft: doAssert value
    for value in coveredRight: doAssert value
echo size
for (a, b) in matchedEdges:
    echo a, " ", b
