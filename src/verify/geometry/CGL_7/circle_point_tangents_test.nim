# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/CGL_7_F
# verification-helper: ERROR 1e-8
include cplib/geometry/circle
import algorithm, strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc number(): float = scanf("%lf", addr result)
proc integer(): int = scanf("%lld", addr result)
proc point(): Point[float] = initPoint(number(), number())
proc compare(a, b: Point[float]): int =
    if a.x != b.x: cmp(a.x, b.x)
    else: cmp(a.y, b.y)
proc output(points: seq[Point[float]]) =
    var sorted = points
    sorted.sort(compare)
    for i, p in sorted:
        if i > 0: stdout.write(" ")
        stdout.write(&"{p.x:.10f} {p.y:.10f}")
    stdout.write("\n")
let p = point()
let c = initCircle(point(), number())
var outputPoints: seq[Point[float]]
for t in tangent_lines(c, p).tangents: outputPoints.add(t.first)
outputPoints.sort(compare)
for p in outputPoints: echo &"{p.x:.10f} {p.y:.10f}"
