# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/collections/rangeset

var rs = initRangeSet[int](0)
assert rs.get_segment(10) == (low(int), high(int), 0)
rs.update(2, 5, 1)
assert rs.get_segment(2) == (2, 5, 1)
assert rs.get_segment(4) == (2, 5, 1)
assert rs.get_segment(5)[2] == 0
rs.update(5, 7, 1)
assert rs.get_segment(6) == (2, 7, 1)
rs.update(3, 4, 2)
assert rs.get_segment(2) == (2, 3, 1)
assert rs.get_segment(3) == (3, 4, 2)
assert rs.get_segment(4) == (4, 7, 1)
rs.update(0, 10, 0)
assert rs.get_segment(3) == (low(int), high(int), 0)

var names = initRangeSet[string]("none")
names.update(1, 3, "hot")
assert names.get_segment(2) == (1, 3, "hot")
assert names.get_segment(3)[2] == "none"
