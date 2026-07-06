# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/ppunionfind

var uf = initPartialPersistentUnionFind(4)
assert uf.root(0) == 0
assert uf.unite(0, 1, 2)
assert uf.unite(2, 3, 5)
assert uf.unite(1, 2, 8)
assert uf.issame(0, 1, 2)
assert not uf.issame(0, 2, 7)
assert uf.issame(0, 3, 8)
assert uf.size(0, 1) == 1
assert uf.size(0, 2) == 2
assert uf.size(3, 5) == 2
assert uf.size(3, 8) == 4
assert uf.when_unite(0, 3) == 8
assert uf.when_unite(0, 1) == 2
