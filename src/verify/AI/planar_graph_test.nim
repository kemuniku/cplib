# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random
import cplib/graph/graph
import cplib/graph/planar_graph
import cplib/utils/random_helper

proc complete(n: int): UnWeightedUnDirectedGraph =
    result = initUnWeightedUnDirectedGraph(n)
    for u in 0..<n:
        for v in u+1..<n: result.add_edge(u, v)

assert initUnWeightedUnDirectedGraph(0).is_planar_graph()
assert initUnWeightedUnDirectedGraph(10).is_planar_graph()
assert complete(4).is_planar_graph()
assert not complete(5).is_planar_graph()
var k33 = initUnWeightedUnDirectedGraph(6)
for u in 0..<3:
    for v in 3..<6: k33.add_edge(u, v)
assert not k33.is_planar_graph()
for base in [complete(5), k33]:
    var subdivided = initUnWeightedUnDirectedGraph(base.len + base.edge_count + 5)
    for i, e in base.edge_info:
        subdivided.add_edge(e.src, base.len + i)
        subdivided.add_edge(base.len + i, e.dst)
    assert not subdivided.is_planar_graph()
    for removed in 0..<base.edge_count:
        var subgraph = initUnWeightedUnDirectedGraph(base.len)
        for i, e in base.edge_info:
            if i != removed: subgraph.add_edge(e.src, e.dst)
        assert subgraph.is_planar_graph()
var cube = initUnWeightedUnDirectedGraph(8)
for u in 0..<8:
    for bit in 0..<3:
        let v = u xor (1 shl bit)
        if u < v: cube.add_edge(u, v)
assert cube.is_planar_graph()
var octahedron = initUnWeightedUnDirectedGraph(6)
for u in 0..<6:
    for v in u+1..<6:
        if u div 2 != v div 2: octahedron.add_edge(u,v)
assert octahedron.is_planar_graph()
var petersen = initUnWeightedUnDirectedGraph(10)
for u in 0..<5:
    petersen.add_edge(u,(u+1) mod 5)
    petersen.add_edge(u,u+5)
    petersen.add_edge(u+5,(u+2) mod 5+5)
assert not petersen.is_planar_graph()
var disconnected = initUnWeightedUnDirectedGraph(20)
for e in cube.edge_info: disconnected.add_edge(e.src,e.dst)
for e in k33.edge_info: disconnected.add_edge(e.src+10,e.dst+10)
assert not disconnected.is_planar_graph()
var multi = complete(4)
for u in 0..<4:
    for v in 0..<4:
        multi.add_edge(u, v)
assert multi.is_planar_graph()
var weighted = initWeightedUnDirectedGraph(6, float)
var weightedStatic = initWeightedUnDirectedStaticGraph(6, float)
var unweightedStatic = initUnWeightedUnDirectedStaticGraph(6)
for e in k33.edge_info:
    weighted.add_edge(e.src, e.dst, 1.5)
    weightedStatic.add_edge(e.src, e.dst, 1.5)
    unweightedStatic.add_edge(e.src, e.dst)
assert not weighted.is_planar_graph()
assert not weightedStatic.is_planar_graph()
assert not unweightedStatic.is_planar_graph()
weightedStatic.build()
unweightedStatic.build()
assert not weightedStatic.is_planar_graph()
assert not unweightedStatic.is_planar_graph()
randomize(20260917)
for n in 0..35:
    let maximum = if n < 3: n*(n-1) div 2 else: 3*n-6
    for m in 0..maximum:
        let g = random_planar_graph(n, m)
        assert g.len == n and g.edge_count == m
        assert g.is_planar_graph()
        var seen = newSeq[bool](n*n)
        for e in g.edge_info:
            assert e.src != e.dst
            let index = min(e.src,e.dst)*n + max(e.src,e.dst)
            assert not seen[index]
            seen[index] = true
        var occurrences = newSeq[int](m)
        for u in 0..<n:
            for (v,id) in g.to_and_id(u):
                assert id in 0..<m
                let e = g.get_edge(id)
                assert (e.src == u and e.dst == v) or (e.src == v and e.dst == u)
                inc occurrences[id]
        for count in occurrences: assert count == 2
var generatedOctahedron = false
for seed in 0..<500:
    randomize(seed)
    let g = random_planar_graph(6,12)
    var regular = true
    for u in 0..<6:
        if g.edges[u].len != 4: regular = false
    if regular:
        generatedOctahedron = true
        break
assert generatedOctahedron
for (n,m) in [(-1,0),(0,1),(1,1),(2,2),(3,4),(5,10),(5,-1)]:
    var rejected = false
    try: discard random_planar_graph(n,m)
    except AssertionDefect: rejected = true
    assert rejected
var path = initUnWeightedUnDirectedGraph(100000)
for v in 1..<path.len: path.add_edge(v-1,v)
assert path.is_planar_graph()
path.add_edge(0,path.len-1)
assert path.is_planar_graph()
assert random_planar_graph(100,294).is_planar_graph()
echo "Hello World"
