# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_3_A
include cplib/geometry/polygon
import strformat, sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
proc get(): Point[Fraction[int]] = initPoint(initFraction(ii()), initFraction(ii()))
var v = newSeqWith(n, get())
var p = initPolygon(v)
echo &"{p.area.toFloat:.1f}"
