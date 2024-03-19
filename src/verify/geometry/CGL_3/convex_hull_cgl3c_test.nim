# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_A
include cplib/geometry/polygon
import sequtils, strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var n = ii()
proc get(): Point[int] = initPoint(ii(), ii())
var v = newSeqWith(n, get())
var p = initPolygon(v)
var ans = convex_hull(p, false)
echo ans.len
var ps = (10001, 10001)
var s = 0
for i in 0..<ans.len:
    if ps > (ans.v[i].y, ans.v[i].x):
        s = i
        ps = (ans.v[i].y, ans.v[i].x)
for i in 0..<ans.len:
    var pi = ans.v[(i+s) mod ans.len]
    echo &"{pi.x} {pi.y}"
