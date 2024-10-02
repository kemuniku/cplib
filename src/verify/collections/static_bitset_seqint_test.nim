# verification-helper: PROBLEM https://atcoder.jp/contests/abc258/tasks/abc258_g
import cplib/collections/staticbitset
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N = ii()
var A : seq[BitSet[3000]]
for i in 0..<(N):
    var S = stdin.readline()
    var tmp : seq[int]
    for j in 0..<(N):
        if S[j] == '1':
            tmp.add(j)
    A.add(tmp.initBitSet(3000))

var ans = 0
for i in 0..<(N-1):
    for j in (i+1)..<N:
        if A[i][j]:
            ans += (A[i]&A[j]).popcount()
echo (ans div 3)