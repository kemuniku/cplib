# verification-helper: PROBLEM https://atcoder.jp/contests/abc234/tasks/abc234_d
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import sequtils,strutils
import cplib/collections/tatyamset
var N, K = ii()
var P = newseqwith(N,ii())
K -= 1
var s = initSortedMultiSet(P[0..<K])
var ans : seq[int]
for i in K..<N:
    s.incl(P[i])
    ans.add(s[-K-1])
echo ans.join("\n")