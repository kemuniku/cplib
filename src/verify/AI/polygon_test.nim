# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/ITP1_1_A
echo "Hello World"

import sequtils
import cplib/geometry/base
import cplib/geometry/polygon
import cplib/math/fractions

let square = initPolygon(@[initPoint(0, 0), initPoint(2, 0), initPoint(2, 2), initPoint(0, 2)])
assert square.len == 4
assert square.toSeq == @[initPoint(0, 0), initPoint(2, 0), initPoint(2, 2), initPoint(0, 2)]
assert square.area == 8
assert square.is_convex
assert square.is_convex_ccw
assert square.on_edge(initPoint(1, 0))
assert square.contains(initPoint(1, 1))
assert square.contains(initPoint(1, 0))
assert not square.contains(initPoint(1, 0), true)
assert not square.contains(initPoint(3, 3))

let fpoly = initPolygon(@[
  initPoint(initFraction(0), initFraction(0)),
  initPoint(initFraction(1), initFraction(0)),
  initPoint(initFraction(0), initFraction(1)),
])
assert fpoly.area == initFraction(1, 2)

let hull = convex_hull(@[initPoint(0, 0), initPoint(1, 1), initPoint(0, 1), initPoint(1, 0)])
assert hull.len == 4
assert hull.area.abs == 2
