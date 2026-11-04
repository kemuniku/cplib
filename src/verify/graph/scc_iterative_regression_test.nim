# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
import random, algorithm
import cplib/graph/graph
import cplib/graph/SCC

proc checkDirected(g: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph) =
    let groups = SCC(g)
    let (dag, mapping, grouped) = SCCG(g)
    doAssert groups == grouped
    var assigned = newSeq[bool](g.len)
    for id, group in groups:
        for v in group:
            doAssert not assigned[v]
            assigned[v] = true
            doAssert mapping[v] == id
    for v in 0..<g.len: doAssert assigned[v]
    var reach = newSeq[seq[bool]](g.len)
    for i in 0..<g.len:
        reach[i] = newSeq[bool](g.len)
        reach[i][i] = true
    var expected: seq[(int,int)]
    for e in g.edge_info:
        reach[e.src][e.dst] = true
        doAssert mapping[e.src] <= mapping[e.dst]
        if mapping[e.src] != mapping[e.dst]: expected.add((mapping[e.src],mapping[e.dst]))
    for k in 0..<g.len:
        for i in 0..<g.len:
            for j in 0..<g.len: reach[i][j] = reach[i][j] or (reach[i][k] and reach[k][j])
    for i in 0..<g.len:
        for j in 0..<g.len: doAssert (mapping[i]==mapping[j]) == (reach[i][j] and reach[j][i])
    var actual: seq[(int,int)]
    for e in dag.edge_info: actual.add((e.src,e.dst))
    expected.sort(); actual.sort()
    doAssert actual == expected

randomize(20261004)
for trial in 0..<200:
    let n = if trial == 0: 0 else: rand(12)
    var a = initUnWeightedDirectedGraph(n)
    var b = initUnWeightedDirectedStaticGraph(n)
    if n > 0:
        for _ in 0..<rand(n*n):
            let u = rand(n-1)
            let v = rand(n-1)
            a.add_edge(u,v)
            b.add_edge(u,v)
    b.build()
    checkDirected(a)
    checkDirected(b)

proc checkDeep(g: UnWeightedDirectedGraph or UnWeightedDirectedStaticGraph, cycle: bool) =
    let groups = SCC(g)
    if cycle:
        doAssert groups.len == 1 and groups[0].len == g.len
        var seen = newSeq[bool](g.len)
        for v in groups[0]:
            doAssert not seen[v]
            seen[v] = true
    else:
        doAssert groups.len == g.len
        for i, group in groups: doAssert group == @[i]

for cycle in [false, true]:
    let n = 200_000
    var a = initUnWeightedDirectedGraph(n)
    var b = initUnWeightedDirectedStaticGraph(n)
    for v in 1..<n:
        a.add_edge(v-1,v)
        b.add_edge(v-1,v)
    if cycle:
        a.add_edge(n-1,0)
        b.add_edge(n-1,0)
    b.build()
    checkDeep(a,cycle)
    checkDeep(b,cycle)
echo "Hello World"
