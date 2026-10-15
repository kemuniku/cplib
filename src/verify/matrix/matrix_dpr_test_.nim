# verification-helper: PROBLEM https://atcoder.jp/contests/dp/tasks/dp_r
include cplib/matrix/matrix
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/modint/modint
type mint = modint1000000007_barrett

var n, k = ii()
var a = newSeqWith(n, newSeqWith(n, mint(ii()))).toMatrix
echo a.pow(k).sum
