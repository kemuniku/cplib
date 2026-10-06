# verification-helper: PROBLEM https://atcoder.jp/contests/abc151/tasks/abc151_f
# verification-helper: ERROR 1e-6
include cplib/geometry/minimum_enclosing_circle
import strformat
import cplib/math/int128
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc integer(): int = scanf("%lld", addr result)
let n = integer()
var inputPoints: seq[Point[Int128]]
for _ in 0..<n: inputPoints.add(initPoint(to_Int128(integer()), to_Int128(integer())))
let answer = minimum_enclosing_circle(inputPoints)
echo &"{answer.radius_approx:.12f}"
