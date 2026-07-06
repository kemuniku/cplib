# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm
import cplib/collections/unionfind

var uf = initUnionFind(5)
assert uf.count == 5
assert uf.root(0) == 0
uf.unite(0, 1)
uf.unite(3, 4)
assert uf.issame(0, 1)
assert not uf.issame(0, 2)
assert uf.siz(0) == 2
assert uf.count == 3

var roots = uf.roots()
roots.sort()
assert roots == @[0, 2, 3]

var cp = uf.copy()
cp.unite(1, 2)
assert cp.issame(0, 2)
assert not uf.issame(0, 2)
