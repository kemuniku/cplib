# verification-helper: PROBLEM https://judge.yosupo.jp/problem/ordered_set
import sequtils, options
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import cplib/collections/avlset
var N, Q = ii()
var A = newseqwith(N, ii())
var st = initAvlSortedSet[int](A)

for i in 0..<Q:
    var t, x = ii()
    if t == 0:
        st.incl(x)
    elif t == 1:
        st.excl(x)
    elif t == 2:
        if len(st) < x:
            echo -1
        else:
            echo st[x-1]
    elif t == 3:
        echo st.upperBound(x)
    elif t == 4:
        var tmp = st.le(x)
        if tmp.issome():
            echo tmp.get()
        else:
            echo -1
    else:
        var tmp = st.ge(x)
        if tmp.issome():
            echo tmp.get()
        else:
            echo -1
