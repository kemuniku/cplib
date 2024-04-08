# verification-helper: PROBLEM https://atcoder.jp/contests/abc332/tasks/abc332_e
{.checks: off.}
import cplib/utils/bititers
import sequtils, std/math
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N, D = ii()
var W = newSeqWith(N, float(ii()))
var avg = sum(W)/float(D)
var DP = newSeqWith(D+1, newSeqWith((1 shl N), 1e100))
DP[0][0] = 0
for d in 0..<D:
    for i in 0..<(1 shl N):
        for j in bitsuperset(i, N):
            var k = i xor j
            var tmp = 0.0
            for l in standingbits(k):
                tmp += W[l]
            DP[d+1][j] = min(DP[d+1][j], DP[d][i] + (tmp-avg)^2)
echo "+", DP[D][^1]/float(D)
