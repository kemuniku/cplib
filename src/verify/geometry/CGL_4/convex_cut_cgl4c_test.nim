# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_4_C
include cplib/geometry/convex_polygon
import strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int = discard scanf("%lld", addr result)
proc ff(): float = discard scanf("%lf", addr result)
proc point(): Point[float] = initPoint(ff(),ff())
let n = ii()
var vertices = newSeq[Point[float]](n)
for i in 0..<n: vertices[i] = point()
let poly = initConvexPolygon(vertices)
let q = ii()
for i in 0..<q:
    let s = point()
    let t = point()
    let clipped = convex_cut(poly,initLine(s,t))
    echo &"{abs(clipped.area):.10f}"
