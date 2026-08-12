# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/offline_deletable_unionfind

var uf = initOfflineDeletableUnionFind(5)
uf.addEdge(0, 1)
uf.addEdge(1, 2)
let q0 = uf.addConnectivityQuery(0, 2)
let q1 = uf.addSizeQuery(1)
uf.deleteEdge(1, 2)
let q2 = uf.addConnectivityQuery(0, 2)
let q3 = uf.addCountQuery()
uf.addEdge(2, 1)
uf.addEdge(1, 2) # a parallel edge
uf.deleteEdge(1, 2)
let q4 = uf.addConnectivityQuery(0, 2)
uf.deleteEdge(2, 1)
let q5 = uf.addConnectivityQuery(0, 2)

let answers = uf.solve()
assert answers[q0].connected
assert answers[q1].value == 3
assert not answers[q2].connected
assert answers[q3].value == 4
assert answers[q4].connected
assert not answers[q5].connected
assert uf.len == 5

var empty = initOfflineDeletableUnionFind(0)
assert empty.solve().len == 0
