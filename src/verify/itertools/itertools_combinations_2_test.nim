# verification-helper: PROBLEM https://yukicoder.me/problems/no/2561
import math, sequtils
import cplib/itertools/combinations

proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,K = ii()
var A = newSeqWith(N,ii())
var ans = 0
for x in combinations(A,K):
    var S = sum(x)
    if S mod 998 >= S mod 998244353:
        ans += 1
echo ans mod 998