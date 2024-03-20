# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_2_A
include cplib/geometry/angle
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var q = ii()
for _ in 0..<q:
    proc get(): Point[float] = initPoint(float(ii()), float(ii()))
    var p1, p2, p3, p4 = get()
    var s1 = initLine(p1, p2)
    var s2 = initLine(p3, p4)

    if is_parallel(s1, s2): echo 2
    elif is_orthogonal(s1, s2): echo 1
    else: echo 0
