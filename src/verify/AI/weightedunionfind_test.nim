# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/weightedunionfind

var uf = initWeightedUnionFind(4, int)
assert uf.count == 4
assert uf.unite(0, 1, 3)
assert uf.unite(1, 2, 4)
assert uf.issame(0, 2)
assert uf.diff(0, 2) == 7
assert uf.diff(2, 0) == -7
assert uf.potential(2) - uf.potential(0) == 7
assert uf.siz(1) == 3
assert uf.count == 2
assert uf.unite(0, 2, 7)
assert not uf.unite(0, 2, 8)
