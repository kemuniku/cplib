# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/courses/library/7/DPL/all/DPL_1_B

import sequtils
import cplib/utils/knapsack
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var N,W = ii()

var tmp : seq[(int,int)]
for _ in 0..<N:
    var v,w = ii()
    tmp.add((v,w))

echo solve_01knapsack_NW(tmp,W)