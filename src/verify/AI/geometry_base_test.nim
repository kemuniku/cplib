# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import cplib/geometry/base

var p = initPoint(1, 2)
let q = initPoint((3, -1))
assert +p == p
assert -p == initPoint(-1, -2)
p += q
assert p == initPoint(4, 1)
p -= q
assert p == initPoint(1, 2)
assert p + q == initPoint(4, 1)
assert p - q == initPoint(-2, 3)
assert p * 3 == initPoint(3, 6)
assert 2 * p == initPoint(2, 4)
assert dot(p, q) == 1
assert cross(p, q) == -7
assert (p * q) == 1
assert (p @ q) == -7
assert norm(p) == 5
assert $p == "(1, 2)"
assert geometry_eq(1.0, 1.0 + 1e-12)
assert geometry_neq(1, 2)
assert geometry_ge(2, 1.5)
assert geometry_le(1, 1.5)
assert geometry_gt(2, 1)
assert geometry_lt(1, 2)
assert initPoint(1, 2) < initPoint(1, 3)
assert cmp(initPoint(1, 2), initPoint(1, 2)) == 0

let line = initLine(initPoint(0.0, 0.0), initPoint(2.0, 0.0))
assert line.vector == initPoint(2.0, 0.0)
assert $line == "((0.0, 0.0), (2.0, 0.0))"
let line2 = initLine(0.0, 1.0, -1.0)
assert line2.s == initPoint(0.0, 1.0)
let seg = initSegment(initPoint(0.0, 0.0), initPoint(0.0, 2.0))
assert seg.toLine.vector == initPoint(0.0, 2.0)
