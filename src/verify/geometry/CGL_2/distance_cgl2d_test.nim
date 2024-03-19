# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_D
include cplib/geometry/distance
import strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var q = ii()
proc get(): Point[float] = initPoint(float(ii()), float(ii()))
for _ in 0..<q:
    var s1, s2 = initSegment(get(), get())
    var ans = distance(s1, s2)
    echo &"{ans:.10f}"
