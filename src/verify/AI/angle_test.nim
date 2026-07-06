# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/geometry/angle
import cplib/geometry/base

let east = initPoint(1, 0)
let north = initPoint(0, 1)
let west = initPoint(-1, 0)
assert angle(east, east) == ANGLE_0
assert angle(east, north) == ANGLE_90
assert angle(east, west) == ANGLE_180
assert is_parallel(east, west)
assert is_orthogonal(east, north)
