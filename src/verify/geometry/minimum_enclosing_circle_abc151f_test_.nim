# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_f
# verification-helper: ERROR 1e-6
include cplib/geometry/minimum_enclosing_circle
import strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc integer(): int = scanf("%lld", addr result)
let n = integer()
var points: seq[Point[int]]
for _ in 0..<n: points.add(initPoint(integer(), integer()))
let c = minimum_enclosing_circle(points).get
echo &"{c.radius:.12f}"
