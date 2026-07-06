# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/geometry/base
import cplib/geometry/projection

let lf = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))
assert projection(lf, initPoint(1.0, 3.0)) == initPoint(1.0, 0.0)
assert reflection(lf, initPoint(1.0, 3.0)) == initPoint(1.0, -3.0)
