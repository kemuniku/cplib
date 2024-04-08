# verification-helper: PROBLEM https://atcoder.jp/contests/arc126/tasks/arc126_b
import sequtils, algorithm
import cplib/utils/lis
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var _, m = ii()
var ab = newSeqWith(m, (ii(), ii()))
var b = ab.sortedByIt((it[0], -it[1])).mapIt(it[1])
echo b.lis
