# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_3_C
include cplib/geometry/polygon
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
proc get(): Point[int] = initPoint(ii(), ii())
var v = newSeqWith(n, get())
var poly = initPolygon(v)

var q = ii()
for i in 0..<q:
    var p = get()
    if on_edge(poly, p): echo 1
    elif p in poly: echo 2
    else: echo 0
