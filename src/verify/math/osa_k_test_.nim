# verification-helper: PROBLEM https://atcoder.jp/contests/abc383/tasks/abc383_d
import cplib/math/osa_k
import algorithm
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

var t = initPrimeFactorTable(2*(1000000))
var ans : seq[int]
for i in countup(2,2*(1000000)):
    var tmp = t.primefactor_tuple(i) 
    if (len(tmp) == 1 and tmp[0][1] == 4) or (len(tmp) == 2 and tmp[0][1] == 1 and tmp[1][1] == 1):
        ans.add(i*i)
var N = ii()
echo ans.upperbound(N)