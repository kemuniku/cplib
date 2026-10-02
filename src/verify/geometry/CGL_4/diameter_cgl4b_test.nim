# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_B
# verification-helper: ERROR 1e-8
include cplib/geometry/convex_polygon
import math, strformat
proc scanf(formatstr: cstring): cint {.header: "<stdio.h>", varargs.}
proc ii(): int = discard scanf("%lld", addr result)
let n = ii()
proc ff(): float = discard scanf("%lf", addr result)
var vertices = newSeq[Point[float]](n)
for i in 0..<n: vertices[i] = initPoint(ff(),ff())
let answer = initConvexPolygon(vertices).diameter.get
echo &"{sqrt(float(answer.distance_sq)):.10f}"
