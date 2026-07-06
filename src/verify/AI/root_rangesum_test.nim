# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/root_rangesum

var rs = initrangesum(@[1, 2, 3, 4, 5], 2, 0)
assert rs.len == 5
assert rs.get(0, 5) == 15
assert rs.get(1, 4) == 9
assert rs[2] == 3
assert rs[1..3] == 9
rs.update(2, 10)
assert rs.get(0, 5) == 22
rs[4] = 1
assert rs.get(3, 5) == 5
assert rs.max_right(0, proc(x: int): bool = x <= 13) == 3
assert rs.max_right(4, proc(x: int): bool = x <= 1) == 5
assert rs.min_left(5, proc(x: int): bool = x <= 5) == 3
assert rs.min_left(1, proc(x: int): bool = x <= 1) == 0
assert $rs == "@[1, 2, 10, 4, 1]"
