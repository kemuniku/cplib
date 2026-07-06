# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import algorithm, sequtils
import cplib/utils/gridutils

let grid = @[@[1, 2, 3], @[4, 5, 2]]
assert grid.height == 2
assert grid.width == 3
assert grid.gridfind(2) == (0, 1)
assert grid.gridfind(9) == (-1, -1)
assert grid.gridfinds(2) == @[(0, 1), (1, 2)]
assert grid.getid(1, 2) == 5
assert grid.to_pos(4) == (1, 1)
assert toSeq(griditer(0, 0, 2, 3)).sorted == @[(0, 1), (1, 0)]
assert toSeq(griditer(0, 0, 2, 3, dij8)).sorted == @[(0, 1), (1, 0), (1, 1)]
