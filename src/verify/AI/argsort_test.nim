# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/geometry/argsort

var dirs = @[(0, -1), (1, 0), (0, 1), (-1, 0)]
argsort(dirs)
assert dirs == @[(1, 0), (0, 1), (-1, 0), (0, -1)]
assert argsorted(@[(0, 1), (1, 0), (-1, 0)]) == @[(1, 0), (0, 1), (-1, 0)]
assert argcmp((1, 0), (0, 1)) < 0
