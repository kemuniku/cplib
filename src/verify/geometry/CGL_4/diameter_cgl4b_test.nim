# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_B
include cplib/geometry/convex_polygon
import math, strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int = discard scanf("%lld", addr result)
let n = ii()
var vertices = newSeq[Point[int]](n)
for i in 0..<n: vertices[i] = initPoint(ii(),ii())
let answer = initConvexPolygon(vertices).diameter.get
echo &"{sqrt(float(answer.distance_sq)):.10f}"
