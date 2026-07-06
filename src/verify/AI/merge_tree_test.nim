# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/graph/merge_tree

var mt = initMergeTree(4, @[(0, 1), (2, 3), (1, 2)])
assert mt.get_id(0) == 0
mt.unite(0, 1)
assert mt.get_id(0) == 4
assert mt.get_id(1) == 4
assert mt.get_range(0).len == 2
mt.unite(2, 3)
assert mt.get_id(2) == 5
mt.unite(1, 2)
assert mt.get_id(0) == 6
assert mt.get_range(3).len == 4
let ordered = mt.make_seq(@["a", "b", "c", "d"])
assert mt.restore_seq(ordered) == @["a", "b", "c", "d"]
assert mt.index(0) in 0..<4
