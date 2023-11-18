# verification-helper: PROBLEM https://atcoder.jp/contests/abc174/tasks/abc174_f
import std/sequtils
import std/algorithm
import std/strutils
import cplib/utils/mo
proc scanf(formatstr: cstring){.header: "<stdio.h>", varargs.}
proc ii(): int= scanf("%lld\n",addr result)

var
    N,Q = ii()
    c = newSeqWith(N,ii()-1)
    m = initMo(N,Q)

for i in 0..<Q:
    var l,r = ii()-1
    m.insert(l,r+1)

var
    ans = newSeqWith(Q,0)
    now = 0
    count = newSeqWith(N,0)

proc addq(id:int)=
    if count[c[id]] == 0:
        now += 1
    count[c[id]] += 1

proc delq(id:int)=
    if count[c[id]] == 1:
        now -= 1
    count[c[id]] -= 1

proc rem(id:int)=
    ans[id] = now

m.run(addq,addq,delq,delq,rem)

echo ans.join("\n")