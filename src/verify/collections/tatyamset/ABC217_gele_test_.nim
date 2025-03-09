# verification-helper: PROBLEM https://atcoder.jp/contests/abc217/tasks/abc217_d
import cplib/collections/tatyamset
import options
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
var L, Q = ii()
var st = initSortedMultiset[int]()
st.incl(0)
st.incl(L)
for i in 0..<Q:
    var c, x = ii()
    if c == 1:
        st.incl(x)
    else:
        var l = st.le(x)
        var r = st.ge(x)
        echo r.get()-l.get()
