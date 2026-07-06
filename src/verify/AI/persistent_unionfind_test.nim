# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/persistent_unionfind

let uf0 = initPersistentUnionFind(4)
let uf1 = uf0.unite(0, 1)
let uf2 = uf1.unite(2, 3)
let uf3 = uf2.unite(1, 2)

assert uf0.count == 4
assert not uf0.issame(0, 1)
assert uf1.issame(0, 1)
assert not uf1.issame(0, 2)
assert uf2.siz(2) == 2
assert uf3.issame(0, 3)
assert uf3.siz(0) == 4
assert uf2.count == 2
assert uf3.count == 1
