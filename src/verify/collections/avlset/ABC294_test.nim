# verification-helper: PROBLEM https://atcoder.jp/contests/abc294/tasks/abc294_d
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import sequtils
import cplib/collections/avlset
let N, Q = ii()
var st1 = initAvlSortedMultiset((1..N).toseq())
var st2 = initAvlSortedMultiset[int]()

for _ in 0..<Q:
    let T = ii()
    if T == 1:
        st2.incl(st1.pop(0))
    elif T == 2:
        st2.excl(ii())
    else:
        echo st2[0]
