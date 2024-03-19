# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_1_C
include cplib/geometry/ccw
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

proc get(): Point[int] = initPoint(ii(), ii())
var p1 = get()
var p2 = get()
var s = initLine(p1, p2)
var q = ii()

for i in 0..<q:
    var p3 = get()
    var c = ccw(s, p3)
    if c == COUNTER_CLOCKWISE: echo "COUNTER_CLOCKWISE"
    elif c == CLOCKWISE: echo "CLOCKWISE"
    elif c == ONLINE_BACK: echo "ONLINE_BACK"
    elif c == ONLINE_FRONT: echo "ONLINE_FRONT"
    else: echo "ON_SEGMENT"
