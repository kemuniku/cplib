# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_f
# verification-helper: ERROR 1e-6
include cplib/geometry/minimum_enclosing_circle_exact
import strformat
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc integer(): int = scanf("%lld", addr result)
let n = integer()
var inputPoints: seq[Point[int]]
for _ in 0..<n: inputPoints.add(initPoint(integer(), integer()))
let answer = minimum_enclosing_circle_exact(inputPoints)
echo &"{answer.radius_approx:.12f}"
