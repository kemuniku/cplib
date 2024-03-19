# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_B
include cplib/geometry/intersect
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var q = ii()
for _ in 0..<q:
    proc get(): Point[int] = initPoint(ii(), ii())
    var s1, s2 = initSegment(get(), get())
    echo int(intersect(s1, s2))

