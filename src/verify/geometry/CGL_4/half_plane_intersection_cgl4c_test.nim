# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/4/CGL/1/CGL_4_C
# verification-helper: ERROR 1e-7
import cplib/geometry/base
import cplib/geometry/half_plane_intersection
import strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld", addr result)
proc ff(): float {.inline.} = scanf("%lf", addr result)
proc get(): Point[float] = Point[float](x: ff(), y: ff())

let n = ii()
var points = newSeq[Point[float]](n)
for p in points.mitems: p = get()
var constraints: seq[Line[float]]
for i in 0..<n:
    constraints.add(Line[float](s: points[i], t: points[(i+1) mod n]))
let q = ii()
for _ in 0..<q:
    let line = Line[float](s: get(), t: get())
    let region = half_plane_intersection(constraints & @[line])
    var area = 0.0
    for i in 0..<region.vertices.len:
        let a = region.vertices[i]
        let b = region.vertices[(i+1) mod region.vertices.len]
        area += a.x*b.y-a.y*b.x
    echo &"{area/2:.10f}"
