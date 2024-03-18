# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_B
# verification-helper: ERROR 1e-8

include cplib/geometry/projection
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

proc get(): Point[float] = initPoint(float(ii()), float(ii()))
var l = initLine(get(), get())
var q = ii()
for _ in 0..<q:
    var p = get()
    var ans = reflection(l, p)
    echo &"{ans.x:.10f} {ans.y:.10f}"
