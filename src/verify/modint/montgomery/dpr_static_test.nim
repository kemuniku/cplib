# verification-helper: PROBLEM https://atcoder.jp/contests/dp/tasks/dp_r
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import sequtils
import cplib/modint/modint
import cplib/matrix/matrix
type mint = mint1000000007_montgomery

var n, k = ii()
var a = newSeqWith(n, newSeqWith(n, mint(ii()))).toMatrix
echo a.pow(k).sum
