# verification-helper: PROBLEM https://judge.yosupo.jp/problem/ordered_set
import sequtils,algorithm,sugar
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)

import cplib/collections/segtree
var N,Q = ii()
var A = newseqwith(N,ii())
var querys : seq[(int,int)]
var C = A
for i in 0..<Q:
    var t,x = ii()
    querys.add((t,x))
    C.add(x)
C = C.sorted().deduplicate(true)

var tmp = newseqwith(len(C),0)

for i in 0..<(N):
    tmp[C.lowerbound(A[i])] = 1

var st = newsegwith(tmp,l+r,0)


for i in 0..<Q:
    var (t,x) = querys[i]
    if t == 0:
        st[C.lowerBound(x)] = 1
    elif t == 1:
        st[C.lowerBound(x)] = 0
    elif t == 2:
        if st.get_all() < x:
            stdout.writeLine -1
        else:
            stdout.writeLine C[st.max_right(0,(y:int) => (y<x))]
    elif t == 3:
        stdout.writeLine st[0..C.lowerBound(x)]
    elif t == 4:
        var tmp = st.min_left(C.lowerBound(x)+1,(y:int) => (y == 0))-1
        if tmp == -1:
            stdout.writeLine -1
        else:
            stdout.writeLine C[tmp]
    else:
        var tmp = st.max_right(C.lowerBound(x),(y:int) => (y == 0))
        if tmp == len(st):
            stdout.writeLine -1
        else:
            stdout.writeLine C[tmp]