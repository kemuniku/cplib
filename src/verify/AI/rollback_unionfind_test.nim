# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/rollback_unionfind

var uf = initRollbackUnionFind(4)
assert uf.count == 4
assert uf.get_state == 0
assert uf.unite(0, 1)
assert uf.issame(0, 1)
assert uf.siz(0) == 2
let state1 = uf.get_state
uf.snapshot()
assert uf.unite(2, 3)
assert uf.count == 4
assert uf.issame(2, 3)
uf.rollback()
assert uf.get_state == state1
assert not uf.issame(2, 3)
uf.unite(1, 2)
assert uf.issame(0, 2)
uf.undo()
assert not uf.issame(0, 2)
uf.clear_snapshot()
