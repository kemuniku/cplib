# verification-helper: PROBLEM https://atcoder.jp/contests/abc330/tasks/abc330_c
import math
import cplib/math/isqrt
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var D = ii()
var ans = D
for x in 0..(1 + isqrt(D - 1)):
    if (x^2-D) >= 0:
        ans = min(ans, x^2-D)
    else:
        var y1 = isqrt(D-x^2)
        var y2 = 1 + y1
        ans = min(ans, abs(x^2+y1^2-D))
        ans = min(ans, abs(x^2+y2^2-D))
echo ans
