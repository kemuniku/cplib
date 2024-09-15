# verification-helper: PROBLEM https://judge.yosupo.jp/problem/predecessor_problem
import cplib/collections/wordsizetree
import sequtils
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int {.inline.} = scanf("%lld\n", addr result)
{.checks:off.}

var N,Q = ii()
var T = stdin.readline().mapit(it == '1')
var st = initWordsizeTree(T)
for i in 0..<Q:
    var c,k = ii()
    #echo "task;",c
    if c == 0:
        st.incl(k)
    elif c == 1:
        st.excl(k)
    elif c == 2:
        if st[k]:
            stdout.writeLine "1"
        else:
            stdout.writeLine "0"
    elif c == 3:
        stdout.writeLine st.ge(k)
    else:
        stdout.writeLine st.le(k)