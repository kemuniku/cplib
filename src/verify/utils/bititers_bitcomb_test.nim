# verification-helper: PROBLEM https://atcoder.jp/contests/arc161/tasks/arc161_b
import cplib/utils/bititers
import sequtils,algorithm
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

const arr = bitcomb(60,3).toseq().sorted()
var T = ii()
for i in 0..<T:
    var N = ii()
    var x = arr.upperBound(N)-1
    if x == -1:
        echo -1
    else:
        echo arr[x]