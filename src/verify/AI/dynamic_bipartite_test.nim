# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/dynamic_bipartite

let db = initDynamicBipartite(3)
assert db.is_bipartite
assert db.can_unite(0, 1)
db.unite(0, 1)
assert db.is_bipartite
assert db.cnt_sum == 2
db.unite(1, 2)
assert db.is_bipartite
assert db.cnt_sum == 2
assert not db.can_unite(0, 2)
db.unite(0, 2)
assert not db.is_bipartite
assert db.cnt_sum == -1
