# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/collections/group_unionfind

var uf = initUnionFind(4)
uf.unite(0, 1)
uf.unite(1, 2)
assert uf.issame(0, 2)
assert uf.siz(1) == 3
assert uf.edge_count(0) == 2
assert uf.is_tree(0)
assert not uf.has_cycle(0)

uf.unite(2, 0)
assert uf.edge_count(1) == 3
assert uf.is_namori(2)
assert uf.has_cycle(2)

var group = uf.get_group(0)
group.sort()
assert group == @[0, 1, 2]

var groups = uf.groups().mapIt(sorted(it))
groups.sort(proc(a, b: seq[int]): int = cmp(a[0], b[0]))
assert groups == @[@[0, 1, 2], @[3]]

var cp = uf.copy()
assert cp.edge_count(0) == 3
cp.unite(2, 3)
assert cp.issame(0, 3)
assert not uf.issame(0, 3)
