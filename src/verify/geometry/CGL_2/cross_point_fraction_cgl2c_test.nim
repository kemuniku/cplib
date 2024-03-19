# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_B
# verification-helper: ERROR 1e-8
include cplib/geometry/intersect
import cplib/math/fractions
import strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var q = ii()
proc get(): Point[Fraction[int]] = initPoint(initFraction(ii()), initFraction(ii()))
for _ in 0..<q:
    var l1, l2 = initLine(get(), get())
    var p = cross_point(l1, l2)
    echo &"{p.x.toFloat:.10f} {p.y.toFloat:.10f}"
