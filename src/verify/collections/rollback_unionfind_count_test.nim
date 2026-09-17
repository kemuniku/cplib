# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import random, sets
import cplib/collections/rollback_unionfind

var uf = initRollbackUnionFind(5)
assert uf.count == 5
assert uf.unite(0, 1)
assert uf.count == 4
assert not uf.unite(1, 0)
assert uf.count == 4
uf.undo()
assert uf.count == 4
let state = uf.get_state
uf.snapshot()
assert uf.unite(2, 3)
assert uf.unite(4, 2)
assert uf.count == 2
assert not uf.unite(2, 2)
uf.rollback()
assert uf.count == 4
assert uf.get_state == state
uf.rollback(0)
assert uf.count == 5
assert uf.get_state == 0
assert initRollbackUnionFind(0).count == 0

var rng = initRand(3100)
for trial in 0..<500:
    if uf.get_state > 0 and rng.rand(0..3) == 0:
        uf.undo()
    else:
        discard uf.unite(rng.rand(0..4), rng.rand(0..4))
    var roots = initHashSet[int]()
    for v in 0..<5:
        roots.incl(uf.root(v))
    assert uf.count == roots.len
uf.rollback(0)
assert uf.count == 5
