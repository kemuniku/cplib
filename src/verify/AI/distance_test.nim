# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import std/math
import cplib/geometry/base
import cplib/geometry/distance

let p = initPoint(0, 0)
let q = initPoint(3, 4)
assert norm(p, q) == 25
assert manhattan(q) == 7
assert manhattan(p, q) == 7

let pf = initPoint(0.0, 0.0)
let qf = initPoint(3.0, 4.0)
assert abs(distance(pf, qf) - 5.0) < 1e-12
let line = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))
assert norm(initPoint(1.0, 3.0), line) == 9.0
assert abs(distance(initPoint(1.0, 3.0), line) - 3.0) < 1e-12
let seg = initSegment(initPoint(0.0, 0.0), initPoint(2.0, 0.0))
assert norm(initPoint(3.0, 4.0), seg) == 17.0
assert abs(distance(initPoint(3.0, 4.0), seg) - sqrt(17.0)) < 1e-12
let seg2 = initSegment(initPoint(3.0, 0.0), initPoint(3.0, 4.0))
assert norm(seg, seg2) == 1.0
assert abs(distance(seg, seg2) - 1.0) < 1e-12
