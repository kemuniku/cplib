# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/rootvalue_unionfind

proc merge(x, y: var int) =
  x += y

let uf0 = initRootValueUnionFind(3, merge, 1)
assert uf0.count == 3
assert uf0.siz(0) == 1
assert uf0.get(0) == 1
uf0.unite(0, 1)
assert uf0.issame(0, 1)
assert uf0.siz(1) == 2
assert uf0.get(0) == 2
uf0.set(1, 7)
assert uf0.get(0) == 7

proc defaultValue(): int = 2
let uf1 = initRootValueUnionFind(2, merge, defaultValue)
assert uf1.get(0) == 2
let uf2 = initRootValueUnionFind(2, merge, @[3, 4])
uf2.unite(0, 1)
assert uf2.get(0) == 7
