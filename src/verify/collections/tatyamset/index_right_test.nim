# verification-helper: PROBLEM https://atcoder.jp/contests/arc075/tasks/arc075_e
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import sequtils
import cplib/collections/tatyamset
var N,K =ii()
var a = newSeqWith(N,ii()-K)
var now = 0
var st = initSortedMultiset(@[0])
var ans = 0
for i in 0..<N:
    now += a[i]
    ans += st.index_right(now)
    st.incl(now)
echo ans