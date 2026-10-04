# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_B
# verification-helper: ERROR 1e-8
include cplib/geometry/minkowski_sum
import math, strformat, options
proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int = discard scanf("%lld", addr result)
proc ff(): float = discard scanf("%lf", addr result)
let n = ii()
var vertices = newSeq[Point[float]](n)
for i in 0..<n: vertices[i] = initPoint(ff(), ff())
let poly = initConvexPolygon(vertices)
let twice = minkowski_sum(poly, poly)
echo &"{sqrt(twice.diameter.get.distance_sq) / 2.0:.10f}"
