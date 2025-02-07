# verification-helper: PROBLEM https://atcoder.jp/contests/abc380/tasks/abc380_e
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
import cplib/collections/avlset
import cplib/collections/rangeset

var N,Q = ii()
var st = initRangeSet[int](-1)
for i in 0..<(N):
    st.update(i,i+1,i)
var cnt = newseqwith(N,1)
for i in 0..<(Q):
    var t = ii()
    if t == 1:
        var x,c = ii()-1
        var (l,r,bef) = st.get_segment(x)
        cnt[bef] -= r-l
        cnt[c] += r-l
        st.update(l,r,c)
    else:
        var c = ii()-1
        stdout.writeLine cnt[c]