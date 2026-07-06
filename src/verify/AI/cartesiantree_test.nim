# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/tree/cartesiantree

let t = cartesian_tree_tuple(@[3, 1, 4, 2])
assert t[1].p == -1
assert t[1].l == 0
assert t[1].r == 3
assert t[3].l == 2
assert t[0].p == 1
assert t[2].p == 3
