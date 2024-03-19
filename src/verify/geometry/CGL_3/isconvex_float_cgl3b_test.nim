# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_3_B
include cplib/geometry/polygon
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
proc get(): Point[float] = initPoint(float(ii()), float(ii()))
var v = newSeqWith(n, get())
var p = initPolygon(v)
echo int(is_convex_ccw(p, false))
