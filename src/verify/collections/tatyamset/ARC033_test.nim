# verification-helper: PROBLEM https://atcoder.jp/contests/arc033/tasks/arc033_3
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/collections/tatyamset
var Q = ii()
var S = initSortedMultiset[int]()
for i in 0..<Q:
    var T,X = ii()
    if T == 1:
        S.incl(X)
    else:
        echo S.pop(X-1)