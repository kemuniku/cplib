# verification-helper: PROBLEM https://atcoder.jp/contests/abc258/tasks/abc258_g
import cplib/collections/bitset
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N = ii()
var A = newSeqWith(N,(stdin.readline.mapit(it == '1')).initBitSet())
var ans = 0
for i in 0..<(N-1):
    for j in (i+1)..<N:
        if A[i][j]:
            ans += andpopcount(A[i],A[j])
echo (ans div 3)