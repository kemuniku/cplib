# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/all/DPL_1_G
import cplib/utils/knapsack
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,W = ii()

var tmp : seq[(int,int,int)]
for _ in 0..<N:
    var v,w,m = ii()
    tmp.add((v,w,m))

echo solve_Boundedknapsack(tmp,W)