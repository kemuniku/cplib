# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/fenwick_tree

var fw = initFenwickTree(@[1, 2, 3, 4, 5])
assert fw.len == 5
assert fw.prefix(0) == 0
assert fw.prefix(5) == 15
assert fw.get(1, 4) == 9
assert fw[1..3] == 9
assert fw[2] == 3

fw.add(2, 7)
assert fw[2] == 10
assert fw.get(0, 5) == 22

fw[4] = -1
assert fw[4] == -1
assert fw.prefix(5) == 16

let empty = initFenwickTree[int](0)
assert empty.len == 0
assert empty.prefix(0) == 0
