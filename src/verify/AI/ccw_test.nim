# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/geometry/base
import cplib/geometry/ccw

let l = initLine(initPoint(0, 0), initPoint(4, 0))
assert ccw(l, initPoint(2, 1)) == COUNTER_CLOCKWISE
assert ccw(initPoint(0, 0), initPoint(4, 0), initPoint(0, 0), true) == ONLINE_BACK
assert online(l, initPoint(3, 0))
assert online(initPoint(0, 0), initPoint(4, 0), initPoint(2, 0))
