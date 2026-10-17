# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_5_A
# verification-helper: ERROR 1e-6
import math, options, strformat, strutils
import cplib/geometry/base
import cplib/geometry/closest_pair
include cplib/tmpl/fastio

let n = ii()
var points = newSeq[Point[float64]](n)
for i in 0..<n:
    points[i] = initPoint(parseFloat(si()), parseFloat(si()))
echo &"{sqrt(closest_pair(points).get.distanceSquared):.10f}"
