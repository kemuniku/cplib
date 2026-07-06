# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/geometry/base
import cplib/geometry/intersect

let s1 = initSegment(initPoint(0, 0), initPoint(4, 0))
let s2 = initSegment(initPoint(2, -1), initPoint(2, 1))
let s3 = initSegment(initPoint(5, 0), initPoint(6, 0))
let s4 = initSegment(initPoint(4, 0), initPoint(4, 2))
assert intersect(s1, s2)
assert not intersect(s1, s3)
assert intersect(s1, s4)
assert not intersect(s1, s4, true)

let l1 = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))
let l2 = initLine(initPoint(1.0, -1.0), initPoint(1.0, 1.0))
let l3 = initLine(initPoint(0.0, 1.0), initPoint(2.0, 1.0))
assert intersect(l1, l2)
assert not intersect(l1, l3)
assert cross_point(l1, l2) == initPoint(1.0, 0.0)
