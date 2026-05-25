# verification-helper: PROBLEM https://yukicoder.me/problems/no/2156
import cplib/matrix/static_matrix

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import atcoder/modint
type mint = modint998244353

var n = ii()
var a = [[mint(1), mint(1)], [mint(1), mint(0)]].toMatrix()
var ans = [[mint(1)], [mint(0)]].toMatrix()
ans = a.pow(n) * ans
echo ans[0, 0] - 1
